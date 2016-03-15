--/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20160311
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-cj
--## INCIDENCIA_LINK=PRODUCTO-894
--## PRODUCTO=SI
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
	
	DBMS_OUTPUT.PUT_LINE('******** DD_TAC_TIPO_ACTUACION ********');
	
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION... Comprobaciones previas para tipo asunto ACU'); 

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO = ''ACU''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN
    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION SET DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO = ''ACU'') WHERE DD_TAC_CODIGO = ''ACU'' ';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA_M||'.DD_TAC_TIPO_ACTUACION Para el tipo Asunto ACU');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No hay registros que cumplan la condicion en  '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO. Para el tipo asunto ACU');
	END IF;
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION... Comprobaciones previas para tipo asunto CONCURSAL'); 

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO = ''02''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN
    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION SET DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO = ''02'') WHERE DD_TAC_CODIGO = ''CO'' ';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA_M||'.DD_TAC_TIPO_ACTUACION Para el tipo Asunto CONCURSAL');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No hay registros que cumplan la condicion en  '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO. Para el tipo asunto CONCURSAL');
	END IF;
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION... Comprobaciones previas para tipo asunto LITIGIOS'); 

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO = ''01''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN
    	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION SET DD_TAS_ID = (SELECT DD_TAS_ID FROM '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO WHERE DD_TAS_CODIGO = ''01'') WHERE DD_TAC_CODIGO NOT IN (''ACU'',''CO'') ';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA_M||'.DD_TAC_TIPO_ACTUACION Para el tipo Asunto LITIGIO');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No hay registros que cumplan la condicion en  '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO. Para el tipo asunto LITIGIO');
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
