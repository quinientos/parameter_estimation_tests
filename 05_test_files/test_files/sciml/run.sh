#!/bin/bash
# run the specified file in directory and redirect output to file with same name
fstr="\n\nCPU time: %S+%U sec\tMax. resident set size: %M KB\t Elapsed: %e sec."
testfiles=$(ls biohydrogenation* crauste* daisy_mamil* harmonic* hiv* lotka_volterra* seir* vanderpol*)
#testfiles=$(ls daisy_mamil* lotka_volterra*)
mkdir -p outputs
for file in ${testfiles[@]}; do
    echo "Running $file, output to outputs/${file%.jl}.out"
    /usr/bin/time -f "$fstr" julia $file &>outputs/${file%.jl}.out
    # break
done
