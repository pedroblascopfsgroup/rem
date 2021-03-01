--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210224
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
    V_ID NUMBER(16);

    
BEGIN		
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 	
               DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR API ESPEJO');

       	  V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO USING(
				SELECT ICO_ID FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
				JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = ICO.ICO_MEDIADOR_ESPEJO_ID
				WHERE ICO.USUARIOCREAR = ''MIG_BBVA'' AND PVE.PVE_COD_ORIGEN = ''1556453''
				) AUX ON (AUX.ICO_ID = ICO.ICO_ID)
				WHEN MATCHED THEN UPDATE SET
				ICO.ICO_MEDIADOR_ESPEJO_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_ORIGEN = ''1529204''),
				ICO.USUARIOMODIFICAR = ''REMVIP-9054'',
				ICO.FECHAMODIFICAR = SYSDATE';
					
          EXECUTE IMMEDIATE V_MSQL;           	
          DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS ');
          
                         DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR HISTORICO API ESPEJO');

       	  V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI ICM USING(
				SELECT ICM.ICM_ID FROM ACT_ICM_INF_COMER_HIST_MEDI ICM
				JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = ICM.ICO_MEDIADOR_ID
				WHERE ICM.USUARIOCREAR = ''MIG_BBVA'' AND PVE.PVE_COD_ORIGEN = ''1556453''
				AND ICM.DD_TRL_ID = (SELECT DD_TRL_ID FROM DD_TRL_TIPO_ROLES_MEDIADOR WHERE DD_TRL_CODIGO = ''02'')
				) AUX ON (AUX.ICM_ID = ICM.ICM_ID)
				WHEN MATCHED THEN UPDATE SET
				ICM.ICO_MEDIADOR_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_ORIGEN = ''1529204''),
				ICM.USUARIOMODIFICAR = ''REMVIP-9054'',
				ICM.FECHAMODIFICAR = SYSDATE';
					
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
