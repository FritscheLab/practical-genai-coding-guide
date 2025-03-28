###############################################################################
# Script Title: Simulate EHR Data
# Purpose: Simulate electronic health record (EHR) data including BMI, height, weight,
#          and demographics, while injecting data quality issues for downstream analysis.
# Author: Lars Fritsche
# Date Created: 2025-03-26
# Date Last Modified: 2025-03-26
# Usage: Rscript scripts/simulate_ehr_data.R [options]
# Example:
# Rscript scripts/simulate_ehr_data.R
#    --output_ehr "./data/raw/ehr_bmi_simulated_data.tsv"
#    --output_ehr_dict "./data/raw/data_dictionary.txt"
#    --output_demo "./data/raw/demographics_simulated_data.tsv"
#    --output_demo_dict "./data/raw/demographics_data_dictionary.txt"
#    --seed 123
#    --n_individuals 1000
#
# Input Data: None (data is simulated within the script)
# Output Data:
#   - EHR dataset: Simulated EHR data with anthropometric measurements.
#   - Data dictionary: Description of variables in the EHR dataset.
#   - Demographics dataset: Simulated patient demographics.
#   - Demographics data dictionary: Description of variables in the demographics dataset.
# Dependencies:
#   - R version: 4.3.0 or higher
#   - Packages: optparse
###############################################################################

