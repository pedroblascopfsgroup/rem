--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20151112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1119
--## PRODUCTO=SI
--## Finalidad: DML Adaptar las funciones de creación de expedientes manuales.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

--------------------------------------- SOLICITAR_EXP_MANUAL_RECOBRO ---------------------------------------------------------------------
	
DBMS_OUTPUT.PUT_LINE('[INICIO] Comprobando permiso SOLICITAR_EXP_MANUAL');

V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''SOLICITAR_EXP_MANUAL''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Cambiando el permiso SOLICITAR_EXP_MANUAL a SOLICITAR_EXP_MANUAL_RECOBRO');
    V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.FUN_FUNCIONES SET FUN_DESCRIPCION_LARGA = ''Solicitar Expediente Manual Recobro'', FUN_DESCRIPCION = ''SOLICITAR_EXP_MANUAL_RECOBRO'' '||
    			'WHERE FUN_DESCRIPCION = ''SOLICITAR_EXP_MANUAL''';
    EXECUTE IMMEDIATE V_MSQL;
ELSE
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos el permiso SOLICITAR_EXP_MANUAL_RECOBRO');
	V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR,  BORRADO )  VALUES '||
				'('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL, ''Solicitar Expediente Manual Recobro'', ''SOLICITAR_EXP_MANUAL_RECOBRO'', 0, ''DML'', SYSDATE, 0)';
	EXECUTE IMMEDIATE V_MSQL;
END IF;

-----------------------------------  SOLICITAR_EXP_MANUAL_SEGUIMIENTO -------------------------------------------------------------------

DBMS_OUTPUT.PUT_LINE('[INICIO] Comprobando permiso SOLICITAR_EXP_MANUAL_SEG');

V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''SOLICITAR_EXP_MANUAL_SEG''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Cambiando el permiso SOLICITAR_EXP_MANUAL_SEG a SOLICITAR_EXP_MANUAL_SEGUIMIENTO');
    V_MSQL := 'UPDATE '|| V_ESQUEMA_M ||'.FUN_FUNCIONES SET FUN_DESCRIPCION_LARGA = ''Solicitar Expediente Manual Seguimiento'', FUN_DESCRIPCION = ''SOLICITAR_EXP_MANUAL_SEGUIMIENTO'' '||
    			'WHERE FUN_DESCRIPCION = ''SOLICITAR_EXP_MANUAL_SEG''';
    EXECUTE IMMEDIATE V_MSQL;
ELSE
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos el permiso SOLICITAR_EXP_MANUAL_SEGUIMIENTO');
	V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR,  BORRADO )  VALUES '||
				'('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL, ''Solicitar Expediente Manual Seguimiento'', ''SOLICITAR_EXP_MANUAL_SEGUIMIENTO'', 0, ''DML'', SYSDATE, 0)';
	EXECUTE IMMEDIATE V_MSQL;
END IF;

-----------------------------------  SOLICITAR_EXP_MANUAL_RECUPERACIONES -------------------------------------------------------------------

DBMS_OUTPUT.PUT_LINE('[INICIO] Comprobando permiso SOLICITAR_EXP_MANUAL_RECUPERACIONES');

V_SQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA_M || '.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''SOLICITAR_EXP_MANUAL_RECUPERACIONES''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

IF V_NUM_TABLAS = 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos el permiso SOLICITAR_EXP_MANUAL_RECUPERACIONES');
	V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION,  VERSION, USUARIOCREAR, FECHACREAR,  BORRADO )  VALUES '||
				'('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL, ''Solicitar Expediente Manual Recuperaciones'', ''SOLICITAR_EXP_MANUAL_RECUPERACIONES'', 0, ''DML'', SYSDATE, 0)';
	EXECUTE IMMEDIATE V_MSQL;
END IF;

COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT

