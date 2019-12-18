--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20191001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7795
--## PRODUCTO=NO
--## Finalidad: Diccionario con los subestados de cargas 
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
	T_TIPO_DATA('01','Sin iniciar','Sin iniciar'),
	T_TIPO_DATA('02','En análisis','En análisis'),
	T_TIPO_DATA('03','Solicitada Provisión Fondos','Solicitada Provisión Fondos'),
	T_TIPO_DATA('04','Solicitada carta de pago','Solicitada carta de pago'),
	T_TIPO_DATA('05','Cancelado económico','Cancelado económico'),
	T_TIPO_DATA('06','Solicitado certificado saldo cero','Solicitado certificado saldo cero'),
	T_TIPO_DATA('07','Paralizado por la Propiedad','Paralizado por la Propiedad'),
	T_TIPO_DATA('08','Solicitada por confusión en título','Solicitada por confusión en título'),
	T_TIPO_DATA('09','Solicitada por instancia por confusión','Solicitada por instancia por confusión'),
	T_TIPO_DATA('10','Solicitada por instancia de caducidad','Solicitada por instancia de caducidad'),
	T_TIPO_DATA('11','Solicitada por escritura de cancelación','Solicitada por escritura de cancelación'),
	T_TIPO_DATA('12','Recibida instancia por Gestoría','Recibida instancia por Gestoría'),
	T_TIPO_DATA('13','Presentado en RP','Presentado en RP'),
	T_TIPO_DATA('14','Defecto','Defecto'),
	T_TIPO_DATA('15','Solicitados mandamientos a través cliente','Solicitados mandamientos a través cliente'),
	T_TIPO_DATA('16','Solicitados mandamientos al procurador/letrado','Solicitados mandamientos al procurador/letrado'),
	T_TIPO_DATA('17','Recibidos mandamientos por Gestoría','Recibidos mandamientos por Gestoría'),
	T_TIPO_DATA('18','Defecto subsanado','Defecto subsanado'),
	T_TIPO_DATA('19','Cancelada la carga','Cancelada la carga'),
	T_TIPO_DATA('20','Asume comprador','Asume comprador'),
	T_TIPO_DATA('21','No cancelable','No cancelable'),
	T_TIPO_DATA('22','Caducada pendiente','Caducada pendiente'),
	T_TIPO_DATA('23','Recibida escritura de cancelación por Gestoría','Recibida escritura de cancelación por Gestoría')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_SCG_SUBESTADO_CARGA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SCG_SUBESTADO_CARGA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SCG_SUBESTADO_CARGA WHERE DD_SCG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_SCG_SUBESTADO_CARGA '||
                    'SET DD_SCG_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_SCG_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_SCG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SCG_SUBESTADO_CARGA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SCG_SUBESTADO_CARGA (' ||
                      'DD_SCG_ID, DD_SCG_CODIGO, DD_SCG_DESCRIPCION, DD_SCG_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ', '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SCG_SUBESTADO_CARGA ACTUALIZADO CORRECTAMENTE ');
   

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
