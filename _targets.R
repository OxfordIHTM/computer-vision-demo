# Computer vision demonstration workflow ---------------------------------------


## Load libraries and custom functions ----
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


## Build options ----

### Set Google credentials ----
gargle::credentials_service_account(path = Sys.getenv("GOOGLE_AUTH_FILE"))


## Data targets ----
data_targets <- tar_plan(
  data_pdf_file = "data-raw/pdf/student_nutrition_records.pdf",
  data_pdf_pages = seq_len(13),
  tar_target(
    name = data_jpg_files,
    command = convert_pdf_to_image(
      pdf = data_pdf_file, format = "jpg", 
      page = data_pdf_pages,
      destdir = "data-raw/jpg", dpi = 300
    ),
    pattern = map(data_pdf_pages),
    format = "file"
  ),
  tar_target(
    name = data_png_files,
    command = convert_pdf_to_image(
      pdf = data_pdf_file, format = "png", 
      page = data_pdf_pages,
      destdir = "data-raw/png", dpi = 300
    ),
    pattern = map(data_pdf_pages),
    format = "file"
  )
)

## LLM targets ----
llm_targets <- tar_plan(
  ### LLM parameters ----
  tar_target(
    name = llm_parameters,
    command = ellmer::params(
      temperature = 0.3,
      top_p = 0.95,
      top_k = 64
    )
  ),
  extraction_context_prompt_md = "prompts/task_context_prompt.md",
  tar_target(
    name = extraction_context_prompt,
    command = ellmer::interpolate_file(path = extraction_context_prompt_md)
  ),
  ### LLM extraction output type ----
  tar_target(
    name = extraction_output_type,
    command = llm_create_data_type()
  )
)


## qwen model targets ----
qwen_local_targets <- tar_plan(
  tar_target(
    name = local_qwen_model,
    command = get_llm_name(src = "qwen3.5"),
    cue = tar_cue("always")
  ),
  tar_target(
    name = qwen_extractor,
    command = ellmer::chat_ollama(
      system_prompt = extraction_context_prompt, 
      model = local_qwen_model,
      echo = "none"
    )
  ),
  tar_target(
    name = qwen_test_extraction,
    command = llm_extract_data(
      extractor = qwen_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_qwen_model,
      ollama = TRUE
    ),
    pattern = slice(data_jpg_files, 1)
  )
)

## gemini model targets ----
gemini_targets <- tar_plan(
  gemini_model = "gemini-pro-latest",
  tar_target(
    name = gemini_extractor,
    command = ellmer::chat_google_gemini(
      system_prompt = extraction_context_prompt,
      model = gemini_model,
      echo = "none"
    )
  ),
  tar_target(
    name = gemini_extraction,
    command = llm_extract_data(
      extractor = gemini_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = gemini_model,
      ollama = FALSE
    ),
    pattern = data_jpg_files
  )
)


## Processing targets ----
processing_targets <- tar_plan(
  
)


## Analysis targets ----
analysis_targets <- tar_plan(
  
)


## Output targets ----
output_targets <- tar_plan(
  
)


## Reporting targets ----
report_targets <- tar_plan(
  
)


## Deploy targets ----
deploy_targets <- tar_plan(
  
)


## List targets ----
all_targets()
