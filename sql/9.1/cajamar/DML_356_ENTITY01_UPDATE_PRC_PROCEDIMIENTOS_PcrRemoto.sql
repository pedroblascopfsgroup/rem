--/*
--##########################################
--## AUTOR=Alberto B
--## FECHA_CREACION=20160119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=HR-1767
--## PRODUCTO=NO
--## Finalidad: DML
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** TAP_TAREA_PROCEDIMIENTO ********'); 
	DBMS_OUTPUT.PUT_LINE('******** COMPROBACIONES PREVIAS ********');
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''PRC_REMOTO'' and TABLE_NAME=''PRC_PROCEDIMIENTOS'' and owner = '''||V_ESQUEMA||'''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_EXISTE;
	
	IF V_NUM_EXISTE > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Se pone valor 1 a los procedimientos de los asuntos de tipo litigio y 0 a los que no lo son');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS SET PRC_REMOTO = 1 WHERE ASU_ID IN (SELECT ASU_ID FROM '||V_ESQUEMA||'.ASU_ASUNTOS WHERE DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO WHERE UPPER(DD_TAS_DESCRIPCION) = UPPER(''Litigio'')))';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] RegistroS actualizadoS en '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS');
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS SET PRC_REMOTO = 0 WHERE ASU_ID NOT IN (SELECT ASU_ID FROM '||V_ESQUEMA||'.ASU_ASUNTOS WHERE DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO WHERE UPPER(DD_TAS_DESCRIPCION) = UPPER(''Litigio'')))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] RegistroS actualizadoS en '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe el campo PRC_REMOTO en la tabla PRC_PROCEDIMIENTOS ');
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
