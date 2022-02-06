library(haven) #read dta
library(dygraphs)
library(xts) # To make the convertion data-frame / xts format

setwd("C:/Ministerio Público/DASHBOARD/Data")

#importamos datos
df_endes <- read_dta("basefinal_endes.dta")
df_enapres <- read_dta("basefinal_enapres.dta")


#arreglo de bases
df_endes <- as.data.frame(df_endes)
df_endes[,-1] <- df_endes[,-1]*100

df_enapres <- as.data.frame(df_enapres)
df_enapres[,-1] <- df_enapres[,-1]*100


#Los años los convertimos en formato tiempo
df_endes$ANIO <- paste0("01/01/",df_endes$ANIO)
df_endes$ANIO <- as.Date(as.character(df_endes$ANIO), format = "%m/%d/%Y")

df_enapres$ANIO <- paste0("01/01/",df_enapres$ANIO)
df_enapres$ANIO <- as.Date(as.character(df_enapres$ANIO), format = "%m/%d/%Y")


#series de tiempo endes
b <- xts(x = df_endes , order.by= df_endes$ANIO)

g <- dygraph(b, main = "Evolución del porcentaje de mujeres que sufrieron violencia por su compañero/esposo" ) %>%
        dyAxis("y", label = "Porcentaje") %>%
        dyAxis("x", label = "Año" ) %>%
        dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = FALSE, fillAlpha = 0.25, drawGrid = TRUE) %>%
        dySeries("ANIO", label = "AÑO") %>%
        dySeries("VE_PORC", label = "Violencia emocional") %>%
        dySeries("VMS_PORC",  label = "Violencia menos severa") %>%
        dySeries("VS_PORC",  label = "Violencia severa") %>%
        dySeries("VSS_PORC",  label = "Violencia sexual") %>%
        dyRangeSelector(height = 30) %>%
        dyLegend(width = 150, labelsSeparateLines = TRUE)
g

#series de tiempo enapres
b2 <- xts(x = df_enapres , order.by= df_enapres$ANIO)

g2 <- dygraph(b2, main = "Evolución del porcentaje de confianza en el Ministerio Público (MP)" ) %>%
        dyAxis("y", label = "Porcentaje") %>%
        dyAxis("x", label = "Año" ) %>%
        dyOptions(drawPoints = TRUE, pointSize = 2, axisLabelFontSize = 13, fillGraph = FALSE, fillAlpha = 0.25, drawGrid = TRUE) %>%
        dySeries("ANIO", label = "AÑO") %>%
        dySeries("CONFIANZA_MP_PORC", label = "Confianza en el MP") %>%
        dyRangeSelector(height = 30) %>%
        dyLegend(width = 150, labelsSeparateLines = TRUE)
g2

