# Red Teaming Prompt Templates

Red teaming involves adopting an adversarial perspective to identify potential weaknesses, assumptions, or edge cases in your project plans or code. These templates help you use LLMs as skeptical reviewers to strengthen your methodology and implementation.

## Template 1: Red Teaming Project Plans

Use this template to critically evaluate your project methodology before implementation:

```markdown
You are a skeptical methods reviewer with expertise in [INSERT DOMAIN, e.g., clinical epidemiology, biostatistics]. Review the project plan below:
~~~
<Insert Your Project Plan>
~~~
Adopt a "not impressed" stance. List up to 10 missing assumptions, edge cases, or ambiguities that could be challenged by a critical reviewer. Pay particular attention to:
- Population-specific considerations and demographic heterogeneity
- Data quality issues inherent to the data source (e.g., EHR, survey, registry)
- Temporal considerations and measurement context
- Missing or ambiguous operational definitions
- Statistical validity and potential for bias

For each issue, write in 1-2 concise bullet points explaining why it could be problematic.

If the plan appears robust and you find fewer than 10 issues, list as many as you can and briefly explain why the plan is otherwise comprehensive.
```

### Example Issues This Might Identify:
- **Methodological gaps**: Missing validation approaches, undefined outlier detection thresholds
- **Domain-specific oversight**: Failure to account for clinical contexts affecting measurements
- **Technical assumptions**: Presumptions about data standardization or temporal relationships
- **Definitional ambiguities**: Vague terms lacking operational definitions
- **Population heterogeneity**: Oversimplified demographic categorizations that ignore within-group variation or data quality issues

## Template 2: Red Teaming LLM-Generated Code

Use this template to critically evaluate code implementation:

```markdown
You are a skeptical code reviewer. Review the code below and identify potential issues:
~~~
<Insert Your LLM-Generated Code>
~~~
Adopt a "not impressed" stance. List up to 10 potential problems, including:
- Logical errors or edge cases not handled
- Performance inefficiencies  
- Data quality assumptions that might not hold
- Missing validation steps
- Potential for incorrect results

For each issue, explain in 1-2 bullet points why it could be problematic.
```

### Example Issues This Might Identify:
- **Edge case handling**: Missing checks for empty datasets, malformed data, unexpected types
- **Performance issues**: Inefficient loops, unnecessary operations, memory problems
- **Domain-specific oversights**: Failure to handle measurement artifacts or collection biases
- **Statistical validity**: Inappropriate methods, missing assumptions, inadequate validation
- **Error propagation**: Early mistakes compounding into incorrect final results

## Tips for Effective Red Teaming

1. **Be specific about expertise**: Specify the domain expertise you want the LLM to adopt (e.g., "clinical epidemiologist," "biostatistician," "health informatics expert")
2. **Target known problem areas**: Direct attention to methodological areas prone to issues in your field
3. **Iterate**: Apply red teaming at different stages - initial plans, draft code, and final implementation
4. **Document responses**: Keep track of identified issues and how you addressed them
5. **Don't dismiss easily**: Even seemingly minor issues might reveal important oversights
6. **Consider intersectionality**: Ask about interactions between different methodological choices

## Domain-Specific Red Teaming Prompts

### For Health/Clinical Research:
```markdown
Focus particularly on:
- Population heterogeneity and demographic classification issues
- Age-stratified analysis requirements and developmental considerations
- Clinical context and measurement artifacts  
- Temporal relationships and exposure windows
- Data provenance and collection biases
- Regulatory and ethical considerations
```

### For Observational Studies:
```markdown
Pay special attention to:
- Selection bias and missing data patterns
- Confounding and causal inference issues
- Measurement error and misclassification
- Time-varying exposures and outcomes
- Generalizability across populations
```

### Example: Race-Specific Methodology Critique
A sophisticated red teaming response might identify: "Your plan applies race-specific BMI cut points to 'Black, Asian, Native American, or Pacific Islander' populations using a single scheme, but evidence for lower BMI thresholds is most consistent for specific Asian subgroups rather than all listed populations. Additionally, EHR race data is notoriously noisy, multiracial identities are increasingly common, and your plan doesn't specify how missing, 'Other,' or harmonized race categories will be handled. This could lead to systematic misclassification bias."

### Example: Age-Stratified Analysis Critique  
Another nuanced critique might focus on developmental considerations: "Your plan mentions using `growthcleanr` for data cleaning but doesn't specify age-stratified analysis pipelines. For participants ages 2-19, BMI should be evaluated using age- and sex-specific percentiles rather than adult categorical thresholds. Your plan needs to clearly define pediatric versus adult analysis pathways and specify how you'll handle the transition at age boundaries to avoid inappropriate categorization across developmental stages."

## Acting on Red Teaming Feedback

For each identified issue:
- Evaluate whether it represents a real risk to your analysis
- Modify your methodology or code to address legitimate concerns  
- Add validation checks or error handling where appropriate
- Document assumptions or limitations that cannot be easily resolved
- Test edge cases that were previously overlooked

Red teaming transforms initial plans and code into more robust, defensible solutions that anticipate common failure modes and handle edge cases appropriately. a skeptical methods reviewer.
