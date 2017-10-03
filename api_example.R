library(httr)
library(jsonlite)

my_auth_token <-"0846098d000418c06aa25b1031467c75baef2a9f"

call_api <- function(hosts){
  
  base_uri <- "http://api.mywot.com/0.4/public_link_json2"
  
  call_url <- paste0(base_uri, "?hosts=", hosts,"&key=",my_auth_token)
  
  message("Calling ", call_url)
  req <- GET(call_url)
  
  if(req$status_code != 200){
    stop("Problem with calling the API - response: ", content(req))
  }
  
  # this content is tricky to parse into text, so this bit is done for you
  response_content <- rawToChar(content(req, "raw"))
  json_response <- fromJSON(response_content)
  
  ## add something here to parse json_response into something readable
  json_response[[1]]$`4`
}

call_api("google.com/")
