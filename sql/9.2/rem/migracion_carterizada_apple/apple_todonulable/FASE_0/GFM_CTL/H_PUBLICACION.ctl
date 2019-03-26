
OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/H_PUBLICACION.dat'
BADFILE './CTLs_DATs/bad/H_PUBLICACION.bad'
DISCARDFILE './CTLs_DATs/rejects/H_PUBLICACION.bad'
INTO TABLE REM01.MIG2_ACT_AHP_HIST_PUBLICACION
TRUNCATE
TRAILING NULLCOLS
(
AHP_CODIGO_ACTIVO POSITION(1:17) INTEGER EXTERNAL NULLIF(AHP_CODIGO_ACTIVO=BLANKS) "CASE WHEN (:AHP_CODIGO_ACTIVO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AHP_CODIGO_ACTIVO,1,17)||','||SUBSTR(:AHP_CODIGO_ACTIVO,18,0)),';',' '), '\"',''),'''','')) END",
DD_EPV_COD POSITION(18:37) CHAR NULLIF(DD_EPV_COD=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_EPV_COD),';',' '), '\"',''),'''','')",
DD_EPA_COD POSITION(38:57) CHAR NULLIF(DD_EPA_COD=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_EPA_COD),';',' '), '\"',''),'''','')",
DD_TCO_COD POSITION(58:77) CHAR NULLIF(DD_TCO_COD=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_TCO_COD),';',' '), '\"',''),'''','')",
DD_MTO_V_CODIGO POSITION(78:97) CHAR NULLIF(DD_MTO_V_CODIGO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_MTO_V_CODIGO),';',' '), '\"',''),'''','')",
AHP_MOT_OCULTACION_MANUAL_V POSITION(98:347) CHAR NULLIF(AHP_MOT_OCULTACION_MANUAL_V=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:AHP_MOT_OCULTACION_MANUAL_V),';',' '), '\"',''),'''','')",
AHP_CHECK_PUBLICAR_V POSITION(348:349) INTEGER EXTERNAL NULLIF(AHP_CHECK_PUBLICAR_V=BLANKS) "CASE WHEN (:AHP_CHECK_PUBLICAR_V) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AHP_CHECK_PUBLICAR_V,1,2)||','||SUBSTR(:AHP_CHECK_PUBLICAR_V,3,0)),';',' '), '\"',''),'''','')) END",
AHP_CHECK_OCULTAR_V POSITION(350:351) INTEGER EXTERNAL NULLIF(AHP_CHECK_OCULTAR_V=BLANKS) "CASE WHEN (:AHP_CHECK_OCULTAR_V) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AHP_CHECK_OCULTAR_V,1,2)||','||SUBSTR(:AHP_CHECK_OCULTAR_V,3,0)),';',' '), '\"',''),'''','')) END",
AHP_CHECK_OCULTAR_PRECIO_V POSITION(352:353) INTEGER EXTERNAL NULLIF(AHP_CHECK_OCULTAR_PRECIO_V=BLANKS) "CASE WHEN (:AHP_CHECK_OCULTAR_PRECIO_V) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AHP_CHECK_OCULTAR_PRECIO_V,1,2)||','||SUBSTR(:AHP_CHECK_OCULTAR_PRECIO_V,3,0)),';',' '), '\"',''),'''','')) END",
AHP_CHECK_PUB_SIN_PRECIO_V POSITION(354:355) INTEGER EXTERNAL NULLIF(AHP_CHECK_PUB_SIN_PRECIO_V=BLANKS) "CASE WHEN (:AHP_CHECK_PUB_SIN_PRECIO_V) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AHP_CHECK_PUB_SIN_PRECIO_V,1,2)||','||SUBSTR(:AHP_CHECK_PUB_SIN_PRECIO_V,3,0)),';',' '), '\"',''),'''','')) END",
DD_MTO_A_CODIGO POSITION(356:375) CHAR NULLIF(DD_MTO_A_CODIGO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_MTO_A_CODIGO),';',' '), '\"',''),'''','')",
AHP_MOT_OCULTACION_MANUAL_A POSITION(376:625) CHAR NULLIF(AHP_MOT_OCULTACION_MANUAL_A=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:AHP_MOT_OCULTACION_MANUAL_A),';',' '), '\"',''),'''','')",
AHP_CHECK_PUBLICAR_A POSITION(626:627) INTEGER EXTERNAL NULLIF(AHP_CHECK_PUBLICAR_A=BLANKS) "CASE WHEN (:AHP_CHECK_PUBLICAR_A) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AHP_CHECK_PUBLICAR_A,1,2)||','||SUBSTR(:AHP_CHECK_PUBLICAR_A,3,0)),';',' '), '\"',''),'''','')) END",
AHP_CHECK_OCULTAR_A POSITION(628:629) INTEGER EXTERNAL NULLIF(AHP_CHECK_OCULTAR_A=BLANKS) "CASE WHEN (:AHP_CHECK_OCULTAR_A) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AHP_CHECK_OCULTAR_A,1,2)||','||SUBSTR(:AHP_CHECK_OCULTAR_A,3,0)),';',' '), '\"',''),'''','')) END",
AHP_CHECK_OCULTAR_PRECIO_A POSITION(630:631) INTEGER EXTERNAL NULLIF(AHP_CHECK_OCULTAR_PRECIO_A=BLANKS) "CASE WHEN (:AHP_CHECK_OCULTAR_PRECIO_A) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AHP_CHECK_OCULTAR_PRECIO_A,1,2)||','||SUBSTR(:AHP_CHECK_OCULTAR_PRECIO_A,3,0)),';',' '), '\"',''),'''','')) END",
AHP_CHECK_PUB_SIN_PRECIO_A POSITION(632:633) INTEGER EXTERNAL NULLIF(AHP_CHECK_PUB_SIN_PRECIO_A=BLANKS) "CASE WHEN (:AHP_CHECK_PUB_SIN_PRECIO_A) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:AHP_CHECK_PUB_SIN_PRECIO_A,1,2)||','||SUBSTR(:AHP_CHECK_PUB_SIN_PRECIO_A,3,0)),';',' '), '\"',''),'''','')) END",
AHP_FECHA_INI_VENTA POSITION(634:641) DATE 'YYYYMMDD' NULLIF(AHP_FECHA_INI_VENTA=BLANKS) "REPLACE(:AHP_FECHA_INI_VENTA, '00000000', '')",
AHP_FECHA_FIN_VENTA POSITION(642:649) DATE 'YYYYMMDD' NULLIF(AHP_FECHA_FIN_VENTA=BLANKS) "REPLACE(:AHP_FECHA_FIN_VENTA, '00000000', '')",
AHP_FECHA_INI_ALQUILER POSITION(650:657) DATE 'YYYYMMDD' NULLIF(AHP_FECHA_INI_ALQUILER=BLANKS) "REPLACE(:AHP_FECHA_INI_ALQUILER, '00000000', '')",
AHP_FECHA_FIN_ALQUILER POSITION(658:665) DATE 'YYYYMMDD' NULLIF(AHP_FECHA_FIN_ALQUILER=BLANKS) "REPLACE(:AHP_FECHA_FIN_ALQUILER, '00000000', '')",
DD_TPU_V_CODIGO POSITION(666:685) CHAR NULLIF(DD_TPU_V_CODIGO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_TPU_V_CODIGO),';',' '), '\"',''),'''','')",
DD_TPU_A_CODIGO POSITION(686:705) CHAR NULLIF(DD_TPU_A_CODIGO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:DD_TPU_A_CODIGO),';',' '), '\"',''),'''','')",
VALIDACION CONSTANT "0"
)




