--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160311
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-858
--## PRODUCTO=NO
--## Finalidad: DML Insertar operacion nueva en DD_OPM_OPERACION_MASIVA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR); -- Vble. para la realización de la sentencia.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

    BEGIN
		DBMS_OUTPUT.PUT_LINE('******** DD_OPM_OPERACION_MASIVA ********'); 
		
		V_MSQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.DD_OPM_OPERACION_MASIVA WHERE DD_OPM_CODIGO=''CA_AC'' ';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
		    V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.DD_OPM_OPERACION_MASIVA(DD_OPM_ID, DD_OPM_CODIGO, DD_OPM_DESCRIPCION, DD_OPM_DESCRIPCION_LARGA, FUN_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_OPM_VALIDACION_FORMATO ) '||
		    ' VALUES ('||V_ESQUEMA||'.S_DD_OPM_OPERACION_MASIVA.NEXTVAL,''CA_AC'',''Carterización de acreditados'',''Carterización de acreditados'', (select fun_id from ' || V_ESQUEMA_M || '.FUN_FUNCIONES where fun_descripcion=''FUN_OM_CARAC_ACRED''), 0, ''PRODUCTO-858'',sysdate, 0,''s*,s,s,s,s*'' )';
	    	EXECUTE IMMEDIATE V_MSQL;  
	    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_OPM_OPERACION_MASIVA... filas actualizadas');
    	ELSE
	    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_OPM_OPERACION_MASIVA... DD_OPM_CODIGO: CA_AC ya existe ');  	
  		END IF;

  		
    	DBMS_OUTPUT.PUT_LINE('******** POP_PLANTILLAS_OPERACION ********'); 
		
		V_MSQL := 'SELECT COUNT(1) FROM ' || V_ESQUEMA || '.POP_PLANTILLAS_OPERACION WHERE DD_OPM_ID IN '||
		'(SELECT DD_OPM_ID FROM DD_OPM_OPERACION_MASIVA WHERE DD_OPM_CODIGO = ''CA_AC'') ';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
		    V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.POP_PLANTILLAS_OPERACION(POP_ID, POP_NOMBRE, POP_DIRECTORIO, DD_OPM_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '||
		    ' VALUES ('||V_ESQUEMA||'.S_POP_PLANTILLAS_OPERACION.NEXTVAL,''Acreditados'',''Plantilla_Acreditados.xls'', (SELECT DD_OPM_ID FROM ' || V_ESQUEMA || '.DD_OPM_OPERACION_MASIVA WHERE '||
			' DD_OPM_CODIGO = ''CA_AC'') , 0, ''PRODUCTO-858'',sysdate, 0)';
	    	EXECUTE IMMEDIATE V_MSQL;   
	    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.POP_PLANTILLAS_OPERACION... filas actualizadas'); 
    	ELSE
	    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.POP_PLANTILLAS_OPERACION... DD_OPM_ID ya existe con DD_OPM_CODIGO: CA_AC en DD_OPM_OPERACION_MASIVA ');  	
  		END IF;    	
 
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