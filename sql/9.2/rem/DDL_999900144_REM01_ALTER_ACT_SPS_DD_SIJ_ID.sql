--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171121
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3277
--## PRODUCTO=NO
--## Finalidad: Modificar nombre y FK
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
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_SPS_SIT_POSESORIA';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN
	 
    DBMS_OUTPUT.PUT_LINE('******** '''||V_TABLA||''' - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' 
		AND COLUMN_NAME = ''SPS_DISPONIBILIDAD_JURIDICA''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... No existe el campo a renombrar');
    ELSE
        V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'
  			RENAME COLUMN SPS_DISPONIBILIDAD_JURIDICA TO DD_SIJ_ID';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA||'... Se ha renombrado el nuevo campo con éxito');
	END IF;

	-- Comprobamos si existe FK hacia DD_SIJ_SITUACION_JURIDICA
	V_SQL := 'SELECT COUNT(1) FROM ALL_CONS_COLUMNS T1
		JOIN ALL_CONSTRAINTS T2 ON T1.CONSTRAINT_NAME = T2.CONSTRAINT_NAME
		WHERE T1.COLUMN_NAME = ''DD_SIJ_ID'' AND T1.TABLE_NAME = '''||V_TABLA||'''
		    AND T1.OWNER = '''||V_ESQUEMA||'''  AND T2.CONSTRAINT_TYPE = ''R'' AND T1.POSITION = 1';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Ya existe la clave foránea sobre DD_SIJ_ID.');
    ELSE
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'
			ADD CONSTRAINT FK_DD_SIJ_ID_SPS
			  FOREIGN KEY (DD_SIJ_ID)
			  REFERENCES '||V_ESQUEMA||'.DD_SIJ_SITUACION_JURIDICA(DD_SIJ_ID)';
        EXECUTE IMMEDIATE V_SQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TABLA||'... Se ha creado la nueva clave foránea.');
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
