## Appendix B: Prompt Library for Biostatistics, Bioinformatics, and Data Science

Large Language Models (LLMs) like ChatGPT are increasingly used to assist with coding, data analysis, and interpretation tasks in biomedical research. Their ability to follow natural language instructions makes them valuable tools for data scientists and bioinformaticians, enabling analyses and visualizations through verbal or written commands. However, the quality of LLM output depends heavily on prompt design—phrasing questions clearly, providing examples, or breaking tasks into steps can significantly improve results [(14)](../docs/References.md#ref14). This appendix presents a broad collection of example prompts that illustrate how LLMs can support various tasks in biostatistics, bioinformatics, and data science. These examples span data cleaning, analysis, visualization, documentation, reproducibility, model interpretation, statistical reporting, genomic data handling, and data sharing. Each prompt is crafted to be pedagogically useful, demonstrating how to instruct an LLM to tackle the task. The prompts range from concise code-focused queries to multi-step analytical workflows, reflecting real-world scenarios where an LLM could assist students and professionals.

---

### Data Cleaning

Effective data cleaning is a critical first step in any analysis. LLMs can help streamline data cleaning by suggesting code to handle missing values, detect outliers, harmonize formats, and even parse unstructured data into structured form [(13)](../docs/References.md#ref13). Example prompts:

1. **(R, tidyverse) – Harmonizing EHR Codes**  
   **Prompt:**  
   *"Using R (tidyverse), map and standardize diagnosis codes from ICD-9 to ICD-10. Identify codes that don’t directly match and suggest how to handle them (e.g., approximate mappings or flag for manual review)."*

2. **(Python, pandas) – Missing Data Imputation**  
   **Prompt:**  
   *"In Python with pandas, identify columns with more than 20% missing values. Then, for the remaining columns, impute missing values—use mean imputation for numeric columns and mode for categorical columns. Provide the pandas code."*

3. **(R, lubridate) – Date Parsing**  
   **Prompt:**  
   *"Using R’s lubridate, convert all date strings in a column to a standard format (YYYY-MM-DD). Flag any entries that don’t parse (e.g., typos like '32/13/2021'). Show your R code."*

4. **(Python, IQR-based Outlier Detection)**  
   **Prompt:**  
   *"Write Python code (numpy/pandas) to detect outliers in a numeric column using the IQR method. Then remove or flag those rows."*

5. **(R, dplyr) – Duplicate Records**  
   **Prompt:**  
   *"In R using dplyr, find and remove duplicate records based on patient ID and date, keeping only the latest record for each patient. Show the code."*

6. **(Multi-step Prompt) – Iterative Data QC**  
   **Prompt:**  
   *"Let’s clean this dataset step by step. First, summarize each column (type, missing count, unique values). Then **ask me** which columns to fix. After I specify, generate R code to address issues in those columns. Proceed interactively."*

---

### Data Analysis

LLMs can assist with a wide array of data analysis tasks—from classical statistical tests to advanced modeling. Example prompts:

1. **(R, survival) – Kaplan-Meier Survival**  
   **Prompt:**  
   *"Using R and the `survival` package, fit a Kaplan-Meier survival curve by treatment group. Plot the KM curves, perform a log-rank test, and show the R code and output."*

2. **(R, lme4) – Mixed Effects Model**  
   **Prompt:**  
   *"Fit a linear mixed-effects model for repeated measures (blood pressure over time) using `lme4` in R. Include a random intercept per patient. Show the R code and interpret the summary."*

3. **(R, stats) – Dimensionality Reduction**  
   **Prompt:**  
   *"Perform a PCA in R (using `prcomp`) on a scaled gene expression dataset. Provide the first 5 PCs and their variance explained. Show the R code."*

4. **(Python, scikit-learn) – Classification**  
   **Prompt:**  
   *"Train a random forest classifier to predict disease status from lab features. Include code for train/test split, training (100 trees), and output feature importances."*

5. **(Python, TensorFlow) – LSTM**  
   **Prompt:**  
   *"Give Python code using TensorFlow/Keras to build and train an LSTM model on a sequence of 10 heart-rate measurements to predict the next value."*

6. **(R, epi) – Epidemiological Analysis**  
   **Prompt:**  
   *"Calculate the odds ratio for an exposure in a case-control study. Provide R code (e.g., `epiR` or base methods) to compute the OR, 95% CI, and a Chi-square test for association."*

7. **(R, powerAnalysis) – Clinical Trial Sample Size**  
   **Prompt:**  
   *"Using R, demonstrate how to perform a power analysis for a two-arm trial (80% power to detect a 5% difference, alpha=0.05). Show the code (e.g., `pwr` package) and the required sample size."*

8. **(R, glm) – Logistic Regression with Interaction**  
   **Prompt:**  
   *"Use `glm()` to fit a logistic regression (outcome: disease yes/no) on age, smoking, and their interaction. Provide the R code and interpret the interaction term."*

9. **(Python, statsmodels) – Regression Diagnostics**  
   **Prompt:**  
   *"Fit a linear regression and generate diagnostic plots (residuals vs fitted, Q-Q plot) to check assumptions. Provide the Python code using statsmodels and matplotlib."*

---

### Data Visualization

Data visualization is another area where LLMs can provide plotting code and suggestions [(15)](../docs/References.md#ref15). Example prompts:

1. **(R, ggplot2) – Scatter Plot with Regression**  
   **Prompt:**  
   *"In R with ggplot2, create a scatter plot of systolic BP vs age, add a regression line with confidence interval, proper labels, and a title."*

2. **(Python, seaborn) – Correlation Heatmap**  
   **Prompt:**  
   *"Use Python (pandas + seaborn) to compute the correlation matrix of clinical variables and plot an annotated heatmap."*

3. **(R, survminer) – Kaplan-Meier Plot**  
   **Prompt:**  
   *"Plot a Kaplan-Meier curve by treatment group using the `survminer` package. Include a risk table below the plot."*

4. **(R, EnhancedVolcano) – Volcano Plot**  
   **Prompt:**  
   *"After differential expression analysis, create a volcano plot highlighting genes with p<0.001 and |log2FC| > 2. Label top 10 genes. Provide the code (EnhancedVolcano or ggplot2)."*

5. **(Python, matplotlib) – ROC Curve**  
   **Prompt:**  
   *"Provide Python code to plot an ROC curve using scikit-learn. Compute AUC, add a diagonal reference line, and annotate the AUC."*

---

### Documentation

LLMs are adept at producing human-readable text from structured information, making them excellent for generating documentation. Example prompts:

1. **(Python) – Code Comments & Docstring**  
   **Prompt:**  
   *"Given this Python function `calc_auc(...)`, write a clear docstring and inline comments explaining each step."*

2. **(R) – Explain an R Script**  
   **Prompt:**  
   *"Explain the following R script step by step. Provide markdown comments for a newcomer to understand the workflow."*

3. **Summarizing a Data Table**  
   **Prompt:**  
   *"Given this results table, generate a brief summary of the key findings in 2–3 sentences suitable for a report."*

4. **Model Output Explanation**  
   **Prompt:**  
   *"Explain the meaning of these linear regression coefficients and p-values in plain English. Which are significant? What does the intercept represent?"*

5. **(Roxygen) – R Function Documentation**  
   **Prompt:**  
   *"Write Roxygen2 documentation for an R function `clean_data()`. Include description, parameters, return value, and example usage."*

6. **Project README Generation**  
   **Prompt:**  
   *"Generate a README.md for a data analysis project with sections: Introduction, Data, Methods, Results. Keep the tone professional."*

---

### Reproducibility

Reproducibility is crucial in scientific analysis. While much work has focused on LLM accuracy, reproducibility remains underexplored [(17)](../docs/References.md#ref17). Example prompts:

1. **(R, set.seed)**  
   **Prompt:**  
   *"Provide R code for a random forest analysis with a fixed random seed (`set.seed(123)`) so results can be reproduced."*

2. **(Python, environment)**  
   **Prompt:**  
   *"How do I ensure reproducibility on another machine? Provide a short guide: saving environment dependencies (`pip freeze`, `conda env export`), setting random seeds in numpy/TensorFlow, etc."*

3. **Workflow Tools**  
   **Prompt:**  
   *"Outline a reproducible data analysis pipeline (Snakemake or Nextflow). Explain how each step (data import, cleaning, analysis, visualization) can be version-controlled and documented."*

4. **(R, renv)**  
   **Prompt:**  
   *"Using R, show how to make a project's environment reproducible with `renv`: initialization, snapshot, and restoring on another machine."*

5. **Version Control Integration**  
   **Prompt:**  
   *"Explain how to integrate Git version control into a data analysis project, track changes, collaborate on GitHub, and maintain a single source of truth."*

6. **Comparing Outputs**  
   **Prompt:**  
   *"I have two versions of the same analysis (before/after refactoring). Provide a strategy to compare outputs and ensure consistency."*

---

### Model Interpretation

Interpreting models is essential in biostatistics and ML. LLMs can help translate complex outputs into understandable explanations. Example prompts:

1. **Linear Regression Coefficient**  
   **Prompt:**  
   *"Interpret a linear regression coefficient for Age=1.5 mmHg/year (p=0.01). Also clarify what the intercept means if it's 100 mmHg."*

2. **Logistic Regression Odds Ratio**  
   **Prompt:**  
   *"If the OR for smoking is 2.0 (95% CI 1.5–2.7), explain in plain terms what that means about disease risk."*

3. **Random Forest Feature Importance**  
   **Prompt:**  
   *"Explain how to interpret feature importance = 0.15 vs 0.10. Also mention any caution about random forests' bias toward variables with many categories."*

4. **(Python, SHAP) – Explainable AI**  
   **Prompt:**  
   *"Provide Python code using the SHAP library to interpret an XGBoost model’s predictions. Include a summary plot and how to read it."*

5. **Cox Proportional Hazards**  
   **Prompt:**  
   *"A hazard ratio of 0.75 with p=0.03 for a new drug—what does that mean for patient survival? Also mention the assumption of proportional hazards."*

6. **Model Assumptions & Diagnostics**  
   **Prompt:**  
   *"List the key assumptions of a linear model and how to check them (residual plots, tests for heteroscedasticity, normal errors, etc.)."*

7. **Interpreting PCA**  
   **Prompt:**  
   *"After PCA, the first two PCs explain 60% of the variance. How do I describe these components and which variables are most influential?"*

---

### Statistical Reporting

Reporting results clearly is as important as doing the analysis. LLMs can assist in writing results sections and checking adherence to reporting standards. Example prompts:

1. **Results Paragraph (ANOVA)**  
   **Prompt:**  
   *"Write a short results paragraph for an ANOVA test, e.g., F(3,116)=5.23, p=0.002. Interpret the finding."*

2. **APA Style (Regression)**  
   **Prompt:**  
   *"Provide an APA-style paragraph for a linear regression: coefficient=0.5 (SE=0.1), p<0.001, R²=0.30. 2–3 sentences only."*

3. **Summary Table (R, stargazer)**  
   **Prompt:**  
   *"In R, create a table of regression results for multiple models using `stargazer` or `gt`. Show the code and briefly interpret."*

4. **Methods Section Draft**  
   **Prompt:**  
   *"Draft a Methods section for a logistic regression analysis. Include study design, variable selection, model fit assessment. Write formally in past tense."*

5. **Non-significant Result**  
   **Prompt:**  
   *"Explain how to report a non-significant difference in mean cholesterol (mean diff=5 mg/dL, CI [-2, 12], p=0.18) without 'failing to reject' jargon."*

6. **CONSORT Summary**  
   **Prompt:**  
   *"Outline how to report a randomized controlled trial according to CONSORT guidelines: participant flow, baseline, primary outcome, adverse events."*

7. **Automated Report Generation**  
   **Prompt:**  
   *"Suggest a way to auto-generate a report (R Markdown or Jupyter) that includes code, outputs, and narrative interpretation for transparency."*

---

### Genomic Data Handling

Genomic data has unique formats (FASTA, VCF, BAM). LLMs can help with code for reading and analyzing these files, or guide advanced tasks like GWAS and PRS [(4)](../docs/References.md#ref4). Example prompts:

1. **(R, VariantAnnotation) – VCF Filtering**  
   **Prompt:**  
   *"Read a VCF in R using `VariantAnnotation`. Filter variants on chromosome 21 with MAF>0.05. Show code and save the filtered VCF."*

2. **(PLINK) – GWAS**  
   **Prompt:**  
   *"Outline steps for a GWAS on a binary trait using PLINK: data QC, association test, multiple testing correction. Provide example commands."*

3. **(R, snpStats) – Polygenic Risk Score**  
   **Prompt:**  
   *"Compute a PRS given SNP genotypes and effect sizes. Use base R or `snpStats`/`bigsnpr` to sum weighted alleles, standardize the score."*

4. **(Python, BioPython) – FASTA Analysis**  
   **Prompt:**  
   *"Read a FASTA file in Python, compute GC content per sequence, and search for the motif 'ATGGC' using BioPython. Show the code."*

5. **(R, biomaRt) – Gene Annotation**  
   **Prompt:**  
   *"Take a list of Ensembl IDs, query gene symbols and descriptions from Ensembl using `biomaRt`. Provide the example code."*

6. **Variant Interpretation**  
   **Prompt:**  
   *"Interpret 'SNP rs123456 – OR=1.3, p=4e-6' in a GWAS. Explain what OR=1.3 means for risk and note genome-wide significance thresholds."*

7. **(R, phyloseq) – Microbiome Data**  
   **Prompt:**  
   *"Import an OTU table, sample metadata, and taxonomy into `phyloseq`. Compute alpha diversity (Shannon) and plot by disease status. Show R code."*

---

### Data Sharing

Data sharing and collaboration are vital in science, and LLMs can help prepare data and code for broader use. Generative AI techniques can even create synthetic data to protect patient privacy [(20)](../docs/References.md#ref20). Example prompts:

1. **Data Dictionary**  
   **Prompt:**  
   *"Generate a data dictionary for columns: PatientID, Age, Sex, BP_before, BP_after, Outcome. Provide descriptions, units, and possible values."*

2. **De-identification**  
   **Prompt:**  
   *"I have a healthcare dataset with personal identifiers. Give pseudocode for removing or obfuscating names, addresses, phone numbers to protect privacy."*

3. **Packaging Code (R)**  
   **Prompt:**  
   *"Explain how to convert an analysis script into an R package: `usethis` for structure, functions in R/, documentation, sharing on GitHub."*

4. **Reusable Notebook (Python, Jupyter)**  
   **Prompt:**  
   *"Tips for structuring a Jupyter Notebook for others to run easily: install/import blocks, relative paths, parameter sections, clear markdown instructions."*

5. **Synthetic Data Generation**  
   **Prompt:**  
   *"How to generate a synthetic dataset that preserves real data’s distribution and correlation. Mention why synthetic data helps with data-sharing restrictions."*

6. **Public Repository**  
   **Prompt:**  
   *"Checklist for sharing data/results on Dryad/Zenodo: choose license, add metadata, upload data/code, how to cite. Provide a short best-practices list."*

7. **Collaboration Workflow**  
   **Prompt:**  
   *"Describe a workflow for collaborative data analysis using Git and LLM assistance (e.g., GitHub Copilot). Emphasize a single source of truth for data/code."*

---

Each of these prompts shows how users in biostatistics, bioinformatics, and data science can engage LLMs to assist with diverse technical tasks—ranging from code generation to statistical reporting. By specifying the programming language or libraries and clarifying the output format (code snippet, explanation, or combination), one can leverage generative AI to save time, learn new techniques, and maintain reproducible workflows [(18)](../docs/References.md#ref18). As these examples illustrate, LLMs can act as coding assistants, statistical consultants, or “explainers.” With thoughtful prompt engineering—giving context, breaking tasks into steps, or requesting clarifications—the utility of LLMs in these domains is greatly enhanced [(14)](../docs/References.md#ref14).
