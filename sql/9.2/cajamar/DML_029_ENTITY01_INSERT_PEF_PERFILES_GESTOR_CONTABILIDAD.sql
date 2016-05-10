--/*
--##########################################
--## AUTOR=Kevin Fernandez
--## FECHA_CREACION=20160506
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4
--## INCIDENCIA_LINK=PRODUCTO-1330
--## PRODUCTO=SI
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
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_DDNAME VARCHAR2(30):= 'PEF_PERFILES';
BEGIN	

    
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE PEF_CODIGO= ''GESCONT''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el GESCONT '||V_DDNAME||'.');
	
	ELSE
	
	  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
	  '(PEF_ID, PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PEF_CODIGO, PEF_ES_CARTERIZADO, DTYPE) values '||
	  '('||V_ESQUEMA||'.S_PEF_PERFILES.nextval,''Perfil usuario de contabilidad'',''Perfil usuario de contabilidad'',''0'',''PRODUCTO-1330'',sysdate,''0'',''GESCONT'',''0'',''EXTPerfil'') ';
	
	  DBMS_OUTPUT.PUT_LINE('OK modificado');
	
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
  	