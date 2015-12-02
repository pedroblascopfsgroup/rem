--/*
--##########################################
--## AUTOR=Agustin Mompo
--## FECHA_CREACION=20150914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=PRODUCTO-180
--## PRODUCTO=SI
--##
--## Finalidad:Modifica el estado de acuerdo "En Conformación" por "En preparaciones
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
    V_DDNAME VARCHAR2(30):= 'DD_EAC_ESTADO_ACUERDO';
BEGIN	

    
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.'||V_DDNAME||' WHERE DD_EAC_CODIGO= ''01''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('No existe ese codigo en la base de datos');
	  DBMS_OUTPUT.PUT_LINE('[INFO] No se ha podido modificar el estado de acuerdo En Conformacion '||V_DDNAME||'.');
	
	ELSE
	
	  execute immediate 'UPDATE '||V_ESQUEMA_M||'.'||V_DDNAME||' '||
	  ' SET DD_EAC_DESCRIPCION = ''En Preparacion'',DD_EAC_DESCRIPCION_LARGA=''En Preparacion'' WHERE DD_EAC_CODIGO = ''01'' ';
	
	  DBMS_OUTPUT.PUT_LINE('Estado de Acuerdo 01 modificado');
	
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
  	