#!/bin/bash
# FIX: Bug de la versión que tenemos de Oracle. Problema con MERGE
# ORA-00600: internal error code, arguments: [kkmupsViewDestFro_4], [76107],[75624], [], [], [], [], [], [], [], [], []


for script in $(find $ws_package_dir -name DML_382_ENTITY01_DATJPB_MergeSCE_SCL_en_PER_PERSONAS*.sql); do
	echo sed -e 's/DD_SCL_ID NUEVO_DD_SCL_ID.*$/DD_SCL_ID NUEVO_DD_SCL_ID, ROWNUM/g' -i $script
	sed -e 's/DD_SCL_ID NUEVO_DD_SCL_ID.*$/DD_SCL_ID NUEVO_DD_SCL_ID, ROWNUM/g' -i $script
done

