--/*
--##########################################
--## AUTOR=Stefany Morón
--## FECHA_CREACION=20180118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-5135
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza Sanción de GENCAT
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
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

  V_TABLA VARCHAR2(30 CHAR) := 'DD_SAN_SANCION';  -- Tabla a modificar
  V_USR VARCHAR2(30 CHAR) := 'HREOS-5135'; -- USUARIOCREAR/USUARIOMODIFICAR

    --Array que contiene los registros que se van a actualizar
    TYPE T_CDC is table of VARCHAR2(4000); 
    TYPE T_ARRAY_CDC IS TABLE OF T_CDC;
    V_CDC T_ARRAY_CDC := T_ARRAY_CDC(
        --    EMI_NOMBRE_TABLA           
        T_CDC('EJERCE','Ejerce','Ejerce sanción'),
        T_CDC('NO_EJERCE','No ejerce','No ejerce sanción')
       
    );
    V_TMP_CDC T_CDC;

    V_COUNT_ORDEN NUMBER(16) := 0;
BEGIN
  
  DBMS_OUTPUT.PUT_LINE('  [INICIO] ACTUALIZANDO SANCION GENCAT');
  
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comienza el proceso de insercion de registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'...');
  
  DBMS_OUTPUT.PUT_LINE('  [INFO] Comprovaciones previas...');
  -- Verificar si la tabla ya existe
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = upper('''||V_ESQUEMA||''')';
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
  
  IF V_NUM_TABLAS = 1 THEN
    
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla ' ||V_ESQUEMA|| '.'||V_TABLA||'... Existe.');  

    FOR I IN V_CDC.FIRST .. V_CDC.LAST 
    LOOP
      V_COUNT_ORDEN :=V_COUNT_ORDEN + 1;
      V_TMP_CDC := V_CDC(I);  
  
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_SAN_CODIGO = '''||V_TMP_CDC(1)||''' AND BORRADO = 0';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('    [INFO] Actualizando '||V_TMP_CDC(1)||'...');
        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
            	SET 
            	DD_SAN_DESCRIPCION ='''||V_TMP_CDC(2)||''',
 	    	DD_SAN_DESCRIPCION_LARGA ='''||V_TMP_CDC(3)||''',
 	    	USUARIOMODIFICAR = '''||V_USR||''',
 	    	FECHAMODIFICAR = SYSDATE

             	WHERE DD_SAN_CODIGO IN ('''||V_TMP_CDC(1)||''') 
             	';
      ELSE
        DBMS_OUTPUT.PUT_LINE('      [INFO] El codigo '||V_TMP_CDC(1)||'... No Existe.');
      END IF;
      
    END LOOP;
    
    COMMIT;

    
  ELSE
    DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA||'.'||V_TABLA||'... No existe.');
  END IF;
    
  DBMS_OUTPUT.PUT_LINE('[FIN]');    

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;


