library(shinytest2)
library(shiny)

describe("typeaheadInput - filtering logic", {
  it("renders gracefully with an empty dataset", {
    # GIVEN
    app <- shinytest2::AppDriver$new(
      shinyApp(
        ui = fluidPage(
          typeaheadInput(
            inputId = "empty",
            choices = character(0)
          )
        ),
        server = function(...) {}
      )
    )

    # WHEN
    app$run_js(js_input_event_set("empty", "A"))

    # THEN
    expect_true(app$get_js('document.getElementById("empty") !== null'))
    expect_equal(
      app$get_js('document.getElementById("empty").value'),
      "A"
    )
    expect_equal(
      app$get_js('document.querySelectorAll(".tt-suggestion").length'),
      0
    )
    app$stop()
  })

  it("shows correct suggestions based on single letter", {
    # GIVEN
    app <- shinytest2::AppDriver$new(
      shinyApp(
        ui = fluidPage(
          typeaheadInput(
            inputId = "city",
            choices = c("Berlin", "Boston", "Barcelona", "Brussels")
          )
        ),
        server = function(...) {}
      )
    )

    # WHEN
    app$run_js(js_input_event_set("city", "B"))
    expect_equal(app$get_js('document.getElementById("city").value'), "B")

    # THEN
    expect_equal(
      app$get_js('document.querySelectorAll(".tt-suggestion").length'),
      4
    )
    app$stop()
  })

  it("shows correct suggestions based on multiple letter", {
    # GIVEN
    app <- shinytest2::AppDriver$new(
      shinyApp(
        ui = fluidPage(
          typeaheadInput(
            inputId = "city",
            choices = c("Berlin", "Boston", "Barcelona", "Brussels")
          )
        ),
        server = function(...) {}
      )
    )

    # WHEN
    app$run_js(js_input_event_set("city", "Ber"))

    # THEN
    expect_equal(app$get_js('document.getElementById(\"city\").value'), "Ber")
    expect_equal(
      app$get_js('document.querySelectorAll(\".tt-suggestion\").length'),
      1
    )

    app$stop()
  })

  it("shows correct suggestions based on successive inputs", {
    # GIVEN
    app <- shinytest2::AppDriver$new(
      shinyApp(
        ui = fluidPage(
          typeaheadInput(
            inputId = "city",
            choices = c("Berlin", "Boston", "Barcelona", "Brussels")
          )
        ),
        server = function(...) {}
      )
    )

    # WHEN
    app$run_js(js_input_event_set("city", "B"))
    app$run_js(js_input_event_set("city", "Be"))

    # THEN
    expect_equal(app$get_js('document.getElementById(\"city\").value'), "Be")
    expect_equal(
      app$get_js('document.querySelectorAll(\".tt-suggestion\").length'),
      1
    )

    app$stop()
  })

  it("is case-insensitive", {})
  it("folds diacritics/accents", {})
  it("prioritises prefix matches over infix", {})
  it("supports regex filtering when enabled", {})
  it("highlights matched fragments", {})
  it("handles extremely long query strings (>256 chars) without crash", {})
  it("allows free-text entries when `allowFreeText = TRUE`", {})
})

describe("typeaheadInput - rich display via named choices", {
  it("renders HTML in suggestions and returns plain label on select", {
    # GIVEN
    app <- shinytest2::AppDriver$new(
      shinyApp(
        ui = fluidPage(
          typeaheadInput(
            inputId = "city",
            choices = c(
              "Berlin" = "<strong>Berlin</strong> <small>Germany</small>",
              "Boston" = "<strong>Boston</strong> <small>USA</small>",
              "Barcelona" = "<strong>Barcelona</strong> <small>Spain</small>"
            )
          ),
          verbatimTextOutput("selected")
        ),
        server = function(input, output, session) {
          output$selected <- renderText(input$city)
        }
      )
    )

    # WHEN — type "B" to trigger suggestions
    app$run_js(js_input_event_set("city", "B"))

    # THEN — should see 3 suggestions with HTML content
    suggestion_count <- app$get_js(
      'document.querySelectorAll(".tt-suggestion").length'
    )
    expect_equal(suggestion_count, 3)

    # Verify HTML rendering: suggestion should contain <strong> tags
    has_strong <- app$get_js(
      'document.querySelector(".tt-suggestion strong") !== null'
    )
    expect_true(has_strong)

    # WHEN — click first suggestion
    app$run_js(
      'document.querySelector(".tt-suggestion").click()'
    )
    app$wait_for_idle()

    # THEN — input value should be plain label, not HTML
    input_val <- app$get_js('document.getElementById("city").value')
    expect_true(input_val %in% c("Berlin", "Boston", "Barcelona"))
    expect_false(grepl("<strong>", input_val))

    app$stop()
  })

  it("updates from plain to rich choices via updateTypeaheadInput", {
    # GIVEN — start with plain choices
    app <- shinytest2::AppDriver$new(
      shinyApp(
        ui = fluidPage(
          typeaheadInput(
            inputId = "city",
            choices = c("Berlin", "Boston", "Barcelona")
          ),
          actionButton("switch_rich", "Switch to rich")
        ),
        server = function(input, output, session) {
          observeEvent(input$switch_rich, {
            updateTypeaheadInput(
              session = session,
              inputId = "city",
              choices = c(
                "Berlin" = "<strong>Berlin</strong> <small>Germany</small>",
                "Boston" = "<strong>Boston</strong> <small>USA</small>"
              )
            )
          })
        }
      )
    )

    # WHEN — switch to rich and type
    app$click("switch_rich")
    app$wait_for_idle()
    app$run_js(js_input_event_set("city", "B"))

    # THEN — should show 2 rich suggestions
    suggestion_count <- app$get_js(
      'document.querySelectorAll(".tt-suggestion").length'
    )
    expect_equal(suggestion_count, 2)

    has_strong <- app$get_js(
      'document.querySelector(".tt-suggestion strong") !== null'
    )
    expect_true(has_strong)

    app$stop()
  })
})

