--/*
--##########################################
--## AUTOR=Pablo Garcia Pallas
--## FECHA_CREACION=20200319
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9700
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica en DD_SDE_SUBTIPO_DOC_EXP las descripciones del subtipo 63
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SDE_SUBTIPO_DOC_EXP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-9700';
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        -- DD_SDE_CODIGO  DD_SDE_DESCRIPCION  DD_SDE_DESCRIPCION_LARGA  
        T_TIPO_DATA('63', 'Advisory Note Advisory', 'Advisory Note Advisory')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SCR_SUBCARTERA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||TRIM(V_TEXT_TABLA)||'');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||TRIM(V_TEXT_TABLA)||' WHERE DD_SDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||
        ''' AND DD_SDE_DESCRIPCION NOT LIKE('''||TRIM(V_TMP_TIPO_DATA(2))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        DBMS_OUTPUT.PUT_LINE('[INFO]: NUMERO DE REGISTROS'''|| TRIM(V_SQL) ||'''');
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN		

          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'|| V_TEXT_TABLA ||''||
                    ' SET DD_SDE_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_SDE_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = '''||TRIM(V_ITEM)||''' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_SDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';

          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' MODIFICADO CORRECTAMENTE ');
   

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
