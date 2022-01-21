--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20211124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16504
--## PRODUCTO=NO
--##
--## FINALIDAD: Script que modifica en DD_OPM_OPERACION_MASIVA los datos añadidos en T_ARRAY_DATA.
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
    V_TABLA VARCHAR2(30 CHAR);
    V_USUARIOCREAR VARCHAR2(25 CHAR);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	     T_FUNCION('CMIN')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_MSQL_1 VARCHAR2(4000 CHAR);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
  	V_TABLA := 'DD_OPM_OPERACION_MASIVA';
	V_USUARIOCREAR := 'HREOS-16504'; 
    -- LOOP para insertar los valores en DD_OPM_OPERACION_MASIVA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_ESQUEMA||'.'||V_TABLA||'.');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
      	V_TMP_FUNCION := V_FUNCION(I);
		
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(1)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		-- Si existe la FUNCION
		IF V_NUM_TABLAS > 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] Se modifica la carga masiva de la tabla '||V_ESQUEMA||'.'||V_TABLA||'.');
    		V_MSQL_1 := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET ' ||
		        'USUARIOMODIFICAR = '''||V_USUARIOCREAR||''', ' ||
		        'FECHAMODIFICAR = SYSDATE, ' ||
		        'BORRADO = 0 '||
		        'WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(1)||''' ';
   	   		DBMS_OUTPUT.PUT_LINE(V_MSQL_1);

    		EXECUTE IMMEDIATE V_MSQL_1;
			DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' actualizados correctamente.');
			COMMIT;
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] La carga masiva no existe en la tabla '||V_ESQUEMA||'.'||V_TABLA||'.');
	    END IF;	
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
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