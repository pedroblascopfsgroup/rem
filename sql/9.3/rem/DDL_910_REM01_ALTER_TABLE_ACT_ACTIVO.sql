--/*
--##########################################
--## AUTOR= Juan Beltrán
--## FECHA_CREACION=20190722
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7073
--## PRODUCTO=NO
--##
--## Finalidad: Añadir nuevos campos en la tabla ACT_ACTIVO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_ACTIVO'; -- Nombre de la tabla 
    
    --Tipos de campo
    V_TIPO_NUM_LONG VARCHAR2(250 CHAR):= 'NUMBER(16,0)';
    V_TIPO_NUM_BOOL VARCHAR2(250 CHAR):= 'NUMBER(1,0)';
    V_TIPO_VARCHAR VARCHAR2(250 CHAR):= 'VARCHAR2(100 CHAR)';
	
    -- Nombre de tablas a REFERENCIAR
	V_TABLA_REF_SRA VARCHAR2(50 CHAR):= 'DD_SRA_SERVICER_ACTIVO';
	V_KEY_NAME_SRA VARCHAR2(50 CHAR):= 'FK_ACT_DD_SRA_ID';
	
	V_TABLA_REF_CMS VARCHAR2(50 CHAR):= 'DD_CMS_CESION_COM_SANEAMIENTO';
	V_KEY_NAME_CMS VARCHAR2(50 CHAR):= 'FK_ACT_DD_CMS_ID';
	
	--Nombre de las columnas
	V_COL_SRA VARCHAR2(50 CHAR):= 'DD_SRA_ID'; 
	V_COL_CMS VARCHAR2(50 CHAR):= 'DD_CMS_ID';
	V_COL_MAC VARCHAR2(50 CHAR):= 'ACT_PERIMETRO_MACC';
	V_COL_CAR VARCHAR2(50 CHAR):= 'ACT_PERIMETRO_CARTERA';
	V_COL_NCP VARCHAR2(50 CHAR):= 'ACT_NOM_CARTERA_PERIMETRO'; 	
	
    
BEGIN   


  DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');  

--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN  
 
  
            -- ******** DD_SRA_SERVICER_ACTIVO *******
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_SRA||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL_SRA||'');  
                
                -- Añadimos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COL_SRA||' '||V_TIPO_NUM_LONG||'';   
                -- Añadimos LA CLAVE AJENA
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT '||V_KEY_NAME_SRA||' FOREIGN KEY ('||V_COL_SRA||')
	  								REFERENCES '||V_ESQUEMA||'.'||V_TABLA_REF_SRA||' ('||V_COL_SRA||') ON DELETE SET NULL ENABLE';
	  			-- Añadimos el comentario al campo
                EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_SRA||' IS ''Código identificador único del diccionario.'''; 					
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA||'.'||V_COL_SRA||'... YA existe.');
            END IF;    
            
            
            
             -- ******** DD_CMS_CESION_COM_SANEAMIENTO *******             
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_CMS||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL_CMS||'');  
                
                -- Añadimos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COL_CMS||' '||V_TIPO_NUM_LONG||'';   
                -- Añadimos LA CLAVE AJENA
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT '||V_KEY_NAME_CMS||' FOREIGN KEY ('||V_COL_CMS||')
	  								REFERENCES '||V_ESQUEMA||'.'||V_TABLA_REF_CMS||' ('||V_COL_CMS||') ON DELETE SET NULL ENABLE';
	  			-- Añadimos el comentario al campo
                EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_CMS||' IS ''Código identificador único del diccionario.'''; 					
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA||'.'||V_COL_CMS||'... YA existe.');
            END IF;    
            
            
            
               -- ******** ACT_PERIMETRO_MACC *******             
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_MAC||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL_MAC||'');  
                
                -- Añadimos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COL_MAC||' '||V_TIPO_NUM_BOOL||'';
	  			-- Añadimos el comentario al campo
                EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_MAC||' IS ''Indicardor de si el activo pertenece al perímetro MACC'''; 					
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA||'.'||V_COL_MAC||'... YA existe.');
            END IF;    
            
            
            
             -- ******** ACT_PERIMETRO_CARTERA *******             
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_CAR||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL_CAR||'');  
                
                -- Añadimos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COL_CAR||' '||V_TIPO_NUM_BOOL||'';
	  			-- Añadimos el comentario al campo
                EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_CAR||' IS ''Indicardor de si el activo pertenece al perímetro Cartera'''; 					
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA||'.'||V_COL_CAR||'... YA existe.');
            END IF;    
            
            
            
              -- ******** ACT_NOM_CARTERA_PERIMETRO *******             
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_NCP||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL_NCP||'');  
                
                -- Añadimos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COL_NCP||' '||V_TIPO_VARCHAR||'';
	  			-- Añadimos el comentario al campo
                EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_NCP||' IS ''Campo que permite identificar la Cartera por nombre'''; 					
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA||'.'||V_COL_NCP||'... YA existe.');
            END IF;    

    
  ELSE
      DBMS_OUTPUT.PUT_LINE(' [INFO] '''||V_TABLA||'''... No existe.');  
  END IF;
  DBMS_OUTPUT.PUT_LINE('[FIN CAMPOS]');
            

  COMMIT;
           
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;

/

EXIT;
