**Data Description**  
Primary BMI file (tab-delimited) with rows per measurement:
- person_id, encounter_id, bmi (reported), height_cm, weight_kg, measurement_date (ISO)

Demographics file:
- person_id, date_of_birth, sex_gender, race_clean, ethnicity_clean, race_ethnicity, race_ethnicity_harmonized, and other context fields

Additional derived variables required:
- agedays: age in days at each measurement (measurement_date − date_of_birth)
- bmi_calc: recomputed BMI from cleaned height/weight
- biological_sex: derived from sex assigned at birth when available; keep gender_identity separate for reporting (needed for pediatric algorithms) [1, 3]

*Note: Raw EHR measurements may include multiple rows per person and inconsistent units; all such issues are addressed in the cleaning steps below.*

---

**Task to Be Accomplished**

1. **Data Ingestion**  
    - **BMI Data**:
       - Read the BMI file with the correct delimiter and types; parse dates in ISO format.  
       - After cleaning units (below), compute bmi_calc = weight_kg / (height_cm/100)^2 and retain the original bmi (as bmi_reported).
    - **Demographic Data**:
       - Load demographics; ensure proper parsing of person_id, sex_gender, date_of_birth, race/ethnicity fields.  
       - Join to measurements by person_id and compute agedays per measurement (integer); required for growthcleanr [1, 3].  
       - Derive biological_sex from sex assigned at birth when available; keep gender_identity separate for reporting.

2. **Data Cleaning and Filtering**  
    - **General Cleaning**:  
       - Dates: drop/flag rows where measurement_date < date_of_birth (agedays < 0).  
       - Unit Quality Control and Conversion:  
          - Height unit detection and conversion (inch-to-cm when values cluster in 50–90 range or person-level medians suggest inches).  
          - Weight unit detection and conversion (lb-to-kg when values cluster in 90–250 with implausible BMI).  
          - Trajectory-based unit inference for mixed/site-specific usage [8].  
          - Height–weight swap test when height_cm > 300 and weight_kg < 3, or BMI outside 8–80; correct if plausible.  
          - Persist flags: flag_unit_inferred, flag_swap_corrected, flag_global_range_violation.  
          - Global plausibility ranges after conversion: pediatrics 45–220 cm, adults 120–230 cm; pediatrics 2–250 kg, adults 25–350 kg [9].
       - BMI vs computed BMI consistency:  
          - Pair same-day height/weight when available.  
          - Adults: if no same-day height, use nearest within 365 days, favoring robust median height from prior 5 years; record height_pairing_days.  
          - Pediatrics: require same-day height.  
          - Flag discrepancy if |bmi_reported − bmi_calc| > 0.5 kg/m² or relative difference >3%; use bmi_calc for analysis; log counts.
    - **Outlier Detection**:  
       - Pediatrics (2–19): run growthcleanr with agedays, biological_sex, cm/kg units; set adult_cutpoint = 20; exclude rows the tool marks for exclusion [1–3, 11].  
       - Adults (20+): run the growthcleanr adult algorithm to identify carried-forward values, duplicates, digit errors, and implausible longitudinal points; exclude rows the tool marks for exclusion [2, 12].  
       - Adult-specific checks: global ranges (height 120–230 cm; weight 25–350 kg; BMI 10–80), height stability (>3 cm deviation from robust median unless clinically justified), and weight rate-of-change flags (>7 kg/1 day or >20%/7 days outside hospitalization).  
       - Produce sensitivity analyses with looser/stricter thresholds.

3. **Representative Record Selection**  
    - Define an index date per protocol; select a baseline anthropometric record:  
       - Eligible encounter types: outpatient/ambulatory/primary care only. Exclude ED, observation, inpatient, peri-operative pre-admission testing, and dialysis for baseline selection [13, 10].  
       - Time window: choose the closest eligible encounter within −365 to +30 days of the index; prefer pre-index if both sides exist. If none, extend to −730 to 0 days and set baseline_window_extended = TRUE.  
       - Multiple candidates: prefer same-day height, else smallest height_pairing_days; remaining ties choose the median BMI within the window.  
       - Contextual exclusions: pregnancy windows (conception to 6 months postpartum when available); inpatient admission windows; visits with explicit edema or active fluid-titration documentation. Log reasons [10].

