--/*
--##########################################
--## AUTOR=VIOREL Ivan Rubio
--## FECHA_CREACION=20200924
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11228
--## PRODUCTO=NO
--## Finalidad: Inserción nuevos registros en la tabla DD_MAO_MOTIVO_ANULACION_OFR.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


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
      T_TIPO_DATA('04',   'Incumplimiento del plazo firma de contrato de reserva',   'Incumplimiento del plazo firma de contrato de reserva.'),
      T_TIPO_DATA('05',   'Por orden de la Propiedad',    'Por orden de la Propiedad'),
      T_TIPO_DATA('06',   'Desistimiento del comprador por desinterés',   'Desistimiento del comprador por desinterés'),
      T_TIPO_DATA('07',   'Anulación tras 3 meses sin formalizar o posicionar',    'Anulación tras 3 meses sin formalizar o posicionar'),
      T_TIPO_DATA('08',   'Sin noticias de comprador/prescriptor',   'Sin noticias de comprador/prescriptor'),
      T_TIPO_DATA('09',   'Financiación rechazada',    'Financiación rechazada'),
      T_TIPO_DATA('10',   'Sin documentación de PBC',    'Sin documentación de PBC'),
      T_TIPO_DATA('11',   'PBC rechazado',    'PBC rechazado'),
      T_TIPO_DATA('12',   'Ejerce GenCat',    'Ejerce GenCat'),
      T_TIPO_DATA('13',   'VPO denegada',    'VPO denegada'),
      T_TIPO_DATA('14',   'Incidencia jurídica/técnica',    'Incidencia jurídica/técnica'),
      T_TIPO_DATA('15',   'Alta Oferta Espejo',    'Alta Oferta Espejo')
      
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores en DD_ECA_ESTADO_CARGA_ACTIVOS -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_MAO_MOTIVO_ANULACION_OFR] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_MAO_MOTIVO_ANULACION_OFR WHERE DD_MAO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_MAO_MOTIVO_ANULACION_OFR '||
                    'SET DD_MAO_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_MAO_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''HREOS-11228'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_MAO_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_MAO_MOTIVO_ANULACION_OFR.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_MAO_MOTIVO_ANULACION_OFR (' ||
                      'DD_MAO_ID, DD_MAO_CODIGO, DD_MAO_DESCRIPCION, DD_MAO_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ', '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''HREOS-11228'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_MAO_MOTIVO_ANULACION_OFR ACTUALIZADO CORRECTAMENTE ');
   

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
