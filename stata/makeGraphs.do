clear
graph drop _all
set more off
// Set a global directory

//global dir "/path/to/your/directory"

// Use the global directory
cd "$dir"


quietly{
    do "`dir'./scripts/loadMultilateralData.do"
    cd ../../stata
    do "`dir'./scripts/processGraphs.do"
}
describe
cd "$dir"

//////////CHANGE DIRECTORY
cd "`dir'./output/figures


/* FIGURE 5: TRADED vs NONTRADED SECTORS (Country distribution) */

// Overlaid kdensity for mean_hot_traded and mean_hot_nontraded
twoway (kdensity mean_hot_traded if year==2014 & sector_r == "Chemicals",lpattern(solid)) ///
       (kdensity mean_hot_nontraded if year==2014 & sector_r == "IT",lpattern(dash_dot)), ///
       legend(label(1 "HOT Traded") label(2 "HOT Non-traded") size(small)) ///
       xlabel(0(0.2)1, labsize(small)) xtitle("", size(small)) ///
       ylabel(, labsize(small)) ytitle("Density", size(small)) ///
       graphregion(m(small) fcolor(white)) note("") name(kdensity_hot, replace)
graph export kdensity_hot_tradedNonTraded.pdf, replace

// Overlaid kdensity for mean_hot1_traded and mean_hot1_nontraded
twoway (kdensity mean_hot1_traded if year==2014 & sector_r == "Chemicals",lpattern(solid)) ///
       (kdensity mean_hot1_nontraded if year==2014 & sector_r == "IT",lpattern(dash_dot)), ///
       legend(label(1 "HOT1 Traded") label(2 "HOT1 Non-traded") size(small)) ///
       xlabel(0(0.2)1, labsize(small)) xtitle("", size(small)) ///
       ylabel(, labsize(small)) ytitle("Density", size(small)) ///
       graphregion(m(small) fcolor(white)) note("") name(kdensity_hot1, replace)
graph export kdensity_hot1_tradedNonTraded.pdf, replace

// Overlaid kdensity for mean_x_traded and mean_x_nontraded
twoway (kdensity mean_x_traded if year==2014 & sector_r == "Chemicals" & mean_x_traded<=4,lpattern(solid)) ///
       (kdensity mean_x_nontraded if year==2014 & sector_r == "IT",lpattern(dash_dot)), ///
       legend(label(1 "X Traded") label(2 "X Non-traded") size(small)) ///
       xlabel(0(1)4, labsize(small)) xtitle("", size(small)) ///
       ylabel(, labsize(small)) ytitle("Density", size(small)) ///
       graphregion(m(small) fcolor(white)) note("") name(kdensity_x, replace)
graph export kdensity_x_tradedNonTraded.pdf, replace

// Overlaid kdensity for mean_phi_traded and mean_phi_nontraded 
twoway (kdensity mean_phi_traded if year==2014 & sector_r == "Chemicals" & mean_phi_traded<=500, yaxis(1) lpattern(solid)) ///
       (kdensity mean_phi_nontraded if year==2014 & sector_r == "IT" & mean_phi_nontraded<=500, yaxis(2) lpattern(dash_dot)), ///
       legend(label(1 "{&phi} Traded") label(2 "{&phi} Non-traded") size(small)) ///
       xlabel(0(50)500, labsize(small)) xtitle("", size(small)) ///
       ylabel(, labsize(small)) ///
       ytitle("Density (Traded)", axis(1) size(small)) ///
       ytitle("Density (Non-traded)", axis(2) size(small)) ///
       ylabel(, axis(2) labsize(small)) ///
	   graphregion(m(small) fcolor(white)) note("") name(kdensity_phi, replace)
graph export kdensity_phi_tradedNonTraded.pdf, replace

// Overlaid kdensity for mean_tva_traded and mean_tva_nontraded
twoway (kdensity mean_tva_traded if year==2014 & sector_r == "Chemicals" & mean_tva_traded<=1,lpattern(solid)) ///
       (kdensity mean_tva_nontraded if year==2014 & sector_r == "IT" & mean_tva_nontraded<=1,lpattern(dash_dot)), ///
       legend(label(1 "T(VA) Traded") label(2 "T(VA) Non-traded") size(small)) ///
       xlabel(0(0.2)1, labsize(small)) xtitle("", size(small)) ///
       ylabel(, labsize(small)) ytitle("Density", size(small)) ///
       graphregion(m(small) fcolor(white)) note("") name(kdensity_tva, replace)
