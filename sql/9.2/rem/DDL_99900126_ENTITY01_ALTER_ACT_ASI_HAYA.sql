--/*
--##########################################
--## AUTOR=JOSE MANUEL PÉREZ BARBERÁ
--## FECHA_CREACION=20170126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.17
--## INCIDENCIA_LINK=RECOVERY-4371
--## PRODUCTO=SI
--##
--## Finalidad: Añade nueva columna DD_EIN_ID y quita restricción NOT NULL para la columna REG_ID
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

        V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME=''ACT_ASI_HAYA'' AND COLUMN_NAME=''ACT_NUM_ACTIVO'' AND NULLABLE = ''N''';
        EXECUTE IMMEDIATE V_SQL INTO VN_COUNT;
          IF VN_COUNT = 1 THEN
                V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_ASI_HAYA MODIFY (ACT_NUM_ACTIVO NULL )';
                EXECUTE IMMEDIATE V_MSQL;
                
                DBMS_OUTPUT.PUT_LINE('[INFO] Se ha modificado la columna ACT_NUM_ACTIVO a NULLABLE en la tabla ACT_ASI_HAYA');
          ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] No existe la columna ACT_NUM_ACTIVO NO NULLABLE en la tabla ACT_ASI_HAYA');
          END IF;
          
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
