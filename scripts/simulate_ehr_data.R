###############################################################################
# Script Title: Simulate EHR Data
# Purpose: Simulate electronic health record (EHR) data including BMI, height, weight,
#          and demographics, while injecting data quality issues for downstream analysis.
# Author: Lars Fritsche
# Date Created: 2025-03-26
# Date Last Modified: 2025-03-28 # <--- Updated modification date
# Usage: Rscript scripts/simulate_ehr_data.R [options]
# Example:
# Rscript scripts/simulate_ehr_data.R \
#    --output_ehr "./data/raw/ehr_bmi_simulated_data.tsv" \
#    --output_ehr_dict "./data/raw/data_dictionary.txt" \
#    --output_demo "./data/raw/demographics_simulated_data.tsv" \
#    --output_demo_dict "./data/raw/demographics_data_dictionary.txt" \
#    --seed 123 \
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

# Install missing packages if necessary
for (pkg in required_packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
        message("Installing package: ", pkg)
        install.packages(pkg, repos = "https://cloud.r-project.org")
    }
    # Load required packages
    library(pkg, character.only = TRUE)
    message("Package loaded: ", pkg)
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
        # Changed type to integer for better validation
        type = "integer", default = 1000,
        help = "Number of unique individuals to simulate [default= %default]", metavar = "integer"
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

# --- Input Validation ---
if (!is.integer(opt$n_individuals) || opt$n_individuals <= 0) {
    stop("--n_individuals must be a positive integer.", call. = FALSE)
}
if (!is.numeric(opt$seed)) {
     stop("--seed must be numeric.", call. = FALSE)
}
# --- End Input Validation ---

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
    # Use message directly, no need for paste
    if (verbose_output) message(...)
}

#------------------------------------------------------------------------------
# Check and Prepare Output Directory
#------------------------------------------------------------------------------
output_dirs <- unique(dirname(c(output_ehr, output_ehr_dict, output_demo, output_demo_dict)))
for (dir in output_dirs) {
    if (!dir.exists(dir)) {
        message("Output directory '", dir, "' does not exist. Creating directory...")
        dir.create(dir, recursive = TRUE)
    }
}

#------------------------------------------------------------------------------
# Simulation Parameters Setup
#------------------------------------------------------------------------------
# Set seed for reproducibility
set.seed(seed_val)
vmsg("Random seed set to: ", seed_val)

# --- General Simulation Parameters ---
min_records_per_person <- 50  # Minimum measurements per individual
max_records_per_person <- 150 # Maximum measurements per individual
max_years_span         <- 10  # Maximum span of years for measurements
ehr_start_date         <- as.Date("2010-01-01")
ehr_end_date           <- as.Date("2019-12-31")

# --- ID Generation Parameters ---
person_id_length    <- 12 # Length of hashed person_id strings
encounter_id_length <- 12 # Length of hashed encounter_id strings
id_charset          <- c(0:9, LETTERS, letters) # Characters for IDs

# --- Anthropometric Simulation Parameters ---
height_mean           <- 170 # cm
height_sd             <- 10  # cm
height_min_plausible  <- 130 # cm (used in generation)
height_max_plausible  <- 210 # cm (used in generation)
bmi_mean              <- 26  # kg/m^2
bmi_sd                <- 6   # kg/m^2
bmi_min_plausible     <- 15  # kg/m^2 (used in generation)
bmi_max_plausible     <- 50  # kg/m^2 (used in generation)
weight_change_mean    <- 0.2 # kg/year trend
weight_change_sd      <- 0.5 # kg/year trend SD
weight_noise_sd       <- 2.0 # kg short-term fluctuation SD
height_measurement_error_prob <- 0.1 # Probability of +/- 1cm error

