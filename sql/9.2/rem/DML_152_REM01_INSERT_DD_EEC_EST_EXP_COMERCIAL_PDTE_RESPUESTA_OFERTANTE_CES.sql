--/*
--##########################################
--## AUTOR=MIGUEL LOPEZ
--## FECHA_CREACION=20190826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7349
--## PRODUCTO=NO
--## Finalidad: Script que añade en DD_EEC_EST_EXP_COMERCIAL los datos añadidos en T_ARRAY_DATA
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

    V_TABLA VARCHAR2(30 CHAR) := 'DD_EEC_EST_EXP_COMERCIAL';  -- Tabla a modificar
    V_TABLA_SEQ VARCHAR2(50 CHAR) := 'S_DD_EEC_EST_EXP_COMERCIAL';  -- Tabla a modificar
    USUARIOMODIFICAR VARCHAR2(1000 CHAR) := 'HREOS-7349'; --Usuario

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(2500);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('43', 'Pdte respuesta ofertante CES', 'Pdte respuesta ofertante CES')
    );

    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 
   -- LOOP para actualizar los valores en la tabla indicada
  DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizando... ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
  LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_EEC_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '||(V_TMP_TIPO_DATA(1))||' ');

       	  V_MSQL := ' UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' EEC 
                    SET
                        EEC.DD_EEC_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||''',
		               	EEC.DD_EEC_DESCRIPCION_LARGA = '''||V_TMP_TIPO_DATA(3)||''',
		               	EEC.USUARIOMODIFICAR = '''||USUARIOMODIFICAR||''', 
                        FECHAMODIFICAR = SYSDATE 
					WHERE EEC.DD_EEC_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '||V_TMP_TIPO_DATA(1)||' ');   
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TABLA||' 
                    (
                      DD_EEC_ID, 
                      DD_EEC_CODIGO, 
                      DD_EEC_DESCRIPCION, 
                      DD_EEC_DESCRIPCION_LARGA, 
                      VERSION, 
                      USUARIOCREAR, 
                      FECHACREAR, 
                      BORRADO
                      ) 
                      VALUES( 
                      '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.nextval,
                      '''||V_TMP_TIPO_DATA(1)||''',
                      '''||V_TMP_TIPO_DATA(2)||''',
                      '''||V_TMP_TIPO_DATA(3)||''',
                       ''0'', 
                       '''||USUARIOMODIFICAR||''',
                       SYSDATE,
                       ''0'')';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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



   
