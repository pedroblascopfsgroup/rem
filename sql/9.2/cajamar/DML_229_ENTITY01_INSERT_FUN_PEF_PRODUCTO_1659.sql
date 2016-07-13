--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160713
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=PRODUCTO-1659
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_PEF_ID NUMBER(16); -- Vble. para guardar el id del perfil 
    V_FUN_ID NUMBER(16); -- Vble. para guardar el id de la funcion 
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... Comprobaciones previas SUP_SSCC'); 

    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUP_SSCC''';

	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN	  
	
	    V_SQL :='SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUP_SSCC''';
	    -- Nos guardamos el id del perfil
	    EXECUTE IMMEDIATE V_SQL INTO V_PEF_ID;

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''MODIFICAR_RIESGO_OPERACIONAL'''; 
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN	  

		    V_SQL :='SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''MODIFICAR_RIESGO_OPERACIONAL'''; 
		    EXECUTE IMMEDIATE V_SQL INTO V_FUN_ID;
		    
		    		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = '||V_FUN_ID||' AND PEF_ID = '||V_PEF_ID||''; 
			    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	        IF V_NUM_TABLAS = 0 THEN	  
	
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ( '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, '||V_FUN_ID||', '||V_PEF_ID||',''PRODUCTO-1659'', SYSDATE, 0)';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.FUN_PEF');
				
			ELSE 
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro en '||V_ESQUEMA||'.FUN_PEF');
    		END IF;


		ELSE 
				DBMS_OUTPUT.PUT_LINE('[INFO] No existe la funcion en la tabla '||V_ESQUEMA_M||'.FUN_FUNCIONES.');
	
	    END IF;
	
	ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] No existe el perfil SER_CENTRALES en la tabla '||V_ESQUEMA||'.PEF_PERFILES.');
    	  	
    END IF;	
    
    
    
    
    DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... Comprobaciones previas SUP_SSCC'); 

    V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUP_SSCC''';

	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN	  
	
	    V_SQL :='SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUP_SSCC''';
	    -- Nos guardamos el id del perfil
	    EXECUTE IMMEDIATE V_SQL INTO V_PEF_ID;

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''MODIFICAR_RIESGO_OPERACIONAL'''; 
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN	  

		    V_SQL :='SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''MODIFICAR_RIESGO_OPERACIONAL'''; 
		    EXECUTE IMMEDIATE V_SQL INTO V_FUN_ID;
		    
		    		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = '||V_FUN_ID||' AND PEF_ID = '||V_PEF_ID||''; 
			    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	        IF V_NUM_TABLAS = 0 THEN	  
	
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FP_ID, FUN_ID, PEF_ID, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ( '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, '||V_FUN_ID||', '||V_PEF_ID||',''PRODUCTO-1659'', SYSDATE, 0)';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.FUN_PEF');
				
			ELSE 
				DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro en '||V_ESQUEMA||'.FUN_PEF');
    		END IF;


		ELSE 
				DBMS_OUTPUT.PUT_LINE('[INFO] No existe la funcion en la tabla '||V_ESQUEMA_M||'.FUN_FUNCIONES.');
	
	    END IF;
	
	ELSE
    	DBMS_OUTPUT.PUT_LINE('[INFO] No existe el perfil SUP_SSCC en la tabla '||V_ESQUEMA||'.PEF_PERFILES.');
    	  	
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
