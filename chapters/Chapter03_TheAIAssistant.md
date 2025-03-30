# Chapter 3: The AI Assistant — Prompt LLM to Generate Code

Having meticulously planned our approach and fortified our understanding through thorough research, we now arrive at the stage where we engage our AI assistant to generate the code we need. This step, **Prompt LLM to Generate Code**, is pivotal, as the quality and relevance of the LLM's output are heavily dependent on the clarity and precision of our instructions.

The cornerstone of this step is **crafting clear and explicit prompts** [11](../docs/References.md#ref11). This involves translating our well-defined plan from Chapter 1 and the insights gained from our research in Chapter 2 into a set of instructions that the LLM can readily understand and follow [11](../docs/References.md#ref11). 

> **Tip:** If you created a detailed plan, such as the [Advanced Project Plan](../docs/templates/ProjectPlan_Advanced.md), you can feed that plan directly to the LLM. In doing so, the LLM has full knowledge of your data sources, variable definitions, and goals.

We must explicitly explain the task we want the LLM to perform, providing ample context so that it grasps the overall objective. For our BMI harmonization example, this would mean clearly stating that we need code to process EHR data to calculate and categorize BMI. It is also crucial to specify the programming language we intend to use—such as R or Python—so that the LLM generates code in the correct syntax [12](../docs/References.md#ref12). Furthermore, we need to detail each required operation step-by-step, essentially mirroring the sub-tasks we outlined in our initial plan. If our plan included reading the data, filtering outliers, selecting one BMI per person, and then categorizing those values, our prompt should reflect this sequence of actions in a clear and logical order.

In addition to the high-level instructions, it is essential to **include data details** in our prompts [14](../docs/References.md#ref14). This involves providing the LLM with information about the format of our data (e.g., is it in a tab-delimited file, a CSV file, or a database?) and listing the exact column names that the LLM will encounter. For our EHR data, we would specify that it is in a tab-delimited format and list the column names such as `person_id`, `encounter_id`, `bmi`, `height_cm`, `weight_kg`, and `measurement_date`. Providing these specifics helps the LLM understand the structure of the input data and generate appropriate code for loading and manipulating it [16](../docs/References.md#ref16).

To ensure that the LLM's output is directly usable and aligns with our needs, we must also be clear about **requesting specific outputs** [18](../docs/References.md#ref18). This means stating the desired format of the code we want the LLM to produce. For example, we might ask for "an R script" or "a Python function." Moreover, if we have any requirements for clarity and reproducibility—such as the inclusion of comments within the code—we should explicitly state these in our prompt.

For instance, we could instruct the LLM to:

**Example Prompt** 
~~~markdown
Return an R script that performs the following steps and includes comments explaining each section of the code:  
1. Reads the BMI data from a TSV file  
2. Filters out implausible heights and weights  
3. Selects a single representative BMI measurement per person  
4. Categorizes BMI based on pre-defined thresholds  
5. Outputs a cleaned dataset and a summary table.
~~~

To further enhance the effectiveness of our prompting, we can leverage **prompt templates** [19](../docs/References.md#ref19). The provided file [CodingPromptForRScript.md](../docs/templates/CodingPromptForRScript.md) is an excellent example of a structured approach to guide the LLM. This template begins by assigning the LLM the role of an expert R programmer with experience in production-quality scripts using specific libraries like `data.table` and `optparse`. It then instructs the LLM to:

1. Review a detailed project description and analysis plan (e.g., the one in [ProjectPlan_Advanced.md](../docs/templates/ProjectPlan_Advanced.md)).  
2. Ask clarifying questions as needed.  
3. Only begin writing code once it is confident in its understanding.  
4. Follow specific coding guidelines (e.g., using `optparse` for command-line arguments, `data.table` for data manipulation, including clear comments and function definitions, ensuring the script can be run from the command line, and outputting useful logs).

> **Practical Flow:**  
> 1. Copy the contents from your chosen project plan ([Initial](../docs/templates/ProjectPlan_InitialDraft.md), [Improved](../docs/templates/ProjectPlan_Improved.md), or [Advanced](../docs/templates/ProjectPlan_Advanced.md)).  
> 2. Paste it together with the [CodingPromptForRScript.md](../docs/templates/CodingPromptForRScript.md) template.  
> 3. Provide these as the “system” or “context” message to the LLM.  
> 4. Wait for the LLM to generate an initial script.  
> 5. Review, refine, and iterate as described in Chapters 4–6.

Finally, to solidify our understanding of how to translate our planning and research into an actionable set of instructions, it is helpful to consider an **example prompt for BMI harmonization**. Such a prompt would incorporate the overarching goal of harmonizing BMI data, the specific context of EHR data with its columns and format, the sub-tasks identified in Chapter 1 (reading, cleaning, filtering, selecting, categorizing, outputting), and any relevant research insights from Chapter 2 (e.g., specific BMI category definitions or outlier thresholds). 

Below is a short example showing how you might combine the plan into a prompt template:

**Example Prompt Template**  

~~~markdown
You are an expert R programmer with deep experience in writing production-quality scripts using `data.table` and `optparse`.

Here is my project plan:
```markdown
<paste entire contents of docs/templates/ProjectPlan_Advanced.md here>
```

Please review the plan, ask any clarifying questions, and then generate an R script that follows the instructions precisely. 
~~~

The LLM then evaluates both your project plan (which outlines how to handle EHR data) and your desired coding format. Once it understands them, it will produce an R script aligned with your advanced plan.

In conclusion, **effective prompting is a skill honed with practice** [21](../docs/References.md#ref21). By adhering to the principles of clarity, specificity, and providing sufficient context—often by directly including your project plan and the coding prompt template in the conversation—you can harness the LLM’s code-generation capabilities to significantly accelerate your research and coding workflows. The more specific and clear your prompt, the better the code generation will align with your needs.

---

## 📚 Navigation

- [⬅️ Previous Chapter: Chapter 2 — Knowledge is Power](Chapter02_KnowledgeIsPower.md)
- [➡️ Next Chapter: Chapter 4 — Critical Eye](Chapter04_CriticalEye.md)
