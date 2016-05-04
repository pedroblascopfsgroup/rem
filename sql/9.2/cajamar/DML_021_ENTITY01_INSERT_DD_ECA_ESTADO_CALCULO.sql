--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20160504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.
--## INCIDENCIA_LINK= PRODUCTO-1294
--## PRODUCTO=SI
--##
--## Finalidad: Introducir datos en el diccionario DD_ECA_ESTADO_CALCULO
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
    V_MAX_ID NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('******** DD_ECA_ESTADO_CALCULO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_ECA_ESTADO_CALCULO... Comprobaciones previas'); 
    
    	-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_ECA_ESTADO_CALCULO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existe la rellenamos
    IF V_NUM_TABLAS = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] Existe la tabla: '||V_ESQUEMA||'.DD_ECA_ESTADO_CALCULO... Comenzamos la inserción de datos'); 
    	
    	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ECA_ESTADO_CALCULO WHERE DD_ECA_DESCRIPCION = ''PTE.CÁLCULO'' or DD_ECA_DESCRIPCION = ''CALCULADA''';
   	 	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
   	 	
   	 	-- Si la tabla no tiene ya los registros los inserta
   	 	IF V_NUM_TABLAS < 1 THEN
    	
    		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ECA_ESTADO_CALCULO (DD_ECA_ID,DD_ECA_CODIGO,DD_ECA_DESCRIPCION,DD_ECA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES (' || V_ESQUEMA || '.S_DD_ECA_ESTADO_CALCULO.nextval,''PTE'',''PTE.CÁLCULO'',''PTE.CÁLCULO'',''0'',''DML'',SYSDATE,null,null,null,null,''0'')';
	    	DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('OK INSERTADO');
		
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ECA_ESTADO_CALCULO (DD_ECA_ID,DD_ECA_CODIGO,DD_ECA_DESCRIPCION,DD_ECA_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) VALUES (' || V_ESQUEMA || '.S_DD_ECA_ESTADO_CALCULO.nextval,''CAL'',''CALCULADA'',''CALCULADA'',''0'',''DML'',SYSDATE,null,null,null,null,''0'')';
	   	 	DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('OK INSERTADO');
		ELSE
			DBMS_OUTPUT.PUT_LINE('Ya existe alguno de los registros que se quieren insertar');
		END IF;
    	
    
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
  	