--/*
--##########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20210517
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14001
--## PRODUCTO=NO
--##
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

  V_TABLA VARCHAR2(30 CHAR) := 'DD_EEB_ESTADO_EXPEDIENTE_BC';  -- Tabla a modificar
  V_USR VARCHAR2(30 CHAR) := 'HREOS-14001'; -- USUARIOCREAR/USUARIOMODIFICAR

    --Array que contiene los registros que se van a actualizar
    TYPE T_TIPO_DATA is table of VARCHAR2(4000); 
    TYPE T_ARRAY_CDC IS TABLE OF T_TIPO_DATA;
    V_CDC T_ARRAY_CDC := T_ARRAY_CDC(
        --    EMI_NOMBRE_TABLA           
            T_TIPO_DATA('001',1,1),
            T_TIPO_DATA('002',1,1),
            T_TIPO_DATA('003',1,1),
            T_TIPO_DATA('004',0,1),
            T_TIPO_DATA('005',0,1),
            T_TIPO_DATA('006',0,1),
            T_TIPO_DATA('007',0,1),
            T_TIPO_DATA('008',1,0),
            T_TIPO_DATA('009',1,0),
            T_TIPO_DATA('010',1,0),
            T_TIPO_DATA('011',1,0),
            T_TIPO_DATA('012',1,0),
            T_TIPO_DATA('013',1,0),
            T_TIPO_DATA('014',1,0),
            T_TIPO_DATA('015',1,0),
            T_TIPO_DATA('016',1,0),
            T_TIPO_DATA('017',1,0),
            T_TIPO_DATA('018',1,0),
            T_TIPO_DATA('019',1,0),
            T_TIPO_DATA('020',1,0),
            T_TIPO_DATA('021',1,0),
            T_TIPO_DATA('022',1,0),
            T_TIPO_DATA('023',1,0)
                
    );
    V_TMP_CDC T_TIPO_DATA;

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('  [INICIO] ACTUALIZANDO DD_EEB_ESTADO_EXPEDIENTE_BC');
  
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
      V_TMP_CDC := V_CDC(I);  
  
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_EEB_CODIGO = '''||V_TMP_CDC(1)||''' AND BORRADO = 0';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('    [INFO] Actualizando '||V_TMP_CDC(1)||'...');
        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
            	SET 
            	DD_EEB_VENTA ='||V_TMP_CDC(2)||',
 	    	DD_EEB_ALQUILER ='||V_TMP_CDC(3)||',
 	    	USUARIOMODIFICAR = '''||V_USR||''',
 	    	FECHAMODIFICAR = SYSDATE

             	WHERE DD_EEB_CODIGO = ('''||V_TMP_CDC(1)||''') 
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
