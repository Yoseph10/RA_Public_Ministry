library(dplyr) 
library(survey)
library(haven)
library(ggplot2)

setwd("C:/Ministerio Público/ENAPRES/dta/seguridad_ciudadana")

#importamos las bases de datos (enapres_2018, enapres_2019, enapres_2020)

for (i in 2018:2020){
        
        assign( paste0("enapres_",i),
                read_stata(paste0("CAP600_ENAPRES_",i,".dta") ) )
        
}

#vector con las bases de datos creadas
datasets <- c("enapres_2018", "enapres_2019", "enapres_2020") 


#ver la clase de la variable FACTOR
for (i in datasets){
        
        base <- get(i)
        print( class(base$FACTOR) )
        
}


#convertimos la variable factor en numérico para cada base. Creamos la variable FACTOR_

for (i in datasets){
        
        base <- get(i)
        base$FACTOR_ <- as.numeric(base$FACTOR)
        assign(i, base)
        
}


#convertimos las variables de percepción de inseguridad en númericas

var_inseguridad <- c("P611_1", "P611_2", "P611_3", "P611_4", "P611_5", "P611_6", "P611_7", "P611_8", "P611_9",
              "P611_10", "P611_11", "P611_12", "P611_13")

for (i in datasets){
        
        base <- get(i)
        base[var_inseguridad] <- sapply(base[var_inseguridad], as.numeric)
        assign(i, base)
        
}

#Eliminamos las observaciones que contengan NA en todas las variables de percepción de inseguridad

for (i in datasets){
        
        base <- get(i)
        base <- base[!is.na(base$P611_1) & !is.na(base$P611_2) & !is.na(base$P611_3) & !is.na(base$P611_4) & !is.na(base$P611_5) 
            & !is.na(base$P611_6) & !is.na(base$P611_7) & !is.na(base$P611_8) & !is.na(base$P611_9) & !is.na(base$P611_10) 
            & !is.na(base$P611_11) & !is.na(base$P611_12) & !is.na(base$P611_13),]
        assign(i, base)
        
}

#Creamos una variable que tengan el valor de 1 si es que la persona al menos tiene percepción de inseguridad por alguno de los 13 items.
# 0 si es que no presenta ninguna percepción de inseguridad

for (i in datasets){
        
        base <- get(i)
        
        base <- mutate(base , indicador_inei =
                               case_when( P611_1 == 1 | P611_2 == 1 | P611_3 == 1 | P611_4 == 1 | P611_5 == 1 |
                                          P611_6 == 1 | P611_7 == 1 | P611_8 == 1 | P611_9 == 1 | P611_10 == 1 |
                                          P611_11 == 1 | P611_12 == 1 | P611_13 == 1 ~ 1,
                                          
                                          TRUE ~ 0
                               ))
        assign(i, base)
        
}


#Creamos una variable que tenga el valor de 1 si es que la persona siente percepción de inseguridad ciudadana por un item
# y 0 si es que no lo siente

for (i in datasets){
        
        base <- get(i)
        base <- base %>% 
                mutate_at(vars(P611_1, P611_2, P611_3, P611_4, P611_5, P611_6, P611_7, P611_8, P611_9, P611_10,
                               P611_11, P611_12, P611_13), recode,'1'='1', '2'='0', '3'='0', '4'='0') 
        assign(i, base)
        
}


#Creamos una variable que sume los trece items anteriores. La suma estaría entre 0 y 13

for (i in datasets){
        
        base <- get(i)
        base[var_inseguridad] <- sapply(base[var_inseguridad], as.numeric)
        base$suma <- base$P611_1 + base$P611_2 + base$P611_3 + base$P611_4 + base$P611_5 + base$P611_6 + base$P611_7 +
                     base$P611_8 + base$P611_9 + base$P611_10 + base$P611_11 + base$P611_12 + base$P611_13
        assign(i, base)
        
}

##SURVEY 

#Para declarar nuestra base como survey, primero, debemos quedarnos con las observaciones que no tienen ningún missing en la variable FACTOR_

for (i in datasets){
        
        base <- get(i)
        assign( paste0(i,"_s"),
                base[!is.na(base$FACTOR_),] )
        #las bases se llamarán enapres_año_s
        
}


datasets2 <- c("enapres_2018_s", "enapres_2019_s", "enapres_2020_s")

#Declaramos nuestras bases de datos como encuestas

for (i in datasets2){
        
        base <- get(i)
        base <- svydesign(ids = ~1, 
                          data = base, 
                          weights = as.numeric(base$FACTOR_))
        assign(i, base)
}


####################################
#INDICADOR INEI
###################################

#El porcentaje de personas que presentan inseguridad ciudadana en al menos uno de los 13 items

