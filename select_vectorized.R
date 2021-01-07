suppressMessages(library(reshape2))
suppressMessages(library(data.table))
library(parallel)

args <- commandArgs()
subrows<-as.numeric(scan("subrows", what="character"))
file.to.read<-as.character(args[6])
multipl<-as.numeric(gsub(".txt", "", file.to.read))
totrows<-as.numeric(scan("totrows", what="character"))

a<-fread(file.to.read)
ncoltot=ncol(a)

#remove duplicates and self
#if (multipl!=0) a[,1:(multipl*subrows)]<-NA
#process in smaller sets to avoid stack overflow
if (multipl!=0) for (j in 0:(multipl-1)) a[,(1+(j*subrows)):(subrows + j*subrows)]<-NA
nr<-nrow(a)
tmp<-a[,(1+multipl*subrows):(nrow(a)+multipl*subrows)]
tmp[lower.tri(tmp, diag=T)]<-NA
a[,(1+multipl*subrows):(nrow(a)+multipl*subrows)]<-tmp

#dynamic threshold
total_edges<-choose(ncoltot,2)
current_edge_number<-sum(apply(a, 2, function(x)length(which(!is.na(x)))))
edges_to_get<-current_edge_number/total_edges*5000000
for (i in seq(50,5000, by=50)) {
  if(length(which(a<i))>edges_to_get) {break}
}
print(i)
select<-which(a<i, arr.ind=T)
select<-select[order(select[,1]),]
dim(select)
hrr<-vector(length=nrow(select))
rselect<-select[,1]
cselect<-select[,2]
for (i in as.numeric(names(table(select[,1])))) {
  sel<-select[,1]==i
  vec.col<-select[sel,2]
  hrr[sel]<-unlist(a[i,..vec.col])
}
select<-cbind(select, "hrr"=hrr)
select<-select[order(select[,3]),]
select[,1]<-select[,1]+multipl*subrows
fwrite(data.table(select), paste("selectedpairs_", multipl, sep=""), quote=F, row.names=F, col.names=F, sep="\t")
