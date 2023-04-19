use "/Users/soyo/Downloads/学习/Semester 1/Data Science/大作业/CFPS2018变量池ver2.dta"
tabstat age health iq hk urban provin rank hospital total_asset  familysize eduexpen trainspend party_f eduyear_f eduyear_m parentedu expectedu expectgrade 
drop if total_asset <= 0
gen testscore = wordtest+ mathtest
tabstat testscore age health iq hk urban provin rank hospital total_asset  familysize eduexpen trainspend party_f eduyear_f eduyear_m parentedu expectedu expectgrade 
tabstat age health iq hk urban provin rank hospital total_asset  familysize eduexpen trainspend party_f eduyear_f eduyear_m parentedu expectedu expectgrade,stats(mean sd min p50 max) c(s) f(%6.2f)
logout, save(description) word replace: tabstat age health iq hk urban provin rank hospital total_asset  familysize eduexpen trainspend party_f eduyear_f eduyear_m parentedu expectedu expectgrade, stats(mean sd min p50 max) c(s) f(%6.2f)
