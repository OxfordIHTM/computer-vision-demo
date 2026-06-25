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
      destdir = "data-raw/png", dpi = 200
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
  extraction_context_ollama_prompt_md = "prompts/task_context_ollama_prompt.md",
  tar_target(
    name = extraction_context_ollama_prompt,
    command = ellmer::interpolate_file(
      path = extraction_context_ollama_prompt_md
    )
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
    command = get_llm_name(src = "qwen3-vl"),
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
      ollama = TRUE
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
      ollama = TRUE
    ),
    pattern = data_jpg_files
  )
)


## gemma model targets ----
gemma_local_targets <- tar_plan(
  tar_target(
    name = local_gemma_model,
    command = get_llm_name(src = "gemma4"),
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
      ollama = TRUE
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
      ollama = TRUE
    ),
    pattern = data_jpg_files
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
      ollama = TRUE
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
      ollama = TRUE
    ),
    pattern = data_jpg_files
  )
)


## llava model targets ----
llava_local_targets <- tar_plan(
  tar_target(
    name = local_llava_model,
    command = get_llm_name(src = "llava"),
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
      ollama = TRUE
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
      ollama = TRUE
    ),
    pattern = data_jpg_files
  )
)


## llama model targets ----
llama_targets <- tar_plan(
  tar_target(
    name = local_llama_model,
    command = get_llm_name(src = "llama4"),
    cue = tar_cue("always")
  ),
  tar_target(
    name = llama_extractor,
    command = ellmer::chat_ollama(
      system_prompt = extraction_context_ollama_prompt, 
      model = local_llama_model,
      echo = "none"
    )
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
    pattern = data_jpg_files
  )
)


## Processing targets ----
processing_test_targets <- tar_plan(
  tar_target(
    name = gemma_test_extraction_results_long,
    command = process_extraction_output(
      extract = gemma_test_extraction, format = "long"
    ) 
  ),
  tar_target(
    name = gemma_test_extraction_results_wide,
    command = process_extraction_output(
      extract = gemma_test_extraction, format = "wide"
    ) 
  ),
  tar_target(
    name = qwen_test_extraction_results_long,
    command = process_extraction_output(
      extract = qwen_test_extraction, format = "long"
    ) 
  ),
  tar_target(
    name = qwen_test_extraction_results_wide,
    command = process_extraction_output(
      extract = qwen_test_extraction, format = "wide"
    ) 
  ),
  tar_target(
    name = deepseek_test_extraction_results_long,
    command = process_extraction_output(
      extract = deepseek_test_extraction, format = "long"
    ) 
  ),
  tar_target(
    name = deepseek_test_extraction_results_wide,
    command = process_extraction_output(
      extract = deepseek_test_extraction, format = "wide"
    ) 
  ),
  tar_target(
    name = llava_test_extraction_results_long,
    command = process_extraction_output(
      extract = llava_test_extraction, format = "long"
    ) 
  ),
  tar_target(
    name = llava_test_extraction_results_wide,
    command = process_extraction_output(
      extract = llava_test_extraction, format = "wide"
    ) 
  )
)


processing_production_targets <- tar_plan(
  tar_target(
    name = gemini_extraction_results_long,
    command = process_extraction_output(
      extract = gemini_extraction, format = "long"
    ) 
  ),
  tar_target(
    name = gemini_extraction_results_wide,
    command = process_extraction_output(
      extract = gemini_extraction, format = "wide"
    ) 
  ),
  tar_target(
    name = claude_extraction_results_long,
    command = process_extraction_output(
      extract = claude_extraction, format = "long"
    ) 
  ),
  tar_target(
    name = claude_extraction_results_wide,
    command = process_extraction_output(
      extract = claude_extraction, format = "wide"
    ) 
  ),
  tar_target(
    name = gemma_extraction_results_long,
    command = process_extraction_output(
      extract = gemma_extraction, format = "long"
    ) 
  ),
  tar_target(
    name = gemma_extraction_results_wide,
    command = process_extraction_output(
      extract = gemma_extraction, format = "wide"
    ) 
  ),
  tar_target(
    name = qwen_extraction_results_long,
    command = process_extraction_output(
      extract = qwen_extraction, format = "long"
    ) 
  ),
  tar_target(
    name = qwen_extraction_results_wide,
    command = process_extraction_output(
      extract = qwen_extraction, format = "wide"
    ) 
  ),
  tar_target(
    name = deepseek_extraction_results_long,
    command = process_extraction_output(
      extract = deepseek_extraction, format = "long"
    ) 
  ),
  tar_target(
    name = deepseek_extraction_results_wide,
    command = process_extraction_output(
      extract = deepseek_extraction, format = "wide"
    ) 
  ),
  tar_target(
    name = llava_extraction_results_long,
    command = process_extraction_output(
      extract = llava_extraction, format = "long"
    ) 
  ),
  tar_target(
    name = llava_extraction_results_wide,
    command = process_extraction_output(
      extract = llava_extraction, format = "wide"
    ) 
  )
)


