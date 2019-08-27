library(shiny)
library(shinydashboard)
library(DT)
library(rAmCharts)

Movie <- read.csv("C:\\Users\\Wel\\Downloads\\Restaurant\\movie.csv",stringsAsFactors = FALSE)

Movie <- Movie[complete.cases(Movie),]

genres <- strsplit(Movie$Genre,",")
genres <- unlist(genres)
genres <- unique(genres)

directors <- unique(Movie$Director)

actors <- strsplit(Movie$Actors,",")
actors <- unlist(actors)
actors <- unique(actors)

genre_choices <- append(genres,"Select All",after = 0)
directors_choices <- append(directors,"Select All",after = 0)
actors_choices <- append(actors,"Select All",after = 0)

highrate <- subset(Movie,Movie$Rating == max(Movie$Rating),select = (Title))
highrate


header <- dashboardHeader(title = "The Movie App") 

sidebar <- dashboardSidebar(
  sidebarMenu(
    img(src = "C:\\Users\\Wel\\Downloads\\Restaurant\\Shiny\\movie.jpg", height = 240, width = 230),
    sliderInput("Rating", "Movie according to the rating",0,10,c(0,10)),
    sliderInput("Year", "Year released", 2006, 2016, c(2006, 2016)),
    selectInput("genre_input", "Genre (a movie can have multiple genres)",genre_choices, selected = "Select All"),
    selectInput("directors_input","Director",directors_choices, selected = "Select All"),
    selectInput("actors_input","Actor",actors_choices, selected = "Select All")
  )
)



page <- dashboardBody(
  fluidRow(
    box(width = 12, amChartsOutput("top_box_office_collections"),title = "Top 10 Box Office Collections",collapsible = TRUE,solidHeader = TRUE),
    box(width = 12, amChartsOutput("top_imdb_ratings"),title = "Top 10 IMDB Ratings",collapsible = TRUE,solidHeader = TRUE)
  ),
  fluidRow(
    #box(width = 12, plotOutput("actors_wordcloud"),title = "Active Actors",collapsible = TRUE,solidHeader = TRUE),
    box(width = 12, amChartsOutput("year_on_year_movies"),title = "Year on Year Movies",collapsible = TRUE,solidHeader = TRUE)
  ),
  fluidRow(
    box(width = 12, DT::DTOutput("movies_table"),title = "All Filtered Movies",collapsible = TRUE,solidHeader = TRUE)
  )
)



ui <- dashboardPage(
  header,
  sidebar,
  page,
  skin = 'yellow')

