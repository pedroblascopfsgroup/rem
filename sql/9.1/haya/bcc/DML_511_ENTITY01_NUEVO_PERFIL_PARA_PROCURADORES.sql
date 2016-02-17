--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
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
    V_DDNAME2 VARCHAR2(30):= 'FUN_FUNCIONES';
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('Creando perfil PROCUINTEGRAL');
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_DDNAME||' WHERE PEF_CODIGO= ''PROCUINTEGRAL''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el PROCUINTEGRAL '||V_DDNAME||'.');	
	ELSE
		-- SE CREA EL PERFIL
	  execute immediate 'Insert into '||V_ESQUEMA||'.'||V_DDNAME||' '||
	  '(PEF_ID, PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PEF_CODIGO, PEF_ES_CARTERIZADO, DTYPE) values '||
	  '('||V_ESQUEMA||'.S_PEF_PERFILES.nextval,''Perfil de procurador de despacho integral'',''Perfil de procurador de despacho integral'',''0'',''PROD-671'',sysdate,''0'',''PROCUINTEGRAL'',''0'',''EXTPerfil'') ';
	
	  DBMS_OUTPUT.PUT_LINE('OK modificado');
	
	END IF;
	
	-- LE INSERTAMOS LAS FUNCIONES QUE TENDRAN LOS USUARIOS QUE PERTENECEN A UN DESPACHO LETRADO Y QUE SEA O HAYA SIDO INTEGRAL.
	DBMS_OUTPUT.PUT_LINE('[INFO] Insertando funciones al perfil PROCUINTEGRAL.');		 
	 V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
				' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
				' SELECT fun.FUN_ID, (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''PROCUINTEGRAL''), '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''PROD-671'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES fun WHERE ' ||
					' fun.FUN_DESCRIPCION = ''TAB_HISTORICO_RESOLUCIONES_PROCURADOR'' ' ||
					' AND fun.FUN_ID NOT IN (SELECT FUN_ID FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID=(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO =''PROCUINTEGRAL''))';
	EXECUTE IMMEDIATE V_MSQL;				
					
	DBMS_OUTPUT.PUT_LINE('[INFO] Funciones insertadas.');
	
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
  	