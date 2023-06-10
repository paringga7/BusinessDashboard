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
      )
