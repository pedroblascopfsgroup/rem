--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8986
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización vigencia de contraseña
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
	V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
 	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
 	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8986'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZAR FECHA DE VIGENCIA DE LAS CONTRASEÑAS DE TODOS LOS USUARIOS');

	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET
				USU_FECHA_VIGENCIA_PASS = TO_DATE(''31/12/99'',''DD/MM/RR''),
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHAMODIFICAR = SYSDATE
				WHERE BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN USU_USUARIOS');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	
	EXCEPTION
	
	    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		ROLLBACK;
		RAISE;
END;
/
EXIT;