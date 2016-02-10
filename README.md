# Expression-network-analysis
This pipeline first uses a program written in C designed to compute Pearson Correlation Coefficients (PCC) and/or Highest Reciprocal Ranks (HRR) on large transcript expression matrices. It relies on mpich to efficiently parallelize computations.
The input table (eg, file.dat) should have the format n x p, with n corresponding to transcripts and p to samples. Provide table as a tab-delimited file; store transcript ids in the first column (without header) and sample names in the first row. 

        Be sure that your file.dat is a tab-delimited file. 
        You may run the following Perl one-liner to replace spaces by tabulations:
        perl -pe 's/ /\t/g' file.dat >file.dat.ok


The resulting vectors are next cut into n files by a simple multithreaded R script.

##Installation

Untar 'hrr.tgz' and compile with mpich by typing 'make' in the directory. Requires cBLAS and Lapack libraries.

##Usage

Command line example :

- rankmatrix, all results saved on node 0, doubleprecision

        mpirun -np 4 hrr file.dat rankmatrix doubleprecision

- rankmatrix, all results saved on node 0

        mpirun -np 4 hrr file.dat rankmatrix

- rankmatrix, all results saved on each node

        mpirun -np 4 hrr file.dat rankmatrix localsave

- pcc, all results saved on node 0

        mpirun -np 4 hrr file.dat pcc

- pcc, all results saved on each node

        mpirun -np 4 hrr file.dat pcc localsave



##Values
The program returns np text files (named 0.txt to (np-1).txt) corresponding to concatenated vectors of PCC or HRR values.

##Process .txt files resulting from hrr
First, create a PCC_lt or HRR_lt directory and use the R script HRR_cut.R as following in the directory containing .txt files (it should contain only those .txt files).


        Rscript --vanilla HRR_cut.R

        Usage: HRR_cut.R [options]
        
        
          Options:
          	-n INTEGER, --files=INTEGER
          		Number of .txt files (equal to number of cpus used in hrr)
          
          	-a CHARACTER, --accession=CHARACTER
          		File containing transcript names
          
          	-s INTEGER, --size=INTEGER
          		Number of rows in the processed matrix (not REAL size), see hrr standard output
          
          	-S INTEGER, --realsize=INTEGER
          		Number of rows in the matrix (REAL size), see hrr standard output
          
          	-c INTEGER, --subsize=INTEGER
          		Number of row in the submatrix, see hrr standard output
          
          	-r CHARACTER, --corr=CHARACTER
          		PCC or HRR
          
          	-m INTEGER, --mcores=INTEGER
          		Number of CPUs to use; relies on 'Parallel' R package
          
          	-h, --help
          		Show this help message and exit
          
  
  
##Example

You may download a full Arabidopsis expression matrix @http://bbv-ea2106.sciences.univ-tours.fr/index.php/web-links/36-transcriptomic-resources and use the pipeline to generate HRR or PCC files.
