--/*
--##########################################
--## AUTOR=DANIEL ALGABA
--## FECHA_CREACION=20180426
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3975
--## PRODUCTO=NO
--##
--## Finalidad: Script que migra los activos que no están en el histórico a la ACT_APU_ACTIVO_PUBLICACION
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

	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCIÓN EN '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ');
    
        --Comprobamos que la tabla existe
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe, insertamos
        IF V_NUM_TABLAS > 0 THEN
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS REGISTROS EN LA TABLA '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');

          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS ACTIVOS CON CUALQUIER ESTADO COMERCIAL');
          EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                      (
                        APU_ID
                        ,ACT_ID
                        ,DD_EPV_ID
                        ,DD_EPA_ID
                        ,DD_TCO_ID
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
                        ,DD_EPA_ID
                        ,DD_TCO_ID
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
                          ACT_ID
                          , (SELECT DDEPV.DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA DDEPV WHERE DDEPV.DD_EPV_CODIGO = ''01'') DD_EPV_ID
                          , (SELECT DDEPA.DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER DDEPA WHERE DDEPA.DD_EPA_CODIGO = ''01'') DD_EPA_ID
                          , NVL(DD_TCO_ID, (SELECT DD_TCO_ID FROM DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''02'')) DD_TCO_ID
                          , NULL DD_MTO_V_ID
                          , NULL APU_MOT_OCULTACION_MANUAL_V
                          , 0 APU_CHECK_PUBLICAR_V
                          , 0 APU_CHECK_OCULTAR_V
                          , 0 APU_CHECK_OCULTAR_PRECIO_V
                          , 0 APU_CHECK_PUB_SIN_PRECIO_V
                          , NULL DD_MTO_A_ID
                          , NULL APU_MOT_OCULTACION_MANUAL_A
                          , 0 APU_CHECK_PUBLICAR_A
                          , 0 APU_CHECK_OCULTAR_A
                          , 0 APU_CHECK_OCULTAR_PRECIO_A
                          , 0 APU_CHECK_PUB_SIN_PRECIO_A 
                          , SYSDATE APU_FECHA_INI_VENTA
                          , SYSDATE APU_FECHA_INI_ALQUILER
                          , 0 VERSION
                          , ''MIGRACIÓN'' USUARIOCREAR
                          , SYSDATE FECHACREAR
                          , NULL USUARIOMODIFICAR
                          , NULL FECHAMODIFICAR
                          , NULL USUARIOBORRAR
                          , NULL FECHABORRAR
                          , 0 BORRADO
                          ,NULL DD_TPU_V_ID
                          ,NULL DD_TPU_A_ID
                        FROM (SELECT ACT_ID, DD_TCO_ID
                              FROM ACT_ACTIVO
                              WHERE BORRADO = 0
                              AND ACT_ID NOT IN (SELECT ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION WHERE BORRADO = 0)
                             )
                        )';

          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');

          -- Pasamos las estadísticas
          DBMS_OUTPUT.PUT_LINE('[INFO]: PASAMOS LAS ESTADÍSTICAS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');
          EXECUTE IMMEDIATE 'ANALYZE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' COMPUTE STATISTICS';

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
