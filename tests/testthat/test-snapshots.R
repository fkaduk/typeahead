testthat::skip_on_os(c("mac", "windows"))

describe("typeaheadInput snapshot tests", {
  it("renders minimal UI correctly", {
    # WHEN/THEN
    ui <- typeaheadInput("minimal")
    expect_snapshot(ui)
  })

  it("renders basic UI correctly", {
    # GIVEN
    choices <- c("Apple", "Banana", "Cherry")

    # WHEN
    ui <- typeaheadInput(
      inputId = "fruits",
      label = "Select a fruit:",
      choices = choices,
      placeholder = "Start typing...",
      value = "Apple"
    )

    # THEN
    expect_snapshot(ui)
  })
})
