# typeahead R pkg specifications

## overview

The `typeahead` package provides autocomplete text input components for R Shiny applications and R markdown.
It wraps the typeahead-standalone JavaScript library to deliver both server- and client-side type-ahead functionality with dropdown and inline suggestions.

## expected behavior

- users can create typeahead text inputs using the `typeaheadInput()` function
- the `typeaheadInput()` function exposes core functionality of the `typeahead-standalone` JavaScript library, including:
    - independent control of hints and dropdown visibility
- users can dynamically update typeahead choices and selected values using `updateTypeaheadInput()`, following `updateSelectInput()` behavior:
    - multiple rapid calls are batched and only the final state is sent to browser after the reactive cycle completes
- default styling matches `selectInput` appearance and behavior
- supports `bslib` theming and customization
- Shiny reactivity triggers only on selection, not on every keystroke
- value semantics follow key-value pattern: server receives the key/name, not display text:
    - supports simple character vectors `c("key" = "Display")` and rich data `c("key" = list(name = "Display", img = "url"))` for template-based displays
- empty state handling: with `choices = character(0)` or `NULL`, renders functional input field with no suggestions and `NULL` value

## function APIs

```r
#' @title Create a typeahead text input
#' @description TODO
#'
#' @param inputId Character string. Unique identifier for the input element.
#' @param label Character string or NULL. Display label above the input field. 
#'      If NULL, no label is displayed.
#' @param choices=character() Character vector, named list, or list with remote configuration.
#'      Available options for autocomplete suggestions. Can be:
#'      \itemize{
#'        \item Character vector: Static local choices
#'        \item Named list: Static local choices with custom display values
#'        \item List with \code{remote} element: Remote data source configuration
#'      } 
#' @param value=NULL Character string or NULL.
#'      Pre-selected value to display in the input.
#' @param width=NULL Character string or NULL. CSS width specification 
#'      (e.g., "100%", "300px").
#' @param placeholder=NULL Character string or NULL.
#'      Placeholder text shown when input is empty.
#' @param items=8 Integer. Maximum number of suggestions to display in dropdown.
#' @param min_length=1 Integer. Minimum number of characters
#'      required before showing suggestions. 
#' @param hint=TRUE Logical. Whether to show auto-completion hints as user types. 
#' @param options List. Additional options passed to the typeahead.js library
#'
#' @return A \code{shiny.tag.list} object containing the HTML input element with 
#'   attached JavaScript dependencies and CSS styling.
#'
#' @details #TODO
#' @family typeahead functions
#' @export
#' @examples
#' \dontrun{
#' # Basic usage
#' typeaheadInput("city", "Choose a city:", 
#'                choices = c("Berlin", "Boston", "Barcelona"))
#'
#' # With custom options
#' typeaheadInput("search", "Search items:",
#'                choices = my_data$names,
#'                placeholder = "Start typing...",
#'                items = 5,
#'                min_length = 2)
#' }
```

```r
#' @title Update a typeahead input
#' @description Updates the choices, value, or configuration of an existing typeahead input
#'     from the server-side without requiring a page refresh. Dynamically replaces
#'     the suggestion list and resets the typeahead index.
#'
#' @param session Shiny session object obtained from the server function.
#' @inheritParams ...
#'
#' @return NULL 
#'
#' @details #TODO
#' @family typeahead functions
#' @export
```

## testing

- unit tests covering
    - utilities
    - valid html output of `typeaheadInput`
    - message sending without error when updating typeahead
- integration tests via shinytest2
    - ensure that typing into the field generates suggestions
    - make sure updateTypeaheads is immediately reflected in the ui
- snapshot tests
    - making sure ui works, also if other elements are displayed
    - ensure bootstrap styling via bslib works


## possible extension

- [ ] make it possible for the typeahead input to load remote data
- [ ] add `reactive_on` parameter to control when shiny reactivity triggers (e.g., "selection", "input", "debounced")
- [ ] add `template` parameter for complex entry templates with rich display formatting
- [ ] add support for remote data sources for dynamic choices
