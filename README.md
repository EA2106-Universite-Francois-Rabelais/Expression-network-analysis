# Expression-network-analysis
This pipeline first uses a program written in C designed to compute Pearson Correlation Coefficients (PCC) and/or Highest Reciprocal Ranks (HRR) on large transcript expression matrices. It relies on mpich to efficiently parallelize computations.
The input table (eg, file.dat) should have the format n x p, with n corresponding to transcripts and p to samples. Provide table as a tab-delimited file; store transcript ids in the first column (without header) and sample names in the first row. 

Be sure that your file.dat is a tab-delimited file. 
You may run the following Perl one-liner to replace spaces by tabulations:
```
perl -pe 's/ /\t/g' file.dat >file.dat.ok
```
	
Alternatively, if the expression matrix is generated in R, please use the following command:

```
#Replace with the correct object and output names
write.table(expressionmatrix, "expressionmatrix.dat", sep="\t", quote=F)
```

## Installation

Untar 'hrr.tgz' and compile with mpich by typing 'make' in the directory. Requires cBLAS and Lapack libraries, as well as mpicc (in mpich or openmpi).

## Usage
```
HRR calculation pipeline

Usage: ./hrr_pipeline.sh \
 expression table \
 number of cpus \
 hrr executable \

Example:
./hrr_pipeline.sh matrix 8 /usr/bin/hrr
```

## What it does?
The bash script contains command to 

	1. compute all pairwise HRR in a parallelized manner
	2. extract gene names for further renaming in R
	3. extract the best pairs

The best pairs can then be loaded in R to construct the network, as described below:

```
library(data.table)
library(igraph)
#for a network containing the 1e+06 best pairs
threshold=1e+06

list.pairs<-list.files(pattern="selected", full.names = T)
pairs.table<-rbindlist(lapply(list.pairs, fread))
pairs.table<-pairs.table[order(pairs.table[,V3]),]
colnames(pairs.table)<-c("from", "to", "hrr")
rn<-scan("rn.tmp", what="character")

print("Get best pairs")
pairs.table.best<-pairs.table[1:threshold,]
rn.combi<-pairs.table.best
rn.combi$from<-rn[rn.combi$from]
rn.combi$to<-rn[rn.combi$to]
rm(pairs.table)
g<-simplify(graph_from_data_frame(rn.combi, directed=F))
#This is the network

``` 
 
## Example

You may download a full Arabidopsis expression matrix @http://bbv-ea2106.sciences.univ-tours.fr/index.php/web-links/36-transcriptomic-resources and use the pipeline to generate HRR or PCC files.