# --- Data Quality Injection Parameters ---
# Missingness
prop_height_missing      <- 0.10
prop_weight_missing      <- 0.05
prop_bmi_missing_added <- 0.03 # Additional BMI missing (where H/W present)
# Implausible Outliers
prop_height_outliers     <- 0.01
prop_weight_outliers     <- 0.01
prop_bmi_outliers        <- 0.01
height_outlier_low_max   <- 99    # cm, values below this are outliers
height_outlier_high_min  <- 251   # cm, values above this are outliers
weight_outlier_low_max   <- 24.9  # kg, values below this are outliers
weight_outlier_high_min  <- 300.1 # kg, values above this are outliers
bmi_outlier_low_max      <- 9.9   # kg/m^2, values below this are outliers
bmi_outlier_high_min     <- 70.1  # kg/m^2, values above this are outliers
# BMI Mismatches
prop_bmi_mismatch        <- 0.05
bmi_mismatch_sd_error    <- 2.0   # SD of error added to create mismatch
# Extreme/Nonsensical Outliers
n_extreme_outliers       <- 5     # Fixed number of specific extreme errors

# --- Demographics Simulation Parameters ---
dob_min_date            <- as.Date("1930-01-01")
dob_max_date            <- as.Date("2000-12-31")
demographics_ref_date   <- as.Date("2019-12-31") # Date for age calculation
prop_age_missing        <- 0.05
prob_deceased           <- c(Yes = 0.1, No = 0.9)
race_categories         <- c("White", "Black", "Asian", "Native American", "Pacific Islander", "Other", "Patient Refused", "Unknown", "")
race_probs              <- c(0.4, 0.15, 0.1, 0.05, 0.05, 0.1, 0.05, 0.05, 0.05)
ethnicity_categories    <- c("Hispanic", "Non-Hispanic", "Patient Refused", "Unknown", "")
ethnicity_probs         <- c(0.2, 0.7, 0.05, 0.03, 0.02)
na_race_eth_values      <- c("Patient Refused", "Unknown", "") # Values to map to NA
sex_gender_categories   <- c("Male", "Female")
marital_status_categories <- c("Single", "Married", "Divorced", "Widowed")
marital_status_probs    <- c(0.4, 0.4, 0.15, 0.05)
zip3_min                <- 0
zip3_max                <- 999


#------------------------------------------------------------------------------
# Main Code Logic: Simulate EHR and Demographics Data
#------------------------------------------------------------------------------
message("Starting simulation of EHR and demographics data...")

# -----------------------------
# Generate Unique Person IDs
# -----------------------------
vmsg("Generating unique person IDs...")
person_ids <- replicate(n_individuals, paste(sample(id_charset, person_id_length, replace = TRUE), collapse = ""))
# Ensure uniqueness by regenerating any duplicates.
# Note: Collisions are extremely unlikely with these ID parameters but check is kept for robustness.
while (length(unique(person_ids)) < n_individuals) {
    vmsg("...regenerating duplicate person IDs (rare event)...")
    dup_idx <- duplicated(person_ids) | duplicated(person_ids, fromLast = TRUE)
    person_ids[dup_idx] <- replicate(sum(dup_idx), paste(sample(id_charset, person_id_length, replace = TRUE), collapse = ""))
}

# -----------------------------
# Simulate Measurements for Each Person
# -----------------------------
vmsg("Simulating measurements for each individual...")

# Functions to generate plausible base height and BMI values
generate_height <- function() {
    # Note: Could add max iterations for safety, but unlikely necessary here.
    h <- rnorm(1, mean = height_mean, sd = height_sd)
    while (h < height_min_plausible || h > height_max_plausible) {
        h <- rnorm(1, mean = height_mean, sd = height_sd)
    }
    return(round(h)) # Round to nearest cm
}

generate_bmi <- function() {
    # Note: Could add max iterations for safety, but unlikely necessary here.
    b <- rnorm(1, mean = bmi_mean, sd = bmi_sd)
    while (b < bmi_min_plausible || b > bmi_max_plausible) {
        b <- rnorm(1, mean = bmi_mean, sd = bmi_sd)
    }
    return(b)
}

