# Computer vision demonstration workflow ---------------------------------------


## Load libraries and custom functions ----
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


## Data targets ----
data_targets <- tar_plan(
  data_pdf_file = "data-raw/pdf/student_nutrition_records.pdf",
  data_pdf_pages = seq_len(13),
  tar_target(
    name = data_jpg_files,
    command = convert_pdf_to_png(
      pdf = data_pdf_file, format = "jpg", 
      page = data_pdf_pages,
      destdir = "data-raw/jpg", dpi = 100
    ),
    pattern = map(data_pdf_pages),
    format = "file"
  )
)

## LLM targets ----
llm_targets <- tar_plan(
  tar_target(
    name = local_qwen_model,
    command = get_llm_name(src = "qwen3.5"),
    cue = tar_cue("always")
  ),
  ### LLM parameters ----
  tar_target(
    name = llm_parameters,
    command = ellmer::params(
        temperature = 0.3,
        top_p = 0.95,
        top_k = 64,
        reasoning_effort = "low",
        reasoning_tokens = 0
    )
  ),
  tar_target(
    name = data_jpg_files_list,
    command = list.files(
      path = "data-raw/jpg", pattern = "\\.jpg$", 
      full.names = TRUE, recursive = TRUE
    )
  )
)

## LLM targets ----
llm_targets <- tar_plan(
  tar_target(
    name = local_qwen_model,
    command = get_llm_name(src = "qwen3.5"),
    cue = tar_cue("always")
  ),
  ### LLM parameters ----
  tar_target(
    name = llm_parameters,
    command = ellmer::params(
        temperature = 0.3,
        top_p = 0.95,
        top_k = 64,
        reasoning_effort = "low",
        reasoning_tokens = 0
    )
  ),
  tar_target(
    name = extraction_context_prompt,
    command = ellmer::interpolate_file(path = "prompts/task_context_prompt.md")
  ),
  tar_target(
    name = extraction_output_type,
    command = llm_create_data_type()
  ),
  tar_target(
    name = qwen_reviewer,
    command = ellmer::chat_ollama(
      system_prompt = extraction_context_prompt, 
      model = local_qwen_model,
      #params = llm_parameters,
      echo = "none"
    )
  ),
  tar_target(
    name = qwen_test_extraction,
    command = llm_extract_data(
      extractor = qwen_reviewer,
      query = data_jpg_files_list,
      type = extraction_output_type
    ),
    pattern = slice(data_jpg_files_list, 1)
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
