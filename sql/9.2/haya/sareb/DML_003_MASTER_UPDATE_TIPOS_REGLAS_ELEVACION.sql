--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-795
--## PRODUCTO=NO
--## Finalidad: Cambiar la descripción de reglas de elevación
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION SET DD_TRE_DESCRIPCION = ''Proponer clasificación crediticia'' WHERE DD_TRE_CODIGO = ''POLITICA''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.DD_TRE_DESCRIPCION');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION SET DD_TRE_DESCRIPCION = ''Seleccionar propuesta de actuación'' WHERE DD_TRE_CODIGO = ''GESTION_PROPUESTA''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.DD_TRE_DESCRIPCION');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION WHERE DD_TRE_CODIGO = ''SANCIONAR_PROPUESTA''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM=0 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_TRE_TIPO_REGLAS_ELEVACION (DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA_M||'.S_DD_TRE_TIPO_REGLAS_ELEVACION.NEXTVAL, ''SANCIONAR_PROPUESTA'', ''Sancionar Propuesta'', ''Sancionar Propuesta'', 0, ''DML'', SYSDATE, 0)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertado en '||V_ESQUEMA||'.DD_TRE_DESCRIPCION');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el tipo de regla de elevación: Sancionar Propuesta.');
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
