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
