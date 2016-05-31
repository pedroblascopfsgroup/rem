--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0
--## INCIDENCIA_LINK=HR-1125
--## PRODUCTO=SI
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  	
    TABLE_NAME VARCHAR2(30 CHAR);
    TABLE_NAME_CUR VARCHAR2(30 CHAR);
    
    TABLES_CURSOR SYS_REFCURSOR;
    
    TYPE T_TIPO_COLUMN IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_COLUMN IS TABLE OF T_TIPO_COLUMN;
    V_TIPO_COLUMN T_ARRAY_COLUMN := T_ARRAY_COLUMN(   
      T_TIPO_COLUMN('PEF_ID')
     );
     V_TMP_TIPO_COLUMN T_TIPO_COLUMN;
    
BEGIN
	
	 FOR I IN V_TIPO_COLUMN.FIRST .. V_TIPO_COLUMN.LAST
      LOOP
        V_TMP_TIPO_COLUMN := V_TIPO_COLUMN(I);
		V_NUM_TABLAS := 0;
	
        
        OPEN TABLES_CURSOR FOR 'SELECT t.TABLE_NAME ' ||
							' FROM USER_TAB_COLUMNS t  '||
							'WHERE t.COLUMN_NAME = '''||V_TMP_TIPO_COLUMN(1)||''' ' ||
							' AND EXISTS (SELECT a.OBJECT_NAME FROM ALL_OBJECTS a WHERE a.OWNER = '''||V_ESQUEMA||''' AND a.OBJECT_NAME = t.TABLE_NAME AND a.OBJECT_TYPE = ''TABLE'')';
 	
 		LOOP
 			FETCH TABLES_CURSOR INTO TABLE_NAME;
 			EXIT WHEN TABLES_CURSOR%NOTFOUND;
 			
        	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'|| TABLE_NAME ||' MODIFY '||V_TMP_TIPO_COLUMN(1)||' VARCHAR2(50 CHAR)';
						
			EXECUTE IMMEDIATE V_MSQL;
			V_NUM_TABLAS := V_NUM_TABLAS + 1;
			
			
		END LOOP;
		CLOSE TABLES_CURSOR;
		DBMS_OUTPUT.PUT_LINE('Modificados el tamanyo de los campos para las columnas ' ||V_TMP_TIPO_COLUMN(1)||' de '||V_NUM_TABLAS||' tablas.');
	END LOOP;
	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('El proceso ha finalizado correctamente.');
						
    
EXCEPTION
   WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;