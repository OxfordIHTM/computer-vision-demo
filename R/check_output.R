#'
#' Check model outputs against standard
#' 

check_output <- function(target, current,
                         ignore_case = TRUE,
                         trim_ws = TRUE,
                         collapse_ws = TRUE,
                         tolerance = sqrt(.Machine$double.eps),
                         min_similarity = 0.5,
                         test = FALSE) {
  if (!is.data.frame(current)) current <- current[[1]]
 
  if (test) target <- target[1:3, ]

  ## layout + dimension guard ----
  x_target  <- process_extraction_output(target,  format = "wide")
  x_current <- process_extraction_output(current, format = "wide")

  ## Keep raw values for reporting, normalized values for comparison ----
  m_target  <- as.matrix(x_target)
  m_current <- as.matrix(x_current)
  
  m_target_n  <- matrix(
    normalise(
      m_target, ignore_case = ignore_case, 
      trim_ws = trim_ws, collapse_ws = collapse_ws
    ),
    nrow = nrow(m_target),
    ncol = ncol(m_target)
  )
  
  m_current_n <- matrix(
    normalise(
      m_current, ignore_case = ignore_case,
      trim_ws = trim_ws, collapse_ws = collapse_ws
    ),
    nrow = nrow(m_current),
    ncol = ncol(m_current)
  )

  ## columns must still match (same schema); only the row count may differ
  stopifnot(identical(colnames(m_target), colnames(m_current)))
  ncol_x <- ncol(m_target)

  mf <- function(a, b) cell_match(a, b, tolerance = tolerance)

  al <- align_rows(
    m_target_n, m_current_n, mf,
    key_target  = m_target[, "image"],
    key_current = m_current[, "image"],
    min_similarity = min_similarity
  )

  ## cell mismatches within matched row pairs (report RAW values)
  matched <- lapply(al$pairs, function(p) {
    ti <- p[["target"]]; ci <- p[["current"]]
    miss <- which(!mapply(mf, m_target_n[ti, ], m_current_n[ci, ]))
    if (!length(miss)) return(NULL)
    data.frame(
      target_row  = ti, current_row = ci,
      column      = colnames(m_target)[miss],
      target      = m_target[ti, miss],
      current     = m_current[ci, miss],
      kind        = "cell_mismatch",
      stringsAsFactors = FALSE
    )
  })

  cell_locs  <- do.call(rbind, matched)
  n_cellmiss <- if (is.null(cell_locs)) 0L else nrow(cell_locs)

  ## precision / recall at the cell level ----
  expected  <- nrow(m_target)  * ncol_x          # cells that SHOULD exist
  produced  <- nrow(m_current) * ncol_x          # cells the model DID emit
  tp        <- length(al$pairs) * ncol_x - n_cellmiss  # matched cells that agree

  recall    <- tp / expected                     # penalized by missing rows + wrong cells
  precision <- tp / produced                     # penalized by extra rows   + wrong cells
  
  if (precision + recall > 0) {
    f1 <- 2 * precision * recall / (precision + recall)
  } else {
    f1 <- 0
  }

  list(
    precision  = precision,
    recall     = recall,
    f1         = f1,
    tp         = tp,
    expected   = expected,
    produced   = produced,
    cell_mismatches = cell_locs,
    missing_rows    = al$missing_in_current,  # target rows with no match -> hurt recall
    extra_rows      = al$extra_in_current     # current rows with no match -> hurt precision
  )
}
