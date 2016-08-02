--/*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20160628
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-205
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
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

	VN_COUNT NUMBER;

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES
			WHERE FUN_DESCRIPCION = ''FUN_CIRCUITO_DECISION''
			AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
  IF VN_COUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe la función FUN_CIRCUITO_DECISION, se creará');
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES
				(FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION,  VERSION,    USUARIOCREAR,  FECHACREAR,  BORRADO )
				VALUES ('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL, ''Habilita circuito decisión'', ''FUN_CIRCUITO_DECISION'', 0, ''PFS-CONF'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Función FUN_CIRCUITO_DECISION, creada correctamente');
  ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la función FUN_CIRCUITO_DECISION');
  END IF;

	COMMIT;


	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');
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
