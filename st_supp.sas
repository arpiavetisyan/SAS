%macro st_supp(loc=, data=);
	%if &data=DM %then
		%do;

			data fortr;
				set &loc..supp&data.;
			run;

			data common;
				set &loc..&data.;
			run;
			
			proc sort data=fortr;
				by STUDYID RDOMAIN USUBJID;
			run;

			proc transpose data=fortr out=transp(drop=_name_);
				by USUBJID;
				var QVAL;
				id QNAM;
				idlabel QLABEL;
			run;

			data &data.sup;
				length USUBJID $200;
				merge common transp;
				by USUBJID;
			run;

		%end;

	%if &data^=DM %then
		%do;

			data fortr;
				set &loc..supp&data.;
				&data.SEQ=input(IDVARVAL,best.);
			run;

			data common;
				set &loc..&data.;
			run;
			
			proc sort data=fortr;
				by STUDYID RDOMAIN USUBJID &data.SEQ ;
			run;

			proc transpose data=fortr out=transp(drop=_name_);
				by USUBJID &data.SEQ;
				var QVAL;
				id QNAM;
				idlabel QLABEL;
			run;
			data &data.sup;
				length USUBJID $200;
				merge common transp;
				by USUBJID &data.SEQ;
			run;
	%end;
%mend st_supp;

		/* quit; */
/*  */
/* %st_supp(loc=sdtm, data=AE); */