#!/bin/bash

FECHA=`date +%d%b%G`

LOG=$DIR_SHELLS/testigos.log

TESTIGO1=testigoConvF2.sem
TESTIGO2=testigoUVEM.sem
TESTIGO3=testigoCDD.sem
TESTIGO4=testigoLitios.sem
TESTIGO5=testigoUploadLitios.sem
TESTIGO6=testigoTDX.sem

cd $DIR_SHELLS

if [ -e $TESTIGO1 ] && [ -e $TESTIGO2 ] && [ -e $TESTIGO3 ] && [ -e $TESTIGO4 ] && [ -e $TESTIGO5 ] && [ -e $TESTIGO6 ]; then
	echo "Los ficheros Testigo $TESTIGO1, $TESTIGO2, $TESTIGO3, $TESTIGO4, $TESTIGO5, $TESTIGO6 [ EXISTEN ]" >> $LOG
        $DIR_SHELLS/enviaMailTestigos.sh >> $LOG
else
	echo "Los ficheros Testigo $TESTIGO1, $TESTIGO2, $TESTIGO3, $TESTIGO4, $TESTIGO5, $TESTIGO6 [ NO EXISTEN ]" >> $LOG
fi

