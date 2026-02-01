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

basic_ui <- function(...) {
  fluidPage(
    ...,
    typeaheadInput(
      inputId = "city",
      label = "City",
      choices = c("Berlin", "Boston", "Barcelona", "Brussels"),
      placeholder = "Start typing...",
      hint = TRUE
    ),
    selectInput("country", "Country", choices = c("DE", "US", "ES", "BE"))
  )
}

dark_ui <- function(...) {
  bslib::page_fluid(
    theme = bslib::bs_theme(version = 5, preset = "darkly"),
    ...,
    typeaheadInput(
      inputId = "city",
      label = "City",
      choices = c("Berlin", "Boston", "Barcelona", "Brussels"),
      placeholder = "Start typing...",
      hint = TRUE
    ),
    selectInput("country", "Country", choices = c("DE", "US", "ES", "BE"))
  )
}

describe("typeaheadInput screenshot tests", {
  it("renders idle state", {
    app <- new_app(
      shinyApp(ui = basic_ui(), server = function(...) {}),
      name = "typeahead-idle"
    )
    app$wait_for_idle()
    app$expect_screenshot()
    app$stop()
  })

  it("renders with suggestions", {
    app <- new_app(
      shinyApp(ui = basic_ui(), server = function(...) {}),
      name = "typeahead-suggestions"
    )
    app$run_js(js_input_event_set("city", "B"))
    app$wait_for_idle()
    app$expect_screenshot()
    app$stop()
  })

  it("renders with selectInput open", {
    app <- new_app(
      shinyApp(ui = basic_ui(), server = function(...) {}),
      name = "typeahead-select-open"
    )
    app$run_js('document.querySelector("#country-selectized").focus();
                document.querySelector("#country + .selectize-control .selectize-input").click();')
    app$wait_for_idle()
    app$expect_screenshot()
    app$stop()
  })

  it("renders idle state in dark theme", {
    app <- new_app(
      shinyApp(ui = dark_ui(), server = function(...) {}),
      name = "typeahead-dark-idle"
    )
    app$wait_for_idle()
    app$expect_screenshot()
    app$stop()
  })

  it("renders with suggestions in dark theme", {
    app <- new_app(
      shinyApp(ui = dark_ui(), server = function(...) {}),
      name = "typeahead-dark-suggestions"
    )
    app$run_js(js_input_event_set("city", "B"))
    app$wait_for_idle()
    app$expect_screenshot()
    app$stop()
  })

  it("renders with selectInput open in dark theme", {
    app <- new_app(
      shinyApp(ui = dark_ui(), server = function(...) {}),
      name = "typeahead-dark-select-open"
    )
    app$run_js('document.querySelector("#country-selectized").focus();
                document.querySelector("#country + .selectize-control .selectize-input").click();')
    app$wait_for_idle()
    app$expect_screenshot()
    app$stop()
  })
})
