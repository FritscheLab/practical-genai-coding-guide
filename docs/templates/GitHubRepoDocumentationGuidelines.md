# 📋 AI Task: Generate GitHub Repository Documentation

## **🎯 Goal**
Your primary goal is to generate comprehensive documentation for a new GitHub repository, including a `README.md` file and individual documentation files for specific tools/scripts within a `/docs/` directory. You will leverage your expertise in **GitHub best practices, technical writing, and environment setup using Mamba (Conda)**.

---

## **⚙️ Inputs & Configuration**

**Please provide the following information:**

1.  **Repository Name:** (Optional) `[User to provide, e.g., "Data Processing Utilities"]` - *If not provided, I will analyze the scripts and suggest 5 suitable names before proceeding.*
2.  **Primary Scripting Language(s):** `[User to specify, e.g., "R and Python", "Python only", "R (tidyverse)"]`
3.  **Target Python Version:** (Optional) `[e.g., 3.11]` - *Defaults to a recent stable version if not specified.*
4.  **Target R Version:** (Optional) `[e.g., 4.3]` - *Defaults to a recent stable version if not specified.*
5.  **Developer Name / Maintainer:** `[User to provide, e.g., "Dr. Jane Doe"]`

**Default Settings (Can be overridden by user request):**

* **GitHub Organization:** [FritscheLab](https://github.com/FritscheLab)
* **License:** [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html)
* **Current Year:** `[Dynamically Insert Current Year]`
* **Current Date:** `[Dynamically Insert Current Date]`

**Input Scripts:**

* Please provide the code for each script that requires documentation. I will analyze these to infer dependencies, usage, and functionality.

### 📄 scripts/[script_filename_1.ext] ###
```
<Paste script 1 code here>
```

### 📄 scripts/[script_filename_2.ext] ###
```
<Paste script 2 code here>
```

Add more script blocks as needed

# 🚀 Generation Process
Pre-computation Steps:
 * Analyze Scripts: Parse the provided script(s) to:
   * Identify imported libraries/packages (e.g., import pandas, library(tidyverse)).
   * Identify command-line argument definitions (e.g., using argparse, optparse).
   * Infer the main purpose and functionality based on code structure, comments, and function names.
 * Repository Name: If a repository name was not provided in the inputs, suggest 5 suitable names based on the script analysis and ask the user to choose one. Confirm the final name before proceeding.
Output Generation:
 * Generate the README.md file according to the structure specified below.
 * For each script provided, generate a corresponding /docs/[script_filename_base].md file using the specified structure.
📄 README.md Structure
Generate a README.md file with the following sections, populating content based on the inputs and script analysis:
1. Title
 * Use the chosen Repository Name.
2. Badges (Optional but Recommended)
 * Consider adding relevant badges (e.g., License, Build Status if applicable later). Self-correction: Add basic license badge.
   [![License: GPL v3](https://www.google.com/search?q=https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

3. Description
 * Write a concise overview of the repository's purpose, the problem it solves, and its key features, informed by the script analysis. Mention the primary language(s) used.
4. Installation
 * Provide instructions using Mamba (Conda).
 * Use the Repository Name to create a unique environment name (e.g., [RepositoryName]_env).
 * Include commands to create the environment, specifying the target Python/R versions (use defaults if not provided).
 * List the Mamba commands to install the inferred dependencies for both R and Python (as applicable), specifying -c conda-forge where appropriate.
 * Recommend installing Mamba via Mambaforge/Miniforge: See [Mamba documentation](https://mamba.readthedocs.io/en/latest/installation.html) for installation instructions.
 * Example Structure:
   ## Installation

We recommend using the Mamba package manager for environment management. See [Mamba documentation](https://mamba.readthedocs.io/en/latest/installation.html) for installation options (like Mambaforge).

1.  **Create and activate the Conda environment:**
    ```sh
    # Replace [python_version] and [r_version] with desired versions if needed
    mamba create -n [RepositoryName]_env python=[python_version] r-base=[r_version] -y
    mamba activate [RepositoryName]_env
    ```

2.  **Install required packages:**
    ```sh
    # Install R packages (example)
    mamba install [inferred_r_package_1] [inferred_r_package_2] -c conda-forge

    # Install Python packages (example)
    mamba install [inferred_python_package_1] [inferred_python_package_2] -c conda-forge
    ```

5. Requirements
 * List the primary requirements.
 * Operating System: Infer general compatibility (e.g., Linux, macOS - mention if Windows is known to be problematic or untested).
 * Software: Mamba (Conda).
 * Packages: List the key R and/or Python packages inferred from the scripts, potentially with versions if easily determined or specified in the environment creation.
6. Usage
 * Provide clear examples of how to run the main script(s).
 * Derive example commands based on the script's identified command-line arguments. Use realistic placeholder values for arguments (e.g., input.csv, output_directory).
 * If multiple core scripts exist, provide examples for each.
 * Structure:
   ## Usage

Below are example commands for running the scripts:

### Running `[script_filename_1.ext]`
```sh
[python or Rscript] scripts/[script_filename_1.ext] --[inferred_arg1] [value1] --[inferred_arg2] [value2]
```

   Briefly explain what this command does based on script analysis.
   Running [script_filename_2.ext]
   [python or Rscript] scripts/[script_filename_2.ext] --[inferred_argA] [valueA] ...

   Briefly explain what this command does.

7. Project Structure
 * Illustrate the typical directory layout. Adapt based on the provided scripts (e.g., only include R/Python specific elements if applicable).
   ## Project Structure

   📂 [RepositoryName]/
   ├── 📁 data/               # Example or placeholder input data
   ├── 📁 docs/               # Detailed documentation for each script
   │   └── 📜 [script_filename_base].md
   ├── 📁 scripts/            # Source code for the tools
   │   └── 📜 [script_filename_1.ext]
   ├── 📜 .gitignore          # Specifies intentionally untracked files git should ignore
   ├── 📜 LICENSE             # [License Name, e.g., GNU GPLv3] License file
   └── 📜 README.md           # This file
   
8. Contributing
 * Include standard contribution guidelines (Fork, Branch, Commit, PR). Mention issue tracking on GitHub.
9. License
 * State the license clearly, linking to the license file or URL. Use the default setting unless overridden.
   ## License

This project is licensed under the terms of the [License Name]. See the [LICENSE](LICENSE) file for details or visit [License URL].
Copyright (c) [Current Year], [GitHub Organization / Developer Name]

10. Contact
 * Provide contact information or point to the GitHub repository for issues/questions.
   ## Contact

For questions, bug reports, or feature requests, please open an issue on the [GitHub Repository Issues page](https://github.com/[GitHub Organization]/[RepositoryName]/issues).
Maintained by: [Developer Name / Maintainer] ([GitHub Organization Link])

📖 /docs/[script_filename_base].md Structure
For each provided script (e.g., scripts/process_data.py), generate a corresponding documentation file (e.g., docs/process_data.md) with the following sections:
1. Tool Name
 * Use the base name of the script file (e.g., process_data.py).
2. Purpose
 * Analyze the script's code and comments/docstrings to provide a clear, concise description of what the script does.
3. Inputs & Outputs
 * Inputs:
   * Arguments: List the command-line arguments identified from the script's argument parser (argparse, optparse, etc.). Include their names, expected data types (if discernible), and descriptions (from the parser's help text).
   * Input Files: Describe the expected format of any input files (e.g., "CSV file with columns 'ID', 'Date', 'Value'").
 * Outputs: Describe the files or results generated by the script (e.g., "Outputs a processed CSV file to the specified output directory," "Generates a plot named 'result.png'").
4. Usage Example
 * Provide a specific, detailed command-line example for this script, using its actual arguments derived during analysis. Explain the example.
5. Best Practices / Notes
 * (Optional but helpful) Include any tips for using the script effectively, potential limitations, or important assumptions based on script analysis (e.g., "Ensure input data is sorted by date," "Requires at least 8GB RAM for large datasets").
6. Error Handling / Troubleshooting
 * (Optional but helpful) List any common errors users might encounter and suggest solutions (e.g., "FileNotFoundError: Check input file path," "MemoryError: Try processing data in chunks or use a machine with more RAM"). This may require more sophisticated analysis or common patterns.
Proceed with generating the documentation once the Repository Name is confirmed.