#------------------------------------------------------------------------------
# Library Management: Install and load required packages
#------------------------------------------------------------------------------
required_packages <- c("optparse") # For handling command-line arguments

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
option_list <- list(
    make_option(c("--output_ehr"),
        type = "character", default = "./data/ehr_bmi_simulated_data.tsv",
        help = "Path to the EHR output TSV file [default= %default]", metavar = "character"
    ),
    make_option(c("--output_ehr_dict"),
        type = "character", default = "./data/data_dictionary.txt",
        help = "Path to the EHR data dictionary file [default= %default]", metavar = "character"
    ),
    make_option(c("--output_demo"),
        type = "character", default = "./data/demographics_simulated_data.tsv",
        help = "Path to the demographics output TSV file [default= %default]", metavar = "character"
    ),
    make_option(c("--output_demo_dict"),
        type = "character", default = "./data/demographics_data_dictionary.txt",
        help = "Path to the demographics data dictionary file [default= %default]", metavar = "character"
    ),
    make_option(c("--seed"),
        type = "numeric", default = 123,
        help = "Random seed for reproducibility [default= %default]", metavar = "numeric"
    ),
    make_option(c("--n_individuals"),
        type = "numeric", default = 1000,
        help = "Number of unique individuals to simulate [default= %default]", metavar = "numeric"
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

opt_parser <- OptionParser(
    option_list = option_list,
    usage = "Usage: Rscript %prog [options]"
)
opt <- parse_args(opt_parser)

# Assign options to variables for easier use
output_ehr <- opt$output_ehr
output_ehr_dict <- opt$output_ehr_dict
output_demo <- opt$output_demo
output_demo_dict <- opt$output_demo_dict
seed_val <- opt$seed
n_individuals <- opt$n_individuals
verbose_output <- opt$verbose

#------------------------------------------------------------------------------
# Verbose Messaging Functionality
#------------------------------------------------------------------------------
vmsg <- function(...) {
    if (verbose_output) message(...)
}

#------------------------------------------------------------------------------
# Check and Prepare Output Directory
#------------------------------------------------------------------------------
# Ensure that the directories for output files exist; create them if missing
output_dirs <- unique(dirname(c(output_ehr, output_ehr_dict, output_demo, output_demo_dict)))
for (dir in output_dirs) {
    if (!dir.exists(dir)) {
        message(paste("Output directory", dir, "does not exist. Creating directory..."))
        dir.create(dir, recursive = TRUE)
    }
}

#------------------------------------------------------------------------------
# Main Code Logic: Simulate EHR and Demographics Data
#------------------------------------------------------------------------------
message("Starting simulation of EHR and demographics data...")

# -----------------------------
# Simulation Parameters Setup
# -----------------------------
# Set seed for reproducibility and define simulation parameters
set.seed(seed_val)
vmsg(paste("Random seed set to:", seed_val))

min_records_per_person <- 50 # Minimum measurements per individual
max_records_per_person <- 150 # Maximum measurements per individual
max_years <- 10 # Maximum span of years for measurements

# Define ID format parameters
person_id_length <- 12 # Length of hashed person_id strings
encounter_id_length <- 12 # Length of hashed encounter_id strings
id_charset <- c(0:9, LETTERS, letters) # Characters for IDs (digits + letters)

# -----------------------------
# Generate Unique Person IDs
# -----------------------------
vmsg("Generating unique person IDs...")
person_ids <- replicate(n_individuals, paste(sample(id_charset, person_id_length, replace = TRUE), collapse = ""))
# Ensure uniqueness by regenerating any duplicates (though unlikely)
if (length(unique(person_ids)) < n_individuals) {
    dup_idx <- duplicated(person_ids)
    person_ids[dup_idx] <- replicate(sum(dup_idx), paste(sample(id_charset, person_id_length, replace = TRUE), collapse = ""))
}

# -----------------------------
# Simulate Measurements for Each Person
# -----------------------------
vmsg("Simulating measurements for each individual...")

# Functions to generate plausible base height and BMI values
generate_height <- function() {
    h <- rnorm(1, mean = 170, sd = 10)
    # Enforce plausible adult height range
    while (h < 130 || h > 210) {
        h <- rnorm(1, mean = 170, sd = 10)
    }
    return(round(h)) # Round to nearest cm
}

generate_bmi <- function() {
    b <- rnorm(1, mean = 26, sd = 6)
    # Enforce plausible BMI range
    while (b < 15 || b > 50) {
        b <- rnorm(1, mean = 26, sd = 6)
    }
    return(b)
}

# Initialize list to collect records for each individual
records_list <- vector("list", n_individuals)

for (i in 1:n_individuals) {
    # Determine a random number of records for the individual
    n_rec <- sample(min_records_per_person:max_records_per_person, 1)
    pid <- person_ids[i]

    # Generate stable attributes for the individual
    height_cm_base <- generate_height()
    bmi_base <- generate_bmi()
    weight_kg_base <- bmi_base * (height_cm_base / 100)^2 # Derive weight from BMI and height
    yearly_weight_change <- rnorm(1, mean = 0.2, sd = 0.5) # Annual weight change (kg/year)

    # Determine the measurement date range
    start_date <- as.Date("2010-01-01") + sample(0:(365 * (max_years - 1)), 1)
    span_days <- sample(0:(365 * max_years), 1)
    span_days <- max(span_days, n_rec - 1) # Ensure span is sufficient
    end_date <- start_date + span_days
    if (end_date > as.Date("2019-12-31")) {
        end_date <- as.Date("2019-12-31")
    }
    all_dates <- seq.Date(start_date, end_date, by = "day")
    # Sample measurement dates (with replacement to allow duplicates)
    measurement_dates <- sample(all_dates, size = n_rec, replace = TRUE)

    # Initialize data frame for the individual's records
    person_df <- data.frame(
        person_id        = pid,
        measurement_date = measurement_dates,
        height_cm        = numeric(n_rec),
        weight_kg        = numeric(n_rec),
        bmi              = numeric(n_rec)
    )

    # Order records chronologically to simulate realistic trends, then revert to original order
    ord <- order(person_df$measurement_date)
    sorted_dates <- person_df$measurement_date[ord]

    for (j in seq_along(sorted_dates)) {
        date_j <- sorted_dates[j]
        # Calculate elapsed years since the start date
        years_since_start <- as.numeric(difftime(date_j, start_date, units = "days")) / 365

        # Simulate height with occasional ±1 cm measurement error
        if (runif(1) < 0.1) {
            height_val <- height_cm_base + sample(c(-1, 1), 1)
        } else {
            height_val <- height_cm_base
        }

        # Simulate weight as baseline plus trend and short-term fluctuation
        expected_weight <- weight_kg_base + yearly_weight_change * years_since_start
        weight_val <- expected_weight + rnorm(1, mean = 0, sd = 2)
        if (weight_val < 0) weight_val <- 0

        # Calculate BMI from the current height and weight
        bmi_val <- ifelse(height_val > 0, weight_val / ((height_val / 100)^2), NA)

        # Assign computed values back to the record (restore original order)
        person_df$height_cm[ord[j]] <- height_val
        person_df$weight_kg[ord[j]] <- weight_val
        person_df$bmi[ord[j]] <- bmi_val
    }

    # Round values to appropriate precision
    person_df$height_cm <- round(person_df$height_cm)
    person_df$weight_kg <- round(person_df$weight_kg, 1)
    person_df$bmi <- round(person_df$bmi, 1)

    records_list[[i]] <- person_df
}

# Combine all individuals' records into one data frame
ehr_data <- do.call(rbind, records_list)
total_records <- nrow(ehr_data)
vmsg(paste("Total EHR records simulated:", total_records))

# -----------------------------
# Inject Data Quality Issues
# -----------------------------
vmsg("Injecting data quality issues into EHR data...")
n <- total_records

# 1. Introduce missing values in height, weight, or BMI
height_missing_idx <- sample(1:n, size = floor(0.10 * n)) # ~10% missing height
weight_missing_idx <- sample(1:n, size = floor(0.05 * n)) # ~5% missing weight
ehr_data$height_cm[height_missing_idx] <- NA
ehr_data$weight_kg[weight_missing_idx] <- NA
ehr_data$bmi[weight_missing_idx] <- NA
# Additional missing BMI values (~3%) where height and weight are present
bmi_missing_idx <- sample(setdiff(1:n, weight_missing_idx), size = floor(0.03 * n))
ehr_data$bmi[bmi_missing_idx] <- NA

# 2. Inject implausible anthropometric values (outliers)
# Height outliers: <100 cm or >250 cm
valid_idx <- which(!is.na(ehr_data$height_cm))
height_outlier_idx <- sample(valid_idx, size = floor(0.01 * n)) # 1% outliers
h_n <- length(height_outlier_idx)
if (h_n > 0) {
    low_half <- height_outlier_idx[1:floor(h_n / 2)]
    high_half <- height_outlier_idx[(floor(h_n / 2) + 1):h_n]

    if (length(low_half) > 0) {
        ehr_data$height_cm[low_half] <- sample(50:99, length(low_half), replace = TRUE)
    }
    if (length(high_half) > 0) {
        ehr_data$height_cm[high_half] <- sample(251:300, length(high_half), replace = TRUE)
    }
}

# Weight outliers: <25 kg or >300 kg
valid_idx <- which(!is.na(ehr_data$weight_kg))
weight_outlier_idx <- sample(setdiff(valid_idx, height_outlier_idx), size = floor(0.01 * n))
w_n <- length(weight_outlier_idx)
if (w_n > 0) {
    low_half <- weight_outlier_idx[1:floor(w_n / 2)]
    high_half <- weight_outlier_idx[(floor(w_n / 2) + 1):w_n]

    if (length(low_half) > 0) {
        ehr_data$weight_kg[low_half] <- runif(length(low_half), 10, 24.9)
    }
    if (length(high_half) > 0) {
        ehr_data$weight_kg[high_half] <- runif(length(high_half), 300.1, 500)
    }
}

# BMI outliers: <10 or >70
valid_idx <- which(!is.na(ehr_data$bmi))
bmi_outlier_idx <- sample(setdiff(valid_idx, c(height_outlier_idx, weight_outlier_idx)), size = floor(0.01 * n))
b_n <- length(bmi_outlier_idx)
if (b_n > 0) {
    low_half <- bmi_outlier_idx[1:floor(b_n / 2)]
    high_half <- bmi_outlier_idx[(floor(b_n / 2) + 1):b_n]

    if (length(low_half) > 0) {
        ehr_data$bmi[low_half] <- runif(length(low_half), 5, 9.9)
    }
    if (length(high_half) > 0) {
        ehr_data$bmi[high_half] <- runif(length(high_half), 70.1, 100)
    }
}

# 3. Introduce BMI discrepancies (~5% mismatch)
clean_idx <- setdiff(
    1:n,
    c(
        height_missing_idx, weight_missing_idx, bmi_missing_idx,
        height_outlier_idx, weight_outlier_idx, bmi_outlier_idx
    )
)
mismatch_idx <- sample(clean_idx, size = floor(0.05 * n))
for (idx in mismatch_idx) {
    if (!is.na(ehr_data$height_cm[idx]) &&
        !is.na(ehr_data$weight_kg[idx]) &&
        !is.na(ehr_data$bmi[idx])) {
        orig_bmi <- ehr_data$bmi[idx]
        err <- rnorm(1, 0, 2) # Small random shift
        new_bmi <- orig_bmi + err
        if (new_bmi < 10) new_bmi <- 10
        if (new_bmi > 70) new_bmi <- 70
        ehr_data$bmi[idx] <- round(new_bmi, 1)
    }
}

# 4. Inject rare extreme or nonsensical outliers
extreme_idx <- sample(setdiff(clean_idx, mismatch_idx), size = 5)
if (length(extreme_idx) == 5) {
    ehr_data$height_cm[extreme_idx[1]] <- -5 # Negative height
    ehr_data$height_cm[extreme_idx[2]] <- 999 # Extremely tall height
    ehr_data$weight_kg[extreme_idx[3]] <- -10 # Negative weight
    ehr_data$weight_kg[extreme_idx[4]] <- 500 # Extremely high weight
    ehr_data$bmi[extreme_idx[5]] <- 100 # Extremely high BMI
}

# Ensure rounding consistency after injections
ehr_data$height_cm <- round(ehr_data$height_cm)
ehr_data$weight_kg <- round(ehr_data$weight_kg, 1)
ehr_data$bmi <- round(ehr_data$bmi, 1)

# -----------------------------
# Assign Encounter IDs
# -----------------------------
vmsg("Assigning encounter IDs to each record...")
encounter_ids <- replicate(total_records, paste(sample(id_charset, encounter_id_length, replace = TRUE), collapse = ""))
if (length(unique(encounter_ids)) < total_records) {
    dup_idx <- duplicated(encounter_ids)
    encounter_ids[dup_idx] <- replicate(sum(dup_idx), paste(sample(id_charset, encounter_id_length, replace = TRUE), collapse = ""))
}
ehr_data$encounter_id <- encounter_ids

# -----------------------------
# Convert Measurement Dates to Date-Time Format
# -----------------------------
vmsg("Converting measurement dates to date-time format...")
ehr_data$measurement_date <- as.POSIXct(ehr_data$measurement_date)
# Add a random time offset (0 to 86399 seconds) within each day
random_seconds <- runif(total_records, 0, 86400 - 1)
ehr_data$measurement_date <- ehr_data$measurement_date + random_seconds
# Format as 'YYYY-MM-DD HH:MM:SS'
ehr_data$measurement_date <- format(ehr_data$measurement_date, "%Y-%m-%d %H:%M:%S")
# Reorder columns for clarity
ehr_data <- ehr_data[, c("person_id", "encounter_id", "bmi", "height_cm", "weight_kg", "measurement_date")]

# -----------------------------
# Output: Write EHR Dataset and Data Dictionary
# -----------------------------
vmsg("Writing EHR dataset and data dictionary to files...")
# Write the simulated EHR dataset to a TSV file
tryCatch(
    {
        write.table(ehr_data, file = output_ehr, sep = "\t", quote = FALSE, row.names = FALSE)
        vmsg(paste("EHR dataset successfully saved to:", output_ehr))
    },
    error = function(e) {
        stop(paste("Error writing EHR dataset:", e$message), call. = FALSE)
    }
)

# Write the EHR data dictionary to a text file
dict_lines <- c(
    "person_id: Hashed unique identifier for an individual (consistent across records).",
    "encounter_id: Hashed unique identifier for the encounter (unique per record).",
    "bmi: Body Mass Index (kg/m^2); may be missing, implausible, or inconsistent.",
    "height_cm: Height in centimeters; may be missing or implausible (<100 or >250).",
    "weight_kg: Weight in kilograms; may be missing or implausible (<25 or >300).",
    "measurement_date: Date-time of measurement (YYYY-MM-DD HH:MM:SS)."
)
tryCatch(
    {
        writeLines(dict_lines, con = output_ehr_dict)
        vmsg(paste("EHR data dictionary successfully saved to:", output_ehr_dict))
    },
    error = function(e) {
        stop(paste("Error writing EHR data dictionary:", e$message), call. = FALSE)
    }
)

# -----------------------------
# Generate Demographics Data
# -----------------------------
vmsg("Generating demographics data...")
n_demo <- n_individuals
dob_start <- as.Date("1930-01-01")
dob_end <- as.Date("2000-12-31")
date_of_birth <- sample(seq.Date(dob_start, dob_end, by = "day"), n_demo, replace = TRUE)

# Compute age as of a reference date (2019-12-31)
ref_date <- as.Date("2019-12-31")
age <- floor(as.numeric(difftime(ref_date, date_of_birth, units = "days")) / 365.25)
# Randomly set ~5% of ages to NA to simulate invalid entries
na_age_idx <- sample(1:n_demo, size = floor(0.05 * n_demo))
age[na_age_idx] <- NA

# Define age bins based on computed age
age_bin <- ifelse(is.na(age), NA,
    ifelse(age < 18, "<18",
        ifelse(age < 35, "18-34",
            ifelse(age < 55, "35-54",
                ifelse(age < 75, "55-74", "75+")
            )
        )
    )
)

# Simulate deceased status (10% chance of "Yes")
deceased <- sample(c("Yes", "No"), n_demo, replace = TRUE, prob = c(0.1, 0.9))

# Simulate race and convert specific values to NA
races <- c(
    "White", "Black", "Asian", "Native American", "Pacific Islander", "Other",
    "Patient Refused", "Unknown", ""
)
race_clean <- sample(races, n_demo, replace = TRUE, prob = c(0.4, 0.15, 0.1, 0.05, 0.05, 0.1, 0.05, 0.05, 0.05))
race_clean[race_clean %in% c("Patient Refused", "Unknown", "")] <- NA

# Simulate ethnicity and convert specific values to NA
ethnicities <- c("Hispanic", "Non-Hispanic", "Patient Refused", "Unknown", "")
ethnicity_clean <- sample(ethnicities, n_demo, replace = TRUE, prob = c(0.2, 0.7, 0.05, 0.03, 0.02))
ethnicity_clean[ethnicity_clean %in% c("Patient Refused", "Unknown", "")] <- NA

# Combine race and ethnicity when both are available
race_ethnicity <- ifelse(is.na(race_clean) | is.na(ethnicity_clean),
    NA,
    paste(race_clean, ethnicity_clean)
)
# Harmonize race and ethnicity into broader categories
race_ethnicity_harmonized <- sapply(seq_len(n_demo), function(i) {
    if (is.na(race_clean[i]) || is.na(ethnicity_clean[i])) {
        return(NA)
    } else if (ethnicity_clean[i] == "Hispanic") {
        return("Hispanic")
    } else if (race_clean[i] == "White") {
        return("Non-Hispanic White")
    } else if (race_clean[i] == "Black") {
        return("Non-Hispanic Black")
    } else if (race_clean[i] %in% c("Asian", "Native American", "Pacific Islander")) {
        return("Non-Hispanic Asian/Pacific Islander/Native American")
    } else {
        return("Other")
    }
})

# Simulate sex/gender
sex_gender <- sample(c("Male", "Female"), n_demo, replace = TRUE)

# Simulate marital status
marital_status_name <- sample(c("Single", "Married", "Divorced", "Widowed"),
    n_demo,
    replace = TRUE, prob = c(0.4, 0.4, 0.15, 0.05)
)

# Simulate a three-digit ZIP code (with leading zeros)
zip3 <- sprintf("%03d", sample(0:999, n_demo, replace = TRUE))

# Combine demographics into a data frame
demo_data <- data.frame(
    person_id = person_ids,
    date_of_birth = format(date_of_birth, "%Y-%m-%d"),
    age = age,
    age_bin = age_bin,
    deceased = deceased,
    race_clean = race_clean,
    ethnicity_clean = ethnicity_clean,
    race_ethnicity = race_ethnicity,
    race_ethnicity_harmonized = race_ethnicity_harmonized,
    sex_gender = sex_gender,
    marital_status_name = marital_status_name,
    zip3 = zip3,
    stringsAsFactors = FALSE
)

# Write the demographics dataset to a TSV file
tryCatch(
    {
        write.table(demo_data, file = output_demo, sep = "\t", quote = FALSE, row.names = FALSE)
        vmsg(paste("Demographics dataset successfully saved to:", output_demo))
    },
    error = function(e) {
        stop(paste("Error writing demographics dataset:", e$message), call. = FALSE)
    }
)

# Write the demographics data dictionary to a text file
demo_dict_lines <- c(
    "person_id: Unique identifier for the individual.",
    "date_of_birth: Birth date in YYYY-MM-DD format.",
    "age: Age in years as of 2019-12-31. May contain NA for invalid entries.",
    "age_bin: Age category (<18, 18-34, 35-54, 55-74, 75+).",
    "deceased: Indicator if the person is deceased (Yes/No).",
    "race_clean: Race (NA for 'Patient Refused', 'Unknown', or blank).",
    "ethnicity_clean: Ethnicity (NA for 'Patient Refused', 'Unknown', or blank).",
    "race_ethnicity: Combined race and ethnicity.",
    "race_ethnicity_harmonized: Harmonized classification (e.g., Non-Hispanic White, Non-Hispanic Black, Non-Hispanic Asian/Pacific Islander/Native American, Other).",
    "sex_gender: Sex/Gender of the individual.",
    "marital_status_name: Marital status.",
    "zip3: Three-digit ZIP code."
)
tryCatch(
    {
        writeLines(demo_dict_lines, con = output_demo_dict)
        vmsg(paste("Demographics data dictionary successfully saved to:", output_demo_dict))
    },
    error = function(e) {
        stop(paste("Error writing demographics data dictionary:", e$message), call. = FALSE)
    }
)

#------------------------------------------------------------------------------
# Session Information: Record the R environment for reproducibility
#------------------------------------------------------------------------------
message("-------------------------------------------------------------------------------")
message("Session Information:")
sessionInfo()
message("-------------------------------------------------------------------------------")

# End of script message
message("Script execution completed successfully.")
