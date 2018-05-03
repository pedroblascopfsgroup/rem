OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/TITULARES_ADICIONALES_OFERTA.dat'
BADFILE './CTLs_DATs/bad/TITULARES_ADICIONALES_OFERTA.bad'
DISCARDFILE './CTLs_DATs/rejects/TITULARES_ADICIONALES_OFERTA.bad'
INTO TABLE REM01.MIG2_OFR_TIA_TITULARES_ADI
TRUNCATE
TRAILING NULLCOLS
(	
	OFR_TIA_COD_OFERTA					POSITION(1:17)			INTEGER EXTERNAL												"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_TIA_COD_OFERTA),';',' '), '\"',''),'''',''),2,16))",
	OFR_TIA_NOMBRE						POSITION(18:273)		CHAR NULLIF(OFR_TIA_NOMBRE=BLANKS)								"REPLACE(REPLACE(REPLACE(TRIM(:OFR_TIA_NOMBRE),';',' '), '\"',''),'''','')",
	OFR_TIA_COD_TIPO_DOC_TITUL_ADI		POSITION(274:290)		INTEGER EXTERNAL NULLIF(OFR_TIA_COD_TIPO_DOC_TITUL_ADI=BLANKS)	"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFR_TIA_COD_TIPO_DOC_TITUL_ADI),';',' '), '\"',''),'''',''),2,16))",
	OFR_TIA_DOCUMENTO					POSITION(291:340)		CHAR NULLIF(OFR_TIA_DOCUMENTO=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:OFR_TIA_DOCUMENTO),';',' '), '\"',''),'''','')",
VALIDACION CONSTANT "0")
