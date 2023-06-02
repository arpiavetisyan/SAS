/* not missing(ENDTC) and not missing(STDTC),if not missing(STDTC) and missing(ENDTC), if missing(STDTC) and not missing(ENDTC)*/;
%macro st_dy(data=,datest=,datend=);
data &data._dy;
	set &data.;
	%if &datest. ne and &datend. ne %then %do;
	if not missing(RFSTDTC) and lengthn(&datest)=10 and lengthn(RFSTDTC)=10 then
		do;

			if &datest>=RFSTDTC then
				&data.STDY=input(&datest, yymmdd10.)-input(RFSTDTC, yymmdd10.)+1;
			else
				&data.STDY=input(&datest, yymmdd10.)-input(RFSTDTC, yymmdd10.);
		end;

	if not missing(RFSTDTC) and lengthn(&datend)=10 and lengthn(RFSTDTC)=10 then
		do;

			if &datend>=RFSTDTC then
				&data.ENDY=input(&datend, yymmdd10.)-input(RFSTDTC, yymmdd10.)+1;
			else
				&data.ENDY=input(&datend, yymmdd10.)-input(RFSTDTC, yymmdd10.);
		end;
	%end;	
	%if &datest ne and &datend eq %then %do;
			if not missing(RFSTDTC) and lengthn(&datest)=10 and lengthn(RFSTDTC)=10 then
		do;

			if &datest>=RFSTDTC then
				&data.STDY=input(&datest, yymmdd10.)-input(RFSTDTC, yymmdd10.)+1;
			else
				&data.STDY=input(&datest, yymmdd10.)-input(RFSTDTC, yymmdd10.);
		end;
	%end;	
run;
%mend;

/* %st_dy(data=%str(ex_mcr),datest=EXSTDTC,datend=EXENDTC); */
/* %st_dy(data=%str(vs_epoch),datest=VSDTC); */

/* proc contents data = ex out = test;run; */
