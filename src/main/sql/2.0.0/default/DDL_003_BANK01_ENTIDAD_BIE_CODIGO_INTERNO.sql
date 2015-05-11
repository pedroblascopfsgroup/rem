--/*
--##########################################
--## Author: Fran Gutiérrez
--## Finalidad: DDL modificación tipo de datos de BIE_CODIGO_INTERNO sin perder los datos de la tabla BIE_BIEN_ENTIDAD
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR);   
    -- Configuracion Esquemas
    V_ESQUEMA VARCHAR2(25 CHAR) := 'BANK01';
    -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL VARCHAR2(4000 CHAR);
    -- Vble. para validar la existencia de una tabla.    
    V_NUM_TABLAS NUMBER(16);
    -- Vble. auxiliar para registrar errores en el script.
    ERR_NUM NUMBER(25);
    -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR);
BEGIN
        
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD ADD BIE_CODIGO_INTERNO_AUX VARCHAR(50 CHAR)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO BIE_CODIGO_INTERNO_AUX');      
        
        V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD SET BIE_CODIGO_INTERNO_AUX = TO_CHAR(BIE_CODIGO_INTERNO)';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADA BIE_CODIGO_INTERNO_AUX');  
        
        COMMIT; 
        
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD DROP COLUMN BIE_CODIGO_INTERNO';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO BIE_CODIGO_INTERNO ANTIGUO');
        
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD RENAME COLUMN BIE_CODIGO_INTERNO_AUX TO BIE_CODIGO_INTERNO';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] RENOMBRADO NUEVO BIE_CODIGO_INTERNO');
        
        COMMIT;
        
EXCEPTION        
		WHEN OTHERS THEN  
			ERR_NUM := SQLCODE;
			ERR_MSG := SQLERRM;
			DBMS_OUTPUT.put_line('Error:'||TO_CHAR(ERR_NUM));
			DBMS_OUTPUT.put_line(ERR_MSG);  
			ROLLBACK;
			RAISE;
END;
/
