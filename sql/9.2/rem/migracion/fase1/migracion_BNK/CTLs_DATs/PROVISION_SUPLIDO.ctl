OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/PROVISION_SUPLIDO.dat'
BADFILE './CTLs_DATs/bad/PROVISION_SUPLIDO.bad'
DISCARDFILE './CTLs_DATs/rejects/PROVISION_SUPLIDO.bad'
INTO TABLE REM01.MIG_APS_PROVISION_SUPLIDO_BNK
TRUNCATE
TRAILING NULLCOLS
(
	TBJ_NUM_TRABAJO				POSITION(1:17)			INTEGER EXTERNAL NULLIF(TBJ_NUM_TRABAJO=BLANKS) 				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:TBJ_NUM_TRABAJO),';',' '), '\"',''),'''',''),2,16))",
	TIPO_ADELANTO				POSITION(18:37)			CHAR NULLIF(TIPO_ADELANTO=BLANKS) 								"REPLACE(REPLACE(REPLACE(TRIM(:TIPO_ADELANTO ),';',' '), '\"',''),'''','')",
	PSU_CONCEPTO				POSITION(38:287)		CHAR NULLIF(PSU_CONCEPTO=BLANKS) 								"REPLACE(REPLACE(REPLACE(TRIM(:PSU_CONCEPTO),';',' '), '\"',''),'''','')",
	PSU_IMPORTE					POSITION(288:304)		INTEGER EXTERNAL NULLIF(PSU_IMPORTE=BLANKS) 					"CASE WHEN (:PSU_IMPORTE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:PSU_IMPORTE,1,15)||','||SUBSTR(:PSU_IMPORTE,16,2)),';',' '), '\"',''),'''','')) END",
	PSU_FECHA					POSITION(305:312)		DATE 'YYYYMMDD' NULLIF(PSU_FECHA=BLANKS) 						"REPLACE(:PSU_FECHA, '00000000', '')"
)
