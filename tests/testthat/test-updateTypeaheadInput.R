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

  it("errors without a valid session", {
    expect_error(
      updateTypeaheadInput(session = NULL, "test", choices = c("A")),
      "must be a ShinySession"
    )
  })
})
