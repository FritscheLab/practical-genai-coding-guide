# Chapter 4: Critical Eye — Review & Understand the Code

Once the LLM has diligently responded to our well-crafted prompt and presented us with a draft of the code, it is crucial to resist the urge to execute it immediately. The next vital step in our 8-step process is to **Review & Understand the Code** with a critical eye [23](../docs/References.md#ref23). This stage is akin to a thorough code review with a teammate, ensuring that we have a solid grasp of what the AI has produced and whether it aligns with our intentions.

The first step in this review process is to **step through the AI-generated output** [24](../docs/References.md#ref24). This involves carefully reading the code line by line or section by section. We should approach this task as if we were examining code written by a junior colleague, ensuring that we comprehend the purpose and function of each part. It is paramount at this stage to avoid blindly trusting that the code will work as intended. Instead, we should treat it as a preliminary draft requiring our expert inspection [25](../docs/References.md#ref25).

As we read the code, we must actively **match it to the plan** we formulated in Chapter 1 [26](../docs/References.md#ref26). For each sub-task we have outlined, we must verify that the generated code includes the necessary steps [27](../docs/References.md#ref27). For instance, if our plan for BMI harmonization included filtering out outliers based on height, we must confirm that the code implements this filtering logic. Similarly, if we intended to select only one BMI measurement per person based on the latest encounter date, we must ensure that the code includes the appropriate grouping and sorting operations to achieve this. This verification process ensures that the LLM has addressed all the requirements we laid out in the planning phase.

During our review, it is common to **identify issues and gaps** in the AI-generated code [28](../docs/References.md#ref28). This could include errors in syntax or logic that might cause the code to fail, inefficiencies in the approach that could lead to slow performance, or even missing pieces of functionality that were part of our original plan [30](../docs/References.md#ref30). For example, we might notice that the code uses an incorrect variable name, or perhaps it has forgotten to generate the summary table of BMI categories we requested. It is essential to be vigilant in looking for these discrepancies, as LLM-generated code, while often helpful, is not always flawless.

If, during our review, we encounter any part of the code that is confusing or whose purpose is unclear, we should not hesitate to **clarify confusing sections with the AI** [33](../docs/References.md#ref33). We can simply copy the section of code that we don’t understand and prompt the LLM with a question like: “Could you explain what the `apply()` function is doing in this particular part of the code?” LLMs are often capable of providing explanations for the code they generate, which can significantly aid in our understanding of its logic and help us identify potential issues.

## Using Version Control to Track LLM-Generated Code Iterations

A valuable addition to your workflow at this stage is using **GitHub** (or any other Git-based version control platform) to track the changes the LLM has introduced over time. Because chat sessions with an LLM are transient and may not be fully reproducible later, storing each draft of the code in a repository allows you to:

1. **Compare Diff Over Time:** Each new iteration of code from the LLM can be committed as a separate version. This makes it easy to see exactly what changed from one version to the next.
2. **Revert or Reintroduce Features:** If the LLM removes or replaces functionality between drafts, version control makes it easy to restore a previous approach or cherry-pick certain lines.
3. **Document the Rationale:** In each commit message, you can briefly explain *why* the code changed (e.g., “Fixed incorrect variable name” or “Removed outliers based on user’s new request”).
4. **Collaborate More Seamlessly:** If multiple people or tools are working on the same script, Git merges and pull requests will keep all changes organized.

### Suggested Version Control Workflow

1. **Initialize a Repo:** If you haven’t already, create a Git repository (locally or on GitHub) for your project.  
   ```bash
   git init
   git add .
   git commit -m "Initial commit: Project skeleton"
   ```

2. **Save the First Draft:** Once the LLM produces a first code draft (or a substantial change):
   ```bash
   # Save the code into a file (e.g., `bmi_cleaning_first_draft.R`)
   git add bmi_cleaning_first_draft.R
   git commit -m "LLM-generated first draft of BMI cleaning script"
   ```

3. **Iterate and Commit:** After you identify issues or ask the LLM for refinements, copy the new code or the revised sections into the same file (or a new versioned filename, if that’s your style) and commit the changes.  
   ```bash
   # Overwrite or rename the file with the LLM’s new code
   git add bmi_cleaning_first_draft.R
   git commit -m "Refinement #1: fixed variable name mismatch and added summary table"
   ```
   - In your commit message, reference any relevant conversation with the LLM, or link to your chat notes so you can recall *why* these edits happened.

4. **Use Git Diff Tools:** Whenever you want to see how the LLM’s code has evolved, run:
   ```bash
   git diff <older_commit_hash> <newer_commit_hash> -- bmi_cleaning_first_draft.R
   ```
   This highlights lines that were added, removed, or modified between versions.

5. **Branch if Needed:** If you want to explore a different approach suggested by the LLM without losing your original path, create a new branch for that approach. This way, you can keep alternative solutions separate and eventually merge or discard them as necessary:
   ```bash
   git checkout -b alternate-approach
   # Paste in LLM’s new approach
   git commit -am "Try alternate outlier detection method"
   ```

6. **Tag Milestones:** If you reach a milestone (e.g., “all outlier filtering logic is confirmed working”), add a Git tag or release. This makes it easy to roll back to that known-good state if the LLM’s subsequent suggestions inadvertently break something.

### Why This Matters

By using version control, you ensure that:

- **Every code revision** from the LLM is **preserved**.  
- You have a clear record of **feature additions, removals, or bug fixes**.  
- Later, if you realize a certain step inadvertently introduced a bug or removed an important feature, you can **pinpoint and revert** that exact commit.  
- Collaboration and reproducibility become much simpler, since others can pull the repository and immediately see the timeline of LLM-driven changes.

## Key Principle

Throughout this entire *review and iteration* process, treat the LLM’s output as a **starting point**, not a final solution. Your domain expertise and thorough inspection are essential for making sure the code is correct, efficient, and aligned with your objectives. By combining that critical eye with proper version control, you can accelerate development without sacrificing long-term maintainability and reproducibility.

The overarching principle in this critical review phase is to treat the LLM’s output as a valuable starting point, but not as a final solution. Our domain expertise, combined with a meticulous and critical review of the generated code, is absolutely essential for ensuring that the final script is correct, efficient, and ultimately meets the objectives of our research. We should always verify the AI’s output, as it can be a tremendous time-saver but may also be over-confident and incorrect in certain areas. **This careful review, coupled with Git-based version tracking, ensures that we catch any mistakes before they become significant problems in our analysis** while also preserving a detailed history of each iteration.

---

## 📚 Navigation

- [⬅️ Previous Chapter: Chapter 3 — The AI Assistant](Chapter03_TheAIAssistant.md)
- [➡️ Next Chapter: Chapter 5 — Making It Better](Chapter05_MakingItBetter.md)
