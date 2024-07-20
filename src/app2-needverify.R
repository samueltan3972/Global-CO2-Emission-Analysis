library(shiny)
library(shinythemes)
library(leaflet)

#country coordinates for leaflet
# Create a data frame with the countries and their coordinates
countries_data <- data.frame(
  country = c("USA", "Canada", "Mexico"),
  lat = c(37.0902, 56.1304, 23.6345),
  lng = c(-95.7129, 106.3468, 102.5528)
)


#contents split up for easier coding
AboutUs<-fluidPage(
  div(style = "background-color: #99ff0020;",
  fluidRow(
  column(width = 12, h3("What is GreenGaze?",style='font-weight:bold;color: green;'),
         p("GreenGaze is a digital tool to provide a real-time CO2 emission pattern based on the emission data collected for the world region that is visualised via Smart Dashboard",style='color: #547e5f;font-size: 18px;')),
  column(width = 12, h3("How does GreenGaze work?",style='font-weight:bold;color: green;'),
         p("GreenGaze offers predictive modelling via machine learning algorithm to forecast CO2 emission until year 2050 to ensure actionable control measures are being taken to reduce and achieve net zero carbon by 2050 ",style='color: #547e5f;font-size: 18px;')),
  column(width = 12, h3("What are the benefits?",style='font-weight:bold;color: green;'),
         p("We aim to provide a descriptive and predictive analysis on the global CO2 emissions, allowing corporations and nation leaders to make better decisions in creating a greener and healthier Earth",style='color: #547e5f;font-size: 18px;')),
  column(width = 12, h3("Who will be interested?",style='font-weight:bold;color: green;'),
         p("It is our belief that everyone should play a role in preserving mother Earth. Therefore this app is for anyone and everyone",style='color: #547e5f;font-size: 18px;')),
  
  #add image at bottom
  column(width = 12,
         img(src = "https://images.travelandleisureindia.in/wp-content/uploads/2019/02/Earth-is-Greener-feature.jpg", 
             alt = "image1", 
             width = "100%", 
             height = "auto"))#end for image column
)#end for fluid Row
)#end div
)#end for fluid page


Home<-fluidPage(
  fluidRow(
    column(width = 3,
           selectInput("dropdown", "Year:", 
                       choices = c("1990", "2010", "2020"),
                       selected = "1990"),#end drop down
           
           checkboxGroupInput("checklist", "Select items:", 
                              choices = c("USA", "Canada", "Mexico"),
                              selected = "USA",
                              inline = FALSE)
    ),
    column(width = 9,
           fluidRow(
             column(width = 4, verbatimTextOutput("text1")),
             column(width = 4, verbatimTextOutput("text2")),
             column(width = 4, verbatimTextOutput("text3"))
           ),
    textOutput("my_text"),
    leafletOutput("map", width = "100%")
    )#end column for main page
  )#end fluid row
)#end fluid page


CO2EmissionTrends<-fluidPage(
      fluidRow(
        column(width = 6,align='center', p("Global CO2 Emission Trend",style='font-weight:bold;color: green;'),
               column(width=6,align='center',textInput("plot1_StartYear","Year From (1750-2020):","1750")),
               column(width=6,align='center',textInput("plot1_EndYear","Year To (1751-2020):","2020")),
               
               plotOutput("plot1")   #plot1-4 to be changed 
               ),#end col
          
        column(width = 6,align='center', p("Proportion of Gloal CO2 Emission",style='font-weight:bold;color: green;'),
               textInput("plot2_Year","Year(1950-2020):","2020"),
               plotOutput(outputId = "plot2")
               ),#end col
               
        column(width = 6,align='center', p("Top 10 CO2 Emission Contributors Since 1950",style='font-weight:bold;color: green;'),
               textInput("plot3_Year","From 1950- Year(1951-2020):","2020"),
               plotOutput(outputId = "plot3")
               ),#end col
               
        column(width = 6,align='center', p("Top 10 CO2 Emission Contributor in 2020",style='font-weight:bold;color: green;'),
               textInput("plot4_Year","Year (1750-2020)","2020"),
               plotOutput(outputId = "plot4")
               ),#end col
        
        column(width=12,h3("Correlation Between CO2 Emission and other Factors",style='font-weight:bold;color: green;')),
        
        selectInput("corr","Plot of CO2 Emission Against Country's:",c("Population","Population Density","Size")),
        plotOutput(outputId = "plot5")
        
        
      )#end for fluid Row
)#end for fluid page


