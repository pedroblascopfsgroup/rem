--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2761
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TDP_TIPO_DOC_PRO los datos añadidos en T_ARRAY_DATA
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
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('177'	,'Impuesto de transmisiones patrimoniales (ITP) y Actos Jurídicos Documentados (AJD)'					,'Impuesto de transmisiones patrimoniales (ITP) y Actos Jurídicos Documentados (AJD)' 	,'AI-01-CERA-14'),
		T_TIPO_DATA('178'	,'Catastro: Alteración de titular por adjudicación (MOD 901, 902, 903, 904)'						,'Catastro: Alteración de titular por adjudicación (MOD 901, 902, 903, 904)' 		,'AI-01-DECL-01'),
		T_TIPO_DATA('179'	,'Mandamiento cancelación cargas'											,'Mandamiento cancelación cargas'					,'AI-01-SERE-25'),
		T_TIPO_DATA('180'	,'Título inscrito (Testimonio)'												,'Título inscrito (Testimonio)'				,'AI-01-DOCJ-BJ'),
		T_TIPO_DATA('181'	,'Título inscrito (Escritura)'												,'Título inscrito (Escritura)'				,'AI-01-ESCR-48')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	         --Comprobamos el dato a borrar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TDP_TIPO_DOC_PRO WHERE DD_TDP_CODIGO = ''75''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS2;
        
        --Si existe lo BORRAMOS
        IF V_NUM_TABLAS2 > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS EL REGISTRO ''Título inscrito''');
	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TDP_TIPO_DOC_PRO '||
                    'SET BORRADO = 1'||', USUARIOBORRAR = ''REMVIP-2761'' , FECHABORRAR = SYSDATE '||
					'WHERE DD_TDP_CODIGO = ''75''';

	  EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO BORRADO CORRECTAMENTE');

       END IF;
    -- LOOP para insertar los valores en DD_TEP_TIPO_ENTIDAD_PRO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TDP_TIPO_DOC_PRO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TDP_TIPO_DOC_PRO WHERE DD_TDP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TDP_TIPO_DOC_PRO '||
                    'SET DD_TDP_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TDP_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', DD_TDP_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''REMVIP-2761'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TDP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TDP_TIPO_DOC_PRO.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TDP_TIPO_DOC_PRO (' ||
                      'DD_TDP_ID, DD_TDP_CODIGO, DD_TDP_DESCRIPCION, DD_TDP_DESCRIPCION_LARGA, DD_TDP_MATRICULA_GD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''REMVIP-2761'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TDP_TIPO_DOC_PRO ACTUALIZADO CORRECTAMENTE ');
   

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
