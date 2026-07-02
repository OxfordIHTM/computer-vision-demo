#'
#' Create test standards
#' 

create_test_standards <- function() {
  tibble::tribble(
    ~first_name, ~last_name,    ~age, ~sex,     ~measurements,                                                                                                                                                 ~image,
    "DINDO",     "HAGUPIT",     143,  "female", tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2020-07-31", "2020-08-06"), weight = c(20.9, 21.0), height = c(137.6, 137.6)), "student_nutrition_records_01.jpg",
    "FALCON",    "DANAS",       123,  "male",   tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2019-07-14", "2019-07-20"), weight = c(34.7, 34.7), height = c(147.0, 147.0)), "student_nutrition_records_02.jpg",
    "Samuel",    "Usagi",       132,  "female", tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2018-11-18", "2018-11-24"), weight = c(28.3, 28.5), height = c(137.4, 137.4)), "student_nutrition_records_03.jpg",
    "FLORITA",   "PRAPIROON",   124,  "female", tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2018-06-28", "2018-07-05"), weight = c(19.8, 20.1), height = c(124.5, 124.5)), "student_nutrition_records_04.jpg",
    "JOLINA",    "PAKHAR",      123,  "male",   tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2017-08-24", "2017-08-30"), weight = c(30.4, 30.7), height = c(138.4, 138.4)), "student_nutrition_records_05.jpg",
    "JOLINA",    "PAKHAR",      123,  "male",   tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2017-08-24", "2017-08-30"), weight = c(30.4, 30.7), height = c(138.4, 138.4)), "student_nutrition_records_06.jpg",
    "ISANG",     "HATO",        133,  "female", tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2017-08-20", "2017-08-26"), weight = c(20.5, 20.0), height = c(124.7, 124.7)), "student_nutrition_records_07.jpg",
    "HUANING",   "HAITANG",      11,  "male",   tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2017-07-30", "2017-08-05"), weight = c(30.0, 35.0), height = c(136.3, 136.3)), "student_nutrition_records_08.jpg",
    "GORIO",     "NESAT",       148,  "female", tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2017-07-25", "2017-07-31"), weight = c(24.5, 25.0), height = c(128.2, 130.0)), "student_nutrition_records_09.jpg",
    "EMONG",     "NANMADOL",    123,  "female", tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2017-07-02", "2017-07-08"), weight = c(29.8, 30.0), height = c(131.4, 131.4)), "student_nutrition_records_10.jpg",
    "AURING",    NA_character_, 123,  "male",   tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2017-01-07", "2017-01-13"), weight = c(20.3, 20.5), height = c(1.218, 12.80)), "student_nutrition_records_11.jpg",
    "DANTE",     "MUIFA",        13,  "male",   tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2017-04-26", "2017-05-02"), weight = c(20.3, 20.5), height = c(317.0, 32.0)),  "student_nutrition_records_12.jpg",
    "FABIAN",    "ROKE",        126,  "male",   tibble::tibble(round = factor(x = c("1", "2"), levels = c("1", "2")), date = c("2017-07-22", "2017-07-28"), weight = c(30.0, 30.1), height = c(137.3, 137.3)), "student_nutrition_records_13.jpg"
  ) |>
    dplyr::mutate(
      age = as.integer(age),
      sex = factor(x = sex, levels = c("male", "female"))
    )
}
