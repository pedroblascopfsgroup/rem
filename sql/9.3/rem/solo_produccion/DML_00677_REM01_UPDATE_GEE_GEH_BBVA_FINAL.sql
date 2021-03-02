--/*
--##########################################
--## AUTOR=Juan Beltran
--## FECHA_CREACION=20200402
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6835
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ID NUMBER(16);

    
BEGIN		
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 	
               DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN LA TABLA GEH');

       	  V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST GEH USING(
			SELECT GEE_ID AS GEH_ID, USUARIO
            		FROM '|| V_ESQUEMA ||'.AUX_REMVIP_8946_GEH
			) AUX ON (GEH.GEH_ID = AUX.GEH_ID)
			WHEN MATCHED THEN UPDATE SET
			GEH.USU_ID = (SELECT USU_ID FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS WHERE USU_USERNAME = AUX.USUARIO),
			GEH.FECHAMODIFICAR = SYSDATE,
			GEH.USUARIOMODIFICAR = ''REMVIP-8996''';
					
          EXECUTE IMMEDIATE V_MSQL;           	
          DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS ');
          
          
               DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR EN LA TABLA GEE');

       	  V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE USING(
			SELECT GEE_ID, USUARIO
            		FROM '|| V_ESQUEMA ||'.AUX_REMVIP_8946_GEE
			) AUX ON (GEE.GEE_ID = AUX.GEE_ID)
			WHEN MATCHED THEN UPDATE SET
			GEE.USU_ID = (SELECT USU_ID FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS WHERE USU_USERNAME = AUX.USUARIO),
			GEE.FECHAMODIFICAR = SYSDATE,
			GEE.USUARIOMODIFICAR = ''REMVIP-8996''';
					
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
