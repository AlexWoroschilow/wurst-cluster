#!/bin/bash
ROOT=$(pwd)
R="${ROOT}/build/bin/Rscript"
INPUT="${ROOT}/var/aacid.ncol"
OUT="${ROOT}/out/aacid.clust"
${R} ${ROOT}/clustering.r ${INPUT} ${OUT}