infoGuide<-fluidPage(
  h3("Data Source",style='font-weight:bold;color: green;'),
  p("The data displayed in GreenGaze is obtained from an open dataset in Kaggle.",style='color: #547e5f;font-size: 18px;'),
  p("The dataset consists of cumulative CO2 Emissions from 1750-2020 for each country, as well as population information for the countries.",style='color: #547e5f;font-size: 18px;'),
  p("Link to dataset: https://www.kaggle.com/datasets/moazzimalibhatti/co2-emission-by-countries-year-wise-17502022",style='color: #547e5f;font-size: 18px;'),
  p(" Credits to Moazzim Ali Bhatti for providing the data in Kaggle",style='color: #547e5f;font-size: 18px;'),
  
  h3("Machine Learning Algorithm",style='font-weight:bold;color: green;'),
  
)#end fluid page

CO2Forecast<-fluidPage(
  fluidRow(
  column(width=4,textInput("plot6_Year","Predict Global CO2 Emission by (2021-):","2021")),#end col
  column(width=8,
         column(width=6,verbatimTextOutput("text4")),
         column(width=6,verbatimTextOutput("text5"))
         ),#end text column
  plotOutput(outputId = "plot6")
)#end fluid row
  
)#end fluid page


contactUs<-fluidPage(
  h3("Please Contact Us for More Information:",style='font-weight:bold;color: green;'),
  column(6,
         h3("Fathia Farhana bt Agusalim"),
         p("Email: fathiafarhana@gmail.com")
  ),
  column(6,
         h3("Tan Jun Ren"),
         p("Email: lawlietren95@gmail.com")
  ),
  column(6,
         h3("Mohamad Dzul Syakimin"),
         p("Email: dzulsyakimin61@gmail.com")
  ),
  column(6,
         h3("Mavis Lee"),
         p("Email: mavislee977@gmail.com")
  ),
  column(6,
         h3("Samuel Tan Joo Woon"),
         p("Email: samuel.joowoon@gmail.com"),
         p(a("LinkedIn", href = "https://www.linkedin.com/in/samueltanjoowoon/"))
  ),
  column(6,
         h3("Lim Ee"),
         p("Email: limee97@gmail.com"),
         p(a("LinkedIn", href = "https://www.linkedin.com/in/lim-ee-b55624145"))
)
)

ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel(
    #to add title with green padding
    div(style="background-color: #3cb371; padding: 5px;", 
        h1("GreenGaze", style='color: white;'),
        p("Emission Insights at Your Fingertips - The CO2 Prediction and Trending Dashboard", style='color: black;font-size: 18px;font-weight: bold;')
        )
        ),
  
  tabsetPanel(id = "tabs", type = "tabs",
              
              tabPanel("About Us", value = "tab1",AboutUs),
              tabPanel("Home", value = "tab2",Home),
              tabPanel("CO2 Emission Trends", value = "tab3",CO2EmissionTrends),
              tabPanel("CO2 Forecast", value = "tab4",CO2Forecast),
              tabPanel("Information Guide", value = "tab5",infoGuide),
              tabPanel("Contact Us", value = "tab6",contactUs)
  )
)

server <- function(input, output) {
  #prediction
  pre_cumulative<-"61.03T"
  pre_year<-"1.64T"
  
  
  output$text1 <- renderText({ paste("You selected", input$dropdown) })
  output$text2 <- renderText(input$checklist)
  output$text3 <- renderText("92bn")
  output$my_text <- renderText("World CO2 Emission")
  output$text4<-renderText({paste("Cumulative Global CO2 Emission:\n",pre_cumulative)})
  output$text5<-renderText({paste("Global CO2 Emission in",input$plot6_Year,":\n",pre_year)})
  
  plotA<-renderPlot(plot(x=c(1,10),y=c(1,10))) #dummy plot

  #for plots
  output$plot1<-plotA #make it a plot of overall CO2 emission trend from year x to y. x and y can be define by user
  output$plot2<-plotA  #make it a plot of proportion, year can be defined by user
  output$plot3<-plotA  #make it a plot of top10 CO2 emission since 1950-user defined year
  output$plot4<-plotA  #make it a plot of top10 co2 emission contributor in year x, x defined by user
  output$plot5<-plotA  #make plot for correlations
  output$plot6<-plotA #make plot for correlations
  
 
  
  
  output$map <- renderLeaflet({
    leaflet() %>% addTiles() %>% setView(0, 0, 2)
  })
} #end server func

shinyApp(ui, server)
