[SET] delta=0.1, end=8, req=""

[CMT] CENT PERIPH

[PARAM]
WT = 70
CLCR = 83
AGE = 35

[THETA]
 1.50E+01  
 1.27E+01  
 1.52E+01  
 1.24E+01 
-4.47E-01  
 8.20E-01  
 1.88E-01  
 4.76E-01  
 6.20E-01

[MAIN]

double TVCL =    THETA1;
double TVV1 =    THETA2;
double TVQ  =    THETA3;
double TVV2 =    THETA4;
double CL_AGE =  THETA5;
double V1_WT =   THETA6;
double RUV_PROP =    THETA7;
double RUV_ADD =    THETA8;
double CL_CLCR = THETA9;

double LOGTWT = log((WT/70)); 
  
double LOGTAGE = log((AGE/35));
  
double LOGTCLCR = log((CLCR/83));
  
double MU_1 = log(TVCL) + CL_AGE * LOGTAGE + CL_CLCR * LOGTCLCR;

double CL =  exp(MU_1 +  ETA(1)) ;

double MU_2 = log(TVV1) + V1_WT * LOGTWT;
double V1 =  exp(MU_2 +  ETA(2)) ;

double MU_3 = log(TVQ);
double Q =  exp(MU_3 +  ETA(3)) ;

double MU_4 = log(TVV2);
double V2 =  exp(MU_4 +  ETA(4));

[OMEGA]
8.84E-02
9.76E-02
1.03E-01
7.26E-02

[SIGMA]
1

[ODE] 
double CENTRAL_DES = CENT;
double PERIPHERAL_DES = PERIPH;
double CC_DES = (CENTRAL_DES/V1);
dxdt_CENT = ((((-(Q)*CENTRAL_DES)/V1)+((Q*PERIPHERAL_DES)/V2))-((CL*CENTRAL_DES)/V1));
dxdt_PERIPH = (((Q*CENTRAL_DES)/V1)-((Q*PERIPHERAL_DES)/V2));
      
[TABLE] 
capture CC = (CENT/V1);
double IPRED = CC;
double W = sqrt((RUV_ADD*RUV_ADD)+ (RUV_PROP*RUV_PROP*IPRED*IPRED));
capture Y = IPRED+W*EPS(1);
