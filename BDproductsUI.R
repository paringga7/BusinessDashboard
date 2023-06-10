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
    ))
