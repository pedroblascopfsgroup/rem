--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160219
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-793
--## PRODUCTO=SI
--## Finalidad: Crear el tipo de expediente: Gestión de deuda, con borrado logico
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
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPX_TIPO_EXPEDIENTE WHERE DD_TPX_CODIGO = ''GESDEU''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM=0 THEN
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'."DD_TPX_TIPO_EXPEDIENTE" (DD_TPX_ID, DD_TPX_CODIGO, DD_TPX_DESCRIPCION, DD_TPX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
					VALUES ('||V_ESQUEMA||'.S_DD_TPX_TIPO_EXPEDIENTE.NEXTVAL, ''GESDEU'', ''Expediente de Gestión de Deuda'', ''Expediente de Gestión de Deuda'', 0, ''DML'', SYSDATE, 1)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros insertado en '||V_ESQUEMA_M||'.DD_TPX_TIPO_EXPEDIENTE');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el tipo de expediente: Gestión de deuda.');
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
