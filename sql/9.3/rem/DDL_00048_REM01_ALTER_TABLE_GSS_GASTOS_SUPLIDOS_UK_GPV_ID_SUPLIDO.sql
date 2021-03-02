--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200423
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10134
--## PRODUCTO=NO
--## 
--## Finalidad: Adición de UK_GPV_ID_SUPLIDO para la tabla GSS_GASTOS_SUPLIDOS
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.  
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	-- Verificar si la UK existe y, si no es así, la creamos:
	DBMS_OUTPUT.PUT_LINE('	[INFO] Verificando si existe la clave única ''UK_GPV_ID_SUPLIDO''');
	V_SQL := 'SELECT COUNT(*) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''UK_GPV_ID_SUPLIDO''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		DBMS_OUTPUT.PUT_LINE('	[INFO] Añadiendo clave única...');
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.GSS_GASTOS_SUPLIDOS ADD CONSTRAINT UK_GPV_ID_SUPLIDO UNIQUE (GPV_ID_SUPLIDO)';
		DBMS_OUTPUT.PUT_LINE('	[OK] Hecho.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('	[ERROR] La clave única UK_GPV_ID_SUPLIDO ya existe.');
	END IF;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN 
		DBMS_OUTPUT.PUT_LINE('KO!');
		err_num := SQLCODE;
		err_msg := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(err_msg);
		DBMS_OUTPUT.put_line('-----------------------V_SQL--------------------------------'); 
		DBMS_OUTPUT.put_line(V_SQL); 
		ROLLBACK;
		RAISE;
END;
/
EXIT;
