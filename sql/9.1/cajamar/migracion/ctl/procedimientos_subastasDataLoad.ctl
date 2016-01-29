OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE CM01.MIG_PROCEDIMIENTOS_SUBASTAS -- OJO BORRAR EL 2 PARA ENTREGA
TRUNCATE 
TRAILING NULLCOLS
(  ID_PROC_SUBASTA								SEQUENCE
  ,CD_SUBASTA                                   POSITION(1:17)     INTEGER EXTERNAL
  ,CD_PROCEDIMIENTO                             POSITION(18:34)    INTEGER EXTERNAL
  ,FECHA_SOLICITUD_SUBASTA                      POSITION(35:42)    DATE 'DDMMYYYY' nullif (FECHA_SOLICITUD_SUBASTA=BLANKS) "replace( replace(:FECHA_SOLICITUD_SUBASTA, '01010001', ''), '00000000', '')"
  ,FECHA_SENALAMIENTO_SUBASTA                   POSITION(43:50)    DATE 'DDMMYYYY' nullif (FECHA_SENALAMIENTO_SUBASTA=BLANKS) "replace( replace(:FECHA_SENALAMIENTO_SUBASTA, '01010001', ''), '00000000', '')"
  ,SUBASTA_CELEBRADA                            POSITION(51:52)    INTEGER EXTERNAL
  ,FECHA_CELEBRACION_SUBASTA                    POSITION(53:60)    DATE 'DDMMYYYY' nullif (FECHA_CELEBRACION_SUBASTA=BLANKS) "replace( replace(:FECHA_CELEBRACION_SUBASTA, '01010001', ''), '00000000', '')"
  ,FECHA_DECRETO_ADJUDICACION                   POSITION(61:68)    DATE 'DDMMYYYY' nullif (FECHA_DECRETO_ADJUDICACION=BLANKS) "replace( replace(:FECHA_DECRETO_ADJUDICACION, '01010001', ''), '00000000', '')"
  ,TIPO_SUBASTA                                 POSITION(69:71)    INTEGER EXTERNAL nullif(TIPO_SUBASTA=BLANKS)
  ,SUSPENDIDA_POR                               POSITION(72:73)    INTEGER EXTERNAL nullif(SUSPENDIDA_POR=BLANKS)
  ,MOTIVO_SUSPENSION                            POSITION(74:83)    CHAR nullif(MOTIVO_SUSPENSION=BLANKS) "replace (replace(replace(TRIM(:MOTIVO_SUSPENSION),';',' '), '\"',''),'''','')"
  ,MOTIVO_SUBASTA_CANCELADA                     POSITION(84:85)    INTEGER EXTERNAL nullif(MOTIVO_SUBASTA_CANCELADA=BLANKS)
  ,FECHA_RECEPCION_ACTA                         POSITION(86:93)    DATE 'DDMMYYYY' nullif (FECHA_RECEPCION_ACTA=BLANKS) "replace( replace(:FECHA_RECEPCION_ACTA, '01010001', ''), '00000000', '')"
  ,RESOLUCION_COMITE                            POSITION(94:95)    INTEGER EXTERNAL nullif(RESOLUCION_COMITE=BLANKS)
  ,FECHA_RESOLUCION_PROPUESTA                   POSITION(96:103)   DATE 'DDMMYYYY' nullif (FECHA_RESOLUCION_PROPUESTA=BLANKS) "replace( replace(:FECHA_RESOLUCION_PROPUESTA, '01010001', ''), '00000000', '')"
  ,DEUDA_JUDICIAL                               POSITION(104:119)  DECIMAL EXTERNAL nullif(DEUDA_JUDICIAL=BLANKS) "to_number(TRIM(SUBSTR(:DEUDA_JUDICIAL,1,14)||','||SUBSTR(:DEUDA_JUDICIAL,15,2)))"
  ,MINUTA_LETRADO                               POSITION(120:135)  DECIMAL EXTERNAL nullif(MINUTA_LETRADO=BLANKS) "to_number(TRIM(SUBSTR(:MINUTA_LETRADO,1,14)||','||SUBSTR(:MINUTA_LETRADO,15,2)))"
  ,MINUTA_PROCURADOR                            POSITION(136:151)  DECIMAL EXTERNAL nullif(MINUTA_PROCURADOR=BLANKS) "to_number(TRIM(SUBSTR(:MINUTA_PROCURADOR,1,14)||','||SUBSTR(:MINUTA_PROCURADOR,15,2)))"
 )
