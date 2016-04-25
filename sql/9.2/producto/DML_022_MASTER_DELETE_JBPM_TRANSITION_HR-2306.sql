--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160422
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.2
--## INCIDENCIA_LINK=HR-2306
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	

    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.JBPM_NODE jno, '||V_ESQUEMA_M||'.JBPM_TRANSITION jtr WHERE class_ = ''F'' AND jno.ID_  = jtr.FROM_ AND jtr.NAME_ LIKE ''activarProrroga''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] No existen transiciones a sí mismos en nodos fork');
	ELSE
	  V_MSQL:= 'DELETE FROM '||V_ESQUEMA_M||'.JBPM_TRANSITION jtr WHERE jtr.ID_ IN (SELECT jtr.id_ FROM '||V_ESQUEMA_M||'.JBPM_NODE jno, '||V_ESQUEMA_M||'.JBPM_TRANSITION jtr WHERE class_ = ''F'' AND jno.ID_  = jtr.FROM_ AND jtr.NAME_ LIKE ''activarProrroga'')';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE(V_NUM_TABLAS || 'registros borrados');
	
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
  	