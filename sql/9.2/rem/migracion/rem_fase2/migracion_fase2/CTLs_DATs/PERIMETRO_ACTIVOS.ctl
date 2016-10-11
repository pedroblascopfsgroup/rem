OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/PERIMETRO_ACTIVOS.dat'
BADFILE './CTLs_DATs/bad/PERIMETRO_ACTIVOS.bad'
DISCARDFILE './CTLs_DATs/rejects/PERIMETRO_ACTIVOS.bad'
INTO TABLE REM01.MIG2_PAC_PERIMETRO_ACTIVO
TRUNCATE
TRAILING NULLCOLS
(
	PAC_NUMERO_ACTIVO						POSITION(1:17)			INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PAC_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))",
	PAC_IND_INCLUIDO						POSITION(18:19)			INTEGER EXTERNAL NULLIF(PAC_IND_INCLUIDO=BLANKS)					"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PAC_IND_INCLUIDO),';',' '), '\"',''),'''',''),2,1))",
	PAC_IND_CHECK_TRA_ADMISION				POSITION(20:21)			INTEGER EXTERNAL NULLIF(PAC_IND_CHECK_TRA_ADMISION=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PAC_IND_CHECK_TRA_ADMISION),';',' '), '\"',''),'''',''),2,1))",
	PAC_FECHA_TRA_ADMISION					POSITION(22:29)			DATE 'YYYYMMDD' NULLIF(PAC_FECHA_TRA_ADMISION=BLANKS)				"REPLACE(:PAC_FECHA_TRA_ADMISION, '00000000', '')",
	PAC_MOTIVO_TRA_ADMISION					POSITION(30:284)		CHAR NULLIF(PAC_MOTIVO_TRA_ADMISION=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:PAC_MOTIVO_TRA_ADMISION),';',' '), '\"',''),'''','')",
	PAC_IND_CHECK_GESTIONAR					POSITION(285:286)		INTEGER EXTERNAL NULLIF(PAC_IND_CHECK_GESTIONAR=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PAC_IND_CHECK_GESTIONAR),';',' '), '\"',''),'''',''),2,1))",
	PAC_FECHA_GESTIONAR						POSITION(287:294)		DATE 'YYYYMMDD' NULLIF(PAC_FECHA_GESTIONAR=BLANKS)					"REPLACE(:PAC_FECHA_GESTIONAR, '00000000', '')",
	PAC_MOTIVO_GESTIONAR					POSITION(295:549)		CHAR NULLIF(PAC_MOTIVO_GESTIONAR=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:PAC_MOTIVO_GESTIONAR),';',' '), '\"',''),'''','')",
	PAC_IND_CHECK_ASIG_MEDIA				POSITION(550:551)		INTEGER EXTERNAL NULLIF(PAC_IND_CHECK_ASIG_MEDIA=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PAC_IND_CHECK_ASIG_MEDIA),';',' '), '\"',''),'''',''),2,1))",
	PAC_FECHA_ASIGNAR_MEDIADOR				POSITION(552:559)		DATE 'YYYYMMDD' NULLIF(PAC_FECHA_ASIGNAR_MEDIADOR=BLANKS)			"REPLACE(:PAC_FECHA_ASIGNAR_MEDIADOR, '00000000', '')",
	PAC_MOTIVO_ASIGNAR_MEDIADOR				POSITION(560:814)		CHAR NULLIF(PAC_MOTIVO_ASIGNAR_MEDIADOR=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:PAC_MOTIVO_ASIGNAR_MEDIADOR),';',' '), '\"',''),'''','')",
	PAC_IND_CHECK_COMERCIALIZAR				POSITION(815:816)		INTEGER EXTERNAL NULLIF(PAC_IND_CHECK_COMERCIALIZAR=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PAC_IND_CHECK_COMERCIALIZAR),';',' '), '\"',''),'''',''),2,1))",
	PAC_FECHA_COMERCIALIZAR					POSITION(817:824)		DATE 'YYYYMMDD' NULLIF(PAC_FECHA_COMERCIALIZAR=BLANKS)				"REPLACE(:PAC_FECHA_COMERCIALIZAR, '00000000', '')",
	PAC_COD_MOTIVO_COMERCIAL				POSITION(825:844)		CHAR NULLIF(PAC_COD_MOTIVO_COMERCIAL=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:PAC_COD_MOTIVO_COMERCIAL),';',' '), '\"',''),'''','')",
	PAC_COD_MOTIVO_NOCOMERCIAL				POSITION(845:864)		CHAR NULLIF(PAC_COD_MOTIVO_NOCOMERCIAL=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:PAC_COD_MOTIVO_NOCOMERCIAL),';',' '), '\"',''),'''','')",
	PAC_IND_CHECK_FORMALIZAR				POSITION(865:866)		INTEGER EXTERNAL NULLIF(PAC_IND_CHECK_FORMALIZAR=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PAC_IND_CHECK_FORMALIZAR),';',' '), '\"',''),'''',''),2,1))",
	PAC_FECHA_FORMALIZAR					POSITION(867:874)		DATE 'YYYYMMDD' NULLIF(PAC_FECHA_FORMALIZAR=BLANKS)					"REPLACE(:PAC_FECHA_FORMALIZAR, '00000000', '')",
	PAC_MOTIVO_FORMALIZAR					POSITION(875:1129)		CHAR NULLIF(PAC_MOTIVO_FORMALIZAR=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:PAC_MOTIVO_FORMALIZAR),';',' '), '\"',''),'''','')"
)
