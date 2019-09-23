--/*
--#########################################
--## AUTOR=Oscar Diestre Pérez
--## FECHA_CREACION=20190913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5251
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5251'; -- USUARIOCREAR/USUARIOMODIFICAR.

    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] BORRANDO EMAIL de USU_USUARIOS ');
	
	
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS
		   SET USU_MAIL = ''notificaciones.rem@haya.es'',
		       USUARIOMODIFICAR = ''REMVIP-5251-2'',
		       FECHAMODIFICAR   = SYSDATE			
		   WHERE 1 = 1
		   AND USU_USERNAME IN
			( 
			 ''ext.bcunningham'',
			 ''ext.crenilla'',
			 ''ext.dmilone'',
			 ''ext.drubio'',
			 ''ext.gcalnan'',
			 ''ext.ibastosmendes'',
			 ''ext.jperezb'',
			 ''ext.mkelly''
			)
		';
	
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualiza el correo de '||SQL%ROWCOUNT||' usuario.'); 
		
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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