## Analysis targets ----
analysis_targets <- tar_plan(
  
)


## Output targets ----
output_test_targets <- tar_plan(
  tar_target(
    name = gemma_test_extraction_results_long_csv,
    command = output_to_csv(
      data = gemma_test_extraction_results_long,
      path = "tests/gemma_test_extraction_results_long.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = gemma_test_extraction_results_wide_csv,
    command = output_to_csv(
      data = gemma_test_extraction_results_wide,
      path = "tests/gemma_test_extraction_results_wide.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = qwen_test_extraction_results_long_csv,
    command = output_to_csv(
      data = qwen_test_extraction_results_long,
      path = "tests/qwen_test_extraction_results_long.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = qwen_test_extraction_results_wide_csv,
    command = output_to_csv(
      data = qwen_test_extraction_results_wide,
      path = "tests/qwen_test_extraction_results_wide.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = deepseek_test_extraction_results_long_csv,
    command = output_to_csv(
      data = deepseek_test_extraction_results_long,
      path = "tests/deepseek_test_extraction_results_long.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = deepseek_test_extraction_results_wide_csv,
    command = output_to_csv(
      data = deepseek_test_extraction_results_wide,
      path = "tests/deepseek_test_extraction_results_wide.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = llava_test_extraction_results_long_csv,
    command = output_to_csv(
      data = llava_test_extraction_results_long,
      path = "tests/llava_test_extraction_results_long.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = llava_test_extraction_results_wide_csv,
    command = output_to_csv(
      data = llava_test_extraction_results_wide,
      path = "tests/llava_test_extraction_results_wide.csv",
      overwrite = TRUE
    )
  )
)


## Output production targets ----
output_production_targets <- tar_plan(
  tar_target(
    name = gemini_extraction_results_long_csv,
    command = output_to_csv(
      data = gemini_extraction_results_long,
      path = "data/gemini_extraction_results_long.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = gemini_extraction_results_wide_csv,
    command = output_to_csv(
      data = gemini_extraction_results_wide,
      path = "data/gemini_extraction_results_wide.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = claude_extraction_results_long_csv,
    command = output_to_csv(
      data = claude_extraction_results_long,
      path = "data/claude_extraction_results_long.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = claude_extraction_results_wide_csv,
    command = output_to_csv(
      data = claude_extraction_results_wide,
      path = "data/claude_extraction_results_wide.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = gemma_extraction_results_long_csv,
    command = output_to_csv(
      data = gemma_extraction_results_long,
      path = "data/gemma_extraction_results_long.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = gemma_extraction_results_wide_csv,
    command = output_to_csv(
      data = gemma_extraction_results_wide,
      path = "data/gemma_extraction_results_wide.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = qwen_extraction_results_long_csv,
    command = output_to_csv(
      data = qwen_extraction_results_long,
      path = "data/qwen_extraction_results_long.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = qwen_extraction_results_wide_csv,
    command = output_to_csv(
      data = qwen_extraction_results_wide,
      path = "data/qwen_extraction_results_wide.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = deepseek_extraction_results_long_csv,
    command = output_to_csv(
      data = deepseek_extraction_results_long,
      path = "data/deepseek_extraction_results_long.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = deepseek_extraction_results_wide_csv,
    command = output_to_csv(
      data = deepseek_extraction_results_wide,
      path = "data/deepseek_extraction_results_wide.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = llava_extraction_results_long_csv,
    command = output_to_csv(
      data = llava_extraction_results_long,
      path = "data/llava_extraction_results_long.csv",
      overwrite = TRUE
    )
  ),
  tar_target(
    name = llava_extraction_results_wide_csv,
    command = output_to_csv(
      data = llava_extraction_results_wide,
      path = "data/llava_extraction_results_wide.csv",
      overwrite = TRUE
    )
  )
)


## Reporting targets ----
report_targets <- tar_plan(
  tar_quarto(
    name = text_extraction_handwriting_report,
    path = "reports/text-extraction-handwriting.qmd"
  )
)


## Deploy targets ----
deploy_targets <- tar_plan(
  
)


## List targets ----
all_targets()
