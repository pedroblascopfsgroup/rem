
OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/COM_PROPIETARIOS_CABECERA.dat'
BADFILE './CTLs_DATs/bad/COM_PROPIETARIOS_CABECERA.bad'
DISCARDFILE './CTLs_DATs/rejects/COM_PROPIETARIOS_CABECERA.bad'
INTO TABLE REM01.MIG_CPC_PROP_CABECERA
TRUNCATE
TRAILING NULLCOLS
(
CPR_COD_COM_PROP_EXTERNO POSITION(1:10) CHAR NULLIF(CPR_COD_COM_PROP_EXTERNO=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_COD_COM_PROP_EXTERNO),';',' '), '\"',''),'''','')",
CPR_CONSTITUIDA POSITION(11:12) INTEGER EXTERNAL NULLIF(CPR_CONSTITUIDA=BLANKS) "CASE WHEN (:CPR_CONSTITUIDA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_CONSTITUIDA,1,2)||','||SUBSTR(:CPR_CONSTITUIDA,3,0)),';',' '), '\"',''),'''','')) END",
CPR_NOMBRE POSITION(13:112) CHAR NULLIF(CPR_NOMBRE=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_NOMBRE),';',' '), '\"',''),'''','')",
CPR_NIF POSITION(113:132) CHAR NULLIF(CPR_NIF=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_NIF),';',' '), '\"',''),'''','')",
CPR_DIRECCION POSITION(133:382) CHAR NULLIF(CPR_DIRECCION=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_DIRECCION),';',' '), '\"',''),'''','')",
CPR_NUM_CUENTA POSITION(383:432) CHAR NULLIF(CPR_NUM_CUENTA=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_NUM_CUENTA),';',' '), '\"',''),'''','')",
CPR_PRESIDENTE_NOMBRE POSITION(433:532) CHAR NULLIF(CPR_PRESIDENTE_NOMBRE=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_PRESIDENTE_NOMBRE),';',' '), '\"',''),'''','')",
CPR_PRESIDENTE_TELF POSITION(533:552) CHAR NULLIF(CPR_PRESIDENTE_TELF=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_PRESIDENTE_TELF),';',' '), '\"',''),'''','')",
CPR_PRESIDENTE_TELF2 POSITION(553:572) CHAR NULLIF(CPR_PRESIDENTE_TELF2=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_PRESIDENTE_TELF2),';',' '), '\"',''),'''','')",
CPR_PRESIDENTE_EMAIL POSITION(573:672) CHAR NULLIF(CPR_PRESIDENTE_EMAIL=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_PRESIDENTE_EMAIL),';',' '), '\"',''),'''','')",
CPR_PRESIDENTE_DIR POSITION(673:922) CHAR NULLIF(CPR_PRESIDENTE_DIR=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_PRESIDENTE_DIR),';',' '), '\"',''),'''','')",
CPR_FECHA_INI POSITION(923:930) DATE 'YYYYMMDD' NULLIF(CPR_FECHA_INI=BLANKS) "REPLACE(:CPR_FECHA_INI, '00000000', '')",
CPR_FECHA_FIN POSITION(931:938) DATE 'YYYYMMDD' NULLIF(CPR_FECHA_FIN=BLANKS) "REPLACE(:CPR_FECHA_FIN, '00000000', '')",
CPR_ADMINISTRADOR_NOMBRE POSITION(939:1038) CHAR NULLIF(CPR_ADMINISTRADOR_NOMBRE=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_ADMINISTRADOR_NOMBRE),';',' '), '\"',''),'''','')",
CPR_ADMINISTRADOR_TELF POSITION(1039:1058) CHAR NULLIF(CPR_ADMINISTRADOR_TELF=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_ADMINISTRADOR_TELF),';',' '), '\"',''),'''','')",
CPR_ADMINISTRADOR_TELF2 POSITION(1059:1078) CHAR NULLIF(CPR_ADMINISTRADOR_TELF2=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_ADMINISTRADOR_TELF2),';',' '), '\"',''),'''','')",
CPR_ADMINISTRADOR_DIR POSITION(1079:1328) CHAR NULLIF(CPR_ADMINISTRADOR_DIR=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_ADMINISTRADOR_DIR),';',' '), '\"',''),'''','')",
CPR_ADMINISTRADOR_EMAIL POSITION(1329:1428) CHAR NULLIF(CPR_ADMINISTRADOR_EMAIL=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_ADMINISTRADOR_EMAIL),';',' '), '\"',''),'''','')",
CPR_IMPORTEMEDIO POSITION(1429:1445) INTEGER EXTERNAL NULLIF(CPR_IMPORTEMEDIO=BLANKS) "CASE WHEN (:CPR_IMPORTEMEDIO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_IMPORTEMEDIO,1,15)||','||SUBSTR(:CPR_IMPORTEMEDIO,16,2)),';',' '), '\"',''),'''','')) END",
CPR_ESTATUTOS POSITION(1446:1447) INTEGER EXTERNAL NULLIF(CPR_ESTATUTOS=BLANKS) "CASE WHEN (:CPR_ESTATUTOS) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_ESTATUTOS,1,2)||','||SUBSTR(:CPR_ESTATUTOS,3,0)),';',' '), '\"',''),'''','')) END",
CPR_LIBRO_EDIFICIO POSITION(1448:1449) INTEGER EXTERNAL NULLIF(CPR_LIBRO_EDIFICIO=BLANKS) "CASE WHEN (:CPR_LIBRO_EDIFICIO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_LIBRO_EDIFICIO,1,2)||','||SUBSTR(:CPR_LIBRO_EDIFICIO,3,0)),';',' '), '\"',''),'''','')) END",
CPR_CERTIFICADO_ITE POSITION(1450:1451) INTEGER EXTERNAL NULLIF(CPR_CERTIFICADO_ITE=BLANKS) "CASE WHEN (:CPR_CERTIFICADO_ITE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_CERTIFICADO_ITE,1,2)||','||SUBSTR(:CPR_CERTIFICADO_ITE,3,0)),';',' '), '\"',''),'''','')) END",
CPR_OBSERVACIONES POSITION(1452:1963) CHAR NULLIF(CPR_OBSERVACIONES=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_OBSERVACIONES),';',' '), '\"',''),'''','')",
CPR_FECHA_COMUNICACION POSITION(1964:1971) DATE 'YYYYMMDD' NULLIF(CPR_FECHA_COMUNICACION=BLANKS) "REPLACE(:CPR_FECHA_COMUNICACION, '00000000', '')",
CPR_ENVIO_CARTAS POSITION(1972:1973) INTEGER EXTERNAL NULLIF(CPR_ENVIO_CARTAS=BLANKS) "CASE WHEN (:CPR_ENVIO_CARTAS) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_ENVIO_CARTAS,1,2)||','||SUBSTR(:CPR_ENVIO_CARTAS,3,0)),';',' '), '\"',''),'''','')) END",
CPR_NUMERO_CARTAS POSITION(1974:1975) INTEGER EXTERNAL NULLIF(CPR_NUMERO_CARTAS=BLANKS) "CASE WHEN (:CPR_NUMERO_CARTAS) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_NUMERO_CARTAS,1,2)||','||SUBSTR(:CPR_NUMERO_CARTAS,3,0)),';',' '), '\"',''),'''','')) END",
CPR_CONTACTO_TELF POSITION(1976:1977) INTEGER EXTERNAL NULLIF(CPR_CONTACTO_TELF=BLANKS) "CASE WHEN (:CPR_CONTACTO_TELF) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_CONTACTO_TELF,1,2)||','||SUBSTR(:CPR_CONTACTO_TELF,3,0)),';',' '), '\"',''),'''','')) END",
CPR_VISITA POSITION(1978:1979) INTEGER EXTERNAL NULLIF(CPR_VISITA=BLANKS) "CASE WHEN (:CPR_VISITA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_VISITA,1,2)||','||SUBSTR(:CPR_VISITA,3,0)),';',' '), '\"',''),'''','')) END",
CPR_BUROFAX POSITION(1980:1981) INTEGER EXTERNAL NULLIF(CPR_BUROFAX=BLANKS) "CASE WHEN (:CPR_BUROFAX) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_BUROFAX,1,2)||','||SUBSTR(:CPR_BUROFAX,3,0)),';',' '), '\"',''),'''','')) END",
CPR_NO_CORRESPONDE POSITION(1982:1983) INTEGER EXTERNAL NULLIF(CPR_NO_CORRESPONDE=BLANKS) "CASE WHEN (:CPR_NO_CORRESPONDE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_NO_CORRESPONDE,1,2)||','||SUBSTR(:CPR_NO_CORRESPONDE,3,0)),';',' '), '\"',''),'''','')) END",
CPR_CERRADO_SIN_LOCALIZAR POSITION(1984:1985) INTEGER EXTERNAL NULLIF(CPR_CERRADO_SIN_LOCALIZAR=BLANKS) "CASE WHEN (:CPR_CERRADO_SIN_LOCALIZAR) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_CERRADO_SIN_LOCALIZAR,1,2)||','||SUBSTR(:CPR_CERRADO_SIN_LOCALIZAR,3,0)),';',' '), '\"',''),'''','')) END",
CPR_ENVIO_CARTA_VENTA POSITION(1986:1987) INTEGER EXTERNAL NULLIF(CPR_ENVIO_CARTA_VENTA=BLANKS) "CASE WHEN (:CPR_ENVIO_CARTA_VENTA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_ENVIO_CARTA_VENTA,1,2)||','||SUBSTR(:CPR_ENVIO_CARTA_VENTA,3,0)),';',' '), '\"',''),'''','')) END",
CPR_NO_CONSTITUIDA POSITION(1988:1989) INTEGER EXTERNAL NULLIF(CPR_NO_CONSTITUIDA=BLANKS) "CASE WHEN (:CPR_NO_CONSTITUIDA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_NO_CONSTITUIDA,1,2)||','||SUBSTR(:CPR_NO_CONSTITUIDA,3,0)),';',' '), '\"',''),'''','')) END",
CPR_SOLICITUD_901 POSITION(1990:1997) DATE 'YYYYMMDD' NULLIF(CPR_SOLICITUD_901=BLANKS) "REPLACE(:CPR_SOLICITUD_901, '00000000', '')",
CPR_CATASTRO POSITION(1998:1999) INTEGER EXTERNAL NULLIF(CPR_CATASTRO=BLANKS) "CASE WHEN (:CPR_CATASTRO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_CATASTRO,1,2)||','||SUBSTR(:CPR_CATASTRO,3,0)),';',' '), '\"',''),'''','')) END",
CPR_CATASTRO_OBSERVACIONES POSITION(2000:2511) CHAR NULLIF(CPR_CATASTRO_OBSERVACIONES=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_CATASTRO_OBSERVACIONES),';',' '), '\"',''),'''','')",
CPR_PLUSVALIA_EXENTO POSITION(2512:2513) INTEGER EXTERNAL NULLIF(CPR_PLUSVALIA_EXENTO=BLANKS) "CASE WHEN (:CPR_PLUSVALIA_EXENTO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_PLUSVALIA_EXENTO,1,2)||','||SUBSTR(:CPR_PLUSVALIA_EXENTO,3,0)),';',' '), '\"',''),'''','')) END",
CPR_AUTOLIQUIDACION POSITION(2514:2515) INTEGER EXTERNAL NULLIF(CPR_AUTOLIQUIDACION=BLANKS) "CASE WHEN (:CPR_AUTOLIQUIDACION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_AUTOLIQUIDACION,1,2)||','||SUBSTR(:CPR_AUTOLIQUIDACION,3,0)),';',' '), '\"',''),'''','')) END",
CPR_F_ESCRITO_AYTO POSITION(2516:2517) INTEGER EXTERNAL NULLIF(CPR_F_ESCRITO_AYTO=BLANKS) "CASE WHEN (:CPR_F_ESCRITO_AYTO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CPR_F_ESCRITO_AYTO,1,2)||','||SUBSTR(:CPR_F_ESCRITO_AYTO,3,0)),';',' '), '\"',''),'''','')) END",
CPR_VENTA_OBSERVACIONES POSITION(2518:3029) CHAR NULLIF(CPR_VENTA_OBSERVACIONES=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:CPR_VENTA_OBSERVACIONES),';',' '), '\"',''),'''','')",
VALIDACION CONSTANT "0"
)




