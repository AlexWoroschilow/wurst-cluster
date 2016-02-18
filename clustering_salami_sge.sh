#!/bin/bash
#0pe openmpi_pe 4
ROOT=$(pwd)
qsub -S /bin/bash -wd ${ROOT} -q "8c.q,16c.q,32c.q" ${ROOT}/clustering_salami.sh
