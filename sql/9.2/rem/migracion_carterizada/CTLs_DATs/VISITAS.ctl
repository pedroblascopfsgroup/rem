OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/VISITAS.dat'
BADFILE './CTLs_DATs/bad/VISITAS.bad'
DISCARDFILE './CTLs_DATs/rejects/VISITAS.bad'
INTO TABLE REM01.MIG2_VIS_VISITAS
TRUNCATE
TRAILING NULLCOLS
(
	VIS_COD_VISITA_WEBCOM				POSITION(1:19)		INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIS_COD_VISITA_WEBCOM),';',' '), '\"',''),'''',''),2,16))",
	VIS_COD_CLIENTE_WEBCOM				POSITION(20:36)		INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIS_COD_CLIENTE_WEBCOM),';',' '), '\"',''),'''',''),2,16))",
	VIS_ACT_NUMERO_ACTIVO				POSITION(37:53)		INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIS_ACT_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))",
	VIS_COD_ESTADO_VISITA				POSITION(54:73)		CHAR NULLIF(VIS_COD_ESTADO_VISITA=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:VIS_COD_ESTADO_VISITA),';',' '), '\"',''),'''','')",
	VIS_COD_SUBESTADO_VISISTA			POSITION(74:93)		CHAR NULLIF(VIS_COD_SUBESTADO_VISISTA=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:VIS_COD_SUBESTADO_VISISTA),';',' '), '\"',''),'''','')",
	VIS_COD_PROCEDENCIA					POSITION(94:113)	CHAR NULLIF(VIS_COD_PROCEDENCIA=BLANKS)								"REPLACE(REPLACE(REPLACE(TRIM(:VIS_COD_PROCEDENCIA),';',' '), '\"',''),'''','')",
	VIS_COD_SUBPROCEDENCIA				POSITION(114:133)	CHAR NULLIF(VIS_COD_SUBPROCEDENCIA=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:VIS_COD_SUBPROCEDENCIA),';',' '), '\"',''),'''','')",
	VIS_FECHA_SOLCITUD					POSITION(134:141)	DATE 'YYYYMMDD' NULLIF(VIS_FECHA_SOLCITUD=BLANKS)					"REPLACE(:VIS_FECHA_SOLCITUD, '00000000', '')",
	VIS_FECHA_CONCERTACION				POSITION(142:149)	DATE 'YYYYMMDD' NULLIF(VIS_FECHA_CONCERTACION=BLANKS)				"REPLACE(:VIS_FECHA_CONCERTACION, '00000000', '')",
	VIS_FECHA_REAL_VISITA				POSITION(150:157)	DATE 'YYYYMMDD' NULLIF(VIS_FECHA_REAL_VISITA=BLANKS)				"REPLACE(:VIS_FECHA_REAL_VISITA, '00000000', '')",
	VIS_COD_PRESCRIPTOR_UVEM			POSITION(158:207)	CHAR NULLIF(VIS_COD_PRESCRIPTOR_UVEM=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:VIS_COD_PRESCRIPTOR_UVEM),';',' '), '\"',''),'''','')",
	VIS_IND_VISITA_PRESCRIPTOR			POSITION(208:209)	INTEGER EXTERNAL NULLIF(VIS_IND_VISITA_PRESCRIPTOR=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIS_IND_VISITA_PRESCRIPTOR),';',' '), '\"',''),'''',''),2,1))",
	VIS_COD_API_RESPONSABLE_UVEM		POSITION(210:259)	CHAR NULLIF(VIS_COD_API_RESPONSABLE_UVEM=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:VIS_COD_API_RESPONSABLE_UVEM),';',' '), '\"',''),'''','')",
	VIS_IND_VISITA_API_RESPONSABLE		POSITION(260:261)	INTEGER EXTERNAL NULLIF(VIS_IND_VISITA_API_RESPONSABLE=BLANKS)		"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIS_IND_VISITA_API_RESPONSABLE),';',' '), '\"',''),'''',''),2,1))",
	VIS_COD_API_CUSTODIO_UVEM			POSITION(262:311)	CHAR NULLIF(VIS_COD_API_CUSTODIO_UVEM=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:VIS_COD_API_CUSTODIO_UVEM),';',' '), '\"',''),'''','')",
	VIS_IND_VISITA_API_CUSTODIO			POSITION(312:313)	INTEGER EXTERNAL NULLIF(VIS_IND_VISITA_API_CUSTODIO=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIS_IND_VISITA_API_CUSTODIO),';',' '), '\"',''),'''',''),2,1))",
	VIS_COD_FVD_UVEM					POSITION(314:363)	CHAR NULLIF(VIS_COD_FVD_UVEM=BLANKS)								"REPLACE(REPLACE(REPLACE(TRIM(:VIS_COD_FVD_UVEM),';',' '), '\"',''),'''','')",
	VIS_IND_VISITA_FVD					POSITION(364:365)	INTEGER EXTERNAL NULLIF(VIS_IND_VISITA_FVD=BLANKS)					"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:VIS_IND_VISITA_FVD),';',' '), '\"',''),'''',''),2,1))",
	VIS_OBSERVACIONES					POSITION(366:615)	CHAR NULLIF(VIS_OBSERVACIONES=BLANKS)								"REPLACE(REPLACE(REPLACE(TRIM(:VIS_OBSERVACIONES),';',' '), '\"',''),'''','')",
	VALIDACION CONSTANT "0"	

)
