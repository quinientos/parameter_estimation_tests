#!/bin/bash
# run all *.m file in directory and redirect output to file with same name
fstr="\n\nCPU time: %S+%U sec\tMax. resident set size: %M KB\t Elapsed: %e sec."
#mfiles=$(ls seir*)
#mfiles=$(ls biohydrogenation*)
#mfiles=$(ls biohydrogenation* crauste* daisy_mamil* harmonic* hiv* lotka_volterra* seir* vanderpol*)
#mfiles=$(ls daisy_mamil4*)
#mfiles=$(ls lotka_volterra* seir* vanderpol*)
mfiles=$(ls daisy_mamil3*)

mkdir -p outputs
for file in ${mfiles[@]}; do
    echo "Running $file, output to outputs/${file%.m}.out"
    /usr/bin/time -f "$fstr" matlab -nodisplay -nosplash -nodesktop -r "run $file; exit" &>outputs/${file%.m}.out
    # break
done
