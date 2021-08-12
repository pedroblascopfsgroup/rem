--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210811
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-14649
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade los datos del array en DD_MRR_MOTIVO_RECHAZO_REGISTRO
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'DD_MRR_MOTIVO_RECHAZO_REGISTRO';
    V_CHARS VARCHAR2(3 CHAR):= 'MRR';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-14649';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('F01','Activo sin tipo/subtipo activo','Activo sin tipo/subtipo activo',1,'LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV4 ON EQV4.DD_NOMBRE_CAIXA = ''''CLASE_USO'''' AND EQV4.DD_CODIGO_CAIXA = AUX.CLASE_USO AND EQV4.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_CODIGO = EQV4.DD_CODIGO_REM AND SAC.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV8 ON EQV8.DD_NOMBRE_CAIXA = ''''SUBTIPO_VIVIENDA''''  AND EQV8.DD_CODIGO_CAIXA = AUX.SUBTIPO_VIVIENDA AND EQV8.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC_VIV ON SAC_VIV.DD_SAC_CODIGO = EQV8.DD_CODIGO_REM AND SAC_VIV.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV9 ON EQV9.DD_NOMBRE_CAIXA = ''''SUBTIPO_SUELO''''  AND EQV9.DD_CODIGO_CAIXA = AUX.SUBTIPO_SUELO AND EQV9.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC_SUELO ON SAC_SUELO.DD_SAC_CODIGO = EQV9.DD_CODIGO_REM WHERE SAC.DD_SAC_ID IS NULL AND SAC_VIV.DD_SAC_ID IS NULL AND SAC_SUELO.DD_SAC_ID IS NULL'),
        T_TIPO_DATA('F02','Activo sin sociedad/subcartera','Activo sin sociedad/subcartera',1,'LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV2 ON EQV2.DD_NOMBRE_CAIXA = ''''SOCIEDAD_PATRIMONIAL''''  AND EQV2.DD_CODIGO_CAIXA = AUX.SOCIEDAD_PATRIMONIAL AND EQV2.DD_NOMBRE_REM = ''''DD_SCR_SUBCARTERA'''' and EQV2.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_CODIGO = EQV2.DD_CODIGO_REM WHERE SCR.DD_SCR_ID IS NULL'),
        T_TIPO_DATA('F03','Activo sin estado posesorio','Activo sin estado posesorio',1,'WHERE AUX.ESTADO_POSESORIO NOT IN (''''P01'''',''''P02'''',''''P03'''',''''P04'''',''''P05'''',''''P06'''')'),
        T_TIPO_DATA('F04','Activo sin estado titularidad','Activo sin estado titularidad',1,'LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV1 ON EQV1.DD_NOMBRE_CAIXA = ''''ESTADO_TITULARIDAD'''' AND EQV1.DD_CODIGO_CAIXA = AUX.ESTADO_TITULARIDAD AND EQV1.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO ETI ON ETI.DD_ETI_CODIGO = EQV1.DD_CODIGO_REM WHERE ETI.DD_ETI_ID IS NULL'),
        T_TIPO_DATA('F05','Activo sin tipo/subtipo título','Activo sin tipo/subtipo título',1,'LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''''ORIGEN_REGULATORIO'''' AND EQV.DD_CODIGO_CAIXA = AUX.ORIGEN_REGULATORIO AND EQV.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA_OR ON STA_OR.DD_STA_CODIGO = EQV.DD_CODIGO_REM LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV1 ON EQV1.DD_NOMBRE_CAIXA = ''''PRODUCTO''''  AND EQV1.DD_CODIGO_CAIXA = AUX.PRODUCTO AND EQV1.BORRADO=0 LEFT JOIN '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA_PR ON STA_PR.DD_STA_CODIGO = EQV1.DD_CODIGO_REM WHERE STA_OR.DD_STA_ID IS NULL AND STA_PR.DD_STA_ID IS NULL'),
        T_TIPO_DATA('F06','Activo de tipo Vivienda sin mapeo en campo Tipo vivienda','Activo de tipo Vivienda sin mapeo en campo Tipo vivienda',1,'LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV8 ON EQV8.DD_NOMBRE_CAIXA = ''''SUBTIPO_VIVIENDA'''' AND EQV8.DD_CODIGO_CAIXA = AUX.SUBTIPO_VIVIENDA AND EQV8.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC_VIV ON SAC_VIV.DD_SAC_CODIGO = EQV8.DD_CODIGO_REM AND SAC_VIV.BORRADO = 0 WHERE AUX.CLASE_USO = ''''0001'''' AND SAC_VIV.DD_SAC_ID IS NULL'),
        T_TIPO_DATA('F07','Activo de tipo Suelo sin mapeo en campo Tipo suelo','Activo de tipo Suelo sin mapeo en campo Tipo suelo',1,'LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV9 ON EQV9.DD_NOMBRE_CAIXA = ''''SUBTIPO_SUELO'''' AND EQV9.DD_CODIGO_CAIXA = AUX.SUBTIPO_SUELO AND EQV9.BORRADO = 0 LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC_SUELO ON SAC_SUELO.DD_SAC_CODIGO = EQV9.DD_CODIGO_REM WHERE AUX.CLASE_USO IN (''''0007'''',''''0008'''') AND SAC_SUELO.DD_SAC_ID IS NULL'),
        T_TIPO_DATA('F08','Activo sin número identificativo BC','Activo sin número identificativo BC',1,'WHERE AUX.NUM_IDENTIFICATIVO IS NULL'),
        T_TIPO_DATA('F09','Activo sin número de inmueble existente ya en REM','Activo sin número de inmueble existente ya en REM',1,'WHERE AUX.FLAG_EN_REM = 1 AND AUX.NUM_INMUEBLE IS NULL'),
        -- Validación de fechas
        T_TIPO_DATA('F10','Formato de fecha del campo FEC_VALIDO_DE incorrecto','Formato de fecha del campo FEC_VALIDO_DE incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_VALIDO_DE, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F11','Formato de fecha del campo FEC_VALIDO_A incorrecto','Formato de fecha del campo FEC_VALIDO_A incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_VALIDO_A, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F12','Formato de fecha del campo FEC_PRESENTACION_REGISTRO incorrecto','Formato de fecha del campo FEC_PRESENTACION_REGISTRO incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_PRESENTACION_REGISTRO, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F13','Formato de fecha del campo FEC_INSC_TITULO incorrecto','Formato de fecha del campo FEC_INSC_TITULO incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_INSC_TITULO, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F14','Formato de fecha del campo FEC_ADJUDICACION incorrecto','Formato de fecha del campo FEC_ADJUDICACION incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_ADJUDICACION, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F15','Formato de fecha del campo FEC_TITULO_FIRME incorrecto','Formato de fecha del campo FEC_TITULO_FIRME incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_TITULO_FIRME, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F16','Formato de fecha del campo FEC_CESION_REMATE incorrecto','Formato de fecha del campo FEC_CESION_REMATE incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_CESION_REMATE, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F17','Formato de fecha del campo FEC_PRESENTADO incorrecto','Formato de fecha del campo FEC_PRESENTADO incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_PRESENTADO, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F18','Formato de fecha del campo FEC_RECEP_LLAVES incorrecto','Formato de fecha del campo FEC_RECEP_LLAVES incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_RECEP_LLAVES, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F19','Formato de fecha del campo FEC_ESTADO_TITULARIDAD incorrecto','Formato de fecha del campo FEC_ESTADO_TITULARIDAD incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_ESTADO_TITULARIDAD, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F20','Formato de fecha del campo FEC_ESTADO_POSESORIO incorrecto','Formato de fecha del campo FEC_ESTADO_POSESORIO incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_ESTADO_POSESORIO, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F21','Formato de fecha del campo FEC_ESTADO_COMERCIAL_ALQUILER incorrecto','Formato de fecha del campo FEC_ESTADO_COMERCIAL_ALQUILER incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_ESTADO_COMERCIAL_ALQUILER, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F22','Formato de fecha del campo FEC_ESTADO_COMERCIAL_VENTA incorrecto','Formato de fecha del campo FEC_ESTADO_COMERCIAL_VENTA incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_ESTADO_COMERCIAL_VENTA, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F23','Formato de fecha del campo FEC_ESTADO_TECNICO incorrecto','Formato de fecha del campo FEC_ESTADO_TECNICO incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_ESTADO_TECNICO, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F24','Formato de fecha del campo FEC_INICIO_CONCURENCIA incorrecto','Formato de fecha del campo FEC_INICIO_CONCURENCIA incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_INICIO_CONCURENCIA, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F25','Formato de fecha del campo FEC_FIN_CONCURENCIA incorrecto','Formato de fecha del campo FEC_FIN_CONCURENCIA incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_FIN_CONCURENCIA, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F26','Formato de fecha del campo FEC_VISITA_INMB_SERVICER incorrecto','Formato de fecha del campo FEC_VISITA_INMB_SERVICER incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_VISITA_INMB_SERVICER, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F27','Formato de fecha del campo FEC_PUBLICACION_SERVICER incorrecto','Formato de fecha del campo FEC_PUBLICACION_SERVICER incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_PUBLICACION_SERVICER, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F28','Formato de fecha del campo FEC_FIN_CONCESION incorrecto','Formato de fecha del campo FEC_FIN_CONCESION incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_FIN_CONCESION, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F29','Formato de fecha del campo FEC_SOLICITUD incorrecto','Formato de fecha del campo FEC_SOLICITUD incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_SOLICITUD, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F30','Formato de fecha del campo FEC_FIN_VIGENCIA incorrecto','Formato de fecha del campo FEC_FIN_VIGENCIA incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_FIN_VIGENCIA, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F31','Formato de fecha del campo FEC_INICIO_PRECIO_VENTA incorrecto','Formato de fecha del campo FEC_INICIO_PRECIO_VENTA incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_INICIO_PRECIO_VENTA, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F32','Formato de fecha del campo FEC_FIN_PRECIO_VENTA incorrecto','Formato de fecha del campo FEC_FIN_PRECIO_VENTA incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_FIN_PRECIO_VENTA, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F33','Formato de fecha del campo FEC_INICIO_PRECIO_ALQUI incorrecto','Formato de fecha del campo FEC_INICIO_PRECIO_ALQUI incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_INICIO_PRECIO_ALQUI, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F34','Formato de fecha del campo FEC_FIN_PRECIO_ALQUI incorrecto','Formato de fecha del campo FEC_FIN_PRECIO_ALQUI incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_FIN_PRECIO_ALQUI, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F35','Formato de fecha del campo FEC_INICIO_PRECIO_CAMP_VENTA incorrecto','Formato de fecha del campo FEC_INICIO_PRECIO_CAMP_VENTA incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_INICIO_PRECIO_CAMP_VENTA, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F36','Formato de fecha del campo FEC_FIN_PRECIO_CAMP_VENTA incorrecto','Formato de fecha del campo FEC_FIN_PRECIO_CAMP_VENTA incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_FIN_PRECIO_CAMP_VENTA, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F37','Formato de fecha del campo FEC_INICIO_PRECIO_CAMP_ALQUI incorrecto','Formato de fecha del campo FEC_INICIO_PRECIO_CAMP_ALQUI incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_INICIO_PRECIO_CAMP_ALQUI, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F38','Formato de fecha del campo FEC_FIN_PRECIO_CAMP_ALQUI incorrecto','Formato de fecha del campo FEC_FIN_PRECIO_CAMP_ALQUI incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_FIN_PRECIO_CAMP_ALQUI, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F39','Formato de fecha del campo FEC_POSESION incorrecto','Formato de fecha del campo FEC_POSESION incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_POSESION, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F40','Formato de fecha del campo FEC_SENYAL_LANZAMIENTO incorrecto','Formato de fecha del campo FEC_SENYAL_LANZAMIENTO incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_SENYAL_LANZAMIENTO, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F41','Formato de fecha del campo FEC_LANZAMIENTO incorrecto','Formato de fecha del campo FEC_LANZAMIENTO incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_LANZAMIENTO, ''''yyyymmdd'''')'),
        T_TIPO_DATA('F42','Formato de fecha del campo FEC_RESOLUCION_MORA incorrecto','Formato de fecha del campo FEC_RESOLUCION_MORA incorrecto',1,'WHERE 0 = IS_VALIDATE_DATE(AUX.FEC_RESOLUCION_MORA, ''''yyyymmdd'''')'),
        -- Validación numéricos
        T_TIPO_DATA('F43','Formato numérico del campo CUOTA incorrecto','Formato numérico del campo CUOTA incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.CUOTA)'),
        T_TIPO_DATA('F44','Formato numérico del campo IMPORTE_CESION incorrecto','Formato numérico del campo IMPORTE_CESION incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.IMPORTE_CESION)'),
        T_TIPO_DATA('F45','Formato numérico del campo VALORES_EMISIONES incorrecto','Formato numérico del campo VALORES_EMISIONES incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.VALORES_EMISIONES)'),
        T_TIPO_DATA('F46','Formato numérico del campo VALOR_ENERGIA incorrecto','Formato numérico del campo VALOR_ENERGIA incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.VALOR_ENERGIA)'),
        T_TIPO_DATA('F47','Formato numérico del campo PRECIO_MAX_MOD_VENTA incorrecto','Formato numérico del campo PRECIO_MAX_MOD_VENTA incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.PRECIO_MAX_MOD_VENTA)'),
        T_TIPO_DATA('F48','Formato numérico del campo PRECIO_MAX_MOD_ALQUILER incorrecto','Formato numérico del campo PRECIO_MAX_MOD_ALQUILER incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.PRECIO_MAX_MOD_ALQUILER)'),
        T_TIPO_DATA('F49','Formato numérico del campo SUP_TASACION_SOLAR incorrecto','Formato numérico del campo SUP_TASACION_SOLAR incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.SUP_TASACION_SOLAR)'),
        T_TIPO_DATA('F50','Formato numérico del campo PORC_OBRA_EJECUTADA incorrecto','Formato numérico del campo PORC_OBRA_EJECUTADA incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.PORC_OBRA_EJECUTADA)'),
        T_TIPO_DATA('F51','Formato numérico del campo SUP_TASACION_UTIL incorrecto','Formato numérico del campo SUP_TASACION_UTIL incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.SUP_TASACION_UTIL)'),
        T_TIPO_DATA('F52','Formato numérico del campo SUP_REGISTRAL_UTIL incorrecto','Formato numérico del campo SUP_REGISTRAL_UTIL incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.SUP_REGISTRAL_UTIL)'),
        T_TIPO_DATA('F53','Formato numérico del campo SUP_TASACION_CONSTRUIDA incorrecto','Formato numérico del campo SUP_TASACION_CONSTRUIDA incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.SUP_TASACION_CONSTRUIDA)'),
        T_TIPO_DATA('F54','Formato numérico del campo NUM_HABITACIONES incorrecto','Formato numérico del campo NUM_HABITACIONES incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.NUM_HABITACIONES)'),
        T_TIPO_DATA('F55','Formato numérico del campo NUM_BANYOS incorrecto','Formato numérico del campo NUM_BANYOS incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.NUM_BANYOS)'),
        T_TIPO_DATA('F56','Formato numérico del campo NUM_TERRAZAS incorrecto','Formato numérico del campo NUM_TERRAZAS incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.NUM_TERRAZAS)'),
        T_TIPO_DATA('F57','Formato numérico del campo SUP_SOBRE_RASANTE incorrecto','Formato numérico del campo SUP_SOBRE_RASANTE incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.SUP_SOBRE_RASANTE)'),
        T_TIPO_DATA('F58','Formato numérico del campo SUP_BAJO_RASANTE incorrecto','Formato numérico del campo SUP_BAJO_RASANTE incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.SUP_BAJO_RASANTE)'),
        T_TIPO_DATA('F50','Formato numérico del campo NUM_APARACAMIENTOS incorrecto','Formato numérico del campo NUM_APARACAMIENTOS incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.NUM_APARACAMIENTOS)'),
        T_TIPO_DATA('F60','Formato numérico del campo IMP_PRECIO_VENTA incorrecto','Formato numérico del campo IMP_PRECIO_VENTA incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.IMP_PRECIO_VENTA)'),
        T_TIPO_DATA('F61','Formato numérico del campo IMP_PRECIO_ALQUI incorrecto','Formato numérico del campo IMP_PRECIO_ALQUI incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.IMP_PRECIO_ALQUI)'),
        T_TIPO_DATA('F62','Formato numérico del campo IMP_PRECIO_CAMP_ALQUI incorrecto','Formato numérico del campo IMP_PRECIO_CAMP_ALQUI incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.IMP_PRECIO_CAMP_ALQUI)'),
        T_TIPO_DATA('F63','Formato numérico del campo IMP_PRECIO_CAMP_VENTA incorrecto','Formato numérico del campo IMP_PRECIO_CAMP_VENTA incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.IMP_PRECIO_CAMP_VENTA)'),
        T_TIPO_DATA('F64','Formato numérico del campo IMP_PRECIO_REF_ALQUI incorrecto','Formato numérico del campo IMP_PRECIO_REF_ALQUI incorrecto',1,'WHERE 0 = IS_NUMERIC_WITHOUT_DECIMALS(AUX.IMP_PRECIO_REF_ALQUI)'),

        T_TIPO_DATA('F65','Activo sin fecha FEC_ESTADO_TITULARIDAD obligatoria','Activo sin fecha FEC_ESTADO_TITULARIDAD obligatoria',1,'WHERE AUX.FEC_ESTADO_TITULARIDAD IS NULL'),
        T_TIPO_DATA('F66','Activo sin fecha FEC_ESTADO_POSESORIO obligatoria','Activo sin fecha FEC_ESTADO_POSESORIO obligatoria',1,'WHERE AUX.FEC_ESTADO_POSESORIO IS NULL')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        V_MSQL := '
          UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
          SET 
            DD_'||V_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
            DD_'||V_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
            , PROCESO_VALIDAR = '||TRIM(V_TMP_TIPO_DATA(4))||'
            , QUERY_ITER = '''||TRIM(V_TMP_TIPO_DATA(5))||'''
            , USUARIOMODIFICAR = '''||V_USUARIO||'''
            , FECHAMODIFICAR = SYSDATE
			    WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        
      --Si no existe, lo insertamos   
      ELSE
              DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
        
        V_MSQL := '
          	INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' (
				DD_'||V_CHARS||'_ID
        , DD_'||V_CHARS||'_CODIGO
        , DD_'||V_CHARS||'_DESCRIPCION
        , DD_'||V_CHARS||'_DESCRIPCION_LARGA
        , PROCESO_VALIDAR
        , QUERY_ITER
        ,	VERSION
        , USUARIOCREAR
        , FECHACREAR)
          	SELECT 
	            '|| V_ID || ',
	            '''||V_TMP_TIPO_DATA(1)||'''
              ,	'''||V_TMP_TIPO_DATA(2)||'''
              ,	'''||V_TMP_TIPO_DATA(3)||'''
              ,	'||V_TMP_TIPO_DATA(4)||'
              , '''||V_TMP_TIPO_DATA(5)||'''
              , 0
              , '''||V_USUARIO||'''
              , SYSDATE 
              FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
      
      END IF;

    END LOOP;
  COMMIT;
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
