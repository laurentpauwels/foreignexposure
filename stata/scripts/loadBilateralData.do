/******************************************************************************/
/* LOAD DATA */

clear 
set more off

//////IMPORT INITIAL BILATERAL DATA FILE WITH HOT, VHOT, PHI, X, ABSDIFFs, BHOTIVs//////
cd "`dir'../matlab/output/"
 
import delimited "bilateral.txt"

label var hot_ijrs "HOT"
label var tva_ijrs "T(VA)"
label var xva_ijrs "X/VA"
label var xgo_ijrs "X/GO"
label var phi_ijrs "phiness of trade"
label var qdva_ijrs "Quasi-Corr VA PPP growth"

label var country_i "Country i"
label var country_j "Country j"
label var sector_r "Sector r"
label var sector_s "Sector s"
label var sectcode_r "WIOT Sector r Code"
label var sectcode_s "WIOT Sector s Code"
label var year "Time"


/* SETUP PANEL */

egen cross = group(country_i country_j sectcode_r sectcode_s)
xtset cross year, yearly

/* REMOVE ROW AND PUBLIC SECTORS */

//Remove Rest of the World
drop if country_i == "ROW"
drop if country_j == "ROW"



//ABSDIFF & QCORR  start in 2001 (due to differencing)
drop if year == 2000
