--/*
--##########################################
--## AUTOR=DANIEL ALGABA
--## FECHA_CREACION=20180323
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-3975
--## PRODUCTO=NO
--##
--## Finalidad: Script que cambia el estado a oculto de los activos que tiene el check marcado en la ACT_APU_ACTIVO_PUBLICACION
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
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS LOS REGISTROS EN LA TABLA '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');

          -- Pasamos las estadísticas
          DBMS_OUTPUT.PUT_LINE('[INFO]: PASAMOS LAS ESTADÍSTICAS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');
          EXECUTE IMMEDIATE 'ANALYZE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' COMPUTE STATISTICS';


          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS ACTIVOS QUE NO ESTABAN OCULTOS DE VENTA');


          EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' APU 
            USING 
              (
                SELECT APU.ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION APU
                JOIN DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                JOIN DD_EPV_ESTADO_PUB_VENTA EPV ON APU.DD_EPV_ID = EPV.DD_EPV_ID
                WHERE APU_CHECK_OCULTAR_V = 1 AND TCO.DD_TCO_CODIGO = ''01'' AND EPV.DD_EPV_CODIGO = ''03''
              ) AUX
            ON (APU.ACT_ID = AUX.ACT_ID)
            WHEN MATCHED THEN
            UPDATE SET
             APU.DD_EPV_ID = 5';

          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');

          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS ACTIVOS QUE NO ESTABAN OCULTOS DE ALQUILER');

          EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' APU 
            USING 
              (
                SELECT APU.ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION APU
                JOIN DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                JOIN DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID
                WHERE APU_CHECK_OCULTAR_A = 1 AND TCO.DD_TCO_CODIGO IN (''03'',''04'') AND EPA.DD_EPA_CODIGO = ''03''
              ) AUX
          ON (APU.ACT_ID = AUX.ACT_ID)
          WHEN MATCHED THEN
          UPDATE SET
           APU.DD_EPA_ID = 5';

          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');
 

          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS LOS ACTIVOS QUE NO ESTABAN OCULTOS DE ALQUILER Y VENTA');
          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS PARA VENTA');

          EXECUTE IMMEDIATE 'MERGE INTO ACT_APU_ACTIVO_PUBLICACION APU 
            USING 
              (
                SELECT APU.ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION APU
                JOIN DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                JOIN DD_EPV_ESTADO_PUB_VENTA EPV ON APU.DD_EPV_ID = EPV.DD_EPV_ID
                WHERE APU_CHECK_OCULTAR_V = 1 AND TCO.DD_TCO_CODIGO = ''02'' AND EPV.DD_EPV_CODIGO = ''03''
              ) AUX
            ON (APU.ACT_ID = AUX.ACT_ID)
            WHEN MATCHED THEN
            UPDATE SET
             APU.DD_EPV_ID = 5';

          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');
          DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS PARA VENTA');

          EXECUTE IMMEDIATE 'MERGE INTO ACT_APU_ACTIVO_PUBLICACION APU 
            USING 
              (
                SELECT APU.ACT_ID FROM ACT_APU_ACTIVO_PUBLICACION APU
                JOIN DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID = TCO.DD_TCO_ID
                JOIN DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID
                WHERE APU_CHECK_OCULTAR_A = 1 AND TCO.DD_TCO_CODIGO = ''02'' AND EPA.DD_EPA_CODIGO = ''03''
              ) AUX
            ON (APU.ACT_ID = AUX.ACT_ID)
            WHEN MATCHED THEN
            UPDATE SET
             APU.DD_EPA_ID = 5';
 
          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTROS INSERTADOS CORRECTAMENTE');
          DBMS_OUTPUT.PUT_LINE('[FIN]: SCRIPT TERMINADA CORRECTAMENTE');

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