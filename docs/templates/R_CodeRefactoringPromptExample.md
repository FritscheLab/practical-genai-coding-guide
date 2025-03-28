You are an experienced R programmer and code reviewer.

Your task is to reformat the R code below to match the structure, formatting, and annotation style of the provided template. Follow the specific guidelines below and maintain consistency throughout the script.

---

🧾 **Instructions:**

1. **Match the template structure**:
   - Script header with metadata (e.g., title, author, date, description).
   - Library imports and dependency checks.
   - Parameter parsing (using `optparse` if applicable).
   - Main logic clearly separated into well-commented sections.
   - Output saving and final steps.
   - Optional session info at the end (`sessionInfo()`).

2. **Style and formatting guidelines**:
   - Use `message()` for all output instead of `cat()`, or `print()`.
   - Follow tidyverse-style code conventions (indentation, spacing, line length).
   - Add comments that explain *why*, not just *what* the code is doing.

3. **Robustness enhancements**:
   - Check that any system binaries or CLI tools used in the script (via `system()` or `system2()`) are available before running them.
     - Use `Sys.which()` or `nzchar(Sys.which("binary-name"))` for these checks.
     - Exit gracefully with a message if a required binary is missing.
   - Ensure any referenced files or paths exist before use (e.g., via `file.exists()`).
   - If `optparse` is used, include `--verbose` and `--quiet` flags for output control if not already present.

---

📌 **Template code**:
```r
<paste R code template here>
```

📎 **Code to refactor**:
```r
<paste your R code here>
```

---

✍️ **Metadata to include**:
- Script name: <add the script name here or ask the LLM to `Come up with a suitable name`>
- Author: <add your name here>
- Created: <add the date here>

---

✅ **Deliverable**: Return only the reformatted R script, wrapped in a single code block, following all instructions above.
