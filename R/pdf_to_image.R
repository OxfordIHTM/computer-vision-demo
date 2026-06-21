#'
#' Convert PDF to PNG
#' 

convert_pdf_to_image <- function(pdf, format, page, destdir, dpi = 600) {
  if (!dir.exists(destdir)) {
    dir.create(path = destdir, showWarnings = FALSE)
  }

  file_path <- file.path(
    destdir, 
    basename(pdf) |>
      gsub(pattern = ".pdf", replacement = "", x = _) |>
      paste(
        stringr::str_pad(string = page, width = 2, pad = "0"), 
        sep = "_"
      ) |>
      paste(format, sep = ".")
  )

  pdftools::pdf_convert(
    pdf = pdf, format = format,
    pages = page, filenames = file_path, dpi = dpi,
    antialias = "text", verbose = FALSE
  )

  file_path
}



