# OFFICES SERVER # ####
    
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
