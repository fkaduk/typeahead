library(testthat)
library(shiny)
library(shinytest2)

testthat::skip_on_ci()
testthat::skip_on_cran()

new_app <- function(..., name) {
  AppDriver$new(
    ...,
    name = name,
    variant = platform_variant(),
    seed = 1,
    width = 1280,
    height = 720
  )
}

describe("typeaheadInput screenshot tests", {
  it("renders without suggestions", {
    app <- new_app(
      shinyApp(
        ui = fluidPage(
          typeaheadInput(
            inputId = "test",
            label = "Test Input",
            choices = c("Apple", "Banana", "Cherry")
          )
        ),
        server = function(...) {}
      ),
      name = "typeahead-basic"
    )

    app$wait_for_idle()
    app$expect_screenshot()
    app$stop()
  })

  it("renders with suggestions", {
    app <- new_app(
      shinyApp(
        ui = fluidPage(
          typeaheadInput(
            inputId = "test",
            label = "Test Input",
            choices = c("Apple", "Apricot", "Banana", "Cherry"),
            placeholder = "Start typing..."
          )
        ),
        server = function(...) {}
      ),
      name = "typeahead-suggestions"
    )

    app$run_js(js_input_event_set("test", "A"))
    app$wait_for_idle()
    app$expect_screenshot()
    app$stop()
  })

  it("renders alongside other elements", {
    app <- new_app(
      shinyApp(
        ui = fluidPage(
          h3("Form"),
          textInput("name", "Name"),
          typeaheadInput(
            inputId = "test",
            label = "City",
            choices = c("Berlin", "Boston", "Barcelona", "Brussels"),
            placeholder = "Start typing..."
          ),
          selectInput("country", "Country", choices = c("DE", "US", "ES", "BE"))
        ),
        server = function(...) {}
      ),
      name = "typeahead-with-elements"
    )

    app$run_js(js_input_event_set("test", "B"))
    app$wait_for_idle()
    app$expect_screenshot()
    app$stop()
  })

  it("renders with bslib Bootstrap 5 theme", {
    app <- new_app(
      shinyApp(
        ui = bslib::page_fluid(
          theme = bslib::bs_theme(version = 5),
          typeaheadInput(
            inputId = "test",
            label = "BS5 Input",
            choices = c("Apple", "Apricot", "Banana", "Cherry"),
            placeholder = "Start typing..."
          )
        ),
        server = function(...) {}
      ),
      name = "typeahead-bslib"
    )

    app$run_js(js_input_event_set("test", "A"))
    app$wait_for_idle()
    app$expect_screenshot()
    app$stop()
  })
})
