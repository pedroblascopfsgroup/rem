--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170629
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2118
--## PRODUCTO=NO
--## Finalidad: Añadimos a la tabla ACT_PRT_PRESUPUESTO_TRABAJO el campo del Proveedor Contacto
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TABLA VARCHAR2(100 CHAR) := 'ACT_PRT_PRESUPUESTO_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COL_TO_INSERT VARCHAR2(100 CHAR) := 'PVC_ID'; -- Vble. auxiliar para almacenar el nombre de la columna a insertar.
    V_TIPO_COL_TO_INSERT VARCHAR2(100 CHAR) := 'NUMBER(16,0)'; -- Vble. auxiliar para almacenar el tipo de la columna a insertar.

    TABLE_NOT_EXISTS EXCEPTION;

    V_TABLA_FK VARCHAR2(40 CHAR) := 'ACT_PVC_PROVEEDOR_CONTACTO';
    V_FK VARCHAR2(40 CHAR) := 'FK_PRESUTRAB_PVE_CONTACTO';

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Vamos a incluir nuevos campos si no existen.');

	-- Comprobamos si existe la tabla a incluir nuevos campos
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Seguimos la ejecución.');
		
		-- Comprobamos si existe columna PVC_ID
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE UPPER(COLUMN_NAME)= UPPER('''||V_COL_TO_INSERT||''') and TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS = 1 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_TO_INSERT||'... Ya existe en la tabla');
		ELSE
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD ('||V_COL_TO_INSERT||' '||V_TIPO_COL_TO_INSERT||')';	
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_TO_INSERT||'... Creado');
		END IF;

	ELSE 
		DBMS_OUTPUT.PUT_LINE('[ALERT] ' || V_ESQUEMA || '.'||V_TABLA||'... La tabla no existe. No podemos incluir los nuevos campos.');
		RAISE TABLE_NOT_EXISTS;
	END IF;
	
 --** Comprobamos si existe la tabla FK
    V_SQL := 'select count(1) from ALL_CONSTRAINTS where constraint_name = '''||V_FK||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    IF V_NUM_TABLAS = 1 THEN 
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' DROP CONSTRAINT '||V_FK||'';        
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_FK||' FK BORRADO...');
    END IF;
    
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'
	         ADD CONSTRAINT '||V_FK||' FOREIGN KEY (PVC_ID) REFERENCES '||V_ESQUEMA||'.'||V_TABLA_FK||' (PVC_ID) ON DELETE SET NULL';        
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' NUEVA FK CREADA...'); 
EXCEPTION
     WHEN TABLE_NOT_EXISTS THEN
    	  DBMS_OUTPUT.PUT_LINE('La tabla no existe '||V_TABLA||'.');
	  DBMS_OUTPUT.PUT_LINE('KO!');
     WHEN OTHERS THEN 
          DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;