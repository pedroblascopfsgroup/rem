--/*
--##########################################
--## AUTOR=Ivan Repiso
--## FECHA_CREACION=20210210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8871
--## PRODUCTO=NO
--## 
--## Finalidad: MODIFICAMOS EL PVE_COD_REM PARA KNB
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8871'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_GRF_GESTORIA_RECEP_FICH WHERE DD_GRF_ID = 6 AND BORRADO = 0 AND PVE_COD_REM = ''10006181''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

	IF V_COUNT = 1 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS EL PVE_COD_REM PARA KNB');

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_GRF_GESTORIA_RECEP_FICH SET
					PVE_COD_REM = ''110187531'',
					USUARIOMODIFICAR = '''||V_USUARIO||''',
					FECHAMODIFICAR = SYSDATE
					WHERE DD_GRF_ID = 6 AND BORRADO = 0 AND PVE_COD_REM = ''10006181''';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN DD_GRF_GESTORIA_RECEP_FICH');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] YA MODIFICADO EL PVE_COD_REM DE OGF');

	END IF;

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