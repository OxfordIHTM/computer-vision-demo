#'
#' Get name of local LLM available
#'

get_llm_name <- function(src) {
  ellmer::models_ollama(Sys.getenv("OLLAMA_BASE_URL")) |>
    dplyr::filter(grepl(pattern = src, x = id)) |>
    dplyr::pull(id)
}
