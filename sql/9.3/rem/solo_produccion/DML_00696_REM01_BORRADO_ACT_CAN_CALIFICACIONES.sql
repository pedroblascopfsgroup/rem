--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9043
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización tabla 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CAN_CALIFICACION_NEG'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ID NUMBER(16);

    
BEGIN		
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 	
               DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN LA TABLA GEH');

       	  V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_CAN_CALIFICACION_NEG CAN USING(
				SELECT CAN.ACT_CAN_ID 
				FROM '||V_ESQUEMA||'.ACT_CAN_CALIFICACION_NEG CAN 
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = CAN.ACT_ID
				JOIN '||V_ESQUEMA||'.DD_CAN_CALIFICACION_NEG NEG ON NEG.DD_CAN_ID = CAN.DD_CAN_ID
				WHERE CAN.USUARIOCREAR = ''MIG_BBVA'' AND NEG.DD_CAN_CODIGO = ''02'' AND CAN.BORRADO = 0
				) AUX ON (AUX.ACT_CAN_ID = CAN.ACT_CAN_ID)
			     WHEN MATCHED THEN UPDATE SET
		             CAN.BORRADO = 1,
			     CAN.USUARIOBORRAR = ''REMVIP-9043'',
			     CAN.FECHABORRAR = SYSDATE';
					
          EXECUTE IMMEDIATE V_MSQL;           	
          DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS ');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_MSG := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;
/

EXIT
