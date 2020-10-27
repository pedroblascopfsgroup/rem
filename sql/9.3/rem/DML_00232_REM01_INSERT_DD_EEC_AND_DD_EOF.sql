--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK= REMVIP-8194
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_EEC_EST_EXP_COMERCIAL y DD_EOF_ESTADOS_OFERTA los datos añadidos en T_ARRAY_DATA
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8177'; -- USUARIO CREAR/MODIFICAR    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    --ID    ESTADO OFERTA   ESTADO EXP COMERCIAL
        T_TIPO_DATA('999',  'Anulada RC',   'Datos erróneos')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
  LOOP
      
      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_EEC_EST_EXP_COMERCIAL] ');
      
      --Comprobamos el dato a insertar
      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
          
      IF V_NUM_TABLAS > 0 THEN				

          V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL 
                    SET DD_EEC_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                    DD_EEC_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
                    USUARIOMODIFICAR = '''||V_USUARIO||''',FECHAMODIFICAR = SYSDATE, DD_EEC_VENTA = 1, DD_EEC_ALQUILER = 0
                    WHERE DD_EEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
              
      ELSE

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_EEC_EST_EXP_COMERCIAL (
                    DD_EEC_ID, DD_EEC_CODIGO, DD_EEC_DESCRIPCION, DD_EEC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, DD_EEC_VENTA, DD_EEC_ALQUILER) VALUES (
                    '||V_TMP_TIPO_DATA(1)|| ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||V_USUARIO||''',SYSDATE,1,0)';
          EXECUTE IMMEDIATE V_MSQL;
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
          
      END IF;

      DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_EOF_ESTADOS_OFERTA] ');
      
      --Comprobamos el dato a insertar
      V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
          
      IF V_NUM_TABLAS > 0 THEN				

          V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA 
                    SET DD_EOF_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                    DD_EOF_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                    USUARIOMODIFICAR = '''||V_USUARIO||''',FECHAMODIFICAR = SYSDATE
                    WHERE DD_EOF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
                
      ELSE

          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA (
                    DD_EOF_ID, DD_EOF_CODIGO, DD_EOF_DESCRIPCION, DD_EOF_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (
                    '||V_TMP_TIPO_DATA(1)|| ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||V_USUARIO||''',SYSDATE)';
          EXECUTE IMMEDIATE V_MSQL;
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
          
      END IF;

  END LOOP;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EEC_EST_EXP_COMERCIAL Y DD_EOF_ESTADOS_OFERTA ACTUALIZADOS CORRECTAMENTE ');
   

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



   
