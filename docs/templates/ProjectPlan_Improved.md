**Data Description**
The source file contains rows of BMI-related information, which is tab-delimited. Each row includes:
- A person’s unique identifier (`person_id`)
- An encounter identifier (`encounter_id`)
- A numerical BMI value (`bmi`)
- The person’s height in centimeters (`height_cm`)
- The person’s weight in kilograms (`weight_kg`)
- The date of measurement (`measurement_date`)

This raw data from an EHR system was not collected for research purposes.
There are multiple rows per person. 


**Task to Be Accomplished**  
1. **Read the Data**  
   - Import the file using a chosen delimiter (e.g., comma or tab).  
   - Convert columns to appropriate types (particularly for dates).  

2. **Clean and Filter**  
   - Flag rows with missing or unreasonable heights/weights.  
   - Check for and flag large discrepancies between reported BMI and the BMI computed from height and weight.  
   - Write the flagged entries in a separate file and continue only with the rows that pass these checks.  

3. **Representative Record Selection**  
   - For each person, flag extreme outlier measurements (use the standard IQR approach), output them in a separate file, and continue with the remaining records.
   - For each person, select one “typical” row based on the median BMI among the remaining records.
   - If there are no valid measurements left for a person, flag them and output them in a separate file.
   - If there are multiple valid measurements, select the one closest to the median BMI.

4. **Categorize BMI, Height, and Weight**  
   - Assign people to categories (e.g., Underweight, Normal, Overweight, etc.) based on BMI, defined as:
      - Underweight: BMI < 18.5 kg/m² 
      - Normal: 18.5 ≤ BMI < 25 kg/m² 
      - Overweight: 25 ≤ BMI < 30 kg/m² 
      - Obesity I: 30 ≤ BMI < 35 kg/m² 
      - Obesity II: 35 ≤ BMI < 40 kg/m² 
      - Obesity III: BMI ≥ 40 kg/m² 
   - Create categories for height (Short, Average, Tall), defined as:
      - Short: height < 150 cm
      - Average: 150 cm ≤ height < 180 cm
      - Tall: height ≥ 180 cm
   - Create categories for weight (Light, Medium, Heavy, etc.), defined as:
      - Light: weight < 50 kg
      - Medium: 50 kg ≤ weight < 80 kg
      - Heavy: 80 kg ≤ weight < 100 kg
      - Very Heavy: weight ≥ 100 kg

**Expected Output**  
1. **Cleaned Dataset**  
   - One TSV file with one row per person:  
     - The "typical" BMI, plus the height, weight, and date of that measurement.  
     - Categorical variables for BMI, height, and weight.  

2. **Summary Table**  
   - A summary about the flagged entries, including:
      - The number of rows removed due to missing or implausible values.
      - The number of rows removed due to large discrepancies between reported and calculated BMI.
      - The number of extreme outlier measurements removed.
      - The number of individuals with only invalid measurements.
      - The number of individuals with valid measurements.
      - The distribution of the number of BMI measurements (e.g., mean, median, standard deviation) per person.
   - A short overview of how many individuals fall into each BMI category (plus height/weight categories).  
   - May be saved as a text or Markdown file.  

3. **Data Dictionary**  
   - A separate text listing each column and a brief explanation (e.g., `person_id`: a unique identifier for the person).
