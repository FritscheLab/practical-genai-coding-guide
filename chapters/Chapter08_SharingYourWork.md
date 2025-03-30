# Chapter 8: Sharing Your Work — Generate Documentation

The final step in our practical 8-step process is to ensure that your hard work is well-documented and easily understandable by others. This chapter focuses on **Generate Documentation**, a critical phase for enhancing the reproducibility and usability of your research workflows [71](../docs/References.md#ref71).

One of the most efficient ways to begin this step is to **let AI draft project documentation** [45](../docs/References.md#ref45). You can prompt the LLM to write a `README.md` file or a comprehensive summary of your project. This documentation should clearly explain what the code does, provide instructions on how to run it, and describe the format and meaning of the outputs it produces. For instance, you might use a prompt like: 

> "Based on the R script we have developed for BMI harmonization, write a `README.md` file that describes the purpose of the script, outlines the steps involved in its execution, details the outputs it generates, and provides definitions for each of the output fields."

It is essential to ensure that this documentation **includes key project details** [48](../docs/References.md#ref48). For our BMI harmonization example, this would mean clearly outlining the contents of the cleaned dataset, including the names and definitions of each column. The documentation should also explain the logic behind the BMI categorization process, including the specific thresholds used for each category, and should mention any key assumptions or methodological choices made during the analysis.

---

## Using the GitHub Repository Documentation Guidelines

To help automate or guide the creation of high-quality documentation, we provide a **GitHub Repository Documentation Guidelines** prompt in  
[`docs/templates/GitHubRepoDocumentationGuidelines.md`](../docs/templates/GitHubRepoDocumentationGuidelines.md).

This file outlines a *template* for:

- Writing a comprehensive `README.md` with sections like **Title**, **Description**, **Installation**, **Requirements**, **Usage**, **Project Structure**, **Contributing**, **License**, and **Contact**.  
- Setting up environments using **mamba (Conda)** for both R and Python dependencies.  
- Generating `/doc/<tool>.md` files for tool-specific documentation.  
- Embedding best practices like versioning, usage examples, and license references.

### Example Workflow with the Guidelines Prompt

1. **Draft or finalize your R script** (or any code) so you know the final structure and usage.  
2. **Open `docs/templates/GitHubRepoDocumentationGuidelines.md`** and copy the relevant prompt text.  
3. **Prompt the LLM** with your code’s context plus the guidelines. For example:
   > "Using the guidelines from `GitHubRepoDocumentationGuidelines.md`, please generate a README that covers installation steps (including mamba), usage examples, and environment requirements for my BMI harmonization script."
4. **Review and adapt** the AI-generated text. Make sure the documentation accurately reflects your code’s functionality, dependencies, input/output specs, and lab standards.  
5. **Commit** the final documentation (`README.md`, data dictionaries, etc.) to version control. 

Leveraging this guidelines file helps ensure you produce consistent and professional project documentation, saving you time and helping your project meet open-source or academic publishing standards.

---

Another valuable component of project documentation is a **data dictionary**, and here too, AI can be a significant help [76](../docs/References.md#ref76). You can use the LLM to generate a table or a detailed list that describes each field in your output dataset. For example, you could prompt: 
> "Create a data dictionary in Markdown table format for the columns in the final cleaned BMI dataset, including the column name, a brief description, and the data type for each column."

This data dictionary serves as a crucial reference for anyone who will be working with or interpreting the resulting data.

---

Once the LLM has provided you with initial drafts of the documentation, it is vital to **review and polish the docs** [48](../docs/References.md#ref48). Carefully edit the AI-generated text for accuracy and clarity. You might need to add specific examples to illustrate how to use the script, provide additional context about the research question or the data, or correct any minor inaccuracies that the LLM might have introduced. Remember that while the AI can significantly speed up the writing process, human oversight is essential to ensure the final documentation is of high quality and truly reflects the work that was done.

In conclusion, generating thorough and user-friendly documentation is a critical final step in any research workflow. By leveraging the capabilities of LLMs to draft initial documentation—whether with your own prompts or via [our guidelines prompt](../docs/templates/GitHubRepoDocumentationGuidelines.md)—and then taking the time to carefully review and polish these drafts, you can significantly enhance the transparency, reproducibility, and overall impact of your research. This ensures that your work is not only sound but also readily accessible and understandable to the wider scientific community.

---

## 📚 Navigation

- [⬅️ Previous Chapter: Chapter 7 — Standardization](Chapter07_Standardization.md)
- [⬅️ Back to README](../README.md)
