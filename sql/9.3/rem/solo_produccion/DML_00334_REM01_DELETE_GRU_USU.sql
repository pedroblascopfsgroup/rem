--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200611
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7471
--## PRODUCTO=NO
--##
--## Finalidad: Borrado de relación Grupos-Usuarios REM
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
	
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7471'; -- USUARIO CREAR/MODIFICAR
	V_TABLA VARCHAR2(50 CHAR) := 'GRU_GRUPOS_USUARIOS';
	V_ENTIDAD_ID NUMBER(16);
	V_ID NUMBER(16);

BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '); 
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO EN '||V_TABLA||'] ');
	
		DBMS_OUTPUT.PUT_LINE('****************************************************');	
		DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobando si existe el usuario ''mon.ybrodriguez''');
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' 
			WHERE USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''mon.ybrodriguez'')
			AND BORRADO = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
		-- Si existe la FILA
		IF V_NUM_TABLAS > 0 THEN	  
			V_MSQL := '
			DELETE FROM '||V_ESQUEMA_M||'.'||V_TABLA||' GRU
			WHERE 
				 GRU.USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''mon.ybrodriguez'')
				AND GRU.BORRADO = 1 AND GRU.USUARIOBORRAR = ''ITREM-17545''
			';
				
			EXECUTE IMMEDIATE V_MSQL;	
			DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS EN GRU_GRUPOS_USUARIOS: ' || sql%rowcount);
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]: Ya no existe el usuario en ese grupo.');	
		END IF;	
	
	COMMIT;
		
	DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   
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
