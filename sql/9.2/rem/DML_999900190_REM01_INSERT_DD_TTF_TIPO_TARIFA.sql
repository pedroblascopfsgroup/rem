--/*
--##########################################
--## AUTOR=Jose Navarro
--## FECHA_CREACION=20180412
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3960
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TTF_TIPO_TARIFA los datos añadidos en T_ARRAY_DATA.
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

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5050);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    		T_TIPO_DATA('TP1', 'Activos hasta 150 m2' ,'Activos hasta 150 m2'),
		T_TIPO_DATA('TP2', 'De 5 a 10 inmuebles' ,'De 5 a 10 inmuebles'),
		T_TIPO_DATA('TP3', 'De 10 a 20 inmuebles' ,'De 10 a 20 inmuebles'),
		T_TIPO_DATA('TP4', 'De 20 a 30 inmuebles' ,'De 20 a 30 inmuebles'),
		T_TIPO_DATA('TP5', 'Mas de 30 inmuebles' ,'Mas de 30 inmuebles'),
		T_TIPO_DATA('TP6', 'Activos de más de 150 m2 (con contenedor)' ,'Activos de más de 150 m2 (con contenedor)'),
		T_TIPO_DATA('TP7', 'Encimera 60cm, base tablero fib. madera+resinas sint.MDF,e=30mm.' ,'Encimera 60cm, base tablero fib. madera+resinas sint.MDF,e=30mm.'),
		T_TIPO_DATA('TP8', 'm2 Encimera inox AISI 316,e=1mm,pulido+esmerilado,ancho=60cm,5 pliegos,agujeros,colocada' ,'m2 Encimera inox AISI 316,e=1mm,pulido+esmerilado,ancho=60cm,5 pliegos,agujeros,colocada'),
		T_TIPO_DATA('TP9', 'Módulo estándard p/mueble cocina alto <=600x330mm h<=900mm, precio medio,+ti+her.+reg' ,'Módulo estándard p/mueble cocina alto <=600x330mm h<=900mm, precio medio,+ti+her.+reg'),
		T_TIPO_DATA('TP10', 'Módulo rinconero angular p/mueble cocina alto <=(900x900) x330mm h<=900mm,precio medio,+ti+her+reg.' ,'Módulo rinconero angular p/mueble cocina alto <=(900x900) x330mm h<=900mm,precio medio,+ti+her+reg.'),
		T_TIPO_DATA('TP11', 'Módulo campana p/mueble cocina alto <=600x330mm h<=600mm, precio medio,+tir.+her.+reg.' ,'Módulo campana p/mueble cocina alto <=600x330mm h<=600mm, precio medio,+tir.+her.+reg.'),
		T_TIPO_DATA('TP12', 'Columna mueble cocina <=600x600mm h<=2200mm,2estantes+2cazueleros, precio medio,+pie.+tir.+her.' ,'Columna mueble cocina <=600x600mm h<=2200mm,2estantes+2cazueleros, precio medio,+pie.+tir.+her.'),
		T_TIPO_DATA('TP13', 'Columna mueble cocina <=600x600mm h<=2200mm,2estantes+2, precio medio,+pies.+tir+her. 227,61 €' ,'Columna mueble cocina <=600x600mm h<=2200mm,2estantes+2, precio medio,+pies.+tir+her. 227,61 €'),
		T_TIPO_DATA('TP14', 'Módulo estándard p/mueble cocina bajo <=600x600mm h=700mm, puerta, precio medio, +pie+tir.+her.' ,'Módulo estándard p/mueble cocina bajo <=600x600mm h=700mm, puerta, precio medio, +pie+tir.+her.'),
		T_TIPO_DATA('TP15', 'Módulo estándard p/mueble cocina bajo <=600x600mm h=700mm, cajones/cazuelero, p.medio,+pie+tir.+her.' ,'Módulo estándard p/mueble cocina bajo <=600x600mm h=700mm, cajones/cazuelero, p.medio,+pie+tir.+her.'),
		T_TIPO_DATA('TP16', 'Módulo estándard p/mueble cocina bajo <=600x600mm h=700mm,1cajón+1 puerta, p.medio,+pie.+tir.+her.' ,'Módulo estándard p/mueble cocina bajo <=600x600mm h=700mm,1cajón+1 puerta, p.medio,+pie.+tir.+her.'),
		T_TIPO_DATA('TP17', 'Módulo fregadero p/mueble cocina bajo 600x600mm h=700mm,puerta,precio medio,+pie.+tir.+her.' ,'Módulo fregadero p/mueble cocina bajo 600x600mm h=700mm,puerta,precio medio,+pie.+tir.+her.'),
		T_TIPO_DATA('TP18', 'Módulo rinconero angular p/mueble cocina bajo <=(900x900)x600mm' ,'Módulo rinconero angular p/mueble cocina bajo <=(900x900)x600mm'),
		T_TIPO_DATA('TP19', 'Mobiliario p/cocina long<=3m,precio medio,módulos altos + módulos bajos.+ti.+her.+reg.' ,'Mobiliario p/cocina long<=3m,precio medio,módulos altos + módulos bajos.+ti.+her.+reg.'),
		T_TIPO_DATA('TP20', 'Mobiliario p/cocina long.3-4m,precio medio,módulos altos + módulos bajos.+ti.+her.+reg.' ,'Mobiliario p/cocina long.3-4m,precio medio,módulos altos + módulos bajos.+ti.+her.+reg.'),
		T_TIPO_DATA('TP21', 'Mobiliario p/cocina long.4-5m,precio medio,módulos altos + módulos bajos.+ti.+her.+reg.' ,'Mobiliario p/cocina long.4-5m,precio medio,módulos altos + módulos bajos.+ti.+her.+reg.'),
		T_TIPO_DATA('TP22', 'Cocina gas inox. 4 quemadores,conex.red gas. precio bajo.' ,'Cocina gas inox. 4 quemadores,conex.red gas. precio bajo.'),
		T_TIPO_DATA('TP23', 'Cocina gas inox. 4 quemadores,conex.red gas. precio medio.' ,'Cocina gas inox. 4 quemadores,conex.red gas. precio medio.'),
		T_TIPO_DATA('TP24', 'Placa vitrocerámica, marco inox.3/4 elemen. precio medio.' ,'Placa vitrocerámica, marco inox.3/4 elemen. precio medio.'),
		T_TIPO_DATA('TP25', 'Placa vitrocerámica, canto bisel. 3/4 elemen. precio medio.' ,'Placa vitrocerámica, canto bisel. 3/4 elemen. precio medio.'),
		T_TIPO_DATA('TP26', 'Campana horizontal blanco,60cm,1motor, interruptor, 3 velocidads, filtros,2 lámp.40W' ,'Campana horizontal blanco,60cm,1motor, interruptor, 3 velocidads, filtros,2 lámp.40W'),
		T_TIPO_DATA('TP27', 'Campana horizontal inox. 60cm,1motor, interruptor,3velocidads, filtros,2 lámp.40W' ,'Campana horizontal inox. 60cm,1motor, interruptor,3velocidads, filtros,2 lámp.40W'),
		T_TIPO_DATA('TP28', 'Horno multifunción color blanco precio bajo.' ,'Horno multifunción color blanco precio bajo.'),
		T_TIPO_DATA('TP29', 'Horno multifunción inox. precio bajo.' ,'Horno multifunción inox. precio bajo.'),
		T_TIPO_DATA('TP30', 'Horno multifunción color blanco precio medio.' ,'Horno multifunción color blanco precio medio.'),
		T_TIPO_DATA('TP31', 'Suministro y colocación de caldera atmosferica 24 Kw.' ,'Suministro y colocación de caldera atmosferica 24 Kw.'),
		T_TIPO_DATA('TP32', 'Suministro y colocación de caldera estanca 24 Kw.' ,'Suministro y colocación de caldera estanca 24 Kw.'),
		T_TIPO_DATA('TP33', 'Suministro y colocación de caldera estanca 20/20 F o similar con microacumulación' ,'Suministro y colocación de caldera estanca 20/20 F o similar con microacumulación'),
		T_TIPO_DATA('TP34', 'Termo eléctrico 50l' ,'Termo eléctrico 50l'),
		T_TIPO_DATA('TP35', 'Termo eléctrico 80l' ,'Termo eléctrico 80l'),
		T_TIPO_DATA('TP36', 'Desbroces, incluyendo poda arbolado hasta 5 uds, superficie hasta 500 m² con transporte a vertedero.' ,'Desbroces, incluyendo poda arbolado hasta 5 uds, superficie hasta 500 m² con transporte a vertedero.'),
		T_TIPO_DATA('TP37', 'Desbroces, incluyendo poda arbolado hasta 10 uds, superficie entre 500 m² y 1.000 m2 con transporte a vertedero.' ,'Desbroces, incluyendo poda arbolado hasta 10 uds, superficie entre 500 m² y 1.000 m2 con transporte a vertedero.'),
		T_TIPO_DATA('TP38', 'Desbroces, , incluyendo poda arbolado hasta 50 uds superficie entre 1000 m² y 5.000 m² con transporte a vertedero' ,'Desbroces, , incluyendo poda arbolado hasta 50 uds superficie entre 1000 m² y 5.000 m² con transporte a vertedero'),
		T_TIPO_DATA('TP39', 'Desbroces, , incluyendo poda arbolado hasta 100 uds superficie entre 5000 m² y 10.000 m² con transporte a vertedero' ,'Desbroces, , incluyendo poda arbolado hasta 100 uds superficie entre 5000 m² y 10.000 m² con transporte a vertedero'),
		T_TIPO_DATA('TP40', 'Tratamiento retardador malas hierbas (herbicida)' ,'Tratamiento retardador malas hierbas (herbicida)'),
		T_TIPO_DATA('TP41', 'Vallado con bloque de hormigón de 20cm, hasta una altura de 2 m enfoscado, maestreado. Con pilares cada 3m de bloque de hormigón de 20cm armado y hormigonado. Incluso ejecución de cimentación de Hormigón HA-20 con dimensiones 30*20 cm, incluso acero para armar B500S a base de redondos de 12mm y cercos de 8mm cada 30cm. Incluso preparación del terreno, excavación, encofrado y desencofrado. Unidad totalmente terminada.' ,'Vallado con bloque de hormigón de 20cm, hasta una altura de 2 m enfoscado, maestreado. Con pilares cada 3m de bloque de hormigón de 20cm armado y hormigonado. Incluso ejecución de cimentación de Hormigón HA-20 con dimensiones 30*20 cm, incluso acero para armar B500S a base de redondos de 12mm y cercos de 8mm cada 30cm. Incluso preparación del terreno, excavación, encofrado y desencofrado. Unidad totalmente terminada.'),
		T_TIPO_DATA('TP42', 'Vallado con bloque de hormigón de 20cm, hasta una altura de 1 m, enfoscado, maestreado. Con pilares cada 3m de bloque de hormigón de 20cm armado y hormigonado. Incluso ejecución de cimentación de Hormigón HA-20 con dimensiones 30*20 cm, incluso acero para armar B500S a base de redondos de 12mm y cercos de 8mm cada 30cm. Incluso preparación del terreno, excavación, encofrado y desencofrado. Unidad totalmente terminada.' ,'Vallado con bloque de hormigón de 20cm, hasta una altura de 1 m, enfoscado, maestreado. Con pilares cada 3m de bloque de hormigón de 20cm armado y hormigonado. Incluso ejecución de cimentación de Hormigón HA-20 con dimensiones 30*20 cm, incluso acero para armar B500S a base de redondos de 12mm y cercos de 8mm cada 30cm. Incluso preparación del terreno, excavación, encofrado y desencofrado. Unidad totalmente terminada.'),
		T_TIPO_DATA('TP43', 'Vallado con chapa metálica nervada hasta 2m de altura incluso elementos verticales de sujeción cada 3 metros, cimentación y anclaje de los postes. Unidad totalmente terminada y puesta en servicio.' ,'Vallado con chapa metálica nervada hasta 2m de altura incluso elementos verticales de sujeción cada 3 metros, cimentación y anclaje de los postes. Unidad totalmente terminada y puesta en servicio.'),
		T_TIPO_DATA('TP44', 'Limpieza y desbroce de parcelas con medios manuales o mecánicos superiores a 5000m2. Incluida poda ramas bajas de arboles y retirada a vertedero' ,'Limpieza y desbroce de parcelas con medios manuales o mecánicos superiores a 5000m2. Incluida poda ramas bajas de arboles y retirada a vertedero'),
		T_TIPO_DATA('TP45', 'Cerramiento de Ladrillo de 11cm de espesor, realizada con ladrillos cerámicos huecos de 33x16x11cm hasta 50m2' ,'Cerramiento de Ladrillo de 11cm de espesor, realizada con ladrillos cerámicos huecos de 33x16x11cm hasta 50m2'),
		T_TIPO_DATA('TP46', 'de 50 m2 a 100 m2' ,'de 50 m2 a 100 m2'),
		T_TIPO_DATA('TP47', 'de 100 m2 a 200 m2' ,'de 100 m2 a 200 m2'),
		T_TIPO_DATA('TP48', 'Cerramiento de ladrillo panal, de 11.5cm de espesor, realizada con ladrillos cerámicos perforados de 24x11.5x9cm hasta 50m2' ,'Cerramiento de ladrillo panal, de 11.5cm de espesor, realizada con ladrillos cerámicos perforados de 24x11.5x9cm hasta 50m2'),
		T_TIPO_DATA('TP49', 'de 50m2 a 100m2' ,'de 50m2 a 100m2'),
		T_TIPO_DATA('TP50', 'de 100m2 a 200m2' ,'de 100m2 a 200m2'),
		T_TIPO_DATA('TP51', 'PUERTA PEATONAL: puerta metálica de malla o chapa de acero galvanizado para acceso peatonal (0,8 - 1m) de paso, candado, incluso material necesario para su puesta en servicio y cimentación para anclajes. Incluyendo ejecución de rampas en el caso de ser necesarias. Unidad totalmente terminada y puesta en servicio.' ,'PUERTA PEATONAL: puerta metálica de malla o chapa de acero galvanizado para acceso peatonal (0,8 - 1m) de paso, candado, incluso material necesario para su puesta en servicio y cimentación para anclajes. Incluyendo ejecución de rampas en el caso de ser necesarias. Unidad totalmente terminada y puesta en servicio.'),
		T_TIPO_DATA('TP52', 'Puerta abatible de 3x2 m. para cerramiento exterior, formada por bastidor de tubo de acero laminado, montantes de 40x30x1,5 mm., travesaños de 30x30x1,5 y columnas de fijación de 80x80x2 de chapa galvanizada en caliente por inmersión Z-275, i/herrajes de colgar y seguridad, parador de pie y tope, candado, elaborada en taller, ajuste y montaje en obra. Totalmente instalada.' ,'Puerta abatible de 3x2 m. para cerramiento exterior, formada por bastidor de tubo de acero laminado, montantes de 40x30x1,5 mm., travesaños de 30x30x1,5 y columnas de fijación de 80x80x2 de chapa galvanizada en caliente por inmersión Z-275, i/herrajes de colgar y seguridad, parador de pie y tope, candado, elaborada en taller, ajuste y montaje en obra. Totalmente instalada.'),
		T_TIPO_DATA('TP53', 'Cercado de 2 m. de altura realizado con malla simple torsión galvanizada en caliente de trama 50/14, y postes de tubo de acero galvanizado por inmersión de 48 mm de diámetro,cada 3 metros, p.p. de postes de esquina, jabalcones, tornapuntas, tensores, grupillas y accesorios, montada i/ replanteo y recibido de postes con hormigón HM-20/P/20/I.' ,'Cercado de 2 m. de altura realizado con malla simple torsión galvanizada en caliente de trama 50/14, y postes de tubo de acero galvanizado por inmersión de 48 mm de diámetro,cada 3 metros, p.p. de postes de esquina, jabalcones, tornapuntas, tensores, grupillas y accesorios, montada i/ replanteo y recibido de postes con hormigón HM-20/P/20/I.'),
		T_TIPO_DATA('TP54', 'Cercado de 1,50 m. de altura realizado con malla simple torsión galvanizada en caliente de trama 50/14, y postes de tubo de acero galvanizado por inmersión de 48 mm de diámetro, cada 3 metros, p.p. de postes de esquina, jabalcones, tornapuntas, tensores, grupillas y accesorios, montada i/ replanteo y recibido de postes con hormigón HM-20/P/20/I.' ,'Cercado de 1,50 m. de altura realizado con malla simple torsión galvanizada en caliente de trama 50/14, y postes de tubo de acero galvanizado por inmersión de 48 mm de diámetro, cada 3 metros, p.p. de postes de esquina, jabalcones, tornapuntas, tensores, grupillas y accesorios, montada i/ replanteo y recibido de postes con hormigón HM-20/P/20/I.'),
		T_TIPO_DATA('TP55', 'Cercado de 1 m. de altura realizado con malla simple torsión galvanizada en caliente de trama 50/14, y postes de tubo de acero galvanizado por inmersión de 48 mm de diámetro, cada 3 metros, p.p. de postes de esquina, jabalcones, tornapuntas, tensores, grupillas y accesorios, montada i/ replanteo y recibido de postes con hormigón HM-20/P/20/I.' ,'Cercado de 1 m. de altura realizado con malla simple torsión galvanizada en caliente de trama 50/14, y postes de tubo de acero galvanizado por inmersión de 48 mm de diámetro, cada 3 metros, p.p. de postes de esquina, jabalcones, tornapuntas, tensores, grupillas y accesorios, montada i/ replanteo y recibido de postes con hormigón HM-20/P/20/I.'),
		T_TIPO_DATA('TP56', 'Desmontado por medios manuales de cercado de malla simple torsión galvanizada en caliente de trama 50/14 y postes de tubo de acero galvanizado, con recuperación del material desmontado, incluso ayudas de albañilería, medios de elevación carga, descarga, retirada de escombros y posterior transporte a vertedero.' ,'Desmontado por medios manuales de cercado de malla simple torsión galvanizada en caliente de trama 50/14 y postes de tubo de acero galvanizado, con recuperación del material desmontado, incluso ayudas de albañilería, medios de elevación carga, descarga, retirada de escombros y posterior transporte a vertedero.'),
		T_TIPO_DATA('TP57', 'RETIRADA RESIDUOS: Retirada de residuos inertes (restos de obra, basuras, etc.), incluso medios de elevación carga, descarga y posterior transporte a vertedero.' ,'RETIRADA RESIDUOS: Retirada de residuos inertes (restos de obra, basuras, etc.), incluso medios de elevación carga, descarga y posterior transporte a vertedero.'),
		T_TIPO_DATA('TP58', 'RETIRADA FIBROCEMENTO: Retirada, desmontaje y acondicionamiento de residuos contaminados de fibrocemento, amianto,... Incluso plan de trabajo específico, autorizaciones necesarias, retirada a vertedero autorizado y certificado de gestión.' ,'RETIRADA FIBROCEMENTO: Retirada, desmontaje y acondicionamiento de residuos contaminados de fibrocemento, amianto,... Incluso plan de trabajo específico, autorizaciones necesarias, retirada a vertedero autorizado y certificado de gestión.'),
		T_TIPO_DATA('TP59', 'Aislamiento mediante espuma rígida de poliuretano hidrofugo, proyectada sobre los paramentos verticales, con una densidad mínima de 50 kg/m3. y 3 cm. de espesor medio, incluso maquinaria de proyección y medios auxiliares, medido a cinta corrida.' ,'Aislamiento mediante espuma rígida de poliuretano hidrofugo, proyectada sobre los paramentos verticales, con una densidad mínima de 50 kg/m3. y 3 cm. de espesor medio, incluso maquinaria de proyección y medios auxiliares, medido a cinta corrida.'),
		T_TIPO_DATA('TP60', 'Activo (desratización 80/150 m2)' ,'Activo (desratización 80/150 m2)'),
		T_TIPO_DATA('TP61', 'Desinfección general de la urbanización' ,'Desinfección general de la urbanización'),
		T_TIPO_DATA('TP62', 'Cepos garaje' ,'Cepos garaje'),
		T_TIPO_DATA('TP63', 'Obtencion de Boletin de Agua' ,'Obtencion de Boletin de Agua'),
		T_TIPO_DATA('TP64', 'Obtencion de Boletin de Luz' ,'Obtencion de Boletin de Luz'),
		T_TIPO_DATA('TP65', 'Obtencion de Boletin de Gas' ,'Obtencion de Boletin de Gas'),
		T_TIPO_DATA('TP66', 'Obtención de CEE' ,'Obtención de CEE'),
		T_TIPO_DATA('TP67', 'Arreglo de pared (caída)' ,'Arreglo de pared (caída)'),
		T_TIPO_DATA('TP68', 'Arreglo de pared (agujero)' ,'Arreglo de pared (agujero)'),
		T_TIPO_DATA('TP69', 'Arreglo de techo (caída)' ,'Arreglo de techo (caída)'),
		T_TIPO_DATA('TP70', 'Arreglo de techo (agujero)' ,'Arreglo de techo (agujero)'),
		T_TIPO_DATA('TP71', 'Arreglo de piscina en urbanización' ,'Arreglo de piscina en urbanización'),
		T_TIPO_DATA('TP72', 'Arreglo de zonas comunes en urbanización' ,'Arreglo de zonas comunes en urbanización'),
		T_TIPO_DATA('TP73', 'Arreglo de puertas de garajes' ,'Arreglo de puertas de garajes'),
		T_TIPO_DATA('TP74', 'Desmontaje de tuberías' ,'Desmontaje de tuberías'),
		T_TIPO_DATA('TP75', 'Cambio de tuberías' ,'Cambio de tuberías'),
		T_TIPO_DATA('TP76', 'Viviendas de menores de 80m2' ,'Viviendas de menores de 80m2'),
		T_TIPO_DATA('TP77', 'Viviendas de 80 a 100 m2' ,'Viviendas de 80 a 100 m2'),
		T_TIPO_DATA('TP78', 'Viviendas de 100 a 120 m2' ,'Viviendas de 100 a 120 m2'),
		T_TIPO_DATA('TP79', 'Viviendas de 120 a 150 m2' ,'Viviendas de 120 a 150 m2'),
		T_TIPO_DATA('TP80', 'Viviendas de más de 150 m2' ,'Viviendas de más de 150 m2'),
		T_TIPO_DATA('TP81', 'Pintura de urbanización' ,'Pintura de urbanización'),
		T_TIPO_DATA('TP82', 'Colocación de vallas en suelos' ,'Colocación de vallas en suelos'),
		T_TIPO_DATA('TP83', 'Instalaciones de electricidad 24 horas' ,'Instalaciones de electricidad 24 horas'),
		T_TIPO_DATA('TP84', 'Cambio de puerta' ,'Cambio de puerta'),
		T_TIPO_DATA('TP85', 'Cambio de ventana' ,'Cambio de ventana'),
		T_TIPO_DATA('TP86', 'Cambio de persiana' ,'Cambio de persiana'),
		T_TIPO_DATA('TP87', 'Arreglo de puerta' ,'Arreglo de puerta'),
		T_TIPO_DATA('TP88', 'Arreglo de ventana/ persiana' ,'Arreglo de ventana/ persiana'),
		T_TIPO_DATA('TP89', 'Ruptura puntual de tubería' ,'Ruptura puntual de tubería'),
		T_TIPO_DATA('TP90', 'Desmontaje y montaje de lavabo con pedestal' ,'Desmontaje y montaje de lavabo con pedestal'),
		T_TIPO_DATA('TP91', 'Desmontaje y montaje de bidet' ,'Desmontaje y montaje de bidet'),
		T_TIPO_DATA('TP92', 'Desmontaje y montaje de inodoro con cisterna baja' ,'Desmontaje y montaje de inodoro con cisterna baja'),
		T_TIPO_DATA('TP93', 'Desmontaje y montaje de plato de ducha' ,'Desmontaje y montaje de plato de ducha'),
		T_TIPO_DATA('TP94', 'Desmontaje y montaje de bañera' ,'Desmontaje y montaje de bañera'),
		T_TIPO_DATA('TP95', 'Cambio Mecanismo de cisterna' ,'Cambio Mecanismo de cisterna'),
		T_TIPO_DATA('TP96', 'Enlucido de yeso m2' ,'Enlucido de yeso m2'),
		T_TIPO_DATA('TP97', 'Enfoscado de mortero de cemento m2' ,'Enfoscado de mortero de cemento m2'),
		T_TIPO_DATA('TP98', 'Paño falso techo de escayola m2' ,'Paño falso techo de escayola m2'),
		T_TIPO_DATA('TP99', 'Pavimento terrazo/gres m2 -rodapié incluido' ,'Pavimento terrazo/gres m2 -rodapié incluido'),
		T_TIPO_DATA('TP100', 'Rehacer enlucido de yeso m2' ,'Rehacer enlucido de yeso m2'),
		T_TIPO_DATA('TP101', 'Rehacer m2 alicatado (gres cerámico)' ,'Rehacer m2 alicatado (gres cerámico)'),
		T_TIPO_DATA('TP102', 'Cambio parquet' ,'Cambio parquet'),
		T_TIPO_DATA('TP103', 'Reparación parquet' ,'Reparación parquet'),
		T_TIPO_DATA('TP104', 'Ml escayola' ,'Ml escayola'),
		T_TIPO_DATA('TP105', 'Alicatado o solado m2 (material estimado 8€ m2)' ,'Alicatado o solado m2 (material estimado 8€ m2)'),
		T_TIPO_DATA('TP106', 'Demolición solado gres m2' ,'Demolición solado gres m2'),
		T_TIPO_DATA('TP107', 'Demolición terrazo m2' ,'Demolición terrazo m2'),
		T_TIPO_DATA('TP108', 'Demolición alicatada m2' ,'Demolición alicatada m2'),
		T_TIPO_DATA('TP109', 'Demolición-mármol m2' ,'Demolición-mármol m2'),
		T_TIPO_DATA('TP110', 'Picado de yeso (demolición) m2' ,'Picado de yeso (demolición) m2'),
		T_TIPO_DATA('TP111', 'Picado de cemento (demolición) m2' ,'Picado de cemento (demolición) m2'),
		T_TIPO_DATA('TP112', 'Demolición m2 Ladrillo H. sencillo m2' ,'Demolición m2 Ladrillo H. sencillo m2'),
		T_TIPO_DATA('TP113', 'Demolición m2 Ladrillo H. Doble m2' ,'Demolición m2 Ladrillo H. Doble m2'),
		T_TIPO_DATA('TP114', 'Localización de avería' ,'Localización de avería'),
		T_TIPO_DATA('TP115', 'Punto de luz sencillo' ,'Punto de luz sencillo'),
		T_TIPO_DATA('TP116', 'Punto de timbre' ,'Punto de timbre'),
		T_TIPO_DATA('TP117', 'Sustitución de interruptores' ,'Sustitución de interruptores'),
		T_TIPO_DATA('TP118', 'Cristal sencillo-incoloro 5mm-m2' ,'Cristal sencillo-incoloro 5mm-m2'),
		T_TIPO_DATA('TP119', 'Doble cristal tipo Climalit 4+6+4 /m2' ,'Doble cristal tipo Climalit 4+6+4 /m2'),
		T_TIPO_DATA('TP120', 'Doble cristal tipo Climalit 5+6+4 /m2' ,'Doble cristal tipo Climalit 5+6+4 /m2'),
		T_TIPO_DATA('TP121', 'Informe técnico (Arquitecto Técnico). Se adjunta formato del Informe como Anexo' ,'Informe técnico (Arquitecto Técnico). Se adjunta formato del Informe como Anexo'),
		T_TIPO_DATA('TP122', 'Visita técnica no especilizado (1 hora)' ,'Visita técnica no especilizado (1 hora)'),
		T_TIPO_DATA('TP123', '1º Hora Oficial Albañil (incluido desplazamiento) para los oficios de Cerrajero, Fontanero, Electricista, Cerrajero, Pintor, Parquetista, Cristalero y Carpintero. ' ,'1º Hora Oficial Albañil (incluido desplazamiento) para los oficios de Cerrajero, Fontanero, Electricista, Cerrajero, Pintor, Parquetista, Cristalero y Carpintero. '),
		T_TIPO_DATA('TP124', '1º Hora Oficial de Climatización (incluido desplazamiento) ' ,'1º Hora Oficial de Climatización (incluido desplazamiento) '),
		T_TIPO_DATA('TP125', '2º Hora y sucesivas Oficial Albañil (incluido desplazamiento) para los oficios de Cerrajero, Fontanero, Electricista, Cerrajero, Pintor, Parquetista, Cristalero y Carpintero, peón, climatización .' ,'2º Hora y sucesivas Oficial Albañil (incluido desplazamiento) para los oficios de Cerrajero, Fontanero, Electricista, Cerrajero, Pintor, Parquetista, Cristalero y Carpintero, peón, climatización .'),
		T_TIPO_DATA('TP126', 'Incremento de tarifa a partir de las 20:00 hrs. De Lunes a Viernes' ,'Incremento de tarifa a partir de las 20:00 hrs. De Lunes a Viernes'),
		T_TIPO_DATA('TP127', 'Incremento de tarifa para Sábados, Domingos y Festivos ' ,'Incremento de tarifa para Sábados, Domingos y Festivos '),
		T_TIPO_DATA('TP128', 'Informe técnico (Arquitecto Técnico). Se adjunta formato del Informe como Anexo ' ,'Informe técnico (Arquitecto Técnico). Se adjunta formato del Informe como Anexo '),
		T_TIPO_DATA('TP129', 'Visita técnica no especilizado (1 hora)' ,'Visita técnica no especilizado (1 hora)'),
		T_TIPO_DATA('TP130', '1º Hora Oficial Albañil (incluido desplazamiento) para los oficios de Cerrajero, Fontanero, Electricista, Cerrajero, Pintor, Parquetista, Cristalero y Carpintero. ' ,'1º Hora Oficial Albañil (incluido desplazamiento) para los oficios de Cerrajero, Fontanero, Electricista, Cerrajero, Pintor, Parquetista, Cristalero y Carpintero. '),
		T_TIPO_DATA('TP131', '1º Hora Oficial de Climatización (incluido desplazamiento) ' ,'1º Hora Oficial de Climatización (incluido desplazamiento) '),
		T_TIPO_DATA('TP132', '2º Hora y sucesivas Oficial Albañil (incluido desplazamiento) para los oficios de Cerrajero, Fontanero, Electricista, Cerrajero, Pintor, Parquetista, Cristalero y Carpintero, peón, climatización .' ,'2º Hora y sucesivas Oficial Albañil (incluido desplazamiento) para los oficios de Cerrajero, Fontanero, Electricista, Cerrajero, Pintor, Parquetista, Cristalero y Carpintero, peón, climatización .'),
		T_TIPO_DATA('TP133', 'Incremento de tarifa a partir de las 20:00 hrs. De Lunes a Viernes' ,'Incremento de tarifa a partir de las 20:00 hrs. De Lunes a Viernes'),
		T_TIPO_DATA('TP134', 'Incremento de tarifa para Sábados, Domingos y Festivos ' ,'Incremento de tarifa para Sábados, Domingos y Festivos ')

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
					', DD_TTF_DESCRIPCION_LARGA = '''||SUBSTR(TRIM(V_TMP_TIPO_DATA(3)),1,250)||''''||
					', USUARIOMODIFICAR = ''HREOS-3960'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_TTF_TIPO_TARIFA.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_TTF_TIPO_TARIFA (' ||
                      'DD_TTF_ID, DD_TTF_CODIGO, DD_TTF_DESCRIPCION, DD_TTF_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),1,100)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(3)),1,250)||''', 0, ''HREOS-3960'',SYSDATE,0 FROM DUAL';
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
