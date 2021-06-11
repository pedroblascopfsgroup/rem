--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210415
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9484
--## PRODUCTO=NO
--##
--## Finalidad: Script para organizar gestores expedientes
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9484'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]'); 

	V_MSQL:= 'DELETE FROM '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO
				WHERE GEH_ID IN (18757161,18757162)';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han eliminado correctamente '||SQL%ROWCOUNT||' registros en GCH_GESTOR_ECO_HISTORICO');   

	V_MSQL:= 'DELETE FROM '||V_ESQUEMA||'.GCO_GESTOR_ADD_ECO
				WHERE GEE_ID IN (15936630,15936631)';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han eliminado correctamente '||SQL%ROWCOUNT||' registros en GCO_GESTOR_ADD_ECO'); 

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST SET BORRADO = 1,
				USUARIOBORRAR = '''||V_USU||''', FECHABORRAR = SYSDATE
				WHERE GEH_ID IN (18757161,18757162)';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado correctamente '||SQL%ROWCOUNT||' registros en GEH_GESTOR_ENTIDAD_HIST'); 

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD SET BORRADO = 1,
				USUARIOBORRAR = '''||V_USU||''', FECHABORRAR = SYSDATE
				WHERE GEE_ID IN (15936630,15936631)';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado correctamente '||SQL%ROWCOUNT||' registros en GEE_GESTOR_ENTIDAD'); 

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

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