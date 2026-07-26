local dir `c(pwd)'
cd "`dir'/output/tables"
/*
Panel Data Regressions (OLS)
*/
quietly{
    local outputfile "Table_ValueAdded"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex

    quietly: eststo: xi: reg dlrva_ppp hot,  vce(cluster cross)
    `writeoutput' keep(hot) title("Value Added Estimation: HP Detrended") ctitle("All sectors")
    quietly: eststo: xi: reg dlrva_ppp xgo,  vce(cluster cross)
    `writeoutput' keep(xgo) ctitle("All sectors")
    quietly: eststo: xi: reg dlrva_ppp xva,  vce(cluster cross)
    `writeoutput' keep(xva) ctitle("All sectors")
    quietly: eststo: xi: reg dlrva_ppp phi,  vce(cluster cross)
    `writeoutput' keep(phi) ctitle("All sectors")
    quietly: eststo: xi: reg dlrva_ppp tva,  vce(cluster cross)
    `writeoutput' keep(tva) ctitle("All sectors")
    quietly: eststo: xi: reg dlrva_ppp hot xva phi tva,  vce(cluster cross)
    `writeoutput' keep(hot xva phi tva) ctitle("All sectors")

    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}



// AGR
quietly{
    local outputfile "Table_ValueAdded_AGR"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex

    quietly: eststo: xi: reg dlrva_ppp hot if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(hot) title("Value Added Estimation: HP Detrended") ctitle("AGR")
    quietly: eststo: xi: reg dlrva_ppp xgo if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(xgo) ctitle("AGR")
    quietly: eststo: xi: reg dlrva_ppp xva if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(xva) ctitle("AGR")
    quietly: eststo: xi: reg dlrva_ppp phi if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(phi) ctitle("AGR")
    quietly: eststo: xi: reg dlrva_ppp tva if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(tva) ctitle("AGR")
    quietly: eststo: xi: reg dlrva_ppp hot xva phi tva if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(hot xva phi tva) ctitle("AGR")

    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}

// MFG
quietly{
    local outputfile "Table_ValueAdded_MFG"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex

    quietly: eststo: xi: reg dlrva_ppp hot if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(hot) title("Value Added Estimation: HP Detrended") ctitle("MFG")
    quietly: eststo: xi: reg dlrva_ppp xgo if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(xgo) ctitle("MFG")
    quietly: eststo: xi: reg dlrva_ppp xva if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(xva) ctitle("MFG")
    quietly: eststo: xi: reg dlrva_ppp phi if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(phi) ctitle("MFG")
    quietly: eststo: xi: reg dlrva_ppp tva if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(tva) ctitle("MFG")
    quietly: eststo: xi: reg dlrva_ppp hot xva phi tva if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(hot xva phi tva) ctitle("MFG")

    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}

// SER with public sectors
quietly{
    local outputfile "Table_ValueAdded_SER"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex

    quietly: eststo: xi: reg dlrva_ppp hot if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(hot) title("Value Added Estimation: HP Detrended") ctitle("SER")
    quietly: eststo: xi: reg dlrva_ppp xgo if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(xgo) ctitle("SER")
    quietly: eststo: xi: reg dlrva_ppp xva if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(xva) ctitle("SER")
    quietly: eststo: xi: reg dlrva_ppp phi if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(phi) ctitle("SER")
    quietly: eststo: xi: reg dlrva_ppp tva if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(tva) ctitle("SER")
    quietly: eststo: xi: reg dlrva_ppp hot xva phi tva if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(hot xva phi tva) ctitle("SER")

    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}


/*
First Difference Panel Data Regressions (OLS)
*/
// All sectors
quietly{
    local outputfile "Table_ValueAdded_diff"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex

    quietly: eststo: xi: reg d.lrva_ppp d.hot,  vce(cluster cross)
    `writeoutput' keep(d.hot) title("Value Added Estimation: First Difference") ctitle("All sectors")
    quietly: eststo: xi: reg d.lrva_ppp d.xgo,  vce(cluster cross)
    `writeoutput' keep(d.xgo) ctitle("All sectors")
    quietly: eststo: xi: reg d.lrva_ppp d.xva,  vce(cluster cross)
    `writeoutput' keep(d.xva) ctitle("All sectors")
    quietly: eststo: xi: reg d.lrva_ppp d.phi,  vce(cluster cross)
    `writeoutput' keep(d.phi) ctitle("All sectors")
    quietly: eststo: xi: reg d.lrva_ppp d.tva,  vce(cluster cross)
    `writeoutput' keep(d.tva) ctitle("All sectors")
    quietly: eststo: xi: reg d.lrva_ppp d.hot d.xva d.phi d.tva,  vce(cluster cross)
    `writeoutput' keep(d.hot d.xva d.phi d.tva) ctitle("All sectors")

    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}

// AGR
quietly{
    local outputfile "Table_ValueAdded_diff_AGR"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex

    quietly: eststo: xi: reg d.lrva_ppp d.hot if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.hot) title("Value Added Estimation: HP Detrended") ctitle("AGR")
    quietly: eststo: xi: reg d.lrva_ppp d.xgo if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.xgo) ctitle("AGR")
    quietly: eststo: xi: reg d.lrva_ppp d.xva if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.xva) ctitle("AGR")
    quietly: eststo: xi: reg d.lrva_ppp d.phi if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.phi) ctitle("AGR")
    quietly: eststo: xi: reg d.lrva_ppp d.tva if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.tva) ctitle("AGR")
    quietly: eststo: xi: reg d.lrva_ppp d.hot d.xva d.phi d.tva if agr_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.hot d.xva d.phi d.tva) ctitle("AGR")

    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}

// MFG
quietly{
    local outputfile "Table_ValueAdded_diff_MFG"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex

    quietly: eststo: xi: reg d.lrva_ppp d.hot if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.hot) title("Value Added Estimation: HP Detrended") ctitle("MFG")
    quietly: eststo: xi: reg d.lrva_ppp d.xgo if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.xgo) ctitle("MFG")
    quietly: eststo: xi: reg d.lrva_ppp d.xva if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.xva) ctitle("MFG")
    quietly: eststo: xi: reg d.lrva_ppp d.phi if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.phi) ctitle("MFG")
    quietly: eststo: xi: reg d.lrva_ppp d.tva if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.tva) ctitle("MFG")
    quietly: eststo: xi: reg d.lrva_ppp d.hot d.xva d.phi d.tva if mfg_r == 1,  vce(cluster cross)
    `writeoutput' keep(d.hot d.xva d.phi d.tva) ctitle("MFG")

    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}

// SER with public sectors
quietly{
    local outputfile "Table_ValueAdded_diff_SER"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex

    quietly: eststo: xi: reg d.lrva_ppp d.hot if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(d.hot) title("Value Added Estimation: HP Detrended") ctitle("SER")
    quietly: eststo: xi: reg d.lrva_ppp d.xgo if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(d.xgo) ctitle("SER")
    quietly: eststo: xi: reg d.lrva_ppp d.xva if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(d.xva) ctitle("SER")
    quietly: eststo: xi: reg d.lrva_ppp d.phi if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(d.phi) ctitle("SER")
    quietly: eststo: xi: reg d.lrva_ppp d.tva if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(d.tva) ctitle("SER")
    quietly: eststo: xi: reg d.lrva_ppp d.hot d.xva d.phi d.tva if (ser_r == 1) | (pub_r == 1),  vce(cluster cross)
    `writeoutput' keep(d.hot d.xva d.phi d.tva) ctitle("SER")

    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}

eststo clear
cd "`dir'"
