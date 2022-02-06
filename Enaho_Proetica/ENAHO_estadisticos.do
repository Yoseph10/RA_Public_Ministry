clear all
cls

global main "C:\Ministerio Público\ENAHO"
global dta "$main/_dta"
global works "$main/Trabajadas"


**************************
*TRADUCCIÓN DE DTA
*************************

clear
cd "$dta/educacion"

*MODULO EDUCACION
forvalues i=2017(1)2020{
unicode analyze "enaho01a-`i'-300.dta"
unicode encoding set latin1 //puede ser con ISO-8859-10 también
unicode translate "enaho01a-`i'-300.dta"
}

clear
cd "$dta/empleo_ingresos"

*MODULO EMPLEO, INGRESOS
forvalues i=2017(1)2020{
unicode analyze "enaho01a-`i'-500.dta"
unicode encoding set latin1 //puede ser con ISO-8859-10 también
unicode translate "enaho01a-`i'-500.dta"
}

clear
cd "$dta/gobernabilidad"

*MODULO GOBERNABILIDAD, DEMOCRACIA Y TRANSPARENCIA
forvalues i=2017(1)2020{
unicode analyze "enaho01b-`i'-1.dta"
unicode encoding set latin1 //puede ser con ISO-8859-10 también
unicode translate "enaho01b-`i'-1.dta"
}

clear
cd "$dta/miembros"

*MODULO MIEMBROS DEL HOGAR
forvalues i=2017(1)2020{
unicode analyze "enaho01-`i'-200.dta"
unicode encoding set latin1 //puede ser con ISO-8859-10 también
unicode translate "enaho01-`i'-200.dta"
}


************************************
*JUNTAMOS BASES DE GOBERNABILIDAD
************************************
*En el módulo de gobernabilidad, hay variables como sexo, estado civil, grado de estudios, ubigeo, demonio geográfico, estrato (de aquí se puede sacar lo de urbano, rural)
clear
cd "$dta/gobernabilidad"

*creacion de variables
forvalues i=2017(1)2020{
 
use "enaho01b-`i'-1", clear
gen ANIO = `i'
save "$works/gobernabilidad_`i'", replace

}

cd "$works"
*juntamos bases 
forvalues i=2017(1)2019{
clear
use "gobernabilidad_`i'"
append using "gobernabilidad_`=`i'+1'"
save "gobernabilidad_`=`i'+1'", replace

}

save final_gobernabilidad, replace




********************************************************
*USAMOS ENAHO 2019
********************************************************

cd "$dta/gobernabilidad"

use enaho01b-2019-1, clear

********************************************************************************
*Declaramos diseño muestral

*  svyset [psu] [weight] [, design_options options]


*Está bien declarado el diseño muestral?
svyset conglome [pw=famiegob07], strata(estrato)
svydes

svy: tab p2c_06
*pocas observaciones
codebook p2c_06 p2c_03 p2c_07 p2c_10


*factor de expansión, diferencias?
tab p2c_06 [iw=famiegob07]

tab p2c_06 [aw=famiegob07]

svy: prop p2c_06












*Modificamos y creamos variables
global retribuciones "p2c_06 p2c_03 p2c_07 p2c_10"

foreach i in $retribuciones{

recode `i' (1 3 = 1) (2 4 = 0), gen (`i'_)
*1: le solicitarion y dio, no le solicitaron pero dio

*0: le solicitaron y no dio, no le solicitaron
}

svy: tab p2c_06_

tab p2c_06_ [iw=famiegob07]

tab p2c_06_ [aw=famiegob07]

svy: reg p2c_06_ p207_01 p208_01

reg p2c_06_ p207_01 p208_01

svy: prop p2c_06_


********************************************************
*USAMOS POOL 2017-2020
********************************************************


**
cd "$works"
use final_gobernabilidad, clear


*Declaramos diseño muestral
svyset conglome [pw=facgob_p], strata(estrato)
svydes

svy: tab p2c_06 

tab p2c_06 [aw=facgob_p]



codebook p2c_06
svy: codebook p2c_06 



*Modificamos y creamos variables
global retribuciones "p2c_06 p2c_03 p2c_07 p2c_10"

foreach i in $retribuciones{

recode `i' (1 3 = 1) (2 4 = 0), gen (`i'_)
*1: le solicitarion y dio, no le solicitaron pero dio

*0: le solicitaron y no dio, no le solicitaron
}

codebook p2c_06_ p2c_03_ p2c_07_ p2c_10_


*Generamos un variable que indique si es que la persona dio retribuciones a alguna de esas entidades 

*1= dio
*0 = no dio

gen retribu = 1 if p2c_06_ == 1 | p2c_03_ == 1 |  p2c_10_==1
replace retribu = 0 if p2c_06_ == 0 & p2c_03_ == 0  & p2c_10_==0
*le quité la defensoría del pueblo

tab retribu [iw=facgob_p]

tab retribu [aw=facgob_p]






*Descriptivos de variables importantes

*¿Le solicitaron, se sintió obligado(a) a dar, odio voluntariamente retribuciones en …?
codebook p2c_06 p2c_03 p2c_07 p2c_10





********************************************************************************
*Denuncias al sistema de administración de justicia debido a actos de corrupción 
********************************************************************************

*HACER EL POOL DE DATOS / VER LAS OBSERVACIONES
*VER OTROS MÓDULOS CON CARACTERÍSTICAS INDIVIDUALES
*HACER EL POOL CON LAS PERSONAS CON SUS CARACTERÍSTICAS

forvalues i=2017(1)2020{
    
use "enaho01b-`i'-1", clear

display "`i'"
codebook p2c_06 p2c_03 p2c_07 p2c_10

}








forvalues i=2017(1)2020{
    
use "enaho01b-`i'-1", clear
gen ANIO = `i'

*ENAHO 2019
*porcentaje de personas que denunciaron actos de corrupción por parte de la PNP
gen n1 = 1 if p2c_06 =1 |  D104 ==2 | 
egen n1_ = sum(n1) 

gen VE = 1 if D104 ==1
egen VE_SUM = sum(VE)
gen VE_PORC = VE_SUM/n1_

*p2c_06

*p2d_06

*porcentaje de personas que denunciaron actos de corrupción por parte el Poder Judicial

*p2c_03

*p2d_03

*porcentaje de personas que denunciaron actos de corrupción por parte de la Defensoría del Pueblo

*p2c_07

*p2d_07

*porcentaje de personas que denunciaron actos de corrupción por parte del Ministerio Público/Fiscalía de la Nación

*p2c_10

*p2d_10

save "$series/SERIES_`i'", replace
}

