/******************************************************************************/
/* VARIABLE ASSIGNMENTS AND TRANSFORMATION */

replace qdva_ijrs = qdva_ijrs*100

gen lhot = log(hot_ijrs)
label var lhot "log HOT"

gen ltva = log(tva_ijrs)
label var ltva "log T(VA)"

gen lxva = log(xva_ijrs)
label var lxva "log XVA"

gen lxgo = log(xgo_ijrs)
label var lxva "log XVA"

gen lphi = log(phi_ijrs)
label var lphi "log phiness of trade"

********************************************************************************
/* SECTOR DUMMIES: Agriculture, Mining, Manufacturing and Services */

gen agr_r = (sectcode_r=="r1"|sectcode_r=="r2"|sectcode_r=="r3")
label var agr_r "Agriculture r"

gen agr_s = (sectcode_s=="r1"|sectcode_s=="r2"|sectcode_s=="r3")
label var agr_s "Agriculture s"

gen mfg_r = (sectcode_r=="r4"|sectcode_r=="r5"|sectcode_r=="r6"|sectcode_r=="r7"|sectcode_r=="r8" /*
*/ |sectcode_r=="r9"|sectcode_r=="r10"|sectcode_r=="r11"|sectcode_r=="r12"/*
*/ |sectcode_r=="r13"|sectcode_r=="r14"|sectcode_r=="r15"|sectcode_r=="r16"/*
*/ |sectcode_r=="r17"|sectcode_r=="r18"|sectcode_r=="r19"|sectcode_r=="r20"/*
*/ |sectcode_r=="r21"|sectcode_r=="r22"|sectcode_r=="r23"|sectcode_r=="r27")
label var mfg_r "Manufacturing r"

gen mfg_s = (sectcode_s=="r4"|sectcode_s=="r5"|sectcode_s=="r6"|sectcode_s=="r7"|sectcode_s=="r8"/*
*/ |sectcode_s=="r9"|sectcode_s=="r10"|sectcode_s=="r11"|sectcode_s=="r12"/*
*/ |sectcode_s=="r13"|sectcode_s=="r14"|sectcode_s=="r15"|sectcode_s=="r16"/*
*/ |sectcode_s=="r17"|sectcode_s=="r18"|sectcode_s=="r19"|sectcode_s=="r20"/*
*/ |sectcode_s=="r21"|sectcode_s=="r22"|sectcode_s=="r23"|sectcode_s=="r27")
label var mfg_s "Manufacturing s"

gen ser_r = (sectcode_r=="r24"|sectcode_r=="r25"|sectcode_r=="r26"|sectcode_r=="r28"|sectcode_r=="r29"|sectcode_r=="r30"|sectcode_r=="r31"/*
*/ |sectcode_r=="r32"|sectcode_r=="r33"|sectcode_r=="r34"|sectcode_r=="r35"/*
*/ |sectcode_r=="r36"|sectcode_r=="r37"|sectcode_r=="r38"|sectcode_r=="r39"/*
*/ |sectcode_r=="r40"|sectcode_r=="r41"|sectcode_r=="r42"|sectcode_r=="r43"/*
*/ |sectcode_r=="r44"|sectcode_r=="r45"|sectcode_r=="r46"|sectcode_r=="r47"/*
*/ |sectcode_r=="r48"|sectcode_r=="r49"|sectcode_r=="r50")
label var ser_r "Services r"

gen ser_s = (sectcode_s=="r24"|sectcode_s=="r25"|sectcode_s=="r26"|sectcode_s=="r28"|sectcode_s=="r29"|sectcode_s=="r30"|sectcode_s=="r31"/*
*/ |sectcode_s=="r32"|sectcode_s=="r33"|sectcode_s=="r34"|sectcode_s=="r35"/*
*/ |sectcode_s=="r36"|sectcode_s=="r37"|sectcode_s=="r38"|sectcode_s=="r39"/*
*/ |sectcode_s=="r40"|sectcode_s=="r41"|sectcode_s=="r42"|sectcode_s=="r43"/*
*/ |sectcode_s=="r44"|sectcode_s=="r45"|sectcode_s=="r46"|sectcode_s=="r47"/*
*/ |sectcode_s=="r48"|sectcode_s=="r49"|sectcode_s=="r50")
label var ser_s "Services s"

gen pub_r = (sectcode_r=="r51"|sectcode_r=="r52"|sectcode_r=="r53"|sectcode_r=="r54"/*
*/ |sectcode_r=="r55" |sectcode_r=="r56")
label var pub_r "Public r"

gen pub_s = (sectcode_s=="r51"|sectcode_s=="r52"|sectcode_s=="r53"|sectcode_s=="r54"/*
*/ |sectcode_s=="r55" |sectcode_r=="r56")
label var pub_s "Public s"

gen serpub_r = ser_r + pub_r
gen serpub_s = ser_s + pub_s

********************************************************************************