OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE BANK01.TMP_CNT_PER
REPLACE
TRAILING NULLCOLS
(
   TMP_CNT_PER_ID                  SEQUENCE
  ,TMP_CNT_PER_FECHA_EXTRACCION    POSITION(1:8)      DATE 'ddmmyyyy'
  ,TMP_CNT_PER_FECHA_DATO          POSITION(9:16)     DATE 'ddmmyyyy'
  ,TMP_CNT_PER_COD_ENTIDAD         POSITION(17:21)    INTEGER EXTERNAL
  ,TMP_CNT_PER_COD_PERSONA         POSITION(22:38)    INTEGER EXTERNAL
  ,TMP_CNT_PER_COD_PROPIETARIO     POSITION(39:44)    INTEGER EXTERNAL
  ,TMP_CNT_PER_TIPO_PRODUCTO       POSITION(45:49)    CHAR "replace (replace(replace(TRIM(:TMP_CNT_PER_TIPO_PRODUCTO),';',' '), '\"',''),'''','')"
  ,TMP_CNT_PER_NUM_CONTRATO        POSITION(50:67)    INTEGER EXTERNAL
  ,TMP_CNT_PER_NUM_ESPEC           POSITION(68:83)    INTEGER EXTERNAL
  ,TMP_CNT_PER_TIPO_INTERVENCION   POSITION(84:93)    CHAR "replace (replace(replace(TRIM(:TMP_CNT_PER_TIPO_INTERVENCION),';',' '), '\"',''),'''','')"
  ,TMP_CNT_PER_ORDEN               POSITION(94:98)    INTEGER EXTERNAL
  ,TMP_CNT_PER_CHAR_EXTRA1         POSITION(99:148)   CHAR nullif (TMP_CNT_PER_CHAR_EXTRA1=BLANKS) "replace(replace(replace(TRIM(:TMP_CNT_PER_CHAR_EXTRA1),';',' '), '\"',''),'''','')"
  ,TMP_CNT_PER_CHAR_EXTRA2         POSITION(149:198)  CHAR nullif (TMP_CNT_PER_CHAR_EXTRA2=BLANKS) "replace(replace(replace(TRIM(:TMP_CNT_PER_CHAR_EXTRA2),';',' '), '\"',''),'''','')"
  ,TMP_CNT_PER_FLAG_EXTRA1         POSITION(199:199)  CHAR nullif (TMP_CNT_PER_FLAG_EXTRA1=BLANKS) "TRIM(:TMP_CNT_PER_FLAG_EXTRA1)"
  ,TMP_CNT_PER_FLAG_EXTRA2         POSITION(200:200)  CHAR nullif (TMP_CNT_PER_FLAG_EXTRA2=BLANKS) "TRIM(:TMP_CNT_PER_FLAG_EXTRA2)"
  ,TMP_CNT_PER_DATE_EXTRA1         POSITION(201:208)  DATE 'ddmmyyyy' nullif (TMP_CNT_PER_DATE_EXTRA1=BLANKS) "replace (:TMP_CNT_PER_DATE_EXTRA1, '01010001', '')"
  ,TMP_CNT_PER_DATE_EXTRA2         POSITION(209:216)  DATE 'ddmmyyyy' nullif (TMP_CNT_PER_DATE_EXTRA2=BLANKS) "replace (:TMP_CNT_PER_DATE_EXTRA2, '01010001', '')"
  ,TMP_CNT_PER_NUM_EXTRA1          POSITION(217:232)  DECIMAL EXTERNAL  nullif (TMP_CNT_PER_NUM_EXTRA1=BLANKS) "TO_NUMBER(DECODE(TRIM(SUBSTR(:TMP_CNT_PER_NUM_EXTRA1,1,14)||','||SUBSTR(:TMP_CNT_PER_NUM_EXTRA1,15)),',','0,00',TRIM(SUBSTR(:TMP_CNT_PER_NUM_EXTRA1,1,14)||','||SUBSTR(:TMP_CNT_PER_NUM_EXTRA1,15))))"
  ,TMP_CNT_PER_NUM_EXTRA2          POSITION(233:248)  DECIMAL EXTERNAL  nullif (TMP_CNT_PER_NUM_EXTRA2=BLANKS) "TO_NUMBER(DECODE(TRIM(SUBSTR(:TMP_CNT_PER_NUM_EXTRA2,1,14)||','||SUBSTR(:TMP_CNT_PER_NUM_EXTRA2,15)),',','0,00',TRIM(SUBSTR(:TMP_CNT_PER_NUM_EXTRA2,1,14)||','||SUBSTR(:TMP_CNT_PER_NUM_EXTRA2,15))))"
  ,TMP_CNT_PER_FICHERO_CARGA	   EXPRESSION "(SELECT 'RELACION-2038-'||TO_CHAR(SYSDATE,'YYYYMMDD')||'.txt' FROM DUAL)"
  ,TMP_CNT_PER_FECHA_CARGA         EXPRESSION "(SELECT TO_CHAR(SYSDATE,'DDMMYYYY') FROM DUAL)"
  ,VERSION                        "0"
  ,USUARIOCREAR                   "to_char('BATCH_USER')"
  ,FECHACREAR                     "cast(sysdate as timestamp)"
  ,BORRADO                        "0"
  ,TMP_CNT_PER_CODIGO_CNT50			   CHAR "LPAD(replace(TO_CHAR(:TMP_CNT_PER_COD_PROPIETARIO),'+',''),5,'0')||LPAD(replace(:TMP_CNT_PER_TIPO_PRODUCTO,'+',''),5,'0')||LPAD(replace(TO_CHAR(:TMP_CNT_PER_NUM_CONTRATO),'+',''),17,'0')||LPAD(replace(TO_CHAR(:TMP_CNT_PER_NUM_ESPEC),'+',''),15,'0')"  
)
