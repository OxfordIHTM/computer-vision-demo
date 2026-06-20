#'
#' Extract the relevant information from the images using LLM.
#' 
#' 

llm_extract_data <- function(extractor, query, type) {
  extractor <- extractor$set_turns(list())

  out <- extractor$chat_structured(query, type = type)

  out
}
