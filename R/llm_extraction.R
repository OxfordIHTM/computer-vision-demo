#'
#' Extract the relevant information from the images using LLM.
#' 
#' 

llm_extract_data <- function(extractor, image, type,
                             model, ollama = FALSE) {
  extractor <- extractor$set_turns(list())

  model <- stringr::str_extract(
    string = model, pattern = "gemini|claude|gpt|qwen|llama"
  )

  if (ollama) {
    image_upload <- "ellmer::content_image_file(image)"
  } else {
    if (model == "gemini") {
      image_upload <- "ellmer::google_upload(image)"
    }
    
    # if (model == "claude") {
    #   image_upload <- "ellmer::claude_file_upload(image)"
    # }
    
    if (!model %in% c("gemini")) {
      image_upload <- "ellmer::content_image_file(image)"
    }
  }

  out <- extractor$chat_structured(
    eval(parse(text = image_upload)), 
    type = type
  )

  out
}
