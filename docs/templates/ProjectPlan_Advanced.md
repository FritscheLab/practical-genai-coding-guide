**Data Description**  
The primary source file contains rows of BMI-related information (tab-delimited) with the following fields:
- **person_id**: A unique identifier for each person  
- **encounter_id**: An identifier for each clinical encounter  
- **bmi**: The numerical BMI value  
- **height_cm**: Height in centimeters  
- **weight_kg**: Weight in kilograms  
- **measurement_date**: Date of the BMI measurement

*Note: This raw EHR data was not originally collected for research purposes and may contain multiple rows per person.*

In addition, a separate demographics file is available that provides key background information:
- **person_id**: De-identified Patient Identifier  
- **date_of_birth**: Date of Birth (YYYY-MM-DD)  
- **age**: Age in years (with invalid values set to NA)  
- **age_bin**: Age category (e.g., <18, 18-34, etc.)  
- **deceased**: Indicator if the person is deceased  
- **race_clean**: Race (with NA for 'Patient Refused', 'Unknown', or blank)  
- **ethnicity_clean**: Ethnicity (with NA for 'Patient Refused', 'Unknown', or blank)  
- **race_ethnicity**: Combined Race and Ethnicity  
- **race_ethnicity_harmonized**: Harmonized classification (e.g., Non-Hispanic White, Non-Hispanic Black, Non-Hispanic Asian/Pacific Islander/Native American, Other)  
- **sex_gender**: Consolidated Sex/Gender (using sex assigned at birth if available)  
- **marital_status_name**: Marital Status  
- **zip3**: Three-digit ZIP code

For processing the height and weight data, the R package **`growthcleanr`** will be used. This requires calculating an additional variable, **`agedays`**, based on the individual’s date of birth.

---

**Task to Be Accomplished**

1. **Data Ingestion**  
   - **BMI Data**:  
     - Read the BMI file using the appropriate delimiter (e.g., tab).  
     - Convert columns to appropriate data types, especially the measurement dates.  
   - **Demographic Data**:  
     - Load the demographics file ensuring proper parsing of key fields such as `person_id`, `sex_gender`, `date_of_birth`, and `race_clean`.  
     - Compute `agedays` (age in days) for each individual to support processing with `growthcleanr`.

2. **Data Cleaning and Filtering**  
   - **General Cleaning**:  
     - Flag rows with missing or implausible values in height or weight.  
     - Identify and flag rows where the reported BMI greatly differs from the BMI calculated using height and weight.  
     - Output flagged entries to a separate file and continue processing only valid rows.
   - **Outlier Detection**:  
     - For each person, identify extreme outlier measurements.  
     - Write these outlier records to a separate file and retain the remaining valid records.

3. **Representative Record Selection**  
   - For each individual, from the valid records, determine a “typical” measurement:
     - Flag any extreme outlier measurements and exclude them.
     - Select the row with the median BMI value.  
     - If multiple valid measurements exist, choose the one closest to the median BMI.
     - If no valid measurements remain for a person, flag that individual and record them separately.

4. **Categorization of BMI, Height, and Weight**  
   - **BMI Categorization**:  
     - **General**:  
          - Underweight: BMI < 18.5 kg/m² 
          - Normal: 18.5 ≤ BMI < 25 kg/m² 
          - Overweight: 25 ≤ BMI < 30 kg/m² 
          - Obesity I: 30 ≤ BMI < 35 kg/m² 
          - Obesity II: 35 ≤ BMI < 40 kg/m² 
          - Obesity III: BMI ≥ 40 kg/m² 
     - **Race-Specific**:  
       For individuals identified (using `race_clean`) as Black, Asian, Native American, or Pacific Islander:  
          - Underweight: BMI < 18.5 kg/m² 
          - Normal: 18.5 ≤ BMI < 23 kg/m² 
          - Overweight: BMI >= 23 AND < 27.5 kg/m²  
          - Obesity: BMI >= 27.5 kg/m²  
          - Obesity I: 27.5 ≤ BMI < 32.5 kg/m²
          - Obesity II: 32.5 ≤ BMI < 37.5 kg/m²
          - Obesity III: BMI ≥ 37.5 kg/m²
   - **Height Categorization**:  
     - Short: height < 150 cm  
     - Average: 150 cm ≤ height < 180 cm  
     - Tall: height ≥ 180 cm  
   - **Weight Categorization**:  
     - Light: weight < 50 kg  
     - Medium: 50 kg ≤ weight < 80 kg  
     - Heavy: 80 kg ≤ weight < 100 kg  
     - Very Heavy: weight ≥ 100 kg

---

**Expected Output**

1. **Cleaned Dataset**  
   - A TSV file containing one representative row per person, which includes:  
     - The “typical” BMI measurement along with its corresponding height, weight, and measurement date.  
     - Demographic information (including `date_of_birth`, `sex_gender`, computed `agedays`, and `race_clean`).  
     - Categorical variables for BMI (both general and race-specific), height, and weight.

2. **Summary Report**  
   - A detailed summary (in text or Markdown) that documents:  
     - The number of rows removed due to missing or implausible values.  
     - The number of rows flagged and removed because of large discrepancies between reported and computed BMI.  
     - The number of extreme outlier measurements removed.  
     - The count of individuals with only invalid measurements versus those with valid measurements.  
     - Descriptive statistics on the number of BMI measurements per person (e.g., mean, median, standard deviation).  
   - A `tableone`-based table with the "typical" BMI, height, and weight for each individual with:
     - Overall and stratified by `sex_gender`
     - Breakdown of individuals across BMI categories (both general and race-specific) as well as height and weight categories.
     - A summary of the distribution of BMI, height, and weight categories.

3. **Data Dictionary**  
   - A separate document detailing each column along with a brief description (e.g., `person_id`: a unique identifier for each person, `date_of_birth`: the patient’s birth date, etc.).

4. **Additional Considerations**  
   - Utilize the R package **`growthcleanr`** for processing height and weight, leveraging the computed `agedays` variable from the demographic data.  
   - Incorporate race-specific BMI categorizations to better capture cardiometabolic risk profiles in populations prone to central adiposity at lower BMI thresholds.
