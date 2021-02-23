--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20211802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8996
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
	 	
     DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR OGF '||V_ESQUEMA||'.'||V_TEXT_TABLA);

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET 
				NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE || USU.USU_APELLIDO1 || USU.USU_APELLIDO2	FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''knb03_bbva''),  
				USUARIOMODIFICAR = ''REMVIP-8996'' ,
				FECHAMODIFICAR = SYSDATE  ,
				USERNAME =  ''knb03_bbva'' 
				WHERE USERNAME IN (''ogf03'') 					
				AND COD_CARTERA = 16 AND TIPO_GESTOR = ''GIAFORM''';
					
          EXECUTE IMMEDIATE V_MSQL;           	
          DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS ');
          
     DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR GARSA '||V_ESQUEMA||'.'||V_TEXT_TABLA);

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET 
				NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE || USU.USU_APELLIDO1 || USU.USU_APELLIDO2	FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''garsa03_bbva''),  
				USUARIOMODIFICAR = ''REMVIP-8996'' ,
				FECHAMODIFICAR = SYSDATE  ,
				USERNAME =  ''garsa03_bbva'' 
				WHERE USERNAME IN (''garsa03'') 					
				AND COD_CARTERA = 16 AND TIPO_GESTOR = ''GIAFORM''';
					
          EXECUTE IMMEDIATE V_MSQL;           	
          DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS ');
          
     DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR PINOS '||V_ESQUEMA||'.'||V_TEXT_TABLA);

       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' SET 
				NOMBRE_USUARIO = (SELECT USU.USU_NOMBRE || USU.USU_APELLIDO1 || USU.USU_APELLIDO2	FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''pinos03_bbva''),  
				USUARIOMODIFICAR = ''REMVIP-8996'' ,
				FECHAMODIFICAR = SYSDATE  ,
				USERNAME =  ''pinos03_bbva'' 
				WHERE USERNAME IN (''pinos03'') 					
				AND COD_CARTERA = 16 AND TIPO_GESTOR = ''GIAFORM''';
					
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
