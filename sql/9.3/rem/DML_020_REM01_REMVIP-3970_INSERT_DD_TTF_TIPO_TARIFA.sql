--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190521
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3970
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
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-3970'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
    V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(10000);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
		T_TIPO_DATA('OM1'  ,' Verificación y localización de avería '),
		T_TIPO_DATA('VER1'  ,'Verificación y localización de avería descubriendo (máximo 2 horas)'),
		T_TIPO_DATA('OM3'  ,'Segunda localización: verificación y observación de avería'),
		T_TIPO_DATA('OM4'  ,'Soldadura de tuberías generales y reparación de bajantes PVC '),
		T_TIPO_DATA('OM5'  ,'Sustitución de tubería bajante general fecales hasta 3 metros'),
		T_TIPO_DATA('OM6'  ,'Sustitución de tubería bajante PVC general pluviales hasta 3 metros lineales'),
		T_TIPO_DATA('OM7'  ,'Sustitución de tubería general de alimentación hasta 3 m 1 Pulgada'),
		T_TIPO_DATA('OM8'  ,'Sustitución de tubería general de alimentación hasta 3m 2 Pulgadas'),
		T_TIPO_DATA('OM9'  ,'Sustitución de tramo de bajante fecal con injerto sencillo'),
		T_TIPO_DATA('OM10'  ,'Sustitución de tramo de bajante fecal con injerto doble'),
		T_TIPO_DATA('OM11'  ,'Sustitución de desagüe de plomo hasta 1 metro (reemplazar por un material autorizado)'),
		T_TIPO_DATA('OM12'  ,'Sustitución de desagüe de plomo hasta 2 metros (reemplazar por un material autorizado)'),
		T_TIPO_DATA('OM13'  ,'Sustitución de desagüe de plomo hasta 3 metros (reemplazar por un material autorizado)'),
		T_TIPO_DATA('OM14'  ,'Sustitución de desagüe de PVC hasta 1 metro '),
		T_TIPO_DATA('OM15'  ,'Sustitución de desagüe de PVC hasta 3 metros '),
		T_TIPO_DATA('OM16'  ,'Sustitución de tubería de alimentación hasta 1 metro lineal'),
		T_TIPO_DATA('OM17'  ,'Sustitución de tubería de alimentación hasta 2 metros lineales'),
		T_TIPO_DATA('OM18'  ,'Sustitución de tubería de alimentación hasta 3 metros lineales'),
		T_TIPO_DATA('OM19'  ,'Sustitución de tubería de alimentación hasta 6 metros lineales'),
		T_TIPO_DATA('OM20'  ,'Sustitución de tubería de agua fría y caliente 1 metro lineal cada una'),
		T_TIPO_DATA('OM21'  ,'Sustitución tubería de agua fría y caliente 2 metros lineales cada una '),
		T_TIPO_DATA('OM22'  ,'Sustitución tubería de agua fría y caliente hasta 3 metros lineales cada una'),
		T_TIPO_DATA('OM23'  ,'Sustitución de tubería de agua fría y caliente hasta 6 m 1 cada una'),
		T_TIPO_DATA('OM24'  ,'Sustitución manguetón PVC (Incluido desmontar y montar inodoro)'),
		T_TIPO_DATA('OM25'  ,'Sustitución manguetón plomo (Incluido desmontar y montar inodoro) (reemplazar por un material autorizado)'),
		T_TIPO_DATA('OM26'  ,'Sustitución de bote sifónico normal'),
		T_TIPO_DATA('OM27'  ,'Encasquillado de bote sifónico '),
		T_TIPO_DATA('OM28'  ,'Sustitución de bote sifónico de PVC'),
		T_TIPO_DATA('OM29'  ,'Hacer junta de manguetón WC. con inodoro o bajante general (un)'),
		T_TIPO_DATA('OM30'  ,'Sustitución de válvula y rebosadero de bañera '),
		T_TIPO_DATA('OM31'  ,'Reparar mangueta o bote sifónico o desagüe o tubería sin sustitución'),
		T_TIPO_DATA('OM32'  ,'Colocación de gebo 1 unidad hasta 1/2 pulgada'),
		T_TIPO_DATA('OM33'  ,'Colocación de gebo 1 unidad hasta 3/4 pulgada'),
		T_TIPO_DATA('OM34'  ,'Únicamente sustitución de sanitario'),
		T_TIPO_DATA('OM35'  ,'Desmontaje y montaje de sanitarios (lavabo, bidet e inodoro)'),
		T_TIPO_DATA('OM36'  ,'Sustitución de mecanismo de cisterna (sin material)'),
		T_TIPO_DATA('OM37'  ,'Sustitución de grifería (sin material)'),
		T_TIPO_DATA('OM38'  ,'Sustitución de bañera (sin material)'),
		T_TIPO_DATA('OM39'  ,'Unidad de desatasco en vivienda particular (En ciudad)'),
		T_TIPO_DATA('OM40'  ,'Temple liso, hasta 10 m²'),
		T_TIPO_DATA('OM41'  ,'Temple liso, metro cuadrado adicional (a partir de 10 m²)'),
		T_TIPO_DATA('OM42'  ,'Temple picado, hasta 10 m²'),
		T_TIPO_DATA('OM43'  ,'Temple picado, metro cuadrado adicional (a partir de 10 m²)'),
		T_TIPO_DATA('OM44'  ,'Plástico liso, hasta 10 m²'),
		T_TIPO_DATA('OM45'  ,'Plástico liso, m² adicional (a partir de 10 m²)'),
		T_TIPO_DATA('OM46'  ,'Picado, acabado plástico, hasta 10 m²'),
		T_TIPO_DATA('OM47'  ,'Picado, acabado plástico, m² adicional (a partir de 10 m²)'),
		T_TIPO_DATA('OM48'  ,'Gotelet, acabado plástico, hasta 10 metros cuadrados'),
		T_TIPO_DATA('OM49'  ,'Gotelet, acabado plástico, metro adicional, a partir de 10 m²'),
		T_TIPO_DATA('OM50'  ,'Pintura tisotrópica (paramentos muy afectados) hasta 10 m²'),
		T_TIPO_DATA('OM51'  ,'Pintura tisotrópica (paramentos muy afect.) m² adicional a partir de 10 m²'),
		T_TIPO_DATA('OM52'  ,'Pasta rayada, hasta 10 m²'),
		T_TIPO_DATA('OM53'  ,'Pasta rayada, metro cuadrado adicional, a partir de 10 m²'),
		T_TIPO_DATA('OM54'  ,'Esmalte, hasta 10 metros cuadrados'),
		T_TIPO_DATA('OM55'  ,'Esmalte, metro cuadrado adicional, a partir de 10 m²'),
		T_TIPO_DATA('OM56'  ,'Tapar 1/2 m² de techo de escayola'),
		T_TIPO_DATA('OM57'  ,'Tapar 1 m² de techo de escayola'),
		T_TIPO_DATA('OM58'  ,'Tapar 2 m² de techo de escayola'),
		T_TIPO_DATA('OM59'  ,'Tapar 3 m² de techo de escayola'),
		T_TIPO_DATA('OM60'  ,'Tapar m² adicional (a partir de 3 m²) de techo de escayola'),
		T_TIPO_DATA('OM61'  ,'Hasta 3 metros lineales de moldura de escayola'),
		T_TIPO_DATA('OM62'  ,'Metro lineal de moldura de escayola adicional'),
		T_TIPO_DATA('OM63'  ,'Tapar cala enlucido una o dos caras 1/2 m²'),
		T_TIPO_DATA('OM64'  ,'Tapar cala enlucido una o dos caras 1 m²'),
		T_TIPO_DATA('OM65'  ,'Tapar cala con alicatado o solado 1/2 m²'),
		T_TIPO_DATA('OM66'  ,'Tapar cala con alicatado o solado 1 m²'),
		T_TIPO_DATA('OM67'  ,'Tapar cala con alicatado o solado 2 m²'),
		T_TIPO_DATA('OM68'  ,'Tapar cala con alicatado o solado 3 m²'),
		T_TIPO_DATA('OM69'  ,'M² de alicatado o solado hasta 3 m (precio por metro)'),
		T_TIPO_DATA('OM70'  ,'M² de alicatado o solado más de 3 m (precio por metro)'),
		T_TIPO_DATA('OM71'  ,'Picar y tapar 1/2 m² de enlucido en paredes verticales'),
		T_TIPO_DATA('OM72'  ,'Picar y tapar 1 m² de enlucido, en paredes verticales'),
		T_TIPO_DATA('OM73'  ,'Picar y tapar 2 m² de enlucido, en paredes verticales'),
		T_TIPO_DATA('OM74'  ,'Picar y tapar 3 m² de enlucido, en paredes verticales'),
		T_TIPO_DATA('OM75'  ,'Picar y tapar m² adicional de enlucido, en paredes verticales (a partir de 3 m)'),
		T_TIPO_DATA('OM76'  ,'M² solo raseado con arena y cemento'),
		T_TIPO_DATA('OM77'  ,'M² picar yeso'),
		T_TIPO_DATA('OM78'  ,'M² tender yeso negro'),
		T_TIPO_DATA('OM79'  ,'M² tender yeso blanco'),
		T_TIPO_DATA('OM80'  ,'M² picar cemento (azulejo, plaqueta o terrazo) para alicatar o solar'),
		T_TIPO_DATA('OM81'  ,'M² picar hormigón e=10cm'),
		T_TIPO_DATA('OM82'  ,'Tapar cala hormigón 1 m²'),
		T_TIPO_DATA('OM83'  ,'Tapar cala hormigón m² adicional'),
		T_TIPO_DATA('OM84'  ,'Suministro e instalación de lunas incoloras de 3 mm (un metro cuadrado) incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM85'  ,'Suministro e instalación de vidrio simple de 4 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM86'  ,'Suministro e instalación de vidrio simple de 5 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM87'  ,'Suministro e instalación de vidrio simple de 6 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM88'  ,'Suministro e instalación de vidrio simple de 8 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM89'  ,'Suministro e instalación de vidrio simple de 10 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM90'  ,'Suministro e instalación de vidrio simple de 15 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM91'  ,'Composición incoloro climalit o similar 4+6+4 (m²)'),
		T_TIPO_DATA('OM92'  ,'Composición incoloro climalit o similar 5+6+4 (m²)'),
		T_TIPO_DATA('OM93'  ,'Composición incoloro climalit o similar 6+6+4 (m²)'),
		T_TIPO_DATA('OM94'  ,'Composición con vidrio impreso climalit o similar 4+6+4  m²)'),
		T_TIPO_DATA('OM95'  ,'Suministro e instalación de vidrios laminados de seguridad de 3+3 mm (m²)'),
		T_TIPO_DATA('OM96'  ,'Suministro e instalación de vidrios laminados de seguridad de 4+4 mm (m²)'),
		T_TIPO_DATA('OM97'  ,'Suministro e instalación de vidrios laminados de seguridad de 5+5 mm m²)'),
		T_TIPO_DATA('OM98'  ,'Suministro e instalación de vidrios laminados de seguridad de 6+6 mm (m²)'),
		T_TIPO_DATA('OM99'  ,'Tres lunas antirrobo 6+6+6 mm (metro cuadrado)'),
		T_TIPO_DATA('OM100'  ,'Tres lunas antibala 10+10+2,5 mm (metro cuadrado)'),
		T_TIPO_DATA('OM101'  ,'Suministro e instalación de luna incolora templada de 6mrn (metro cuadrado)'),
		T_TIPO_DATA('OM102'  ,'Suministro e instalación de luna incolora templada de 8mm (metro cuadrado)'),
		T_TIPO_DATA('OM103'  ,'Suministro e instalación de luna incolora templada de 10 mm (metro cuadrado)'),
		T_TIPO_DATA('OM104'  ,'Suministro e instalación de luna en color templada de6 mm (metro cuadrado)'),
		T_TIPO_DATA('OM105'  ,'Suministro e instalación de luna en color templada de 10 mm (metro cuadrado)'),
		T_TIPO_DATA('OM106'  ,'Suministro e instalación de luna templada en puertas de 10 mm (metro cuadrado'),
		T_TIPO_DATA('OM107'  ,'Taladros punto de luces (metro lineal o unidad)'),
		T_TIPO_DATA('OM108'  ,'Taladros grosor hasta 6 mm, hasta 25 mm de diámetro'),
		T_TIPO_DATA('OM109'  ,'Taladros grosor de 7 a 10 mm, hasta 25 mm de diámetros'),
		T_TIPO_DATA('OM110'  ,'Punto de luz sencillo'),
		T_TIPO_DATA('OM111'  ,'Doble punto de luz con doble interruptor'),
		T_TIPO_DATA('OM112'  ,'Punto de luz conmutado'),
		T_TIPO_DATA('OM113'  ,'Punto de luz cruzamiento'),
		T_TIPO_DATA('OM114'  ,'Punto de luz sencillo con regulación lumínica'),
		T_TIPO_DATA('OM115'  ,'Punto de luz conmutado con regulación lumínica'),
		T_TIPO_DATA('OM116'  ,'Punto de luz cruzamiento con regulación lumínica'),
		T_TIPO_DATA('OM117'  ,'Punto de luz conmutado con una base de enchufe'),
		T_TIPO_DATA('OM118'  ,'Punto de luz conmutado con dos bases de enchufe'),
		T_TIPO_DATA('OM119'  ,'Punto de luz cruzamiento con dos bases de enchufe'),
		T_TIPO_DATA('OM120'  ,'Punto de timbre'),
		T_TIPO_DATA('OM121'  ,'Toma de corriente de 10 A'),
		T_TIPO_DATA('OM122'  ,'Toma de corriente con toma de tierra lateral de 16 A'),
		T_TIPO_DATA('OM123'  ,'Toma de corriente con toma de tierra lateral de 20 A'),
		T_TIPO_DATA('OM124'  ,'Toma de corriente con toma de tierra lateral de 25 A'),
		T_TIPO_DATA('OM125'  ,'M lineal de 2x1,5m m²'),
		T_TIPO_DATA('OM126'  ,'M línea de 2 x 2,5 m m² + TT'),
		T_TIPO_DATA('OM127'  ,'M línea de 2 x 1,5 m m² + 2 x 2,5 m m² + TT'),
		T_TIPO_DATA('OM128'  ,'M lineal de 2x4m m²+TT'),
		T_TIPO_DATA('OM129'  ,'M línea de 2x6mni2+TT'),
		T_TIPO_DATA('OM130'  ,'Sustitución de interruptor, enchufe, timbre Mod. Simón 31 o similar'),
		T_TIPO_DATA('OM131'  ,'Sustitución de diferencial hasta 2 x 40 A 30 mA'),
		T_TIPO_DATA('OM132'  ,'Sustitución de diferencial de 2 x 63 A 30 mA'),
		T_TIPO_DATA('OM133'  ,'Sustitución de diferencial hasta 4 x 40 A 300 mA'),
		T_TIPO_DATA('OM134'  ,'Sustitución de diferencial de 4 x 63 A 300 mA'),
		T_TIPO_DATA('OM135'  ,'Sustitución de magnetotérmico de 2 x 25 A'),
		T_TIPO_DATA('OM136'  ,'Sustitución de magnetotérmico de 2 x 40'),
		T_TIPO_DATA('OM137'  ,'Sustitución de magnetotérmico de 2 x 50'),
		T_TIPO_DATA('OM138'  ,'Apertura/Descerraje de cerradura estándar o de seguridad media sin sustitución ni reposición de elementos.'),
		T_TIPO_DATA('CM-CER1'  ,'Sustitución de bombillo normal (Azbe, Tesa, Lince, Fiam, Ucem o similar) incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.'),
		T_TIPO_DATA('CM-CER2'  ,'Sustitución de bombillo de seguridad (Azbe, Tesa, Linceo similar) gama baja  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.'),
		T_TIPO_DATA('CM-CER3'  ,'Sustitución de bombillo de seguridad (Fac, Mia de Borjas, Iseo o similar) gama media  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.'),
		T_TIPO_DATA('CM-CER4'  ,'Sustitución de bombillo de seguridad (Potent Borjas, Cr Acoraz, Cr doble) gama alta  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.'),
		T_TIPO_DATA('CM-CER5'  ,'Sustitución de cerrojo (Fac, Lince, Ezcurra o similar)  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.'),
		T_TIPO_DATA('CM-CER6'  ,'Reparación de cerradura (sin aporte de piezas)'),
		T_TIPO_DATA('OM145'  ,'Sustitución de hoja de puerta de paso (solo mano de obra)'),
		T_TIPO_DATA('OM146'  ,'Sustitución de hoja de puerta corredera (solo mano de obra)'),
		T_TIPO_DATA('OM147'  ,'Sustitución de hoja de puerta blindada (solo mano de obra)'),
		T_TIPO_DATA('OM148'  ,'Sustitución de puerta acorazada (solo mano de obra)'),
		T_TIPO_DATA('OM149'  ,'Ajuste de puerta de paso'),
		T_TIPO_DATA('OM150'  ,'Ajuste de puerta corredera'),
		T_TIPO_DATA('OM151'  ,'Ajuste de puerta blindada'),
		T_TIPO_DATA('OM152'  ,'Ajuste de puerta acorazada'),
		T_TIPO_DATA('OM153'  ,'Descolgamiento de puerta de paso'),
		T_TIPO_DATA('OM154'  ,'Descolgamiento de puerta corredera'),
		T_TIPO_DATA('OM155'  ,'Descolgamiento de puerta blindada'),
		T_TIPO_DATA('OM156'  ,'Descolgamiento de puerta acorazada'),
		T_TIPO_DATA('OM157'  ,'Sustitución de cerradura puerta de paso'),
		T_TIPO_DATA('OM158'  ,'Sustitución de bisagras puerta de paso'),
		T_TIPO_DATA('OM159'  ,'Sustitución de manetas puerta de paso'),
		T_TIPO_DATA('OM160'  ,'Cepillado de puerta por roce'),
		T_TIPO_DATA('OM161'  ,'Ajuste y regulación de frente de armario'),
		T_TIPO_DATA('OM162'  ,'Sustituir puerta de armario (Sin material)'),
		T_TIPO_DATA('OM163'  ,'Sustitución de molduras metro lineal'),
		T_TIPO_DATA('OM164'  ,'Ajuste de puertas armarios cocina'),
		T_TIPO_DATA('OM165'  ,'Ajuste de muebles de cocina'),
		T_TIPO_DATA('OM166'  ,'Clavado y sellado de jambas (precio por puerta)'),
		T_TIPO_DATA('OM167'  ,'Preparación de suelo con pasta niveladora por m² espesor entre 5 mm-25 mm'),
		T_TIPO_DATA('OM168'  ,'Lijado y barnizado hasta 15 m²'),
		T_TIPO_DATA('OM169'  ,'Lijado y barnizado por m² adicional'),
		T_TIPO_DATA('OM170'  ,'M² parquet roble damas'),
		T_TIPO_DATA('OM171'  ,'M² parquet roble tablillas'),
		T_TIPO_DATA('OM172'  ,'M² parquet roble baldosa'),
		T_TIPO_DATA('OM173'  ,'M² tarima roble'),
		T_TIPO_DATA('OM174'  ,'M² parquet eucalipto damas'),
		T_TIPO_DATA('OM175'  ,'M² parquet eucalipto tablillas'),
		T_TIPO_DATA('OM176'  ,'M² parquet pino oregón'),
		T_TIPO_DATA('OM177'  ,'M² tarima pino viejo'),
		T_TIPO_DATA('OM178'  ,'MI rodapié aglomerado'),
		T_TIPO_DATA('OM179'  ,'MI rodapié macizo 7 cm'),
		T_TIPO_DATA('OM180'  ,'Ml rodapié macizo 10 cm'),
		T_TIPO_DATA('OM181'  ,'Ml barnizado de rodapié poliuretano'),
		T_TIPO_DATA('OM182'  ,'Hora de trabajo de Oficial electricista'),
		T_TIPO_DATA('OM183'  ,'Hora de trabajo de Oficial parquetista'),
		T_TIPO_DATA('OM184'  ,'Hora de trabajo de Oficial carpintero'),
		T_TIPO_DATA('OM185'  ,'Hora de trabajo de Oficial pintor'),
		T_TIPO_DATA('OM186'  ,'Hora de trabajo de Oficial albañil'),
		T_TIPO_DATA('OM187'  ,'Hora de trabajo de Oficial fontanero'),
		T_TIPO_DATA('OM188'  ,'Hora de trabajo de Oficial cerrajero'),
		T_TIPO_DATA('OM189'  ,'Hora de trabajo de Oficial frigorista'),
		T_TIPO_DATA('OM190'  ,'Hora de trabajo de Oficial calefactor'),
		T_TIPO_DATA('OM191'  ,'Hora de trabajo de Oficial polivalente'),
		T_TIPO_DATA('OM192'  ,'Hora de trabajo de Limpiador'),
		T_TIPO_DATA('OM193'  ,'Hora de trabajo de peón no cualificado'),
		T_TIPO_DATA('OM194'  ,'Hora de trabajo de Oficial polivalente (de 22:00 a 08:00 horas y festivos)'),
		T_TIPO_DATA('OM195'  ,'Hora de trabajo de Encargado'),
		T_TIPO_DATA('OM196'  ,'Hora de trabajo de Auxiliar Administrativo'),
		T_TIPO_DATA('OM197'  ,'Hora de trabajo de Oficial de 2ª'),
		T_TIPO_DATA('OM198'  ,'Hora de trabajo de Ayudante de oficio'),
		T_TIPO_DATA('OM199'  ,'Hora de trabajo de Peón especializado'),
		T_TIPO_DATA('OM200'  ,'Desplazamiento de camión de desatranco'),
		T_TIPO_DATA('OM201'  ,'Hora de trabajo de camión de desatranco'),
		T_TIPO_DATA('OM202'  ,'Hora de mano trabajo de cerrajería urgente'),
		T_TIPO_DATA('OM203'  ,'M² Desbroce de parcela con maquinaria. Gestión de residuos incluida'),
		T_TIPO_DATA('OM204'  ,'M² Desbroce manual de parcela/jardín. Gestión de residuos incluida '),
		T_TIPO_DATA('SOL1'  ,'Limpieza de parcela/solar para retirada de escombros u otros restos voluminosos, incluida retirada y gestión de restos a vertedero autorizado. Se deberá aportar justificación del volumen real retirado.'),
		T_TIPO_DATA('OM206'  ,'M² Aplicación de herbicida sistémico no selectivo junto con herbicida de post-emergencia'),
		T_TIPO_DATA('OM207'  ,'M² Poda, puntual y selectiva, manual, con todos los útiles necesarios. Gestión de residuos incluida'),
		T_TIPO_DATA('OM208'  ,'M Vallado con simple torsión hasta 2 m de altura, incluso postes de sujeción cada 3 metros. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos'),
		T_TIPO_DATA('OM209'  ,'M Vallado con bloque de hormigón, hasta una altura de 2 m enfoscado, con pilares cada 3m, maestreado y pintado en blanco. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos'),
		T_TIPO_DATA('OM210'  ,'Ud suministro e instalación puerta metálica de malla de acero galvanizado para acceso peatonal (0,8 - 1m) de paso, candado incluido. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos'),
		T_TIPO_DATA('OM211'  ,'Ud suministro e instalación puerta abatible de 3x2 m., candado incluido. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos'),
		T_TIPO_DATA('OM212'  ,'Ud Limpieza general del inmueble: retirada de basuras, restos de comida, etc… sin contenedor (únicamente bolsas). Gestión de residuos incluida. Hasta 1 m3'),
		T_TIPO_DATA('OM213'  ,'Ud Limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escombros, etc. (utilizando un contenedor de aprox 6 m3) Gestión de residuos incluida'),
		T_TIPO_DATA('OM214'  ,' Ud Contenedor adicional (6 m3) en limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escombros, etc. Gestión de residuos incluida'),
		T_TIPO_DATA('OM215'  ,'Ud Desinsectación contra todo tipo de insectos voladores o rastreros, incluido certificado. (Superficie hasta 400 m²)'),
		T_TIPO_DATA('SOL2'  ,'Ud Desratización con anticoagulantes, administrados mediante cebos, incluido certificado. (Superficie hasta 400 m²)'),
		T_TIPO_DATA('SOL3'  ,'Ud Desinfección contra hongos, virus y bacterias, incluido certificado. (Sup. Hasta 400 m²)'),
		T_TIPO_DATA('OM218'  ,'M² Reparación de humedades en fachada de unifamiliares'),
		T_TIPO_DATA('OM219'  ,'M² Reparación grietas en fachada de unifamiliares'),
		T_TIPO_DATA('OM220'  ,'M² Reparación de humedades en cubierta con impermeabilizante'),
		T_TIPO_DATA('OM221'  ,'M² Reparación grietas en cubierta con impermeabilizante'),
		T_TIPO_DATA('OTR2'  ,' PA Trámites Oficinas suministradoras'),
		T_TIPO_DATA('OTR1'  ,' PA Trámites Entidades Locales'),
		T_TIPO_DATA('BOL4'  ,'PA Obtención/Tramitación de Boletín Agua'),
		T_TIPO_DATA('BOL5'  ,'Emisión de proyecto y boletín de legalización de instalación de gas en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos '),
		T_TIPO_DATA('CED1'  ,'PA Obtención/Tramitación de Nueva cédula de habitabilidad'),
		T_TIPO_DATA('CED2'  ,'PA Obtención/Tramitación de Duplicado de LPO o Cédula'),
		T_TIPO_DATA('INF4'  ,'Hr Técnico en elaboración de informes o realización de gestiones'),
		T_TIPO_DATA('OM229'  ,'Ud Repaso de instalación eléctrica y telecomunicaciones de vivienda NO incluida la colocación de las tapas de cajas y mecanismos faltantes'),
		T_TIPO_DATA('OM230'  ,'Ud Colocación de caja general de protección de la vivienda según normativa de instalación, totalmente terminada'),
		T_TIPO_DATA('OM231'  ,'Ud Suministro y colocación de timbre. Con instalación de cableado'),
		T_TIPO_DATA('OM232'  ,'Ud Instalación de toma de corriente para calentador, incluido cableado, mecanismo de superficie o empotrado y canaleta'),
		T_TIPO_DATA('OM233'  ,'Calentador de gas de agua interior mural, vertical para 6l/min con tiro natural, colocado y probado. Incluyendo boletín y legalización'),
		T_TIPO_DATA('OM234'  ,'Ud Suministro y colocación Termo eléctrico 50 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado'),
		T_TIPO_DATA('OM235'  ,'Ud Suministro y colocación Termo eléctrico 100 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado '),
		T_TIPO_DATA('OM236'  ,'Ud Instalación de salida de humos calentador, de chapa de acero de 150mm, sin incluir perforación de fachada, aunque sí su sellado y resolución de encuentros'),
		T_TIPO_DATA('OM237'  ,'Ud Instalación fontanería para calentador'),
		T_TIPO_DATA('OM238'  ,'Ud Sustitución de llave de paso '),
		T_TIPO_DATA('OM239'  ,'Ud Suministro e instalación de fregadero de cocina metálico, de hasta 90 cm de anchura, con senos y/o escurridor'),
		T_TIPO_DATA('OM240'  ,'Ud Suministro e instalación Rejilla de baño'),
		T_TIPO_DATA('OM241'  ,'Ud Suministro e instalación de bidet cerámico color estándar a elegir, sin incluir grifería'),
		T_TIPO_DATA('OM242'  ,'Suministro e instalación de lavabo cerámico color estándar a elegir de un seno y sustentado sobre pie cerámico, sin incluir grifería'),
		T_TIPO_DATA('OM243'  ,'Ud Suministro e instalación de inodoro cerámico color estándar a elegir, con tanque bajo'),
		T_TIPO_DATA('OM244'  ,'Suministro e instalación de tapa de inodoro'),
		T_TIPO_DATA('OM245'  ,'Ud Suministro e instalación de descarga de inodoro'),
		T_TIPO_DATA('OM246'  ,'Ud suministro de llave magnética codificada'),
		T_TIPO_DATA('OM247'  ,'Ud suministro de mando de garaje codificado '),
		T_TIPO_DATA('OM248'  ,'M² Recolocación de placas de escayola desmontable con perfiles, situados a una altura de hasta 4m '),
		T_TIPO_DATA('OM249'  ,' M² Recolocación de placas de escayola desmontable sin perfiles, situados a una altura de hasta 4m '),
		T_TIPO_DATA('OM250'  ,'Ud Revisión de la instalación de gas de vivienda'),
		T_TIPO_DATA('OM251'  ,'Ud Suministro e instalación de caldera de condensación de gas de vivienda, incluyendo la instalación de ventilación, el boletín y la legalización.'),
		T_TIPO_DATA('OM252'  ,'Suministro e instalación de puerta antiocupa homologada cumpliendo normativa europea y suministrada igualmente por fabricante competente para emitir su certificado de idoneidad'),
		T_TIPO_DATA('OM253'  ,'Tapiado con fábrica de ladrillo de 1/2 pie'),
		T_TIPO_DATA('OM254'  ,'Tapiado con fábrica de bloque de hormigón armado'),
		T_TIPO_DATA('OM255'  ,'Tapiado con malla armada plastificada Pecafil, fabricada por Max Frank GmbH y Co. KG, o similar'),
		T_TIPO_DATA('OM256'  ,'Solado o alicatado de elementos de gran formato y/o porcelánicos (sin material)'),
		T_TIPO_DATA('OM257'  ,'Solado o alicatado de piedra natural incluyendo el material pétreo, todo el resto de material y trabajos auxiliares'),
		T_TIPO_DATA('OM258'  ,'Piezas pétreas en fachada mediante anclajes de acero inox'),
		T_TIPO_DATA('OM259'  ,'Cartelería "Prohibido el paso a todo personal ajeno a la obra. Precaución con los menores"'),
		T_TIPO_DATA('OM260'  ,'Suministro e instalación de detector de presencia para instalación eléctrica'),
		T_TIPO_DATA('OM261'  ,'Cartelería de instalación de protección contra incendios (salidas de evacuación, extintores, etc.)'),
		T_TIPO_DATA('OM262'  ,'Suministro e instalación de boca de incendio equipada 25 m incluyendo señalización(s/ CTE)'),
		T_TIPO_DATA('OM263'  ,'Suministro e instalación de boca de incendio equipada 45 m incluyendo señalización(s/ CTE)'),
		T_TIPO_DATA('OM264'  ,'Suministro y sustitución de manguera en BIE de 25m (incluyendo material)'),
		T_TIPO_DATA('OM265'  ,'Suministro y sustitución de manguera en BIE de 45m (incluyendo material)'),
		T_TIPO_DATA('OM266'  ,'Suministro e instalación de puerta EF 30 (s/ CTE), 90x210 totalmente rematada y terminada'),
		T_TIPO_DATA('OM267'  ,'Suministro e instalación de puerta EF 60 (s/ CTE), 90x210 totalmente rematada y terminada'),
		T_TIPO_DATA('OM268'  ,'Suministro e instalación de luminaria de emergencia (s/ CTE)'),
		T_TIPO_DATA('OM269'  ,'Suministro y colocación de suelos formado por lamas machihembradas/encoladas de aspecto similar al parquet flotante con un laminado plástico estratificado o un recubrimiento melamínico'),
		T_TIPO_DATA('OM270'  ,'Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen'),
		T_TIPO_DATA('OM271'  ,'Impermeabilización de cubierta plana asfáltica, no incluyendo retirada ni reposición de material de protección de la lámina. Incluyendo p.p. de remates de desagües, esquinas y cualquier otro elemento que interrumpa la tela'),
		T_TIPO_DATA('OM272'  ,'Suministro e instalación de extintor de incendios portátil de eficacia 21A -113B incluyendo soporte y señalización (s/ CTE)'),
		T_TIPO_DATA('OM273'  ,'Impermeabilización de cubierta plana de PVC, no incluyendo retirada ni reposición de material de protección de la lámina. Incluyendo p.p. de remates de desagües, esquinas y cualquier otro elemento que interrumpa la membrana'),
		T_TIPO_DATA('OM274'  ,'Retirada de teja cerámica o de hormigón, reparación de la impermeabilización y reposición posterior de la teja, con recibido si es necesario (sin aporte de material)'),
		T_TIPO_DATA('OM275'  ,'Drenaje de trasdós de muro mediante excavación, colocación de lámina de drenaje, instalación de tubo dren y relleno posterior con grava según CTE, hasta 3 m de profundidad'),
		T_TIPO_DATA('OM276'  ,'Suministro e instalación mediante anclajes epoxi de rejas de protección en ventanas/ puertas, realizadas con hierro tratado contra la corrosión'),
		T_TIPO_DATA('OM277'  ,'Revisión, legalización y puesta en marcha de ascensor de hasta 4 alturas'),
		T_TIPO_DATA('OM278'  ,'Revisión, legalización y puesta en marcha de ascensor de hasta 9 alturas'),
		T_TIPO_DATA('OM279'  ,'Limpieza de sumidero en cubierta / patio / garaje'),
		T_TIPO_DATA('OM280'  ,'Limpieza de arqueta de cualquier tipo'),
		T_TIPO_DATA('OM281'  ,'Reparación de acera mediante elemento continuo de hormigón pulido / impreso'),
		T_TIPO_DATA('OM282'  ,'Reparación de acera mediante elemento discontinuo de baldosa / adoquín'),
		T_TIPO_DATA('OM283'  ,'Limpieza y desatranco de canaletas e cubierta / patio / garaje con retirada de escombro a vertedero'),
		T_TIPO_DATA('OM284'  ,'Limpieza de canalones de cualquier material y sección'),
		T_TIPO_DATA('OM285'  ,'Suministro e instalación de grifería monomando de cocina de acero, para colocar empotrado en fregadero'),
		T_TIPO_DATA('OM286'  ,'Suministro e instalación de grifería monomando de lavabo/bidet de acero'),
		T_TIPO_DATA('OM287'  ,'Suministro e instalación de grifería monomando de bañera de acero, con doble salida a grifo y flexo. Incluyendo manguera y ducha'),
		T_TIPO_DATA('OM288'  ,'Visita para verificación de activo'),
		T_TIPO_DATA('OM289'  ,'Tala de árbol < 6 m de altura sacando el tocón'),
		T_TIPO_DATA('OM290'  ,'Tala de árbol < 6 m de altura sin sacar el tocón'),
		T_TIPO_DATA('OM291'  ,'Tala de árbol 10/15m de altura sacando el tocón'),
		T_TIPO_DATA('OM292'  ,'Tala de árbol 10/15m de altura sin sacar el tocón'),
		T_TIPO_DATA('OM293'  ,'Tala de árbol 6/10m de altura sacando el tocón'),
		T_TIPO_DATA('OM294'  ,'Tala de árbol 6/10m de altura sin sacar el tocón'),
		T_TIPO_DATA('OM295'  ,'Aislamiento espuma poliuret. 4 cm proyectada'),
		T_TIPO_DATA('OM296'  ,'Excavación tierras + transporte a vertedero'),
		T_TIPO_DATA('OM297'  ,'Relleno de zanjas con arena'),
		T_TIPO_DATA('OM298'  ,'Terraplenado con tierras adecuadas 95% PM'),
		T_TIPO_DATA('OM299'  ,'Terraplenado con zahorra artificial 95% PM'),
		T_TIPO_DATA('OM300'  ,'Poda de árbol con cesta de 15 a 20 m de altura'),
		T_TIPO_DATA('OM301'  ,'Poda de árbol con cesta de 6 a 10 m de altura'),
		T_TIPO_DATA('OM302'  ,'Poda de árbol con trepa de 15 a 20 m de altura'),
		T_TIPO_DATA('OM303'  ,'Derribo de cielo raso + Carga escombros'),
		T_TIPO_DATA('OM304'  ,'Suministro de copia de llave de seguridad intermedia (llave de puntos o similar)'),
		T_TIPO_DATA('OM305'  ,'Sustitución de bombillo de buzón'),
		T_TIPO_DATA('OM306'  ,'Suministro e instalación de escudo de seguridad media'),
		T_TIPO_DATA('OM307'  ,'Suministro e instalación de candado, incluida cadena hasta 0,5mts en caso necesario y descerraje de candado existente si fuere necesario'),
		T_TIPO_DATA('OM308'  ,'Desmontaje y retirada de puerta antiocupa.'),
		T_TIPO_DATA('OM309'  ,'Suministro e instalación de juego de tapetas gama media en acabado lacado blanco, para las dos caras de una puerta'),
		T_TIPO_DATA('OM310'  ,'Suministro e instalación de Hoja de Puerta abatible interior de hasta 100 cms gama media en acabado lacado blanco, incluyendo: puerta, bisagras y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM311'  ,'Suministro e instalación de Puerta abatible block interior de hasta 100 cms gama media en acabado lacado blanco, incluyendo: puerta, bisagras, batientes, tapetas y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM312'  ,'Suministro e instalación de Puerta abatible de Entrada en block de hasta 100 cms BLINDADA (gama media) en acabado de melamina, incluyendo: puerta, bisagras, batientes, tapetas, cerradura, pomo y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM313'  ,'ML. Sellado de carpintería de aluminio con encuentros de fabrica de fachada y albardillas'),
		T_TIPO_DATA('OM314'  ,'UD. Ajuste o reparación de cierres de carpintería metálica corredera. Ventana o puerta'),
		T_TIPO_DATA('OM315'  ,'UD. Ajuste o reparación de cierres de carpintería metálica abatible. Ventana o puerta'),
		T_TIPO_DATA('OM316'  ,'Suministro e instalación de vidrio con cámara de 4/8/4 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
		T_TIPO_DATA('OM317'  ,'Desmontaje y retirada de Parquet flotante, incluso zócalo, capas inferiores de aislamiento y pasos de puerta existentes, incluyendo gestión de residuos a vertedero autorizado'),
		T_TIPO_DATA('OM318'  ,'Limpieza de terraza. Incluidos los imbornales, sumideros y elementos existentes hasta 15m²'),
		T_TIPO_DATA('OM319'  ,'Limpieza general de piscina de Sup. <=35 m2  (Incluido vaciado)'),
		T_TIPO_DATA('OM320'  ,'Limpieza general de piscina de Sup. De >35 m2  (Incluido vaciado)'),
		T_TIPO_DATA('OM321'  ,'Suministro y colocación de Valla trasladable de obra o similar de 3,50x2,00 m, formada por panel de malla electrosoldada y postes verticales, acabado galvanizado, colocados sobre bases prefabricadas de hormigón, con malla de ocultación colocada sobre la valla, incluidos todos los trabajos necesarios para su completa y correcta ejecución.'),
		T_TIPO_DATA('OM322'  ,'Vallado de 2m de altura, compuesto por paneles opacos de chapa perfilada nervada de acero UNE-EN 10346 S320 GD galvanizado de 0,6 mm espesor y 30 mm altura de cresta, incluidos postes de sujeción cada 2ml.'),
		T_TIPO_DATA('OM323'  ,'Suministro y colocación de cercado mediante chapa plegada o similar en acabado galvanizado y altura hasta 200 cms, con los postes y tensores necesarios en función de la geometría del solar, incluidos los pies, anclajes y/o empotramientos necesarios para su completa y correcta ejecución.'),
		T_TIPO_DATA('OM324'  ,'Ejecución de riostra de cimentación, para posterior ejecución de muro de vallado de obra, de 40 cms de ancho y 60 cms de profundidad armada con 4Ø12 y estribos de Ø10 cada 30 cms, con hormigón HA-25-B-20-IIA, incluso excavación en terreno blando. Incluidos todos los medios auxiliares necesarios, completamente ejecutada y retirada de restos de excavación.'),
		T_TIPO_DATA('OM325'  ,'Dirección Facultativa 10.000 - 60.000 € '),
		T_TIPO_DATA('OM326'  ,'Dirección Facultativa > 60.000 €   '),
		T_TIPO_DATA('OTR3'  ,'Redacción de proyecto técnico para su visado (sin tasas de visado) módulo mínimo'),
		T_TIPO_DATA('OTR4'  ,'Redacción de proyecto técnico para su visado (sin tasas de visado)'),
		T_TIPO_DATA('OTR5'  ,'Proyecto y dirección de obra (un solo técnico) 10.000 - 60.000 €'),
		T_TIPO_DATA('OTR6'  ,'Proyecto y dirección de obra (un solo técnico) >60.000 €'),
		T_TIPO_DATA('OM331'  ,'Coordinación de Seguridad y Salud Módulo mínimo'),
		T_TIPO_DATA('OM332'  ,'Coordinación de Seguridad y Salud > 30.000 €'),
		T_TIPO_DATA('OTR7'  ,'Levantamiento topográfico (Día de trabajo de campo hasta 8h Desp < 100km)'),
		T_TIPO_DATA('OM334'  ,'Servicio mínimo de horas de camión de desatranco, incluidos los operarios necesarios para la ejecución de los trabajos. Partida complementaria al desplazamiento del camión (a esta partida falta añadirle las horas de servicio).'),
		T_TIPO_DATA('OM335'  ,'Servicio mínimo para Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen.'),
		T_TIPO_DATA('OM336'  ,'Suministro e instalación de extractora de baño o espacio cerrado con necesidad de ventilación i/instalación eléctrica,'),
		T_TIPO_DATA('OM337'  ,'Suministro e instalación de flexo de ducha de hasta 2m.'),
		T_TIPO_DATA('OM338'  ,'Suministro e instalación de conjunto flexo y alcachofa de ducha o bañera.'),
		T_TIPO_DATA('OM339'  ,'Sellado de perímetro de bañera o plato de ducha con silicona anti moho al acido.'),
		T_TIPO_DATA('OM340'  ,'Ud Instalación fontanería para termo. Dejando instalación lista para colocación.'),
		T_TIPO_DATA('OM341'  ,'Levantado y posterior recolocación de mampara de ducha o bañera, incluidos todos los trabajos necesarios para la correcta ejecución. Se contabilizará cada uno de los elementos. Se incluye el sellado final del elemento.'),
		T_TIPO_DATA('OM342'  ,'Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 80 m2 o 2 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros.'),
		T_TIPO_DATA('OM343'  ,'Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 100 m2 o 3 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros.'),
		T_TIPO_DATA('OM344'  ,'Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 120 m2 o 4 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros'),
		T_TIPO_DATA('OM345'  ,'Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 150 m2 o 5 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros. Para mayores superficies o habitaciones se realizará valoración específica del inmueble.'),
		T_TIPO_DATA('OM346'  ,'Suministro e instalación de placa cocción de gas de 60x60 cms, incluidos todos los trabajos para la correcta ejecución y conexionado a la instalación existente. Quedan expresamente excluidos los trabajos de adaptación de la instalación de gas a normativa en caso de ser necesario.'),
		T_TIPO_DATA('OM347'  ,'Suministro e instalación de HORNO GAMA MEDIA E INSTALACIÓN ESTANDAR.'),
		T_TIPO_DATA('OM348'  ,'Suministro e instalación de placa de inducción de 60x60 cms, incluidos todos los trabajos para la correcta ejecución'),
		T_TIPO_DATA('OM349'  ,'Suministro y colocación de amueblamiento de cocina gama baja-económica, compuesta por 3,5 m de muebles bajos con zócalo inferior y un módulo de muebles altos de 80 cm, acabado laminado, cantos verticales post formados. Incluso zócalo inferior, y remates a juego con el acabado, guías de rodamientos metálicos y tiradores en puertas, incluso piezas especiales de desagües de electrodomésticos. Totalmente montado, sin incluir encimera, electrodomésticos ni fregadero. '),
		T_TIPO_DATA('OM350'  ,'Ud Revisión y prueba de instalación eléctrica, telecomunicaciones y video portero en vivienda, incluso rotulación de cuadro eléctrico sin considerar elementos de protección o mecanismos que pudieran faltar.'),
		T_TIPO_DATA('BOL8'  ,'Emisión de Proyecto y Boletín de legalización de instalación eléctrica en local comercial superior a 1500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.'),
		T_TIPO_DATA('OM352'  ,'Anulación y Retirada de Instalación Eléctrica Pre-existente, consistente en: Desconexión permanente de todas las líneas del cuadro eléctrico, retirada del cableado que pueda entorpecer para la posterior conexión de una nueva instalación al cuadro eléctrico, retirada de mecanismos y embellecedores de interruptores y bases de enchufes, y tapado mediante pasta de yeso, mortero o tapas registrables en función del acabado de los paramentos. Se incluye retirada de restos a vertedero autorizado. Vivienda hasta 120 m2'),
		T_TIPO_DATA('OM353'  ,'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda hasta 120 m2'),
		T_TIPO_DATA('OM354'  ,'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda entre 121 y 200 m2'),
		T_TIPO_DATA('OM355'  ,'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda hasta 120 m2'),
		T_TIPO_DATA('OM356'  ,'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda entre 121 y 200 m2'),
		T_TIPO_DATA('OM357'  ,'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda hasta 120 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico'),
		T_TIPO_DATA('OM358'  ,'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda entre 121 y 200 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico'),
		T_TIPO_DATA('OM359'  ,'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda hasta 120 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico'),
		T_TIPO_DATA('OM360'  ,'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda entre 121 y 200 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico'),
		T_TIPO_DATA('OM361'  ,'ML. Suministro y colocación de rodapié cerámico incluido material. '),
		T_TIPO_DATA('OM362'  ,'Ml. Rejuntado o sellado de rodapié con mortero hidrófugo o silicona resistencia UV '),
		T_TIPO_DATA('OM363'  ,'Ml. Sellado de juntas con mortero hidrófugo'),
		T_TIPO_DATA('OM364'  ,'M2. Aplicación de lechada y llagueado de material cerámico en paramentos verticales.'),
		T_TIPO_DATA('OM365'  ,'Derribo de cielo raso + Carga escombros'),
		T_TIPO_DATA('OM366'  ,'Apertura de cata en falso techo continuo/tabique/pared maestra/suelo o similar, incluso p/p de replanteo, cortes, limpieza, acopio, retirada y carga manual de escombros sobre vehículo o contenedor. (máx 3m2). Aplicable para destapiado de puertas y ventanas.'),
		T_TIPO_DATA('OM367'  ,'Suministro e instalación de teja árabe, incluidos materiales de fijación, remate y sellado del mismo en caso de ser necesario para la completa y correcta ejecución. Partida mínima de ejecución de 1 m2.'),
		T_TIPO_DATA('OM368'  ,'Suministro e instalación de teja de hormigón, incluidos materiales de fijación, remate y sellado del mismo en caso de ser necesario para la completa y correcta ejecución. Partida mínima de ejecución de 1 m2.'),
		T_TIPO_DATA('BOL1'  ,'Emisión de proyecto y boletín de legalización de instalación eléctrica en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos'),
		T_TIPO_DATA('BOL2'  ,'Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos'),
		T_TIPO_DATA('BOL3'  ,'Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 1500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos'),
		T_TIPO_DATA('OM372'  ,'Suministro e instalación de campana extractora de cocina hasta 16m² de acero inoxidable visto de calidad media alta>500m³/h'),
		T_TIPO_DATA('OM373'  ,'Suministro e instalación de campana extractora de cocina hasta 10m² de acero inoxidable visto de calidad media alta>500m³/h'),
		T_TIPO_DATA('OM374'  ,' Suministro e instalación de campana extractora de cocina hasta 10m²empotrable de calidad media baja>500m³/h'),
		T_TIPO_DATA('OM375'  ,'Suministro e instalación de encimera de cocina de calidad alta de silestone con acabado pulido o similar, color a elegir '),
		T_TIPO_DATA('OM376'  ,'Suministro e instalación de encimera de cocina de calidad media de granito nacional pulido o similar'),
		T_TIPO_DATA('OM377'  ,'Suministro e instalación de encimera de cocina de calidad económica con acabado en tablero, incluyendo copas y remates de extremos, ángulos y esquinas'),
		T_TIPO_DATA('OM378'  ,'Ud Revisión de instalación fontanería en vivienda, incluyendo pruebas de presión, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente'),
		T_TIPO_DATA('OM379'  ,' Ud Revisión de instalación fontanería en local comercial de hasta 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente'),
		T_TIPO_DATA('OM380'  ,'Ud Revisión de instalación fontanería en local comercial de más de 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente'),
		T_TIPO_DATA('OM381'  ,'Ud Suministro y colocación Termo eléctrico 75 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado'),
		T_TIPO_DATA('OM382'  ,'Suministro e instalación de bañera de chapa lacada de hasta 160 cm de longitud, sin incluir grifería'),
		T_TIPO_DATA('OM383'  ,' Suministro e instalación de bañera acrílica de hasta 160 cm de longitud, sin incluir grifería'),
		T_TIPO_DATA('OM384'  ,'Suministro e instalación de plato de ducha cerámico de hasta 90x90 cm, sin incluir grifería '),
		T_TIPO_DATA('OM385'  ,'Suministro e instalación de plato de ducha cerámico mayor de 90x90 cm, sin incluir grifería'),
		T_TIPO_DATA('OM386'  ,'Suministro e instalación de plato de ducha acrílico de hasta 90x90 cm, sin incluir grifería'),
		T_TIPO_DATA('OM387'  ,'Suministro e instalación de plato de ducha acrílico mayor de 90x90 cm, sin incluir grifería'),
		T_TIPO_DATA('OM388'  ,'Reparación de persiana hasta 1 m² '),
		T_TIPO_DATA('OM389'  ,'Reparación de persiana hasta 2 m² '),
		T_TIPO_DATA('OM390'  ,'Reparación de persiana hasta 4 m² '),
		T_TIPO_DATA('CEE1'  ,'Vivienda suelta con documentación del activo'),
		T_TIPO_DATA('CEE10'  ,'Promociones (viviendas integradas en una promoción) con documentación del activo'),
		T_TIPO_DATA('CEE11'  ,'Promociones (viviendas integradas en una promoción) sin documentación del activo'),
		T_TIPO_DATA('CEE12'  ,'Promociones (viviendas integradas en una promoción) sin documentación del activo'),
		T_TIPO_DATA('CEE13'  ,'Promociones (viviendas integradas en una promoción) sin documentación del activo'),
		T_TIPO_DATA('CEE14'  ,'Promociones (viviendas integradas en una promoción) sin documentación del activo'),
		T_TIPO_DATA('CEE15'  ,'Terciario (local comercial y oficina) con documentación del activo'),
		T_TIPO_DATA('CEE16'  ,'Terciario (local comercial y oficina) con documentación del activo'),
		T_TIPO_DATA('CEE17'  ,'Terciario (local comercial y oficina) con documentación del activo'),
		T_TIPO_DATA('CEE18'  ,'Terciario (local comercial y oficina) sin documentación del activo'),
		T_TIPO_DATA('CEE19'  ,'Terciario (local comercial y oficina) sin documentación del activo'),
		T_TIPO_DATA('CEE2'  ,'Vivienda suelta con documentación del activo'),
		T_TIPO_DATA('CEE20'  ,'Terciario (local comercial y oficina) sin documentación del activo'),
		T_TIPO_DATA('CEE3'  ,'Vivienda suelta con documentación del activo'),
		T_TIPO_DATA('CEE4'  ,'Vivienda suelta sin documentación del activo'),
		T_TIPO_DATA('CEE5'  ,'Vivienda suelta sin documentación del activo'),
		T_TIPO_DATA('CEE6'  ,'Vivienda suelta sin documentación del activo'),
		T_TIPO_DATA('CEE7'  ,'Promociones (viviendas integradas en una promoción) con documentación del activo'),
		T_TIPO_DATA('CEE8'  ,'Promociones (viviendas integradas en una promoción) con documentación del activo'),
		T_TIPO_DATA('CEE9'  ,'Promociones (viviendas integradas en una promoción) con documentación del activo'),
		T_TIPO_DATA('AP-VACI-LIMP-CER1'  ,'INFORME DE ESTADO + REP.FOTOGRAFICO + CAMBIO CERRADURA + LIMPIEZA + PINTURA'),
		T_TIPO_DATA('AP-VACI-LIMP-CER2'  ,'INFORME DE ESTADO + REP.FOTOGRAFICO + CAMBIO + CERRADURA + LIMPIEZA BÁSICA + VACIADO 5M3'),
		T_TIPO_DATA('AP-VACI-LIMP-CER3'  ,'INFORME DE ESTADO + REP.FOTOGRAFICO + CAMBIO + CERRADURA + LIMPIEZA BÁSICA'),
		T_TIPO_DATA('AP-VACI-LIMP-CER4'  ,'COMPROBACIÓN CERRADURA + INFORME DE ESTADO + I. COMERCIAL')

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
          
          /*DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TTF_TIPO_TARIFA '||
                    'SET DD_TTF_DESCRIPCION = '''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),1,100)||''''|| 
					', DD_TTF_DESCRIPCION_LARGA = '''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),1,250)||''''||
					', USUARIOMODIFICAR = '||V_USU_MODIFICAR||' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;*/
          DBMS_OUTPUT.PUT_LINE('[INFO]: CODIGO '''||TRIM(V_TMP_TIPO_DATA(1))||''' YA EXISTE');
          
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
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),1,100)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),1,250)||''', 0, '||V_USU_MODIFICAR||' ,SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
	  V_COUNT_INSERT := V_COUNT_INSERT + 1;
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||V_COUNT_INSERT||' registros en la tabla DD_TTF_TIPO_TARIFA');
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
