clear all
cls

global main "C:\Ministerio Público\ENAHO"
global dta "$main/_dta"

cd "$dta/gobernabilidad"


*Desde el 2004, las bases empleadas cuentan con información anual

***************************************
*ENAHO 2002 (solo para el IV trimestre)
***************************************
use enaho01b-2002-2.dta, clear

/*¿Le solicitaron, se 
sintió obligado o dio 
voluntariamente 
retribuciones como: 
regalos, propinas, 
sobornos, coimas, 
etc.?  (Persona de 18 años y más de edad) */

*1: sí, le solicitaron/ 2:sí, se sintió obligado/ 3: sí, dio voluntariamente/
*4: Le solicitaron y no dio/ 5: No

codebook P9
*gran cantidad de missings

***************************************
*ENAHO 2003 (mayo-diciembre)
***************************************

use enaho01b-2003-1.dta, clear

/*En los últimos 12 meses, ¿A Ud. o algún miembro de su
hogar, le solicitaron, se sintió obligado o dio
voluntariamente regalos, propinas, sobornos, coimas a
un funcionario del estado?  (Persona de 18 años y más de edad) */

*1: sí/2: no /3: no ha hecho uso de servicios del estado

codebook P5
*los missing no son un problema

tab P5 [aw=FACTOR07]  
*FACTOR: Factor de expansión de hogar proyección CPV 1993
*FACTOR07: Factor de expansión de hogar proyección CPV 2007


use enaho01b-2003-2.dta, clear

/*¿Le solicitaron, se
sintió obligado o dio
voluntariamente
retribuciones como:
regalos, propinas,
sobornos, coimas,
etc.?  (Persona de 18 años y más de edad)*/

*1: sí, le solicitaron/ 2:sí, se sintió obligado/ 3: sí, dio voluntariamente/
*4: Le solicitaron y no dio/ 5: No

codebook P11
*gran cantidad de missings


***************************************
*ENAHO 2004-2006 (anual)
***************************************

forvalues i=2004(1)2006{

use enaho01b-`i'-1.dta, clear

display `i'

/*En los últimos 12 meses, ¿A Ud. o algún miembro de su
hogar, le solicitaron, se sintió obligado o dio
voluntariamente regalos, propinas, sobornos, coimas a
un funcionario del estado?  (Persona de 18 años y más de edad) */

*1: sí/2: no /3: no ha hecho uso de servicios del estado

codebook p5
*los missing no son un problema

tab p5 [aw=factor07]  

}

forvalues i=2004(1)2006{
	
use enaho01b-`i'-2.dta, clear

display `i'

/*¿Le solicitaron, se
sintió obligado o dio
voluntariamente
retribuciones como:
regalos, propinas,
sobornos, coimas,
etc.?  (Persona de 18 años y más de edad)*/

*1: sí, le solicitaron/ 2:sí, se sintió obligado/ 3: sí, dio voluntariamente/
*4: Le solicitaron y no dio/ 5: No

codebook p11
*gran cantidad de missings
}


***************************************
*ENAHO 2007-2009 (anual)
***************************************

forvalues i=2007(1)2009{

use enaho01b-`i'-1.dta, clear

display `i'

/*En los últimos 12 meses, ¿A Ud. o algún miembro de su
hogar, le solicitaron, se sintió obligado o dio
voluntariamente regalos, propinas, sobornos, coimas a
un funcionario del estado?  (Persona de 18 años y más de edad) */

*1: sí/2: no /3: no ha hecho uso de servicios del estado

codebook p23
*los missing no son un problema

tab p23 [aw=factor07] 

}

 
***************************************
*ENAHO 2010-2011 (anual)
***************************************

forvalues i=2010(1)2011{

use enaho01b-`i'-1.dta, clear

display `i'

/*En los últimos 12 meses, ¿A Ud. o algún miembro de su
hogar, le solicitaron, se sintió obligado o dio
voluntariamente regalos, propinas, sobornos, coimas a
un funcionario del estado?  (Persona de 18 años y más de edad) */

*1: sí/2: no /3: no ha hecho uso de servicios del estado

codebook p23
*los missing no son un problema

tab p23 [aw=facgob07] 

}

***************************************
*ENAHO 2012-2016 (anual)
***************************************


forvalues i=2012(1)2016{
	
use enaho01b-`i'-2.dta, clear

display `i'

/*En los últimos 12 meses, ¿A Ud. o algún miembro de su
hogar, le solicitaron, se sintió obligado o dio
voluntariamente regalos, propinas, sobornos, coimas a
un funcionario del estado?  (Solo para el jefe de hogar o cónyuge) */

*1: sí/2: no /3: no ha hecho uso de servicios del estado
*9: missing para el 2015-2016

recode p23 (9=.)
codebook p23
*los missing no son un problema

tab p23 [aw=factor07]

}


forvalues i=2012(1)2013{
	
use enaho01b-`i'-3.dta, clear

display `i'

/*¿LE SOLICITARON O DIO 
VOLUNTARIAMENTE 
RETRIBUCIONES COMO: 
REGALOS, PROPINAS, 
SOBORNOS, COIMAS, 
ETC.?  (Solo para el jefe de hogar o cónyuge)

*1: sí, le solicitaron y dio/ 2:sí, le solicitaron y no dio/ 3: no le solicitaron, pero dio algo/ 4: no le solicitaron, ni entregó nada */

codebook p23c
*los missing no parecen ser un gran problema

tab p23c [aw=factor07] 

}


***************************************
*ENAHO 2017-2020 (anual)
***************************************

forvalues i=2017(1)2020{
	
use enaho01b-`i'-1.dta, clear

display `i'

/*¿Le solicitaron, se sintió
obligado(a) a dar, o dio
voluntariamente 
retribuciones como: 
regalos, propinas, 
sobornos, coimas, etc  (Persona de 18 años y más de edad) */

*1: sí, le solicitaron dar y dio/ 2: sí, le solicitaron dar y no dio/ 3: no, pero dio voluntariamente / 4: No le solicitaron

codebook p2c_*
*los missing son un problema

}


forvalues i=2017(1)2020{
	
use enaho01b-`i'-2.dta, clear

display `i'

/*En los últimos 12 meses, ¿A Ud. o algún miembro de su
hogar, le solicitaron, se sintió obligado o dio
voluntariamente regalos, propinas, sobornos, coimas a
un funcionario del estado?  (Solo para el jefe de hogar o cónyuge) */

*1: sí/2: no /3: no ha hecho uso de servicios del estado
*9: missing 
recode p23 (9=.)

codebook p23
*los missing no son un problema
*Solo para el 2020 los missing sí son un problema


tab p23 [aw=factor07]

}


forvalues i=2017(1)2020{
	
use enaho01b-`i'-1.dta, clear

display `i'

/*¿En los últimos 12 meses, usted ha realizado trámite en .. */

*1: sí, 2: no

codebook p2b_*
*los missing son un problema

}


