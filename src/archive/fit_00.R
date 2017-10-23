library(shiny)
library(miniUI)
library(ggplot2)

fit_lm <- function(data) {
  
  ui <- fluidPage(    
    
    # Give the page a title
    gadgetTitleBar("Fit a linear model"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      # Define the sidebar with one input
      sidebarPanel(
        numericInput("beta0", "Intercept",30, 0, 40, 0.2),
        sliderInput("beta1", "Slope", 0, 1,0,0.05)
      ),
      mainPanel(
        plotOutput("fitPlot")  
      )
    )
  )
  
  server <- function(input, output, session) {
    # Fill in the spot we created for a plot
    output$fitPlot <- renderPlot({
      data$pred <- input$beta0 + data$x*input$beta1
      # Render a barplot
      plot(data$x,data$y)
      lines(data$x,data$pred,col="firebrick", lwd=3)
      rss <- round(sum((data$pred-data$y)^2),0)
      title(paste0("beta0 = ",input$beta0, " beta1 = ", input$beta1, 
                   "  rss = ", rss))
    })
    observeEvent(input$done, {
      stopApp(c(beta0 = input$beta0, beta1=input$beta1))
    })
  }
  runGadget(ui, server)
}

fit_lm(readRDS("data/linear.RDS"))
