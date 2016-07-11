--/*
--##########################################
--## AUTOR=PABLO MESEGUER
--## FECHA_CREACION=20160413
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_ENO_ENTIDAD_ORIGEN los datos añadidos en T_ARRAY_DATA
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_ENO_ENTIDAD_ORIGEN'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
	
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('15','','','CAJA DE CREDITO DE PETREL CAJA RURAL CCV 0','CAJA DE CREDITO DE PETREL CAJA RURAL CCV 0'),
		T_TIPO_DATA('16','','','CAIXALTEA','CAIXALTEA'),
		T_TIPO_DATA('17','','','CAJAMAR CAJA RURAL S.C.C.','CAJAMAR CAJA RURAL S.C.C.'),
		T_TIPO_DATA('18','','','RURALCAJA','RURALCAJA'),
		T_TIPO_DATA('19','','','CAIXA RURAL ALMENARA','CAIXA RURAL ALMENARA'),
		T_TIPO_DATA('20','','','CAIXA RURAL SANT VICENT FERRER','CAIXA RURAL SANT VICENT FERRER'),
		T_TIPO_DATA('21','','','CAIXACALLOSA','CAIXACALLOSA'),
		T_TIPO_DATA('22','','','CAJA RURAL CATOLICO AGRARIA, SCCV','CAJA RURAL CATOLICO AGRARIA, SCCV'),
		T_TIPO_DATA('23','','','CAIXA RURAL BURRIANA','CAIXA RURAL BURRIANA'),
		T_TIPO_DATA('24','','','CAIXA RURAL TORRENT','CAIXA RURAL TORRENT'),
		T_TIPO_DATA('25','','','CAIXALQUERIES','CAIXALQUERIES'),
		T_TIPO_DATA('26','','','CAJA RURAL DE CHESTE','CAJA RURAL DE CHESTE'),
		T_TIPO_DATA('27','','','CAIXA RURAL DE TURIS CCV','CAIXA RURAL DE TURIS CCV'),
		T_TIPO_DATA('28','','','CAIXA RURAL DE NULES','CAIXA RURAL DE NULES'),
		T_TIPO_DATA('29','','','CAJA RURAL DE CASINOS SOC. CCV','CAJA RURAL DE CASINOS SOC. CCV'),
		T_TIPO_DATA('30','','','CAJA RURAL DE VILLAR','CAJA RURAL DE VILLAR'),
		T_TIPO_DATA('31','','','CAIXA RURAL XILXES','CAIXA RURAL XILXES'),
		T_TIPO_DATA('32','','','CAIXA RURAL DE VILAVELLA','CAIXA RURAL DE VILAVELLA'),
		T_TIPO_DATA('33','','','CAIXA RURAL VILAFAMES','CAIXA RURAL VILAFAMES'),
		T_TIPO_DATA('34','','','CAJA RURAL DE CANARIAS, S.COOP.DE CREDIT','CAJA RURAL DE CANARIAS, S.COOP.DE CREDIT'),
		T_TIPO_DATA('35','','','CAIXA RURAL DALGINET','CAIXA RURAL DALGINET'),
		T_TIPO_DATA('36','','','CAIXA ALBALAT','CAIXA ALBALAT'),
		T_TIPO_DATA('37','','','CREDIT VALENCIA','CREDIT VALENCIA'),
		T_TIPO_DATA('38','','','CAJACAMPO','CAJACAMPO'),
		T_TIPO_DATA('39','','','CAIXA RURAL ALCORA','CAIXA RURAL ALCORA'),
		T_TIPO_DATA('40','','','CASTELLON','CASTELLON'),
		T_TIPO_DATA('41','','','CAJA RURAL DE ONDA','CAJA RURAL DE ONDA'),
		T_TIPO_DATA('42','','','CAIXA RURAL BETXI','CAIXA RURAL BETXI'),
		T_TIPO_DATA('43','','','CAIXA RURAL DE BALEARS','CAIXA RURAL DE BALEARS'),
		T_TIPO_DATA('44','','','CAJAMAR (TITULIZADOS)','CAJAMAR (TITULIZADOS)'),
		T_TIPO_DATA('9999','','','Pendiente de definir', 'Pendiente de definir')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	 
    -- LOOP para actualizar los valores en DD_ENO_ENTIDAD_ORIGEN -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACIÓN EN DD_ENO_ENTIDAD_ORIGEN] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a actualizar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN WHERE DD_ENO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_ENO_ENTIDAD_ORIGEN '||
                    'SET DD_ENO_PADRE_ID = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
                    ', DD_ENO_CIF = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
                    ', DD_ENO_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', DD_ENO_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_ENO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_ENO_ENTIDAD_ORIGEN.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_ENO_ENTIDAD_ORIGEN (' ||
                      'DD_ENO_ID, DD_ENO_CODIGO, DD_ENO_PADRE_ID, DD_ENO_CIF, DD_ENO_DESCRIPCION, DD_ENO_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''' , (SELECT DD_ENO_ID FROM DD_ENO_ENTIDAD_ORIGEN WHERE DD_ENO_CODIGO LIKE ('''||V_TMP_TIPO_DATA(2)||''')) ,'''||
                      V_TMP_TIPO_DATA(3)||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''||TRIM(V_TMP_TIPO_DATA(5))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_ENO_ENTIDAD_ORIGEN ACTUALIZADO CORRECTAMENTE ');
   

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

