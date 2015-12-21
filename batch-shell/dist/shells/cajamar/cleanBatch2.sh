#!/bin/bash

/recovery/batch-server/programas/stopBatch.sh
echo "*** Batch detenido"
/recovery/batch-server/programas/startBatch.sh
echo "*** Batch arrancado de nuevo"
