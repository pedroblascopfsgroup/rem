--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180208
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1476
--## PRODUCTO=NO
--##
--## Finalidad: cambiar al gestor rmoreno (gestor de admisión) los registros de la tabla TAC_TAREAS_ACTIVO, dar de baja para que no entre en rem
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'TAC_TAREAS_ACTIVOS';
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1476';
    
 BEGIN
 
    V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
 			 USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''jdrodriguez''),
 			 USUARIOMODIFICAR = '''||V_USUARIO||''',
 			 FECHAMODIFICAR = SYSDATE
 			 WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''rmoreno'')
		  ';
		  
    EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han cambiado '||SQL%ROWCOUNT||' registros en la tabla TAC_TAREAS_ACTIVOS');

    V_SQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET 
 			 USU_FECHA_VIGENCIA_PASS = TO_DATE(''01/08/18'',''DD/MM/YY'') 
 			 , USUARIOMODIFICAR = '''||V_USUARIO||''' 
 			 , FECHAMODIFICAR = SYSDATE 
 			 WHERE USU_USERNAME = ''rmoreno''
		  ';
		  
    EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han cambiado '||SQL%ROWCOUNT||' FECHA_VIGENCIA_PASS en la tabla USU_USUARIOS');

    
  
 COMMIT;
 
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
