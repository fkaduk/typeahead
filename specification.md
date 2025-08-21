# typeahead R pkg specifications

## overview

The `typeahead` package provides autocomplete text input components for R Shiny applications and R markdown.
It wraps the typeahead-standalone JavaScript library to deliver both client-side type-ahead functionality with dropdown and inline suggestions.

## expected behavior

- users can create typeahead text inputs using the `typeaheadInput()` function
- the `typeaheadInput()` function exposes core functionality of the `typeahead-standalone` JavaScript library, including:
    - independent control of hints and dropdown visibility
- users can dynamically update typeahead choices and selected values using `updateTypeaheadInput()`, following `updateSelectInput()` behavior:
    - multiple rapid calls are batched and only the final state is sent to browser after the reactive cycle completes
- default styling matches `selectInput` appearance and behavior
- supports `bslib` theming and customization
- Shiny reactivity triggers only on selection, not on every keystroke
- the api should match `selectInput` as far as is reasonable to offer a familiar interface
- empty state handling: with `choices = character(0)` or `NULL`, renders functional input field with no suggestions and `NULL` value and return value `""`

## function APIs

```r
#' @title Create a type-ahead input control
#' @description Bootstrap-styled text box with client-side autocomplete.
#' @param inputId Character string. Unique identifier for the input element.
#' @param label Character string or NULL. Display label above the input field.
#' @param choices Character vector. Available options for autocomplete suggestions.
#'   If named, displays values but returns names to server (like selectInput).
#' @param value Character string or NULL. Initial value to display in the input.
#' @param width Character string or NULL. CSS width specification (e.g., "100%", "300px").
#' @param placeholder Character string or NULL. Placeholder text shown when input is empty.
#' @param items Integer. Maximum number of suggestions to display in dropdown (default 8).
#' @param min_length Integer. Minimum number of characters required before showing suggestions (default 1).
#' @param hint Logical. Whether to show auto-completion hints as user types (default TRUE).
#' @param options List. Additional options passed to the typeahead.js library.
#' @return A shiny.tag.list object containing the HTML input element with attached dependencies.
#' @export
typeaheadInput <- function(inputId,
                           label = NULL,
                           choices = character(),
                           value = NULL,
                           width = NULL,
                           placeholder = NULL,
                           items = 8,
                           min_length = 1,
                           hint = TRUE,
                           options = list()) {
  # Implementation
}

#' @title Update a typeahead input
#' @description Replace choices or value of typeaheadInput
#' @param session Shiny session object (default: getDefaultReactiveDomain()).
#' @param inputId Character string. The id of the typeahead input to update.
#' @param label Character string or NULL. New display label (optional).
#' @param choices Character vector or NULL. New choices (optional).
#' @param value Character string or NULL. New selected value (optional).
#' @export
updateTypeaheadInput <- function(session = getDefaultReactiveDomain(),
                                 inputId,
                                 label = NULL,
                                 choices = NULL,
                                 value = NULL) {
  # Implementation  
}
```

## testing

- unit tests covering
    - utilities
    - valid html output of `typeaheadInput`
    - message sending without error when updating typeahead
- integration tests via shinytest2
    - ensure that typing into the field generates suggestions
    - make sure updateTypeahead is immediately reflected in the ui
- snapshot tests
    - making sure ui works, also if other elements are displayed
    - ensure bootstrap styling via bslib works


## possible extension

- [ ] make it possible for the typeahead input to load remote data
- [ ] add `reactive_on` parameter to control when shiny reactivity triggers (e.g., "selection", "input", "debounced")
- [ ] add `template` parameter for complex entry templates with rich display formatting
