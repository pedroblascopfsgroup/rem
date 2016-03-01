--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-802
--## PRODUCTO=SI
--## Finalidad: Crear nueva función CREACION_EXP_MANUAL_GESTION_DEUDA
--##			y agrega también el PLAZO POR DEFECTO PARA LA TAREA CREACION MANUAL EXPEDIENTES DEUDA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    
    V_NUM NUMBER; 
    V_DD_STA_ID NUMBER;
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''SOLICITAR_EXP_MANUAL_GESTION_DEUDA''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM = 0  THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL, ''Solicitar Expediente Manual Gestion Deuda'', ''SOLICITAR_EXP_MANUAL_GESTION_DEUDA'', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Función SOLICITAR_EXP_MANUAL_GESTION_DEUDA creada correctamente');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] La función SOLICITAR_EXP_MANUAL_GESTION_DEUDA ya existía...');
	END IF;

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''SOLEXPMGDEUDA'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		V_SQL := 'SELECT '||V_ESQUEMA_M||'.S_DD_STA_SUBTIPO_TAREA_BASE.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_DD_STA_ID;
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_STA_GESTOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_DD_STA_ID||', 1, ''SOLEXPMGDEUDA'', ''Solicitud Expediente Manual Gestión Deuda'', ''Pedido al Supervisor de Expediente Manual de Gestión de Deuda'', 0, 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada el SubTipo Tarea SOLEXPMGDEUDA, con DD_STA_ID: '||V_DD_STA_ID);
	ELSE
		V_SQL := 'SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''SOLEXPMGDEUDA'' AND BORRADO = 0 AND ROWNUM = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_DD_STA_ID;	
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existía un SubTipo Tarea SOLEXPMGDEUDA, con DD_STA_ID: '||V_DD_STA_ID);
	END IF;

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PLA_PLAZOS_DEFAULT WHERE PLA_CODIGO = ''EXPMGDEUDA'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	IF V_NUM = 0 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PLA_PLAZOS_DEFAULT (PLA_ID, DD_STA_ID, PLA_PLAZO, PLA_CODIGO, PLA_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_PLA_PLAZOS_DEFAULT.NEXTVAL, '||V_DD_STA_ID||', 5000, ''EXPMGDEUDA'', ''Solicitud Expediente Manual de Gestión de Deuda'', 0, ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha creado un plazo por defecto para la creación de expedientes manuales de Gestión de Deuda');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existía un plazo por defecto para la creación de expedientes manuales de Gestión de Deuda');
	END IF;
	
    COMMIT;
	
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
