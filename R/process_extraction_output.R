#'
#' Process LLM extraction output
#' 

process_extraction_output <- function(extract, format = c("long", "wide")) {
  if (format == "wide") {
    extract |>
      tidyr::unnest_wider(col = "measurements") |>
      tidyr::unnest_wider(col = c(date, weight, height), names_sep = "_") |>
      dplyr::relocate(
        dplyr::contains("_2"), .after = dplyr::contains("_1")
      )
  } else {
    extract |>
      tidyr::unnest_wider(col = "measurements") |>
      tidyr::unnest_longer(col = c(date, weight, height))
  }
}