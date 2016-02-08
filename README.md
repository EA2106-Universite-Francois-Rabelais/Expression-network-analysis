# Expression-network-analysis
This program written in C is designed to compute Pearson Correlation Coefficients (PCC) and/or Highest Reciprocal Ranks (HRR) on large transcript expression matrices. The input table should have the format n x p, with n corresponding to transcripts and p to samples. Provide table as a tab-delimited file; store transcript ids in the first column (without header) and sample names in the first row. 

##Installation

Untar and compile with mpich by typing "make" in the directory. Requires cBLAS and Lapack libraries.

##Usage


Command line example :

- rankmatrix, all results saved on node 0, doubleprecision

mpirun -np 4 ./hrr.exe file.dat rankmatrix doubleprecision

- rankmatrix, all results saved on node 0

mpirun -np 4 ./hrr.exe file.dat rankmatrix

- rankmatrix, all results saved on each node

mpirun -np 4 ./hrr.exe file.dat rankmatrix localsave

- pcc, all results saved on node 0

mpirun -np 4 ./hrr.exe file.dat pcc

- pcc, all results saved on each node

mpirun -np 4 ./hrr.exe file.dat pcc localsave

- weightedpcc, all results saved on node 0, default limit 0.4
