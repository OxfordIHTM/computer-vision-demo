#'
#' Check model outputs against standard
#' 

check_output <- function(target, current, tol_num = 1e-8, test = FALSE) {
  if (!is.data.frame(current)) current <- current[[1]]
 
  if (test) target <- target[1:3, ]

  target <- process_extraction_output(extract = target, format = "long")
  current <- process_extraction_output(extract = current, format = "long")

  cd <- arsenal::comparedf(
    x = target, y = current, by = c("round", "image"),
    control = arsenal::comparedf.control(
      tol.char = "both",
      tol.num = "absolute",
      tol.num.val = tol_num,
      int.as.num = TRUE,
      factor.as.char = TRUE
    )
  )

  score_comparedf(cd, target, current, by = c("round", "image"))
}
