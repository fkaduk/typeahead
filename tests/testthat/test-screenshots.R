library(testthat)
library(shiny)
library(shinytest2)

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
})
