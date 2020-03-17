--/* 
--##########################################
--## AUTOR=Lara Pablo
--## FECHA_CREACION=20200218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v2.2.0
--## INCIDENCIA_LINK=HREOS-9445
--## PRODUCTO=NO
--##
--## Finalidad: Añadir campos TBJ_NUM_DND y TBJ_NOMBRE_DND a ACT_TBJ_TRABAJO
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
	V_TABLA VARCHAR2(50 CHAR):= 'ACT_TBJ_TRABAJO'; -- Nombre de la tabla a crear
	V_COL1 VARCHAR2(50 CHAR):= 'TBJ_NUM_DND'; --Nombre de la columna
	V_COL2 VARCHAR2(50 CHAR):= 'TBJ_NOMBRE_DND'; --Nombre de la columna
	
	V_TIPO1 VARCHAR2(250 CHAR):= 'NUMBER(16,0)';--Tipo nuevo campo
	V_TIPO2 VARCHAR2(250 CHAR):= 'VARCHAR2(100 CHAR)';--Tipo nuevo campo

 	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    
BEGIN   


  DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');  
--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN  

                             
            -- Verificar si el campo ya existe
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL1||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL1||'');  
                
                -- Añadimos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COL1||' '||V_TIPO1||'';    
                
                V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL1||' IS ''Número de la agrupación DND''';

				EXECUTE IMMEDIATE V_MSQL;
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA||'.'||V_COL1||'... YA existe.');
            END IF;    
            
            
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL2||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL2||'');  
                -- Añadimos el campo
                 EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COL2||' '||V_TIPO2||'';    
                
                V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL2||' IS ''Nombre de la agrupación DND''';

				EXECUTE IMMEDIATE V_MSQL;
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA||'.'||V_COL2||'... YA existe.');
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
