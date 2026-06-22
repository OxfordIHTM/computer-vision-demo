#'
#' Output processed results to CSV files
#' 

output_to_csv <- function(data, path, overwrite = FALSE) {
  # Ensure the output directory exists
  if (!dir.exists(dirname(path))) {
    dir.create(dirname(path), recursive = TRUE)
  }

  # Check if the file already exists
  if (file.exists(path) && !overwrite) {
    stop("File already exists. Use overwrite = TRUE to overwrite.")
  }

  # Write the data to CSV
  write.csv(data, path, row.names = FALSE)

  ## Return the path of the written file
  path
}