for (i in 2018:2020){
        
        #Obtenemos la proporción del indicador_inei usando el factor de expansión
        base <- as.data.frame( prop.table(svytable(~indicador_inei, get(paste0("enapres_",i,"_s")) )) ) 
        base$año <- i
        #solo nos quedamos con la proporción cuando el indicador_inei es 1
        #base <- base[2,]
        base$Freq <- base$Freq*100
        colnames(base) <- c("indicador_inei","porcentaje","año")
        
        assign( paste0("indicador_",i),
                base )
        #las bases guardadas son indicador_año
}


indicador_inei <- bind_rows(indicador_2018, indicador_2019, indicador_2020)

#Mejoramos los labels
indicador_inei_ <- mutate(indicador_inei , indicador_inei =
                                  case_when( indicador_inei == 1  ~ "Sí",
                                             TRUE ~ "No"
                                  ))


#Evolución (Gráfico)
grafico_inei <- ggplot(indicador_inei_, aes(fill= indicador_inei, y=porcentaje, x=año)) + 
                geom_bar(position="dodge", stat="identity") +
                geom_text(aes(label=round(porcentaje,2)), position=position_dodge(width=0.9), vjust=-0.25) +
                xlab("") + ylab("Porcentaje (%)") + 
                labs(fill="Percepción de inseguridad") +
                scale_fill_grey() 

ggsave(filename = "C:/Ministerio Público/ENAPRES/INDICE_PERCEPCION_INSEGURIDAD/grafico_inei.png", grafico_inei, height = 4 , width = 10 )

#Proporción de personas que responden que sí a cada una de las preguntas sobre percepción de inseguridad

var_inseguridad <- c("P611_1", "P611_2", "P611_3", "P611_4", "P611_5", "P611_6", "P611_7", "P611_8", "P611_9",
                     "P611_10", "P611_11", "P611_12", "P611_13")


proporciones_2018 <- c()
proporciones_2019 <- c()
proporciones_2020 <- c()


for (i in 1:13 ){
        
        proporciones_2018[i] <- prop.table(svytable(~ get(var_inseguridad[i]) , enapres_2018_s ))[2]
        proporciones_2019[i] <- prop.table(svytable(~ get(var_inseguridad[i]) , enapres_2019_s ))[2]
        proporciones_2020[i] <- prop.table(svytable(~ get(var_inseguridad[i]) , enapres_2020_s ))[2]

}


#######################################
#CONTRIBUCIÓN DE CADA PREGUNTA AL ÍNDICE EMP
######################################

proporciones <- c("proporciones_2018", "proporciones_2019", "proporciones_2020")

#creamos los data frames

for (i in proporciones){
        
        labels <- c("Robo vivienda",
                    "Robo vehículo automotor",
                    "Robo autopartes del vehículo automor",
                    "Robo motocicleta/motaxi",
                    "Robo bicleta",
                    "Robo dinero/cartera/celular",
                    "Amenazas/Intimidaciones",
                    "Maltrato hogar",
                    "Ofensas sexuales",
                    "Secuestro",
                    "Extorsión",
                    "Estafa",
                    "Robo de negocio"
        )
        
        proporciones <- get(i)
        
        data <- data.frame(labels,proporciones )
        colnames(data) <- c("Hecho_delictivo", "Porcentaje")
        data$Porcentaje <- data$Porcentaje*100
        #ordenamos en base a las proporciones(De mayor a menor)
        data <- data %>% arrange(desc(Porcentaje))

        assign( paste0("contribución_",i),
                data )
        #las bases guardadas son contribución_proporciones_año
}

contribución_proporciones_2018$año <- 2018
contribución_proporciones_2019$año <- 2019
contribución_proporciones_2020$año <- 2020


contribución_inei <- bind_rows(contribución_proporciones_2018, contribución_proporciones_2019, contribución_proporciones_2020)


# GRÁFICO

#reorder / ordenamos los labels en base a los porcentajes (de mayor a menor)
grafico_contri <- ggplot(data=contribución_inei, aes(x=reorder(Hecho_delictivo, Porcentaje) ,y=Porcentaje,fill=factor(año))) +
                geom_bar(position="dodge",stat="identity") + 
                geom_text(aes(label= round(Porcentaje,2)),hjust = -0.5, size = 3.2,
                          position = position_dodge(width = 1),
                          inherit.aes = TRUE) +
                xlab("Hecho delictivo") + ylab("Porcentaje (%)") + 
                labs(fill="") +
                scale_fill_grey() +
                coord_flip()  # Horizontal bar plot

ggsave(filename = "C:/Ministerio Público/ENAPRES/INDICE_PERCEPCION_INSEGURIDAD/grafico_contri .png", grafico_contri , height = 6 , width = 12)

