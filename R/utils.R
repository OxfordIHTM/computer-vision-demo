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
#' Turn a comparedf object into the extraction-scoring metrics
#'

score_comparedf <- function(cd, target, current, by) {
  s   <- summary(cd)
  obs <- s$obs.summary

  compared_vars <- setdiff(intersect(names(target), names(current)), by)
  n_vars    <- length(compared_vars)

  n_missing <- sum(obs$version == "x")   # target rows the model missed
  n_extra   <- sum(obs$version == "y")   # rows the model invented
  n_matched <- nrow(target) - n_missing  # == nrow(current) - n_extra

  n_celldiff <- arsenal::n.diffs(cd)
  expected   <- nrow(target)  * n_vars
  produced   <- nrow(current) * n_vars
  tp         <- n_matched * n_vars - n_celldiff

  recall    <- if (expected > 0) tp / expected else NA_real_
  precision <- if (produced > 0) tp / produced else NA_real_
  f1 <- if (isTRUE(precision + recall > 0))
          2 * precision * recall / (precision + recall) else 0

  per_field <- dplyr::mutate(
    s$diffs.byvar.table,
    column   = var.x,
    n_diff   = n,
    accuracy = (n_matched - n) / n_matched,
    .keep = "none"
  )

  list(
    precision       = precision,
    recall          = recall,
    f1              = f1,
    tp              = tp,
    expected        = expected,
    produced        = produced,
    n_matched_rows  = n_matched,
    cell_mismatches = arsenal::diffs(cd),        # var.x, values.x/y, + keys
    missing_rows    = obs[obs$version == "x", ], # hurt recall
    extra_rows      = obs[obs$version == "y", ], # hurt precision
    per_field       = per_field,                 # new: accuracy by field
    comparedf       = cd                         # keep raw object for reporting
  )
}
