quietly reg radscore age health expectedu familysize lnasset parentedu
predict u,residual
gen usq = u^2
gen lnusq=ln(usq)
reg lnusq age health expectedu familysize lnasset parentedu
predict g
gen h = exp(g)
wls0 radscore age health expectedu familysize lnasset parentedu, wvar(h) type(abse) nocon
rvfplot
