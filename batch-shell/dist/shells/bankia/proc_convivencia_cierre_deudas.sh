#!/bin/bash
# Generado manualmente
 
SERVER=10.64.132.59
USER=ftpsocpart
PASSW=tempo.99
PORT=2153
DIR_LOCAL=/mnt/fs_servicios/recovecb/transferencia/aprov_convivencia/salida
DIR_DESTINO=/mnt/fs_servicios/socpart/SGPAR/RecoveryHaya/in/aprovisionamiento/troncal/ 
DIR_BASE_ETL=/aplicaciones/recovecb/programas/etl


	ftp -vn $SERVER <<END_OF_SESSION
        user $USER $PASSW
        lcd $DIR_LOCAL
        cd $DIR_DESTINO
        bin
    	get conv_ccdd_cuentas_demand_haya.dat
        get conv_ccdd_cuentas_grnt_bien_haya.dat
        get conv_ccdd_cuentas_rel_proc_haya.dat
	get conv_ccdd_datos_bienes_prc_haya.dat
	get conv_ccdd_instr_letr_pr_lot_haya.dat
	get conv_ccdd_lote_activ_proc_haya.dat
	get conv_ccdd_per_bien_propuest_haya.dat
	get conv_ccdd_pers_proc_acuerdo_haya.dat
	get conv_ccdd_procedimientos_haya.dat
	get conv_ccdd_res_comit_pr_lot_haya.dat	
        bye
END_OF_SESSION

	filename=$(basename $0)
	nameETL="${filename%.*}"

	export DIR_ETL=$DIR_BASE_ETL/$nameETL
	export DIR_CONFIG=$DIR_BASE_ETL/config/
	export CFG_FILE=config.ini
	export MAINSH="$nameETL"_run.sh
	
	cd "$DIR_ETL" &> null
	if [ $? = 1 ] ; then
	   echo "$(basename $0) Error en $filename: directorio inexistente $DIR_ETL"
	   exit 1
	fi
	
	ROOT_PATH=`pwd`
	
	if [ -f $MAINSH ]; then
	    CLASS="$(cat $MAINSH | grep "^ java" | cut -f10 -d" ")"
        CLASS2=`echo $CLASS | sed -e 's/$ROOT_PATH/./g'`
	    CLASEINICIO="$(cat $MAINSH | grep "^ java" | cut -f11 -d" ")"
	    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE  -Duser.country=ES -Duser.language=es -cp $CLASS2 $CLASEINICIO --context=Default "$@"
	    	
		if [ $? = 0 ] ; then
			cat conv_ccdd_cuentas_demand* > conv_ccdd_cuentas_demand.dat
                        cat conv_ccdd_cuentas_grnt_bien* > conv_ccdd_cuentas_grnt_bien.dat
			cat conv_ccdd_cuentas_rel_proc* > conv_ccdd_cuentas_rel_proc.dat
			cat conv_ccdd_datos_bienes_prc* > conv_ccdd_datos_bienes_prc.dat
			cat conv_ccdd_instr_letr_pr_lot* > conv_ccdd_instr_letr_pr_lot.dat
			cat conv_ccdd_lote_activ_proc* > conv_ccdd_lote_activ_proc.dat
			cat conv_ccdd_per_bien_propuest* > conv_ccdd_per_bien_propuest.dat
			cat conv_ccdd_pers_proc_acuerdo* > conv_ccdd_pers_proc_acuerdo.dat
			cat conv_ccdd_procedimientos* > conv_ccdd_procedimientos.dat
			cat conv_ccdd_res_comit_pr_lot* > conv_ccdd_res_comit_pr_lot.dat		
			rm conv_ccdd_cuentas_demand_haya.dat
			rm conv_ccdd_cuentas_grnt_bien_haya.dat
			rm conv_ccdd_cuentas_rel_proc_haya.dat
			rm conv_ccdd_datos_bienes_prc_haya.dat
			rm conv_ccdd_instr_letr_pr_lot_haya.dat
			rm conv_ccdd_lote_activ_proc_haya.dat
			rm conv_ccdd_per_bien_propuest_haya.dat
			rm conv_ccdd_pers_proc_acuerdo_haya.dat
			rm conv_ccdd_procedimientos_haya.dat
			rm conv_ccdd_res_comit_pr_lot_haya.dat	
		else
			echo "$(basename $0) Error en $filename: error en el ETL"
			exit 1
		fi
	else
	    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
	    exit 1
	fi
