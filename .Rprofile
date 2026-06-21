## Load .env if present
if (file.exists(".env")) {
  try(readRenviron(".env"), silent = TRUE)
}


options(
  repos = c(
    CRAN = "https://cloud.r-project.org",
    IHTM = "https://oxfordihtm.r-universe.dev",
    KATILINGBAN = "https://katilingban.r-universe.dev",
    PANUKATAN = "https://panukatan.r-universe.dev",
    RAPIDSURVEYS = "https://rapidsurveys.r-universe.dev",
    "https://frankiethull.r-universe.dev"
  )
)


source("renv/activate.R")
