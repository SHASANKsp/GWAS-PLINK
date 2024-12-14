#script for Zmax test

#lib
library("mvtnorm")
library("Zmax")


#read block
cltm = read.table("genom_ctrl.gcount" ,header = TRUE)
casem = read.table("genom_case.gcount" ,header = TRUE) 
cltf = read.table("genof_ctrl.gcount" ,header = TRUE)
casef = read.table("genof_case.gcount" ,header = TRUE)

#merge block
#cltr
fi_ctlr = data.frame(ID=cltm$ID, REF=cltm$REF, ALT=cltm$ALT, F2=cltf$HOM_REF_CT, 
                     F1=cltf$HET_REF_ALT_CTS, F0=cltf$TWO_ALT_GENO_CTS,
                     M1=cltm$HAP_REF_CT, M0=cltm$HAP_ALT_CTS)

#case
fi_case = data.frame(ID=casem$ID, REF=casem$REF, ALT=casem$ALT, 
                     F2=casef$HOM_REF_CT, F1=casef$HET_REF_ALT_CTS, 
                     F0=casef$TWO_ALT_GENO_CTS, M1=casem$HAP_REF_CT, 
                     M0=casem$HAP_ALT_CTS)


#head(fi_case)
#head(fi_ctlr)

#test block
#?sprintf

n = length(casef$ID)
for (i in 1:n){
  test = rbind(c(fi_case$F2[i],fi_case$F1[i],fi_case$F0[i],fi_case$M1[i],
                 fi_case$M0[i]), c(fi_ctlr$F2[i],fi_ctlr$F1[i],
                                   fi_ctlr$F0[i],fi_ctlr$M1[i],fi_ctlr$M0[i]))
  
  result = Zmax(test, method = "norm") #norm or rmbs

  phr = sprintf("%d %s",casef$ID[i],result)
  write(gsub("[()]","",gsub("\\c","",gsub('"',"",gsub(",","",phr)))),file="Zmax_norm.txt",append = TRUE)
}








