
require(shiny)


shinyUI(pageWithSidebar(
  headerPanel(title = 'Object Detection using Google Cloud Vision',
              windowTitle = 'Object Detection using Google Cloud Vision'),
  
  sidebarPanel(
    includeCSS('boot.css'),
    tabsetPanel(
      id = "tabs",
    tabPanel("Choose Image File",
 #              fileInput('file1', 'Upload a PNG / JPEG File:')),

        fileInput('file1', '', accept=c('.png', '.jpg')),
        helpText("receiving the response takes a while, please wait ...")
        
    )
    )
  ),
  
  mainPanel(
    h3("Image"),
    hr(),

    imageOutput('image'),
    hr(),
    h3("Google Vision Object Description"),
    tableOutput("res")

   
    
  )
))
