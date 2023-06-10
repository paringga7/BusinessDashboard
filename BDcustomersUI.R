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
      )
