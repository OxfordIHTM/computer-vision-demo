#'
#' Create LLM output type specification
#' 

llm_create_data_type <- function() {
  ellmer::type_array(
    ellmer::type_object(
      "Specification of expected data structure to be extracted from the images of handwritten student records",
      first_name = ellmer::type_string(
        description = "First name of the student", required = TRUE
      ),
      last_name = ellmer::type_string(
        description = "Last name of the student", required = TRUE
      ),
      age = ellmer::type_integer(
        description = "Age of the student", required = TRUE
      ),
      sex = ellmer::type_enum(
        values = c("male", "female"),
        description = "Sex of the student. Can be either male or female",
        required = TRUE
      ),
      measurements = ellmer::type_array(
        ellmer::type_object(
          .description = "Measurements of the student",
          date = ellmer::type_string(
            description = "Date of the measurement in YYYY-MM-DD format",
            required = TRUE
          ),
          weight = ellmer::type_number(
            description = "Weight of the student",
            required = TRUE
          ),
          height = ellmer::type_number(
            description = "Height of the student", 
            required = TRUE
          )
        ),
        description = "Measurements of the student. Each measurement is taken on a separate day."
      )
    )
  )
}