--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200116
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6206
--## PRODUCTO=NO
--## Finalidad: Editar tipo de campos en tablas
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TABLA VARCHAR2(50 CHAR):= 'APR_AUX_GES_GASTOS_GR_REJ'; -- Nombre de la tabla 
    V_TABLA_2 VARCHAR2(50 CHAR):= 'H_GGR_GES_GASTOS_RECH'; -- Nombre de la tabla 
    
    --Tipos de campo
    V_TIPO_VARCHAR VARCHAR2(250 CHAR):= 'VARCHAR2(10 CHAR)';
	
    --Nombre de las columnas
    V_FECHA_GES VARCHAR2(50 CHAR):= 'FECHA_REC_GEST'; 
    V_FECHA_HAYA VARCHAR2(50 CHAR):= 'FECHA_REC_HAYA'; 
    V_FECHA_PROP VARCHAR2(50 CHAR):= 'FECHA_REC_PROP'; 
	
    
BEGIN   


  DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');  

--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN  
 
  
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_FECHA_GES||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS > 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] MODIFICAMOS EL CAMPO '||V_FECHA_GES||'');  
                
                --Editamos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY '||V_FECHA_GES||' '||V_TIPO_VARCHAR||'';   

 		ELSE
               	 DBMS_OUTPUT.PUT_LINE('  [INFO] NO EXISTE EL CAMPO');
            	END IF;  

	    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_FECHA_HAYA||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 

	    IF V_NUM_TABLAS > 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] MODIFICAMOS EL CAMPO '||V_FECHA_HAYA||'');  
                
                --Editamos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY '||V_FECHA_HAYA||' '||V_TIPO_VARCHAR||'';   

 		ELSE
               	 DBMS_OUTPUT.PUT_LINE('  [INFO] NO EXISTE EL CAMPO');
            	END IF;  

 	    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_FECHA_PROP||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 

	    IF V_NUM_TABLAS > 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] MODIFICAMOS EL CAMPO '||V_FECHA_PROP||'');  
                
                --Editamos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' MODIFY '||V_FECHA_PROP||' '||V_TIPO_VARCHAR||'';   

 		ELSE
               	 DBMS_OUTPUT.PUT_LINE('  [INFO] NO EXISTE EL CAMPO');
            	END IF;  

  ELSE
      DBMS_OUTPUT.PUT_LINE(' [INFO] '''||V_TABLA||'''... No existe.');  
  END IF;


--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_2||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN  
 
  
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_2||''' AND COLUMN_NAME = '''||V_FECHA_GES||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS > 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] MODIFICAMOS EL CAMPO '||V_FECHA_GES||'');  
                
                --Editamos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' MODIFY '||V_FECHA_GES||' '||V_TIPO_VARCHAR||'';   

 		ELSE
               	 DBMS_OUTPUT.PUT_LINE('  [INFO] NO EXISTE EL CAMPO');
            	END IF;  

	    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_2||''' AND COLUMN_NAME = '''||V_FECHA_HAYA||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 

	    IF V_NUM_TABLAS > 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] MODIFICAMOS EL CAMPO '||V_FECHA_HAYA||'');  
                
                --Editamos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' MODIFY '||V_FECHA_HAYA||' '||V_TIPO_VARCHAR||'';   

 		ELSE
               	 DBMS_OUTPUT.PUT_LINE('  [INFO] NO EXISTE EL CAMPO');
            	END IF;  

 	    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA_2||''' AND COLUMN_NAME = '''||V_FECHA_PROP||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 

	    IF V_NUM_TABLAS > 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] MODIFICAMOS EL CAMPO '||V_FECHA_PROP||'');  
                
                --Editamos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' MODIFY '||V_FECHA_PROP||' '||V_TIPO_VARCHAR||'';   

 		ELSE
               	 DBMS_OUTPUT.PUT_LINE('  [INFO] NO EXISTE EL CAMPO');
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
