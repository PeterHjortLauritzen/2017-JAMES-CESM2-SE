set terminal eps color enhanced
set out "SYPD.eps"
se(x) = a*x**2+b*x+c
fit se(x) 'perf.dat' using 2:3 via a,b,c
homme(x) = aa*x**2+bb*x+cc
fit homme(x) 'perf.dat' using 2:4 via aa,bb,cc
#set size square
#set bmargin at screen 0.1
set font "Helvetica Bold,20"
set title "CAM6 Aqua-Planet (incl. I/O)" font ",20"
set grid
#set xlabel "#cores/1000" font ",16"
set xlabel "#nodes (36 processors per node)" font ",16"
set ylabel "SYPD [Simulated Years Per Day]" font ",16"
set xtics font ", 16"
set ytics font ", 16"
set key left Left reverse
#set xrange [0:5400]
set yrange [0:70]
#set xtics ("0" 0,"1" 1000,"2" 2000,"3" 3000,"4" 4000,"5" 5000,"6" 6000)
plot se(x) lw 4 notitle,homme(x) lw 4 notitle,'perf.dat' u 2:3 w p pt 7 lw 2 ps 1 title 'CAM-SE', 'perf.dat' u 2:4 w p pt 8 lw 2 ps 1 title 'CAM-HOMME'
