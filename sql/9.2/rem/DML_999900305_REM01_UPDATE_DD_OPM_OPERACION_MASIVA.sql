--/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20180810
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4416
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_TABLA VARCHAR2(30 CHAR) := 'DD_OPM_OPERACION_MASIVA';  -- Tabla a modificar
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_DD_OPM_OPERACION_MASIVA';  -- Tabla a modificar    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4376'; -- USUARIOCREAR/USUARIOMODIFICAR
       
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('PRINEX','n*,n,n,s,s,s,s,s,i,f,s,s,s,i,i,i,s,i,i,i,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,n,n,n,s,n,n,n,s,s,s,s,s,s,s,s,f,s,s,i,s,s')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar los valores en DD_OPM_OPERACION_MASIVA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_OPM_OPERACION_MASIVA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_OPM_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
    		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
    		
    		IF V_NUM_TABLAS = 1 THEN      
    				--Insertar datos
    			DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO EL REGISTRO '''||V_TMP_TIPO_DATA(1)||'''');
    			EXECUTE IMMEDIATE '
    					UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
              SET DD_OPM_VALIDACION_FORMATO = '''||V_TMP_TIPO_DATA(2)||''' ,
              USUARIOMODIFICAR = '''||V_USR||''',
              FECHAMODIFICAR = SYSDATE
              WHERE DD_OPM_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
    				DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');
    		END IF;

      END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_OPM_OPERACION_MASIVA ACTUALIZADO CORRECTAMENTE ');
   

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

EXIT