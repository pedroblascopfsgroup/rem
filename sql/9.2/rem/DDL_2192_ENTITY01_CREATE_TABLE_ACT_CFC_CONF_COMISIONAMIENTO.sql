--/*
--##########################################
--## AUTOR=Sonia Garcia
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=func-rem-comisionamiento
--## INCIDENCIA_LINK=HREOS-5639
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla nueva ACT_CFC_CONF_COMISIONAMIENT
--## INSTRUCCIONES:
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CFC_CONF_COMISIONAMIENT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

  --Array para crear las claves foraneas
  TYPE T_FK IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_FK IS TABLE OF T_FK;
  V_FK T_ARRAY_FK := T_ARRAY_FK(
      ------ ESQUEMA_ORIGEN --- TABLA_ORIGEN ------- CAMPO_ORIGEN ------- ESQUEMA_DESTINO ----- TABLA_DESTINO ------------------ CAMPO_DESTINO --- NOMBRE_F -------------------------    
T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'DD_ACC_ID'            ,''||V_ESQUEMA||''    ,'DD_ACC_ACCION_GASTOS'            ,'DD_ACC_ID'         ,'FK_ACT_CFC_DD_ACC_ID'),
T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'DD_TCO_ID'            ,''||V_ESQUEMA||''    ,'DD_TCO_TIPO_COMERCIALIZACION'    ,'DD_TCO_ID'         ,'FK_ACT_CFC_DD_TCO_ID'),
T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'DD_CTA_ID'            ,''||V_ESQUEMA||''    ,'DD_CTA_CONF_TIPO_ACTIVO'         ,'DD_CTA_ID'         ,'FK_ACT_CFC_DD_CTA_ID'),
T_FK(''||V_ESQUEMA||'', ''||V_TEXT_TABLA||''   ,'DD_CST_ID'            ,''||V_ESQUEMA||''    ,'DD_CST_CONF_SUBTIPO_ACTIVO'      ,'DD_CST_ID'         ,'FK_ACT_CFC_DD_CST_ID')
  );      
  V_TMP_FK T_FK;
  
BEGIN

-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;

-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		
	END IF; 
    
    -----------------------
    ---     TABLA       ---
    -----------------------
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME ='''||V_TEXT_TABLA||''' AND OWNER='''||V_ESQUEMA||''''
    INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
		V_SQL:= ' CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ( 
		  		CFC_ID				NUMBER(16,0)		NOT NULL ENABLE,
		  		CFC_ORIGEN			NUMBER(16,0)		NOT NULL,
		  		DD_ACC_ID			NUMBER(16,0)		NOT NULL,
		  		DD_TCO_ID			NUMBER(16,0)		NOT NULL,
				CFC_TRAMO_MINIMO		NUMBER(16,2),
				CFC_TRAMO_MAXIMO		NUMBER(16,2), 
				CFC_PORCENTAJE			NUMBER(16,2),
				CFC_VALOR_MINIMO		NUMBER(16,2),
				CFC_VALOR_MAXIMO		NUMBER(16,2),
				DD_CTA_ID			NUMBER(16,0),
				DD_CST_ID			NUMBER(16,0),
		  		VERSION				NUMBER(38,0)		DEFAULT 0 NOT NULL ENABLE,
	     	  		USUARIOCREAR			VARCHAR2(50 CHAR)	NOT NULL ENABLE, 
	      	  		FECHACREAR			TIMESTAMP (6)		NOT NULL ENABLE, 
	      	  		USUARIOMODIFICAR		VARCHAR2(50 CHAR), 
	      	  		FECHAMODIFICAR			TIMESTAMP (6), 
	     	  		USUARIOBORRAR			VARCHAR2(50 CHAR), 
	          		FECHABORRAR			TIMESTAMP (6), 
	          		BORRADO				NUMBER(1,0)		DEFAULT 0 NOT NULL ENABLE
		   )';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('['||V_TEXT_TABLA||' CREADA]');

		-- Creamos comentario tabla
		V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS ''Tabla para configuración de comisionamiento que calcula REM para las ofertas.'' ';      
		EXECUTE IMMEDIATE V_SQL;
				
		-- Creamos comentarios columnas
		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CFC_ID IS ''Código identificador único de configuración de comisionamiento.'' ';      
		EXECUTE IMMEDIATE V_SQL;		

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CFC_ORIGEN IS ''Origen.'' ';      
		EXECUTE IMMEDIATE V_SQL;	
		
		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_ACC_ID IS ''Código identificador de diccionario de acción de gastos'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TCO_ID IS ''Código identificador de diccionario del tipo de comercialización.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CFC_TRAMO_MINIMO IS ''Valor mínimo del tramo.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CFC_TRAMO_MAXIMO IS ''Valor máximo del tramo.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CFC_PORCENTAJE IS ''Porcentaje de comisionamiento.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CFC_VALOR_MINIMO IS ''Valor mínimo.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CFC_VALOR_MAXIMO IS ''Valor máximo.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_CTA_ID IS ''Código identificador de diccionario de configuración de tipo activo.'' ';      
		EXECUTE IMMEDIATE V_SQL;

		V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_CST_ID IS ''Código identificador de diccionario de configuración de subtipo activo.'' ';      
		EXECUTE IMMEDIATE V_SQL;
						
		
    END IF;
    
    ---------------------------
    -------     PK      -------
    ---------------------------
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P'''
        INTO V_NUM_TABLAS; 
        
    IF V_NUM_TABLAS > 0 THEN
        DBMS_OUTPUT.PUT_LINE('  [INFO] La PK PK_'||V_TEXT_TABLA||'... Ya existe.');                 
    ELSE
        DBMS_OUTPUT.PUT_LINE('  [INFO] Creando PK_'||V_TEXT_TABLA||'...');           
        /*PK_ACT_PRY_PROYECTO*/
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_TEXT_TABLA||' 
            ADD (CONSTRAINT PK_'||V_TEXT_TABLA||' PRIMARY KEY (CFC_ID))
        ';               
    END IF;    
    
    ---------------------------
    ---     SECUENCIA       ---
    ---------------------------
     EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME =''S_'||V_TEXT_TABLA||''' AND SEQUENCE_OWNER='''||V_ESQUEMA||''''
        INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[CREAMOS S_'||V_TEXT_TABLA||']');
		V_SQL:= 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[S_'||V_TEXT_TABLA||' CREADA]');
    END IF;
    
    --------------------------------
    ---     CLAVES FORANEAS      ---
    --------------------------------    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO CLAVES FORANEAS]');

    FOR J IN V_FK.FIRST .. V_FK.LAST
    LOOP
        V_TMP_FK := V_FK(J);
        
        EXECUTE IMMEDIATE '
          SELECT COUNT(1)
          FROM ALL_CONSTRAINTS CONS
            INNER JOIN ALL_CONS_COLUMNS COL ON COL.CONSTRAINT_NAME = CONS.CONSTRAINT_NAME
          WHERE CONS.OWNER = '''||V_TMP_FK(1)||''' 
            AND CONS.TABLE_NAME = '''||V_TMP_FK(2)||''' 
            AND CONS.CONSTRAINT_TYPE = ''R''
            AND COL.COLUMN_NAME = '''||V_TMP_FK(3)||'''
        '
        INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN
            DBMS_OUTPUT.PUT_LINE('  [INFO] La FK '||V_TMP_FK(7)||'... Ya existe.');                 
        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO] Creando '||V_TMP_FK(7)||'...');           
            
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_TMP_FK(1)||'.'||V_TMP_FK(2)||' 
                ADD (CONSTRAINT '||V_TMP_FK(7)||' FOREIGN KEY ('||V_TMP_FK(3)||') 
                REFERENCES '||V_TMP_FK(4)||'.'||V_TMP_FK(5)||' ('||V_TMP_FK(6)||') ON DELETE SET NULL)
            '
            ;               
        END IF;
    
    END LOOP; 
    DBMS_OUTPUT.PUT_LINE('[FIN CLAVES FORANEAS]');
    
    COMMIT;  
      
EXCEPTION
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
