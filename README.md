# typeahead

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/fkaduk/typeahead/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fkaduk/typeahead/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/fkaduk/typeahead/graph/badge.svg)](https://app.codecov.io/gh/fkaduk/typeahead)
<!-- badges: end -->

The `typeahead` package provides a versatile autocomplete text input component
for R Shiny applications or interactive code chunks in R markdown.

- API and default styling match the familiar `selectInput` component
- Supports bootstrap 5 theming via [`bslib`]("https://cran.r-project.org/web/packages/bslib/index.html")
- Displays suggestions inline hints and/or dropdown
- Live updating of suggestions
- [ ] Suggestions can be supplied from server or client-side
- Rich display formatting of dropdown suggestions via custom html

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

Check out the Makefile for some common operations that help development,
including `make test` and `make check`.

## TODO

- add gifs/videos to README
- add screenshots to README based on screenshot tests
- fix styling/layout issues
