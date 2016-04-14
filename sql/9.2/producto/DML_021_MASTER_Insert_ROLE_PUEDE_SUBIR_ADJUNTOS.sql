--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160414
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.2
--## INCIDENCIA_LINK= PRODUCTO-1093
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_NUM_REGS NUMBER(16); -- Vble. para validar la existencia de un registro  
    V_NUM_SEQUENCE NUMBER(16);     
    V_NUM_MAXID NUMBER(16);
    
BEGIN	

    
    V_SQL := 'SELECT '||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
    DBMS_OUTPUT.PUT_LINE(V_NUM_SEQUENCE);
    
    V_SQL := 'SELECT NVL(MAX(FUN_ID), 0) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
    DBMS_OUTPUT.PUT_LINE(V_NUM_MAXID);
    
    WHILE V_NUM_SEQUENCE < V_NUM_MAXID LOOP
    V_SQL := 'SELECT '||V_ESQUEMA||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
    
    END LOOP;
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION= ''ROLE_VER_CAMPO_POSTORES''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el ROLE_PUEDE_SUBIR_ADJUNTOS');
	
	ELSE
	  V_MSQL:= 'INSERT INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA,FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.nextval,''Función que permite subir adjuntos'',''ROLE_PUEDE_SUBIR_ADJUNTOS'',''0'',''PRODUCTO-1206'',sysdate,''0'') ';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE('OK INSERTADO');
	
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
  	