# Initialize list to collect records for each individual
records_list <- vector("list", n_individuals)

for (i in 1:n_individuals) {
    if (i %% 100 == 0) vmsg("...simulating individual ", i, " of ", n_individuals) # Progress indicator

    # Determine a random number of records for the individual
    n_rec <- sample(min_records_per_person:max_records_per_person, 1)
    pid <- person_ids[i]

    # Generate stable attributes for the individual
    height_cm_base <- generate_height()
    bmi_base <- generate_bmi()
    weight_kg_base <- bmi_base * (height_cm_base / 100)^2 # Derive weight from BMI and height
    yearly_weight_change <- rnorm(1, mean = weight_change_mean, sd = weight_change_sd) # Annual weight change (kg/year)

    # Determine the measurement date range
    start_day_offset <- sample(0:(365 * (max_years_span - 1)), 1)
    person_start_date <- ehr_start_date + start_day_offset
    span_days <- sample(0:(365 * max_years_span), 1)
    span_days <- max(span_days, n_rec - 1) # Ensure span is sufficient for n_rec distinct days if needed
    person_end_date <- person_start_date + span_days
    if (person_end_date > ehr_end_date) {
        person_end_date <- ehr_end_date
    }
    # Ensure start date is not after end date if span is short or hits boundary
    if(person_start_date > person_end_date) person_start_date <- person_end_date

    # Sample measurement dates (with replacement to allow multiple per day initially)
    if(person_start_date == person_end_date) {
         all_dates <- person_start_date
    } else {
         all_dates <- seq.Date(person_start_date, person_end_date, by = "day")
    }
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
        # Calculate elapsed years since the start date for trend calculation
        years_since_start <- as.numeric(difftime(date_j, person_start_date, units = "days")) / 365.25

        # Simulate height with occasional +/- 1 cm measurement error
        if (runif(1) < height_measurement_error_prob) {
            height_val <- height_cm_base + sample(c(-1, 1), 1)
        } else {
            height_val <- height_cm_base
        }
        # Ensure height doesn't go below a reasonable minimum due to error
        if(height_val < height_min_plausible - 5) height_val <- height_min_plausible - 5

        # Simulate weight as baseline plus trend and short-term fluctuation
        expected_weight <- weight_kg_base + yearly_weight_change * years_since_start
        weight_val <- expected_weight + rnorm(1, mean = 0, sd = weight_noise_sd)
        if (weight_val < 0) weight_val <- 0 # Ensure weight is non-negative

        # Calculate BMI from the current height and weight
        # Use max(1, height_val) to avoid division by zero or negative heights
        bmi_val <- ifelse(height_val > 0, weight_val / ((height_val / 100)^2), NA)

        # Assign computed values back to the record (in the original sampled date order)
        person_df$height_cm[ord[j]] <- height_val
        person_df$weight_kg[ord[j]] <- weight_val
        person_df$bmi[ord[j]] <- bmi_val
    }

    # Round values to appropriate precision before storing
    person_df$height_cm <- round(person_df$height_cm)
    person_df$weight_kg <- round(person_df$weight_kg, 1)
    person_df$bmi <- round(person_df$bmi, 1)

    records_list[[i]] <- person_df
}

# Combine all individuals' records into one data frame
# Note: For very large n_individuals, consider data.table::rbindlist or dplyr::bind_rows
ehr_data <- do.call(rbind, records_list)
total_records <- nrow(ehr_data)
vmsg("Total EHR records simulated: ", total_records)

# -----------------------------
# Inject Data Quality Issues
# -----------------------------
vmsg("Injecting data quality issues into EHR data...")
n <- total_records # Use shorter alias

# 1. Introduce missing values
vmsg("...injecting missing values...")
height_missing_idx <- sample(1:n, size = floor(prop_height_missing * n))
weight_missing_idx <- sample(1:n, size = floor(prop_weight_missing * n))
ehr_data$height_cm[height_missing_idx] <- NA
ehr_data$weight_kg[weight_missing_idx] <- NA

