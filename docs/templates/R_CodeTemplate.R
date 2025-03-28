###############################################################################
# Script Title:
# Purpose: [A concise description of what this script does]
# Author: [Your Name]
# Date Created: [YYYY-MM-DD]
# Date Last Modified: [YYYY-MM-DD]
# Usage: Rscript your_script_name.R [options]
# Example: Rscript your_script_name.R --input data.csv --output results.txt
# Input Data:
#   -
#   - [Description of input data 2, if any]
# Output Data:
#   - [Description of output data 1, e.g., Path to output text file containing results]
#   - [Description of output data 2, if any]
# Dependencies:
#   - R version: [e.g., 4.3.0]
#   - Packages: [List required packages, e.g., optparse, dplyr, ggplot2]
###############################################################################

#------------------------------------------------------------------------------
# Library Management: Install and load required packages
#------------------------------------------------------------------------------
# List of required packages
required_packages <- c(
    "optparse" # For handling command-line arguments
    # Add other packages as needed, e.g., "dplyr", "ggplot2"
)

# Function to check if a package is installed
is_installed <- function(pkg) {
    is.element(pkg, installed.packages()[, 1])
}

# Install missing packages
for (pkg in required_packages) {
    if (!is_installed(pkg)) {
        message(paste("Installing package:", pkg))
        install.packages(pkg, repos = "https://cloud.r-project.org")
    }
}

# Load required packages
for (pkg in required_packages) {
    library(pkg, character.only = TRUE)
    message(paste("Package loaded:", pkg))
}

#------------------------------------------------------------------------------
# Parameter Initialization: Set up command-line options using optparse
#------------------------------------------------------------------------------
# Define command-line options
option_list <- list(
    make_option(c("-i", "--input"),
        type = "character", default = NULL,
        help = "Path to the input file", metavar = "character"
    ),
    make_option(c("-o", "--output"),
        type = "character", default = "output.txt",
        help = "Path to the output file [default= %default]", metavar = "character"
    ),
    make_option(c("-p", "--parameter"),
        type = "numeric", default = 10,
        help = "A numeric parameter [default= %default]", metavar = "numeric"
    ),
    make_option(c("-v", "--verbose"),
        action = "store_true", default = TRUE,
        help = "Print extra output [default= %default]"
    ),
    make_option(c("-q", "--quiet"),
        action = "store_false", dest = "verbose",
        help = "Print little output"
    )
)

# Parse command-line arguments
opt_parser <- OptionParser(
    option_list = option_list,
    usage = "Usage: Rscript %prog [options]"
)
opt <- parse_args(opt_parser)

# Check if required arguments are provided
if (is.null(opt$input)) {
    print_help(opt_parser)
    stop("Input file path must be provided.", call. = FALSE)
}

# Assign options to variables for easier use
input_file <- opt$input
output_file <- opt$output
numeric_parameter <- opt$parameter
verbose_output <- opt$verbose

#------------------------------------------------------------------------------
# Verbose Messaging Functionality
#------------------------------------------------------------------------------
# Define a helper function for verbose messaging based on --verbose flag
vmsg <- function(...) {
    if (verbose_output) message(...)
}

#------------------------------------------------------------------------------
# Optional: Print the values of the parameters if verbose output is enabled
#------------------------------------------------------------------------------
vmsg("-------------------------------------------------------------------------------")
vmsg("Script Parameters:")
vmsg(paste("Input file:", input_file))
vmsg(paste("Output file:", output_file))
vmsg(paste("Numeric parameter:", numeric_parameter))
vmsg("-------------------------------------------------------------------------------")

#------------------------------------------------------------------------------
# Main Code Logic: Perform the core computations and analysis
#------------------------------------------------------------------------------
# Start of the main analysis
message("Starting the main analysis...")

# Example: Load the input data
tryCatch(
    {
        data <- read.csv(input_file)
        vmsg(paste("Successfully loaded data from:", input_file))
        vmsg(paste("Number of rows in the data:", nrow(data)))
    },
    error = function(e) {
        stop(paste("Error loading input data:", e$message), call. = FALSE)
    }
)

# Example: Perform some operation based on the numeric parameter
vmsg(paste("Performing operation with parameter:", numeric_parameter))
results <- data.frame(
    original_value = 1:nrow(data),
    modified_value = (1:nrow(data)) * numeric_parameter
)

# Example: Further analysis or processing
vmsg("Performing further analysis...")
final_results <- cbind(data, results)

#------------------------------------------------------------------------------
# Output Section: Save and document the results
#------------------------------------------------------------------------------
# Save the results to the specified output file
tryCatch(
    {
        write.table(final_results, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE)
        vmsg(paste("Results successfully saved to:", output_file))
    },
    error = function(e) {
        stop(paste("Error writing output to file:", e$message), call. = FALSE)
    }
)

#------------------------------------------------------------------------------
# Optional: Print a summary of the results
#------------------------------------------------------------------------------
vmsg("-------------------------------------------------------------------------------")
vmsg("Summary of Results:")
print(head(final_results))
vmsg("-------------------------------------------------------------------------------")

#------------------------------------------------------------------------------
# Session Information: Record the R environment for reproducibility
#------------------------------------------------------------------------------
message("-------------------------------------------------------------------------------")
message("Session Information:")
sessionInfo()
message("-------------------------------------------------------------------------------")

# End of script message
message("Script execution completed successfully.")
