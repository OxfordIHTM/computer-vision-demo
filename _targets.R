# Computer vision demonstration workflow ---------------------------------------


## Load libraries and custom functions ----
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)

## LLM targets ----
llm_targets <- tar_plan(
  tar_target(
    name = local_llm_model,
    command = get_llm_name(src = "qwen2.5"),
    cue = tar_cue("always")
  )
)

## Data targets ----
data_targets <- tar_plan(
  data_pdf_file = "data-raw/pdf/student_nutrition_records.pdf",
  data_pdf_pages = seq_len(13),
  tar_target(
    name = data_jpg_files,
    command = convert_pdf_to_png(
      pdf = data_pdf_file, format = "jpg", page = data_pdf_pages,
      destdir = "data-raw/jpg", dpi = 200
    ),
    pattern = map(data_pdf_pages),
    format = "file"
  ),
  tar_target(
    name = data_raw_text,
    command = kuzco::llm_image_extract_text(
      llm_model = local_llm_model, image = data_jpg_files
    ),
    pattern = map(data_jpg_files),
    iteration = "list"
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
