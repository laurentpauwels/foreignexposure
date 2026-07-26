/* VARIABLE ASSIGNMENTS AND TRANSFORMATION */

/*
   VALUE ADDED: Log Real PPP Value Added
*/
gen va_ppp = va_natcur*ppp_usdpnatcu_ir
gen rva_ppp = ((va_natcur/va_pi)*100)*ppp_usdpnatcu_ir
replace rva_ppp = . if rva_ppp < 0
label var rva_ppp "Real Value Added PPP"

gen lrva_ppp = log(rva_ppp)
label var lrva_ppp "Log real PPP VA "

//HP-detrended Log Real PPP Value Added
//quiet tsfilter hp dlrva_ppp = lrva_ppp, smooth(100)
//label var dlrva_ppp "Log Real PPP VA HP filtered"

/*
   Measures of Foreign Exposure
*/

gen hot = (hot_ir)
label var hot "HOT"

gen xgo = x_ir / go
label var xgo "Exports/GO"

gen xva = x_ir / va_ppp
label var xva "Exports/VA(PPP)"

gen tva = tva_ir / va_ppp
label var tva "TiVA (VA)"

gen phi = phi_ir/10000
label var phi "phiness of trade"


/* SECTOR DUMMIES: Agriculture, Mining, Manufacturing and Services */

gen agr_r = (sectorcode_r=="r1"|sectorcode_r=="r2"|sectorcode_r=="r3")
label var agr_r "Agriculture"

gen mfg_r = (sectorcode_r=="r4"|sectorcode_r=="r5"|sectorcode_r=="r6"|sectorcode_r=="r7"|sectorcode_r=="r8"| /*
*/ sectorcode_r=="r9"|sectorcode_r=="r10"|sectorcode_r=="r11"|sectorcode_r=="r12"|/*
*/ sectorcode_r=="r13"|sectorcode_r=="r14"|sectorcode_r=="r15"|sectorcode_r=="r16"|/*
*/ sectorcode_r=="r17"|sectorcode_r=="r18"|sectorcode_r=="r19"|sectorcode_r=="r20"|/*
*/ sectorcode_r=="r21"|sectorcode_r=="r22"|sectorcode_r=="r23"|sectorcode_r=="r27")
label var mfg_r "Manufacturing" //including Mining and Construction

gen ser_r = (sectorcode_r=="r24"|sectorcode_r=="r25"|sectorcode_r=="r26"|sectorcode_r=="r28"|sectorcode_r=="r29"|sectorcode_r=="r30"|sectorcode_r=="r31"|/*
*/ sectorcode_r=="r32"|sectorcode_r=="r33"|sectorcode_r=="r34"|sectorcode_r=="r35"|sectorcode_r=="r36"|/*
*/ sectorcode_r=="r37"|sectorcode_r=="r38"|sectorcode_r=="r39"|sectorcode_r=="r40"|sectorcode_r=="r41"|/*
*/ sectorcode_r=="r42"|sectorcode_r=="r43"|sectorcode_r=="r44"|sectorcode_r=="r45"|sectorcode_r=="r46"|/*
*/ sectorcode_r=="r47"|sectorcode_r=="r48"|sectorcode_r=="r49"|sectorcode_r=="r50") 
label var ser_r "Services" //including Utilities 

gen pub_r = (sectorcode_r=="r51"|sectorcode_r=="r52"|sectorcode_r=="r53"|sectorcode_r=="r54"|/*
*/ sectorcode_r=="r55"|sectorcode_r=="r56")
label var pub_r "Public Services"

/* TRADED vs NONTRADED SECTORS  */
//Traded vs NonTraded sectors (Country distribution)
bysort ctry_year: egen mean_hot_traded = mean(hot) if (agr_r==1 | mfg_r==1)
bysort ctry_year: egen mean_hot1_traded = mean(xgo) if (agr_r==1 | mfg_r==1)
bysort ctry_year: egen mean_x_traded = mean(xva) if (agr_r==1 | mfg_r==1)
bysort ctry_year: egen mean_phi_traded = mean(phi) if (agr_r==1 | mfg_r==1)
bysort ctry_year: egen mean_tva_traded = mean(tva) if (agr_r==1 | mfg_r==1)


bysort ctry_year: egen mean_hot_nontraded = mean(hot) if (ser_r==1 | pub_r==1)
bysort ctry_year: egen mean_hot1_nontraded = mean(xgo) if (ser_r==1 | pub_r==1)
bysort ctry_year: egen mean_x_nontraded = mean(xva) if (ser_r==1 | pub_r==1)
bysort ctry_year: egen mean_phi_nontraded = mean(phi) if (ser_r==1 | pub_r==1)
bysort ctry_year: egen mean_tva_nontraded = mean(tva) if (ser_r==1 | pub_r==1)

/* OPENED vs CLOSED ECONOMIES (Sector distribution) */

// Calculate the mean of hot for each country
bysort country_i: egen mean_hot_country = mean(hot)

// Calculate the overall median of hot 
egen med_hot_overall = median(mean_hot_country) if year==2014

// Create a variable to classify countries as opened or closed
gen country_status = .
replace country_status = 1 if  mean_hot_country >= med_hot_overall & year==2014 // 1 for opened
replace country_status = 0 if mean_hot_country < med_hot_overall & year==2014 // 0 for closed

// Create lists of countries based on the classification
levelsof country_i if country_status == 1, local(opened) 
levelsof country_i if country_status == 0, local(closed)

bysort sect_year: egen mean_hot_open = mean(hot) if country_status == 1
bysort sect_year: egen mean_hot1_open = mean(xgo) if country_status == 1
bysort sect_year: egen mean_x_open = mean(xva) if country_status == 1
bysort sect_year: egen mean_phi_open = mean(phi) if country_status == 1 
bysort sect_year: egen mean_tva_open = mean(tva) if country_status == 1

bysort sect_year: egen mean_hot_closed = mean(hot) if country_status == 0
bysort sect_year: egen mean_hot1_closed = mean(xgo) if country_status == 0
bysort sect_year: egen mean_x_closed = mean(xva) if country_status == 0
bysort sect_year: egen mean_phi_closed = mean(phi) if country_status == 0 
bysort sect_year: egen mean_tva_closed = mean(tva) if country_status == 0


// Create a dataset for opened countries
preserve
keep if country_status == 1
keep country_i countryname_i
duplicates drop
export delimited using "open_countries.csv", replace
restore

// Create a dataset for closed countries
preserve
keep if country_status == 0
keep country_i countryname_i
duplicates drop
export delimited using "closed_countries.csv", replace
restore

/* FIGURE: Dispersion of HOT, phi, X, and TiVA across sect. for each ctry (2014)  */
bysort ctry_year: egen med_hot_byctry = median(hot)

/* FIGURE: Dispersion of HOT, phi, X, and TiVA across ctry for each sect (2014) */
bysort sect_year: egen med_hot_bysect = median(hot)
