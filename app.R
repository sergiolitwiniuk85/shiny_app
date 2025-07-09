library(shiny)
library(tidyverse)
library(DT)
library(plotly)
library(lubridate)

# Load data once when app starts
epitope_data <- read_csv("df_epitope_data.csv")

# UI
ui <- fluidPage(
  titlePanel("IEDB Epitope Dashboard"),

  sidebarLayout(
    sidebarPanel(
      selectInput("organism", "Select Organism:",
                  choices = unique(epitope_data$organism_name_epitope_data), selected = NULL, multiple = TRUE),
      selectInput("allele", "Select MHC Allele:",
                  choices = unique(epitope_data$mhc_allele_name), selected = NULL, multiple = TRUE),
      actionButton("filter", "Apply Filters")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Summary", plotlyOutput("hla_barplot")),
        tabPanel("Heatmap", plotlyOutput("heatmap")),
        tabPanel("Table", DTOutput("table"))
      )
    )
  ),

  tags$hr(),
  tags$footer(
    style = "text-align:center; padding:10px; font-size:0.9em; color:gray;",
    HTML("Data from <a href='https://www.iedb.org/' target='_blank'>IEDB</a>. Please cite:<br>
    Vita et al., <i>Nucleic Acids Research</i> (2019), <b>47</b>(D1): D339–D343.
    <a href='https://doi.org/10.1093/nar/gky1006' target='_blank'>https://doi.org/10.1093/nar/gky1006</a>")
  )
)


# Server
server <- function(input, output, session) {
  
  filtered_data <- reactive({
    data <- epitope_data
    
    if (!is.null(input$organism) && length(input$organism) > 0) {
      data <- data[data$organism_name_epitope_data %in% input$organism, ]
    }

    if (!is.null(input$allele) && length(input$allele) > 0) {
      data <- data[data$mhc_allele_name %in% input$allele, ]
    }

    return(data)
  })
  
  # Summary plot: top HLA alleles by # of Positive bindings
output$hla_barplot <- renderPlotly({
  df <- filtered_data()
  req(nrow(df) > 0)

  # Case 1: MHC allele selected, but no organism selected
  if ((is.null(input$organism) || length(input$organism) == 0) &&
      (!is.null(input$allele) && length(input$allele) > 0)) {

    df_plot <- df[df$qualitative_result == "Positive", ] |>
      dplyr::count(organism_name_epitope_data, sort = TRUE) |>
      dplyr::top_n(20, n)

    plot_ly(df_plot,
            x = ~forcats::fct_rev(forcats::fct_reorder(organism_name_epitope_data, n)),
            y = ~n,
            type = 'bar') %>%
      layout(title = "Top Organisms by Positive Binding (selected MHC allele)",
             xaxis = list(title = "Organism"),
             yaxis = list(title = "Positive Binding Count"))

  } else {
    # Default: show allele-based barplot
    df_plot <- df[df$qualitative_result == "Positive", ] |>
      dplyr::count(mhc_allele_name, sort = TRUE) |>
      dplyr::top_n(20, n)

    plot_ly(df_plot,
            x = ~forcats::fct_rev(forcats::fct_reorder(mhc_allele_name, n)),
            y = ~n,
            type = 'bar') %>%
      layout(title = "Top MHC Alleles by Positive Binding Count",
             xaxis = list(title = "MHC Allele"),
             yaxis = list(title = "Positive Binding Count"))
  }
})
  
  # Other plots (replace these later with your logic)
  output$heatmap <- renderPlotly({
    plot_ly(x = c(1, 2, 3), y = c(2, 3, 4), z = matrix(runif(9), 3, 3), type = "heatmap")
  })

  output$table <- renderDT({
    datatable(filtered_data())
  })
}


shinyApp(ui, server)
