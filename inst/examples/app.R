library(shiny)
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

ui <- fluidPage(
  titlePanel("typeahead demo"),
  sidebarLayout(
    sidebarPanel(
      actionButton("update", "Switch to fruits")
    ),
    mainPanel(
      h4("Selected value:"),
      verbatimTextOutput("selected"),
      typeaheadInput(
        inputId = "city",
        label = "Choose a city:",
        choices = cities,
        placeholder = "Start typing..."
      ),
    )
  )
)

server <- function(input, output, session) {
  output$selected <- renderText({
    input$city
  })

  observeEvent(input$update, {
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
