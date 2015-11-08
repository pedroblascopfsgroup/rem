OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE CM01.MIG_EXPEDIENTES_CERTIFI_SALDO --OJO COLOCAR LA LETRA S AL FINAL PARA LA ENTREGA
TRUNCATE 
TRAILING NULLCOLS
-- 17,22,28,33,51,67,87,95,103,123,125,141,149
(
   MIG_ID_EXP_CERTIF_SALDO	        SEQUENCE
  ,CD_EXPEDIENTE                        POSITION(1:17)     CHAR "to_number(replace (replace(replace(TRIM(:CD_EXPEDIENTE),';',' '), '\"',''),'''',''))" 
  ,CODIGO_ENTIDAD                       POSITION(18:22)    CHAR "to_number(replace (replace(replace(TRIM(:CODIGO_ENTIDAD),';',' '), '\"',''),'''',''))"
  ,CODIGO_PROPIETARIO                   POSITION(23:28)    CHAR "to_number(replace (replace(replace(TRIM(:CODIGO_PROPIETARIO),';',' '), '\"',''),'''',''))"
  ,TIPO_PRODUCTO 			POSITION(29:33)    CHAR nullif(TIPO_PRODUCTO=BLANKS)  "replace (replace(replace(TRIM(:TIPO_PRODUCTO),';',' '), '\"',''),'''','')"
  ,NUMERO_CONTRATO 			POSITION(34:51)    CHAR "to_number(replace (replace(replace(TRIM(:NUMERO_CONTRATO),';',' '), '\"',''),'''',''))"
  ,NUMERO_ESPEC			POSITION(52:67)    CHAR "to_number(replace (replace(replace(TRIM(:NUMERO_ESPEC),';',' '), '\"',''),'''',''))"
  ,CD_NOTARIO                           POSITION(68:87)    CHAR nullif(CD_NOTARIO=BLANKS)  "replace (replace(replace(TRIM(:CD_NOTARIO),';',' '), '\"',''),'''','')"
  ,FECHA_ENVIO_NOTARIO                  POSITION(88:95)    DATE 'DDMMYYYY' nullif (FECHA_ENVIO_NOTARIO=BLANKS) "replace( replace(:FECHA_ENVIO_NOTARIO, '01010001', ''), '00000000', '')"
  ,FECHA_RECEPCION_RESPUESTA            POSITION(96:103)   DATE 'DDMMYYYY' nullif (FECHA_RECEPCION_RESPUESTA=BLANKS) "replace( replace(:FECHA_RECEPCION_RESPUESTA, '01010001', ''), '00000000', '')"
  ,RESPUESTA				POSITION(104:123)  CHAR nullif(RESPUESTA=BLANKS)  "replace (replace(replace(TRIM(:RESPUESTA),';',' '), '\"',''),'''','')"
  ,DISPONIBLE_IPLUS                     POSITION(124:125)  CHAR "to_number(replace (replace(replace(TRIM(:DISPONIBLE_IPLUS),';',' '), '\"',''),'''',''))"
   ,IMPORTE_LIQUIDACION                  POSITION(126:141)  CHAR "to_number(replace (replace(replace(TRIM(:IMPORTE_LIQUIDACION),';',' '), '\"',''),'''',''))"
   ,FECHA_LIQUIDACION                    POSITION(142:149)  DATE 'DDMMYYYY' nullif (FECHA_LIQUIDACION=BLANKS) "replace( replace(:FECHA_LIQUIDACION, '01010001', ''), '00000000', '')"
) 	
