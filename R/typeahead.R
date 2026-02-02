#' @title typeahead-standalone dependency
#' @description Registers JS + CSS with Shiny
#' @importFrom utils modifyList
dependency_typeahead <- function() {
  htmltools::htmlDependency(
    name = "typeahead-standalone",
    version = "5.4.0",
    src = c(file = "assets"),
    script = c(
      "lib/typeahead-standalone/typeahead-standalone.umd.js",
      "js/typeahead-binding.js"
    ),
    stylesheet = c(
      "lib/typeahead-standalone/basic.css",
      "css/typeahead-shiny.css"
    ),
    package = "typeahead"
  )
}

#' @title Create a type-ahead input control
#' @description Bootstrap-styled text box with client-side autocomplete.
#' @param inputId Character string. Unique identifier for the input element.
#' @param label Character string or NULL. Display label above the input field.
#' @param choices Character vector. Available options for autocomplete suggestions.
#' @param value Character string or NULL. Initial value to display in the input.
#' @param width Character string or NULL. CSS width specification (e.g., "100%", "300px").
#' @param placeholder Character string or NULL. Placeholder text shown when input is empty.
#' @param items Integer. Maximum number of suggestions to display in dropdown (default 8).
#' @param min_length Integer. Minimum number of characters required before showing suggestions (default 1).
#' @param hint Logical. If TRUE, shows an inline suggestion (ghost text) that
#'   completes the current input based on the best match (default FALSE).
#' @param options List. Additional options passed to the typeahead.js library.
#' @return A shiny.tag.list object containing the HTML input element with attached dependencies.
#' @export
typeaheadInput <- function(
    inputId,
    label = NULL,
    choices = character(),
    value = NULL,
    width = NULL,
    placeholder = NULL,
    items = 8,
    min_length = 1,
    hint = FALSE,
    options = list()) {
  opts <- modifyList(
    list(
      limit = items,
      minLength = min_length,
      hint = hint
    ),
    options
  )

  if (!is.null(names(choices))) {
    choices <- mapply(
      function(nm, html) list(label = nm, html = html),
      names(choices), unname(choices),
      SIMPLIFY = FALSE, USE.NAMES = FALSE
    )
  }

  dep <- dependency_typeahead()

  input_tag <- htmltools::tags$input(
    id = inputId,
    type = "text",
    class = "typeahead-standalone form-control",
    autocomplete = "off",
    value = value %||% "",
    `data-source` = jsonlite::toJSON(choices, auto_unbox = TRUE),
    `data-options` = jsonlite::toJSON(opts, auto_unbox = TRUE, null = "null"),
    placeholder = placeholder,
    style = if (!is.null(width)) {
      sprintf("width:%s;", shiny::validateCssUnit(width))
    }
  )

  htmltools::tagList(
    if (!is.null(label)) htmltools::tags$label(`for` = inputId, label),
    htmltools::attachDependencies(input_tag, dep)
  )
}

#' @title Update a typeahead input
#' @description Replace choices or value of typeaheadInput
#' @param session Shiny session object (default: getDefaultReactiveDomain()).
#' @param inputId Character string. The id of the typeahead input to update.
#' @param label Character string or NULL. New display label (optional).
#' @param choices Character vector or NULL. New choices (optional).
#' @param value Character string or NULL. New selected value (optional).
#' @export
updateTypeaheadInput <- function(
    session = shiny::getDefaultReactiveDomain(),
    inputId,
    label = NULL,
    choices = NULL,
    value = NULL) {
  # emulate shiny:::validate_session_object()
  if (
    !inherits(session, c("ShinySession", "MockShinySession", "session_proxy"))
  ) {
    stop(
      "`session` must be a ShinySession object. ",
      "Did you forget to pass `session` to `updateTypeaheadInput()`?",
      call. = FALSE
    )
  }
  if (!is.null(choices) && !is.null(names(choices))) {
    choices <- mapply(
      function(nm, html) list(label = nm, html = html),
      names(choices), unname(choices),
      SIMPLIFY = FALSE, USE.NAMES = FALSE
    )
  } else if (!is.null(choices)) {
    choices <- as.list(choices)
  }

  msg <- list(
    label = label,
    choices = choices,
    value = if (!is.null(value)) as.character(value) else NULL
  )
  session$sendInputMessage(
    inputId = inputId,
    message = drop_nulls(msg)
  )
}
