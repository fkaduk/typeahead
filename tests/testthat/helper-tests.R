#' Generate JS snippet to set input value with InputEvent semantics
#'
#' Targets the .aa-Input element inside the typeahead container.
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
      "const container = document.getElementById(%s);",
      "if (!container) throw new Error('Container %s not found');",
      "const el = container.querySelector('.aa-Input');",
      "if (!el) throw new Error('Input not found in %s');",
      "el.focus();",
      "el.value = %s;",
      "el.dispatchEvent(new InputEvent('input', {",
      "  data: %s, inputType: 'insertText', bubbles: true",
      "}));",
      sep = "\n"
    ),
    id_js, # container ID
    inputId, # for friendly error message
    inputId, # for friendly error message
    val_js, # the input value
    val_js # same data for InputEvent 'data'
  )
}

#' JS condition that resolves when the autocomplete suggestion list is visible
#'
#' Returns a JavaScript expression string for use with
#' \code{app$wait_for_js()}. Evaluates to \code{TRUE} when the \code{.aa-Panel}
#' element exists and contains at least one \code{.aa-Item}.
#'
#' @return A JS expression string suitable for \code{app$wait_for_js()}.
js_wait_for_suggestions <- function() {
  "
  !!document.querySelector('.aa-Panel') &&
    document.querySelectorAll('.aa-Item').length > 0
  "
}
