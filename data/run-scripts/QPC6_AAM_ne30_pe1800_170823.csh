#!/bin/tcsh
setenv src "physgrid_170901"
setenv caze ${src}_QPC6_ne30_`date '+%y%m%d'`_AAM

/glade/u/home/aherring/$src/cime/scripts/create_newcase --case /glade/scratch/aherring/$caze --compset QPC6 --res ne30_ne30_mg16 --project P93300642 --q regular --walltime 04:00:00 --pecount 1800 --run-unsupported
cd /glade/scratch/aherring/$caze

./xmlchange STOP_OPTION=nyears,STOP_N=1
./xmlchange RESUBMIT=0
./xmlchange DOUT_S=FALSE
./xmlchange NTHRDS=1
./xmlchange ATM_NCPL=48

## timing detail
#./xmlchange TIMER_LEVEL=10

##history
echo "inithist 		= 'NONE'						 ">> user_nl_cam
echo "se_statefreq      = 144                                                    ">> user_nl_cam
echo "empty_htapes      = .true.                                                 ">> user_nl_cam
echo "fincl1            = 'MR_dED', 'MO_dED', 'MR_dAF', 'MO_dAF', 'MR_dBD', 	" >> user_nl_cam
echo "			  'MO_dBD', 'MR_dAD', 'MO_dAD', 'MR_dAR', 'MO_dAR',	" >> user_nl_cam
echo "			  'MR_dBF','MO_dBF', 'MR_dBH', 'MO_dBH', 'MR_dCH',	" >> user_nl_cam
echo "			  'MO_dCH', 'MR_dAH', 'MO_dAH'				" >> user_nl_cam
echo "fincl2            = 'MR_dED', 'MO_dED', 'MR_dAF', 'MO_dAF', 'MR_dBD',     " >> user_nl_cam
echo "                    'MO_dBD', 'MR_dAD', 'MO_dAD', 'MR_dAR', 'MO_dAR',     " >> user_nl_cam
echo "                    'MR_dBF','MO_dBF', 'MR_dBH', 'MO_dBH', 'MR_dCH',      " >> user_nl_cam
echo "                    'MO_dCH', 'MR_dAH', 'MO_dAH'                          " >> user_nl_cam
echo "avgflag_pertape(1) = 'A'"                                        		   >> user_nl_cam
echo "avgflag_pertape(2) = 'I'"                                        		   >> user_nl_cam
echo "nhtfrq             = 0,-24	                                          ">> user_nl_cam
echo "mfilt		 = 1, 30		  				  ">> user_nl_cam
echo "ndens		 = 1, 1							  ">> user_nl_cam
echo "interpolate_output = .false.,.false.		 		  	  ">> user_nl_cam

./case.setup
./case.build
./case.submit
