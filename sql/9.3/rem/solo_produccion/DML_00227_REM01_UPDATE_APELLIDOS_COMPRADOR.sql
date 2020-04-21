--/*
--#########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200401
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6797
--## PRODUCTO=NO
--## 
--## Finalidad: Corregir los datos de apellidos de un comrador determinado
--## 
--## INSTRUCCIONES:
--## VERSIONES:
--## 		0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	err_num NUMBER; -- Numero de error.
	err_msg VARCHAR2(2048); -- Mensaje de error.
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6797';
	V_SQL VARCHAR2(4000 CHAR);
	V_NUM NUMBER;
	V_COUNT NUMBER(16):= 0; -- Vble. para contar updates

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar apellidos del comprador con CIF: B70350806');

	EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.COM_COMPRADOR WHERE COM_DOCUMENTO = ''B70350806''' INTO V_NUM;
	IF V_NUM = 1 THEN
		DBMS_OUTPUT.PUT_LINE('	[INFO] Actualizando...');
		EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.COM_COMPRADOR SET 
			COM_APELLIDOS = '''', 
			USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''',
			FECHAMODIFICAR = SYSDATE
			WHERE COM_DOCUMENTO = ''B70350806''';
		DBMS_OUTPUT.PUT_LINE('	[OK] Campo actualizado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[ERROR] El Comprador no existe.');
	END IF;

	--ROLLBACK;
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------');
		DBMS_OUTPUT.put_line(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/
EXIT
