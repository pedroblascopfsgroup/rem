--/*
--##########################################
--## AUTOR=ANAHECT DE VICENTE
--## FECHA_CREACION=20151102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TPD_TIPO_DOCUMENTO los datos añadidos en T_ARRAY_DATA
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
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('01'	,'AI-01-FICH-05'),
    	T_TIPO_DATA('02'	,'AI-01-SERE-26'),
        T_TIPO_DATA('03'	,'AI-01-ESCR-26'),
        T_TIPO_DATA('04'	,'AI-02-DOCJ-15'),
        T_TIPO_DATA('05'	,'AI-01-NOTS-01'),
        T_TIPO_DATA('06'	,'AI-01-NOTS-01'),
        T_TIPO_DATA('07'	,'AI-04-TASA-11'),
        T_TIPO_DATA('11'	,'AI-10-CERT-05'),
        T_TIPO_DATA('12'	,'AI-09-LIPR-06'),
        T_TIPO_DATA('13'	,'AI-09-LIPR-03'),
        T_TIPO_DATA('14'	,'AI-08-CERT-17'),
        T_TIPO_DATA('15'	,'AI-09-CERT-07'),
        T_TIPO_DATA('16'	,'AI-09-CERT-10'),
        T_TIPO_DATA('17'	,'AI-09-CERT-11'),
        T_TIPO_DATA('19'	,'AI-03-ESIN-34'),
        T_TIPO_DATA('20'	,'AI-02-DOCJ-14')
        
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para añadir las matriculas en DD_TPD_TIPO_DOCUMENTO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TPD_TIPO_DOCUMENTO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPD_TIPO_DOCUMENTO '||
                    'SET DD_TPD_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TPD_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe no hacemos nada   
       ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE EL REGISTRO EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TPD_TIPO_DOCUMENTO ACTUALIZADO CORRECTAMENTE ');
   

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



   