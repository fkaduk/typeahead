#' Generate JS snippet to set input value with InputEvent semantics
#'
#' @param inputId The HTML input id (single string).
#' @param value A string to set as the input value.
#' @return A single JS string you can pass to app$run_js().
js_input_event_set <- function(inputId, value) {
  stopifnot(is.character(inputId), length(inputId) == 1L, nzchar(inputId))
  stopifnot(is.character(value), length(value) == 1L)

  id_js <- jsonlite::toJSON(inputId, auto_unbox = TRUE)
  val_js <- jsonlite::toJSON(value, auto_unbox = TRUE)

  sprintf(
    paste(
      "const el = document.getElementById(%s);",
      "if (!el) throw new Error('Element %s not found');",
      "el.focus();",
      "el.value = %s;",
      "el.dispatchEvent(new InputEvent('input', {",
      "  data: %s, inputType: 'insertText', bubbles: true",
      "}));",
      sep = "\n"
    ),
    id_js, # element ID, properly quoted
    inputId, # for friendly error message
    val_js, # the input value
    val_js # same data for InputEvent 'data'
  )
}

js_wait_for_suggestions <- function() {
  "
  !!document.querySelector('.tt-list') &&
    !document.querySelector('.tt-list').classList.contains('tt-hide') &&
    document.querySelectorAll('.tt-suggestion').length > 0
  "
}