# Add BMI missing where weight or height is missing, plus some extra
bmi_missing_from_hw <- which(is.na(ehr_data$height_cm) | is.na(ehr_data$weight_kg))
potential_bmi_missing_added <- setdiff(1:n, bmi_missing_from_hw)
bmi_missing_added_idx <- sample(potential_bmi_missing_added, size = floor(prop_bmi_missing_added * n))
ehr_data$bmi[union(bmi_missing_from_hw, bmi_missing_added_idx)] <- NA


# 2. Inject implausible anthropometric values (outliers)
vmsg("...injecting outlier values...")
# Height outliers
valid_h_idx <- which(!is.na(ehr_data$height_cm))
height_outlier_idx <- sample(valid_h_idx, size = floor(prop_height_outliers * n))
h_n <- length(height_outlier_idx)
if (h_n > 0) {
    low_h_idx <- sample(height_outlier_idx, size = floor(h_n / 2))
    high_h_idx <- setdiff(height_outlier_idx, low_h_idx)
    ehr_data$height_cm[low_h_idx] <- sample(50:height_outlier_low_max, length(low_h_idx), replace = TRUE)
    ehr_data$height_cm[high_h_idx] <- sample(height_outlier_high_min:300, length(high_h_idx), replace = TRUE)
}

# Weight outliers
valid_w_idx <- which(!is.na(ehr_data$weight_kg))
# Ensure we don't pick indices already used for height outliers if possible
potential_w_outlier_idx <- setdiff(valid_w_idx, height_outlier_idx)
weight_outlier_idx <- sample(potential_w_outlier_idx, size = floor(prop_weight_outliers * n))
w_n <- length(weight_outlier_idx)
if (w_n > 0) {
    low_w_idx <- sample(weight_outlier_idx, size = floor(w_n / 2))
    high_w_idx <- setdiff(weight_outlier_idx, low_w_idx)
    ehr_data$weight_kg[low_w_idx] <- round(runif(length(low_w_idx), 10, weight_outlier_low_max), 1)
    ehr_data$weight_kg[high_w_idx] <- round(runif(length(high_w_idx), weight_outlier_high_min, 500), 1)
}

# BMI outliers
valid_b_idx <- which(!is.na(ehr_data$bmi))
# Ensure we don't pick indices already used for height/weight outliers if possible
potential_b_outlier_idx <- setdiff(valid_b_idx, c(height_outlier_idx, weight_outlier_idx))
bmi_outlier_idx <- sample(potential_b_outlier_idx, size = floor(prop_bmi_outliers * n))
b_n <- length(bmi_outlier_idx)
if (b_n > 0) {
    low_b_idx <- sample(bmi_outlier_idx, size = floor(b_n / 2))
    high_b_idx <- setdiff(bmi_outlier_idx, low_b_idx)
    ehr_data$bmi[low_b_idx] <- round(runif(length(low_b_idx), 5, bmi_outlier_low_max), 1)
    ehr_data$bmi[high_b_idx] <- round(runif(length(high_b_idx), bmi_outlier_high_min, 100), 1)
}

# 3. Introduce BMI discrepancies (where BMI != calculated BMI)
vmsg("...injecting BMI calculation mismatches...")
# Identify rows with valid H, W, B that haven't been made outliers yet
all_outlier_or_missing_idx <- unique(c(
    which(is.na(ehr_data$height_cm)), which(is.na(ehr_data$weight_kg)), which(is.na(ehr_data$bmi)),
    height_outlier_idx, weight_outlier_idx, bmi_outlier_idx
))
clean_idx <- setdiff(1:n, all_outlier_or_missing_idx)
mismatch_idx <- sample(clean_idx, size = floor(prop_bmi_mismatch * n))

