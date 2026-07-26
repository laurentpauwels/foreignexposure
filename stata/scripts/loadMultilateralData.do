/******************************************************************************/
/* LOAD DATA */

cd "`dir'../matlab/output/"
 
import delimited "multilateral.txt"

label var x_ir "Total Export"
label var phi_ir "phiness"
label var tva_ir "Domestic Value Added"
label var hot_ir "HOT"

label var go "Gross Output"
label var va_pi "Industry Price Index"
label var va "Value Added (current USD)"
label var va_natcur "Value Added (National Cur.)"
label var ppp_usdpnatcu_ir "PPP USD per Nat. Cur."

label var country_i "Country"
label var sector_r "Sector"
label var sectorcode_r "WIOT Sector Code"
label var year "Time"

//save "../../stata/data/multilateral_180924.dta", replace

/* SETUP PANEL */

egen cross = group(country_i sectorcode_r)
xtset cross year, yearly

encode country_i, g(ctry_i)
encode sector_r, g(sect_r)
encode sectorcode_r, g(code_r)
egen sect_year = group(code_r year)
egen ctry_year = group(ctry_i year)

/* REMOVE ROW AND PUBLIC SECTORS */

gen restofworld = (country_i == "ROW")
drop if restofworld ==1

/******************************************************************************/