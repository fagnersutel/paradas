require(RJSONIO)
linha = 5983
path = paste('http://www.poatransporte.com.br/php/facades/process.php?a=il&p=', linha, sep = "")
path
json_file <- fromJSON(path)

json_file <- lapply(json_file, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})

#View(json_file)

json_file$idlinha
json_file$nome
json_file$codigo
json_file$`0`
length(json_file)

aa = do.call("rbind", json_file)
class(aa)
dim(aa)
aa = as.data.frame(aa)

library(jsonlite)
bb = fromJSON(path)
bb
class(bb)
length(bb)
bb[4]

loop = c(4:length(aa$lat))
for(i in loop){
  print( paste((i-3), aa[i,1], aa[i,2], sep = ";"))
}

library(magrittr)
library(dplyr)  
library(leaflet)
library(leaflet.extras)
lim = length(aa$lat)
lim = (lim - 3)
lim
aa = aa[4:lim,]
dim(aa)
aa$lat =  as.numeric(as.character(aa$lat))
aa$lng =  as.numeric(as.character(aa$lng))


map <- leaflet(data = aa) %>%
  addTiles() %>%
  addPolylines(aa[, 2],aa[, 1],weight=2.25,color="red") 
map


## paradas
path = paste('http://www.poatransporte.com.br/php/facades/process.php?a=tp&p=((-30.14296222668432,%20-51.87917968750003),%20(-29.79200328961529,%20-50.56082031250003))))')
path
json_file <- fromJSON(path)

paradas = as.data.frame(json_file)
paradas[1, ]
paradas$latitude = as.numeric(as.character(paradas$latitude))
paradas$longitude  = as.numeric(as.character(paradas$longitude))

map <- leaflet(data = paradas) %>%
  addTiles() %>%
  addPolylines(aa[, 2],aa[, 1],weight=2.25,color="red")  %>%
  addCircles(~paradas$longitude, ~paradas$latitude, weight = 1, radius=20, color= 'blue', stroke = TRUE, fillOpacity = 0.8)
map
