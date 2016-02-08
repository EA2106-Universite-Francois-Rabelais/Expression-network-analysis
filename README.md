# Expression-network-analysis

#Installation

Untar and compile with mpich by typing "make" in the directory. Requires cBLAS and Lapack libraries.

#Usage
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
