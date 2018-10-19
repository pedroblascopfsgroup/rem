--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2290
--## PRODUCTO=NO
--##
--## Finalidad: Borrar y añadir en la tabla DD_TPD_TIPO_DOCUMENTO 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar      
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(30 CHAR):= 'DD_TPD_TIPO_DOCUMENTO';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    V_MAX_TPD_ID NUMBER(16,0);
    V_MAX_TPD_CODIGO VARCHAR2(20 CHAR);
    --V_TABLA_INSERT VARCHAR2(50 CHAR) := 'DD_TPD_TIPO_DOCUMENTO';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2290';
    
 BEGIN

	--borrado de tipos de documentos
 
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
				  BORRADO = 1 
    				, USUARIOBORRAR = '''||V_USUARIO||''' 
    				, FECHABORRAR = SYSDATE 
    				  WHERE DD_TPD_ID = (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''01'') 
    				';
    				
         EXECUTE IMMEDIATE V_SQL;
      
	 DBMS_OUTPUT.PUT_LINE('[INFO] Se ha puesto borrado = 1 ');

	 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
				  BORRADO = 1 
    				, USUARIOBORRAR = '''||V_USUARIO||''' 
    				, FECHABORRAR = SYSDATE 
    				  WHERE DD_TPD_ID = (SELECT DD_TPD_ID FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = ''60'') 
    				';
    				
         EXECUTE IMMEDIATE V_SQL;
      
	DBMS_OUTPUT.PUT_LINE('[INFO] Se ha puesto borrado = 1 ');

	--insert nuevos tipos de documentos

	

	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_MAX_TPD_ID;
	
	V_MSQL := 'SELECT MAX(DD_TPD_CODIGO)+1 FROM '||V_ESQUEMA||'.'||V_TABLA||'';
	EXECUTE IMMEDIATE V_MSQL INTO V_MAX_TPD_CODIGO;
			
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'(DD_TPD_ID, DD_TPD_CODIGO, DD_TPD_DESCRIPCION, DD_TPD_DESCRIPCION_LARGA, 
				USUARIOCREAR, FECHACREAR, DD_TPD_MATRICULA_GD, DD_TPD_VISIBLE) VALUES('||V_MAX_TPD_ID||', '''||V_MAX_TPD_CODIGO||''', ''Comunicaciones'', 
				''Requerimientos administraciones o terceros de actuaciones'', '''||V_USUARIO||''', SYSDATE, ''AI-03-COMU-81'',0)';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se ha insertado nuevo tipo documento ');

	

	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_MAX_TPD_ID;
	
	V_MSQL := 'SELECT MAX(DD_TPD_CODIGO)+1 FROM '||V_ESQUEMA||'.'||V_TABLA||'';
	EXECUTE IMMEDIATE V_MSQL INTO V_MAX_TPD_CODIGO;
			
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'(DD_TPD_ID, DD_TPD_CODIGO, DD_TPD_DESCRIPCION, DD_TPD_DESCRIPCION_LARGA, 
				USUARIOCREAR, FECHACREAR, DD_TPD_MATRICULA_GD, DD_TPD_VISIBLE) VALUES('||V_MAX_TPD_ID||', '''||V_MAX_TPD_CODIGO||''', ''Título inscrito (Testimonio)'', 
				''Título inscrito (Testimonio)'', '''||V_USUARIO||''', SYSDATE, ''AI-01-DOCJ-BJ'',0)';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se ha insertado nuevo tipo documento ');

	

	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_MAX_TPD_ID;
	
	V_MSQL := 'SELECT MAX(DD_TPD_CODIGO)+1 FROM '||V_ESQUEMA||'.'||V_TABLA||'';
	EXECUTE IMMEDIATE V_MSQL INTO V_MAX_TPD_CODIGO;
			
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'(DD_TPD_ID, DD_TPD_CODIGO, DD_TPD_DESCRIPCION, DD_TPD_DESCRIPCION_LARGA, 
				USUARIOCREAR, FECHACREAR, DD_TPD_MATRICULA_GD, DD_TPD_VISIBLE) VALUES('||V_MAX_TPD_ID||', '''||V_MAX_TPD_CODIGO||''', ''Título inscrito (Escritura)'', 
				''Título inscrito (Escritura)'', '''||V_USUARIO||''', SYSDATE, ''AI-01-ESCR-48'',0)';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se ha insertado nuevo tipo documento ');


      
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
