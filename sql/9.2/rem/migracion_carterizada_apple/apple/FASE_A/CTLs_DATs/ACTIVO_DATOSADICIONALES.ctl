
OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/ACTIVO_DATOSADICIONALES.dat'
BADFILE './CTLs_DATs/bad/ACTIVO_DATOSADICIONALES.bad'
DISCARDFILE './CTLs_DATs/rejects/ACTIVO_DATOSADICIONALES.bad'
INTO TABLE REM01.MIG_ADA_DATOS_ADI
TRUNCATE
TRAILING NULLCOLS
(
ACT_NUMERO_ACTIVO POSITION(1:17) INTEGER EXTERNAL "CASE WHEN (:ACT_NUMERO_ACTIVO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACT_NUMERO_ACTIVO,1,17)||','||SUBSTR(:ACT_NUMERO_ACTIVO,18,0)),';',' '), '\"',''),'''','')) END",
TIPO_VPO POSITION(18:37) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:TIPO_VPO),';',' '), '\"',''),'''','')",
ADM_SUELO_VPO POSITION(38:39) INTEGER EXTERNAL NULLIF(ADM_SUELO_VPO=BLANKS) "CASE WHEN (:ADM_SUELO_VPO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ADM_SUELO_VPO,1,2)||','||SUBSTR(:ADM_SUELO_VPO,3,0)),';',' '), '\"',''),'''','')) END",
ADM_PROMOCION_VPO POSITION(40:41) INTEGER EXTERNAL NULLIF(ADM_PROMOCION_VPO=BLANKS) "CASE WHEN (:ADM_PROMOCION_VPO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ADM_PROMOCION_VPO,1,2)||','||SUBSTR(:ADM_PROMOCION_VPO,3,0)),';',' '), '\"',''),'''','')) END",
ADM_NUM_EXPEDIENTE POSITION(42:91) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:ADM_NUM_EXPEDIENTE),';',' '), '\"',''),'''','')",
ADM_FECHA_CALIFICACION POSITION(92:99) DATE 'YYYYMMDD' "REPLACE(:ADM_FECHA_CALIFICACION, '00000000', '')",
ADM_OBLIGATORIO_SOL_DEV_AYUDA POSITION(100:101) INTEGER EXTERNAL NULLIF(ADM_OBLIGATORIO_SOL_DEV_AYUDA=BLANKS) "CASE WHEN (:ADM_OBLIGATORIO_SOL_DEV_AYUDA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ADM_OBLIGATORIO_SOL_DEV_AYUDA,1,2)||','||SUBSTR(:ADM_OBLIGATORIO_SOL_DEV_AYUDA,3,0)),';',' '), '\"',''),'''','')) END",
ADM_OBLIG_AUT_ADM_VENTA POSITION(102:103) INTEGER EXTERNAL NULLIF(ADM_OBLIG_AUT_ADM_VENTA=BLANKS) "CASE WHEN (:ADM_OBLIG_AUT_ADM_VENTA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ADM_OBLIG_AUT_ADM_VENTA,1,2)||','||SUBSTR(:ADM_OBLIG_AUT_ADM_VENTA,3,0)),';',' '), '\"',''),'''','')) END",
ADM_DESCALIFICADO POSITION(104:105) INTEGER EXTERNAL NULLIF(ADM_DESCALIFICADO=BLANKS) "CASE WHEN (:ADM_DESCALIFICADO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ADM_DESCALIFICADO,1,2)||','||SUBSTR(:ADM_DESCALIFICADO,3,0)),';',' '), '\"',''),'''','')) END",
ADM_MAX_PRECIO_VENTA POSITION(106:122) INTEGER EXTERNAL NULLIF(ADM_MAX_PRECIO_VENTA=BLANKS) "CASE WHEN (:ADM_MAX_PRECIO_VENTA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ADM_MAX_PRECIO_VENTA,1,15)||','||SUBSTR(:ADM_MAX_PRECIO_VENTA,16,2)),';',' '), '\"',''),'''','')) END",
ADM_OBSERVACIONES POSITION(123:2122) CHAR NULLIF(ADM_OBSERVACIONES=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:ADM_OBSERVACIONES),';',' '), '\"',''),'''','')",
ADM_SUJETO_A_EXPEDIENTE POSITION(2123:2124) INTEGER EXTERNAL NULLIF(ADM_SUJETO_A_EXPEDIENTE=BLANKS) "CASE WHEN (:ADM_SUJETO_A_EXPEDIENTE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ADM_SUJETO_A_EXPEDIENTE,1,2)||','||SUBSTR(:ADM_SUJETO_A_EXPEDIENTE,3,0)),';',' '), '\"',''),'''','')) END",
ADM_ORGANISMO_EXPROPIANTE POSITION(2125:2224) CHAR NULLIF(ADM_ORGANISMO_EXPROPIANTE=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:ADM_ORGANISMO_EXPROPIANTE),';',' '), '\"',''),'''','')",
ADM_FECHA_INI_EXPEDIENTE POSITION(2225:2232) DATE 'YYYYMMDD' NULLIF(ADM_FECHA_INI_EXPEDIENTE=BLANKS) "REPLACE(:ADM_FECHA_INI_EXPEDIENTE, '00000000', '')",
ADM_REF_EXPDTE_ADMIN POSITION(2233:2282) CHAR NULLIF(ADM_REF_EXPDTE_ADMIN=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:ADM_REF_EXPDTE_ADMIN),';',' '), '\"',''),'''','')",
ADM_REF_EXPDTE_INTERNO POSITION(2283:2332) CHAR NULLIF(ADM_REF_EXPDTE_INTERNO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:ADM_REF_EXPDTE_INTERNO),';',' '), '\"',''),'''','')",
ADM_OBS_EXPROPIACION POSITION(2333:2844) CHAR NULLIF(ADM_OBS_EXPROPIACION=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:ADM_OBS_EXPROPIACION),';',' '), '\"',''),'''','')",
SPS_FECHA_REVISION_ESTADO POSITION(2845:2852) DATE 'YYYYMMDD' NULLIF(SPS_FECHA_REVISION_ESTADO=BLANKS) "REPLACE(:SPS_FECHA_REVISION_ESTADO, '00000000', '')",
SPS_FECHA_TOMA_POSESION POSITION(2853:2860) DATE 'YYYYMMDD' "REPLACE(:SPS_FECHA_TOMA_POSESION, '00000000', '')",
SPS_OCUPADO POSITION(2861:2862) INTEGER EXTERNAL "CASE WHEN (:SPS_OCUPADO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_OCUPADO,1,2)||','||SUBSTR(:SPS_OCUPADO,3,0)),';',' '), '\"',''),'''','')) END",
SPS_CON_TITULO POSITION(2863:2864) INTEGER EXTERNAL "CASE WHEN (:SPS_CON_TITULO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_CON_TITULO,1,2)||','||SUBSTR(:SPS_CON_TITULO,3,0)),';',' '), '\"',''),'''','')) END",
SPS_ACC_TAPIADO POSITION(2865:2866) INTEGER EXTERNAL NULLIF(SPS_ACC_TAPIADO=BLANKS) "CASE WHEN (:SPS_ACC_TAPIADO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_ACC_TAPIADO,1,2)||','||SUBSTR(:SPS_ACC_TAPIADO,3,0)),';',' '), '\"',''),'''','')) END",
SPS_FECHA_ACC_TAPIADO POSITION(2867:2874) DATE 'YYYYMMDD' NULLIF(SPS_FECHA_ACC_TAPIADO=BLANKS) "REPLACE(:SPS_FECHA_ACC_TAPIADO, '00000000', '')",
SPS_ACC_ANTIOCUPA POSITION(2875:2876) INTEGER EXTERNAL NULLIF(SPS_ACC_ANTIOCUPA=BLANKS) "CASE WHEN (:SPS_ACC_ANTIOCUPA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_ACC_ANTIOCUPA,1,2)||','||SUBSTR(:SPS_ACC_ANTIOCUPA,3,0)),';',' '), '\"',''),'''','')) END",
SPS_FECHA_ACC_ANTIOCUPA POSITION(2877:2884) DATE 'YYYYMMDD' NULLIF(SPS_FECHA_ACC_ANTIOCUPA=BLANKS) "REPLACE(:SPS_FECHA_ACC_ANTIOCUPA, '00000000', '')",
SPS_RIESGO_OCUPACION POSITION(2885:2886) INTEGER EXTERNAL NULLIF(SPS_RIESGO_OCUPACION=BLANKS) "CASE WHEN (:SPS_RIESGO_OCUPACION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_RIESGO_OCUPACION,1,2)||','||SUBSTR(:SPS_RIESGO_OCUPACION,3,0)),';',' '), '\"',''),'''','')) END",
TIPO_TITULO_POSESORIO POSITION(2887:2906) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:TIPO_TITULO_POSESORIO),';',' '), '\"',''),'''','')",
SPS_FECHA_TITULO POSITION(2907:2914) DATE 'YYYYMMDD' "REPLACE(:SPS_FECHA_TITULO, '00000000', '')",
SPS_FECHA_VENC_TITULO POSITION(2915:2922) DATE 'YYYYMMDD' "REPLACE(:SPS_FECHA_VENC_TITULO, '00000000', '')",
SPS_RENTA_MENSUAL POSITION(2923:2939) INTEGER EXTERNAL "CASE WHEN (:SPS_RENTA_MENSUAL) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_RENTA_MENSUAL,1,15)||','||SUBSTR(:SPS_RENTA_MENSUAL,16,2)),';',' '), '\"',''),'''','')) END",
SPS_FECHA_SOL_DESAHUCIO POSITION(2940:2947) DATE 'YYYYMMDD' "REPLACE(:SPS_FECHA_SOL_DESAHUCIO, '00000000', '')",
SPS_FECHA_LANZAMIENTO POSITION(2948:2955) DATE 'YYYYMMDD' "REPLACE(:SPS_FECHA_LANZAMIENTO, '00000000', '')",
SPS_FECHA_LANZAMIENTO_EFECTIVO POSITION(2956:2963) DATE 'YYYYMMDD' "REPLACE(:SPS_FECHA_LANZAMIENTO_EFECTIVO, '00000000', '')",
SPS_OTRO POSITION(2964:3218) CHAR NULLIF(SPS_OTRO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:SPS_OTRO),';',' '), '\"',''),'''','')",
SPS_ESTADO_PORTAL_EXTERNO POSITION(3219:3220) INTEGER EXTERNAL NULLIF(SPS_ESTADO_PORTAL_EXTERNO=BLANKS) "CASE WHEN (:SPS_ESTADO_PORTAL_EXTERNO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_ESTADO_PORTAL_EXTERNO,1,2)||','||SUBSTR(:SPS_ESTADO_PORTAL_EXTERNO,3,0)),';',' '), '\"',''),'''','')) END",
SPS_NUMERO_CONTRATO_ALQUILER POSITION(3221:3237) INTEGER EXTERNAL "CASE WHEN (:SPS_NUMERO_CONTRATO_ALQUILER) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_NUMERO_CONTRATO_ALQUILER,1,17)||','||SUBSTR(:SPS_NUMERO_CONTRATO_ALQUILER,18,0)),';',' '), '\"',''),'''','')) END",
SPS_FECHA_RESOLUCION_CONTRATO POSITION(3238:3245) DATE 'YYYYMMDD' "REPLACE(:SPS_FECHA_RESOLUCION_CONTRATO, '00000000', '')",
SPS_LOTE_COMERCIAL POSITION(3246:3262) INTEGER EXTERNAL NULLIF(SPS_LOTE_COMERCIAL=BLANKS) "CASE WHEN (:SPS_LOTE_COMERCIAL) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_LOTE_COMERCIAL,1,17)||','||SUBSTR(:SPS_LOTE_COMERCIAL,18,0)),';',' '), '\"',''),'''','')) END",
DD_SIJ_ID POSITION(3263:3282) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:DD_SIJ_ID),';',' '), '\"',''),'''','')",
SPS_EDITA_FECHA_TOMA_POSESION POSITION(3283:3284) INTEGER EXTERNAL NULLIF(SPS_EDITA_FECHA_TOMA_POSESION=BLANKS) "CASE WHEN (:SPS_EDITA_FECHA_TOMA_POSESION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_EDITA_FECHA_TOMA_POSESION,1,2)||','||SUBSTR(:SPS_EDITA_FECHA_TOMA_POSESION,3,0)),';',' '), '\"',''),'''','')) END",
SPS_DISPONIBILIDAD_JURIDICA POSITION(3285:3301) INTEGER EXTERNAL "CASE WHEN (:SPS_DISPONIBILIDAD_JURIDICA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:SPS_DISPONIBILIDAD_JURIDICA,1,17)||','||SUBSTR(:SPS_DISPONIBILIDAD_JURIDICA,18,0)),';',' '), '\"',''),'''','')) END",
MUNICIPIO_REGISTRO POSITION(3302:3321) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:MUNICIPIO_REGISTRO),';',' '), '\"',''),'''','')",
REG_NUM_REGISTRO POSITION(3322:3371) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:REG_NUM_REGISTRO),';',' '), '\"',''),'''','')",
REG_TOMO POSITION(3372:3421) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:REG_TOMO),';',' '), '\"',''),'''','')",
REG_LIBRO POSITION(3422:3471) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:REG_LIBRO),';',' '), '\"',''),'''','')",
REG_FOLIO POSITION(3472:3521) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:REG_FOLIO),';',' '), '\"',''),'''','')",
REG_NUM_FINCA POSITION(3522:3571) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:REG_NUM_FINCA),';',' '), '\"',''),'''','')",
REG_NUM_DEPARTAMENTO POSITION(3572:3588) INTEGER EXTERNAL "CASE WHEN (:REG_NUM_DEPARTAMENTO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:REG_NUM_DEPARTAMENTO,1,17)||','||SUBSTR(:REG_NUM_DEPARTAMENTO,18,0)),';',' '), '\"',''),'''','')) END",
REG_IDUFIR POSITION(3589:3638) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:REG_IDUFIR),';',' '), '\"',''),'''','')",
REG_HAN_CAMBIADO POSITION(3639:3640) INTEGER EXTERNAL NULLIF(REG_HAN_CAMBIADO=BLANKS) "CASE WHEN (:REG_HAN_CAMBIADO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:REG_HAN_CAMBIADO,1,2)||','||SUBSTR(:REG_HAN_CAMBIADO,3,0)),';',' '), '\"',''),'''','')) END",
MUNICIPIO_REG_ANTERIOR POSITION(3641:3660) CHAR NULLIF(MUNICIPIO_REG_ANTERIOR=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:MUNICIPIO_REG_ANTERIOR),';',' '), '\"',''),'''','')",
REG_NUM_ANTERIOR POSITION(3661:3710) CHAR NULLIF(REG_NUM_ANTERIOR=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:REG_NUM_ANTERIOR),';',' '), '\"',''),'''','')",
REG_NUM_FINCA_ANTERIOR POSITION(3711:3760) CHAR NULLIF(REG_NUM_FINCA_ANTERIOR=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:REG_NUM_FINCA_ANTERIOR),';',' '), '\"',''),'''','')",
REG_SUPERFICIE POSITION(3761:3777) INTEGER EXTERNAL "CASE WHEN (:REG_SUPERFICIE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:REG_SUPERFICIE,1,15)||','||SUBSTR(:REG_SUPERFICIE,16,2)),';',' '), '\"',''),'''','')) END",
REG_SUPERFICIE_CONSTRUIDA POSITION(3778:3794) INTEGER EXTERNAL "CASE WHEN (:REG_SUPERFICIE_CONSTRUIDA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:REG_SUPERFICIE_CONSTRUIDA,1,15)||','||SUBSTR(:REG_SUPERFICIE_CONSTRUIDA,16,2)),';',' '), '\"',''),'''','')) END",
REG_SUPERFICIE_UTIL POSITION(3795:3811) INTEGER EXTERNAL "CASE WHEN (:REG_SUPERFICIE_UTIL) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:REG_SUPERFICIE_UTIL,1,15)||','||SUBSTR(:REG_SUPERFICIE_UTIL,16,2)),';',' '), '\"',''),'''','')) END",
REG_SUPERFICIE_ELEM_COMUN POSITION(3812:3828) INTEGER EXTERNAL "CASE WHEN (:REG_SUPERFICIE_ELEM_COMUN) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:REG_SUPERFICIE_ELEM_COMUN,1,15)||','||SUBSTR(:REG_SUPERFICIE_ELEM_COMUN,16,2)),';',' '), '\"',''),'''','')) END",
REG_SUPERFICIE_PARCELA POSITION(3829:3845) INTEGER EXTERNAL "CASE WHEN (:REG_SUPERFICIE_PARCELA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:REG_SUPERFICIE_PARCELA,1,15)||','||SUBSTR(:REG_SUPERFICIE_PARCELA,16,2)),';',' '), '\"',''),'''','')) END",
REG_SUPERFICIE_BAJO_RASANTE POSITION(3846:3862) INTEGER EXTERNAL NULLIF(REG_SUPERFICIE_BAJO_RASANTE=BLANKS) "CASE WHEN (:REG_SUPERFICIE_BAJO_RASANTE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:REG_SUPERFICIE_BAJO_RASANTE,1,15)||','||SUBSTR(:REG_SUPERFICIE_BAJO_RASANTE,16,2)),';',' '), '\"',''),'''','')) END",
REG_SUPERFICIE_SOBRE_RASANTE POSITION(3863:3879) INTEGER EXTERNAL NULLIF(REG_SUPERFICIE_SOBRE_RASANTE=BLANKS) "CASE WHEN (:REG_SUPERFICIE_SOBRE_RASANTE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:REG_SUPERFICIE_SOBRE_RASANTE,1,15)||','||SUBSTR(:REG_SUPERFICIE_SOBRE_RASANTE,16,2)),';',' '), '\"',''),'''','')) END",
REG_DIV_HOR_INSCRITO POSITION(3880:3881) INTEGER EXTERNAL NULLIF(REG_DIV_HOR_INSCRITO=BLANKS) "CASE WHEN (:REG_DIV_HOR_INSCRITO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:REG_DIV_HOR_INSCRITO,1,2)||','||SUBSTR(:REG_DIV_HOR_INSCRITO,3,0)),';',' '), '\"',''),'''','')) END",
ESTADO_DIVISION_HORIZONTAL POSITION(3882:3901) CHAR NULLIF(ESTADO_DIVISION_HORIZONTAL=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:ESTADO_DIVISION_HORIZONTAL),';',' '), '\"',''),'''','')",
ESTADO_OBRA_NUEVA POSITION(3902:3921) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:ESTADO_OBRA_NUEVA),';',' '), '\"',''),'''','')",
REG_FECHA_CFO POSITION(3922:3929) DATE 'YYYYMMDD' "REPLACE(:REG_FECHA_CFO, '00000000', '')",
BIE_DREG_INSCRIPCION POSITION(3930:3979) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:BIE_DREG_INSCRIPCION),';',' '), '\"',''),'''','')",
BIE_DREG_MUNICIPIO_LIBRO POSITION(3980:4029) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:BIE_DREG_MUNICIPIO_LIBRO),';',' '), '\"',''),'''','')",
TIPO_UBICACION POSITION(4030:4049) CHAR NULLIF(TIPO_UBICACION=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:TIPO_UBICACION),';',' '), '\"',''),'''','')",
TIPO_VIA POSITION(4050:4069) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:TIPO_VIA),';',' '), '\"',''),'''','')",
LOC_NOMBRE_VIA POSITION(4070:4169) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:LOC_NOMBRE_VIA),';',' '), '\"',''),'''','')",
LOC_NUMERO_DOMICILIO POSITION(4170:4269) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:LOC_NUMERO_DOMICILIO),';',' '), '\"',''),'''','')",
LOC_PORTAL POSITION(4270:4279) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:LOC_PORTAL),';',' '), '\"',''),'''','')",
LOC_BLOQUE POSITION(4280:4289) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:LOC_BLOQUE),';',' '), '\"',''),'''','')",
LOC_ESCALERA POSITION(4290:4299) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:LOC_ESCALERA),';',' '), '\"',''),'''','')",
LOC_PISO POSITION(4300:4309) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:LOC_PISO),';',' '), '\"',''),'''','')",
LOC_PUERTA POSITION(4310:4319) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:LOC_PUERTA),';',' '), '\"',''),'''','')",
LOC_COD_POST POSITION(4320:4339) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:LOC_COD_POST),';',' '), '\"',''),'''','')",
LOC_BARRIO POSITION(4340:4439) CHAR NULLIF(LOC_BARRIO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:LOC_BARRIO),';',' '), '\"',''),'''','')",
UNIDAD_INFERIOR_MUNICIPIO POSITION(4440:4459) CHAR NULLIF(UNIDAD_INFERIOR_MUNICIPIO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:UNIDAD_INFERIOR_MUNICIPIO),';',' '), '\"',''),'''','')",
MUNICIPIO POSITION(4460:4479) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:MUNICIPIO),';',' '), '\"',''),'''','')",
PROVINCIA POSITION(4480:4499) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:PROVINCIA),';',' '), '\"',''),'''','')",
PAIS POSITION(4500:4519) CHAR "REPLACE(REPLACE(REPLACE(TRIM(:PAIS),';',' '), '\"',''),'''','')",
LOC_LONGITUD POSITION(4520:4541) INTEGER EXTERNAL "CASE WHEN (:LOC_LONGITUD) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:LOC_LONGITUD,1,7)||','||SUBSTR(:LOC_LONGITUD,8,15)),';',' '), '\"',''),'''','')) END",
LOC_LATITUD POSITION(4542:4563) INTEGER EXTERNAL "CASE WHEN (:LOC_LATITUD) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:LOC_LATITUD,1,7)||','||SUBSTR(:LOC_LATITUD,8,15)),';',' '), '\"',''),'''','')) END",
LOC_DIST_PLAYA POSITION(4564:4580) INTEGER EXTERNAL NULLIF(LOC_DIST_PLAYA=BLANKS) "CASE WHEN (:LOC_DIST_PLAYA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:LOC_DIST_PLAYA,1,15)||','||SUBSTR(:LOC_DIST_PLAYA,16,2)),';',' '), '\"',''),'''','')) END",
CPR_COD_COM_PROP_EXTERNO POSITION(4581:4590) CHAR NULLIF(CPR_COD_COM_PROP_EXTERNO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_COD_COM_PROP_EXTERNO),';',' '), '\"',''),'''','')",
ACT_LLV_NECESARIAS POSITION(4591:4592) INTEGER EXTERNAL "CASE WHEN (:ACT_LLV_NECESARIAS) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACT_LLV_NECESARIAS,1,2)||','||SUBSTR(:ACT_LLV_NECESARIAS,3,0)),';',' '), '\"',''),'''','')) END",
ACT_LLV_LLAVES_HRE POSITION(4593:4594) INTEGER EXTERNAL "CASE WHEN (:ACT_LLV_LLAVES_HRE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACT_LLV_LLAVES_HRE,1,2)||','||SUBSTR(:ACT_LLV_LLAVES_HRE,3,0)),';',' '), '\"',''),'''','')) END",
ACT_LLV_NUM_JUEGOS POSITION(4595:4603) INTEGER EXTERNAL "CASE WHEN (:ACT_LLV_NUM_JUEGOS) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACT_LLV_NUM_JUEGOS,1,9)||','||SUBSTR(:ACT_LLV_NUM_JUEGOS,10,0)),';',' '), '\"',''),'''','')) END",
ACT_LLV_FECHA_RECEPCION POSITION(4604:4611) DATE 'YYYYMMDD' NULLIF(ACT_LLV_FECHA_RECEPCION=BLANKS) "REPLACE(:ACT_LLV_FECHA_RECEPCION, '00000000', '')",
ACT_IND_CONDICIONADO_OTROS POSITION(4612:4866) CHAR NULLIF(ACT_IND_CONDICIONADO_OTROS=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:ACT_IND_CONDICIONADO_OTROS),';',' '), '\"',''),'''','')",
VALIDACION CONSTANT "0"
)




