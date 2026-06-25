#'
#' Extract the relevant information from the images using LLM.
#' 
#' 

llm_extract_data <- function(extractor, 
                             image, 
                             type,
                             model, 
                             ollama = FALSE, 
                             max_tries = 3L) {
  model <- stringr::str_extract(
    string = model, pattern = "gemini|claude|gpt|qwen|llama"
  )

  if (ollama) {
    image_upload <- "ellmer::content_image_file(image)"
  } else {
    if (model == "gemini") {
      image_upload <- "ellmer::google_upload(image)"
    }
    
    if (!model %in% c("gemini")) {
      image_upload <- "ellmer::content_image_file(image)"
    }
  }

  for (attempt in seq_len(max_tries)) {
    extractor <- extractor$set_turns(list())
    
    out <- tryCatch(
      extractor$chat_structured(
        eval(parse(text = image_upload)),
        type = type
      ),
      error = function(e) {
        if (attempt == max_tries) {
          cli::cli_abort(
            "Structured extraction failed after {max_tries} attempt/s.",
            parent = e
          )
        }
        cli::cli_warn(
          "Extraction attempt {attempt}/{max_tries} failed ({conditionMessage(e)}); retrying."
        )
        NULL
      }
    )
  }
  
  out
}
