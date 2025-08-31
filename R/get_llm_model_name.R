#'
#' Get name of local LLM available
#'

get_llm_name <- function(src) {
  llm <- ollamar::list_models()

  grepv(pattern = src, x = llm)
}