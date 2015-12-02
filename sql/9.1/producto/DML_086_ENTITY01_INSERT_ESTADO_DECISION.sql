--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20151103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=CMREC-887
--## PRODUCTO=SI
--##
--## Finalidad:Crear el estado en conformación
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
    V_DDNAME VARCHAR2(30):= 'DD_EDE_ESTADOS_DECISION';
BEGIN	

    
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.'||V_DDNAME||' WHERE DD_EDE_CODIGO= ''04''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el estado de decisión EN_CONFORMACION '||V_DDNAME||'.');
	
	ELSE
	
	  execute immediate 'Insert into '||V_ESQUEMA_M||'.'||V_DDNAME||' '||
	  '(DD_EDE_ID, DD_EDE_CODIGO,DD_EDE_DESCRIPCION,DD_EDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values '||
	  '('||V_ESQUEMA_M||'.S_DD_EDE_ESTADOS_DECISION.nextval,''04'',''EN CONFORMACIÓN'',''EN CONFORMACIÓN'',''0'',''DD'',sysdate,''0'') ';
	
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
  	