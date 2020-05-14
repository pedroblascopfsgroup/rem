--/*
--###########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200514
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7284
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR RESPONSABLE Y SOLICITANTE TRABAJO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-7284';
  USU_ID  NUMBER(16);
	
  
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grupgact''';
				
	EXECUTE IMMEDIATE V_MSQL INTO USU_ID;

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET USU_ID = '||USU_ID||', 
		TBJ_RESPONSABLE_TRABAJO = '||USU_ID||',
		TBJ_GESTOR_ACTIVO_RESPONSABLE = '||USU_ID||',
		TBJ_SUPERVISOR_ACT_RESPONSABLE = '||USU_ID||',
		USUARIOMODIFICAR = '''||V_USUARIO||''',
		FECHAMODIFICAR = SYSDATE 
		WHERE USUARIOCREAR = ''MIG_DIVARIAN'' AND USU_ID IS NULL';
				
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.put_line('[INFO] Se haN actualizado '||SQL%ROWCOUNT||' registros ');

    	COMMIT;
   
   	DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