4. **Categorization of BMI, Height, and Weight**  
    - **BMI Categorization (Adults, 20+)**: CDC adult BMI categories: <18.5, 18.5–<25, 25–<30, 30–<35, 35–<40, ≥40 kg/m² [7].  
       - Asian-specific action points: for individuals whose race_ethnicity_harmonized maps to Asian, also assign WHO action-point bands at 23.0, 27.5, 32.5, 37.5 while retaining CDC categories for crosswalks. For other groups, keep CDC categories as primary; consider lower thresholds for Pacific Islander groups only in sensitivity analyses [5, 6].  
    - **BMI Categorization (Pediatrics, 2–19)**: compute BMI-for-age percentile by sex and age; CDC categories: underweight <5th; healthy weight 5th–<85th; overweight 85th–<95th; obesity ≥95th; severe obesity ≥120% of the 95th percentile [4].  
    - **Height Categorization**: use pragmatic bins for descriptive summaries only.  
    - **Weight Categorization**: use pragmatic bins for descriptive summaries only.

---

**Expected Output**

1. **Cleaned Dataset**  
    - TSV with one baseline row per person including person_id, encounter_id, measurement_date, height_cm, weight_kg, bmi_calc, bmi_reported, height_pairing_days, agedays, biological_sex, race/ethnicity fields, baseline-window flags, encounter type, context flags, and all cleaning flags.  
    - Adult CDC BMI category and (if Asian) WHO action-point category; pediatric BMI-for-age category where applicable.

2. **Summary Report**  
    - Counts for each exclusion type and reason; distribution of measurements per person before/after cleaning.  
    - Adult distributions across CDC and Asian action-point categories; pediatric distributions across BMI-for-age categories.  
    - Sensitivity analyses comparing baseline windows and outlier thresholds.

3. **Data Dictionary**  
    - Definitions for every variable and flag, including pairing logic, unit inference, and baseline selection fields.

4. **Additional Considerations**  
    - Reproducible rules (concise reference):  
       - Units: deterministic rules plus trajectory-based inference; conversions logged [8, 9].  
       - Global plausibility: adults height 120–230 cm, weight 25–350 kg; pediatrics height 45–220 cm, weight 2–250 kg; BMI 10–80.  
       - Adult height stability: drop deviations >3 cm from person’s robust median without clinical justification.  
       - Weight change flags: >7 kg in 1 day or >20% in 7 days outside hospitalization.  
       - BMI discrepancy: absolute >0.5 kg/m² or relative >3% after correct height pairing; use bmi_calc for analysis.  
       - Baseline window: primary −365 to +30 days; prefer pre-index; outpatient settings only; extend to −730 days if needed.  
       - Contextual exclusions: pregnancy windows; inpatient/ED; peri-op; dialysis; fluid-management contexts [10].  
    - Package/version note: growthcleanr v2.2.0+; record versions used and keep all algorithm flags for audit [1–3].

---

## References
1. growthcleanr: Data Cleaner for Anthropometric Measurements (CRAN manual). https://cran.r-project.org/web/packages/growthcleanr/growthcleanr.pdf
2. Adult algorithm • growthcleanr (pkgdown vignette). https://carriedaymont.github.io/growthcleanr/articles/adult-algorithm.html
3. cleangrowth: Clean growth measurements in growthcleanr (function docs). https://rdrr.io/cran/growthcleanr/man/cleangrowth.html
4. CDC. Child and Teen BMI Categories and Calculator. https://www.cdc.gov/bmi/child-teen-calculator/bmi-categories.html
5. WHO Expert Consultation. Appropriate body-mass index for Asian populations. PubMed: https://pubmed.ncbi.nlm.nih.gov/14726171/
6. Diagnosis of Obesity: 2022 Update of Clinical Practice Guidelines for Obesity (Korean Society). PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC10327686/
7. CDC. Adult BMI Categories. https://www.cdc.gov/bmi/adult-calculator/bmi-categories.html
8. Inference-based correction of multi-site height and weight (EHR unit errors). PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC8922164/
9. Completeness and accuracy of anthropometric measurements in EHRs. BMJ HCI: https://informatics.bmj.com/content/bmjhci/25/1/19.full.pdf
10. Fluid balance versus weighing: A comparison in ICU patients. PMC: https://pmc.ncbi.nlm.nih.gov/articles/PMC11051658/
11. growthcleanr configuration (vignette). https://rdrr.io/github/carriedaymont/growthcleanr/f/vignettes/configuration.Rmd
12. Cleaning of anthropometric data from PCORnet EHRs. PubMed: https://pubmed.ncbi.nlm.nih.gov/36339053/
