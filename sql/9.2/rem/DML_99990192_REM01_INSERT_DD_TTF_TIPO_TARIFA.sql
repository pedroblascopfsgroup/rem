--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20171127
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3323
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TTF_TIPO_TARIFA los datos añadidos en T_ARRAY_DATA
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
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
  	V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(10000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('BK-ANTIOC1','Instalación de cepos de garaje'),
    	T_TIPO_DATA('BK-ANTIOC2','Suministro e instalación puertas antiokupas'),
    	T_TIPO_DATA('BK-ANTIOC3','Desinstalación y transporte de puertas antiokupas'),
    	T_TIPO_DATA('BK-ANTIOC4','Instalación de puertas antiokupas'),
    	T_TIPO_DATA('BK-ANTIOC5','Urgencia: Coste adicional por instalación en servicio atendido en menos de 4 horas, a partir del pedido, siempre que se haga antes de las 17:30'),
    	T_TIPO_DATA('BK-ANTIOC6','Intervenciones programadas: Suplemento por tiempo de espera y presencia a la hora programada en firmas notariales, etc'),
    	T_TIPO_DATA('BK-ANTIOC7','Desalojo: Suplemento por tiempo de espera'),
    	T_TIPO_DATA('BK-ANTIOC8','Hora extraordinaria: Suplemento fraccionable en periodos de 30 minutos, en intervenciones por mantenimiento, sustitución de elemento o por intervención por cauas de intrusión'),
    	T_TIPO_DATA('BK-ANTIOC9','Compensación mínima por cancelación de un servicio cuando los operarios ya están presentes con el material necesario y se suspende por causas ajenas al proveedor'),
    	T_TIPO_DATA('BK-ANTIOC10','Costes por servicios nocturnos y festivos, previa autorización de Bankia. Este servicio solo se ofrece para Madrid y Barcelona, con un mínimo de facturación de 3 horas y un equipo de 2 técnicos'),
    	T_TIPO_DATA('BK-ANTIOC11','Apertura de puerta'),
    	T_TIPO_DATA('BK-ANTIOC12','Instalación de nueva cerradura suministrada por el cliente'),
    	T_TIPO_DATA('BK-ANTIOC13','Instalación de nueva cerradura suministrada por el proveedor (modelo Motura, Arcu 511ND o Azbe 6-12)'),
    	T_TIPO_DATA('BK-ANTIOC14','Cambio de bombín/bombillo, incluido cilindro ISEO LATON 30x30 y/o ISEO NIQUEL 35x35'),
    	T_TIPO_DATA('BK-ANTIOC15','Cambio de bombín/bombillo de seguridad, incluido GRAN SEGUR TK100 30x30 E15LM y/o GRAN SEGUR TK35x35 E15LM'),
    	T_TIPO_DATA('BK-ANTIOC16','Indemnización al proveedor por elemento no entregado al finalizar el alquiler')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TTF_TIPO_TARIFA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TTF_TIPO_TARIFA] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TTF_TIPO_TARIFA '||
                    'SET DD_TTF_DESCRIPCION = '''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),1,100)||''''|| 
					', DD_TTF_DESCRIPCION_LARGA = '''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),1,250)||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          
          -- Comprobar secuencias de la tabla.
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TTF_TIPO_TARIFA.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
		
			V_SQL := 'SELECT NVL(MAX(DD_TTF_ID), 0) FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
			   
			WHILE V_NUM_SEQUENCE <= V_NUM_MAXID LOOP
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_DD_TTF_TIPO_TARIFA.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
			END LOOP;
          
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TTF_TIPO_TARIFA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TTF_TIPO_TARIFA (' ||
                      'DD_TTF_ID, DD_TTF_CODIGO, DD_TTF_DESCRIPCION, DD_TTF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),1,100)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),1,250)||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TTF_TIPO_TARIFA ACTUALIZADO CORRECTAMENTE ');
   

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