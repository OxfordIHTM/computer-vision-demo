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
      destdir = "data-raw/jpg", dpi = 150
    ),
    pattern = map(data_pdf_pages),
    format = "file"
  ),
  tar_target(
    name = data_png_files,
    command = convert_pdf_to_image(
      pdf = data_pdf_file, format = "png", 
      page = data_pdf_pages,
      destdir = "data-raw/png", dpi = 150
    ),
    pattern = map(data_pdf_pages),
    format = "file"
  ),
  tar_target(
    name = test_standards,
    command = create_test_standards()
  )
)

## LLM targets ----
llm_targets <- tar_plan(
  ### LLM parameters ----
  tar_target(
    name = llm_parameters,
    command = ellmer::params(
      temperature = 1.0,
      top_p = 0.95,
      top_k = 64
    )
  ),
  tar_target(
    name = extraction_context_prompt_md,
    command = "prompts/task_context_prompt.md",
    cue = tar_cue("always")
  ),
  tar_target(
    name = extraction_context_prompt,
    command = ellmer::interpolate_file(path = extraction_context_prompt_md),
    cue = tar_cue("always")
  ),
  tar_target(
    name = extraction_context_ollama_prompt_md,
    command = "prompts/task_context_ollama_prompt.md",
    cue = tar_cue("always")
  ),
  tar_target(
    name = extraction_context_ollama_prompt,
    command = ellmer::interpolate_file(
      path = extraction_context_ollama_prompt_md
    ),
    cue = tar_cue("always")
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
    command = get_llm_name(src = "qwen2.5vl"),
    cue = tar_cue("always")
  ),
  tar_target(
    name = qwen_extractor,
    command = ellmer::chat_ollama(
      system_prompt = extraction_context_ollama_prompt, 
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
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = slice(data_jpg_files, 1:3)
  ),
  tar_target(
    name = qwen_extraction,
    command = llm_extract_data(
      extractor = qwen_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_qwen_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = map(data_jpg_files)
  )
)


## gemma model targets ----
gemma_local_targets <- tar_plan(
  tar_target(
    name = local_gemma_model,
    command = get_llm_name(src = "gemma4:31b-it-bf16"),
    cue = tar_cue("always")
  ),
  tar_target(
    name = gemma_extractor,
    command = ellmer::chat_ollama(
      system_prompt = extraction_context_ollama_prompt, 
      model = local_gemma_model,
      echo = "none"
    )
  ),
  tar_target(
    name = gemma_test_extraction,
    command = llm_extract_data(
      extractor = gemma_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_gemma_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = slice(data_jpg_files, 1:3)
  ),
  tar_target(
    name = gemma_extraction,
    command = llm_extract_data(
      extractor = gemma_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_gemma_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = map(data_jpg_files)
  )
)


## deepseek model targets ----
deepseek_local_targets <- tar_plan(
  tar_target(
    name = local_deepseek_model,
    command = get_llm_name(src = "deepseek-ocr"),
    cue = tar_cue("always")
  ),
  tar_target(
    name = deepseek_extractor,
    command = ellmer::chat_ollama(
      system_prompt = extraction_context_ollama_prompt, 
      model = local_deepseek_model,
      echo = "none"
    )
  ),
  tar_target(
    name = deepseek_test_extraction,
    command = llm_extract_data(
      extractor = deepseek_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_deepseek_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = slice(data_jpg_files, 1:3)
  ),
  tar_target(
    name = deepseek_extraction,
    command = llm_extract_data(
      extractor = deepseek_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_deepseek_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = map(data_jpg_files)
  )
)


## llava model targets ----
llava_local_targets <- tar_plan(
  tar_target(
    name = local_llava_model,
    command = get_llm_name(src = "llava:34b"),
    cue = tar_cue("always")
  ),
  tar_target(
    name = llava_extractor,
    command = ellmer::chat_ollama(
      system_prompt = extraction_context_ollama_prompt, 
      model = local_llava_model,
      echo = "none"
    )
  ),
  tar_target(
    name = llava_test_extraction,
    command = llm_extract_data(
      extractor = llava_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_llava_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = slice(data_jpg_files, 1:3)
  ),
  tar_target(
    name = llava_extraction,
    command = llm_extract_data(
      extractor = llava_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_llava_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = map(data_jpg_files)
  )
)


## llama model targets ----
llama_targets <- tar_plan(
  tar_target(
    name = local_llama_model,
    command = get_llm_name(src = "llama3.2-vision"),
    cue = tar_cue("always")
  ),
  tar_target(
    name = llama_extractor,
    command = ellmer::chat_ollama(
      system_prompt = extraction_context_ollama_prompt, 
      model = local_llama_model,
      echo = "none"
    )
  ),
  tar_target(
    name = llama_test_extraction,
    command = llm_extract_data(
      extractor = llama_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_llama_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = slice(data_jpg_files, 1:3)
  ),
  tar_target(
    name = llama_extraction,
    command = llm_extract_data(
      extractor = llama_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_llama_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = map(data_jpg_files)
  )
)


## glm model targets ----
glm_targets <- tar_plan(
  tar_target(
    name = local_glm_model,
    command = get_llm_name(src = "glm-ocr:bf16"),
    cue = tar_cue("always")
  ),
  tar_target(
    name = glm_extractor,
    command = ellmer::chat_ollama(
      system_prompt = extraction_context_ollama_prompt, 
      model = local_glm_model,
      echo = "none"
    )
  ),
  tar_target(
    name = glm_test_extraction,
    command = llm_extract_data(
      extractor = glm_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_glm_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = slice(data_jpg_files, 1:3)
  ),
  tar_target(
    name = glm_extraction,
    command = llm_extract_data(
      extractor = glm_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = local_glm_model,
      ollama = TRUE,
      max_tries = 5L
    ),
    pattern = map(data_jpg_files)
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
    pattern = map(data_jpg_files)
  )
)


##  claude model targets ----
claude_targets <- tar_plan(
  claude_model = "claude-opus-4-8",
  tar_target(
    name = claude_extractor,
    command = ellmer::chat_claude(
      system_prompt = extraction_context_prompt,
      model = claude_model,
      echo = "none"
    )
  ),
  tar_target(
    name = claude_extraction,
    command = llm_extract_data(
      extractor = claude_extractor,
      image = data_jpg_files,
      type = extraction_output_type,
      model = claude_model,
      ollama = FALSE
    ),
    pattern = map(data_jpg_files)
  )
)


## Processing targets ----
processing_test_targets <- tar_plan(
  tar_target(
    name = test_extraction_results,
    command = list(
      gemma = gemma_test_extraction,
      qwen = qwen_test_extraction,
      deepseek = deepseek_test_extraction,
      llava = llava_test_extraction,
      glm = glm_test_extraction
    )
  ),
  tar_target(
    name = test_extraction_results_long,
    command = process_extraction_output(
      extract = test_extraction_results, format = "long"
    ),
    pattern = map(test_extraction_results),
    iteration = "list"
  ),
  tar_target(
    name = test_extraction_results_wide,
    command = process_extraction_output(
      extract = test_extraction_results, format = "wide"
    ),
    pattern = map(test_extraction_results),
    iteration = "list" 
  )
)


processing_production_targets <- tar_plan(
  tar_target(
    name = extraction_results,
    command = list(
      gemini = gemini_extraction,
      claude = claude_extraction,
      gemma = gemma_extraction,
      qwen = qwen_extraction,
      deepseek = deepseek_extraction,
      llava = llava_extraction,
      glm = glm_extraction
    )
  ),
  tar_target(
    name = extraction_results_long,
    command = process_extraction_output(
      extract = extraction_results, format = "long"
    ),
    pattern = map(extraction_results),
    iteration = "list"
  ),
  tar_target(
    name = extraction_results_wide,
    command = process_extraction_output(
      extract = extraction_results, format = "wide"
    ),
    pattern = map(extraction_results),
    iteration = "list" 
  )
)


## Analysis targets ----
analysis_targets <- tar_plan(
  
)


## Output targets ----
output_test_targets <- tar_plan(
  tar_target(
    name = test_extraction_results_long_csv_file_path,
    command = c(
      "tests/test_gemma_extraction_results_long.csv",
      "tests/test_qwen_extraction_results_long.csv",
      "tests/test_deepseek_extraction_results_long.csv",
      "tests/test_llava_extraction_results_long.csv",
      "tests/test_glm_extraction_results_long.csv"
    )
  ),
  tar_target(
    name = test_extraction_results_long_csv,
    command = output_to_csv(
      data = test_extraction_results_long,
      path = test_extraction_results_long_csv_file_path,
      overwrite = TRUE
    ),
    pattern = map(
      test_extraction_results_long,
      test_extraction_results_long_csv_file_path
    )
  ),
  tar_target(
    name = test_extraction_results_wide_csv_file_path,
    command = c(
      "tests/test_gemma_extraction_results_wide.csv",
      "tests/test_qwen_extraction_results_wide.csv",
      "tests/test_deepseek_extraction_results_wide.csv",
      "tests/test_llava_extraction_results_wide.csv",
      "tests/test_glm_extraction_results_wide.csv"
    )
  ),
  tar_target(
    name = test_extraction_results_wide_csv,
    command = output_to_csv(
      data = test_extraction_results_wide,
      path = test_extraction_results_wide_csv_file_path,
      overwrite = TRUE
    ),
    pattern = map(
      test_extraction_results_wide,
      test_extraction_results_wide_csv_file_path
    )
  )
)


## Output production targets ----
output_production_targets <- tar_plan(
  tar_target(
    name = extraction_results_long_csv_file_path,
    command = c(
      "data/gemini_extraction_results_long.csv",
      "data/claude_extraction_results_long.csv",
      "data/gemma_extraction_results_long.csv",
      "data/qwen_extraction_results_long.csv",
      "data/deepseek_extraction_results_long.csv",
      "data/llava_extraction_results_long.csv",
      "data/glm_extraction_results_long.csv"
    )
  ),
  tar_target(
    name = extraction_results_long_csv,
    command = output_to_csv(
      data = extraction_results_long,
      path = extraction_results_long_csv_file_path,
      overwrite = TRUE
    ),
    pattern = map(
      extraction_results_long,
      extraction_results_long_csv_file_path
    )
  ),
  tar_target(
    name = extraction_results_wide_csv_file_path,
    command = c(
      "data/gemini_extraction_results_wide.csv",
      "data/claude_extraction_results_wide.csv",
      "data/gemma_extraction_results_wide.csv",
      "data/qwen_extraction_results_wide.csv",
      "data/deepseek_extraction_results_wide.csv",
      "data/llava_extraction_results_wide.csv",
      "data/glm_extraction_results_wide.csv"
    )
  ),
  tar_target(
    name = extraction_results_wide_csv,
    command = output_to_csv(
      data = extraction_results_wide,
      path = extraction_results_wide_csv_file_path,
      overwrite = TRUE
    ),
    pattern = map(
      extraction_results_wide,
      extraction_results_wide_csv_file_path
    )
  )
)


## Checks targets ----

checks_targets <- tar_plan(
  tar_target(
    name = test_output_checks,
    command = check_output(
      target = test_standards, current = test_extraction_results,
      test = TRUE
    ),
    pattern = map(test_extraction_results),
    iteration = "list"
  )
)


## Reporting targets ----
report_targets <- tar_plan(
  tar_quarto(
    name = text_extraction_handwriting_report,
    path = "reports/text-extraction-handwriting.qmd",
    quiet = FALSE
  )
)


## Deploy targets ----
deploy_targets <- tar_plan(
  
)


## List targets ----
all_targets()
