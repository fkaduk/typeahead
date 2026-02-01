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

  it("errors without a valid session", {
    expect_error(
      updateTypeaheadInput(session = NULL, "test", choices = c("A")),
      "must be a ShinySession"
    )
  })
})
