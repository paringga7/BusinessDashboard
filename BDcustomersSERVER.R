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
