--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190928
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7795
--## PRODUCTO=NO
--## Finalidad: Añadir nuevos campos en la tabla ACT_CRG_CARGA
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
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_CRG_CARGAS'; -- Nombre de la tabla 
    
    --Tipos de campo
    V_TIPO_NUM_LONG VARCHAR2(250 CHAR):= 'NUMBER(16,0)';
    V_TIPO_NUM_BOOL VARCHAR2(250 CHAR):= 'NUMBER(1,0)';
    V_TIPO_VARCHAR VARCHAR2(250 CHAR):= 'VARCHAR2(100 CHAR)';
	
    -- Nombre de tablas a REFERENCIAR
	V_TABLA_REF_SRA VARCHAR2(50 CHAR):= 'DD_SCG_SUBESTADO_CARGA';
	V_KEY_NAME_SRA VARCHAR2(50 CHAR):= 'FK_DD_SCG_ID';
	
    --Nombre de las columnas
        V_COL_SCG VARCHAR2(50 CHAR):= 'DD_SCG_ID'; 
	
    
BEGIN   


  DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');  

--Comprobacion de la tabla
  V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS > 0 THEN  
 
  
            -- ******** DD_ECA_ESTADO_CARGA_ACTIVOS *******
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COL_SCG||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
            
            IF V_NUM_TABLAS = 0 THEN
                DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||V_COL_SCG||'');  
                
                -- Añadimos el campo
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COL_SCG||' '||V_TIPO_NUM_LONG||'';   
                -- Añadimos LA CLAVE AJENA
                EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT '||V_KEY_NAME_SRA||' FOREIGN KEY ('||V_COL_SCG||')
	  								REFERENCES '||V_ESQUEMA||'.'||V_TABLA_REF_SRA||' ('||V_COL_SCG||') ON DELETE SET NULL ENABLE';
	  	-- Añadimos el comentario al campo
                EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COL_SCG||' IS ''Código identificador único del diccionario subtipo carga.'''; 					
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA||'.'||V_COL_SCG||'... YA existe.');
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
