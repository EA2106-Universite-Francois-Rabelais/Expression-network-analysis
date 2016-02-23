#!/usr/bin/env Rscript
library(optparse)
library(parallel)

option_list = list(make_option(c("-n", "--files"), type="integer", default=NULL, help="Number of .txt files (equal to number of cpus used in hrr)", metavar="integer"),
		   make_option(c("-a", "--accession"), type="character", default=NULL, help="File containing transcript names", metavar="character"),
		   make_option(c("-s", "--size"), type="integer", default=NULL, help="Number of rows in the processed matrix (not REAL size), see hrr standard output", metavar="integer"),
		   make_option(c("-S", "--realsize"), type="integer", default=NULL, help="Number of rows in the matrix (REAL size), see hrr standard output", metavar="integer"),
		   make_option(c("-c", "--subsize"), type="integer", default=NULL, help="Number of row in the submatrix, see hrr standard output", metavar="integer"),
		   make_option(c("-r", "--corr"), type="character", default=NULL, help="PCC or HRR", metavar="character"),
		   make_option(c("-m", "--mcores"), type="integer", default=NULL, help="Number of CPUs to use; relies on 'Parallel' R package", metavar="integer"))
		   
 
opt_parser<-OptionParser(option_list=option_list)
opt<-parse_args(opt_parser)

if (is.null(opt$files)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

cpus.ok<-opt$files-1
acc.files<-paste(0:cpus.ok, ".txt", sep="")
ids<-scan(opt$accession, what="character")
to.add<-opt$size-opt$realsize
if (length(to.add!=0)) {
	annot<-c(ids, rep(ids[length(ids)], to.add))} else {
	annot<-ids}

paquets.names<-seq(1, length(annot), opt$subsize)
paquets.names<-c(paquets.names, length(annot)+1)


mclapply(1:length(acc.files), function(y){
        a<-scan(acc.files[y], what="character")
        acc.names<-annot[paquets.names[y]:(paquets.names[y+1]-1)]
        paquets<-seq(1,length(a), opt$size)
        paquets<-c(paquets, length(a)+1)
        lapply(1:(length(paquets)-1), function(x){
                  file.name.tmp<-paste(as.vector(acc.names[x]), sep="")
                  table.tmp<-cbind.data.frame("lt"=annot, "corr"=as.numeric(a[paquets[x]:(paquets[(x+1)]-1)]))
                  write.table(table.tmp, file.name.tmp)})
        }, mc.cores=opt$mcores)
~                                   
