
require(shiny)

require(plyr)
require(httr)

require(googleAuthR)
require(RCurl)

###################### private KEYS


options("googleAuthR.webapp.client_id" = "useYourOwn.apps.googleusercontent.com")
options("googleAuthR.webapp.client_secret" = "nteXXX")


### define scope!
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/cloud-platform"))

#googleAuthR::gar_auth()
service_token <- gar_auth_service(json_file="vision-edbe3a91d7b4.json")

############################################ helper!

detectObject <- function(txt){
  

  ### create Request, following the API Docs.
  body= paste0('{  "requests": [    {   "image": { "content": "',txt,'" }, "features": [  { "type": "LABEL_DETECTION", "maxResults": 2} ],  }    ],}')
  ## generate function call
  #print(body)
  
  simpleCall <- gar_api_generator(baseURI = "https://vision.googleapis.com/v1/images:annotate", http_header="POST" )
  ## set the request!
  pp <- simpleCall(the_body = body)
  ## obtain results.
  res <- pp$content$responses$labelAnnotations[[1]]
  
  return(res)
}


########################################################################## ########################################################################## 
########################################################################## 


shinyServer(function(input, output) {
  

  output$image <- renderImage({
    ###This is to plot uploaded image###
    if (is.null(input$file1)){
      outfile <- "Elefant-legt-sich-auf-Auto.jpg"
      contentType <- "image/jpg"
      #Panda image is the default
    }else{
      outfile <- input$file1$datapath
      contentType <- input$file1$type
      #Uploaded file otherwise
    }
    
    list(src = outfile,
         contentType=contentType,
         width=300)
  }, deleteFile = FALSE)
  
  
  ###############################################
  
  output$res <- renderTable({
    
    if (is.null(input$file1)){
      
      dff <- read.csv("base.csv")
      return(dff[, c("description", "score")])

    }else{
      
      args2 <- input$file1
 
      
      txt <- base64Encode(readBin(args2$datapath, "raw", args2$size), "txt")
      #print(txt)
      dff <<- detectObject(txt)
      
      #print(dff)
      
      return(dff[, c("description", "score")])
    }
  })
  
  
})
