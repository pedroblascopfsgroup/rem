--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20220719
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18402
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza datos en la tabla DD_ELO_ESTADO_LOCALIZACION
--## INSTRUCCIONES: Lanzar, con cuidado de que no se rompa.
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
    V_USR VARCHAR2(30 CHAR) := 'HREOS-18402'; -- USUARIOCREAR/USUARIOMODIFICAR.
        
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_ELO_ESTADO_LOCALIZACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_ELO_ID NUMBER(16); -- Vble. que guarda el id de de la tabla DD_ELO_ESTADO_LOCALIZACION.
	V_SEG_ID NUMBER(16); -- Vble. que guarda el id de de la tabla DD_SEG_SUBESTADO_GESTION.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    
    -------------(DD_ELO_CODIGO, DD_SEG_CODIGO)
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('PDTE', 'Pendiente de Gestionar')
    ); 

    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN   
        
        DBMS_OUTPUT.PUT_LINE('[INICIO] ');

         
    -- LOOP para insertar los valores en '||V_TEXT_TABLA||' -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[FIN]: MODIFICACION EN '||V_TEXT_TABLA||'');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT DD_ELO_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_ELO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN                                
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODFICANDO EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''', '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET  
						DD_ELO_DESCRIPCION = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', DD_ELO_DESCRIPCION_LARGA = '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''
						,USUARIOMODIFICAR='''|| V_USR ||''', FECHAMODIFICAR = SYSDATE
						WHERE DD_ELO_CODIGO ='''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' AND BORRADO = 0';
						
						DBMS_OUTPUT.PUT_LINE(V_MSQL);
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
       	ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO NO EXISTE');
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   

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



   

