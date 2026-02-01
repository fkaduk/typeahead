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

  it("sends dynamically computed choices without error", {
    session <- shiny::MockShinySession$new()
    val <- "12"
    last_digit <- as.integer(substr(val, nchar(val), nchar(val)))
    next_digit <- (last_digit %% 9) + 1
    suggestion <- paste0(val, next_digit)
    expect_equal(suggestion, "123")
    expect_no_error(
      updateTypeaheadInput(session, "test", choices = suggestion)
    )
  })

  it("errors without a valid session", {
    expect_error(
      updateTypeaheadInput(session = NULL, "test", choices = c("A")),
      "must be a ShinySession"
    )
  })
})
