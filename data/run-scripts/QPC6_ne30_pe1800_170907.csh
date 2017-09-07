#!/bin/tcsh

setenv proj ""

## FOR CAM-HOMME
#setenv src "camtrunk_170809"

## FOR CAM-SE
setenv src "physgrid_170901"

setenv caze ${src}_QPC6_ne30_`date '+%y%m%d'`_54months

/glade/u/home/aherring/$src/cime/scripts/create_newcase --case /glade/scratch/aherring/$caze --compset QPC6 --res ne30_ne30_mg16 --project $proj --compiler intel --q regular --walltime 11:00:00 --pecount 1800 --run-unsupported
cd /glade/scratch/aherring/$caze

./xmlchange STOP_OPTION=nmonths,STOP_N=54
./xmlchange RESUBMIT=0
./xmlchange DOUT_S=FALSE
./xmlchange NTHRDS=2
./xmlchange ATM_NCPL=48

## old viscosity coefficients
#echo " se_hypervis_on_plevs = .false. ">> user_nl_cam
#echo " se_hypervis_subcycle = 3	">>user_nl_cam
#echo " se_nu =  0.10E+16	">>user_nl_cam
#echo " se_nu_div =  6.25E+15	">>user_nl_cam
#echo " se_nu_p =  0.10E+16	">>user_nl_cam
#echo " se_nu_top =  0.25E+06	">>user_nl_cam

##history
echo "inithist 		= 'NONE'						 ">> user_nl_cam
echo "se_statefreq      = 144                                                    ">> user_nl_cam
echo "empty_htapes      = .true.                                                 ">> user_nl_cam
echo "fincl1            = 'PS','PSDRY','T','Q','Z3','U','V','OMEGA','PRECL','PRECC',     ">> user_nl_cam
echo "                    'CAPE','CLOUDFRAC_CLUBB','CONCLD','FREQSH','FREQZM',   ">> user_nl_cam
echo "			  'PBLH','SST','CLDTOT'					 ">> user_nl_cam
echo "fincl2            = 'PS','PSDRY','T','Q','Z3','U','V','OMEGA',			 ">> user_nl_cam
echo "                    'CLDLIQ','CLDICE','CMFMCDZM','CAPE','PCONVT',		 ">> user_nl_cam
echo "                    'CONCLD','CLOUDFRAC_CLUBB','FLNT','FLNS','FSNS',	 ">> user_nl_cam
echo "                    'FSNT','SHFLX','LHFLX','PRECC','PRECL','PBLH'          ">> user_nl_cam
echo "fincl3            = 'DTCORE','PTTEND','DTCOND','DCQ','DTV','ZMDT','ZMDQ',  ">> user_nl_cam
echo "                    'STEND_CLUBB','RVMTEND_CLUBB',			 ">> user_nl_cam
echo "			  'RCMTEND_CLUBB','RIMTEND_CLUBB','MPDT','MPDQ'		 ">> user_nl_cam
echo "fincl4            = 'PS','PSDRY','T','Q','Z3','U','V','OMEGA','PRECL','PRECC',     ">> user_nl_cam
echo "                    'CAPE','CLOUDFRAC_CLUBB','CONCLD','FREQSH','FREQZM',   ">> user_nl_cam
echo "                    'PBLH','SST','CLDTOT'                                   ">> user_nl_cam
echo "avgflag_pertape(1) = 'A'"                                        		   >> user_nl_cam
echo "avgflag_pertape(2) = 'I'"                                        		   >> user_nl_cam
echo "avgflag_pertape(3) = 'I'"                                                    >> user_nl_cam
echo "avgflag_pertape(4) = 'A'"                                                    >> user_nl_cam
echo "nhtfrq             = 0,-6,-6,0                                              ">> user_nl_cam
echo "mfilt		 = 1, 120, 120, 1    					  ">> user_nl_cam
## 0 = use GLL bassis, 1 = bi-linear
echo "interpolate_type = 1                                                        ">> user_nl_cam
echo "interpolate_output = .false.,.false.,.false.,.true."       		   >> user_nl_cam

## -- THESE MODS ARE ONLY SET-UP FOR src = physgrid_170901
## ppm limiter in vertical
##cp /glade/u/home/$USER/$src/usr_src/limit/prim_advection_mod.F90 /glade/scratch/$USER/$caze/SourceMods/src.cam/
##
## lcp_moist = .false.
##cp /glade/u/home/$USER/$src/usr_src/cp_cnst/dyn_comp.F90 /glade/scratch/$USER/$caze/SourceMods/src.cam/
## --

./case.setup
./case.build
./case.submit
