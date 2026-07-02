#'
#' Check model outputs against standard
#' 

check_output <- function(target, current, test = FALSE) {
  if (!is.data.frame(current)) current <- current[[1]]
 
  if (test) target <- target[1:3, ]

  target <- process_extraction_output(extract = target, format = "long")
  current <- process_extraction_output(extract = current, format = "long")

  arsenal::comparedf(x = target, y = current, by = c("round", "image"))
}
