--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210511
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13845
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Daniel Algaba - HREOS-13845 - Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
	  V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_CND_CONDICIONES_CONV_SAREB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ITEM VARCHAR2(2400 CHAR) := 'HREOS-13845';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('MOD_REM_TPA', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO AUX_TPA ON AUX_ACT.DD_TPA_ID = AUX_TPA.DD_TPA_ID AND AUX_TPA.BORRADO = 0 
                  WHERE NVL(UCC.VALOR,-1) != NVL(AUX_TPA.DD_TPA_CODIGO,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0')   
      , T_TIPO_DATA('MOD_REM_SAC', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO AUX_SAC ON AUX_ACT.DD_SAC_ID = AUX_SAC.DD_SAC_ID AND AUX_SAC.BORRADO = 0 
                  WHERE NVL(UCC.VALOR,-1) != NVL(AUX_SAC.DD_SAC_CODIGO,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0')        
      , T_TIPO_DATA('MOD_REM_FEC_INSCRIP', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0
                  WHERE UCC.VALOR IS NULL AND AUX_ACT.TIT_FECHA_INSC_REG IS NOT NULL OR UCC.VALOR IS NOT NULL AND AUX_ACT.TIT_FECHA_INSC_REG IS NULL OR TO_DATE(UCC.VALOR, ''''YYYY/MM/DD'''') != AUX_ACT.TIT_FECHA_INSC_REG
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0') 
      , T_TIPO_DATA('MOD_REM_DD_TVI', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON AUX_ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
                  JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA AUX_TVI ON BIE_LOC.DD_TVI_ID = AUX_TVI.DD_TVI_ID AND AUX_TVI.BORRADO = 0
                  WHERE NVL(UCC.VALOR,-1) != NVL(AUX_TVI.DD_TVI_CODIGO,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0')             
      , T_TIPO_DATA('MOD_REM_NOMBRE_VIA', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON AUX_ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
                  WHERE NVL(UCC.VALOR,-1) != NVL(BIE_LOC.BIE_LOC_NOMBRE_VIA,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0')    
      , T_TIPO_DATA('MOD_REM_NUM_DOMIC', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON AUX_ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
                  WHERE NVL(UCC.VALOR,-1) != NVL(BIE_LOC.BIE_LOC_NUMERO_DOMICILIO,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0')     
      , T_TIPO_DATA('MOD_REM_PISO', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON AUX_ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
                  WHERE NVL(UCC.VALOR,-1) != NVL(BIE_LOC.BIE_LOC_PISO,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0') 
      , T_TIPO_DATA('MOD_REM_PUERTA', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON AUX_ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
                  WHERE NVL(UCC.VALOR,-1) != NVL(BIE_LOC.BIE_LOC_PUERTA,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0') 
      , T_TIPO_DATA('MOD_REM_MUNICIPIO', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON AUX_ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
                  JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD AUX_LOC ON BIE_LOC.DD_LOC_ID = AUX_LOC.DD_LOC_ID AND AUX_LOC.BORRADO = 0
                  WHERE NVL(UCC.VALOR,-1) != NVL(AUX_LOC.DD_LOC_CODIGO,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0') 
      , T_TIPO_DATA('MOD_REM_COD_POSTAL', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON AUX_ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
                  WHERE NVL(UCC.VALOR,-1) != NVL(BIE_LOC.BIE_LOC_COD_POST,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0') 
      , T_TIPO_DATA('MOD_REM_LATITUD', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''''060''''
                  JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  WHERE NVL(TO_NUMBER(REPLACE(UCC.VALOR, ''''.'''','''','''')),-1) != NVL(AUX_ACT.LOC_LATITUD, -1)
                  AND AUX_ACT.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0') 
      , T_TIPO_DATA('MOD_REM_LONGITUD', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 AND COS.DD_COS_CODIGO = ''''062''''
                  JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  WHERE NVL(TO_NUMBER(REPLACE(UCC.VALOR, ''''.'''','''','''')),-1) != NVL(AUX_ACT.LOC_LONGITUD, -1)
                  AND AUX_ACT.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0') 
      , T_TIPO_DATA('MOD_REM_PROVINCIA', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON AUX_ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
                  JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA AUX_PRV ON BIE_LOC.DD_PRV_ID = AUX_PRV.DD_PRV_ID AND AUX_PRV.BORRADO = 0
                  WHERE NVL(UCC.VALOR,-1) != NVL(AUX_PRV.DD_PRV_CODIGO,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0') 
      , T_TIPO_DATA('MOD_REM_ESCALERA', 'Primera vez modificado en REM, deja de actualizarse', 'Si se han modificado los datos en REM, deja de actualizarse este campo con la información del Data Tape y permanece la de REM'
            ,'AND EXISTS (SELECT 1 
                  FROM '||V_ESQUEMA||'.UCC_ULTIMO_CAMBIO_CONV_SAREB UCC 
                  JOIN '||V_ESQUEMA||'.DD_COS_CAMPOS_ORIGEN_CONV_SAREB COS ON UCC.DD_COS_ID = COS.DD_COS_ID AND COS.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO AUX_ACT ON UCC.ACT_ID = AUX_ACT.ACT_ID AND AUX_ACT.BORRADO = 0 
                  JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE_LOC ON AUX_ACT.BIE_ID = BIE_LOC.BIE_ID AND BIE_LOC.BORRADO = 0
                  WHERE NVL(UCC.VALOR,-1) != NVL(BIE_LOC.BIE_LOC_ESCALERA,-1) 
                  AND COS.DD_COS_CODIGO = TMP.ORIGEN
                  AND UCC.ACT_ID = ACT.ACT_ID)'
            ,''
            ,'0') 
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
					WHERE DD_CND_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
          DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizamos '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
          
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
              SET
                DD_CND_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                DD_CND_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                QUERY = '''||TRIM(V_TMP_TIPO_DATA(4))||''',
                USUARIOMODIFICAR = '''||V_ITEM||''',
                FECHAMODIFICAR = SYSDATE,
                QUERY_ACT = '''||TRIM(V_TMP_TIPO_DATA(5))||''',
                BORRADO = '''||TRIM(V_TMP_TIPO_DATA(6))||'''
              WHERE 
                DD_CND_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
              ';
          
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha actualizado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||''''); 
        ELSE
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');

          DBMS_OUTPUT.PUT_LINE('[INFO]: '''||TRIM(V_TMP_TIPO_DATA(4))||'''');
            V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                            DD_CND_ID,
                            DD_CND_CODIGO,
                            DD_CND_DESCRIPCION,
                            DD_CND_DESCRIPCION_LARGA,
                            QUERY,
                            VERSION,
                            USUARIOCREAR,
                            FECHACREAR,
                            BORRADO,
                            QUERY_ACT	
              ) VALUES (
              '||V_ID||',
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              '''||TRIM(V_TMP_TIPO_DATA(4))||''',
              0,
              '''||V_ITEM||''',
              SYSDATE,
              '''||TRIM(V_TMP_TIPO_DATA(6))||''',
              '''||TRIM(V_TMP_TIPO_DATA(5))||''')';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