for (idx in mismatch_idx) {
    # Double check validity just in case (should be valid based on clean_idx)
    if (!is.na(ehr_data$height_cm[idx]) && ehr_data$height_cm[idx] > 0 &&
        !is.na(ehr_data$weight_kg[idx]) && ehr_data$weight_kg[idx] >= 0 &&
        !is.na(ehr_data$bmi[idx]))
    {
        orig_bmi <- ehr_data$bmi[idx]
        # Add a small error to the recorded BMI to create a mismatch
        err <- rnorm(1, mean = 0, sd = bmi_mismatch_sd_error)
        new_bmi <- orig_bmi + err
        # Keep the mismatched BMI within a broadly plausible range
        if (new_bmi < bmi_min_plausible - 5) new_bmi <- bmi_min_plausible - 5
        if (new_bmi > bmi_max_plausible + 20) new_bmi <- bmi_max_plausible + 20
        ehr_data$bmi[idx] <- round(new_bmi, 1)
    }
}

# 4. Inject rare extreme or nonsensical outliers
vmsg("...injecting extreme/nonsensical outliers...")
# Sample from indices not already heavily modified
potential_extreme_idx <- setdiff(clean_idx, mismatch_idx)
if(length(potential_extreme_idx) >= n_extreme_outliers && n_extreme_outliers > 0) {
    extreme_idx <- sample(potential_extreme_idx, size = n_extreme_outliers)
    # Assign specific nonsensical values to showcase different error types
    # Ensure indices are assigned sequentially if n_extreme_outliers < 5
    if(n_extreme_outliers >= 1) ehr_data$height_cm[extreme_idx[1]] <- -5    # Negative height
    if(n_extreme_outliers >= 2) ehr_data$height_cm[extreme_idx[2]] <- 999   # Very large height
    if(n_extreme_outliers >= 3) ehr_data$weight_kg[extreme_idx[3]] <- -10   # Negative weight
    if(n_extreme_outliers >= 4) ehr_data$weight_kg[extreme_idx[4]] <- 800   # Very large weight
    if(n_extreme_outliers >= 5) ehr_data$bmi[extreme_idx[5]]       <- 150   # Very large BMI
}

# Ensure rounding consistency after all injections
ehr_data$height_cm <- round(ehr_data$height_cm)
ehr_data$weight_kg <- round(ehr_data$weight_kg, 1)
ehr_data$bmi <- round(ehr_data$bmi, 1)

# -----------------------------
# Assign Encounter IDs
# -----------------------------
vmsg("Assigning encounter IDs to each record...")
encounter_ids <- replicate(total_records, paste(sample(id_charset, encounter_id_length, replace = TRUE), collapse = ""))
# Check for unlikely duplicates
while (length(unique(encounter_ids)) < total_records) {
    vmsg("...regenerating duplicate encounter IDs (rare event)...")
    dup_idx <- duplicated(encounter_ids) | duplicated(encounter_ids, fromLast = TRUE)
    encounter_ids[dup_idx] <- replicate(sum(dup_idx), paste(sample(id_charset, encounter_id_length, replace = TRUE), collapse = ""))
}
ehr_data$encounter_id <- encounter_ids

# -----------------------------
# Convert Measurement Dates to Date-Time Format
# -----------------------------
vmsg("Converting measurement dates to date-time format...")
# Convert Date objects to POSIXct at the start of the day
ehr_data$measurement_date <- as.POSIXct(as.Date(ehr_data$measurement_date))
# Add a random time offset (0 to 86399 seconds) within each day
random_seconds <- runif(total_records, 0, 86400 - 1)
ehr_data$measurement_date <- ehr_data$measurement_date + random_seconds
# Format as 'YYYY-MM-DD HH:MM:SS'
ehr_data$measurement_date <- format(ehr_data$measurement_date, "%Y-%m-%d %H:%M:%S")

