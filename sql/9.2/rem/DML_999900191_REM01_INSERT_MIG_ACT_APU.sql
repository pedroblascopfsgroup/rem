--/*
--##########################################
--## AUTOR=DANIEL ALGABA
--## FECHA_CREACION=20180426
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3890
--## PRODUCTO=NO
--##
--## Finalidad: Script que migra el estado de publicación actual a la ACT_APU_ACTIVO_PUBLICACION
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
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCIÓN EN ACT_APU_ACTIVO_PUBLICACION');
    
        --Comprobamos que la tabla existe
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe, truncamos la tabla e insertamos
        IF V_NUM_TABLAS > 0 THEN

          DBMS_OUTPUT.PUT_LINE('[INFO]: EXISTE LA TABLA ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||', SE PROCEDE A TRUNCAR');
          EXECUTE IMMEDIATE ' TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';  
          DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' TRUNCADA');			
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS REGISTROS EN LA TABLA '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');

          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS ACTIVOS CON ESTADO COMERCIAL DE VENTA');
          EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                      (
                        APU_ID
                        ,ACT_ID
                        ,DD_EPV_ID
                        ,DD_EPA_ID,DD_TCO_ID
                        ,DD_MTO_V_ID
                        ,APU_MOT_OCULTACION_MANUAL_V
                        ,APU_CHECK_PUBLICAR_V
                        ,APU_CHECK_OCULTAR_V
                        ,APU_CHECK_OCULTAR_PRECIO_V
                        ,APU_CHECK_PUB_SIN_PRECIO_V
                        ,DD_MTO_A_ID
                        ,APU_MOT_OCULTACION_MANUAL_A
                        ,APU_CHECK_PUBLICAR_A
                        ,APU_CHECK_OCULTAR_A
                        ,APU_CHECK_OCULTAR_PRECIO_A
                        ,APU_CHECK_PUB_SIN_PRECIO_A
                        ,APU_FECHA_INI_VENTA
                        ,APU_FECHA_INI_ALQUILER
                        ,VERSION
                        ,USUARIOCREAR
                        ,FECHACREAR
                        ,USUARIOMODIFICAR
                        ,FECHAMODIFICAR
                        ,USUARIOBORRAR
                        ,FECHABORRAR
                        ,BORRADO
                        ,DD_TPU_V_ID
                        ,DD_TPU_A_ID
                      )
                    SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                        ,ACT_ID
                        ,DD_EPV_ID
                        ,DD_EPA_ID,DD_TCO_ID
                        ,DD_MTO_V_ID
                        ,APU_MOT_OCULTACION_MANUAL_V
                        ,APU_CHECK_PUBLICAR_V
                        ,APU_CHECK_OCULTAR_V
                        ,APU_CHECK_OCULTAR_PRECIO_V
                        ,APU_CHECK_PUB_SIN_PRECIO_V
                        ,DD_MTO_A_ID
                        ,APU_MOT_OCULTACION_MANUAL_A
                        ,APU_CHECK_PUBLICAR_A
                        ,APU_CHECK_OCULTAR_A
                        ,APU_CHECK_OCULTAR_PRECIO_A
                        ,APU_CHECK_PUB_SIN_PRECIO_A
                        ,APU_FECHA_INI_VENTA
                        ,APU_FECHA_INI_ALQUILER
                        ,VERSION
                        ,USUARIOCREAR
                        ,FECHACREAR
                        ,USUARIOMODIFICAR
                        ,FECHAMODIFICAR
                        ,USUARIOBORRAR
                        ,FECHABORRAR
                        ,BORRADO
                        ,DD_TPU_V_ID
                        ,DD_TPU_A_ID
                    FROM(
                        SELECT  
                          ACT.ACT_ID
                          , (SELECT DDEPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA DDEPV WHERE DDEPV.DD_EPV_CODIGO = (SELECT TMP.DD_EPV_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_EPV_ID
                          , (SELECT DDEPA.DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER DDEPA WHERE DDEPA.DD_EPA_CODIGO = ''01'') DD_EPA_ID
                          , ACT.DD_TCO_ID
                          , (SELECT DDMTO.DD_MTO_ID FROM '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION DDMTO WHERE DDMTO.DD_MTO_CODIGO = (SELECT TMP.DD_MTO_V_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_MTO_V_ID
                          , (SELECT TMP.MTO_OCULTACION FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_MOT_OCULTACION_MANUAL_V
                          , (SELECT TMP.APU_CHECK_PUBLICAR_V FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_PUBLICAR_V
                          , (SELECT TMP.APU_CHECK_OCULTAR_V FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_OCULTAR_V
                          , (SELECT TMP.APU_CHECK_OCULT_PRECIO_V FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_OCULTAR_PRECIO_V
                          , (SELECT TMP.APU_CHECK_PUB_SIN_PRECIO_V FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_PUB_SIN_PRECIO_V
                          , NULL DD_MTO_A_ID
                          , NULL APU_MOT_OCULTACION_MANUAL_A
                          , 0 APU_CHECK_PUBLICAR_A
                          , 0 APU_CHECK_OCULTAR_A
                          , 0 APU_CHECK_OCULTAR_PRECIO_A
                          , 0 APU_CHECK_PUB_SIN_PRECIO_A 
                          , HEP.HEP_FECHA_DESDE APU_FECHA_INI_VENTA
                          , NULL APU_FECHA_INI_ALQUILER
                          , HEP.VERSION
                          , HEP.USUARIOCREAR
                          , HEP.FECHACREAR
                          , HEP.USUARIOMODIFICAR
                          , HEP.FECHAMODIFICAR
                          , HEP.USUARIOBORRAR
                          , HEP.FECHABORRAR
                          , HEP.BORRADO
                          , (SELECT DDTPU.DD_TPU_ID FROM '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION DDTPU WHERE DDTPU.DD_TPU_CODIGO = (SELECT TMP.DD_TPU_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_TPU_V_ID
                          , NULL DD_TPU_A_ID    
                          , ROW_NUMBER () OVER (PARTITION BY HEP.ACT_ID ORDER BY HEP.HEP_FECHA_DESDE DESC) ROWNUMBER
                      FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP
                      JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = HEP.ACT_ID AND ACT.BORRADO = 0
                      LEFT JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION DDEPU ON DDEPU.DD_EPU_ID = HEP.DD_EPU_ID AND DDEPU.BORRADO = 0
                      WHERE HEP.BORRADO = 0
                          AND EXISTS (SELECT 1
                                    FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO
                                   WHERE DDTCO.DD_TCO_CODIGO IN (''01'')
                                     AND DDTCO.BORRADO = 0
                                     AND DDTCO.DD_TCO_ID = ACT.DD_TCO_ID
                                  )
                          AND HEP.HEP_FECHA_HASTA IS NULL) AUX WHERE AUX.ROWNUMBER = 1';

          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');

          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS ACTIVOS CON ESTADO COMERCIAL DE ALQUILER');
          EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                      (
                        APU_ID
                        ,ACT_ID
                        ,DD_EPV_ID
                        ,DD_EPA_ID,DD_TCO_ID
                        ,DD_MTO_V_ID
                        ,APU_MOT_OCULTACION_MANUAL_V
                        ,APU_CHECK_PUBLICAR_V
                        ,APU_CHECK_OCULTAR_V
                        ,APU_CHECK_OCULTAR_PRECIO_V
                        ,APU_CHECK_PUB_SIN_PRECIO_V
                        ,DD_MTO_A_ID
                        ,APU_MOT_OCULTACION_MANUAL_A
                        ,APU_CHECK_PUBLICAR_A
                        ,APU_CHECK_OCULTAR_A
                        ,APU_CHECK_OCULTAR_PRECIO_A
                        ,APU_CHECK_PUB_SIN_PRECIO_A
                        ,APU_FECHA_INI_VENTA
                        ,APU_FECHA_INI_ALQUILER
                        ,VERSION
                        ,USUARIOCREAR
                        ,FECHACREAR
                        ,USUARIOMODIFICAR
                        ,FECHAMODIFICAR
                        ,USUARIOBORRAR
                        ,FECHABORRAR
                        ,BORRADO
                        ,DD_TPU_V_ID
                        ,DD_TPU_A_ID
                      )
                    SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                        ,ACT_ID
                        ,DD_EPV_ID
                        ,DD_EPA_ID,DD_TCO_ID
                        ,DD_MTO_V_ID
                        ,APU_MOT_OCULTACION_MANUAL_V
                        ,APU_CHECK_PUBLICAR_V
                        ,APU_CHECK_OCULTAR_V
                        ,APU_CHECK_OCULTAR_PRECIO_V
                        ,APU_CHECK_PUB_SIN_PRECIO_V
                        ,DD_MTO_A_ID
                        ,APU_MOT_OCULTACION_MANUAL_A
                        ,APU_CHECK_PUBLICAR_A
                        ,APU_CHECK_OCULTAR_A
                        ,APU_CHECK_OCULTAR_PRECIO_A
                        ,APU_CHECK_PUB_SIN_PRECIO_A
                        ,APU_FECHA_INI_VENTA
                        ,APU_FECHA_INI_ALQUILER
                        ,VERSION
                        ,USUARIOCREAR
                        ,FECHACREAR
                        ,USUARIOMODIFICAR
                        ,FECHAMODIFICAR
                        ,USUARIOBORRAR
                        ,FECHABORRAR
                        ,BORRADO
                        ,DD_TPU_V_ID
                        ,DD_TPU_A_ID
                    FROM(
                      SELECT  ACT.ACT_ID
                        , (SELECT DDEPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA DDEPV WHERE DDEPV.DD_EPV_CODIGO = ''01'') DD_EPV_ID
                        , (SELECT DDEPA.DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER DDEPA WHERE DDEPA.DD_EPA_CODIGO = (SELECT TMP.DD_EPA_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_EPA_ID
                        , ACT.DD_TCO_ID
                        , NULL DD_MTO_V_ID
                        , NULL APU_MOT_OCULTACION_MANUAL_V
                        , 0 APU_CHECK_PUBLICAR_V
                        , 0 APU_CHECK_OCULTAR_V
                        , 0 APU_CHECK_OCULTAR_PRECIO_V
                        , 0 APU_CHECK_PUB_SIN_PRECIO_V
                        , (SELECT DDMTO.DD_MTO_ID FROM '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION DDMTO WHERE DDMTO.DD_MTO_CODIGO = (SELECT TMP.DD_MTO_A_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_MTO_A_ID
                        , (SELECT TMP.MTO_OCULTACION FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_MOT_OCULTACION_MANUAL_A
                        , (SELECT TMP.APU_CHECK_PUBLICAR_A FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_PUBLICAR_A
                        , (SELECT TMP.APU_CHECK_OCULTAR_A FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_OCULTAR_A
                        , (SELECT TMP.APU_CHECK_OCULT_PRECIO_A FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_OCULTAR_PRECIO_A
                        , (SELECT TMP.APU_CHECK_PUB_SIN_PRECIO_A FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_PUB_SIN_PRECIO_A 
                        , NULL APU_FECHA_INI_VENTA
                        , HEP.HEP_FECHA_DESDE APU_FECHA_INI_ALQUILER
                        , HEP.VERSION
                        , HEP.USUARIOCREAR
                        , HEP.FECHACREAR
                        , HEP.USUARIOMODIFICAR
                        , HEP.FECHAMODIFICAR
                        , HEP.USUARIOBORRAR
                        , HEP.FECHABORRAR
                        , HEP.BORRADO 
                        , NULL DD_TPU_V_ID
                        , (SELECT DDTPU.DD_TPU_ID FROM '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION DDTPU WHERE DDTPU.DD_TPU_CODIGO = (SELECT TMP.DD_TPU_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_TPU_A_ID   
                        , ROW_NUMBER () OVER (PARTITION BY HEP.ACT_ID ORDER BY HEP.HEP_FECHA_DESDE DESC) ROWNUMBER
                    FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = HEP.ACT_ID AND ACT.BORRADO = 0
                    LEFT JOIN ' ||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION DDEPU ON DDEPU.DD_EPU_ID = HEP.DD_EPU_ID AND DDEPU.BORRADO = 0
                    WHERE HEP.BORRADO = 0
                        AND EXISTS (SELECT 1
                                  FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO
                                 WHERE DDTCO.DD_TCO_CODIGO IN (''03'',''04'')
                                   AND DDTCO.BORRADO = 0
                                   AND DDTCO.DD_TCO_ID = ACT.DD_TCO_ID
                                )
                        AND HEP.HEP_FECHA_HASTA IS NULL) AUX WHERE AUX.ROWNUMBER = 1';

          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');

          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS ACTIVOS CON ESTADO COMERCIAL DE ALQUILER Y VENTA');
          EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                      (
                        APU_ID
                        ,ACT_ID
                        ,DD_EPV_ID
                        ,DD_EPA_ID,DD_TCO_ID
                        ,DD_MTO_V_ID
                        ,APU_MOT_OCULTACION_MANUAL_V
                        ,APU_CHECK_PUBLICAR_V
                        ,APU_CHECK_OCULTAR_V
                        ,APU_CHECK_OCULTAR_PRECIO_V
                        ,APU_CHECK_PUB_SIN_PRECIO_V
                        ,DD_MTO_A_ID
                        ,APU_MOT_OCULTACION_MANUAL_A
                        ,APU_CHECK_PUBLICAR_A
                        ,APU_CHECK_OCULTAR_A
                        ,APU_CHECK_OCULTAR_PRECIO_A
                        ,APU_CHECK_PUB_SIN_PRECIO_A
                        ,APU_FECHA_INI_VENTA
                        ,APU_FECHA_INI_ALQUILER
                        ,VERSION
                        ,USUARIOCREAR
                        ,FECHACREAR
                        ,USUARIOMODIFICAR
                        ,FECHAMODIFICAR
                        ,USUARIOBORRAR
                        ,FECHABORRAR
                        ,BORRADO
                      )
                    SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                        ,ACT_ID
                        ,DD_EPV_ID
                        ,DD_EPA_ID,DD_TCO_ID
                        ,DD_MTO_V_ID
                        ,APU_MOT_OCULTACION_MANUAL_V
                        ,APU_CHECK_PUBLICAR_V
                        ,APU_CHECK_OCULTAR_V
                        ,APU_CHECK_OCULTAR_PRECIO_V
                        ,APU_CHECK_PUB_SIN_PRECIO_V
                        ,DD_MTO_A_ID
                        ,APU_MOT_OCULTACION_MANUAL_A
                        ,APU_CHECK_PUBLICAR_A
                        ,APU_CHECK_OCULTAR_A
                        ,APU_CHECK_OCULTAR_PRECIO_A
                        ,APU_CHECK_PUB_SIN_PRECIO_A
                        ,APU_FECHA_INI_VENTA
                        ,APU_FECHA_INI_ALQUILER
                        ,VERSION
                        ,USUARIOCREAR
                        ,FECHACREAR
                        ,USUARIOMODIFICAR
                        ,FECHAMODIFICAR
                        ,USUARIOBORRAR
                        ,FECHABORRAR
                        ,BORRADO
                    FROM(
                      SELECT  ACT.ACT_ID
                        , (SELECT DDEPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA DDEPV WHERE DDEPV.DD_EPV_CODIGO = (SELECT TMP.DD_EPV_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_EPV_ID
                        , (SELECT DDEPA.DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER DDEPA WHERE DDEPA.DD_EPA_CODIGO = (SELECT TMP.DD_EPA_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_EPA_ID
                        , ACT.DD_TCO_ID
                        , (SELECT DDMTO.DD_MTO_ID FROM '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION DDMTO WHERE DDMTO.DD_MTO_CODIGO = (SELECT TMP.DD_MTO_V_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_MTO_V_ID
                        , (SELECT TMP.MTO_OCULTACION FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_MOT_OCULTACION_MANUAL_V
                        , (SELECT TMP.APU_CHECK_PUBLICAR_V FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_PUBLICAR_V
                        , (SELECT TMP.APU_CHECK_OCULTAR_V FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_OCULTAR_V
                        , (SELECT TMP.APU_CHECK_OCULT_PRECIO_V FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_OCULTAR_PRECIO_V
                        , (SELECT TMP.APU_CHECK_PUB_SIN_PRECIO_V FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_PUB_SIN_PRECIO_V
                        , (SELECT DDMTO.DD_MTO_ID FROM '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION DDMTO WHERE DDMTO.DD_MTO_CODIGO = (SELECT TMP.DD_MTO_A_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_MTO_A_ID
                        , (SELECT TMP.MTO_OCULTACION FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_MOT_OCULTACION_MANUAL_A
                        , (SELECT TMP.APU_CHECK_PUBLICAR_A FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_PUBLICAR_A
                        , (SELECT TMP.APU_CHECK_OCULTAR_A FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_OCULTAR_A
                        , (SELECT TMP.APU_CHECK_OCULT_PRECIO_A FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_OCULTAR_PRECIO_A
                        , (SELECT TMP.APU_CHECK_PUB_SIN_PRECIO_A FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO) APU_CHECK_PUB_SIN_PRECIO_A 
                        , HEP.HEP_FECHA_DESDE APU_FECHA_INI_VENTA
                        , HEP.HEP_FECHA_DESDE APU_FECHA_INI_ALQUILER
                        , HEP.VERSION
                        , HEP.USUARIOCREAR
                        , HEP.FECHACREAR
                        , HEP.USUARIOMODIFICAR
                        , HEP.FECHAMODIFICAR
                        , HEP.USUARIOBORRAR
                        , HEP.FECHABORRAR
                        , HEP.BORRADO
                        , (SELECT DDTPU.DD_TPU_ID FROM '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION DDTPU WHERE DDTPU.DD_TPU_CODIGO = (SELECT TMP.DD_TPU_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_VENTA TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_TPU_V_ID
                        , (SELECT DDTPU.DD_TPU_ID FROM '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION DDTPU WHERE DDTPU.DD_TPU_CODIGO = (SELECT TMP.DD_TPU_CODIGO FROM '||V_ESQUEMA||'.TMP_MAPEO_PUB_ALQUILER TMP WHERE TMP.DD_EPU_CODIGO = DDEPU.DD_EPU_CODIGO)) DD_TPU_A_ID    
                        , ROW_NUMBER () OVER (PARTITION BY HEP.ACT_ID ORDER BY HEP.HEP_FECHA_DESDE DESC) ROWNUMBER
                      FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP
                      JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = HEP.ACT_ID AND ACT.BORRADO = 0
                      LEFT JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION DDEPU ON DDEPU.DD_EPU_ID = HEP.DD_EPU_ID AND DDEPU.BORRADO = 0
                      WHERE HEP.BORRADO = 0
                          AND EXISTS (SELECT 1
                                    FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION DDTCO
                                   WHERE DDTCO.DD_TCO_CODIGO IN (''02'')
                                     AND DDTCO.BORRADO = 0
                                     AND DDTCO.DD_TCO_ID = ACT.DD_TCO_ID
                                  )
                          AND HEP.HEP_FECHA_HASTA IS NULL) AUX WHERE AUX.ROWNUMBER = 1';

          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');

          -- Pasamos las estadísticas
          DBMS_OUTPUT.PUT_LINE('[INFO]: PASAMOS LAS ESTADÍSTICAS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');
          EXECUTE IMMEDIATE 'ANALYZE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' COMPUTE STATISTICS';


          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS ACTIVOS NO PUBLICADOS DE VENTA');


          EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' APU 
            USING 
              (
              SELECT HEP.ACT_ID 
              FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP
              JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION EPU ON HEP.DD_EPU_ID = EPU.DD_EPU_ID
              WHERE ACT_ID IN 
                (
                  SELECT CNT.ACT_ID 
                  FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION CNT
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = CNT.ACT_ID AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON ACT.DD_TCO_ID = TCO.DD_TCO_ID
                  WHERE CNT.BORRADO = 0 AND TCO.DD_TCO_CODIGO = ''01''
                  GROUP BY CNT.ACT_ID
                  HAVING COUNT(CNT.ACT_ID) = 1
                ) 
                AND EPU.DD_EPU_CODIGO = ''06''
              ) HIS
            ON (APU.ACT_ID = HIS.ACT_ID)
            WHEN MATCHED THEN
            UPDATE SET
             APU.DD_EPV_ID = (SELECT DDEPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA DDEPV WHERE DDEPV.DD_EPV_CODIGO = ''01''),
             APU.APU_CHECK_PUBLICAR_V = 0,
             APU.APU_CHECK_OCULTAR_V = 0,
             APU.DD_MTO_V_ID = NULL,
             APU.APU_MOT_OCULTACION_MANUAL_V = NULL';

          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');

          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS ACTIVOS NO PUBLICADOS DE ALQUILER');

          EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' APU 
            USING 
              (
                SELECT HEP.ACT_ID 
                FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP
                JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION EPU ON HEP.DD_EPU_ID = EPU.DD_EPU_ID
                WHERE ACT_ID IN (
                SELECT CNT.ACT_ID 
                FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION CNT
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = CNT.ACT_ID AND ACT.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON ACT.DD_TCO_ID = TCO.DD_TCO_ID
                WHERE CNT.BORRADO = 0 AND TCO.DD_TCO_CODIGO IN (''03'',''04'')
                GROUP BY CNT.ACT_ID
                HAVING COUNT(CNT.ACT_ID) = 1) 
                AND EPU.DD_EPU_CODIGO = ''06''
              ) HIS
          ON (APU.ACT_ID = HIS.ACT_ID)
          WHEN MATCHED THEN
          UPDATE SET
           APU.DD_EPA_ID = (SELECT DDEPA.DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER DDEPA WHERE DDEPA.DD_EPA_CODIGO = ''01''),
           APU.APU_CHECK_PUBLICAR_A = 0,
           APU.APU_CHECK_OCULTAR_A = 0,
           APU.DD_MTO_A_ID = NULL,
           APU.APU_MOT_OCULTACION_MANUAL_A = NULL';

          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');
 

          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS ACTIVOS NO PUBLICADOS DE ALQUILER Y VENTA');

          EXECUTE IMMEDIATE 'MERGE INTO ACT_APU_ACTIVO_PUBLICACION APU 
            USING 
              (
                SELECT HEP.ACT_ID 
                FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION HEP
                JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION EPU ON HEP.DD_EPU_ID = EPU.DD_EPU_ID
                WHERE ACT_ID IN (
                SELECT CNT.ACT_ID 
                FROM '||V_ESQUEMA||'.ACT_HEP_HIST_EST_PUBLICACION CNT
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = CNT.ACT_ID AND ACT.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON ACT.DD_TCO_ID = TCO.DD_TCO_ID
                WHERE CNT.BORRADO = 0 AND TCO.DD_TCO_CODIGO = ''02''
                GROUP BY CNT.ACT_ID
                HAVING COUNT(CNT.ACT_ID) = 1) 
                AND EPU.DD_EPU_CODIGO = ''06''
              ) HIS
            ON (APU.ACT_ID = HIS.ACT_ID)
            WHEN MATCHED THEN
            UPDATE SET
             APU.DD_EPV_ID = (SELECT DDEPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA DDEPV WHERE DDEPV.DD_EPV_CODIGO = ''01''),
             APU.DD_EPA_ID = (SELECT DDEPA.DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER DDEPA WHERE DDEPA.DD_EPA_CODIGO = ''01''),
             APU.APU_CHECK_PUBLICAR_V = 0,
             APU.APU_CHECK_OCULTAR_V = 0,
             APU.DD_MTO_V_ID = NULL,
             APU.APU_MOT_OCULTACION_MANUAL_V = NULL,
             APU.APU_CHECK_PUBLICAR_A = 0,
             APU.APU_CHECK_OCULTAR_A = 0,
             APU.DD_MTO_A_ID = NULL,
             APU.APU_MOT_OCULTACION_MANUAL_A = NULL';
 
          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');
          DBMS_OUTPUT.PUT_LINE('[FIN]: MIGRACIÓN TERMINADA CORRECTAMENTE');

       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: LA TABLA ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||' NO EXISTE');
        
       END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: SCRIPT EJECUTADO');
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
