clear all
cls

global main "C:\Ministerio Público\YOUNG_LIVES\Paper"
global data "$main/_finaldata"
global works "$main/_works"

use "$data/final_data.dta", clear

*testear la exogeneidad estricta  -- hausman test/ variables instrumentales
*testar la multicolinealidad  -- VIF
*testear la homocedasticidad  -- white cuando hay heterocedasticidad


******************************************
*TRATAMIENTO DE VARIABLES
******************************************
recode sex_r1 (1=1) (2=0), gen(sex_r1_)

label define lab_sex 1 "male" 0 "female"
label values sex_r1_ lab_sex



******************************************
*CARACTERÍSTICAS DE LA MUESTRA
******************************************

global varlist "sex_r1_ spanish urban_r1 wi_r1"

tabstat $varlist, stats(mean min max sd n) format(%6.3fc) save
mat T = r(StatTotal)' // the prime is for transposing the matrix

*putexcel set "comparando_capacidades_agregado.xlsx", replace 
*putexcel A1 = matrix(T), names


******************************************
*CARACTERÍSTICAS DE LAS VARIABLES DE INTERÉS
******************************************

global varlist2 "peer_violence_r3 dummy_peer_viol_r3 drugc_r4 criminalb_r4 dummy_crim_r4 usex_r4"

tabstat $varlist2, stats(mean min max sd n) format(%6.3fc) save
mat T = r(StatTotal)' 



******************************************
*REGRESIONES
******************************************

*faltan utilizar los pesos / variables factor

*-------------------------------
*DEPENDIENTE: Conducta criminal
*-------------------------------

reg criminalb_r4 peer_violence_r3 i.sex_r1_ wi_r1 i.spanish i.urban_r1 i.gang_f_r4 i.meduc ln_pc_exp_r2

*testeando la multicolinealidad (menor a 10)
vif

*testeando homocedasticidad (p < 0.05 - se rechaza varianzas constantes)
estat hettest

*MCG/ white 

reg criminalb_r4 peer_violence_r3 i.sex_r1_ wi_r1 i.spanish i.urban_r1 i.gang_f_r4 i.meduc ln_pc_exp_r2, robust

outreg2 using "$works\modelos.doc", replace
 

*-------------------------------
*DEPENDIENTE: Consumo de drogas
*-------------------------------

logit drugc_r4 peer_violence_r3 i.sex_r1_ wi_r1 i.spanish i.urban_r1 i.gang_f_r4 i.meduc ln_pc_exp_r2
outreg2 using "$works\modelos.doc"

fitstat

*efectos marginales
margins, dydx(*)

outreg2 using "$works\modelos2.doc", addstat(Pseudo R2, e(r2_p), P-value, e(p), Chi-square test, e(chi2)) replace 

*correcta clasificación/matriz de confusión
estat classification
*Sensitivity: predicción correcta de los consumen drogas
*Specifity: predicción correcta de los que no consumen drogas


*-------------------------------
*DEPENDIENTE: Relaciones sexuales de riesgo
*-------------------------------

logit usex_r4 peer_violence_r3 i.sex_r1_ wi_r1 i.spanish i.urban_r1 i.gang_f_r4 i.meduc ln_pc_exp_r2

outreg2 using "$works\modelos.doc"

*fitstat

*efectos marginales
margins, dydx(*)

outreg2 using "$works\modelos2.doc", addstat(Pseudo R2, e(r2_p), P-value, e(p), Chi-square test, e(chi2))

*correcta clasificación/matriz de confusión
estat classification
*Sensitivity: predicción correcta de los consumen drogas
*Specifity: predicción correcta de los que no consumen drogas






