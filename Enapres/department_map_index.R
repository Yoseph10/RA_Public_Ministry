library(rgdal)
library(broom)
library(rgeos)
library(maptools)
library(ggplot2)
library(viridis)
library(scales)
library(stringr) #str_pad

###############################################################################
#A NIVEL DEPARTAMENTAL
###############################################################################

#Ubicación de los archivos de cartografía
dirmapas <- "C:/Ministerio Público/ENAPRES/INDICE_PERCEPCION_INSEGURIDAD/DEPARTAMENTO" 
setwd(dirmapas)

# El mapa de polígonos en blanco y negro
departamentos<-readOGR(dsn="DEPARTAMENTO_27_04_2015.shp", layer="DEPARTAMENTO_27_04_2015")

summary(departamentos)

departamentos$NOMBDEP

head(departamentos@data)

#plot(departamentos)

#Debemos transformar los datos para poder hacer un gráfico con ggplot
departamentos_fortified <- tidy(departamentos, region =  "IDDPTO")
unique(departamentos_fortified$id)

# importamos los datos que queremos insertar en el mapa
setwd("C:/Ministerio Público/ENAPRES/INDICE_PERCEPCION_INSEGURIDAD")

dep_data<- read.csv("departamentos_indice.csv")

#arreglamos el ubigeo
dep_data$id<-str_pad(dep_data$X, 2, pad = "0")

#Nos quedamos con el id y los años
dep_data <- dep_data[,c("id","A2018","A2019","A2020", "VAR_18_20")]


#Hacemos un left join
departamentos_fortified_ <-merge(x = departamentos_fortified, y = dep_data, by = c("id"), all.x = TRUE)


#Hacemos el gráfico
ggplot() +
        geom_polygon(data = departamentos_fortified_ , aes(fill = A2018, x = long, y = lat, group = group)) +
        theme_void() +
        coord_map()


#MAPA 2018
map_2018 <- ggplot() +
        geom_polygon(data = departamentos_fortified_ , aes(fill = A2018, x = long, y = lat, group = group), size=0, alpha=0.9) +
        theme_void() +
        scale_fill_viridis(option = 'D', name="Índice") +
        #labs(
         #      title = "Índice de percepción de inseguridad 2018",
          #      caption = "Fuente: Elaboración propia basada en ENAPRES"
        #)  +
        theme(  
                text = element_text(color = "#22211d"),
                
                plot.title = element_text(size= 14, hjust=0.01, color = "black", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
                plot.subtitle = element_text(size= 12, hjust=0.01, color = "#4e4d47", margin = margin(b = -0.1, t = 0.43, l = 2, unit = "cm")),
                plot.caption = element_text( size=10, color = "black", margin = margin(b = 0.3, r=-99, unit = "cm") ),
        ) +
        coord_map()

ggsave(filename = "map_2018.png", map_2018, height = 7 , width = 7)


#MAPA 2019
map_2019 <- ggplot() +
        geom_polygon(data = departamentos_fortified_ , aes(fill = A2019, x = long, y = lat, group = group), size=0, alpha=0.9) +
        theme_void() +
        scale_fill_viridis(option = 'D', name="Índice") +
        #labs(
         ##       title = "Índice de percepción de inseguridad 2019",
           #     caption = "Fuente: Elaboración propia basada en ENAPRES"
        #)  +
        theme(  
                text = element_text(color = "#22211d"),
                
                plot.title = element_text(size= 14, hjust=0.01, color = "black", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
                plot.subtitle = element_text(size= 12, hjust=0.01, color = "#4e4d47", margin = margin(b = -0.1, t = 0.43, l = 2, unit = "cm")),
                plot.caption = element_text( size=10, color = "black", margin = margin(b = 0.3, r=-99, unit = "cm") ),
        ) +
        coord_map()

ggsave(filename = "map_2019.png", map_2019, height = 7 , width = 7)



#MAPA 2020
map_2020 <- ggplot() +
        geom_polygon(data = departamentos_fortified_ , aes(fill = A2020, x = long, y = lat, group = group), size=0, alpha=0.9) +
        theme_void() +
        scale_fill_viridis(option = 'D', name="Índice") +
        #labs(
         #       title = "Índice de percepción de inseguridad 2020",
          #      caption = "Fuente: Elaboración propia basada en ENAPRES"
        #)  +
        theme(  
                text = element_text(color = "#22211d"),
                
                plot.title = element_text(size= 14, hjust=0.01, color = "black", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
                plot.subtitle = element_text(size= 12, hjust=0.01, color = "#4e4d47", margin = margin(b = -0.1, t = 0.43, l = 2, unit = "cm")),
                plot.caption = element_text( size=10, color = "black", margin = margin(b = 0.3, r=-99, unit = "cm") ),
        ) +
        coord_map()

ggsave(filename = "map_2020.png", map_2020, height = 7 , width = 7)



#MAPA VARIACIÓN PORCENTUAL 2018-2020
map_VAR <- ggplot() +
        geom_polygon(data = departamentos_fortified_ , aes(fill = VAR_18_20, x = long, y = lat, group = group), size=0, alpha=0.9) +
        theme_void() +
        scale_fill_viridis(option = 'D', name="Variación") +
        #labs(
        #       title = "Índice de percepción de inseguridad 2020",
        #      caption = "Fuente: Elaboración propia basada en ENAPRES"
        #)  +
        theme(  
                text = element_text(color = "#22211d"),
                
                plot.title = element_text(size= 14, hjust=0.01, color = "black", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
                plot.subtitle = element_text(size= 12, hjust=0.01, color = "#4e4d47", margin = margin(b = -0.1, t = 0.43, l = 2, unit = "cm")),
                plot.caption = element_text( size=10, color = "black", margin = margin(b = 0.3, r=-99, unit = "cm") ),
        ) +
        coord_map()

ggsave(filename = "map_VAR.png", map_VAR, height = 7 , width = 7)