####################################
#INDICE EMP
###################################

datasets2 <- c("enapres_2018_s", "enapres_2019_s", "enapres_2020_s")

#A nivel nacional urbano
for (i in datasets2){
        
        base <- get(i)
        
        indice <- as.data.frame(svytable(~suma, base ))
        
        indice$x <- (as.numeric(indice$suma)-1) * indice$Freq  
        
        i_per_capita<- sum(indice$x)/sum(indice$Freq)
        
        assign( paste0(i,"_indice"),
                i_per_capita )
        #los indices se llamarán enapres_año_s_indice

}

enapres_2018_s_indice
enapres_2019_s_indice
enapres_2020_s_indice

#gráfico

indice_nac<- data.frame(c(2018, 2019, 2020) , c(enapres_2018_s_indice, enapres_2019_s_indice, enapres_2020_s_indice))
colnames(indice_nac) <- c("año", "índice")

grafico_indice_nac <- ggplot(indice_nac, aes(y=índice, x=año)) + 
        geom_bar(position="dodge", stat="identity", width = 0.40) +
        geom_text(aes(label=round(índice,2)), position=position_dodge(width=0.9), vjust=-0.25) +
        scale_fill_grey() +
        xlab("") + ylab("Índice") 


ggsave(filename = "C:/Ministerio Público/ENAPRES/INDICE_PERCEPCION_INSEGURIDAD/grafico_indice_nac.png", grafico_indice_nac , height = 4 , width = 4)


#A nivel sexo

datasets2 <- c("enapres_2018_s", "enapres_2019_s", "enapres_2020_s")
sexo <- c("1", "2")
#1:hombre / 2:mujeres

for (i in datasets2){
        
        base <- get(i)
        
        for (j in sexo){
                
        data <- subset(base,P207== j)
        
        indice <- as.data.frame(svytable(~suma, data ))
        
        indice$x <- (as.numeric(indice$suma)-1) * indice$Freq  
        
        i_per_capita<- sum(indice$x)/sum(indice$Freq)
        
        assign( paste0(i,"_sexo",j),
                i_per_capita )
        }
        #los indices se llamarán enapres_año_s_sexo1/2
        
}

#A nivel departamental

datasets2 <- c("enapres_2018_s", "enapres_2019_s", "enapres_2020_s")
departamento <- c("AMAZONAS","ANCASH","APURIMAC","AREQUIPA","AYACUCHO","CAJAMARCA","CALLAO","CUSCO",
                  "HUANCAVELICA", "HUANUCO", "ICA","JUNIN", "LA LIBERTAD", "LAMBAYEQUE", "LIMA", "LORETO",
                  "MADRE DE DIOS", "MOQUEGUA", "PASCO", "PIURA", "PUNO","SAN MARTIN", "TACNA", "TUMBES", "UCAYALI"  )

for (i in datasets2){
        
        base <- get(i)
        
        for (j in departamento ){
                
                data <- subset(base,NOMBREDD== j)
                
                indice <- as.data.frame(svytable(~suma, data ))
                
                indice$x <- (as.numeric(indice$suma)-1) * indice$Freq  
                
                i_per_capita<- sum(indice$x)/sum(indice$Freq)
                
                assign( paste0(i,"_dep_",j),
                        i_per_capita )
        }
        #los indices se llamarán enapres_año_s_dep_DEPARTAMENTO
        
}

indice_dep_2018 <- c()
indice_dep_2019 <- c()
indice_dep_2020 <- c()

for (i in 1:25){
        
        indice_dep_2018[i]<- get(paste0("enapres_2018_s_dep_", departamento[i] ))
        indice_dep_2019[i]<- get(paste0("enapres_2019_s_dep_", departamento[i] ))
        indice_dep_2020[i]<- get(paste0("enapres_2020_s_dep_", departamento[i] ))
}

indice_dep_2018
indice_dep_2019
indice_dep_2020

#Realizamos el dataframe

indice_dep <- data.frame(departamento ,indice_dep_2018, indice_dep_2019, indice_dep_2020 )
colnames(indice_dep) <- c("DEPARTAMENTO", "A2018", "A2019", "A2020")

#variación porcentual 2018-2020

indice_dep_var <- indice_dep[,c("DEPARTAMENTO", "A2018", "A2020")]
indice_dep_var$var <- ( (indice_dep_var$A2020 - indice_dep_var$A2018)/indice_dep_var$A2018 )*100

indice_dep_var %>% arrange(desc(var))



#setwd("C:/Ministerio Público/ENAPRES/INDICE_PERCEPCION_INSEGURIDAD")

#write.csv(indice_dep,'departamentos_indice.csv')

