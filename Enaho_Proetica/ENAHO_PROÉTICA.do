clear all
cls

global main "C:\Ministerio Público\ENAHO"
global dta "$main/_dta"

cd "$dta/gobernabilidad"

********************************************************************************
*PRIMERA PREGUNTA
********************************************************************************

*************
*ENAHO 2010-2011
*************

forvalues i=2010(1)2011{

use enaho01b-`i'-1.dta, clear

display `i'
*En su opinión, actualmente, ¿cuáles son los principales problemas del país?

*Orden:
/*Corrupción
Credibilidad y transparencia
Desempleo
Seguridad Ciudadana
Violencia hogares
Atención salud
Cobertura seguridad social
Educación estatal
Derechos humanos
Bajo sueldo/inflación
Pobreza
Falta vivienda
Apoyo agricultura
Mala democracia*/


	forvalues i=1(1)9{
		
	tab p2_1_0`i' [aw=facgob07]

	}

	forvalues i=10(1)14{
		
	tab p2_1_`i' [aw=facgob07]

	}

}




*************
*ENAHO 2012-2014
*************

forvalues i=2012(1)2014{

use enaho01b-`i'-1.dta, clear

display `i'
*En su opinión, actualmente, ¿cuáles son los principales problemas del país?

*Orden:
/*Corrupción
Credibilidad y transparencia
Desempleo
Seguridad Ciudadana
Violencia hogares
Atención salud
Cobertura seguridad social
Educación estatal
Derechos humanos
Bajo sueldo/inflación
Pobreza
Falta vivienda
Apoyo agricultura
Mala democracia
Delincuencia*/


	forvalues i=1(1)9{
		
	tab p2_1_0`i' [aw=facgob07]

	}

	forvalues i=10(1)15{
		
	tab p2_1_`i' [aw=facgob07]

	}

}



*************
*ENAHO 2015-2020
*************

forvalues i=2015(1)2020{

use enaho01b-`i'-1.dta, clear

display `i'
*En su opinión, actualmente, ¿cuáles son los principales problemas del país?

*Orden:
/*Corrupción
Credibilidad y transparencia
Desempleo
Seguridad Ciudadana
Violencia hogares
Atención salud
Cobertura seguridad social
Educación estatal
Derechos humanos
Bajo sueldo/inflación
Pobreza
Falta vivienda
Apoyo agricultura
Mala democracia
Delincuencia*/


	forvalues i=1(1)9{
		
	tab p2_1_0`i' [aw=famiegob07]

	}

	forvalues i=10(1)15{
		
	tab p2_1_`i' [aw=famiegob07]

	}

}












