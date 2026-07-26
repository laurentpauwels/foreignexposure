local dir `c(pwd)'
cd "`dir'/output/tables"


//////Quasi-corr///////
quietly{
    local outputfile "Table_Synch_quasicorr"
    local outreg2options "bdec(3) sdec(3) coefastr se  nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"

    cap erase `outputfile'.tex

    quietly: reghdfe qdva_ijrs lhot, absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lhot) addtext(Country-Sector Pairs FE, YES, Year FE, YES)
    quietly: reghdfe qdva_ijrs lxgo, absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lxgo) addtext(Country-Sector Pairs FE, YES, Year FE, YES)
    quietly: reghdfe qdva_ijrs lxva, absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lxva) addtext(Country-Sector Pairs FE, YES, Year FE, YES)
    quietly: reghdfe qdva_ijrs lphi, absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lphi) addtext(Country-Sector Pairs FE, YES, Year FE, YES)
    quietly: reghdfe qdva_ijrs ltva, absorb(cross year) vce(cluster cross)
    `writeoutput' keep(ltva) addtext(Country-Sector Pairs FE, YES, Year FE, YES)
    quietly: reghdfe qdva_ijrs lhot lxva lphi ltva, absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lhot lxva lphi ltva) addtext(Country-Sector Pairs FE, YES, Year FE, YES)

    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}



////// Regressions for (agr_r==1 & agr_s==1) | (agr_r==1 & mfg_s==1) | (agr_r==1 & ser_s==1) //////
quietly{
    local outputfile "Table_Synch_quasicorr_AGR"
    local outreg2options "bdec(3) sdec(3) coefastr se nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"
    cap erase `outputfile'.tex
    quietly: reghdfe qdva_ijrs lhot if (agr_r==1 & agr_s==1) | (agr_r==1 & mfg_s==1) | (agr_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lhot) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("AGR")
    quietly: reghdfe qdva_ijrs lxgo if (agr_r==1 & agr_s==1) | (agr_r==1 & mfg_s==1) | (agr_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lxgo) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("AGR")
    quietly: reghdfe qdva_ijrs lxva if (agr_r==1 & agr_s==1) | (agr_r==1 & mfg_s==1) | (agr_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lxva) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("AGR")
    quietly: reghdfe qdva_ijrs lphi if (agr_r==1 & agr_s==1) | (agr_r==1 & mfg_s==1) | (agr_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lphi) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("AGR")
    quietly: reghdfe qdva_ijrs ltva if (agr_r==1 & agr_s==1) | (agr_r==1 & mfg_s==1) | (agr_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(ltva) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("AGR")
    quietly: reghdfe qdva_ijrs lhot lxva lphi ltva if (agr_r==1 & agr_s==1) | (agr_r==1 & mfg_s==1) | (agr_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lhot lxva lphi ltva) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("AGR")
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}

////// Regressions for (mfg_r==1 & mfg_s==1) | (mfg_r==1 & agr_s==1) | (mfg_r==1 & ser_s==1) //////
quietly{
    local outputfile "Table_Synch_quasicorr_MFG"
    local outreg2options "bdec(3) sdec(3) coefastr se nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"
    cap erase `outputfile'.tex
    quietly: reghdfe qdva_ijrs lhot if (mfg_r==1 & mfg_s==1) | (mfg_r==1 & agr_s==1) | (mfg_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lhot) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("MFG")
    quietly: reghdfe qdva_ijrs lxgo if (mfg_r==1 & mfg_s==1) | (mfg_r==1 & agr_s==1) | (mfg_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lxgo) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("MFG")
    quietly: reghdfe qdva_ijrs lxva if (mfg_r==1 & mfg_s==1) | (mfg_r==1 & agr_s==1) | (mfg_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lxva) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("MFG")
    quietly: reghdfe qdva_ijrs lphi if (mfg_r==1 & mfg_s==1) | (mfg_r==1 & agr_s==1) | (mfg_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lphi) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("MFG")
    quietly: reghdfe qdva_ijrs ltva if (mfg_r==1 & mfg_s==1) | (mfg_r==1 & agr_s==1) | (mfg_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(ltva) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("MFG")
    quietly: reghdfe qdva_ijrs lhot lxva lphi ltva if (mfg_r==1 & mfg_s==1) | (mfg_r==1 & agr_s==1) | (mfg_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lhot lxva lphi ltva) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("MFG")
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}

////// Regressions for (ser_r==1 & agr_s==1) | (ser_r==1 & mfg_s==1) | (ser_r==1 & ser_s==1) //////
quietly{
    local outputfile "Table_Synch_quasicorr_SER"
    local outreg2options "bdec(3) sdec(3) coefastr se nor2 nocons label excel tex"
    local writeoutput "outreg2 using `outputfile', append `outreg2options'"
    cap erase `outputfile'.tex
    quietly: reghdfe qdva_ijrs lhot if (serpub_r==1 & agr_s==1) | (serpub_r==1 & mfg_s==1) | (serpub_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lhot) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("SER")
    quietly: reghdfe qdva_ijrs lxgo if (serpub_r==1 & agr_s==1) | (serpub_r==1 & mfg_s==1) | (serpub_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lxgo) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("SER")
    quietly: reghdfe qdva_ijrs lxva if (serpub_r==1 & agr_s==1) | (serpub_r==1 & mfg_s==1) | (serpub_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lxva) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("SER")
    quietly: reghdfe qdva_ijrs lphi if (serpub_r==1 & agr_s==1) | (serpub_r==1 & mfg_s==1) | (serpub_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lphi) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("SER")
    quietly: reghdfe qdva_ijrs ltva if (serpub_r==1 & agr_s==1) | (serpub_r==1 & mfg_s==1) | (serpub_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(ltva) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("SER")
    quietly: reghdfe qdva_ijrs lhot lxva lphi ltva if (serpub_r==1 & agr_s==1) | (serpub_r==1 & mfg_s==1) | (serpub_r==1 & serpub_s==1), absorb(cross year) vce(cluster cross)
    `writeoutput' keep(lhot lxva lphi ltva) addtext(Country-Sector Pairs FE, YES, Year FE, YES) ctitle("SER")
    cap erase `outputfile'.txt
    cap erase `outputfile'.xml 
}