# -----------------------------
# Reorder Columns for Final EHR Output
# -----------------------------
ehr_data <- ehr_data[, c("person_id", "encounter_id", "bmi", "height_cm", "weight_kg", "measurement_date")]

# -----------------------------
# Output: Write EHR Dataset and Data Dictionary
# -----------------------------
vmsg("Writing EHR dataset and data dictionary to files...")

# Write the simulated EHR dataset to a TSV file
tryCatch(
    {
        write.table(ehr_data, file = output_ehr, sep = "\t", quote = FALSE, row.names = FALSE, na = "")
        vmsg("EHR dataset successfully saved to: ", output_ehr)
    },
    error = function(e) {
        stop("Error writing EHR dataset to '", output_ehr, "': ", e$message, call. = FALSE)
    }
)

# --- Generate and Write EHR Data Dictionary ---
ehr_colnames <- colnames(ehr_data)
dict_descriptions_ehr <- c(
    # Descriptions MUST be in the same order as columns in ehr_data
    "Hashed unique identifier for an individual (consistent across records).",
    "Hashed unique identifier for the encounter (unique per record).",
    "Body Mass Index (kg/m^2); may be missing, implausible, inconsistent, or nonsensical.",
    "Height in centimeters; may be missing, implausible (<100 or >250), or nonsensical.",
    "Weight in kilograms; may be missing, implausible (<25 or >300), or nonsensical.",
    "Date and time of measurement (YYYY-MM-DD HH:MM:SS)."
)

if (length(ehr_colnames) == length(dict_descriptions_ehr)) {
     dict_lines_ehr <- paste0(ehr_colnames, ": ", dict_descriptions_ehr)
} else {
     warning("Mismatch between EHR column names and dictionary descriptions. Writing basic names only.")
     dict_lines_ehr <- paste0(ehr_colnames, ": [Description Mismatch - Check Script]")
}

tryCatch(
    {
        writeLines(dict_lines_ehr, con = output_ehr_dict)
        vmsg("EHR data dictionary successfully saved to: ", output_ehr_dict)
    },
    error = function(e) {
        stop("Error writing EHR data dictionary to '", output_ehr_dict, "': ", e$message, call. = FALSE)
    }
)
# --- End EHR Dictionary ---

# -----------------------------
# Generate Demographics Data
# -----------------------------
vmsg("Generating demographics data...")
n_demo <- n_individuals # Number of demographic records = number of unique individuals

# Simulate Date of Birth
date_of_birth <- sample(seq.Date(dob_min_date, dob_max_date, by = "day"), n_demo, replace = TRUE)

# Compute age as of the reference date
age <- floor(as.numeric(difftime(demographics_ref_date, date_of_birth, units = "days")) / 365.25)
# Randomly set some ages to NA
na_age_idx <- sample(1:n_demo, size = floor(prop_age_missing * n_demo))
age[na_age_idx] <- NA

# Define age bins based on computed age
age_bin <- ifelse(is.na(age), NA_character_,
    ifelse(age < 18, "<18",
        ifelse(age < 35, "18-34",
            ifelse(age < 55, "35-54",
                ifelse(age < 75, "55-74", "75+")
            )
        )
    )
)

# Simulate deceased status
deceased <- sample(names(prob_deceased), n_demo, replace = TRUE, prob = prob_deceased)

# Simulate race and map specified values to NA
race_raw <- sample(race_categories, n_demo, replace = TRUE, prob = race_probs)
race_clean <- ifelse(race_raw %in% na_race_eth_values, NA_character_, race_raw)

# Simulate ethnicity and map specified values to NA
ethnicity_raw <- sample(ethnicity_categories, n_demo, replace = TRUE, prob = ethnicity_probs)
ethnicity_clean <- ifelse(ethnicity_raw %in% na_race_eth_values, NA_character_, ethnicity_raw)

# Combine race and ethnicity (only if both are non-NA)
race_ethnicity <- ifelse(is.na(race_clean) | is.na(ethnicity_clean),
    NA_character_,
    paste(race_clean, ethnicity_clean)
)

