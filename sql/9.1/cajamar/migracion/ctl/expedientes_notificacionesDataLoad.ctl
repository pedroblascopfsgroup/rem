OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE CM01.MIG_EXPEDIENTES_NOTIFICACIONES
TRUNCATE 
TRAILING NULLCOLS
-- 17,17,5,6,17,100,100,10,10,10,10,10,10,100,100,100,100,8,8,100
-- 17,34,39,45,62,162,262,272,282,292,302,312,322,422,522,622,722,730,738,838
(
      CD_EXPEDIENTE          POSITION(1:17)   INTEGER EXTERNAL
    , CD_PROCEDIMIENTO       POSITION(18:34)  INTEGER EXTERNAL	
    , CODIGO_ENTIDAD         POSITION(35:39)  INTEGER EXTERNAL	
    , CODIGO_PROPIETARIO     POSITION(40:45)  INTEGER EXTERNAL	
    , CODIGO_PERSONA         POSITION(46:62)  INTEGER EXTERNAL
    , TIPO_VIA               POSITION(63:162)  CHAR nullif (TIPO_VIA=BLANKS) "replace (replace(replace(TRIM(:TIPO_VIA),';',' '), '\"',''),'''','')" 
    , NOMBRE_VIA             POSITION(163:262) CHAR nullif (NOMBRE_VIA=BLANKS) "replace (replace(replace(TRIM(:NOMBRE_VIA),';',' '), '\"',''),'''','')" 
    , NUM_DOMICILIO          POSITION(263:272) CHAR nullif (NUM_DOMICILIO=BLANKS) "replace (replace(replace(TRIM(:NUM_DOMICILIO),';',' '), '\"',''),'''','')"                     
    , PORTAL                 POSITION(273:282) CHAR nullif (PORTAL=BLANKS) "replace (replace(replace(TRIM(:PORTAL),';',' '), '\"',''),'''','')" 
    , PISO                   POSITION(283:292) CHAR nullif (PISO=BLANKS) "replace (replace(replace(TRIM(:PISO),';',' '), '\"',''),'''','')" 
    , ESCALERA               POSITION(293:302) CHAR nullif (ESCALERA=BLANKS) "replace (replace(replace(TRIM(:ESCALERA),';',' '), '\"',''),'''','')" 
    , PUERTA                 POSITION(303:312) CHAR nullif (PUERTA=BLANKS) "replace (replace(replace(TRIM(:PUERTA),';',' '), '\"',''),'''','')" 
    , CODIGO_POSTAL          POSITION(313:322) CHAR nullif (CODIGO_POSTAL=BLANKS) "replace (replace(replace(TRIM(:CODIGO_POSTAL),';',' '), '\"',''),'''','')" 
    , PROVINCIA              POSITION(323:422) CHAR nullif (PROVINCIA=BLANKS) "replace (replace(replace(TRIM(:PROVINCIA),';',' '), '\"',''),'''','')" 
    , POBLACION              POSITION(423:522) CHAR nullif (POBLACION=BLANKS) "replace (replace(replace(TRIM(:POBLACION),';',' '), '\"',''),'''','')" 
    , MUNICIPIO              POSITION(523:622) CHAR nullif (MUNICIPIO=BLANKS) "replace (replace(replace(TRIM(:MUNICIPIO),';',' '), '\"',''),'''','')" 
    , PAIS                   POSITION(623:722) CHAR nullif (PAIS=BLANKS) "replace (replace(replace(TRIM(:PAIS),';',' '), '\"',''),'''','')" 
    , FECHA_ENVIO            POSITION(723:730) DATE 'DDMMYYYY' NULLIF(FECHA_ENVIO=BLANKS) "replace( replace(:FECHA_ENVIO, '01010001', ''), '00000000', '')"
    , FECHA_ACUSE_RECIBO     POSITION(731:738) DATE 'DDMMYYYY' NULLIF(FECHA_ACUSE_RECIBO=BLANKS) "replace( replace(:FECHA_ACUSE_RECIBO, '01010001', ''), '00000000', '')"
    , ACUSE_RECIBO           POSITION(739:838) CHAR nullif (ACUSE_RECIBO=BLANKS) "replace (replace(replace(TRIM(:ACUSE_RECIBO),';',' '), '\"',''),'''','')" 
)



