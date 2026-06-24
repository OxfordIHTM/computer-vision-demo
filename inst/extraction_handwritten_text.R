# Example script for text extraction from handwritten health records -----------

## Load libraries ----

library(dplyr)
library(tidyr)
library(stringr)
library(pdftools)
library(tesseract)
library(ellmer)
library(here)


## Convert each page of the PDF to images ----

### Retrieve path to PDF of scanned handwritten health records ----
pdf_path <- here("data-raw/pdf/student_nutrition_records.pdf")

### Convert PDF to JPG images ----

pages <- seq_len(pdf_info(pdf_path)$pages)

filenames <- paste0(
  "student_nutrition_record_page_", 
  str_pad(pages, width = 2, pad = "0"),
  ".jpeg"
)

Map(
  f = pdf_convert,
  pdf = pdf_path,
  format = "jpeg",
  page = pages,
  filenames = filenames,
  dpi = 300,
  antialias = "text",
  verbose = FALSE
)


## Create appropriate prompt for text extraction ----

text_extraction_prompt <- r"(
  # Text extraction from handwritten student health and nutrition records

  ## Role and goal
  You are a specialised AI model functioning as a high-precision Optical Character Recognition (OCR) engine. Your sole purpose is to analyse a user-provided image of handwritten student health and nutrition records, extract all discernible text, and return the result in a single, raw JSON object. You will adhere strictly to the following instructions and schema.

  ## Core instructions
  1.  **JSON Only Output:** Your entire response must be a raw JSON object. Do not include any explanatory text, markdown backticks (e.g., ```json), or any characters outside of the valid JSON structure.
  2.  **Image Requirement:** You must analyse the image provided by the user. If no image is present, you MUST return the specific `NO_IMAGE_ERROR` JSON defined below.
  3.  **Focus on Text:** Your analysis must focus exclusively on extracting text. Do not describe the image, its objects, or its sentiment.
  4.  **Mandatory and Complete Fields:** All JSON fields are mandatory. Do not use `null` or empty values. Every field must be fully populated according to the schema definitions.
  5.  **Originality:** The provided examples are for structure only. You must generate an original analysis for each new image.

  ## JSON schema definition
  You must populate the following JSON object.

  *   `first_name` (String): **Required.** This field will contain extracted text on the line that contains the student's first name as a single string.
  *   `last_name` (String): **Required.** This field will contain extracted text on the line that contains the student's last name as a single string.
  *   `age` (Integer): **Required.** This field will contain the student's age as a single integer.
  *   `sex` (String): **Required.** This field will contain extracted text on the line that contains the student's sex as a single string.
  *   `measurement_1_date` (String): **Required.** This field will contain extracted text on the line that contains the date of the first measurement as a single string.
  *   `measurement_1_weight` (Number): **Required.** This field will contain the weight measurement from the first measurement as a floating-point number.
  *   `measurement_1_height` (Number): **Required.** This field will contain the height measurement from the first measurement as a floating-point number.
  *   `measurement_2_date` (String): **Required.** This field will contain extracted text on the line that contains the date of the second measurement as a single string.
  *   `measurement_2_weight` (Number): **Required.** This field will contain the weight measurement from the second measurement as a floating-point number.
  *   `measurement_2_height` (Number): **Required.** This field will contain the height measurement from the second measurement as a floating-point number.

  ## Example Output (For structure reference ONLY)
  ```json
  {
    "first_name": "DINDO",
    "last_name": "HAGUPIT",
    "age": 143,
    "sex": "Female",
    "measurement_1_date": "2023-10-01",
    "measurement_1_weight": 45.5,
    "measurement_1_height": 150.0,
    "measurement_2_date": "2023-11-01",
    "measurement_2_weight": 47.0,
    "measurement_2_height": 152.0
  }
  ```

)"


## Create output object type specification ----
extraction_output_type <- ellmer::type_array(
  ellmer::type_object(
    "Specification of expected data structure to be extracted from the images of handwritten student records",
    first_name = ellmer::type_string(
      description = "First name of the student", required = TRUE
    ),
    last_name = ellmer::type_string(
      description = "Last name of the student", required = TRUE
    ),
    age = ellmer::type_integer(
      description = "Age of the student in months", required = TRUE
    ),
    sex = ellmer::type_enum(
      values = c("male", "female"),
      description = "Sex of the student. Can be either male or female",
      required = TRUE
    ),
    measurements = ellmer::type_array(
      ellmer::type_object(
        .description = "Measurements of the student",
        date = ellmer::type_string(
          description = "Date of the measurement in YYYY-MM-DD format",
          required = TRUE
        ),
        weight = ellmer::type_number(
          description = "Weight of the student in kilograms",
          required = TRUE
        ),
        height = ellmer::type_number(
          description = "Height of the student in centimetres", 
          required = TRUE
        )
      ),
      description = "Measurements of the student. Each measurement is taken on a separate day."
    )
  )
)

## Extract text from each image using Ollama and qwen3.5:9b model ----

qwen_extractor <- ellmer::chat_ollama(
  system_prompt = interpolate(text_extraction_prompt),
  model = "qwen3-vl:32b",
  echo = "none"
)


# qwen_extraction_results <- parallel_chat_structured(
#   chat = qwen_extractor,
#   prompts = lapply(X = filenames, FUN = content_image_file),
#   type = extraction_output_type,
# )


qwen_extraction_results <- list()

for (i in seq_along(filenames)) {
  qwen_extractor <- qwen_extractor$set_turns(list())

  qwen_extraction_results[i] <- qwen_extractor$chat_structured(
    content_image_file(filenames[i]), 
    type = extraction_output_type
  )

  #Sys.sleep(180)  # Sleep for 3 minutes to avoid rate limiting
}

qwen_extraction_results <- dplyr::bind_rows(qwen_extraction_results)
