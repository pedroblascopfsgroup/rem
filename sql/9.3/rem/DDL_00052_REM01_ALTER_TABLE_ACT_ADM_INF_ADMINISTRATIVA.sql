--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20200619
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10397
--## PRODUCTO=NO
--##
--## Finalidad: Añadir dos nuevos campos en la tabla ACT_ADM_INF_ADMINISTRATIVA
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
	V_TABLA VARCHAR2(50 CHAR):= 'ACT_ADM_INF_ADMINISTRATIVA'; -- Nombre de la tabla a crear

	V_TIPO VARCHAR2(250 CHAR):= 'VARCHAR2(50 CHAR)';--Tipo nuevo campo
 	V_TIPO1 VARCHAR2(250 CHAR):= 'VARCHAR2(50 CHAR)';--Tipo nuevo campo

 	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
 	
 	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('DD_TRA_ID', 'NUMBER(16,0)', 'Código identificador único del diccionario DD_TRA_TRIBUTACION_ADQUISION.'),
        T_TIPO_DATA('ACT_ADM_FECHA_VENC_TIP_BON', 'DATE', 'Fecha de vencimiento del tipo de bonificación.'),
        T_TIPO_DATA('ACT_ADM_FECHA_LIQ_COMPLEM', 'DATE', 'Fecha liquidación complementaria..')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');
  
  	--Comprobacion de la tabla
  	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
  	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  	IF V_NUM_TABLAS > 0 THEN
  	
  		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
    	
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
	  		-- Verificar si el campo ya existe
	        V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
	        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
	            
	        IF V_NUM_TABLAS = 0 THEN
	        	DBMS_OUTPUT.PUT_LINE('  [INFO] Insertamos los campos '||TRIM(V_TMP_TIPO_DATA(1))||'');  
	                
	            -- Añadimos el campo
	            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||TRIM(V_TMP_TIPO_DATA(1))||' '||TRIM(V_TMP_TIPO_DATA(2))||'';  
	            V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||TRIM(V_TMP_TIPO_DATA(1))||' IS '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
				EXECUTE IMMEDIATE V_MSQL;
	        ELSE
	            DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA||'.'||TRIM(V_TMP_TIPO_DATA(1))||'... YA existe.');
	        END IF;
		END LOOP;
		
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_DD_TRA_ID FOREIGN KEY (DD_TRA_ID) REFERENCES '||V_ESQUEMA||'.DD_TRA_TRIBUTACION_ADQUISION (DD_TRA_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
    
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