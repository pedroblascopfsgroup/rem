OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE MIG_EXPEDIENTES_OPERACIONES
TRUNCATE 
TRAILING NULLCOLS
(
		 MIG_EXP_OPE_ID 				SEQUENCE
		,CD_EXPEDIENTE  				POSITION(1:17)     INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:CD_EXPEDIENTE),'+',''),16,'0'))" 
		,COD_ENTIDAD    				POSITION(18:22)    INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:COD_ENTIDAD),'+',''),4,'0'))" 
		,COD_PROPIETARIO				POSITION(23:28)    INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:COD_PROPIETARIO),'+',''),5,'0'))" 
		,TIPO_PRODUCTO         			POSITION(29:33)    CHAR "replace (replace(replace(TRIM(:TIPO_PRODUCTO),';',' '), '\"',''),'''','')"
		,NUMERO_CONTRATO        	 	POSITION(34:51)    INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:NUMERO_CONTRATO),'+',''),17,'0'))"
		,NUMERO_ESPEC    				POSITION(52:67)    INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:NUMERO_ESPEC),'+',''),15,'0'))"
		,TIPO_RELACION					POSITION(68:87)    CHAR "replace (replace(replace(TRIM(:TIPO_RELACION),';',' '), '\"',''),'''','')"
)