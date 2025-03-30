# Chapter 2: Knowledge is Power — Do Your Research

With a solid plan and a clear understanding of the context established, the next crucial step in our 8-step process is to arm ourselves with the necessary knowledge. Before we even think about prompting an LLM to generate code, we need to **gather foundational knowledge** relevant to each of the sub-tasks we identified in the planning phase [6](../docs/References.md#ref6). This involves researching the methods, libraries, or tools that are commonly used to accomplish these tasks within our respective domains. For instance, in our BMI harmonization example, this would mean investigating appropriate R packages for data cleaning and manipulation, such as `dplyr` or `data.table`, as well as looking into established medical guidelines and definitions for BMI categories [6](../docs/References.md#ref6). This domain-specific knowledge will be invaluable in guiding the LLM later on and in evaluating the quality and appropriateness of its suggestions.

Furthermore, it is important to take this time to **clarify uncertainties** that might exist regarding the task at hand [8](../docs/References.md#ref8). Before we ask an LLM for code, we should strive to resolve any ambiguities or domain-specific questions we might have. In our BMI example, this could involve determining what range of BMI values would be considered implausible and should be filtered out, or deciding on the most appropriate method for selecting a single representative BMI measurement for each person if multiple measurements exist in the EHR data. Addressing these uncertainties upfront will lead to more focused and effective prompts when we eventually interact with the LLM.

## Considering Edge Cases in Category Definitions

It is also crucial to recognize that **human-friendly definitions** for categories (like “Obesity class 2: **35 kg/m<sup>2</sup> to 39.9 kg/m<sup>2</sup>**”) may not translate neatly into code. Official guidelines often list the upper limit as a single decimal like **39.9**. But from a coding perspective, you might represent that boundary as **< 40.0** or **≤ 39.9**, each of which can alter how borderline values are classified.

For example, a real-valued BMI of **39.95** is **less than 40**—which might suggest it belongs in the 35–39.9 bin from a human perspective—but it is also **greater than 39.9** if you compare it literally. Depending on how your code or LLM-generated logic interprets the boundary, you could misclassify or not classify this measurement at all:

- **Rounding vs. Exact Floats:** If you floor BMI to one decimal place, `39.95` becomes `40.0`, thus pushing it out of the 35–39.9 category (contrary to the guideline’s intended 39.9 upper limit).  
- **Choosing `<` vs. `<=`:** If your logic says `bmi <= 39.9` for Obesity class 2, then 39.95 is excluded. But if you code it as `bmi < 40`, 39.95 is included.  
- **Guideline vs. Code Reality:** Guidelines often say “39.9” to highlight that 40.0+ is a higher risk category (Obesity class 3). In code, you may prefer `< 40` for clarity and to avoid floating-point confusion.

### Suggestions for Handling These Subtleties

1. **Be Explicit About Boundaries:** Decide whether to interpret a textual cutoff like “39.9” as `<= 39.9` or `< 40.0`. Document this thoroughly so that future analysts understand the rationale.  
2. **Consider Rounding:** If your data is recorded at multiple decimals (e.g., 39.95) but guidelines show a single decimal, clarify how (or if) you round before classification.  
3. **Align Code With Human Logic:** For most clinical or epidemiological scenarios, using `< 40` (rather than `<= 39.9`) better reflects the guideline’s intention without risking floating-point mismatch. Still, you should confirm that this tiny difference does not conflict with domain expectations.

Such attention to detail prevents **unresolvable edge cases** in which the code’s binning disagrees with the intended clinical guideline, leading to misclassification and confusion. Always keep in mind that **guidelines are written for humans**, while your code needs precise comparisons for borderline values. This ensures both clinicians and data scientists understand how an exact BMI of 39.95 is ultimately categorized.

## Incorporating Authoritative Guidelines

During the research phase, we may uncover important clinical practice guidelines that further inform how we categorize and interpret BMI data:

1. **European Association for the Study of Obesity (EASO)** – The EASO offers position statements and guidelines discussing the use of BMI and related anthropometric measures in both clinical and epidemiological settings. This information can help frame how BMI (as well as height and weight) should be interpreted in population studies. It also provides insight into **epidemiological nuances behind BMI thresholds**, including considerations tailored to different demographic groups.

2. **NICE Guideline on Overweight and Obesity Management** (Reference number: NG246, Published: 14 January 2025) – This guideline provides a detailed classification of overweight and obesity in adults, including:
   - **Healthy weight:** BMI 18.5 kg/m<sup>2</sup> to 24.9 kg/m<sup>2</sup>  
   - **Overweight:** BMI 25 kg/m<sup>2</sup> to 29.9 kg/m<sup>2</sup>  
   - **Obesity class 1:** BMI 30 kg/m<sup>2</sup> to 34.9 kg/m<sup>2</sup>  
   - **Obesity class 2:** BMI 35 kg/m<sup>2</sup> to 39.9 kg/m<sup>2</sup>  
   - **Obesity class 3:** BMI 40 kg/m<sup>2</sup> or more  

   Crucially, it underscores that people of **South Asian, Chinese, Middle Eastern, Black African, or African–Caribbean** backgrounds are prone to central adiposity and may present higher cardiometabolic risk at **lower BMI thresholds**:
   - **Overweight:** BMI 23 kg/m<sup>2</sup> to 27.4 kg/m<sup>2</sup>  
   - **Obesity:** BMI 27.5 kg/m<sup>2</sup> or above  

   Classes 2 and 3 of obesity in these populations can be identified by subtracting 2.5 kg/m<sup>2</sup> from the mainstream thresholds. These racial- and ethnicity-specific cutoffs are highly relevant when harmonizing multi-ethnic EHR data.  

Integrating such guidelines into our workflow ensures **proper categorization** of BMI across diverse populations, enhancing both the clinical relevance of our analysis and the robustness of any downstream results.

## Leveraging Tools for Data Cleaning and Validation

In addition to reviewing guidelines, we should seek out robust packages or software that can streamline data cleaning. One such tool is:

**`growthcleanr`** – An R package focused on cleaning anthropometric measurements (height, weight, and derived BMI) from EHR systems. It implements a series of algorithms to flag implausible values without deleting them outright. While its original emphasis was on pediatric growth curves, it has been expanded to handle adult measurements up to age 65. Highlights include:

- **Biologically implausible value detection**: Uses patient-specific longitudinal analysis, outlier flagging, and thresholds derived from known growth curve references.  
- **Adult algorithm**: Accommodates stable height and weight fluctuations in adults and flags erroneous or extreme measurements.  
- **Easy integration**: Offers additional utilities to calculate Z-scores and percentiles, potentially saving a great deal of time in data preprocessing.  

Because `growthcleanr` specifically targets **clinical anthropometric data**, it aligns well with tasks such as identifying outlier BMI values in EHR-based cohorts. By using such a tool, you can systematically flag data issues and maintain consistent filtering methods in your workflow.

## Refining the Plan Based on Research

The information we gather during this research phase should then be used to **refine our approach based on research** [9](../docs/References.md#ref9). This means taking the insights gained from authoritative guidelines, specialized tools, and any domain expertise to update your initial plan before coding. For example, the NICE guideline might prompt you to apply **lower BMI thresholds** for certain ethnic populations, and `growthcleanr` could help automate outlier detection. Integrating these best practices ensures that your final solution—once you prompt the LLM—is both clinically sound and methodologically rigorous. The result might look like this: **[ProjectPlan_Advanced.md](../docs/templates/ProjectPlan_Advanced.md)**

## Conclusion

By diligently gathering knowledge from reliable sources (clinical guidelines, relevant software packages, and domain experts) and clarifying any uncertainties early on, you will enable the LLM to generate code that reflects **scientifically validated practices**. As a result, your subsequent workflow steps—such as code generation, review, and refinement—will be grounded in robust methods and aligned with real-world clinical and research standards. Crucially, be sure to address **edge cases** carefully, documenting how borderline BMI values are handled so that both **code** and **human interpretation** remain consistent.

---

## 📚 Navigation

- [⬅️ Previous Chapter: Chapter 1 — Plan & Context](Chapter01_PlanAndContext.md)
- [➡️ Next Chapter: Chapter 3 — The AI Assistant](Chapter03_TheAIAssistant.md)
