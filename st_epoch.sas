%macro st_epoch(indat=,date=);

data for_epoch;
	set sdtm.se;
run;	
 
proc sort data=for_epoch;
	by usubjid;
run;

proc transpose data=for_epoch out=se_tr(drop=_name_ _label_);
	by usubjid;
	id epoch;
	var SESTDTC;
run;


data _epoch;
	length EXSTDTC $200;
	merge &indat(in=a) se_tr;
	by usubjid;
	if a;
	EXSTDTC=EXSTDTC;
	if cmiss(TREATMENT,FOLLOW_UP)=2 then EPOCH="SCREENING";
	if length(&date)=10 and missing(EXSTDTC) then do;
			if input(SCREENING, 
				yymmdd10.)<=input(&date, yymmdd10.)<input(TREATMENT, yymmdd10.) then
					EPOCH="SCREENING";
			else if input(TREATMENT, yymmdd10.)<=input(&date, 
				yymmdd10.)<input(FOLLOW_UP, yymmdd10.) then
					EPOCH="TREATMENT";
			else if input(&date, yymmdd10.)>=input(FOLLOW_UP, yymmdd10.) then
				EPOCH="FOLLOW-UP";
		drop EXSTDTC;		
		end;		
	if length(&date)=10 and not missing(EXSTDTC) then do;
			if input(SCREENING, 
				yymmdd10.)<=input(&date, yymmdd10.)<input(TREATMENT, yymmdd10.) then
					EPOCH="SCREENING";
			else if input(TREATMENT, yymmdd10.)<=input(&date, 
				yymmdd10.)<=input(FOLLOW_UP, yymmdd10.) then
					EPOCH="TREATMENT";
			else if input(&date, yymmdd10.)>input(FOLLOW_UP, yymmdd10.) then
				EPOCH="FOLLOW-UP";
		end;
	drop RFSTDTC SCREENING TREATMENT FOLLOW_UP;
run;
%mend st_epoch;
	
/* %st_epoch(indat=ex_dy,date=EXSTDTC) */