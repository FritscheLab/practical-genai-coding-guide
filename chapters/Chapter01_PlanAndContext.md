# Chapter 1: Laying the Foundation — Plan & Context

The journey of effectively integrating GenAI tools into your research and coding workflows begins with a crucial first step: meticulous planning and a thorough understanding of the context surrounding your task. Before engaging an LLM, it is essential to lay a solid foundation by clearly defining what you want to achieve and the environment in which you will be working.

The initial stage involves **defining the goal and scope** of your endeavor. This means articulating precisely what you aim to accomplish with the assistance of an LLM. For instance, in the context of our running example, the overarching goal is harmonizing BMI data from EHRs. This broad objective can be broken down into more specific aims, such as cleaning the raw data, creating a summary of BMI categories, or automating a particular data transformation process. A well-defined goal provides a clear direction for subsequent steps, including how you will prompt the LLM and how you will evaluate its output.

Next, it is vital to have a comprehensive **understanding of the context**. This includes noting the specific characteristics of your data, such as its format (e.g., tab-delimited, CSV), the variables it contains (e.g., `person_id`, `encounter_id`, `bmi`, `height_cm`, `weight_kg`, `measurement_date`), and any domain-specific considerations that might be relevant. In our BMI harmonization example, understanding that the data comes from EHRs implies the need to consider medical standards for BMI categories and potential data quality issues inherent in clinical data. This contextual awareness is critical for tailoring your prompts to the LLM and ensuring that its responses are aligned with the specific requirements of your research domain.

Once the goal and context are clear, the next logical step is to **plan the sub-tasks**. Complex problems are often more manageable when broken down into smaller, actionable steps. For our BMI harmonization project, this might involve sub-tasks such as reading the EHR file, cleaning and filtering the data to remove errors or inconsistencies, selecting a single representative BMI measurement for each person, categorizing the BMI values into meaningful groups (e.g., underweight, normal, overweight, obese), and finally, outputting the processed data and any summary statistics. Planning these sub-tasks provides a structured roadmap for both you and the LLM, making the overall project seem less daunting and easier to execute.

Finally, before you even begin to prompt an LLM, it is essential to **set success criteria**. This involves determining what the final deliverables should be and how you will validate whether your solution is successful. In our BMI example, success might be defined by the creation of a clean dataset containing one representative BMI per person, a summary table showing the distribution of individuals across different BMI categories, and a data dictionary that clearly explains the contents of the cleaned dataset. Establishing these criteria upfront allows for an objective evaluation of the LLM's contribution and the overall outcome of your workflow.

Even at this initial planning stage, LLMs themselves can be valuable tools. You can **leverage LLMs in the planning phase** by prompting them to help brainstorm potential sub-tasks or to consider challenges you might encounter. For example, you could ask: "Based on the goal of harmonizing BMI data from EHR files, what are the typical sub-tasks involved in data cleaning and summarization?" The responses from the LLM can offer valuable suggestions and help you structure your workflow more effectively.

## Red Teaming Your Project Plan

Once you have developed a comprehensive project plan, an invaluable technique is to **red team** your plan before proceeding to implementation. Red teaming involves adopting an adversarial perspective to identify potential weaknesses, assumptions, or edge cases that could undermine your analysis. This critical review process can reveal blind spots and help you strengthen your methodology before investing time in coding.

You can use an LLM as a **skeptical methods reviewer** to red team your project plan. Consider using a prompt like the one shown in the [RedTeamingPromptExample.md](../docs/templates/RedTeamingPromptExample.md) template:

```markdown
You are a skeptical methods reviewer. Review the project plan below:
~~~
<Insert Your Project Plan>
~~~
Adopt a "not impressed" stance. List up to 10 missing assumptions, edge cases, or ambiguities that could be challenged by a critical reviewer. For each, write in 1-2 concise bullet points explaining why it could be problematic.
```

This adversarial approach can uncover issues such as:
- **Methodological gaps**: Missing considerations for data quality, outlier detection thresholds, or validation approaches
- **Domain-specific oversight**: Failure to account for clinical contexts (e.g., pregnancy, edema, bariatric surgery) that affect measurements
- **Technical assumptions**: Presumptions about data standardization, unit consistency, or temporal relationships
- **Definitional ambiguities**: Vague terms like "typical" measurements or "extreme outliers" that lack operational definitions
- **Population-specific considerations**: Oversimplified application of demographic-specific thresholds without considering evidence heterogeneity, data quality issues, or missing category handling

For example, when red teaming a BMI harmonization plan, a skeptical reviewer might identify that the plan lacks clear age-stratified analysis pipelines (e.g., "Your plan mentions using `growthcleanr` but doesn't specify whether you'll use BMI-for-age percentiles for pediatric participants (ages 2-19) versus adult BMI categories for ages 20+, which could lead to inappropriate categorization across age groups"), or that selecting "median BMI" without considering clinical context or temporal windows could introduce systematic bias.

A particularly sophisticated critique might focus on **population-specific methodological concerns**: "Your plan applies race-specific BMI cut points to 'Black, Asian, Native American, or Pacific Islander' populations using a single scheme, but evidence for lower BMI thresholds is most consistent for specific Asian subgroups rather than all listed populations. Additionally, EHR race data is notoriously noisy, multiracial identities are increasingly common, and your plan doesn't specify how missing, 'Other,' or harmonized race categories will be handled. This could lead to misclassification and systematic bias in BMI categorization."

**Acting on red teaming feedback** is crucial. Review each identified issue and determine whether to:
- Refine your methodology to address the concern
- Add explicit assumptions or limitations to your documentation
- Implement additional validation steps
- Modify your success criteria

This red teaming process transforms your initial plan into a more robust, defensible methodology that anticipates common criticisms and addresses potential pitfalls before they occur in your analysis.

In essence, this foundational planning phase is crucial for setting the stage for effective LLM utilization. A well-defined plan, coupled with a thorough understanding of the context and strengthened through red teaming, will guide your subsequent interactions with the AI assistant and ensure that the generated code and analysis are relevant, accurate, and aligned with your research objectives. Clarity at this stage ensures that both you and the AI are working toward solving the right problem.

---

## **Project Plan Examples in the Appendix**

To see how a high-level plan can evolve over time, refer to these example project plan files in the [docs/templates/](../docs/templates/) folder:

- **[ProjectPlan_InitialDraft.md](../docs/templates/ProjectPlan_InitialDraft.md)**  
  A simple, bare-bones plan outlining essential tasks like data ingestion, cleaning, and representative record selection.

- **[ProjectPlan_Improved.md](../docs/templates/ProjectPlan_Improved.md)**  
  A more detailed version that covers filtering, validation steps, and additional best practices.

- **[ProjectPlan_Advanced.md](../docs/templates/ProjectPlan_Advanced.md)**  
  A comprehensive plan that integrates demographic data, applies race-specific BMI categorizations, and includes extensive summary reporting.

- **[RedTeamingPromptExample.md](../docs/templates/RedTeamingPromptExample.md)**  
  A template for conducting adversarial review of your project plans to identify potential methodological weaknesses and edge cases.

These examples illustrate how an initial idea can be refined from a broad outline into a structured, domain-specific project plan that supports effective LLM utilization, and how red teaming can strengthen your methodology before implementation.

---

## 📚 Navigation

- [⬅️ Back to README](../README.md)
- [➡️ Next Chapter: Chapter 2 — Knowledge is Power](Chapter02_KnowledgeIsPower.md)
