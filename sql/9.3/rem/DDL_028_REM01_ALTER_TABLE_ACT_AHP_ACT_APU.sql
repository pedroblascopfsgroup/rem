--/* 
--##########################################
--## AUTOR=Sergio Salt
--## FECHA_CREACION=20191225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8886
--## PRODUCTO=NO
--##
--## Finalidad: Añadir un nuevo campo en la tabla ACT_AHP_HIST_PUBLICACION , ACT_APU_ESTADO_PUBLICACION
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
	V_TABLA_1 VARCHAR2(50 CHAR):= 'ACT_AHP_HIST_PUBLICACION'; -- Nombre de la tabla a crear
  V_TABLA_2 VARCHAR2(50 CHAR):= 'ACT_APU_ACTIVO_PUBLICACION'; -- Nombre de la tabla a crear
	V_TABLA_REF VARCHAR2(50 CHAR):= 'DD_POR_PORTAL'; -- Nombre de la tabla a REFERENCIAR
	V_COL VARCHAR2(50 CHAR):= 'DD_POR_ID'; --Nombre de la columna
	 V_TIPO VARCHAR2(250 CHAR):= 'NUMBER(16,0)';--Tipo nuevo campo
	 V_KEY_NAME VARCHAR2(50 CHAR):= 'FK_DD_POR_ID';
   V_KEY_NAME_2 VARCHAR2(50 CHAR):= 'FK_DD_POR_ID_APU';
 	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    
BEGIN   


  DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');  

--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_1||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN                        
      -- Verificar si el campo ya existe
      V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_1||''' AND COLUMN_NAME = '''||V_COL||'''';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
      
      IF V_NUM_TABLAS = 0 THEN
          DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL||'');  
          
          -- Añadimos el campo
          EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' ADD '||V_COL||' '||V_TIPO||'';   
          -- Añadimos LA CLAVE AJENA
          EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' ADD CONSTRAINT '||V_KEY_NAME||' FOREIGN KEY ('||V_COL||')
              REFERENCES '||V_ESQUEMA||'.'||V_TABLA_REF||' ('||V_COL||') ON DELETE SET NULL ENABLE';
      -- Añadimos el comentario al campo
          EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA_1||'.'||V_COL||' IS ''Código identificador único de DD_POR_PORTAL.'''; 					
      ELSE
          DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA_1||'.'||V_COL||'... YA existe.');
      END IF;    
  ELSE
      DBMS_OUTPUT.PUT_LINE(' [INFO] '''||V_TABLA_1||'''... No existe.');  
  END IF;
  
--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_2||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN                         
    -- Verificar si el campo ya existe
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_2||''' AND COLUMN_NAME = '''||V_COL||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
    
    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL||'');  
        
        -- Añadimos el campo
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' ADD '||V_COL||' '||V_TIPO||'';   
        -- Añadimos LA CLAVE AJENA
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' ADD CONSTRAINT '||V_KEY_NAME_2||' FOREIGN KEY ('||V_COL||')
            REFERENCES '||V_ESQUEMA||'.'||V_TABLA_REF||' ('||V_COL||') ON DELETE SET NULL ENABLE';
    -- Añadimos el comentario al campo
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA_2||'.'||V_COL||' IS ''Código identificador único de DD_POR_PORTAL.'''; 					
    ELSE
        DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA_2||'.'||V_COL||'... YA existe.');
    END IF;    

  ELSE
      DBMS_OUTPUT.PUT_LINE(' [INFO] '''||V_TABLA_2||'''... No existe.');  
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