graph export kdensity_tva_tradedNonTraded.pdf, replace

/* FIGURE 6: OPENED vs CLOSED ECONOMIES (Sector distribution) */

// Overlaid kdensity for mean_hot_opened and mean_hot_closed
twoway (kdensity mean_hot_open if year==2014 & country_i == "BEL",lpattern(solid)) ///
       (kdensity mean_hot_closed if year==2014 & country_i == "BRA",lpattern(dash_dot)), ///
       legend(label(1 "HOT Open") label(2 "HOT Closed") size(small)) ///
       xlabel(0(0.2)1, labsize(small)) xtitle("", size(small)) ///
       ylabel(, labsize(small)) ytitle("Density", size(small)) ///
       graphregion(m(small) fcolor(white)) note("") name(kdensity_hot, replace)
graph export kdensity_hot_openClosed.pdf, replace

// Overlaid kdensity for mean_hot1_opened and mean_hot1_closed
twoway (kdensity mean_hot1_open if year==2014 & country_i == "BEL",lpattern(solid)) ///
       (kdensity mean_hot1_closed if year==2014 & country_i == "BRA",lpattern(dash_dot)), ///
       legend(label(1 "HOT1 Open") label(2 "HOT1 Closed") size(small)) ///
       xlabel(0(0.2)1, labsize(small)) xtitle("", size(small)) ///
       ylabel(, labsize(small)) ytitle("Density", size(small)) ///
       graphregion(m(small) fcolor(white)) note("") name(kdensity_hot1, replace)
graph export kdensity_hot1_openClosed.pdf, replace

// Overlaid kdensity for mean_x_opened and mean_x_closed
twoway (kdensity mean_x_open if year==2014 & country_i == "BEL" & mean_x_open<=4,lpattern(solid)) ///
       (kdensity mean_x_closed if year==2014 & country_i == "BRA",lpattern(dash_dot)), ///
       legend(label(1 "X Open") label(2 "X Closed") size(small)) ///
       xlabel(0(1)4, labsize(small)) xtitle("", size(small)) ///
       ylabel(, labsize(small)) ytitle("Density", size(small)) ///
       graphregion(m(small) fcolor(white)) note("") name(kdensity_x, replace)
graph export kdensity_x_openClosed.pdf, replace

// Overlaid kdensity for mean_phi_opened and mean_phi_closed with two y-axes
twoway (kdensity mean_phi_open if year==2014 & country_i == "BEL" & mean_phi_open<=0.0001,lpattern(solid)) ///
       (kdensity mean_phi_closed if year==2014 & country_i == "BRA" & mean_phi_closed<=0.0001,lpattern(dash_dot)), ///
       legend(label(1 "{&phi} Open") label(2 "{&phi} Closed") size(small)) ///
       xlabel(0(0.00002)0.0001, labsize(small)) xtitle("", size(small)) ///
       ylabel(, labsize(small)) ///
       ytitle("Density", size(small)) ///
       graphregion(m(small) fcolor(white)) note("") name(kdensity_phi, replace)
graph export kdensity_phi_openClosed.pdf, replace

// Overlaid kdensity for mean_tva_opened and mean_tva_closed
twoway (kdensity mean_tva_open if year==2014 & country_i == "BEL" & mean_tva_open<=1,lpattern(solid)) ///
       (kdensity mean_tva_closed if year==2014 & country_i == "BRA" & mean_tva_closed<=1,lpattern(dash_dot)), ///
       legend(label(1 "T(VA) Open") label(2 "T(VA) Closed") size(small)) ///
       xlabel(0(0.2)1, labsize(small)) xtitle("", size(small)) ///
       ylabel(, labsize(small)) ytitle("Density", size(small)) ///
       graphregion(m(small) fcolor(white)) note("") name(kdensity_tva, replace)
graph export kdensity_tva_openClosed.pdf, replace


/* FIGURE: Dispersion of HOT, phi, X, and TiVA across sect. for each ctry (2014) */

