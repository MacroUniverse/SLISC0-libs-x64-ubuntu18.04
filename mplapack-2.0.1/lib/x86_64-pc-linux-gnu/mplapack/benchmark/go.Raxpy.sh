#!/bin/bash

if [ `uname` = "Darwin" ]; then
    LDPATHPREFIX="DYLD_LIBRARY_PATH=/home/docker/MPLAPACK/lib"
else
    LDPATHPREFIX="LD_LIBRARY_PATH=/home/docker/MPLAPACK/lib:$LD_LIBRARY_PATH"
fi

####
MPLIBS="_Float128 _Float64x dd double"

for _mplib in $MPLIBS; do
env $LDPATHPREFIX ./Raxpy.${_mplib}_opt -NOCHECK  >& log.Raxpy.${_mplib}_opt
env $LDPATHPREFIX ./Raxpy.${_mplib} -NOCHECK      >& log.Raxpy.${_mplib}
done
####

####
MPLIBS="mpfr gmp qd"

for _mplib in $MPLIBS; do
env $LDPATHPREFIX ./Raxpy.${_mplib}_opt -NOCHECK  >& log.Raxpy.${_mplib}_opt
env $LDPATHPREFIX ./Raxpy.${_mplib} -NOCHECK      >& log.Raxpy.${_mplib}
done
####

####
if [ `uname` = "Linux" ]; then
    MODELNAME=`lscpu | grep 'Model name' | uniq | awk '{for(i=3;i<=NF;i++) printf $i FS }'`
    SED=sed
elif [ `uname` = "Darwin" ]; then
    MODELNAME=`sysctl machdep.cpu.brand_string | awk '{for(i=2;i<=NF;i++) printf $i FS }'`
    SED=gsed
else
    MODELNAME="unknown"
fi

$SED -i -e "s/%%MODELNAME%%/$MODELNAME/g" Raxpy1.plt
$SED -i -e "s/%%MODELNAME%%/$MODELNAME/g" Raxpy2.plt
$SED -i -e "s/%%MODELNAME%%/$MODELNAME/g" Raxpy3.plt
####

gnuplot Raxpy1.plt > Raxpy1.pdf
gnuplot Raxpy2.plt > Raxpy2.pdf
gnuplot Raxpy3.plt > Raxpy3.pdf