describe("updateTypeaheadInput - basic", {
  it("changes suggestions when button is pressed", {
    # GIVEN
    app <- shinytest2::AppDriver$new(
      shinyApp(
        ui = fluidPage(
          typeaheadInput(
            inputId = "test",
            choices = c("Apple", "Apricot", "Avocado")
          ),
          actionButton("change", "Change Suggestions")
        ),
        server = function(input, output, session) {
          observeEvent(input$change, {
            updateTypeaheadInput(
              session = session,
              inputId = "test",
              choices = c("Ananas", "Arbitrerry")
            )
          })
        }
      )
    )

    # WHEN - Type "A" to see original suggestions
    app$run_js(js_input_event_set("test", "A"))
    original_count <- app$get_js(
      'document.querySelectorAll(".tt-suggestion").length'
    )

    # Click button to change suggestions and wait for server round-trip
    app$click("change")
    app$wait_for_idle()

    new_count <- app$get_js(
      'document.querySelectorAll(".tt-suggestion").length'
    )

    # THEN - Should show new suggestions
    expect_equal(original_count, 3)
    expect_equal(new_count, 2)

    app$stop()
  })
})

# describe("typeaheadInput — accessibility semantics", {
#   it("exposes role='combobox' and toggles aria-expanded", { })
#   it("links list with aria-controls and unique ID", { })
#   it("maintains aria-activedescendant as user arrows through list", { })
#   it("announces suggestion-count changes via live region", { })
#   it("supports complete keyboard-only operation (Tab, Esc, Enter)", { })
# })
#
# describe("typeaheadInput — state & isolation", {
#   it("preserves selection on blur/focus cycles", { })
#   it("isolates suggestion lists across multiple widgets", { })
#   it("handles concurrent server updates without race conditions", { })
# })
#
# describe("updateTypeaheadInput — dynamic behaviour", {
#   it("expands the choice set and re-renders", { })
#   it("clears selection when choices become invalid", { })
#   it("shows freshly pushed suggestions while menu is open", { })
#   it("debounces rapid successive updates (≤1 refresh per 150 ms burst)", { })
#   it("resets to default on empty update", { })
# })
#
# describe("typeaheadInput — performance & resilience", {
#   it("renders <50 ms with 10 k items (virtualised)", { })
#   it("keystroke latency <100 ms under 300 ms network delay", { })
#   it("no memory growth after 1 000 open/close cycles", { })
#   it("recovers gracefully from network error with retry banner", { })
# })
#
# describe("typeaheadInput — security & edge cases", {
#   it("escapes HTML to prevent XSS in suggestions", { })
#   it("ignores duplicate keys", { })
#   it("supports RTL text entry (Arabic, Hebrew)", { })
#   it("renders correctly in IE 11 polyfilled & WebKit mobile", { })
#   it("fails loudly on malformed dataset JSON", { })
# })
#
# describe("E2E — user journeys", {
#   it("selects a suggestion and submits the form", { })
#   it("passes axe-core audit (desktop view)", { })
#   it("passes axe-core audit (mobile view)", { })
#   it("matches visual snapshots (Percy) across Chrome/Firefox/WebKit", { })
#   it("handles slow network with loading skeleton", { })
# })
