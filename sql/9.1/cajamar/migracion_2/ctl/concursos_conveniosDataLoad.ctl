OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE CM01.MIG_CONCURSOS_CONVENIOS 
TRUNCATE 
TRAILING NULLCOLS
(
   ID_CONCURSO_CONVENIO   			SEQUENCE
  ,CD_CONVENIO           			POSITION(1:17)     INTEGER EXTERNAL
  ,CD_CONCURSO 						POSITION(18:34)    INTEGER EXTERNAL
  ,ESTADO_CONVENIO     	 			POSITION(35:54)    CHAR "replace (replace(replace(TRIM(:ESTADO_CONVENIO),';',' '), '\"',''),'''','')"
  ,ORIGEN          		 			POSITION(55:74)    CHAR "replace (replace(replace(TRIM(:ORIGEN),';',' '), '\"',''),'''','')"
  ,TIPO                   			POSITION(75:94)    CHAR "replace (replace(replace(TRIM(:TIPO),';',' '), '\"',''),'''','')"
  ,NUMERO_PROPONENTES     			POSITION(95:98)     INTEGER EXTERNAL
  ,TOTAL_MASA_PASIVA       			POSITION(99:114)  DECIMAL EXTERNAL nullif (TOTAL_MASA_PASIVA=BLANKS) "to_number(TRIM(SUBSTR(:TOTAL_MASA_PASIVA,1,14)||','||SUBSTR(:TOTAL_MASA_PASIVA,15,2)))"
  ,PORCENTAJE_MASA_PASIVA    		POSITION(115:120)  DECIMAL EXTERNAL nullif (PORCENTAJE_MASA_PASIVA=BLANKS) "to_number(TRIM(SUBSTR(:PORCENTAJE_MASA_PASIVA,1,4)||','||SUBSTR(:PORCENTAJE_MASA_PASIVA,5,2)))"         
  ,ALTERNATIVA               		POSITION(121:122)  CHAR nullif (ALTERNATIVA=BLANKS) "replace (replace(replace(TRIM(:ALTERNATIVA),';',' '), '\"',''),'''','')"
  ,PROPONENETES              		POSITION(123:1122)  CHAR nullif (PROPONENETES=BLANKS) "replace (replace(replace(TRIM(:PROPONENETES),';',' '), '\"',''),'''','')"
  ,TERCEROS                  		POSITION(1123:2122)  CHAR nullif (TERCEROS=BLANKS) "replace (replace(replace(TRIM(:TERCEROS),';',' '), '\"',''),'''','')"
  ,ADHESION                  		POSITION(2123:2124)  INTEGER EXTERNAL nullif(ADHESION=BLANKS)
  ,RESUMEN_PROPUESTA         		POSITION(2125:3124)  CHAR nullif (RESUMEN_PROPUESTA=BLANKS) "replace (replace(replace(TRIM(:RESUMEN_PROPUESTA),';',' '), '\"',''),'''','')"
  ,POSTURA                  		POSITION(3125:3144)  CHAR nullif (POSTURA=BLANKS) "replace (replace(replace(TRIM(:POSTURA),';',' '), '\"',''),'''','')"
  ,DESCRIPCION_ADHESIONES    		POSITION(3145:4144)  CHAR nullif (DESCRIPCION_ADHESIONES=BLANKS) "replace (replace(replace(TRIM(:DESCRIPCION_ADHESIONES),';',' '), '\"',''),'''','')"
)
