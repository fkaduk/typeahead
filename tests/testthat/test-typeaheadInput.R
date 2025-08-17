describe("typeaheadInput", {
  it("generates a valid Shiny input widget", {
    # WHEN/THEN
    input <- typeaheadInput("my_input", "Label", choices = c("A", "B"))

    expect_s3_class(input, "shiny.tag.list")
    deps <- htmltools::findDependencies(input)
    expect_true(length(deps) > 0)
  })

  it("includes provided choices and configuration", {
    # GIVEN
    choices <- c("apple", "banana", "cherry")

    # WHEN
    input <- typeaheadInput("test", choices = choices, value = "apple")

    # THEN
    # Should contain choices data and initial value somewhere in structure
    input_str <- as.character(input)
    expect_true(grepl("apple", input_str))
    expect_true(grepl("banana", input_str))
  })

  it("works with minimal required parameters", {
    # WHEN/THEN
    expect_no_error(typeaheadInput("minimal"))

    minimal_input <- typeaheadInput("minimal")
    expect_s3_class(minimal_input, "shiny.tag.list")
  })
})
