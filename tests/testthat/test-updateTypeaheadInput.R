describe("updateTypeaheadInput unit tests", {
  it("sends choices message without error", {
    session <- shiny::MockShinySession$new()
    expect_no_error(
      updateTypeaheadInput(session, "test", choices = c("A", "B"))
    )
  })

  it("sends value message without error", {
    session <- shiny::MockShinySession$new()
    expect_no_error(
      updateTypeaheadInput(session, "test", value = "A")
    )
  })

  it("sends label message without error", {
    session <- shiny::MockShinySession$new()
    expect_no_error(
      updateTypeaheadInput(session, "test", label = "New label")
    )
  })

  it("sends length-1 choices as a list so it serializes to a JSON array", {
    captured <- NULL
    session <- shiny::MockShinySession$new()
    session$sendInputMessage <- function(inputId, message) {
      captured <<- message
    }
    updateTypeaheadInput(session, "test", choices = "only-one")
    expect_type(captured$choices, "list")
    expect_equal(captured$choices, list("only-one"))
  })

  it("sends named choices as list of label/html objects", {
    captured <- NULL
    session <- shiny::MockShinySession$new()
    session$sendInputMessage <- function(inputId, message) {
      captured <<- message
    }
    updateTypeaheadInput(session, "test", choices = c(
      "Berlin" = "<strong>Berlin</strong>",
      "Boston" = "<strong>Boston</strong>"
    ))
    expect_type(captured$choices, "list")
    expect_length(captured$choices, 2)
    expect_equal(captured$choices[[1]]$label, "Berlin")
    expect_equal(captured$choices[[1]]$html, "<strong>Berlin</strong>")
    expect_equal(captured$choices[[2]]$label, "Boston")
  })

  it("sends unnamed choices as plain list of strings", {
    captured <- NULL
    session <- shiny::MockShinySession$new()
    session$sendInputMessage <- function(inputId, message) {
      captured <<- message
    }
    updateTypeaheadInput(session, "test", choices = c("A", "B"))
    expect_type(captured$choices, "list")
    expect_equal(captured$choices, list("A", "B"))
  })

  it("errors without a valid session", {
    expect_error(
      updateTypeaheadInput(session = NULL, "test", choices = c("A")),
      "must be a ShinySession"
    )
  })
})
