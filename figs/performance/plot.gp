set terminal eps color enhanced
set out "perf.eps"
f(x) = a*x**2+b*x+c
fit f(x) 'perf.dat' using 2:3 via a,b,c
set size square
set font "Helvetica Bold,20"
set title "CAM6-SE Aqua-Planet (incl. I/O)" font ",20"
set grid
#set xlabel "#cores/1000" font ",16"
set xlabel "#nodes (36 processors per node)" font ",16"
set ylabel "SYPD [Simulated Years Per Day]" font ",16"
set xtics font ", 16"
set ytics font ", 16"
set nokey
#set xrange [0:5400]
set yrange [0:60]
#set xtics ("0" 0,"1" 1000,"2" 2000,"3" 3000,"4" 4000,"5" 5000,"6" 6000)
plot f(x) lw 2,'perf.dat' u 2:3 w p pt 7 lw 2 ps 1