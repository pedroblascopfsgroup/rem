OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE MIG_PROCEDIMIENTOS_CABECERA
TRUNCATE 
TRAILING NULLCOLS
(
   ID_PROC_CABECERA                 SEQUENCE 
  ,CD_PROCEDIMIENTO                 POSITION(1:17)      INTEGER EXTERNAL 
  ,CD_DESPACHO                      POSITION(18:37)     CHAR "replace (replace(replace(TRIM(:CD_DESPACHO),';',' '), '\"',''),'''','')"
  ,CD_PROCURADOR                    POSITION(38:57)     CHAR "replace (replace(replace(TRIM(:CD_PROCURADOR),';',' '), '\"',''),'''','')"
  ,TIPO_PROCEDIMIENTO               POSITION(58:77)     CHAR "replace (replace(replace(TRIM(:TIPO_PROCEDIMIENTO),';',' '), '\"',''),'''','')"
  ,ESTADO_PROCEDIMIENTO             POSITION(78:97)     CHAR "replace (replace(replace(TRIM(:ESTADO_PROCEDIMIENTO),';',' '), '\"',''),'''','')"
  ,MOTIVO_FINALIZACION              POSITION(98:117)    CHAR nullif (MOTIVO_FINALIZACION=BLANKS) "replace (replace(replace(TRIM(:MOTIVO_FINALIZACION),';',' '), '\"',''),'''','')"
  ,PLAZA                            POSITION(118:147)   CHAR  nullif (PLAZA=BLANKS) "replace(replace(replace(TRIM(:PLAZA),';',' '), '\"',''),'''','')"   
  ,JUZGADO                          POSITION(148:167)    CHAR  nullif (JUZGADO=BLANKS) "replace(replace(replace(TRIM(:JUZGADO),';',' '), '\"',''),'''','')"  
  ,NUM_AUTOS                        POSITION(168:177)   CHAR  nullif (NUM_AUTOS=BLANKS) "replace(replace(replace(TRIM(:NUM_AUTOS),';',' '), '\"',''),'''','')"
  ,NUM_AUTO_SIN_FORMATO             POSITION(178:227)   CHAR  nullif (NUM_AUTO_SIN_FORMATO=BLANKS) "replace(replace(replace(TRIM(:NUM_AUTO_SIN_FORMATO),';',' '), '\"',''),'''','')"
  ,IMPORTE_PRINCIPAL                POSITION(228:243)   DECIMAL EXTERNAL nullif (IMPORTE_PRINCIPAL=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_PRINCIPAL,1,15)||','||SUBSTR(:IMPORTE_PRINCIPAL,16,2)))"
  ,IMPORTE_INTERESES_COSTAS         POSITION(244:259)   DECIMAL EXTERNAL nullif (IMPORTE_INTERESES_COSTAS=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_INTERESES_COSTAS,1,15)||','||SUBSTR(:IMPORTE_INTERESES_COSTAS,16,2)))"
  ,IMPORTE_DEMANDA                  POSITION(260:275)   DECIMAL EXTERNAL nullif (IMPORTE_DEMANDA=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_DEMANDA,1,15)||','||SUBSTR(:IMPORTE_DEMANDA,16,2)))"
  ,IMPORTE_RECONOCIDO_JUZGADO       POSITION(276:291)   DECIMAL EXTERNAL nullif (IMPORTE_RECONOCIDO_JUZGADO=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_RECONOCIDO_JUZGADO,1,15)||','||SUBSTR(:IMPORTE_RECONOCIDO_JUZGADO,16,2)))"
  ,FECHA_PRESENTACION_DEMANDA       POSITION(292:299)   DATE 'DDMMYYYY' nullif (FECHA_PRESENTACION_DEMANDA=BLANKS) "replace( replace(:FECHA_PRESENTACION_DEMANDA, '01010001', ''), '00000000', '')"
  ,FECHA_ADMISION_DEMANDA           POSITION(300:307)   DATE 'DDMMYYYY' nullif (FECHA_ADMISION_DEMANDA=BLANKS) "replace( replace(:FECHA_ADMISION_DEMANDA, '01010001', ''), '00000000', '')"
  ,FECHA_INADMISION_DEMANDA         POSITION(308:315)   DATE 'DDMMYYYY' nullif (FECHA_INADMISION_DEMANDA=BLANKS) "replace( replace(:FECHA_INADMISION_DEMANDA, '01010001', ''), '00000000', '')"
  ,MOTIVO_INADMISION                POSITION(316:335)   CHAR nullif (MOTIVO_INADMISION=BLANKS) "replace (replace (replace(replace(TRIM(:MOTIVO_INADMISION),';',' '), '\"',''),'''',''), '/','')"
  ,FECHA_PRESENTACION_LITC          POSITION(336:343)   DATE 'DDMMYYYY' nullif (FECHA_PRESENTACION_LITC=BLANKS) "replace( replace(:FECHA_PRESENTACION_LITC, '01010001', ''), '00000000', '')"
  ,FECHA_IMPUGNACION_LITC           POSITION(344:351)   DATE 'DDMMYYYY' nullif (FECHA_IMPUGNACION_LITC=BLANKS) "replace( replace(:FECHA_IMPUGNACION_LITC, '01010001', ''), '00000000', '')"
  ,FECHA_APROBACION_LITC            POSITION(352:359)   DATE 'DDMMYYYY' nullif (FECHA_APROBACION_LITC=BLANKS) "replace( replace(:FECHA_APROBACION_LITC, '01010001', ''), '00000000', '')"
  ,IMPORTE_INTERESES_APROBADOS      POSITION(360:375)   DECIMAL EXTERNAL nullif (IMPORTE_INTERESES_APROBADOS=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_INTERESES_APROBADOS,1,15)||','||SUBSTR(:IMPORTE_INTERESES_APROBADOS,16,2)))"
  ,IMPORTE_COSTAS_LETRADO_APROB     POSITION(376:391)   DECIMAL EXTERNAL nullif (IMPORTE_COSTAS_LETRADO_APROB=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_COSTAS_LETRADO_APROB,1,15)||','||SUBSTR(:IMPORTE_COSTAS_LETRADO_APROB,16,2)))"
  ,IMPORTE_COSTAS_PROCU_APROB       POSITION(392:407)   DECIMAL EXTERNAL nullif (IMPORTE_COSTAS_PROCU_APROB=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_COSTAS_PROCU_APROB,1,15)||','||SUBSTR(:IMPORTE_COSTAS_PROCU_APROB,16,2)))"
  ,IMPORTE_COSTAS_TOTALES_APROB     POSITION(408:423)   DECIMAL EXTERNAL nullif (IMPORTE_COSTAS_TOTALES_APROB=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_COSTAS_TOTALES_APROB,1,15)||','||SUBSTR(:IMPORTE_COSTAS_TOTALES_APROB,16,2)))"
  ,CD_EXPEDIENTE_NUSE               POSITION(424:440)   INTEGER EXTERNAL 
  ,CD_PROCEDIMIENTO_ORIGEN          POSITION(441:457)   INTEGER EXTERNAL nullif (CD_PROCEDIMIENTO_ORIGEN=BLANKS)
  ,ULTIMO_HITO                      POSITION(458:557)   CHAR "NVL(replace (replace(replace(TRIM(:ULTIMO_HITO),';',' '), '\"',''),'''',''),'X2')"
  ,NUMERO_EXP_NUSE                  POSITION(558:607)   CHAR "replace (replace(replace(TRIM(:NUMERO_EXP_NUSE),';',' '), '\"',''),'''','')"
  ,ENTIDAD_PROPIETARIA              POSITION(608:627)   CHAR "replace (replace(replace(TRIM(:ENTIDAD_PROPIETARIA),';',' '), '\"',''),'''','')"
  ,GESTION_PLATAFORMA               POSITION(628:628)   CHAR "replace (replace(replace(TRIM(:GESTION_PLATAFORMA),';',' '), '\"',''),'''','')"
)
