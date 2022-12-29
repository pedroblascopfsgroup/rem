OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_12965
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	   ELEMENTO_PEP		NULLIF(ELEMENTO_PEP=BLANKS)			"TRIM(:ELEMENTO_PEP)"
	  ,DESCRIPCION			NULLIF(DESCRIPCION=BLANKS)			"TRIM(:DESCRIPCION)"
	  ,VENTA			NULLIF(VENTA=BLANKS)				"TRIM(:VENTA)"
	  ,ALQUILER			NULLIF(ALQUILER=BLANKS)			"TRIM(:ALQUILER)"
	  ,ESTRUCTURA			NULLIF(ESTRUCTURA=BLANKS)			"TRIM(:ESTRUCTURA)"
	  ,DD_CBC_CODIGO		NULLIF(DD_CBC_CODIGO=BLANKS)			"TRIM(:DD_CBC_CODIGO)"
	  ,GRUPO			NULLIF(GRUPO=BLANKS)				"TRIM(:GRUPO)"
	  ,TIPO			NULLIF(TIPO=BLANKS)				"TRIM(:TIPO)"
	  ,SUBTIPO			NULLIF(SUBTIPO=BLANKS)				"TRIM(:SUBTIPO)"
	  ,COINCIDE_PEP_2022		NULLIF(COINCIDE_PEP_2022=BLANKS)		"TRIM(:COINCIDE_PEP_2022)"
	  ,TIPO_GASTO			NULLIF(TIPO_GASTO=BLANKS)			"TRIM(:TIPO_GASTO)"
	  ,SUBTIPO_GASTO		NULLIF(SUBTIPO_GASTO=BLANKS)			"TRIM(:SUBTIPO_GASTO)"
	  ,CARTERA			NULLIF(CARTERA=BLANKS)				"TRIM(:CARTERA)"

)

