--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191016
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5488
--## PRODUCTO=NO
--##
--## Finalidad:
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'ECO_COND_CONDICIONES_ACTIVO';  -- Tabla a modificar  
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-5488'; -- Usuario modificar
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
					USUARIOBORRAR = '''||V_USUARIO||''',
					FECHABORRAR = SYSDATE,
					BORRADO = 1
				WHERE COND_ID IN (
					SELECT C1.COND_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' C1
					JOIN '||V_ESQUEMA||'.'||V_TABLA||' C2 ON C1.ACT_ID = C2.ACT_ID AND C1.ECO_ID = C2.ECO_ID
					WHERE C1.COND_ID < C2.COND_ID
				)';
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han eliminado '||SQL%ROWCOUNT||' registros');

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
