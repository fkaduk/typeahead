library(shiny)
library(bslib)
library(typeahead)

cities <- c(
  "Berlin",
  "Boston",
  "Barcelona",
  "Brussels",
  "Buenos Aires",
  "Cairo",
  "Chicago",
  "Copenhagen",
  "Dublin",
  "Delhi",
  "Edinburgh",
  "Frankfurt",
  "Geneva",
  "Helsinki",
  "Hong Kong",
  "Istanbul",
  "Jakarta",
  "Kyoto",
  "Lima",
  "Lisbon",
  "London",
  "Los Angeles",
  "Madrid",
  "Melbourne",
  "Mexico City",
  "Montreal",
  "Moscow",
  "Mumbai",
  "Nairobi",
  "New York",
  "Oslo",
  "Paris",
  "Prague",
  "Rio de Janeiro",
  "Rome",
  "San Francisco",
  "Seoul",
  "Shanghai",
  "Singapore",
  "Stockholm",
  "Sydney",
  "Tokyo",
  "Toronto",
  "Vancouver",
  "Vienna",
  "Warsaw",
  "Zurich"
)

ui <- page_sidebar(
  title = "typeahead demo",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  sidebar = sidebar(
    actionButton("update", "Switch to fruits"),
    actionButton("update_cities", "Switch to cities"),
    actionButton("update_numbers", "Switch to numbers"),
    actionButton("update_rich", "Switch to rich")
  ),
  card(
    card_header("typeahead input"),
    card_body(
      typeaheadInput(
        inputId = "city",
        label = "Choose a city:",
        choices = cities,
        placeholder = "Start typing..."
      ),
      h4("Selected value:"),
      verbatimTextOutput("selected")
    )
  )
)

server <- function(input, output, session) {
  output$selected <- renderText({
    input$city
  })

  mode <- reactiveVal("cities")

  observeEvent(input$update_cities, {
    mode("cities")
    updateTypeaheadInput(
      session = session,
      inputId = "city",
      choices = cities
    )
  })

  observeEvent(input$update_numbers, {
    mode("numbers")
    updateTypeaheadInput(
      session = session,
      inputId = "city",
      choices = as.character(1:9)
    )
  })

  observe({
    req(mode() == "numbers")
    val <- input$city
    req(nzchar(val))
    last_char <- substr(val, nchar(val), nchar(val))
    last_digit <- suppressWarnings(as.integer(last_char))
    req(!is.na(last_digit))
    next_digit <- (last_digit %% 9) + 1
    suggestion <- paste0(val, next_digit)
    updateTypeaheadInput(
      session = session,
      inputId = "city",
      choices = suggestion
    )
  })

  observeEvent(input$update_rich, {
    mode("rich")
    updateTypeaheadInput(
      session = session,
      inputId = "city",
      choices = c(
        "Berlin"    = "<strong>Berlin</strong> <small class='text-muted'>Germany</small>",
        "Boston"    = "<strong>Boston</strong> <small class='text-muted'>USA</small>",
        "Barcelona" = "<strong>Barcelona</strong> <small class='text-muted'>Spain</small>",
        "Brussels"  = "<strong>Brussels</strong> <small class='text-muted'>Belgium</small>",
        "Buenos Aires" = "<strong>Buenos Aires</strong> <small class='text-muted'>Argentina</small>",
        "Cairo"     = "<strong>Cairo</strong> <small class='text-muted'>Egypt</small>",
        "Chicago"   = "<strong>Chicago</strong> <small class='text-muted'>USA</small>",
        "Copenhagen" = "<strong>Copenhagen</strong> <small class='text-muted'>Denmark</small>",
        "Dublin"    = "<strong>Dublin</strong> <small class='text-muted'>Ireland</small>",
        "London"    = "<strong>London</strong> <small class='text-muted'>UK</small>",
        "Paris"     = "<strong>Paris</strong> <small class='text-muted'>France</small>",
        "Tokyo"     = "<strong>Tokyo</strong> <small class='text-muted'>Japan</small>"
      )
    )
  })

  observeEvent(input$update, {
    mode("fruits")
    updateTypeaheadInput(
      session = session,
      inputId = "city",
      choices = c(
        "Apple",
        "Apricot",
        "Avocado",
        "Banana",
        "Blueberry",
        "Cherry",
        "Coconut",
        "Date",
        "Fig",
        "Grape",
        "Kiwi",
        "Lemon",
        "Mango",
        "Orange",
        "Papaya",
        "Peach",
        "Pear",
        "Pineapple",
        "Plum",
        "Raspberry",
        "Strawberry",
        "Watermelon"
      )
    )
  })
}

shinyApp(ui, server)