graph hbox hot if (year == 2014), over(ctry_i, label(labsize(vsmall)) sort(1)) /*
*/ ylabel(,labsize(vsmall)) ytitle("HOT", size(small)) plotr(m(vsmall)) /*
*/ graphregion(m(small) fcolor(white)) note("") nooutside name(hot_boxplot_byctry2014)
quietly graph export hot_boxplot_byctry2014.pdf, replace

graph hbox xgo if (year == 2014), over(ctry_i, label(labsize(vsmall)) sort(med_hot_byctry)) /*
*/ ylabel(,labsize(vsmall)) ytitle("HOT1", size(small)) plotr(m(vsmall)) /*
*/ graphregion(m(small) fcolor(white)) note("") nooutside name(xgo_boxplot_byctry2014)
quietly graph export xgo_boxplot_byctry2014.pdf, replace

graph hbox xva if (year == 2014), over(ctry_i, label(labsize(vsmall)) sort(med_hot_byctry)) /*
*/ ylabel(,labsize(vsmall)) ytitle("X", size(small)) plotr(m(vsmall)) /*
*/ graphregion(m(small) fcolor(white)) note("") nooutside name(xva_boxplot_byctry2014)
quietly graph export xva_boxplot_byctry2014.pdf, replace

graph hbox phi if (year == 2014), over(ctry_i, label(labsize(vsmall)) sort(med_hot_byctry)) /*
*/ ylabel(,labsize(vsmall)) ytitle("{&phi}", size(small)) plotr(m(vsmall)) /*
*/ graphregion(m(small) fcolor(white)) note("") nooutside name(phi_boxplot_byctry2014)
quietly graph export phi_boxplot_byctry2014.pdf, replace

graph hbox tva if (year == 2014), over(ctry_i, label(labsize(vsmall)) sort(med_hot_byctry)) /*
*/ ylabel(,labsize(vsmall)) ytitle("T(VA)", size(small)) plotr(m(vsmall)) /*
*/ graphregion(m(small) fcolor(white)) note("") nooutside name(tiva_boxplot_byctry2014)
quietly graph export tiva_boxplot_byctry2014.pdf, replace

/* FIGURE: Dispersion of HOT, phi, X, and TiVA across ctry for each sect (2014) */

graph hbox hot if (year == 2014), over(sect_r, label(labsize(vsmall)) sort(1)) /*
*/ ylabel(,labsize(vsmall)) ytitle("HOT", size(small)) plotr(m(vsmall)) /*
*/ graphregion(m(small) fcolor(white)) note("") nooutside name(hot_boxplot_bysect2014)
quietly graph export hot_boxplot_bysect2014.pdf, replace

graph hbox xgo if (year == 2014), over(sect_r, label(labsize(vsmall)) sort(med_hot_bysect)) /*
*/ ylabel(,labsize(vsmall)) ytitle("HOT1", size(small)) plotr(m(vsmall)) /*
*/ graphregion(m(small) fcolor(white)) note("") nooutside name(xgo_boxplot_bysect2014)
quietly graph export xgo_boxplot_bysect2014.pdf, replace

graph hbox xva if (year == 2014), over(sect_r, label(labsize(vsmall)) sort(med_hot_bysect)) /*
*/ ylabel(,labsize(vsmall)) ytitle("X", size(small)) plotr(m(vsmall)) /*
*/ graphregion(m(small) fcolor(white)) note("") nooutside name(xva_boxplot_bysect2014)
quietly graph export xva_boxplot_bysect2014.pdf, replace

graph hbox phi if (year == 2014), over(sect_r, label(labsize(vsmall)) sort(med_hot_bysect)) /*
*/ ylabel(,labsize(vsmall)) ytitle("{&phi}", size(small)) plotr(m(vsmall)) /*
*/ graphregion(m(small) fcolor(white)) note("") nooutside name(phi_boxplot_bysect2014)
quietly graph export phi_boxplot_bysect2014.pdf, replace

graph hbox tva if (year == 2014), over(sect_r, label(labsize(vsmall)) sort(med_hot_bysect)) /*
*/ ylabel(,labsize(vsmall)) ytitle("T(VA)", size(small)) plotr(m(vsmall)) /*
*/ graphregion(m(small) fcolor(white)) note("") nooutside name(tiva_boxplot_bysect2014)
quietly graph export tiva_boxplot_bysect2014.pdf, replace

