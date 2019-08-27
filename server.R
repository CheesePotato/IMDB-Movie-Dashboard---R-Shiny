

library(shiny)

shinyServer(function(input, output) {
   
 filtered_data <- reactive({
   my_Data <- Movie
   my_Data <- my_Data[(my_Data$Year>=input$Year[1]) & (my_Data$Year<=input$Year[2]),]
   my_Data <- my_Data[(my_Data$Rating>=input$Rating[1]) & (my_Data$Rating<=input$Rating[2]),]
   
   if(input$genre_input != "Select All"){
     my_Data <- my_Data[grepl(input$genre_input,my_Data$Genre),]
   }
   
   if(input$directors_input != "Select All"){
     my_Data <- my_Data[grepl(input$directors_input,my_Data$Director),]
   }
   
   if(input$actors_input != "Select All"){
     my_Data <- my_Data[grepl(input$actors_input,my_Data$Actors),]
   }
   my_Data
 })
 
 output$top_box_office_collections <- renderAmCharts({
   box_office_collections_plot <- filtered_data()
   box_office_collections_plot <- box_office_collections_plot[order(box_office_collections_plot$Revenue..Millions., decreasing = T), ]
   box_office_collections_plot <- head(box_office_collections_plot, 10)
   amBarplot(x = "Title", y = "Revenue..Millions.", data = box_office_collections_plot,
             labelRotation = -45) 
 })
 
 output$top_imdb_ratings <- renderAmCharts({
   top_imdb_ratings_plot <- filtered_data()
   top_imdb_ratings_plot <- top_imdb_ratings_plot[order(top_imdb_ratings_plot$Rating, decreasing = T), ]
   top_imdb_ratings_plot <- head(top_imdb_ratings_plot, 10)
   amBarplot(x = "Title", y = "Rating", data = top_imdb_ratings_plot,
             labelRotation = -45)
 })
 
 output$year_on_year_movies <- renderAmCharts({
   year_on_year_movies <- filtered_data()
   year_on_year_movies <- as.data.frame(table(year_on_year_movies$Year))
   colnames(year_on_year_movies) <- c("Year", "Movies")
   amBarplot(x = "Year", y = "Movies", data = year_on_year_movies,
             labelRotation = -45)
 })
 
 library(wordcloud)
 output$actors_wordcloud <- renderPlot({
   actors_wordcloud_plot <- filtered_data()
   actors_wordcloud_plot <- strsplit(actors_wordcloud_plot$Actors, ",")
   actors_wordcloud_plot <- unlist(actors_wordcloud_plot)
   actors_wordcloud_plot <- gsub(" ", "", actors_wordcloud_plot)
   wordcloud(actors_wordcloud_plot)
 })
 
 output$movies_table <- renderDT({ 
   filtered_movies_table <- filtered_data()
   filtered_movies_table <- filtered_movies_table[, c("Title", "Genre", "Description", "Director", "Actors", "Rating")]
   DT::datatable(filtered_movies_table)
   
 })
 
 
    
})
