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
