#'
#' Convert PDF to PNG
#' 

convert_pdf_to_png <- function(pdf, format, page, file_path, dpi = 600) {
  pdftools::pdf_convert(
    pdf = pdf, format = format,
    pages = page, filenames = file_path, dpi = dpi,
    antialias = "text"
  )

  file_path
}