# Harmonize race and ethnicity into broader categories (vectorized approach)
race_ethnicity_harmonized <- ifelse(is.na(race_clean) | is.na(ethnicity_clean), NA_character_,
    ifelse(ethnicity_clean == "Hispanic", "Hispanic",
        ifelse(race_clean == "White", "Non-Hispanic White",
            ifelse(race_clean == "Black", "Non-Hispanic Black",
                ifelse(race_clean %in% c("Asian", "Native American", "Pacific Islander"),
                       "Non-Hispanic Asian/Pacific Islander/Native American",
                       "Other" # Includes 'Other' race category when Non-Hispanic
                )
            )
        )
    )
)

# Simulate sex/gender
sex_gender <- sample(sex_gender_categories, n_demo, replace = TRUE)

# Simulate marital status
marital_status_name <- sample(marital_status_categories, n_demo, replace = TRUE, prob = marital_status_probs)

# Simulate a three-digit ZIP code (with leading zeros)
zip3 <- sprintf("%03d", sample(zip3_min:zip3_max, n_demo, replace = TRUE))

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
    stringsAsFactors = FALSE # Good practice
)

# -----------------------------
# Output: Write Demographics Dataset and Data Dictionary
# -----------------------------
# Write the demographics dataset to a TSV file
tryCatch(
    {
        write.table(demo_data, file = output_demo, sep = "\t", quote = FALSE, row.names = FALSE, na = "")
        vmsg("Demographics dataset successfully saved to: ", output_demo)
    },
    error = function(e) {
        stop("Error writing demographics dataset to '", output_demo, "': ", e$message, call. = FALSE)
    }
)

# --- Generate and Write Demographics Data Dictionary ---
demo_colnames <- colnames(demo_data)
dict_descriptions_demo <- c(
    # Descriptions MUST be in the same order as columns in demo_data
    "Unique identifier for the individual (matches EHR data).",
    "Date of birth in YYYY-MM-DD format.",
    paste("Age in years as of", format(demographics_ref_date), ". May contain NA."),
    "Age category based on calculated age (<18, 18-34, 35-54, 55-74, 75+).",
    "Indicator if the person is recorded as deceased (Yes/No).",
    paste("Self-reported race (NA for:", paste(na_race_eth_values, collapse=", "), ")."),
    paste("Self-reported ethnicity (NA for:", paste(na_race_eth_values, collapse=", "), ")."),
    "Combined race and ethnicity string (NA if either component is NA).",
    "Harmonized race/ethnicity classification (e.g., Hispanic, Non-Hispanic White, Non-Hispanic Black, Non-Hispanic Asian/Pacific Islander/Native American, Other).",
    "Recorded sex/gender of the individual.",
    "Self-reported marital status.",
    "Simulated three-digit ZIP code prefix."
)

if (length(demo_colnames) == length(dict_descriptions_demo)) {
     dict_lines_demo <- paste0(demo_colnames, ": ", dict_descriptions_demo)
} else {
     warning("Mismatch between Demographics column names and dictionary descriptions. Writing basic names only.")
     dict_lines_demo <- paste0(demo_colnames, ": [Description Mismatch - Check Script]")
}

tryCatch(
    {
        writeLines(dict_lines_demo, con = output_demo_dict)
        vmsg("Demographics data dictionary successfully saved to: ", output_demo_dict)
    },
    error = function(e) {
        stop("Error writing demographics data dictionary to '", output_demo_dict, "': ", e$message, call. = FALSE)
    }
)
# --- End Demographics Dictionary ---


#------------------------------------------------------------------------------
# Session Information: Record the R environment for reproducibility
#------------------------------------------------------------------------------
message("-------------------------------------------------------------------------------")
message("Session Information:")
sessionInfo()
message("-------------------------------------------------------------------------------")

# End of script message
message("Script execution completed successfully.")
