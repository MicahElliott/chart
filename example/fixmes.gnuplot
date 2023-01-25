set datafile separator '\t'
set xdata time
set timefmt "%Y-%m-%d"
set key autotitle columnhead
set ylabel "Occurences"
set xlabel 'Week Of'

# set y2tics # enable second axis
set ytics nomirror # dont show the tics on that side

set terminal png size 800,400
set output 'fixmes.png'
plot './fixmes.tsv'  using 1:2 with lines, '' using 1:3 with lines, '' using 1:4 with lines
