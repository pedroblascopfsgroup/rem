--/*
--##########################################
--## AUTOR=Sergio Salt
--## FECHA_CREACION=20190131
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5208
--## PRODUCTO=SI
--## Finalidad: DDL Modificacion de la tabla PCO_PRC_PROCEDIMIENTOS
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NOMBRE_TABLA VARCHAR2(50 CHAR) := 'ACT_CAN_CALIFICACION_NEG'; -- Vble. auxiliar para el nombre de la tabla.
    V_NOMBRE_TABLA_REF1 VARCHAR2(50 CHAR) := 'DD_EMN_ESTADO_MOTIVO_CAL_NEG';
    V_NOMBRE_TABLA_REF2 VARCHAR2(50 CHAR) := 'DD_RSU_RESPONSABLE_SUBSANAR';
    V_NOMBRE_COL_1 VARCHAR2(50 CHAR) := 'DD_EMN_ID'; -- Vble. auxiliar para el nombre de la columna.
    V_NOMBRE_COL_2 VARCHAR2(50 CHAR) := 'DD_RSU_ID'; -- Vble. auxiliar para el nombre de la columna.
    V_TIPO VARCHAR (27 CHAR) := 'NUMBER (16,0)'; -- Vble. auxiliar para el tipo de la columna
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    BEGIN
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla
    IF V_NUM_TABLAS = 1 THEN
    		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' AND COLUMN_NAME = '''|| V_NOMBRE_COL_1||''' ';
    		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    		--si no existe la columna la creamos
    		IF V_NUM_TABLAS = 0 THEN
	            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||' ADD '|| V_NOMBRE_COL_1||' '|| V_TIPO;
	            EXECUTE IMMEDIATE V_MSQL;   
	            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_NOMBRE_TABLA||' columna '|| V_NOMBRE_COL_1||' añadida');
                ELSE 
                    DBMS_OUTPUT.PUT_LINE('[INFO] La columna ' ||V_NOMBRE_COL_1 || ' ya existe ');
            END IF;	
	        V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' AND COLUMN_NAME = '''||V_NOMBRE_COL_2||''' ';
    		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    		--si no existe la columna la creamos
    		IF V_NUM_TABLAS = 0 THEN
	            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||' ADD '||V_NOMBRE_COL_2||' '|| V_TIPO;
	            EXECUTE IMMEDIATE V_MSQL;
                COMMIT;       
	            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA ||'.'||V_NOMBRE_TABLA||' columna '||V_NOMBRE_COL_2||' añadida');
            ELSE 
                    DBMS_OUTPUT.PUT_LINE('[INFO] La columna ' ||V_NOMBRE_COL_2 || ' ya existe ');
	        END IF;
    ELSE	
		    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA ||'.'||V_NOMBRE_TABLA||'... La tabla NO existe.');
    END IF;


    --Restricciones 
   
    
    
        DBMS_OUTPUT.PUT_LINE('[INFO] Añadiendo las restricciones a las columnas añadidas ');
    V_SQL := 'SELECT COUNT(CONSTRAINT_NAME) FROM USER_CONS_COLUMNS WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' AND COLUMN_NAME = '''|| V_NOMBRE_COL_1||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 0 THEN
    
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_NOMBRE_TABLA_REF1||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
            V_SQL := 'ALTER TABLE '|| V_NOMBRE_TABLA||' ADD CONSTRAINT FK_'||V_NOMBRE_COL_1||' FOREIGN KEY ('||V_NOMBRE_COL_1||') REFERENCES   '||V_NOMBRE_TABLA_REF1||' ('||V_NOMBRE_COL_1||')';
            EXECUTE IMMEDIATE V_SQL;
        END IF;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('[INFO] La columna ' ||V_NOMBRE_COL_1 || ' ya posee la restriccion pertinente');
    END IF;
        V_SQL := 'SELECT COUNT(CONSTRAINT_NAME) FROM USER_CONS_COLUMNS WHERE TABLE_NAME = '''||V_NOMBRE_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' AND COLUMN_NAME = '''|| V_NOMBRE_COL_2||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 0 THEN
            
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_NOMBRE_TABLA_REF2||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         IF V_NUM_TABLAS = 1 THEN
            V_SQL := 'ALTER TABLE '|| V_NOMBRE_TABLA||' ADD CONSTRAINT FK_'||V_NOMBRE_COL_2||' FOREIGN KEY ('||V_NOMBRE_COL_2||') REFERENCES   '||V_NOMBRE_TABLA_REF2||' ('||V_NOMBRE_COL_2||')';
            EXECUTE IMMEDIATE V_SQL;
            COMMIT;
        END IF;
    ELSE 
    DBMS_OUTPUT.PUT_LINE('[INFO] La columna ' || V_NOMBRE_COL_2 || ' ya posee la restriccion pertinente');
    END IF;
    
    --Comentarios
    DBMS_OUTPUT.PUT_LINE('[INFO] Añadiendo los comentarios a las columnas añadidas ');

       V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||'.'||V_NOMBRE_COL_1||' IS ''Clave ajena '||V_NOMBRE_TABLA_REF1||'.''';    EXECUTE IMMEDIATE V_SQL;
       
       V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_NOMBRE_TABLA||'.'||V_NOMBRE_COL_2||' IS ''Clave ajena '||V_NOMBRE_TABLA_REF2||'.''';    EXECUTE IMMEDIATE V_SQL;


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
