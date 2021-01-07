#!/bin/bash
usage(){
    echo "HRR calculation pipeline"
    echo ""
    echo "Usage: ./hrr_pipeline.sh "
    echo " expression table (tab delimited)"
    echo " number of cpus "
    echo " hrr executable"
    echo ""
    echo "Example:"
    echo "./hrr_pipeline.sh matrix 8 /usr/bin/hrr"
    echo ""
    echo "The select_vectorized.R script must be in the working directory"
}

operation(){
echo Processing table $1
cut -f1 $1 | tail -n +2 >rn.tmp
mpirun -np $2 $3 $1 rankmatrix doubleprecision alternateranking
cut -f1 -d" " 0.txt | wc -l >subrows
head -n 1 0.txt  | tr ' ' '\n' |wc -l >totrows
for i in $(ls *txt); do Rscript select_vectorized.R $i; done
rm *.txt
for i in $(ls selectedpairs_*); do mv $i $1.$i; done
}

if [  $# -le 2 ]
then
	usage
	exit 1
else
	operation $1 $2 $3
fi
