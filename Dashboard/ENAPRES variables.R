library(haven)
library(psych)


setwd("C:/Ministerio Público/ENAPRES")

#Importamos datos
for (i in 2010:2020){
 df <- read_sav( paste0("CAP600_", i , ".sav") )
assign(paste("df", i, sep = ""), df)
}

write.table(df2010, file = "df2010.csv", sep=",", row.names=FALSE)
write.table(df2011, file = "df2011.csv", sep=",", row.names=FALSE)
write.table(df2012, file = "df2012.csv", sep=",", row.names=FALSE)
write.table(df2013, file = "df2013.csv", sep=",", row.names=FALSE)
write.table(df2014, file = "df2014.csv", sep=",", row.names=FALSE)
write.table(df2015, file = "df2015.csv", sep=",", row.names=FALSE)
write.table(df2016, file = "df2016.csv", sep=",", row.names=FALSE)
write.table(df2017, file = "df2017.csv", sep=",", row.names=FALSE)
write.table(df2018, file = "df2018.csv", sep=",", row.names=FALSE)
write.table(df2019, file = "df2019.csv", sep=",", row.names=FALSE)
write.table(df2020, file = "df2020.csv", sep=",", row.names=FALSE)

            

