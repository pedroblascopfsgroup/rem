--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190417
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6163
--## PRODUCTO=NO
--## Finalidad: Inserción de claves foraneas en ACT_HNG_HIST_NOTIF_GENCAT
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

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_HNG_HIST_NOTIF_GENCAT';
    V_TABLA_REF VARCHAR2(50 CHAR):= 'ADC_ADJUNTO_COMUNICACION';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  
    
BEGIN
	 
    DBMS_OUTPUT.PUT_LINE('******** '''||V_TABLA||''' - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' 
			  AND COLUMN_NAME = ''ADC_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS >= 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... El nuevo campo ya existe en la tabla. NO SE HACE NADA');
    ELSE
        V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' 
				  ADD ADC_ID NUMBER(16,0) CONSTRAINT FK_ADC_ID_HNG REFERENCES '|| V_ESQUEMA ||'.'|| V_TABLA_REF ||'(ADC_ID)
				  ';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA||'... Se ha añadido la columna ADC_ID y clave foranea con exito');
	END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' 
              AND COLUMN_NAME = ''ADC_ID_SANCION''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS >= 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... El nuevo campo ya existe en la tabla. NO SE HACE NADA');
    ELSE
        V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' 
                  ADD ADC_ID_SANCION NUMBER(16,0) CONSTRAINT FK_ADC_ID_SANCION_HNG REFERENCES '|| V_ESQUEMA ||'.'|| V_TABLA_REF ||'(ADC_ID)
                  ';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA||'... Se ha añadido la columna ADC_ID_SANCION y clave foranea con exito');
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' 
              AND COLUMN_NAME = ''DD_NOG_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS < 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... El campo no existe en la tabla. NO SE HACE NADA');
    ELSE
        V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY (DD_NOG_ID NUMBER(16,0) NULL)';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA||'... Se ha modificado la columna DD_NOG_ID');
    END IF;

    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' 
              AND COLUMN_NAME = ''FECHACREAR''';
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS < 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... El campo no existe en la tabla. NO SE HACE NADA');
    ELSE
        V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY (FECHACREAR TIMESTAMP(6), FECHAMODIFICAR TIMESTAMP(6), FECHABORRAR TIMESTAMP(6))';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA||'... Se han modificado las columnas de fechas de auditora');
    END IF;
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
