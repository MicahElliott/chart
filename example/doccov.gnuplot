set datafile separator '\t'
set xdata time
set timefmt "%Y-%m-%d"
set key autotitle columnhead
set ylabel "Number of Functions"
set xlabel 'Week Of'

set y2tics # enable second axis
set ytics nomirror # dont show the tics on that side
set y2label "Percent of Docstring Coverage" # label for second axis

set terminal png size 800,400
set output 'doccov.png'
plot './doccov.tsv' using 1:2 with lines, '' using 1:3 with lines, '' using 1:4 with lines axis x1y2 # new plot command
