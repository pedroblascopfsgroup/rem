--/*
--#########################################
--## AUTOR=Lara Pablo
--## FECHA_CREACION=20190914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7474
--## PRODUCTO=NO
--##
--## FINALIDAD: Creación de una tabla de pruebas
--##
--## INSTRUCCIONES:
--##	1. Especificar el esquema de la tabla en la variable 'V_TABLE_SCHEME' apuntando a la variables 'V_SCHEME' o 'V_MASTER_SCHEME'.
--##	2. Especificar el nombre de la tabla a crear o modificar en la variable 'V_TABLE_NAME'.
--##	3. Especificar el comentario aclarativo de la tabla en la variable 'V_TABLE_COMMENT'.
--##	4. Configurar las columnas a crear o modificar en la matriz 'V_COLUMNS_MATRIX'. No especificar la columna de ID único, se genera automáticamente al crear la tabla.
--##	5. Configurar las foreign keys (opcional) en la variable 'V_FK_MATRIX'. Puede quedarse vacía para no crear nada.
--##	6. Configurar los índices (opcional) en la variable 'V_INDEX_MATRIX'. Puede quedarse vacía para no crear nada.
--##
--##	** No modificar las zonas entre BEGIN -> EXIT, la lógica implementada lleva a cabo las operaciones necesarias con las variables en el DECLARE **
--##	Más información: http://bit.ly/pitertul-api
--##
--## VERSIONES:
--##	0.1 Versión inicial
--#########################################
--*/

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
    
    V_COLUMNA VARCHAR2(30 CHAR):= 'ADT_ID_DOCUMENTO_REST'; -- Vble. para almacenar el nombre de la columna.
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_ADT_ADJUNTO_TRIBUTOS'; -- Vble. para almacenar el nombre de la tabla.
    V_NUM_COLS NUMBER(16); --Vble. para validar la existencia de una columna  
   
    BEGIN
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''|| V_COLUMNA ||''' AND TABLE_NAME= '''|| V_TABLA ||''' AND OWNER='''|| V_ESQUEMA ||''''; 
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS;
     
    -- Si existe 
    IF V_NUM_COLS > 0 THEN 
    
    	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME ='''|| V_TABLA ||''' AND OWNER = '''|| V_ESQUEMA ||''' and (column_name = '''|| V_ESQUEMA ||''') AND NULLABLE=''N''';
    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS;
    	
    	 IF V_NUM_COLS > 0 THEN  
       	 	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA ||'.'|| V_TABLA ||' MODIFY ('||V_COLUMNA ||' NUMBER(16,0) NULL )';
       	 ELSE
       	 	 DBMS_OUTPUT.PUT_LINE('LA COLUMNA YA ES NO NULA');
       	 END IF; 
       	 
    ELSE
       DBMS_OUTPUT.PUT_LINE('YA EXISTE EL COLUMNA');
    END IF;   
            
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
