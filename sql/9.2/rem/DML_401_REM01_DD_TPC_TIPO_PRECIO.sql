--/*
--##########################################
--## AUTOR=CARLOS FELIU
--## FECHA_CREACION=20160624
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TPC_TIPO_PRECIO los datos añadidos en T_ARRAY_DATA
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
    	T_TIPO_DATA('01', 'VNC','V',null),
    	T_TIPO_DATA('02', 'Aprobado de venta (web)','P', 2),
    	T_TIPO_DATA('03', 'Aprobado de renta (web)','P', 3),
    	T_TIPO_DATA('04', 'Mínimo autorizado','P', 1),
    	T_TIPO_DATA('05',null,null,null),
    	T_TIPO_DATA('06',null,null,null),
    	T_TIPO_DATA('07', 'De descuento aprobado','P', 4),
    	T_TIPO_DATA('08',null,null,null),
    	T_TIPO_DATA('09', 'Valor legal VPO', 'V', null),
    	T_TIPO_DATA('10',null,null,null),
    	T_TIPO_DATA('11', 'Valor estimado de venta'	,'V',null),
    	T_TIPO_DATA('12', 'Valor estimado de renta' ,'V',null)
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
    TYPE T_TIPO_DATA2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA2 IS TABLE OF T_TIPO_DATA2;
    V_TIPO_DATA2 T_ARRAY_DATA2 := T_ARRAY_DATA2(
    	T_TIPO_DATA2('13'	,'De descuento publicado (web)'		,'Precio de descuento publicado'	,'P', 5),
    	T_TIPO_DATA2('14'	,'Valor de referencia'				,'Valor de referencia'				,'V', null),
    	T_TIPO_DATA2('15'	,'PT'								,'Precio de transferencia'			,'V', null),
    	T_TIPO_DATA2('16'	,'Valor asesoramiento liquidativo'	,'Valor asesoramiento liquidativo'	,'V', null),
    	T_TIPO_DATA2('17'	,'VACBE'							,'VACBE'							,'V', null),
    	T_TIPO_DATA2('18'	,'Coste de adquisición'				,'Coste de adquisición'				,'V', null),
    	T_TIPO_DATA2('19'	,'FSV venta'						,'First Sale Value (FSV) venta'		,'V', null),
    	T_TIPO_DATA2('20'	,'FSV renta'						,'First Sale Value (FSV) renta'		,'V', null)
    ); 
    V_TMP_TIPO_DATA2 T_TIPO_DATA2;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TPC_TIPO_PRECIO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TPC_TIPO_PRECIO] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO '||
                    'SET DD_TPC_TIPO = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
                    ',DD_TPC_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
                    ',DD_TPC_ORDEN = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TPC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
       	END IF;
      END LOOP;
      
      FOR I IN V_TIPO_DATA2.FIRST .. V_TIPO_DATA2.LAST
      LOOP
      
        V_TMP_TIPO_DATA2 := V_TIPO_DATA2(I);
       --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO '||
                    'SET DD_TPC_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA2(2))||''''|| 
					', DD_TPC_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA2(3))||''''||
					', DD_TPC_TIPO = '''||TRIM(V_TMP_TIPO_DATA2(4))||''''||
					', DD_TPC_ORDEN = '''||TRIM(V_TMP_TIPO_DATA2(5))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TPC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
	       --Si no existe, lo insertamos   
	       ELSE
	       
	          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||'''');   
	          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TPC_TIPO_PRECIO.NEXTVAL FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
	          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO (' ||
	                      'DD_TPC_ID, DD_TPC_CODIGO, DD_TPC_DESCRIPCION, DD_TPC_DESCRIPCION_LARGA, DD_TPC_TIPO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
	                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA2(1)||''','''||TRIM(V_TMP_TIPO_DATA2(2))||''','''||TRIM(V_TMP_TIPO_DATA2(3))||''','''||TRIM(V_TMP_TIPO_DATA2(4))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TPC_TIPO_PRECIO ACTUALIZADO CORRECTAMENTE ');
   

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



   