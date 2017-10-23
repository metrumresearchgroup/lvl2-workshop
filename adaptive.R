library(mrgsolve)
library(dplyr)


code <- '
$INCLUDE adaptive.h

$GLOBAL
hx obj;

$PREAMBLE 
obj.reset();

$CMT A

$ODE dxdt_A = -0.5*A;

$MAIN 
if(NEWIND <= 1) obj.reset();

$TABLE
obj.save(A);

report("previous ", obj.previous());
report("current ", obj.current());

'

mod <- mcode("foo", code, project = 'model', soloc = '.')

mrgsim(init(mod, A = 100))


code <- '
$SET req = ""

$GLOBAL
double F1  = 1;

bool tta(double time, double evid, double titr) {
  return  (time/168 == floor(time/168)) && evid==0 && time > 7*24 && time <= 7*7*24 & titr==1;
}

$INCLUDE adaptive.h

$PARAM TVCL = 1, V = 20, KA = 1.2, TVEC50 = 20, TVE0 = 100
TITR = 1

$PKMODEL cmt = "GUT CENT", depot = TRUE

$OMEGA 0 0.09 100

$MAIN 

if(NEWIND <=1 ) F1 = 1;
double CL = TVCL*exp(ETA(1));
double EC50 = TVEC50*exp(ETA(2));
double E0 = TVE0 + ETA(3);

F_GUT = F1;

$TABLE
capture CP = CENT/V;
capture RESP = E0 + 60*CP/(EC50+CP);

if(tta(self.time,EVID,TITR)) F1 = adjust(RESP,F1); 

capture F1out = F1;
'

##' The simulation duration

dur <- 10*7*24


mod <- 
  mcode("foo", code, project = '.') %>% 
  update(end = dur) %>% 
  ev(amt=100, ii=12, addl=2*10*7)


mod <- param(mod, TITR = 1)
