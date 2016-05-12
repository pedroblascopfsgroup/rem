--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160309
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-671
--## PRODUCTO=NO
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_DDNAME VARCHAR2(30):= 'PEF_PERFILES';
BEGIN	

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE PEF_CODIGO= ''FPFSRPROC''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	-- Si no existe el perfil, lo creamos.
	IF V_NUM_TABLAS = 0 THEN    
	  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES ' ||
	  			'(PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,VERSION, USUARIOCREAR,FECHACREAR,BORRADO,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) '||
	  			'VALUES ('||V_ESQUEMA||'.S_PEF_PERFILES.nextval,''Gestor Procurador'',''Gestor Procurador'',0,''PRODUCTO-1206'',sysdate,0,''FPFSRPROC'',0,''EXTPerfil'') ';
		
	  	EXECUTE IMMEDIATE V_MSQL;
	END IF;
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID=(SELECT PEF_ID FROM '||V_ESQUEMA||'.pef_perfiles where pef_codigo= ''FPFSRPROC'') and fun_id=(select fun_id from '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION=''ROLE_PUEDE_SUBIR_ADJUNTOS'')';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN
	
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
				' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
				' SELECT fun.FUN_ID, (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''FPFSRPROC''), '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''PRODUCTO-1206'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES fun WHERE ' ||
					' fun.FUN_DESCRIPCION = ''ROLE_PUEDE_SUBIR_ADJUNTOS''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;				
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Funciones insertadas.');
		
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
