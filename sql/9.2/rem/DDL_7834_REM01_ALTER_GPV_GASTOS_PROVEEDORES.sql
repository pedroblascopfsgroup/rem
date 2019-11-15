--/*
--##########################################
--## AUTOR=MARIAM LLISO
--## FECHA_CREACION=20191001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7830
--## PRODUCTO=NO
--##
--## Finalidad: Añadir nuevos campos en la tabla GDE_GASTOS_DETALLE_ECONOMICO Y GPV_GASTOS_PROVEEDOR
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
    
    -- Tablas
    V_TABLA_GPV VARCHAR2(50 CHAR):= 'GPV_GASTOS_PROVEEDOR'; -- Nombre de la tabla GPV_GASTOS_PROVEEDOR
    V_TABLA_GDE VARCHAR2(50 CHAR):= 'GDE_GASTOS_DETALLE_ECONOMICO'; -- Nombre de la tabla GDE_GASTOS_DETALLE_ECONOMICO
    
    --Tipos de campo
    V_TIPO_NUM_BOOL VARCHAR2(250 CHAR):= 'NUMBER(1,0)';
    V_TIPO_NUM VARCHAR2(250 CHAR):= 'NUMBER(16,0)';
    V_TIPO_VARCHAR VARCHAR2(250 CHAR):= 'VARCHAR2(50 CHAR)';
	
    -- Nombre de tablas a REFERENCIAR
	V_TABLA_REF_TRG VARCHAR2(50 CHAR):= 'DD_TRG_TIPO_RECARGO_GASTO';
	V_KEY_NAME_TRG  VARCHAR2(50 CHAR):= 'FK_GDE_DD_TRG_ID';
	
	--Nombre de las columnas
	V_COL_GPV VARCHAR2(50 CHAR):= 'GPV_IDENTIFICADOR_UNICO';
	
	V_COL_GDE 	 VARCHAR2(50 CHAR):= 'GDE_EXISTE_RECARGO';
	V_COL_DD_TRG VARCHAR2(50 CHAR):= 'DD_TRG_ID'; 	
    
BEGIN   


  DBMS_OUTPUT.PUT_LINE('[INICIO INSERT CAMPOS EN '||V_TABLA_GPV||']');  

--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_GPV||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN             
            
            ---------		GPV_GASTOS_PROVEEDOR
                         
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_GPV||''' AND COLUMN_NAME = '''||V_COL_GPV||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL_GPV||'');  
                
                -- Añadimos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_GPV||' ADD '||V_COL_GPV||' '||V_TIPO_VARCHAR||'';
	  			-- Añadimos el comentario al campo
                EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA_GPV||'.'||V_COL_GPV||' IS ''Identificador unico del gasto'''; 					
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA_GPV||'.'||V_COL_GPV||'... YA existe.');
            END IF;    

    
  ELSE
      DBMS_OUTPUT.PUT_LINE(' [INFO] '''||V_TABLA_GPV||'''... No existe.');  
  END IF;
  DBMS_OUTPUT.PUT_LINE('[FIN CAMPOS NUEVOS EN '||V_TABLA_GPV||']');
  
  
  
            

  DBMS_OUTPUT.PUT_LINE('[INICIO INSERT CAMPOS EN '||V_TABLA_GDE||']');  

--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_GDE||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN         
  
		V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_REF_TRG||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
		IF V_NUM_TABLAS > 0 THEN    
            
					---------		GDE_EXISTE_RECARGO
								
					V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_GDE||''' AND COLUMN_NAME = '''||V_COL_GDE||'''';
					EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
					
					IF V_NUM_TABLAS = 0 THEN
						DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL_GDE||'');  
						
						-- Añadimos el campo
						EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_GDE||' ADD '||V_COL_GDE||' '||V_TIPO_NUM_BOOL||' DEFAULT 0';
						-- Añadimos el comentario al campo
						EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA_GDE||'.'||V_COL_GDE||' IS ''Identificador si existe recargo o no'''; 					
					ELSE
						DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA_GDE||'.'||V_COL_GDE||'... YA existe.');
					END IF;    
		
					---------		GDE_EXISTE_RECARGO
					V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_GDE||''' AND COLUMN_NAME = '''||V_COL_DD_TRG||'''';
					EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
					
					IF V_NUM_TABLAS = 0 THEN
						DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL_DD_TRG||'');                  
						-- Añadimos el campo
						EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_GDE||' ADD '||V_COL_DD_TRG||' '||V_TIPO_NUM||'';   
						-- Añadimos LA CLAVE AJENA
						EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_GDE||' ADD CONSTRAINT '||V_KEY_NAME_TRG||' FOREIGN KEY ('||V_COL_DD_TRG||')
											REFERENCES '||V_ESQUEMA||'.'||V_TABLA_REF_TRG||' ('||V_COL_DD_TRG||') ON DELETE SET NULL ENABLE';
						-- Añadimos el comentario al campo
						EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA_GDE||'.'||V_COL_DD_TRG||' IS ''Código identificador único del diccionario.'''; 					
					ELSE
						DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA_GDE||'.'||V_COL_DD_TRG||'... YA existe.');
					END IF;  
		
		ELSE
		DBMS_OUTPUT.PUT_LINE(' [INFO] '''||V_TABLA_REF_TRG||'''... No existe.');
		
  ELSE
      DBMS_OUTPUT.PUT_LINE(' [INFO] '''||V_TABLA_GDE||'''... No existe.');  
  
  END IF;
  DBMS_OUTPUT.PUT_LINE('[FIN CAMPOS NUEVOS EN '||V_TABLA_GDE||']');	
	
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
