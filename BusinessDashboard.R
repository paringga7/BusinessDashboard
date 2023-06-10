# PREP # ####
library(DBI)
library(RMySQL)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinyalert)
library(DT)
library(ggplot2)
library(plotly)
library(dplyr)
library(pier)
library(RColorBrewer)

con <- dbConnect(MySQL(), user = 'root', password = '', host = '127.0.0.1', dbname = 'classicmodels')
emp_list <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name FROM employees')
prod_list <- dbGetQuery(con, 'SELECT DISTINCT productLine FROM products')
office_list <- dbGetQuery(con, 'SELECT CONCAT(offices.city, ", ", offices.country) AS office FROM offices')
cust_list <- dbGetQuery(con, 'SELECT customerName FROM customers')

# UI # ####
shinyApp(
  ui <- fluidPage(
    navbarPage(
      title = 'Classic Models',
      windowTitle = 'Classic Models', 
      position = 'fixed-top', 
      collapsible = TRUE, 
      theme = shinytheme('cosmo'), 
      
      # OFFICES UI # ####
      
      tabPanel(title = 'Offices',
               br(),
               br(),
               br(),
               br(),
               sidebarLayout(
                 sidebarPanel(
                   width = 5,
                   inputPanel(
                     selectInput(
                       inputId = 'offices_selectOffice',
                       label = 'Office Branch:',
                       choices = office_list[order(office_list$office), ],
                       selected = office_list[order(office_list$office), ][1]
                     )
                   ),
                   inputPanel(
                     selectInput(
                       inputId = 'offices_selectProduct',
                       label = 'Products Type:',
                       choices = c('ALL', prod_list[order(prod_list$productLine), ]),
                       selected = 'ALL'
                     )
                   ),
                   
                   br(),
                   wellPanel(
                     align = 'center',
                     style = 'background-color: #33adff; color: #ffffff;',
                     h4('Branch Income Earned by Product Type'),
                     htmlOutput(
                       outputId = 'offices_wpIncome'
                     )
                   ),
                   wellPanel(
                     align = 'center',
                     style = 'background-color: #33adff; color: #ffffff;',
                     h4('Branch Best Employee'),
                     htmlOutput(
                       outputId = 'offices_wpBestemp'
                     )
                   )
                 ),
                 mainPanel(
                   width = 7,
                   align = 'center',
                   br(),
                   htmlOutput(outputId = 'offices_pieTitle'),
                   plotlyOutput(
                     outputId = 'offices_pie'
                   )
                 )
               ),
               fluidRow(
                 width = 12,
                 align = 'center',
                 htmlOutput(outputId = 'offices_lineTitle'),
                   plotOutput(
                     outputId = 'offices_line1'
                   )
                 ),
               br(),
               fluidRow(
                 width = 12,
                 dataTableOutput(
                   outputId = 'offices_table'
                 )
               ),
               br(),
               br(),
               br()
      ),
      
      # EMPLOYEES UI # ####
      
      tabPanel(title = 'Employees',
               br(),
               br(),
               br(),
               br(),
               sidebarLayout(
                 sidebarPanel(
                   width = 5,
                   inputPanel(
                     selectInput(
                       inputId = 'employees_selectEmployee',
                       label = 'Employees:',
                       choices = emp_list[order(emp_list$employee_name), ],
                       selected = emp_list[order(emp_list$employee_name), ][1]
                     )
                   ),
                   inputPanel(
                     selectInput(
                       inputId = 'employees_selectProduct',
                       label = 'Products Type:',
                       choices = prod_list[order(prod_list$productLine), ],
                       selected = prod_list[order(prod_list$productLine), ][1]
                     )
                   ),
                   br(),
                   br(),
                   h3('Employee Details'),
                   fluidRow(
                     column(
                       width = 4,
                       h5('First Name')
                     ),
                     column(
                       width = 1,
                       h5(':')
                     ),
                     column(
                       width = 6,
                       htmlOutput(outputId = 'employees_fname')
                     )
                   ),
                   fluidRow(
                     column(
                       width = 4,
                       h5('Last Name')
                     ),
                     column(
                       width = 1,
                       h5(':')
                     ),
                     column(
                       width = 6,
                       htmlOutput(outputId = 'employees_lname')
                     )
                   ),
                   fluidRow(
                     column(
                       width = 4,
                       h5('Email')
                     ),
                     column(
                       width = 1,
                       h5(':')
                     ),
                     column(
                       width = 6,
                       htmlOutput(outputId = 'employees_email')
                     )
                   ),
                   fluidRow(
                     column(
                       width = 4,
                       h5('Title')
                     ),
                     column(
                       width = 1,
                       h5(':')
                     ),
                     column(
                       width = 6,
                       htmlOutput(outputId = 'employees_title')
                     )
                   ),
                   fluidRow(
                     column(
                       width = 4,
                       h5('Office')
                     ),
                     column(
                       width = 1,
                       h5(':')
                     ),
                     column(
                       width = 6,
                       htmlOutput(outputId = 'employees_office')
                     )
                   ),
                   br(),
                   br()
                 ),
                 mainPanel(
                   width = 7,
                   align = 'center',
                   fluidRow(
                     align = 'center',
                     column(
                       width = 6,
                       wellPanel(
                         style = 'background-color: #33adff; color: #ffffff;',
                         h4('Number of Customers'),
                         htmlOutput(
                           outputId = 'employees_wpCustomer'
                         )
                       )
                     ),
                     column(
                       width = 6,
                       wellPanel(
                         style = 'background-color: #33adff; color: #ffffff;',
                         h4('Total Income Earned'),
                         htmlOutput(
                           outputId = 'employees_wpIncome'
                         )
                       )
                     )
                   ),
                   htmlOutput(outputId = 'employees_barTitle'),
                   plotOutput(
                     outputId = 'employees_bar'
                   )
                 )
               ),
               br(),
               br(),
               fluidRow(
                 dataTableOutput(
                   outputId = 'employees_table'
                 )
               ),
               br(),
               br(),
               br()
      ),
      
      # CUSTOMERS UI # ####
      
      tabPanel(title = 'Customers',
               br(),
               br(),
               br(),
               br(),
               fluidRow(
                 width = 12,
                 column(
                   width = 4,
                   align = 'center',
                   wellPanel(
                     style = 'background-color: #00ff99; color: #000000;',
                     h4('Best Customer'),
                     htmlOutput(
                       outputId = 'customers_wpBestcust'
                     )
                   )
                 ),
                 column(
                   width = 4,
                   align = 'center',
                   wellPanel(
                     style = 'background-color: #00ff99; color: #000000;',
                     h4('Highest Product Purchased'),
                     htmlOutput(
                       outputId = 'customers_wpBestitem'
                     )
                   )
                 ),
                 column(
                   width = 4,
                   align = 'center',
                   wellPanel(
                     style = 'background-color: #00ff99; color: #000000;',
                     h4('Highest Money Spent'),
                     htmlOutput(
                       outputId = 'customers_wpBestmoney'
                     )
                   )
                 )
               ),
               hr(),
               sidebarLayout(
                 sidebarPanel(
                   width = 5,
                   inputPanel(
                     selectInput(
                       inputId = 'customers_selectCustomer',
                       label = 'Customers:',
                       choices = cust_list[order(cust_list$customerName), ],
                       selected = cust_list[order(cust_list$customerName), ][1]
                     )
                   ),
                   inputPanel(
                     selectInput(
                       inputId = 'customers_selectProduct',
                       label = 'Product Type:',
                       choices = prod_list[order(prod_list$productLine), ],
                       selected = prod_list[order(prod_list$productLine), ][1]
                     )
                   ),
                   br(),
                   br(),
                   h3('Customer Details'),
                   fluidRow(
                     column(
                       width = 4,
                       h5('First Name')
                     ),
                     column(
                       width = 1,
                       h5(':')
                     ),
                     column(
                       width = 6,
                       htmlOutput(
                         outputId = 'customers_fname'
                       )
                     )
                   ),
                   fluidRow(
                     column(
                       width = 4,
                       h5('Last Name')
                     ),
                     column(
                       width = 1,
                       h5(':')
                     ),
                     column(
                       width = 6,
                       htmlOutput(
                         outputId = 'customers_lname'
                       )
                     )
                   ),
                   fluidRow(
                     column(
                       width = 4,
                       h5('Phone')
                     ),
                     column(
                       width = 1,
                       h5(':')
                     ),
                     column(
                       width = 6,
                       htmlOutput(
                         outputId = 'customers_phone'
                       )
                     )
                   ),
                   fluidRow(
                     column(
                       width = 4,
                       h5('Address')
                     ),
                     column(
                       width = 1,
                       h5(':')
                     ),
                     column(
                       width = 6,
                       htmlOutput(
                         outputId = 'customers_address'
                       )
                     )
                   ),
                   fluidRow(
                     column(
                       width = 4,
                       h5('City')
                     ),
                     column(
                       width = 1,
                       h5(':')
                     ),
                     column(
                       width = 6,
                       htmlOutput(
                         outputId = 'customers_city'
                       )
                     )
                   ),
                   br(),
                   br()
                 ),
                 mainPanel(
                   align = 'center',
                   width = 7,
                   fluidRow(
                     align = 'center',
                     column(
                       width = 6,
                       wellPanel(
                         style = 'background-color: #33adff; color: #ffffff;',
                         h4('Total Product Purchased'),
                         htmlOutput(
                           outputId = 'customers_wpItem'
                         )
                       )
                     ),
                     column(
                       width = 6,
                       wellPanel(
                         style = 'background-color: #33adff; color: #ffffff;',
                         h4('Total Money Spent'),
                         htmlOutput(
                           outputId = 'customers_wpMoney'
                         )
                       )
                     )
                   ),
                   br(),
                   htmlOutput(outputId = 'customers_pieTitle'),
                   plotlyOutput(
                     outputId = 'customers_pie'
                   )
                 )
               ),
               br(),
               br(),
               fluidRow(
                 align = 'center',
                 htmlOutput(outputId = 'customers_barTitle'),
                 plotOutput(
                   outputId = 'customers_bar'
                 )
               ),
               br(),
               br(),
               fluidRow(
                 dataTableOutput(
                   outputId = 'customers_table'
                 )
               ),
               br(),
               br(),
               br()
      ),
      
      # PRODUCTS UI # ####
      
      tabPanel(title = 'Products',
               br(),
               br(),
               br(),
               br(),
               fluidRow(
                 width = 12,
                 column(
                   width = 6,
                   inputPanel(
                     selectInput(
                       inputId = 'products_selectProduct',
                       label = 'Products Type:',
                       choices = prod_list[order(prod_list$productLine), ],
                       selected = prod_list[order(prod_list$productLine), ][1]
                     )
                   )
                 )
               ),
               br(),
               fluidRow(
                 width = 12,
                 column(
                   width = 6,
                   wellPanel(
                     align = 'center',
                     style = 'background-color: #33adff; color: #ffffff;',
                     h4('Best Product'),
                     htmlOutput(
                       outputId = 'products_wpBestprod'
                     )
                   )
                 ),
                 column(
                   width = 6,
                   wellPanel(
                     align = 'center',
                     style = 'background-color: #33adff; color: #ffffff;',
                     h4('Best Seller'),
                     htmlOutput(
                       outputId = 'products_wpBestseller'
                     )
                   )
                 )
               ),
               br(),
               fluidRow(
                 width = 12,
                 align = 'center',
                 column(
                   width = 6,
                   htmlOutput(outputId = 'products_barTitle'),
                   plotOutput(
                     outputId = 'products_bar'
                   )
                 ),
                 column(
                   width = 6,
                   htmlOutput(outputId = 'products_pieTitle'),
                   plotlyOutput(
                     outputId = 'products_pie'
                   )
                 )
               ),
               br(),
               fluidRow(
                 width = 12,
                 dataTableOutput(
                   outputId = 'products_table'
                 )
               ),
               br(),
               br(),
               br()
      )
    )),

# SERVER # ####  
  server <- function(input, output) {
    
    # OFFICESE SERVER # ####
    
    output$offices_wpIncome <- renderText(
      {
        offices_wpIncome <- dbGetQuery(con, 'SELECT CONCAT(offices.city, ", ", offices.country) AS office, products.productLine, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) AS income FROM offices JOIN employees ON offices.officeCode = employees.officeCode JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 2, 1')
        offices_wpIncome <- ifelse(input$offices_selectProduct == 'ALL', paste('$', sum(subset(offices_wpIncome, office == input$offices_selectOffice, select = income))), paste('$', sum(subset(offices_wpIncome, office == input$offices_selectOffice & productLine == input$offices_selectProduct, select = income))))
        paste0('<h4>', offices_wpIncome, '</h4>')
      }
    )
    
    output$offices_wpBestemp <- renderText(
      {
        offices_wpBestemp <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name, CONCAT(offices.city, ", ", offices.country) AS office, SUM(orderdetails.quantityOrdered) as quantity FROM employees JOIN offices ON employees.officeCode = offices.officeCode JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber WHERE orders.status = "Shipped" GROUP BY 1, 2')
        offices_wpBestemp <- subset(offices_wpBestemp, office == input$offices_selectOffice, select = c(employee_name, quantity))
        paste0('<h4>', subset(offices_wpBestemp, quantity == max(offices_wpBestemp$quantity), select = employee_name), '</h4>')
      }
    )
    
    output$offices_pieTitle <- renderText(paste0('<h3>Sales Results in ', input$offices_selectOffice, '</h3>'))
    
    output$offices_pie <- renderPlotly(
      {
        offices_pie <- dbGetQuery(con, 'SELECT CONCAT(offices.city, ", ", offices.country) AS office, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity FROM offices JOIN employees ON offices.officeCode = employees.officeCode JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 2, 1')
        offices_pie <- subset(offices_pie, office == input$offices_selectOffice)
        fig <- plot_ly(offices_pie, labels = ~productLine, values = ~quantity, type = 'pie',
                       textposition = 'inside',
                       textinfo = 'label+percent',
                       insidetextfont = list(color = '#000000'),
                       hoverinfo = 'text',
                       text = ~paste(productLine, ': ', round(quantity/sum(offices_pie$quantity)*100, 2), '%'),
                       marker = list(colors = brewer.pal(7, 'Spectral'),
                                     line = list(color = '#FFFFFF', width = 1)),
                       showlegend = FALSE)
        
        fig <- fig %>% layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                              yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        
        fig
      }
    )
    
    output$offices_lineTitle <- renderText(paste0('<h3>Cumulative Income Earned for ', input$offices_selectProduct, '</h3>'))
    
    output$offices_line1 <- renderPlot(
      {
        offices_line1 <- dbGetQuery(con, 'SELECT CONCAT(offices.city, ", ", offices.country) AS office, orders.orderDate, products.productCode, products.productName, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) AS income FROM employees JOIN offices ON employees.officeCode = offices.officeCode JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 2,4,1')
        if (input$offices_selectProduct == 'ALL') {
          offices_line1 <- subset(offices_line1, office == input$offices_selectOffice)
          offices_line1 <- offices_line1 %>% 
            group_by(orderDate) %>% 
            summarise(income = sum(income)) %>%  
            ungroup()
          offices_line1$cumsumincome <- cumsum(offices_line1$income) 
        }
        else {
          offices_line1 <- subset(offices_line1, office == input$offices_selectOffice & productLine == input$offices_selectProduct)
          offices_line1 <- offices_line1 %>% 
            group_by(orderDate) %>% 
            summarise(income = sum(income)) %>%  
            ungroup()
          offices_line1$cumsumincome <- cumsum(offices_line1$income)
        }
        
        offices_line1$orderDate <- as.Date(offices_line1$orderDate) 
        ggplot(offices_line1, aes(x = orderDate, y = cumsumincome)) +
          geom_line(color = 'red', size = 1) +
          labs(x = 'Date', y = 'Income') +
          theme_bw()
      }
    )
    
    output$offices_table <- renderDataTable(
      {
        offices_table <- dbGetQuery(con, 'SELECT CONCAT(offices.city, ", ", offices.country) AS office, orders.orderDate, products.productCode, products.productName, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) AS income FROM employees JOIN offices ON employees.officeCode = offices.officeCode JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 2,4,1')
        if (input$offices_selectProduct == 'ALL') {
          offices_table <- subset(offices_table, office == input$offices_selectOffice, select = c(orderDate, productCode, productName, productLine, quantity, income))
          colnames(offices_table) <- c('Order Date', 'Product Code', 'Product Name', 'Product Type', 'Amount Sold', 'Income')
          rownames(offices_table) <- NULL
          offices_table
        }
        else {
          offices_table <- subset(offices_table, office == input$offices_selectOffice & productLine == input$offices_selectProduct, select = c(orderDate, productCode, productName, productLine, quantity, income))
          colnames(offices_table) <- c('Order Date', 'Product Code', 'Product Name', 'Product Type', 'Amount Sold', 'Income')
          rownames(offices_table) <- NULL
          offices_table
        }
      }
    )
    
    # EMPLOYEES SERVER # ####
    
    output$employees_fname <- renderText(
      {
        employees_fname <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name, employees.firstName FROM employees')
        paste0('<h5>', subset(employees_fname, employee_name == input$employees_selectEmployee, select = firstName), '</h5>')
      }
    )
    
    output$employees_lname <- renderText(
      {
        employees_lname <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name, employees.lastName FROM employees')
        paste0('<h5>', subset(employees_lname, employee_name == input$employees_selectEmployee, select = lastName), '</h5>')
      }
    )
    
    output$employees_email <- renderText(
      {
        employees_email <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name, employees.email FROM employees')
        paste0('<h5>', subset(employees_email, employee_name == input$employees_selectEmployee, select = email), '</h5>')
      }
    )
    
    output$employees_title <- renderText(
      {
        employees_title <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name, employees.jobTitle FROM employees')
        paste0('<h5>', subset(employees_title, employee_name == input$employees_selectEmployee, select = jobTitle), '</h5>')
      }
    )
    
    output$employees_office <- renderText(
      {
        employees_office <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name, CONCAT(offices.city, ", ", offices.country) AS office FROM employees JOIN offices ON employees.officeCode = offices.officeCode')
        paste0('<h5>', subset(employees_office, employee_name == input$employees_selectEmployee, select = office), '</h5>')
      }
    )
    
    output$employees_wpCustomer <- renderText(
      {
        employees_wpCustomer <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name, customers.customerName FROM employees JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber')
        paste0('<h4>', ifelse(length(subset(employees_wpCustomer, employee_name == input$employees_selectEmployee, select = customerName)[,1]) == 0, 0, length(dplyr::count(subset(employees_wpCustomer, employee_name == input$employees_selectEmployee, select = customerName), customerName)[,1])), '</h4>')
      }
    )
    
    output$employees_wpIncome <- renderText(
      {
        employees_wpIncome <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) AS income FROM employees JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber WHERE orders.status = "Shipped" GROUP BY 1')
        paste0('<h4>', '$ ', ifelse(length(subset(employees_wpIncome, employee_name == input$employees_selectEmployee, select = income)[,1]) == 0, 0, sum(subset(employees_wpIncome, employee_name == input$employees_selectEmployee, select = income))), '</h4>')
      }
    )
    
    output$employees_barTitle <- renderText(paste0('<h3>Sales Results for ', input$employees_selectProduct))
    
    output$employees_bar <- renderPlot(
      {
        employees_bar <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name, products.productName, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity FROM employees JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 2, 3, 1')
        employees_bar <- subset(employees_bar, employee_name == input$employees_selectEmployee & productLine == input$employees_selectProduct, select = c(productName, quantity))
        employees_bar <- employees_bar[order(employees_bar$quantity, decreasing = TRUE), ]
        employees_bar$productName <- factor(employees_bar$productName, levels = employees_bar$productName)
        ggplot(employees_bar, aes(x = productName, y = quantity)) +
          geom_bar(stat = 'identity', fill = 'skyblue', color = 'blue') +
          geom_text(aes(label = quantity), nudge_y = max(employees_bar$quantity)/20) +
          theme_bw() +
          labs(x = 'Product Name', y = 'Quantity') +
          theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
      }
    )
    
    output$employees_table <- renderDataTable(
      {
        employees_table <- dbGetQuery(con, 'SELECT CONCAT(employees.firstName, " ", employees.lastName) AS employee_name, products.productCode, products.productName, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) AS income FROM employees JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 2, 3, 1')
        employees_table <- subset(employees_table, employee_name == input$employees_selectEmployee & productLine == input$employees_selectProduct, select = c(productCode, productName, productLine, quantity, income))
        colnames(employees_table) <- c('Product Code', 'Product Name', 'Product Type', 'Amount Sold', 'Income')
        rownames(employees_table) <- NULL
        employees_table
      }
    )
    
    # CUSTOMERS SERVER # ####
    output$customers_wpBestcust <- renderText(
      {
        customers_wpBestcust <- dbGetQuery(con, 'SELECT customers.customerName, SUM(orderdetails.quantityOrdered) AS quantity FROM customers JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber WHERE orders.status = "Shipped" GROUP BY 1')
        customers_wpBestcust <- subset(customers_wpBestcust, quantity == max(customers_wpBestcust$quantity), select = customerName)
        paste0('<h4>', customers_wpBestcust[1,1], '</h4>')
      }
    )
    
    output$customers_wpBestitem <- renderText(
      {
        customers_wpBestitem <- dbGetQuery(con, 'SELECT customers.customerName, SUM(orderdetails.quantityOrdered) AS quantity FROM customers JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber WHERE orders.status = "Shipped" GROUP BY 1')
        customers_wpBestitem <- subset(customers_wpBestitem, quantity == max(customers_wpBestitem$quantity), select = quantity)
        paste0('<h4>', customers_wpBestitem[1,1], '</h4>')
      }
    )
    
    output$customers_wpBestmoney <- renderText(
      {
        customers_wpBestmoney <- dbGetQuery(con, 'SELECT customers.customerName, SUM(orderdetails.quantityOrdered) AS quantity, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) AS spent FROM customers JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber WHERE orders.status = "Shipped" GROUP BY 1')
        customers_wpBestmoney <- subset(customers_wpBestmoney, quantity == max(customers_wpBestmoney$quantity), select = spent)
        paste0('<h4>', '$ ', customers_wpBestmoney[1,1], '</h4>')
      }
    )
    
    output$customers_fname <- renderText(
      {
        customers_fname <- dbGetQuery(con, 'SELECT customerName, contactFirstName FROM customers')
        customers_fname <- subset(customers_fname, customerName == input$customers_selectCustomer, select = contactFirstName)
        paste0('<h5>', customers_fname[1,1], '</h5>')
      }
    )
    
    output$customers_lname <- renderText(
      {
        customers_lname <- dbGetQuery(con, 'SELECT customerName, contactLastName FROM customers')
        customers_lname <- subset(customers_lname, customerName == input$customers_selectCustomer, select = contactLastName)
        paste0('<h5>', customers_lname[1,1], '</h5>')
      }
    )
    
    output$customers_phone <- renderText(
      {
        customers_phone <- dbGetQuery(con, 'SELECT customerName, phone FROM customers')
        customers_phone <- subset(customers_phone, customerName == input$customers_selectCustomer, select = phone)
        paste0('<h5>', customers_phone[1,1], '</h5>')
      }
    )
    
    output$customers_address <- renderText(
      {
        customers_address <- dbGetQuery(con, 'SELECT customerName, addressLine1, addressLine2 FROM customers')
        customers_address <- customers_address %>% mutate(address = ifelse(is.na(addressLine2), addressLine1, paste0(addressLine1, ", ", addressLine2)))
        customers_address <- subset(customers_address, customerName == input$customers_selectCustomer, select = address)
        paste0('<h5>', customers_address[1,1], '</h5>')
      }
    )
    
    output$customers_city <- renderText(
      {
        customers_city <- dbGetQuery(con, 'SELECT customerName, CONCAT(city, ", ", country) AS city FROM customers')
        customers_city <- subset(customers_city, customerName == input$customers_selectCustomer, select = city)
        paste0('<h5>', customers_city[1,1], '</h5>')
      }
    )
    
    output$customers_wpItem <- renderText(
      {
        customers_wpItem <- dbGetQuery(con, 'SELECT customers.customerName, SUM(orderdetails.quantityOrdered) AS quantity FROM customers JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber WHERE orders.status = "Shipped" GROUP BY 1')
        customers_wpItem <- subset(customers_wpItem, customerName == input$customers_selectCustomer, select = quantity)
        ifelse(length(customers_wpItem[,1]) == 0, 0, paste0('<h4>', customers_wpItem, '</h4>'))
      }
    )
    
    output$customers_wpMoney <- renderText(
      {
        customers_wpMoney <- dbGetQuery(con, 'SELECT customers.customerName, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) AS spent FROM customers JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber WHERE orders.status = "Shipped" GROUP BY 1')
        customers_wpMoney <- subset(customers_wpMoney, customerName == input$customers_selectCustomer, select = spent)
        ifelse(length(customers_wpMoney[,1]) == 0, 0, paste0('<h4>', '$ ', customers_wpMoney[1,1], '</h4>'))
      }
    )
    
    output$customers_pieTitle <- renderText(paste0('<h3>Product Purchased by ', input$customers_selectCustomer, '</h3>'))
    
    output$customers_pie <- renderPlotly(
      {
        customers_pie <- dbGetQuery(con, 'SELECT customers.customerName, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity FROM customers JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 1,2')
        customers_pie <- subset(customers_pie, customerName == input$customers_selectCustomer)
        fig <- plot_ly(customers_pie, labels = ~productLine, values = ~quantity, type = 'pie',
                       textposition = 'inside',
                       textinfo = 'label+percent',
                       insidetextfont = list(color = '#000000'),
                       hoverinfo = 'text',
                       text = ~paste(productLine, ': ', round(quantity/sum(customers_pie$quantity)*100, 2), '%'),
                       marker = list(colors = brewer.pal(7, 'Spectral'),
                                     line = list(color = '#FFFFFF', width = 1)),
                       showlegend = FALSE)
        
        fig <- fig %>% layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                              yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        
        fig
      }
    )
    
    output$customers_barTitle <- renderText(paste0('<h3>Product Purchased for ', input$customers_selectProduct, '</h3>'))
    
    output$customers_bar <- renderPlot(
      {
        customers_bar <- dbGetQuery(con, 'SELECT customers.customerName, products.productName, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity FROM customers JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 1,2,3')
        customers_bar <- subset(customers_bar, customerName == input$customers_selectCustomer & productLine == input$customers_selectProduct, select = c(productName, quantity))
        customers_bar <- customers_bar[order(customers_bar$quantity, decreasing = TRUE), ]
        customers_bar$productName <- factor(customers_bar$productName, levels = customers_bar$productName)
        ggplot(customers_bar, aes(x = productName, y = quantity)) +
          geom_bar(stat = 'identity', fill = 'skyblue', color = 'blue') +
          geom_text(aes(label = quantity), nudge_y = 3) +
          theme_bw() +
          labs(x = 'Product Name', y = 'Quantity') +
          theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
      }
    )
    
    output$customers_table <- renderDataTable(
      {
        customers_table <- dbGetQuery(con, 'SELECT customers.customerName, products.productCode, products.productName, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) AS spent FROM customers JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 1, 2, 3, 4')
        customers_table <- subset(customers_table, customerName == input$customers_selectCustomer & productLine == input$customers_selectProduct, select = c(productCode, productName, productLine, quantity, spent))
        colnames(customers_table) <- c('Product Code', 'Product Name', 'Product Type', 'Amount Bought', 'Money Spent')
        rownames(customers_table) <- NULL
        customers_table
      }
    )
    
    # PRODUCTS SERVER # ####
    
    output$products_wpBestprod <- renderText(
      {
        products_wpBestprod <- dbGetQuery(con, 'SELECT products.productName, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity FROM products JOIN orderdetails ON products.productCode = orderdetails.productCode JOIN orders ON orderdetails.orderNumber = orders.orderNumber WHERE orders.status = "Shipped" GROUP BY 1, 2')
        products_wpBestprod <- subset(products_wpBestprod, productLine == input$products_selectProduct, select = c(productName, quantity))
        paste0('<h4>', subset(products_wpBestprod, quantity == max(products_wpBestprod$quantity), select = productName), '</h4>')
      }
    )
    
    output$products_wpBestseller <- renderText(
      {
        products_wpBestseller <- dbGetQuery(con, 'SELECT CONCAT(offices.city, ", ", offices.country) AS office, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity FROM offices JOIN employees ON offices.officeCode = employees.officeCode JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 1, 2')
        products_wpBestseller <- subset(products_wpBestseller, productLine == input$products_selectProduct, select = c(office, quantity))
        paste0('<h4>', subset(products_wpBestseller, quantity == max(products_wpBestseller$quantity), select = office), '</h4>')
      }
    )
    
    output$products_barTitle <- renderText(paste0('<h3>Sales Results for ', input$products_selectProduct))
    
    output$products_bar <- renderPlot(
      {
        products_bar <- dbGetQuery(con, 'SELECT products.productName, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity FROM products JOIN orderdetails ON products.productCode = orderdetails.productCode JOIN orders ON orderdetails.orderNumber = orders.orderNumber WHERE orders.status = "Shipped" GROUP BY 1, 2')
        products_bar <- subset(products_bar, productLine == input$products_selectProduct, select = c(productName, quantity))
        products_bar <- products_bar[order(products_bar$quantity, decreasing = FALSE), ]
        products_bar$productName <- factor(products_bar$productName, levels = products_bar$productName)
        ggplot(products_bar, aes(x = productName, y = quantity)) +
          geom_bar(stat = 'identity', fill = 'skyblue', color = 'blue') +
          geom_text(aes(label = quantity), nudge_y = 70) +
          theme_bw() +
          labs(x = 'Product Name', y = 'Quantity') +
          theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
          coord_flip()
      }
    )
    
    output$products_pieTitle <- renderText(paste0('<h3>Sales Results for ', input$products_selectProduct, ' in Every Branches</h3>'))
    
    output$products_pie <- renderPlotly(
      {
        products_pie <- dbGetQuery(con, 'SELECT CONCAT(offices.city, ", ", offices.country) AS office, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity FROM offices JOIN employees ON offices.officeCode = employees.officeCode JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 1, 2')
        products_pie <- subset(products_pie, productLine == input$products_selectProduct)
        fig <- plot_ly(products_pie, labels = ~office, values = ~quantity, type = 'pie',
                       textposition = 'inside',
                       textinfo = 'label+percent',
                       insidetextfont = list(color = '#000000'),
                       hoverinfo = 'text',
                       text = ~paste(office, ': ', round(quantity/sum(products_pie$quantity)*100, 2), '%'),
                       marker = list(colors = brewer.pal(7, 'Spectral'),
                                     line = list(color = '#FFFFFF', width = 1)),
                       showlegend = FALSE)
        
        fig <- fig %>% layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                              yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        
        fig
      }
    )
    
    output$products_table <- renderDataTable(
      {
        products_table <- dbGetQuery(con, 'SELECT products.productCode, products.productName, products.productLine, SUM(orderdetails.quantityOrdered) AS quantity, SUM(orderdetails.quantityOrdered*orderdetails.priceEach) AS income FROM employees JOIN customers ON employees.employeeNumber = customers.salesRepEmployeeNumber JOIN orders ON customers.customerNumber = orders.customerNumber JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber JOIN products ON orderdetails.productCode = products.productCode WHERE orders.status = "Shipped" GROUP BY 2, 3')
        products_table <- subset(products_table, productLine == input$products_selectProduct)
        colnames(products_table) <- c('Product Code', 'Product Name', 'Product Type', 'Amount Sold', 'Income')
        rownames(products_table) <- NULL
        products_table
      }
    )
    
  })
