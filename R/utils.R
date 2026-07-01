#' 
#' Collect all targets and lists of targets in the environment
#' 
#' 
all_targets <- function(env = parent.env(environment()), 
                        type = "tar_target", 
                        add_list_names = TRUE) {
  
  ## Function to determine if an object is a type (a target), 
  ## or a list on only that type
  rfn <- function(obj) 
    inherits(obj, type) || (is.list(obj) && all(vapply(obj, rfn, logical(1))))
  
  ## Get the names of everything in the environment 
  ## (e.g. sourced in the _targets.R file)
  objs <- ls(env)
  
  out <- list()
  for (o in objs) {
    obj <- get(o, envir = env)      ## Get each top-level object in turn
    if (rfn(obj)) {                 ## For targets and lists of targets
      out[[length(out) + 1]] <- obj ## Add them to the output
      
      ## If the object is a list of targets, add a vector of the target names 
      ## to the environment So that one can call `tar_make(list_name)` to make 
      ## all the targets in that list
      if (add_list_names && is.list(obj)) {
        target_names <- vapply(obj, \(x) x$settings$name, character(1))
        assign(o, target_names, envir = env)
      }
    }
  }
  return(out)
}



#'
#' Normalisation helper
#' 

  
normalise <- function(v,
                      ignore_case  = TRUE,
                      trim_ws      = TRUE,
                      collapse_ws  = TRUE) {
  v <- as.character(v)

  ## strip leading/trailing space ----
  if (trim_ws) v <- trimws(v)
  
  ## collapse runs of whitespace ----
  if (collapse_ws) v <- gsub("[[:space:]]+", " ", v)  
  
  ## Ignore case ----
  if (ignore_case) v <- tolower(v)
  
  ## treat "" as missing
  v[!is.na(v) & v == ""] <- NA
  
  v
}


#'
#' Compare two normalized scalars, with numeric tolerance when both look numeric
#' 

cell_match <- function(a, b, tolerance = sqrt(.Machine$double.eps)) {
  ## NA == NA is a match
  if (is.na(a) && is.na(b)) return(TRUE)

  ## NA vs value is a miss
  if (is.na(a) || is.na(b)) return(FALSE)
  
  na <- suppressWarnings(as.numeric(a))
  nb <- suppressWarnings(as.numeric(b))
  
  ## both numeric -> tolerance
  if (!is.na(na) && !is.na(nb)) {         
    return(abs(na - nb) <= tolerance * max(1, abs(na), abs(nb)))
  }
  
  ## otherwise exact string match ----
  identical(a, b)                         
}


#'
#' match_fn(a, b) -> TRUE/FALSE per normalized cell.
#' min_similarity: a target/current row pair must agree on at least this
#' fraction of cells to be considered the same record; otherwise both rows
#' fall through to the unmatched (missing/extra) buckets.
#'

align_rows <- function(m_target, m_current, match_fn,
                       key_target = NULL, key_current = NULL, 
                       min_similarity = 0.5) {
  nt <- nrow(m_target); nc <- nrow(m_current)

  similarity <- matrix(0, nt, nc)
  for (i in seq_len(nt)) {
    for (j in seq_len(nc)) {
      similarity[i, j] <- mean(mapply(match_fn, m_target[i, ], m_current[j, ]))
    }
  }

  ## Only allow pairings between rows describing the same source record.
  if (!is.null(key_target) && !is.null(key_current)) {
    similarity[outer(key_target, key_current, FUN = "!=")] <- -Inf
    min_similarity <- -Inf
  }

  used_t <- logical(nt); used_c <- logical(nc)
  pairs  <- list()

  repeat {
    s <- similarity
    s[used_t, ] <- -Inf
    s[, used_c] <- -Inf
    if (!any(is.finite(s))) break
    best_val <- max(s)
    if (best_val < min_similarity) break          # <-- threshold: stop pairing weak matches
    best <- which(s == best_val, arr.ind = TRUE)[1, ]
    pairs[[length(pairs) + 1L]] <- c(target = best[[1]], current = best[[2]])
    used_t[best[[1]]] <- TRUE
    used_c[best[[2]]] <- TRUE
  }

  list(
    pairs              = pairs,
    missing_in_current = which(!used_t),
    extra_in_current   = which(!used_c)
  )
}
