--/*
--##########################################
--## Author: Sergio Hernández
--## Finalidad: DML de inserción de DD_TRA_TASADORA
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
        
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en DD_TRA_TASADORA
    TYPE T_TASADORA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TASADORA IS TABLE OF T_TASADORA;
    V_TASADORA T_ARRAY_TASADORA := T_ARRAY_TASADORA(
      T_TASADORA('TIN','TINSA','TINSA','DGG')      
    ); 
    V_TMP_TASADORA T_TASADORA;

    --Insertando valores en DD_SPO_SITUACION_POSESORIA
    TYPE T_POSESORIA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_POSESORIA IS TABLE OF T_POSESORIA;
    V_POSESORIA T_ARRAY_POSESORIA := T_ARRAY_POSESORIA(
      T_POSESORIA('PRO','PROPIETARIO','PROPIETARIO','DGG')      
    ); 
    V_TMP_POSESORIA T_POSESORIA;


BEGIN   
    -- LOOP Insertando valores en DD_TRA_TASADORA
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_TRA_TASADORA... Empezando a insertar datos en el diccionario');
    
        FOR I IN V_TASADORA.FIRST .. V_TASADORA.LAST
      LOOP
      V_TMP_TASADORA := V_TASADORA(I);
                  
                  V_SQL := 'SELECT COUNT(1) FROM DD_TRA_TASADORA WHERE DD_TRA_CODIGO = '''||TRIM(V_TMP_TASADORA(1))||'''';
                  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                  -- Si existe la TASADORA
                  IF V_NUM_TABLAS > 0 THEN                                
                          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TRA_TASADORA... Ya existe la TASADORA '''|| TRIM(V_TMP_TASADORA(1))||'''');
                  ELSE            
                          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_TRA_TASADORA (' ||
                                    'DD_TRA_ID, DD_TRA_CODIGO, DD_TRA_DESCRIPCION, DD_TRA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO)' ||
                                    'VALUES( 1 ,'''||V_TMP_TASADORA(1)||''','''||TRIM(V_TMP_TASADORA(2))||''','''||  
                                    ''||V_TMP_TASADORA(3)||''','''||TRIM(V_TMP_TASADORA(4))||''','|| 
                                    'SYSDATE,0 )';
                          DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TASADORA(1)||''','''||TRIM(V_TMP_TASADORA(2))||'''');
                          EXECUTE IMMEDIATE V_MSQL;
                  END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.DD_TRA_TASADORA... Datos del diccionario insertado');
    
    -- LOOP Insertando valores en DD_SPO_SITUACION_POSESORIA
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_SPO_SITUACION_POSESORIA... Empezando a insertar datos en el diccionario');
    
        FOR I IN V_POSESORIA.FIRST .. V_POSESORIA.LAST
      LOOP
      V_TMP_POSESORIA := V_POSESORIA(I);
                  
                  V_SQL := 'SELECT COUNT(1) FROM DD_SPO_SITUACION_POSESORIA WHERE DD_SPO_CODIGO = '''||TRIM(V_TMP_POSESORIA(1))||'''';
                  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                  -- Si existe la POSESORIA
                  IF V_NUM_TABLAS > 0 THEN                                
                          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_SPO_SITUACION_POSESORIA... Ya existe la POSESORIA '''|| TRIM(V_TMP_POSESORIA(1))||'''');
                  ELSE            
                          V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_SPO_SITUACION_POSESORIA (' ||
                                    'DD_SPO_ID, DD_SPO_CODIGO, DD_SPO_DESCRIPCION, DD_SPO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO )' ||
                                    'VALUES( 1 ,'''||V_TMP_POSESORIA(1)||''','''||TRIM(V_TMP_POSESORIA(2))||''','''||  
                                    ''||V_TMP_POSESORIA(3)||''','''||TRIM(V_TMP_POSESORIA(4))||''','|| 
                                    'SYSDATE,0 )';
                          DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_POSESORIA(1)||''','''||TRIM(V_TMP_POSESORIA(2))||'''');
                          EXECUTE IMMEDIATE V_MSQL;
                  END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.DD_SPO_SITUACION_POSESORIA... Datos del diccionario insertado');
    

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