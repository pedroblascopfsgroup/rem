OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/TASACIONES_ACTIVO.dat'
BADFILE './CTLs_DATs/bad/TASACIONES_ACTIVO.bad'
DISCARDFILE './CTLs_DATs/rejects/TASACIONES_ACTIVO.bad'
INTO TABLE REM01.MIG_ATA_TASACIONES_ACTIVO_BNK
TRUNCATE
TRAILING NULLCOLS
(
	ACT_NUMERO_ACTIVO						POSITION(1:17)			INTEGER EXTERNAL 													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACT_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))",
	TAS_CODIGO_TASA_UVEM					POSITION(18:34)			INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:TAS_CODIGO_TASA_UVEM),';',' '), '\"',''),'''',''),2,16))",
	TAS_TIPO_TASACION						POSITION(35:54)			CHAR NULLIF(TAS_TIPO_TASACION=BLANKS) 								"REPLACE(REPLACE(REPLACE(TRIM(:TAS_TIPO_TASACION),';',' '), '\"',''),'''','')",
	TAS_FECHA_INI_TASACION					POSITION(55:62)			DATE 'YYYYMMDD' NULLIF(TAS_FECHA_INI_TASACION=BLANKS) 				"REPLACE(:TAS_FECHA_INI_TASACION, '00000000', '')",
	TAS_FECHA_FIN_TASACION					POSITION(63:70)			DATE 'YYYYMMDD' NULLIF(TAS_FECHA_FIN_TASACION=BLANKS) 				"REPLACE(:TAS_FECHA_FIN_TASACION, '00000000', '')",
	TAS_F_SOL_TASACION						POSITION(71:78)			DATE 'YYYYMMDD' NULLIF(TAS_F_SOL_TASACION=BLANKS) 					"REPLACE(:TAS_F_SOL_TASACION, '00000000', '')",
	TAS_IMPORTE_VALOR_TASACION				POSITION(79:95)			INTEGER EXTERNAL NULLIF(TAS_IMPORTE_VALOR_TASACION=BLANKS) 			"CASE WHEN (:TAS_IMPORTE_VALOR_TASACION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_IMPORTE_VALOR_TASACION,1,15)||','||SUBSTR(:TAS_IMPORTE_VALOR_TASACION,16,2)),';',' '), '\"',''),'''','')) END",		
	TAS_FECHA_RECEPCION_TASACION			POSITION(96:103)		DATE 'YYYYMMDD' NULLIF(TAS_FECHA_RECEPCION_TASACION=BLANKS) 		"REPLACE(:TAS_FECHA_RECEPCION_TASACION, '00000000', '')",		
	TAS_CODIGO_FIRMA						POSITION(104:120)		INTEGER EXTERNAL NULLIF(TAS_CODIGO_FIRMA=BLANKS) 					"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:TAS_CODIGO_FIRMA),';',' '), '\"',''),'''',''),2,16))",
	TAS_NOMBRE_TASADOR						POSITION(121:220)		CHAR NULLIF(TAS_NOMBRE_TASADOR=BLANKS) 								"REPLACE(REPLACE(REPLACE(TRIM(:TAS_NOMBRE_TASADOR),';',' '), '\"',''),'''','')",		
	TAS_IMPORTE_TAS_FIN						POSITION(221:237)		INTEGER EXTERNAL NULLIF(TAS_IMPORTE_TAS_FIN=BLANKS) 				"CASE WHEN (:TAS_IMPORTE_TAS_FIN) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_IMPORTE_TAS_FIN,1,15)||','||SUBSTR(:TAS_IMPORTE_TAS_FIN,16,2)),';',' '), '\"',''),'''','')) END",		
	TAS_COSTE_REPO_NETO_ACTUAL				POSITION(238:254)		INTEGER EXTERNAL NULLIF(TAS_COSTE_REPO_NETO_ACTUAL=BLANKS) 			"CASE WHEN (:TAS_COSTE_REPO_NETO_ACTUAL) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_COSTE_REPO_NETO_ACTUAL,1,15)||','||SUBSTR(:TAS_COSTE_REPO_NETO_ACTUAL,16,2)),';',' '), '\"',''),'''','')) END",		
	TAS_COSTE_REPO_NETO_FINALIZADO			POSITION(255:271)		INTEGER EXTERNAL NULLIF(TAS_COSTE_REPO_NETO_FINALIZADO=BLANKS) 		"CASE WHEN (:TAS_COSTE_REPO_NETO_FINALIZADO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_COSTE_REPO_NETO_FINALIZADO,1,15)||','||SUBSTR(:TAS_COSTE_REPO_NETO_FINALIZADO,16,2)),';',' '), '\"',''),'''','')) END",	
	TAS_COEF_MERCADO_ESTADO					POSITION(272:288)		INTEGER EXTERNAL NULLIF(TAS_COEF_MERCADO_ESTADO=BLANKS) 			"CASE WHEN (:TAS_COEF_MERCADO_ESTADO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_COEF_MERCADO_ESTADO,1,15)||','||SUBSTR(:TAS_COEF_MERCADO_ESTADO,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_COEF_MERCADO_ESTADO_HOMO			POSITION(289:305)		INTEGER EXTERNAL NULLIF(TAS_COEF_MERCADO_ESTADO_HOMO=BLANKS) 		"CASE WHEN (:TAS_COEF_MERCADO_ESTADO_HOMO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_COEF_MERCADO_ESTADO_HOMO,1,15)||','||SUBSTR(:TAS_COEF_MERCADO_ESTADO_HOMO,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_COEF_POND_VALOR_ANYADIDO			POSITION(306:322)		INTEGER EXTERNAL NULLIF(TAS_COEF_POND_VALOR_ANYADIDO=BLANKS) 		"CASE WHEN (:TAS_COEF_POND_VALOR_ANYADIDO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_COEF_POND_VALOR_ANYADIDO,1,15)||','||SUBSTR(:TAS_COEF_POND_VALOR_ANYADIDO,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_VALOR_REPER_SUELO_CONST				POSITION(323:339)		INTEGER EXTERNAL NULLIF(TAS_VALOR_REPER_SUELO_CONST=BLANKS) 		"CASE WHEN (:TAS_VALOR_REPER_SUELO_CONST) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_VALOR_REPER_SUELO_CONST,1,15)||','||SUBSTR(:TAS_VALOR_REPER_SUELO_CONST,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_COSTE_CONST_CONST					POSITION(340:356)		INTEGER EXTERNAL NULLIF(TAS_COSTE_CONST_CONST=BLANKS) 				"CASE WHEN (:TAS_COSTE_CONST_CONST) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_COSTE_CONST_CONST,1,15)||','||SUBSTR(:TAS_COSTE_CONST_CONST,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_INDICE_DEPRE_FISICA					POSITION(357:373)		INTEGER EXTERNAL NULLIF(TAS_INDICE_DEPRE_FISICA=BLANKS) 			"CASE WHEN (:TAS_INDICE_DEPRE_FISICA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_INDICE_DEPRE_FISICA,1,15)||','||SUBSTR(:TAS_INDICE_DEPRE_FISICA,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_INDICE_DEPRE_FUNCIONAL				POSITION(374:390)		INTEGER EXTERNAL NULLIF(TAS_INDICE_DEPRE_FUNCIONAL=BLANKS) 			"CASE WHEN (:TAS_INDICE_DEPRE_FUNCIONAL) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_INDICE_DEPRE_FUNCIONAL,1,15)||','||SUBSTR(:TAS_INDICE_DEPRE_FUNCIONAL,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_INDICE_TOTAL_DEPRE					POSITION(391:407)		INTEGER EXTERNAL NULLIF(TAS_INDICE_TOTAL_DEPRE=BLANKS) 				"CASE WHEN (:TAS_INDICE_TOTAL_DEPRE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_INDICE_TOTAL_DEPRE,1,15)||','||SUBSTR(:TAS_INDICE_TOTAL_DEPRE,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_COSTE_CONST_DEPRE					POSITION(408:424)		INTEGER EXTERNAL NULLIF(TAS_COSTE_CONST_DEPRE=BLANKS) 				"CASE WHEN (:TAS_COSTE_CONST_DEPRE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_COSTE_CONST_DEPRE,1,15)||','||SUBSTR(:TAS_COSTE_CONST_DEPRE,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_COSTE_UNI_REPO_NETO					POSITION(425:441)		INTEGER EXTERNAL NULLIF(TAS_COSTE_UNI_REPO_NETO=BLANKS) 			"CASE WHEN (:TAS_COSTE_UNI_REPO_NETO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_COSTE_UNI_REPO_NETO,1,15)||','||SUBSTR(:TAS_COSTE_UNI_REPO_NETO,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_COSTE_REPOSICION					POSITION(442:458)		INTEGER EXTERNAL NULLIF(TAS_COSTE_REPOSICION=BLANKS) 				"CASE WHEN (:TAS_COSTE_REPOSICION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_COSTE_REPOSICION,1,15)||','||SUBSTR(:TAS_COSTE_REPOSICION,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_PORCENTAJE_OBRA						POSITION(459:464)		INTEGER EXTERNAL NULLIF(TAS_PORCENTAJE_OBRA=BLANKS) 				"CASE WHEN (:TAS_PORCENTAJE_OBRA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_PORCENTAJE_OBRA,2,3)||','||SUBSTR(:TAS_PORCENTAJE_OBRA,5,2)),';',' '), '\"',''),'''','')) END",
	TAS_IMPORTE_VALOR_TER					POSITION(465:481)		INTEGER EXTERNAL NULLIF(TAS_IMPORTE_VALOR_TER=BLANKS) 				"CASE WHEN (:TAS_IMPORTE_VALOR_TER) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_IMPORTE_VALOR_TER,1,15)||','||SUBSTR(:TAS_IMPORTE_VALOR_TER,16,2)),';',' '), '\"',''),'''','')) END",	
	TAS_ID_TEXTO_ASOCIADO					POSITION(482:498)		INTEGER EXTERNAL NULLIF(TAS_ID_TEXTO_ASOCIADO=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:TAS_ID_TEXTO_ASOCIADO),';',' '), '\"',''),'''',''),2,16))",
	TAS_IMPORTE_VAL_LEGAL_FINCA				POSITION(499:515)		INTEGER EXTERNAL NULLIF(TAS_IMPORTE_VAL_LEGAL_FINCA=BLANKS) 		"CASE WHEN (:TAS_IMPORTE_VAL_LEGAL_FINCA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_IMPORTE_VAL_LEGAL_FINCA,1,15)||','||SUBSTR(:TAS_IMPORTE_VAL_LEGAL_FINCA,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_IMPORTE_VAL_SOLAR					POSITION(516:532)		INTEGER EXTERNAL NULLIF(TAS_IMPORTE_VAL_SOLAR=BLANKS) 				"CASE WHEN (:TAS_IMPORTE_VAL_SOLAR) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_IMPORTE_VAL_SOLAR,1,15)||','||SUBSTR(:TAS_IMPORTE_VAL_SOLAR,16,2)),';',' '), '\"',''),'''','')) END",
	TAS_OBSERVACIONES						POSITION(533:1044)		CHAR NULLIF(TAS_OBSERVACIONES=BLANKS) 								"REPLACE(REPLACE(REPLACE(TRIM(:TAS_OBSERVACIONES),';',' '), '\"',''),'''','')",
	TAS_VALOR_VENTA_RAPIDA					POSITION(1045:1061)		INTEGER EXTERNAL NULLIF(TAS_VALOR_VENTA_RAPIDA=BLANKS) 				"CASE WHEN (:TAS_VALOR_VENTA_RAPIDA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:TAS_VALOR_VENTA_RAPIDA,1,15)||','||SUBSTR(:TAS_VALOR_VENTA_RAPIDA,16,2)),';',' '), '\"',''),'''','')) END"
)
