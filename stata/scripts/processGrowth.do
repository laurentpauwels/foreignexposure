/******************************************************************************/

/* VARIABLE ASSIGNMENTS AND TRANSFORMATION */

/*
VALUE ADDED AT PPP
GROWTH:
- Real PPP Value Added
- Growth, 
- Log Growth and 
- Average
*/
gen va_ppp = va_natcur*ppp_usdpnatcu_ir
replace va_ppp = . if va_ppp < 0

gen rva = (va_ppp /va_pi)*100
by cross: gen grva = rva / l.rva
gen lgrva1 = log(grva)
by cross: egen lgrva = mean(lgrva1)
label var lgrva "Growth real PPP VA "

/*
   Measures of Foreign Exposure
*/

// Average of HOT, X/VA, X/GO & Phi 
by cross: egen hot =  mean(hot_ir)
by cross: egen xgo = mean(x_ir / go)
by cross: egen xva =  mean(x_ir / va_ppp)
by cross: egen phi =  mean(phi_ir/10000)
by cross: egen tva = mean(tva_ir / va_ppp)

label var hot "HOT"
label var xgo "Exports/GO"
label var xva "Exports/VA(PPP)"
label var phi "phiness of trade"
label var tva "TiVA (VA)"

/*
Initial & Log Initial value of Real PPP VA 
*/

by cross: gen rvafirst = rva if _n == 1
gen lrva = log(rvafirst)
label var lrva "Log Initial Real PPP VA"


/******************************************************************************/
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

/******************************************************************************/
/* 
            CROSS-SECTION 1 PERIOD 
    Without loss of generality, Keep year 2000: 
    Initial value of VA @ 2000 & all other variables are averages over Time (year).
*/
by cross: keep if year == 2000
keep lgrva lrva hot xgo xva phi tva  /*
*/   agr_r mfg_r ser_r pub_r ctry_i sect_r code_r cross sectorcode_r

/***********************************END OF DO FILE******************************/
/******************************************************************************/