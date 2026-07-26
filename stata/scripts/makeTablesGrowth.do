local dir `c(pwd)'
cd "`dir'/output/tables"

quietly{
    local outputfile "Table_Growth"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex
    eststo clear
    
    quietly: eststo: xi: reg lgrva lrva hot i.sect_r i.ctry_i, vce(cluster cross)
    `writeoutput' keep(hot) addtext(Country, Yes, Sector FE, Yes) /*
    */ title("Growth Estimation") ctitle("All sectors")
    quietly: eststo: xi: reg lgrva lrva xgo i.sect_r i.ctry_i, vce(cluster cross)
    `writeoutput' keep(xgo) addtext(Country, Yes, Sector FE, Yes) ctitle("All sectors")
    quietly: eststo: xi: reg lgrva lrva xva i.sect_r i.ctry_i, vce(cluster cross)
    `writeoutput' keep(xva) addtext(Country, Yes, Sector FE, Yes) ctitle("All sectors")
    quietly: eststo: xi: reg lgrva lrva phi i.sect_r i.ctry_i, vce(cluster cross)
    `writeoutput' keep(phi) addtext(Country, Yes, Sector FE, Yes) ctitle("All sectors")
    quietly: eststo: xi: reg lgrva lrva tva i.sect_r i.ctry_i, vce(cluster cross)
    `writeoutput' keep(tva) addtext(Country, Yes, Sector FE, Yes) ctitle("All sectors")
    quietly: eststo: xi: reg lgrva lrva hot xva phi tva i.sect_r i.ctry_i, vce(cluster cross)
    `writeoutput' keep(hot xva phi tva) ctitle("All sectors")
    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}
    
// AGR
quietly{
    local outputfile "Table_Growth_AGR"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex
    eststo clear
    
    quietly: eststo: xi: reg lgrva lrva hot i.sect_r i.ctry_i if agr_r==1, vce(cluster cross)
    `writeoutput' keep(hot) addtext(Country, Yes, Sector FE, Yes) /*
    */ title("Growth Estimation") ctitle("AGR")
    quietly: eststo: xi: reg lgrva lrva xgo i.sect_r i.ctry_i if agr_r==1, vce(cluster cross)
    `writeoutput' keep(xgo) addtext(Country, Yes, Sector FE, Yes) ctitle("AGR")
    quietly: eststo: xi: reg lgrva lrva xva i.sect_r i.ctry_i if agr_r==1, vce(cluster cross)
    `writeoutput' keep(xva) addtext(Country, Yes, Sector FE, Yes) ctitle("AGR")
    quietly: eststo: xi: reg lgrva lrva phi i.sect_r i.ctry_i if agr_r==1, vce(cluster cross)
    `writeoutput' keep(phi) addtext(Country, Yes, Sector FE, Yes) ctitle("AGR")
    quietly: eststo: xi: reg lgrva lrva tva i.sect_r i.ctry_i if agr_r==1, vce(cluster cross)
    `writeoutput' keep(tva) addtext(Country, Yes, Sector FE, Yes) ctitle("AGR")
    quietly: eststo: xi: reg lgrva lrva hot xva phi tva i.sect_r i.ctry_i if agr_r == 1, vce(cluster cross)
    `writeoutput' keep(hot xva phi tva) addtext(Country, Yes, Sector FE, Yes) ctitle("AGR")
    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}

// MFG
quietly{
    local outputfile "Table_Growth_MFG"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex
    eststo clear
    
    quietly: eststo: xi: reg lgrva lrva hot i.sect_r i.ctry_i if mfg_r==1, vce(cluster cross)
    `writeoutput' keep(hot) addtext(Country, Yes, Sector FE, Yes) /*
    */ title("Growth Estimation") ctitle("MFG")
    quietly: eststo: xi: reg lgrva lrva xgo i.sect_r i.ctry_i if mfg_r==1, vce(cluster cross)
    `writeoutput' keep(xgo) addtext(Country, Yes, Sector FE, Yes) ctitle("MFG")
    quietly: eststo: xi: reg lgrva lrva xva i.sect_r i.ctry_i if mfg_r==1, vce(cluster cross)
    `writeoutput' keep(xva) addtext(Country, Yes, Sector FE, Yes) ctitle("MFG")
    quietly: eststo: xi: reg lgrva lrva phi i.sect_r i.ctry_i if mfg_r==1, vce(cluster cross)
    `writeoutput' keep(phi) addtext(Country, Yes, Sector FE, Yes) ctitle("MFG")
    quietly: eststo: xi: reg lgrva lrva tva i.sect_r i.ctry_i if mfg_r==1, vce(cluster cross)
    `writeoutput' keep(tva) addtext(Country, Yes, Sector FE, Yes) ctitle("MFG")
    quietly: eststo: xi: reg lgrva lrva hot xva phi tva i.sect_r i.ctry_i if mfg_r == 1, vce(cluster cross)
    `writeoutput' keep(hot xva phi tva) addtext(Country, Yes, Sector FE, Yes) ctitle("MFG")
    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}
// SER
quietly{
    local outputfile "Table_Growth_SER"
    local outreg2options " coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex
    eststo clear
    
    quietly: eststo: xi: reg lgrva lrva hot i.sect_r i.ctry_i if (ser_r == 1) | (pub_r == 1), vce(cluster cross)
    `writeoutput' keep(hot) addtext(Country, Yes, Sector FE, Yes) /*
    */ title("Growth Estimation") ctitle("SER")
    quietly: eststo: xi: reg lgrva lrva xgo i.sect_r i.ctry_i if (ser_r == 1) | (pub_r == 1), vce(cluster cross)
    `writeoutput' keep(xgo) addtext(Country, Yes, Sector FE, Yes) ctitle("SER")
    quietly: eststo: xi: reg lgrva lrva xva i.sect_r i.ctry_i if (ser_r == 1) | (pub_r == 1), vce(cluster cross)
    `writeoutput' keep(xva) addtext(Country, Yes, Sector FE, Yes) ctitle("SER")
    quietly: eststo: xi: reg lgrva lrva phi i.sect_r i.ctry_i if (ser_r == 1) | (pub_r == 1), vce(cluster cross)
    `writeoutput' keep(phi) addtext(Country, Yes, Sector FE, Yes) ctitle("SER")
    quietly: eststo: xi: reg lgrva lrva tva i.sect_r i.ctry_i if (ser_r == 1) | (pub_r == 1), vce(cluster cross)
    `writeoutput' keep(tva) addtext(Country, Yes, Sector FE, Yes) ctitle("SER")
    quietly: eststo: xi: reg lgrva lrva hot xva phi tva i.sect_r i.ctry_i if (ser_r == 1) | (pub_r == 1), vce(cluster cross)
    `writeoutput' keep(hot xva phi tva) addtext(Country, Yes, Sector FE, Yes) ctitle("SER")
    eststo clear
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}
