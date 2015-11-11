--/*
--##########################################
--## AUTOR=Alberto b
--## FECHA_CREACION=20151111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc14
--## INCIDENCIA_LINK=CMREC-1085
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** TPL_TIPO_POLITICA ********'); 

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TPL_TIPO_POLITICA SET TPL_DESCRIPCION = ''Ampliar'' WHERE TPL_CODIGO = ''TPL01''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Descripción TPL_TIPO_POLITICA actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TPL_TIPO_POLITICA SET TPL_DESCRIPCION = ''Reducir'' WHERE TPL_CODIGO = ''TPL03''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Descripción TPL_TIPO_POLITICA actualizada.');
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TPL_TIPO_POLITICA SET TPL_DESCRIPCION = ''Afianzar'' WHERE TPL_CODIGO = ''TPL04''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Descripción TPL_TIPO_POLITICA actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TPL_TIPO_POLITICA SET BORRADO = ''1'', USUARIOBORRAR= ''DD'', FECHABORRAR = SYSDATE WHERE TPL_CODIGO = ''TPL05''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO TPL_TIPO_POLITICA actualizada.');
    
     V_MSQL := 'UPDATE '||V_ESQUEMA||'.TPL_TIPO_POLITICA SET BORRADO = ''1'', USUARIOBORRAR= ''DD'', FECHABORRAR = SYSDATE WHERE TPL_CODIGO = ''TPL02b''';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO TPL_TIPO_POLITICA actualizada.');
    

	
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
