--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1333
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en CPU_CRITERIO_PUNTUACION_ACT los datos añadidos en T_ARRAY_DATA
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
	V_TIPO_ID NUMBER(16); --Vle para el id CPU_CRITERIO_PUNTUACION_ACT
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	--			codigo CPU	Nombre						Descripcion											Valor
    	T_TIPO_DATA('01'		,'Nivel renta alto'			,'Nivel de renta alto'								,100),
    	T_TIPO_DATA('02'		,'Nivel renta medio'		,'Nivel de renta medio'								,50),
    	T_TIPO_DATA('03'		,'Nivel renta bajo'			,'Nivel de renta bajo'								,0),
    	T_TIPO_DATA('04'		,'Hoteles'					,'Hay hoteles cerca'								,2),
    	T_TIPO_DATA('05'		,'Teatros'					,'Hay teatros cerca'								,1),
    	T_TIPO_DATA('06'		,'Salas de cine'			,'Hay salas de cine cerca'							,7),
    	T_TIPO_DATA('07'		,'Instalaciones deportivas'	,'Hay instalaciones deportivas cerca'				,7),
    	T_TIPO_DATA('08'		,'Centros comerciales'		,'Hay centros comerciales cerca'					,8),
    	T_TIPO_DATA('09'		,'Centros educativos'		,'Hay centros educativos cerca'						,25),
    	T_TIPO_DATA('10'		,'Centros santitarios'		,'Hay centros sanitarios cerca'						,25),
    	T_TIPO_DATA('11'		,'Aparcamiento suficiente'	,'Hay aparcamiento en superficie suficiente cerca'	,25),
    	T_TIPO_DATA('12'		,'Acceso carretera'			,'Hay fácil acceso por carretera'					,25),
    	T_TIPO_DATA('13'		,'Líneas de autobús'		,'Hay líneas de autobús cerca'						,25),
    	T_TIPO_DATA('14'		,'Metro'					,'Hay metro cerca'									,25),
    	T_TIPO_DATA('15'		,'Estación de tren'			,'Hay estación de tren cerca'						,25),
    	T_TIPO_DATA('16'		,'Previsible rehabilitación','El edificio necesitará rehabilitación'			,0),
    	T_TIPO_DATA('17'		,'Buen estado general'		,'Edificio en buen estado'							,50),
    	T_TIPO_DATA('18'		,'Bajo'						,'Activo en el bajo del edificio'					,0),
    	T_TIPO_DATA('19'		,'Con ascensor'				,'El edificio del activo tiene ascensor'			,200),
    	T_TIPO_DATA('20'		,'Vivienda unifamiliar'		,'Vivienda unifamiliar'								,200),
    	T_TIPO_DATA('21'		,'Jardines / Zonas verdes'	,'Hay zonas verdes alrededor del edificio'			,10),
    	T_TIPO_DATA('22'		,'Piscina'					,'Hay pisicina en el edificio'						,10),
    	T_TIPO_DATA('23'		,'Instalaciones deportivas'	,'El edificop ciemta con instalaciones deportivas'	,10),
    	T_TIPO_DATA('24'		,'Zona infantil'			,'El edificio cuenta con zonas infantiles'			,10),
    	T_TIPO_DATA('25'		,'Conserje / Vigilancia'	,'Conserje / Caseta de vigilancia'					,5),
    	T_TIPO_DATA('26'		,'Gimnasio'					,'Hay gimnasio'										,5),
    	T_TIPO_DATA('27'		,'Puerta blindada'			,'Puerta de entrada blindada'						,13),
    	T_TIPO_DATA('28'		,'Puerta acorazada'			,'Puerta de entrada acorazada'						,15),
    	T_TIPO_DATA('29'		,'Puertas macizas'			,'Puertas de paso macizas'							,15),
    	T_TIPO_DATA('30'		,'Puertas huecas'			,'Puertas de paso huecas'							,9),
    	T_TIPO_DATA('31'		,'Armarios empotrados alto'	,'Armarios empotrados acabado alto'					,10),
    	T_TIPO_DATA('32'		,'Armarios emp. medio-bajo'	,'Armarios empotrados acabadp medio-bajo'			,6),
    	T_TIPO_DATA('33'		,'Ventanas anodizadas'		,'Ventanas de aluminio anodizado'					,20),
    	T_TIPO_DATA('34'		,'Ventanas lacadas'			,'Ventanas de aluminio lacado en blanco'			,20),
    	T_TIPO_DATA('35'		,'Persianas de aluminio'	,'Persianas de aluminio'							,10),
    	T_TIPO_DATA('36'		,'Ventanas correderas'		,'Ventanas correderas'								,8),
    	T_TIPO_DATA('37'		,'Ventanas abatibles'		,'Ventanas abatibles'								,8),
    	T_TIPO_DATA('38'		,'Ventanas oscilobatientes'	,'Ventanas oscilobatientes'							,10),
    	T_TIPO_DATA('39'		,'Doble cristal'			,'Doble acristalamiento o Climalit'					,20),
    	T_TIPO_DATA('40'		,'Humedad/Grieta paredes'	,'Humedad / Grietas en paredes'						,0),
    	T_TIPO_DATA('41'		,'Humedad/Grieta techos'	,'Humedad / Grietas en techos'						,0),
    	T_TIPO_DATA('42'		,'Gotelet'					,'Gotelet'											,40),
    	T_TIPO_DATA('43'		,'Plástica lisa'			,'Plástica lisa'									,40),
    	T_TIPO_DATA('44'		,'Papel pintado'			,'Papel pintado'									,40),
    	T_TIPO_DATA('45'		,'Pintura lisa en techo'	,'Pintura lisa en techos'							,5),
    	T_TIPO_DATA('46'		,'Moldura de escayola'		,'Moldura de escayola'								,5),
    	T_TIPO_DATA('47'		,'Tarima flotante'			,'Tarima flotante (excluido cocina/baño)'			,50),
    	T_TIPO_DATA('48'		,'Parquet'					,'Solados con parquet (excluido cocina/baño)'		,50),
    	T_TIPO_DATA('49'		,'Mármol'					,'Mármol (excluido cocina/baño)'					,50),
    	T_TIPO_DATA('50'		,'Plaqueta'					,'Plaqueta (excluido cocina/Baño)'					,20),
    	T_TIPO_DATA('51'		,'Cocina amueblada'			,'Cocina amueblada'									,20),
    	T_TIPO_DATA('52'		,'Encimera de granito'		,'Encimera de granito'								,30),
    	T_TIPO_DATA('53'		,'Encimera de mármol'		,'Encimera de mármol'								,30),
    	T_TIPO_DATA('54'		,'Encimera otro material'	,'Encimera de otro material'						,10),
    	T_TIPO_DATA('55'		,'Vitrocerámica'			,'Vitrocerámica'									,10),
    	T_TIPO_DATA('56'		,'Lavadora'					,'Lavadora'											,5),
    	T_TIPO_DATA('57'		,'Frigorífico'				,'Frigorífico'										,5),
    	T_TIPO_DATA('58'		,'Lavavajillas'				,'Lavavajillas'										,2),
    	T_TIPO_DATA('59'		,'Microondas'				,'Microondas'										,2),
    	T_TIPO_DATA('60'		,'Horno'					,'Horno'											,1),
    	T_TIPO_DATA('61'		,'Azulejos buen estado'		,'Azulejos en buen estado'							,20),
    	T_TIPO_DATA('62'		,'Suelos buen estado'		,'Suelos en buen estado'							,15),
    	T_TIPO_DATA('63'		,'Cocina grifería monomando','Cocina con grifería monomando'					,10),
    	T_TIPO_DATA('64'		,'Bañera hidromasaje'		,'Bañera hidromasaje'								,15),
    	T_TIPO_DATA('65'		,'Columna hidromasaje'		,'Columna hidromasaje'								,15),
    	T_TIPO_DATA('66'		,'Alicatado de mármol'		,'Alicatado de mármol'								,25),
    	T_TIPO_DATA('67'		,'Alicatado de granito'		,'Alicatado de granito'								,25),
    	T_TIPO_DATA('68'		,'Alicatado de azulejo'		,'Alicatado de azulejo'								,15),
    	T_TIPO_DATA('69'		,'Encimera de granito'		,'Encimera de granito'								,25),
    	T_TIPO_DATA('70'		,'Encimera de mármol'		,'Encimera de mármol'								,25),
    	T_TIPO_DATA('71'		,'Encimera de otro material','Encimera de otro material'						,15),
    	T_TIPO_DATA('72'		,'Sanitarios buen estado'	,'Sanitarios en buen estado'						,25),
    	T_TIPO_DATA('73'		,'Suelos buen estado'		,'Suelis en buen estado'							,20),
    	T_TIPO_DATA('74'		,'Baño grifería monomando'	,'Baño con grifería monomando'						,10),
    	T_TIPO_DATA('75'		,'Inst. eléctrica buena'	,'Instalación eléctrica en buen estado'				,100),
    	T_TIPO_DATA('76'		,'Inst. eléctrica defectuosa','Instalación eléctrica defectuosa o muy antigua'	,0),
    	T_TIPO_DATA('77'		,'Calefacción central'		,'Calefacción central'								,10),
    	T_TIPO_DATA('78'		,'Calefacción gas natural'	,'Calefacción de gas natural'						,10),
    	T_TIPO_DATA('79'		,'Radiadores de aluminio'	,'Radiadores de aluminio'							,20),
    	T_TIPO_DATA('80'		,'Agua caliente central'	,'Agua caliente central'							,10),
    	T_TIPO_DATA('81'		,'Aire acond. preinstalado'	,'Aire acondicionado con preinstalación'			,10),
    	T_TIPO_DATA('82'		,'Aire acond. instalado'	,'Aire acondicionado con instalación'				,20),
    	T_TIPO_DATA('ENT'		,'Entorno'					,'Valor máximo por entorno'							,300),
    	T_TIPO_DATA('EDI'		,'Edificio'					,'Valor máximo por edificio'						,300),
    	T_TIPO_DATA('INT'		,'Interior'					,'Valor máximo por interior'						,null)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_TUD_TIPO_USO_DESTINO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CPU_CRITERIO_PUNTUACION_ACT');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.CPU_CRITERIO_PUNTUACION_ACT WHERE CPU_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				

          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' ');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.CPU_CRITERIO_PUNTUACION_ACT '||
                    'SET CPU_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(2))||''' '|| 
					', CPU_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
					', CPU_VALOR = '''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
					', USUARIOMODIFICAR = ''REM_F2'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE CPU_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_CPU_CRITERIO_PUNTUACION_ACT.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.CPU_CRITERIO_PUNTUACION_ACT (' ||
                      ' CPU_ID, CPU_CODIGO, CPU_NOMBRE, CPU_DESCRIPCION, CPU_VALOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      ' SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''', '||
                      ' 0, ''REM_F2'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: CPU_CRITERIO_PUNTUACION_ACT ACTUALIZADO CORRECTAMENTE ');
   

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


