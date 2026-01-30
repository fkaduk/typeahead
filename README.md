# typeahead

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/fkaduk/typeahead/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fkaduk/typeahead/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/fkaduk/typeahead/graph/badge.svg)](https://app.codecov.io/gh/fkaduk/typeahead)
<!-- badges: end -->

The `typeahead` package provides a versatile autocomplete text input component
for R Shiny applications or R markdown.
It wraps the typeahead-standalone JavaScript library
to deliver both server and client-side type-ahead functionality
with dropdown and inline suggestions.

## Installation

The development version can be installed from
[GitHub](https://github.com/fkaduk/typeahead) via

```r
devtools::install_github("fkaduk/typeahead")
```

## Example

Here's a basic example showing how to create a typeahead input:

``` r
library(shiny)
library(typeahead)

ui <- fluidPage(
  typeaheadInput(
    inputId = "city",
    label = "Choose a city:",
    choices = c("Berlin", "Boston", "Barcelona", "Brussels", "Buenos Aires"),
    placeholder = "Start typing..."
  ),
  
  verbatimTextOutput("selected")
)

server <- function(input, output) {
  output$selected <- renderText({
    paste("You selected:", input$city)
  })
}

shinyApp(ui = ui, server = server)
```

## Development

Check out the Makefile for some common operations that help development.

## TODO

- add gifs/videos to README
