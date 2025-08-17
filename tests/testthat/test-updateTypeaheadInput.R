describe("updateTypeaheadInput", {
  it("executes without error when updating choices", {
    # GIVEN
    mock_session <- list(sendInputMessage = function(id, msg) {})

    # WHEN/THEN
    expect_no_error(updateTypeaheadInput(
      session = mock_session,
      inputId = "test_input",
      choices = c("new1", "new2", "new3")
    ))
  })

  it("executes without error when updating value", {
    # GIVEN
    mock_session <- list(sendInputMessage = function(id, msg) {})

    # WHEN/THEN
    expect_no_error(updateTypeaheadInput(
      session = mock_session,
      inputId = "test_input",
      value = "selected_value"
    ))
  })

  it("works with minimal parameters", {
    # GIVEN
    mock_session <- list(sendInputMessage = function(id, msg) {})

    # WHEN/THEN
    expect_no_error(updateTypeaheadInput(
      session = mock_session,
      inputId = "test_input"
    ))
  })
})
