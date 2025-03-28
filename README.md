# GenAI Tools for Coding & Research Workflows — A Practical 8-Step Process

Welcome to this repository containing a **practical textbook** on integrating Large Language Models (LLMs) into coding and research workflows. This guide is geared toward **biostatisticians, bioinformaticians, and data scientists**, providing hands-on steps and examples to enhance productivity and maintain rigorous standards when employing GenAI tools.

## Repository Overview

- **Chapters**  
  1. [Chapter 1: Laying the Foundation — Plan & Context](chapters/Chapter01_PlanAndContext.md)  
  2. [Chapter 2: Knowledge is Power — Do Your Research](chapters/Chapter02_KnowledgeIsPower.md)  
  3. [Chapter 3: The AI Assistant — Prompt LLM to Generate Code](chapters/Chapter03_TheAIAssistant.md)  
  4. [Chapter 4: Critical Eye — Review & Understand the Code](chapters/Chapter04_CriticalEye.md)  
     - Introduces **Git-based version control** practices for managing LLM-generated code iterations.  
  5. [Chapter 5: Making it Better — Refine Code & Add Features](chapters/Chapter05_MakingItBetter.md)  
  6. [Chapter 6: The Iterative Journey — Iterate Until Satisfied](chapters/Chapter06_TheIterativeJourney.md)  
  7. [Chapter 7: Standardization — Refactor to Lab Template](chapters/Chapter07_Standardization.md)  
     - Explains using the **R Code Refactoring Prompt** and an **R Code Template** to enforce lab-wide coding standards.  
  8. [Chapter 8: Sharing Your Work — Generate Documentation](chapters/Chapter08_SharingYourWork.md)  
     - Demonstrates how to leverage the **GitHub Repository Documentation Guidelines** for creating robust project docs.  
  - [Conclusions](chapters/Conclusions.md)  
     - A concise, **optimized conclusion** summarizing the eight-step process and emphasizing the importance of version control, collaboration, and reproducibility.

- **Docs**  
  - [Appendix A: Recommended LLM Tools and Platforms](docs/AppendixA_RecommendedLLMTools.md)  
  - [Appendix B: Prompt Library for Biostatistics, Bioinformatics, and Data Science](docs/AppendixB_PromptLibrary.md)  
  - [Appendix C: Further Reading and Resources](docs/AppendixC_FurtherReading.md)  
  - [Appendix D: Project Plans and Code Templates](docs/AppendixD_ProjectPlansAndTemplates.md)  
    - Directs you to the individual plan and template files under `docs/templates`.  
  - [References](docs/References.md)  
    - Hyperlinked citations used throughout the textbook.

- **Templates** (in `docs/templates/`)  
  - **R Code Templates & Prompts**  
    - [`R_CodeTemplate.R`](docs/templates/R_CodeTemplate.R): A production-quality script template featuring metadata, library management, CLI parsing, and more.  
    - [`R_CodeRefactoringPromptExample.md`](docs/templates/R_CodeRefactoringPromptExample.md): Guidance for prompting an LLM to refactor your existing code according to lab standards.  
  - **GitHub Documentation Guide**  
    - [`GitHubRepoDocumentationGuidelines.md`](docs/templates/GitHubRepoDocumentationGuidelines.md): A prompt and template for creating comprehensive `README.md` files, environment setup instructions, and usage docs.  
  - **Project Plans**  
    - [`ProjectPlan_InitialDraft.md`](docs/templates/ProjectPlan_InitialDraft.md)  
    - [`ProjectPlan_Improved.md`](docs/templates/ProjectPlan_Improved.md)  
    - [`ProjectPlan_Advanced.md`](docs/templates/ProjectPlan_Advanced.md)  
  - **Coding Prompt**  
    - [`CodingPromptForRScript.md`](docs/templates/CodingPromptForRScript.md): An example prompt for generating production-ready R scripts with `data.table` and `optparse`.

## How to Use This Repository

1. **Follow the 8-Step Process**  
   Read the chapters in order to learn how to plan, prompt, refine, and document your AI-assisted code effectively.  

2. **Leverage the Appendices**  
   - Check out the recommended LLM tools, curated prompts, further reading, and code templates to accelerate your workflow.

3. **Explore the Templates**  
   - Use the R templates, refactoring prompts, and documentation guidelines in `docs/templates/` to standardize your code and streamline collaboration.

4. **Apply Version Control**  
   - As described in [Chapter 4](chapters/Chapter04_CriticalEye.md), store each LLM-generated or refined code iteration in Git (e.g., GitHub) to maintain a clear history, review diffs, and revert if needed.

5. **Stay Tuned for References**  
   - All references are hyperlinked and listed in [docs/References.md](docs/References.md).

## Data Simulation Script

If you'd like to **test your workflows** or the 8-step process on example data, we provide a script that **simulates EHR and demographic records** with realistic data quality issues:

- **Script**: [`scripts/simulate_ehr_data.R`](scripts/simulate_ehr_data.R)  
- **Purpose**: Generates BMI, height, weight, and demographic data for a specified number of individuals, optionally introducing missing or implausible values.

### Example Usage

```bash
Rscript scripts/simulate_ehr_data.R \
  --output_ehr "./data/raw/ehr_bmi_simulated_data.tsv" \
  --output_ehr_dict "./data/raw/data_dictionary.txt" \
  --output_demo "./data/raw/demographics_simulated_data.tsv" \
  --output_demo_dict "./data/raw/demographics_data_dictionary.txt" \
  --seed 123 \
  --n_individuals 1000
```

**Explanation of Arguments:**

- `--output_ehr`: Where to save the simulated EHR (BMI) data (TSV).  
- `--output_ehr_dict`: Where to write the EHR data dictionary (TXT).  
- `--output_demo`: Where to save the demographics data (TSV).  
- `--output_demo_dict`: Where to write the demographics data dictionary (TXT).  
- `--seed`: Random seed for reproducibility.  
- `--n_individuals`: Number of unique individuals to simulate (default=1000).  

By running this script, you can quickly produce **synthetic data** for testing code-refinement prompts, checking your data-cleaning pipelines, or practicing the entire 8-step process from ingestion to documentation.

## Contributing

- We welcome pull requests for refinements, corrections, or extensions.  
- Please open issues for any questions, or join discussions to keep this textbook accurate and helpful.  

## License

This repository is licensed under the [GNU General Public License v3.0](./LICENSE).  

---

**Happy learning and coding with GenAI tools!**
