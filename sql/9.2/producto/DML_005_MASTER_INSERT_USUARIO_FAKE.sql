--/*
--##########################################
--## AUTOR=Carlos Perez
--## FECHA_CREACION=20160307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0
--## INCIDENCIA_LINK=CMREC-2422
--## PRODUCTO=SI
--##
--## Finalidad: Se crea usuario FAKE para que el batch pueda obtener un usuario logado por defecto
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
    V_DDNAME VARCHAR2(30):= 'USU_USUARIOS';
BEGIN	

    
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.'||V_DDNAME||' WHERE USU_ID= 1';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el usuario fake en '||V_DDNAME||'.');
	
	ELSE
	
	 	V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_DDNAME||' ( usu_id, entidad_id, usu_username, usu_password, usu_nombre, usuariocrear, fechacrear, borrado, usu_externo, usu_fecha_vigencia_pass, usu_grupo, usu_baja_ldap ) VALUES ' ||
				'(1, (select DATAVALUE from ENTIDADCONFIG where datakey = ''initialId'' and rownum = 1), ''BATCH_USER'', ''BATCH_1234'', ''BATCH_USER'', ''CMREC-2422'', SYSDATE, 0, 0, SYSDATE+365, 0,1)';
		DBMS_OUTPUT.put_line(V_SQL);
		execute immediate V_SQL;
		DBMS_OUTPUT.PUT_LINE('Usuario Batch añadido OK');
		
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
  	