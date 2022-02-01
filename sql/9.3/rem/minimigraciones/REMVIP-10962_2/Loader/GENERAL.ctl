OPTIONS (DIRECT=TRUE, BINDSIZE=1024000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_10962_DIVARIAN
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	CPP			NULLIF(CPP=BLANKS)		"TRIM(:CPP)",
	NOMBRE			NULLIF(NOMBRE=BLANKS)		"TRIM(:NOMBRE)",
	TIPO_GASTO 		NULLIF(TIPO_GASTO=BLANKS)	"TRIM(:TIPO_GASTO)",
	SUBTIPO_GASTO		NULLIF(SUBTIPO_GASTO=BLANKS)	"TRIM(:SUBTIPO_GASTO)",
	CCC			NULLIF(CCC=BLANKS)		"TRIM(:CCC)",
	AREA_RESP		NULLIF(AREA_RESP=BLANKS)	"TRIM(:AREA_RESP)",
	RESP			NULLIF(RESP=BLANKS)		"TRIM(:RESP)"


)

