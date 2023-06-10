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
      )
