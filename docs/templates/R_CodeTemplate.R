###############################################################################
# Script Title: [Your Script Title]
# Purpose: [A concise description of what this script does, e.g., Analyze dataset X to generate report Y]
# Author: [Your Name/Team]
# Date Created: [YYYY-MM-DD]
# Date Last Modified: [YYYY-MM-DD] # <-- Keep this updated!
# Version: [e.g., 1.0.0] # <-- Optional: Add versioning
#
# Usage: Rscript your_script_name.R [options]
# Example: Rscript your_script_name.R --input data/raw/input.csv --output results/processed_data.tsv --param_value 50 --seed 42
#
# Input Data:
#   - --input: Path to the primary input file (e.g., CSV, TSV). [Specify format expected]
#   - [Optional: Describe other inputs if necessary]
#
# Output Data:
#   - --output: Path to the primary output file (e.g., TSV, RDS). [Specify format created]
#   - [Optional: Describe other outputs if necessary]
#
# Dependencies:
#   - R version: [e.g., 4.3.0 or higher]
#   - Packages: [List required packages, e.g., optparse, dplyr, readr, ggplot2]
#   - Environment: [Optional: Mention if specific environment variables or external tools are needed]
###############################################################################

#------------------------------------------------------------------------------
# Environment Setup: Options, Variables
#------------------------------------------------------------------------------
# Prevent scientific notation in output files
options(scipen = 999)
# Set timezone (optional, but good for consistency if handling dates/times)
# Sys.setenv(TZ='UTC')

#------------------------------------------------------------------------------
# Library Management: Install and load required packages
#------------------------------------------------------------------------------
message("Loading required packages...")

# List of required packages - Adjust this list for your specific script needs
required_packages <- c(
    "optparse", # For handling command-line arguments
    "readr"    # Often faster and more robust for reading rectangular data (CSV/TSV)
    # "dplyr",   # Common for data manipulation
    # "ggplot2", # Common for plotting
    # "tidyr"    # Common for data tidying
)

# Install missing packages if necessary
for (pkg in required_packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
        message("Installing package: ", pkg)
        install.packages(pkg, repos = "https://cloud.r-project.org")
    }
    # Load required packages
    # Use require() or library() - require() is often used in scripts for its boolean return
    if (require(pkg, character.only = TRUE, quietly = TRUE)) {
        message("- ", pkg, " loaded.")
    } else {
        stop("Failed to load package: ", pkg, call. = FALSE)
    }
}
message("Package loading complete.")

#------------------------------------------------------------------------------
# Parameter Initialization: Set up command-line options using optparse
#------------------------------------------------------------------------------
option_list <- list(
    make_option(c("-i", "--input"),
        type = "character", default = NULL,
        help = "REQUIRED: Path to the primary input data file.", metavar = "FILE"
    ),
    make_option(c("-o", "--output"),
        type = "character", default = "output.tsv", # Sensible default, maybe TSV?
        help = "Path to the primary output file [default= %default].", metavar = "FILE"
    ),
    # Add more specific parameter names instead of generic ones
    make_option(c("-p", "--param_value"), # Renamed for clarity
        type = "numeric", default = 10,
        help = "Example numeric parameter affecting analysis [default= %default].", metavar = "NUMBER"
    ),
    make_option(c("-s", "--seed"),
        type = "integer", default = NULL, # Default to NULL, set later if needed
        help = "Random seed for reproducibility (optional).", metavar = "INTEGER"
    ),
    make_option(c("-v", "--verbose"),
        action = "store_true", default = TRUE,
        help = "Print detailed execution messages [default= %default]."
    ),
    make_option(c("-q", "--quiet"),
        action = "store_false", dest = "verbose",
        help = "Suppress detailed execution messages."
    )
    # Add other options specific to your script here
)

# Parse command-line arguments
opt_parser <- OptionParser(
    option_list = option_list,
    usage = "Usage: Rscript %prog --input <INPUT_FILE> --output <OUTPUT_FILE> [options]",
    description = "Description: [A concise description of what this script does, matching the header purpose.]" # Add description
)
opt <- parse_args(opt_parser)

#------------------------------------------------------------------------------
# Parameter Validation & Processing
#------------------------------------------------------------------------------
message("Validating parameters...")

# Check required arguments
if (is.null(opt$input)) {
    message("ERROR: Input file path ('--input') must be provided.")
    print_help(opt_parser)
    stop("Missing required argument.", call. = FALSE)
}

# Check if input file exists
if (!file.exists(opt$input)) {
    stop("Input file not found: ", opt$input, call. = FALSE)
}

# Check numeric parameter validity (example)
if (!is.numeric(opt$param_value) || opt$param_value <= 0) {
    stop("--param_value must be a positive number.", call. = FALSE)
}

# Assign options to more readable variables
input_file      <- opt$input
output_file     <- opt$output
param_value     <- opt$param_value
seed_value      <- opt$seed
verbose_output  <- opt$verbose

# --- Handle Random Seed ---
# Set seed if provided, otherwise, potentially generate one and report it
if (!is.null(seed_value)) {
    if (!is.integer(seed_value)) {
      stop("--seed must be an integer.", call. = FALSE)
    }
    set.seed(seed_value)
    message("Random seed set to: ", seed_value)
} else {
    # If the script involves randomness, it's good practice to always set a seed
    # You might want to generate one if not provided, e.g., based on time
    # Or simply warn the user if randomness is critical
    message("NOTE: No random seed provided via --seed.")
    # set.seed(as.integer(Sys.time())) # Example: set seed based on time if none provided
}

