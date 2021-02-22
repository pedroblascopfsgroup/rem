--/*
--##########################################
--## AUTOR=Ivan Repiso
--## FECHA_CREACION=20210210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8883
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización supervisor backoffice inmobiliario sareb
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8883'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error

	PL_OUTPUT VARCHAR2(32000 CHAR);
	
	V_USERNAME VARCHAR2(50 CHAR) := 'grupgact';
	V_PERFIL VARCHAR2(50 CHAR) := 'GACT';
	V_CARTERA VARCHAR2(30 CHAR):= 'Bankia';
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = 504975 AND BORRADO = 0 AND DD_SCR_ID IS NULL';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT = 1 THEN

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET
					DD_SCR_ID = 8,
					USUARIOMODIFICAR = '''||V_USUARIO||''',
					FECHAMODIFICAR = SYSDATE
					WHERE ACT_ID = 504975 AND BORRADO = 0 AND DD_SCR_ID IS NULL';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_ACTIVO');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO CON ID 504975');

	END IF;

	REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3('REMVIP-8883', PL_OUTPUT, '504975', NULL, '02' );

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