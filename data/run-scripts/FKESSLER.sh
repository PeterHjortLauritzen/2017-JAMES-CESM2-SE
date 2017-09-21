#!/bin/tcsh
set res = "ne30_ne30_mg17"
set compset = "FKESSLER"
set compiler = "intel"
/home/$USER/src/physgrid/cime/scripts/create_newcase --case /scratch/cluster/$USER/${compset}_${res}_${compiler} --compset $compset --res $res --walltime 00:15:00 --q monster --pecount 384 --compiler $compiler --run-unsupported
cd /scratch/cluster/pel/${compset}_${res}_${compiler}
./xmlchange STOP_OPTION=ndays,STOP_N=15
./xmlchange DOUT_S=FALSE
./case.setup
echo "se_statefreq       = 144                      ">> user_nl_cam
echo "interpolate_output = .true.,.true.            ">> user_nl_cam
./case.build
./case.submit