#------------------------------------------------------------------------------
# Verbose Messaging & Timestamp Functionality
#------------------------------------------------------------------------------
# Define a helper function for verbose messaging
vmsg <- function(...) {
    if (verbose_output) {
        # Optional: Add timestamp to verbose messages
        timestamp <- format(Sys.time(), "[%Y-%m-%d %H:%M:%S] ")
        message(timestamp, ...)
    }
}

# Function for mandatory messages (can also include timestamp)
msg <- function(...) {
     timestamp <- format(Sys.time(), "[%Y-%m-%d %H:%M:%S] ")
     message(timestamp, ...)
}


#------------------------------------------------------------------------------
# Output Directory Preparation (Optional)
#------------------------------------------------------------------------------
output_dir <- dirname(output_file)
if (!dir.exists(output_dir)) {
    vmsg("Output directory does not exist: ", output_dir)
    vmsg("Creating output directory...")
    tryCatch({
        dir.create(output_dir, recursive = TRUE)
        vmsg("Output directory created successfully.")
    }, error = function(e) {
        stop("Failed to create output directory '", output_dir, "': ", e$message, call. = FALSE)
    })
}

#------------------------------------------------------------------------------
# Print Parameters (if verbose)
#------------------------------------------------------------------------------
vmsg("---------------- Script Parameters ----------------")
vmsg("Input file      : ", input_file)
vmsg("Output file     : ", output_file)
vmsg("Parameter Value : ", param_value)
vmsg("Seed            : ", ifelse(is.null(seed_value), "Not Set", seed_value))
vmsg("Verbose Output  : ", verbose_output)
vmsg("---------------------------------------------------")

###############################################################################
# MAIN EXECUTION LOGIC
###############################################################################

#------------------------------------------------------------------------------
# Define Functions (Optional but Recommended for Complex Logic)
#------------------------------------------------------------------------------
# Example function structure
# process_data <- function(df, parameter) {
#     vmsg("Entering process_data function...")
#     # ... processing steps ...
#     modified_df <- df * parameter # Example operation
#     vmsg("Exiting process_data function.")
#     return(modified_df)
# }

#------------------------------------------------------------------------------
# Data Loading
#------------------------------------------------------------------------------
msg("Loading input data from: ", input_file)
tryCatch(
    {
        # Use readr for potentially faster/better CSV/TSV reading
        # Adjust reader function based on expected input format (read_csv, read_tsv, readRDS etc.)
        data <- readr::read_csv(input_file, show_col_types = FALSE) # Use read_tsv for TSV
        msg("Data loaded successfully.")
        vmsg("Number of rows: ", nrow(data), ", Number of columns: ", ncol(data))
        vmsg("Column names: ", paste(colnames(data), collapse=", "))
    },
    error = function(e) {
        stop("Fatal Error: Could not load input data from '", input_file, "'. Details: ", e$message, call. = FALSE)
    }
)

#------------------------------------------------------------------------------
# Data Processing / Analysis
#------------------------------------------------------------------------------
# Start of the main analysis steps
msg("Starting core analysis...")

# Example: Perform some operation using the parameter
# Consider using functions here for complex steps (e.g., results <- process_data(data, param_value))
vmsg("Performing operation with parameter: ", param_value)
# Ensure column types are appropriate for operations
# Example assumes numeric data - add checks/conversions if needed
results <- data * param_value # Placeholder operation

# Example: Further analysis or processing
vmsg("Performing further steps...")
# Combine original data with results (ensure this makes sense for your analysis)
# Might need checks for matching dimensions or use joins if appropriate
final_results <- cbind(data, results) # Placeholder combination
colnames(final_results) <- c(colnames(data), paste0(colnames(results), "_modified")) # Example renaming

msg("Core analysis finished.")

#------------------------------------------------------------------------------
# Output Generation
#------------------------------------------------------------------------------
msg("Saving results to: ", output_file)

# Save the results
tryCatch(
    {
        # Adjust writer function based on desired output format (write_csv, write_tsv, saveRDS etc.)
        readr::write_tsv(final_results, output_file, na = "") # Example: writing TSV
        msg("Results saved successfully.")
    },
    error = function(e) {
        # Use 'msg' or 'stop' depending on severity. Stop is usually appropriate here.
        stop("Fatal Error: Could not write output to '", output_file, "'. Details: ", e$message, call. = FALSE)
    }
)

# Optional: Generate plots or other output files here

#------------------------------------------------------------------------------
# Results Summary (Optional, if verbose)
#------------------------------------------------------------------------------
if (verbose_output) {
    vmsg("----------------- Results Summary -----------------")
    # Use print(), summary(), str(), or custom summaries as needed
    vmsg("First few rows of the output:")
    print(head(final_results))
    vmsg("Output dimensions: ", paste(dim(final_results), collapse=" x "))
    vmsg("---------------------------------------------------")
}

###############################################################################
# Finalization
###############################################################################

#------------------------------------------------------------------------------
# Session Information
#------------------------------------------------------------------------------
# Always good practice to record the environment
msg("---------------- Session Information ----------------")
sessionInfo()
msg("---------------------------------------------------")

# End of script message
msg("Script execution completed successfully.")
# q(status=0) # Optional: Explicitly exit with success status
