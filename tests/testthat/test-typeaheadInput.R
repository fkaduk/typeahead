describe("typeaheadInput unit tests", {
  it("generates a valid Shiny input widget", {
    # WHEN/THEN
    input <- typeaheadInput(
      inputId = "my_input",
      label = "Label",
      choices = c("A", "B")
    )

    expect_s3_class(input, "shiny.tag.list")
    deps <- htmltools::findDependencies(input)
    expect_true(length(deps) > 0)
  })

  it("includes provided choices and configuration", {
    # GIVEN
    choices <- c("apple", "banana", "cherry")

    # WHEN
    input <- typeaheadInput(
      inputId = "test",
      choices = choices,
      value = "apple"
    )

    # THEN
    input_str <- as.character(input)
    expect_true(grepl("apple", input_str))
    expect_true(grepl("banana", input_str))
    expect_true(grepl("cherry", input_str))
  })

  it("works with minimal required parameters", {
    # WHEN/THEN
    expect_no_error({
      minimal_input <- typeaheadInput(inputId = "minimal")
    })

    expect_s3_class(minimal_input, "shiny.tag.list")
  })

  it("disables hint by default", {
    # WHEN
    input <- typeaheadInput(inputId = "no_hint", choices = c("A", "B"))

    # THEN
    input_str <- as.character(input)
    opts <- jsonlite::fromJSON(
      regmatches(input_str, regexpr('data-options="([^"]*)"', input_str))
      |> sub(pattern = 'data-options="', replacement = "")
      |> sub(pattern = '"$', replacement = "")
      |> gsub(pattern = "&quot;", replacement = '"')
    )
    expect_false(opts$hint)
  })

  it("converts named choices to label/html objects in data-source", {
    # GIVEN
    choices <- c(
      "Berlin" = "<strong>Berlin</strong> <small>Germany</small>",
      "Boston" = "<strong>Boston</strong> <small>USA</small>"
    )

    # WHEN
    input <- typeaheadInput(inputId = "rich", choices = choices)
    input_str <- as.character(input)

    # THEN — extract data-source JSON
    src_json <- regmatches(
      input_str,
      regexpr('data-source="([^"]*)"', input_str)
    )
    src_json <- sub('data-source="', "", src_json)
    src_json <- sub('"$', "", src_json)
    src_json <- gsub("&quot;", '"', src_json)
    src_json <- gsub("&lt;", "<", src_json)
    src_json <- gsub("&gt;", ">", src_json)
    parsed <- jsonlite::fromJSON(src_json, simplifyVector = FALSE)

    expect_type(parsed, "list")
    expect_length(parsed, 2)
    expect_equal(parsed[[1]]$label, "Berlin")
    expect_true(grepl("<strong>Berlin</strong>", parsed[[1]]$html))
    expect_equal(parsed[[2]]$label, "Boston")
  })

  it("keeps unnamed choices as a plain string array in data-source", {
    # GIVEN
    choices <- c("Apple", "Banana")

    # WHEN
    input <- typeaheadInput(inputId = "plain", choices = choices)
    input_str <- as.character(input)

    # THEN — extract data-source JSON
    src_json <- regmatches(
      input_str,
      regexpr('data-source="([^"]*)"', input_str)
    )
    src_json <- sub('data-source="', "", src_json)
    src_json <- sub('"$', "", src_json)
    src_json <- gsub("&quot;", '"', src_json)
    parsed <- jsonlite::fromJSON(src_json)

    expect_type(parsed, "character")
    expect_equal(parsed, c("Apple", "Banana"))
  })

  it("enables hint when hint = TRUE", {
    # WHEN
    input <- typeaheadInput(
      inputId = "with_hint",
      choices = c("apple", "banana"),
      hint = TRUE
    )

    # THEN
    input_str <- as.character(input)
    opts <- jsonlite::fromJSON(
      regmatches(input_str, regexpr('data-options="([^"]*)"', input_str))
      |> sub(pattern = 'data-options="', replacement = "")
      |> sub(pattern = '"$', replacement = "")
      |> gsub(pattern = "&quot;", replacement = '"')
    )
    expect_true(opts$hint)
  })
})
