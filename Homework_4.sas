
ods rtf file="C:\Users\nmolin\OneDrive - University of Iowa\Documents\BIOS5130 Jeff\Homework_4.rtf";

/*Problem 1
		a.	Does this suggest that smoking is a confounder in the relationship between coffee and MI?  Explain
Yes, smoking is a confounder due to the difference of 2.98 to 1.89. Once smoking was added to the relationship between
coffee and MI, it change substantially toward the null proving there is association with smoking.

Problem 2
		b.	What two criteria need to be satisfied for a potential confounder to be an actual confounder 
		in the relationship between a predictor of interest and an outcome of interest?   
		(Answer this both in general terms, and in terms of what this would mean in the hypothetical MI/coffee/smoking study.)  
 
-The potential confounder must be associated with the exposure and outcome(independent of the exposure).
-For Smoking, it should be associated with coffee consumption, meaning smokers are more likely to drink coffee.
And smoking must be associated with MI independent of coffee status, meaning smoking is not caused by coffee.*


/* Problem 1 */
data mi_smk1;
 input MI n1 n0 @@;
 coffee=1; do i=1 to n1; smoking=1; output; end;  
 coffee=0; do i=1 to n0; smoking=1; output; end;
cards;
1  307 108
0  108 77
;
run;

data mi_smk0;
 input MI n1 n0 @@;
 coffee=1; do i=1 to n1; smoking=0; output; end;  
 coffee=0; do i=1 to n0; smoking=0; output; end;
cards;
1  73 112
0  112 303
;
run;

data mi; set mi_smk1 mi_smk0; 
  smoke_coff=smoking*coffee; 
run;

title 'Q1a: Crude Coffee?MI Association';
proc freq data=mi; tables coffee*mi / cmh or; run;

title 'Q1c: Smoking-adjusted Coffee?MI Association (Mantel?Haenszel + Zelen test)';
proc freq data=mi;
 tables smoking*coffee*mi / cmh or;
 exact eqor;
run;

title 'Q1c: Logistic Regression ? Crude Coffee effect';
proc logistic data=mi descending;
 model mi = coffee;
run;

title 'Q1c: Logistic Regression ? Interaction Test';
proc logistic data=mi descending;
 model mi = smoking|coffee;
run;

title 'Q1c: Logistic Regression ? No Interaction (adjusted)';
proc logistic data=mi descending;
 model mi = smoking coffee;
run;


/* Problem 2 */
data asthma_boys;
 input asthma n1 n0 @@;
 smoke=1; do i=1 to n1; sex=0; output; end;  /* boys heavy */
 smoke=0; do i=1 to n0; sex=0; output; end;  /* boys light/non */
cards;
1 17 41
0 63 315
;
run;

data asthma_girls;
 input asthma n1 n0 @@;
 smoke=1; do i=1 to n1; sex=1; output; end;  /* girls heavy */
 smoke=0; do i=1 to n0; sex=1; output; end;  /* girls light/non */
cards;
1 8 20
0 55 261
;
run;

data asthma; set asthma_boys asthma_girls; run;

title 'Q2a: Crude Smoking?Asthma Association';
proc freq data=asthma; tables smoke*asthma / cmh or; run;

title 'Q2b/Q2c: Sex-specific Smoking?Asthma ORs (Breslow-Day + Zelen test)';
proc freq data=asthma;
 tables sex*smoke*asthma / cmh or;
 exact eqor;
run;

title 'Q2d: Logistic Regression ? Adjusted, No Interaction';
proc logistic data=asthma descending;
 model asthma = smoke sex;
run;

title 'Q2e: Logistic Regression ? With Interaction';
proc logistic data=asthma descending;
 model asthma = smoke|sex;
run;


/* Question 2 part a: Crude OR
- Crude OR 1.858

Question 2 part b:

-Boys: OR = 1.803
-Girls: OR = 1.898

Question 2 part c:
- Breslow-Day test statistic = 0.00888, df=1, p = 0.9254
Interpretation: A large p-value fails to reject homogeneity. The ORs are not statistically different.

- Woolf test statistic = 0.0110, df=1, p= 0.9163

Question 2 part d:

- MH adjusted OR = 1.834
- 95% CI [1.103, 3.0554]

Question 2 part e
coef        OR    CI_low   CI_high
const       -1.904346  0.148920  0.108891  0.203665
smoke_heavy  0.607114  1.835128  1.102463  3.054701
is_girl     -0.655300  0.519286  0.321946  0.837590

Interpretation:
- Smoking adjusted for sex: OR = 1.835, 95% CI [1.102, 3.055]
- Sex adjusted for smoking: OR 0.519, 95% CI[0.322, 0.838]

Question 2 part f
-Likelihood-ratio statistic = 0.0087, df=1, p = 0.9255

Interpretation: A large p-value indicates no strong evidence of interation.
p > 0.05, we do not reject the no-interaction assumption. */

/* Close the PDF */
ods rtf close;
