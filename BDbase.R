# PREP # ####
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinyalert)

shinyApp(

  # UI # ####
  ui <- fluidPage(
    navbarPage(
      title = 'Classic Models',
      windowTitle = 'Classic Models', 
      position = 'fixed-top', 
      collapsible = TRUE, 
      theme = shinytheme('cosmo'),
      
      # OFFICES UI # ####
      tabPanel(title = 'Offices'),
      
      # EMPLOYEES UI # ####
      tabPanel(title = 'Employees'),
      
      # CUSTOMERS UI # ####
      tabPanel(title = 'Customers'),
      
      # PRODUCTS UI # ####
      tabPanel(title = 'Products')
    )
  ),
  
  # SERVER # ####
  server <- function(input, output) {
    
    # OFFICES SERVER # ####
    
    # EMPLOYEES SERVER # ####
    
    # CUSTOMERS SERVER # ####
    
    # PRODUCTS SERVER # ####
    
  }
)
