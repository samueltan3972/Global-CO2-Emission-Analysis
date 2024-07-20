library(shiny)
library(shinythemes)
library(leaflet)
library(janitor)
library(tidyr)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(treemap)
library(ggmap)
library(mapdata)
library(rgdal)
library(plotly)
library(classInt)
library(rvest)
library(magrittr)
library(stringr)
library(forecast)

#rm(list=ls()) #clear all var
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

#import the data
df<-read.csv("Actual_CO2.csv",header=T,na.strings=c("","NA"))
co2_emission<-df
populated_countries<-df%>%filter(Year==2020,Population>=30000000)

#ml setup
# To get global CO2 Emission and convert into time series object
accumulated_co2_by_year <- aggregate(CO2.emission ~ Year, data = co2_emission, sum)
annualized_co2_by_year <- aggregate(Actual_CO2_by_year ~ Year, data = co2_emission, sum)

# Convert the data into time series object
accumulated_co2_time_series <- ts(accumulated_co2_by_year$CO2.emission, start=1750) 
annualized_co2_time_series <- ts(annualized_co2_by_year$Actual_CO2_by_year, start=1750)
accumulated_arima_model = auto.arima(accumulated_co2_time_series)
annualized_arima_model = auto.arima(annualized_co2_time_series)


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
                       choices = unique(df$Year),
                       selected = "2020"),#end drop down
           
           checkboxGroupInput("checklist", "Select Countries:", 
                              choices = populated_countries$Country,
                              selected = "Malaysia",
                              inline = FALSE),style="overflow-y: scroll;"
    ),
    column(width = 9,
           fluidRow(
             column(width = 4, verbatimTextOutput("text1")),
             column(width = 4, verbatimTextOutput("text2")),
             column(width = 4, verbatimTextOutput("text3"))
           ),
    textOutput("my_text"),
   
    plotOutput("Home",width = "100%", height = "600px")
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
               
        column(width = 6,align='center', p("Top 10 CO2 Emission Contributors Since 1750",style='font-weight:bold;color: green;'),
               textInput("plot3_Year","From 1750 - Year(1751-2020):","2020"),
               plotOutput(outputId = "plot3")
               ),#end col
               
        column(width = 6,align='center', p("Top 10 CO2 Emission Contributor in Selected Year",style='font-weight:bold;color: green;'),
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
  p("Time series forecasting is the process used to analyse the data involve with sequence of time to make future prediction and informed decision. It is important for environmental organization such as United Nations Environment Programme (UNEP) and Intergovernmental Panel on Climate Change (IPCC) to keep track and analyse on the trend of the global CO2 emission. This allows the authority to give early warning and taking necessary action to preserve and protect the environment. In this project, time series forecasting model is used to predict the global emissions by 2050. The project is using R and R package, forecast for modelling"),
  p("The dataset is first being cleaned and processed. Then, it is split into accumulative and annualized global co2 emission. The R package, forecast is used for time series data, where the data is converted into time series object"),
  p("Linear, Arima, Naive, Tbats and Holt models were evaluated and Arima was found to be the most accurate, and therefore used for the predictions in GreenGaze")
)#end fluid page

CO2Forecast<-fluidPage(
  fluidRow(
  column(width=4,textInput("plot6_Year","Predict Global CO2 Emission by (2021-):","2050")),#end col
  column(width=8,
         column(width=6,verbatimTextOutput("text4")),
         column(width=6,verbatimTextOutput("text5"))
         ),#end text column
  
  column(width = 12,align='center', p("Cumulative Global CO2 Emission",style='font-weight:bold;color: green;'),
         plotOutput(outputId = "plot6")
  ),#end col
  
  column(width = 12,align='center', p("Global CO2 Emission",style='font-weight:bold;color: green;'),
         plotOutput(outputId = "plot7")
  )#end col
  
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
  #Modelling
  
  
  co2_emission <- read.csv("Actual_CO2.csv")
  # To get global CO2 Emission and convert into time series object
  accumulated_co2_by_year <- aggregate(CO2.emission ~ Year, data = co2_emission, sum)
  annualized_co2_by_year <- aggregate(Actual_CO2_by_year ~ Year, data = co2_emission, sum)
  
  # Convert the data into time series object
  accumulated_co2_time_series = ts(accumulated_co2_by_year$CO2.emission, start=1750) 
  annualized_co2_time_series = ts(annualized_co2_by_year$Actual_CO2_by_year, start=1750) 
  
  
  
  output$text1 <- renderText({ paste("You selected", input$dropdown) })
  output$text2 <- renderText(input$checklist)
  output$text3 <- renderText("92bn")
  output$my_text <- renderText("World CO2 Emission")

  
  
  plotDummy<-renderPlot(plot(x=c(1,10),y=c(1,10))) #dummy plot
  
  #To setup Home Interactive Map
  
  theMap <-renderPlot({
    
    year <- input$dropdown
    user_country<-input$checklist
    
    
    co2_emission <- read.csv("Actual_CO2.csv")
    
    
    df<-co2_emission%>%filter(Year==as.numeric(year))%>%select(c(Country,Actual_CO2_by_year))%>%arrange(desc(Actual_CO2_by_year))
    names(df)[[2]]<-"co2"
    #new column to set to 1 if country selected by user
    df<-df%>%mutate(selected=ifelse(Country %in% user_country,1,0))
    
    map.world <- map_data("world")
    names(map.world)[[5]]<-"Country"
    
    df$Country<-recode(df$Country,
                       'United States'='USA',
                       'United Kingdom'='UK',
                       'Trinidad and Tobago'='Trinidad',
                       'Eswatini'='Swaziland',
                       'Antigua and Barbuda'='Antigua',
                       'Saint Kitts and Nevis'='Saint Kitts',
                       'Saint Vincent and the Grenadines'='Saint Vincent'
    )
    total<-sum(df$co2)
    output$text3 <- renderText(paste0("Global CO2 Emission: ",total,"Tons"))
    
    map.world_joined <- left_join(df, map.world, by = 'Country')
    ggplot(map.world_joined, aes( x = long, y = lat, group = group )) +
      geom_polygon(aes(color=as.factor(selected),fill = co2))+
      scale_fill_gradient(low="blue", high="red")+
      scale_color_manual(values = c('1' = 'yellow','0'='NA'))+
      
      
      guides(fill = guide_legend(reverse = T)) +
      
      labs(fill = 'CO2 Emission'
           ,title = paste('Global CO2 Emission in',year)
           ,subtitle = 'CO2 Emission In Tons'
           ,x = NULL
           ,y = NULL)+
      
      theme(text = element_text( color = '#EEEEEE')
            ,plot.title = element_text(size = 28)
            ,plot.subtitle = element_text(size = 14)
            ,axis.ticks = element_blank()
            ,axis.text = element_blank()
            ,panel.grid = element_blank()
            ,panel.background = element_rect(fill = '#333333')
            ,plot.background = element_rect(fill = '#333333')
            ,legend.position = c(.18,.36)
            ,legend.background = element_blank()
            ,legend.key = element_blank()
      )
    
  })
  
  
  #To setup plotA
  df<-read.csv("Actual_CO2.csv")
  
  
  data_input_A <- reactive({
    startyear_input <- input$plot1_StartYear
    endyear_input <- input$plot1_EndYear
    df %>% filter(Year >= startyear_input, Year <=endyear_input)%>%
      group_by(Year) %>%summarize(Total_CO2 = sum(Actual_CO2_by_year))
  })

  plotA <- renderPlot({
    ggplot(data = data_input_A(), aes(x=Year,y=Total_CO2)) +geom_line()+ geom_line(color="Blue")+ ggtitle("Global CO2 Emission")+
      xlab("Year")+
      ylab("Global CO2 Emission (Tons)") #+xlim(input$plot1_StartYear,input$plot1_EndYear)
  })
  
  #To setup plotB
  data_input_B <- reactive({
    year_input_B <- input$plot2_Year
    CO2_proportion<-df %>% filter(Year == year_input_B)%>%adorn_percentages(denominator = "col")
  })
  
  #add proportion of CO2 emission
  #CO2_proportion<-CO2_2020[c("Country","year_input_B")]
  #CO2_proportion<-df %>% filter(Year == year_input_B)%>%adorn_percentages(denominator = "col")
  
  #create treemap to show proportion of CO2 emission
  plotB<- renderPlot({
    year_input_B <- input$plot2_Year
    data_year_inputx <- df %>% filter(Year == year_input_B)
    treemap(data_year_inputx, index = c("Country", "Year"), vSize = "Actual_CO2_by_year", vColor = "Actual_CO2_by_year", type = "value",
            palette = "YlOrRd", title = paste("CO2 Emission by Country in", year_input_B))
  })
  
  
  #To setup plotC
  data_input_C <- reactive({
    year_input <- input$plot3_Year
    df %>% filter(Year >= 1750, Year <=year_input)%>%
      group_by(Country) %>%summarize(Total_CO2 = sum(Actual_CO2_by_year))%>%
      top_n(10, Total_CO2)
  })
  
  
  plotC <- renderPlot({
    ggplot(data = data_input_C(), aes(x = reorder(Country, -Total_CO2), y = Total_CO2)) +
      geom_bar(stat = "identity") +
      xlab("Country") +
      ylab("Total CO2 Emission (1750 - input year)")
  })
  
  #To setup plotD
  data_year_input <- reactive({
    year_input <- input$plot4_Year
    df %>% filter(Year == year_input)
  })
  
  top_10_countries <- reactive({
    data_year_input() %>%
      top_n(10, Actual_CO2_by_year)
  })
  
  plotD <- renderPlot({
    ggplot(data = top_10_countries(), aes(x = reorder(Country, -Actual_CO2_by_year), y = Actual_CO2_by_year)) +
      geom_bar(stat = "identity")+ xlab("Country") +ylab("CO2 Emissions (in Tons)")
  })
  
  #To setup plotE
  
  data_input_E <- reactive({
    selection_input <- input$corr
    CO2_2020<-df %>% filter(Year == 2020)
  })
  
  plotE <- renderPlot({
    CO2_2020<-df %>% filter(Year == 2020)
    if(input$corr == "Population"){
      ggplot(CO2_2020,aes(x=Population,y=Actual_CO2_by_year))+geom_point(color="blue")+
        ggtitle("Relationship Between Population of a Country vs CO2 Emission")+
        geom_text(aes(label=ifelse(Population>2.5E8,as.character(Country),'')),hjust=0.2,vjust=1.4)+
        xlab("Population in 2020")+
        ylab("CO2 Emission in 2020")
      } else if(input$corr == "Size"){
      ggplot(CO2_2020,aes(x=Area,y=Actual_CO2_by_year))+geom_point(color="darkgrey")+
        ggtitle("Relationship Between Size of a Country vs CO2 Emission")+
        geom_text(aes(label=ifelse(Area>5E6,as.character(Country),'')),hjust=0.5,vjust=1.4,size=3)+
        xlab("Size of Country (km2)")+
        ylab("CO2 Emission in 2020")
      }else if(input$corr == "Population Density"){
       ggplot(CO2_2020,aes(x=density,y=Actual_CO2_by_year))+geom_point(color="steelblue")+
        ggtitle("Relationship Between density of a Country vs CO2 Emission")+
        geom_text(aes(label=ifelse(density>2000,as.character(Country),'')),hjust=0.5,vjust=1.4,size=3)+
        geom_text(aes(label=ifelse(CO2_2020[,5]>3E9,as.character(Country),'')),hjust=0.5,vjust=1.4,size=3)+
        xlab("Density of Country (population/km2)")+
        ylab("CO2 Emission in 2020")
        
      }
    
  })
  

  
  #Arima Model
  
  user_year<-reactive({
    user_year<-as.integer(input$plot6_Year)
  })
  
  pre_cumulative<-reactive({
    accumulated_arima_predicted <- forecast(accumulated_arima_model, h = as.integer(user_year()-2020))
    accumulated_arima_predicted <-data.frame(accumulated_arima_predicted)
    pre_cumulative<-tail(accumulated_arima_predicted,1)[1]
  })
  
  pre_year<-reactive({
    annualized_arima_predicted <- forecast(annualized_arima_model, h = as.integer(user_year()-2020))
    annualized_arima_predicted <-data.frame(annualized_arima_predicted)
    pre_year<-tail(annualized_arima_predicted,1)[1]
  })
  
  output$text4<-renderText({paste("Cumulative Global CO2 Emission by",user_year(),":\n",pre_cumulative(),"Ton")})
  output$text5<-renderText({paste("Global CO2 Emission in",user_year(),":\n",pre_year(),"Ton")})
  
  plotF<-renderPlot({
    accumulated_arima_predicted <- forecast(accumulated_arima_model, h = as.integer(user_year()-2020))
    plot(accumulated_arima_predicted,xlab="Year",ylab="Global Cumulative CO2 Emission From 1750 onwards (with forecast)")
  })
  
  plotG<-renderPlot({
    annualized_arima_predicted <- forecast(annualized_arima_model, h = as.integer(user_year()-2020))
    plot(annualized_arima_predicted,xlab="Year",ylab="Annual Global CO2 Emission From 1750 onwards (with forecast)")
  })
  

  #for plots
  output$plot1<-plotA #make it a plot of overall CO2 emission trend from year x to y. x and y can be define by user
  output$plot2<-plotB  #make it a plot of proportion, year can be defined by user
  output$plot3<-plotC  #make it a plot of top10 CO2 emission since 1950-user defined year
  output$plot4<-plotD  #make it a plot of top10 co2 emission contributor in year x, x defined by user
  output$plot5<-plotE  #make plot for correlations
  output$plot6<-plotF #make plot for prediction
  output$plot7<-plotG #make plot for prediction
  output$Home<-theMap

} #end server func

shinyApp(ui, server)
