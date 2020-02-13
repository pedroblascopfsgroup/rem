--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6411
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CFT_CONFIG_TARIFA los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
    V_NUM NUMBER(16); -- Vble. auxiliar para almacenar el número de registros
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-6411'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1024);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	TIPO_TARIFA_CODIGO | TIPO_TARUIFA_DESCRIPCION | TIPO_TRABAJO_DESCRIPCIÓN | TIPO_SUBTRABAJO_DESCRIPCIÓN | PRECIO_UNITARIO | UNIDAD_MEDIDA

T_TIPO_DATA( 'OM249', ' M² Recolocación de placas de escayola desmontable sin perfiles, situados a una altura de hasta 4m ', 'Actuación técnica', 'Obra menor tarificada', '5,6705', '€/m2' ),
T_TIPO_DATA( 'VER1', 'Verificación y localización de avería descubriendo (máximo 2 horas)', 'Actuación técnica', 'Verificación de averías', '57,56073', '€/ud' ),
T_TIPO_DATA( 'OM383', ' Suministro e instalación de bañera acrílica de hasta 160 cm de longitud, sin incluir grifería', 'Actuación técnica', 'Obra menor tarificada', '184,0335', '€/ud' ),
T_TIPO_DATA( 'OM374', ' Suministro e instalación de campana extractora de cocina hasta 10m²empotrable de calidad media baja>500m³/h', 'Actuación técnica', 'Obra menor tarificada', '300', '€/ud' ),
T_TIPO_DATA( 'OM214', ' Ud Contenedor adicional (6 m3) en limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escombros, etc. Gestión de residuos incluida', 'Actuación técnica', 'Limpieza', '120,365', '€/ud' ),
T_TIPO_DATA( 'OM379', ' Ud Revisión de instalación fontanería en local comercial de hasta 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente', 'Actuación técnica', 'Obra menor tarificada', '210,324', '€/ud' ),
T_TIPO_DATA( 'OM1', ' Verificación y localización de avería ', 'Actuación técnica', 'Obra menor tarificada', '34,65', '€/h' ),
T_TIPO_DATA( 'OM295', 'Aislamiento espuma poliuret. 4 cm proyectada', 'Actuación técnica', 'Obra menor tarificada', '7,43351', '€/m2' ),
T_TIPO_DATA( 'OM165', 'Ajuste de muebles de cocina', 'Actuación técnica', 'Obra menor tarificada', '30,90938', '€/ud' ),
T_TIPO_DATA( 'OM152', 'Ajuste de puerta acorazada', 'Actuación técnica', 'Obra menor tarificada', '47,68375', '€/ud' ),
T_TIPO_DATA( 'OM151', 'Ajuste de puerta blindada', 'Actuación técnica', 'Obra menor tarificada', '39,7966', '€/ud' ),
T_TIPO_DATA( 'OM150', 'Ajuste de puerta corredera', 'Actuación técnica', 'Obra menor tarificada', '31,1362', '€/ud' ),
T_TIPO_DATA( 'OM149', 'Ajuste de puerta de paso', 'Actuación técnica', 'Obra menor tarificada', '24,9502', '€/ud' ),
T_TIPO_DATA( 'OM164', 'Ajuste de puertas armarios cocina', 'Actuación técnica', 'Obra menor tarificada', '30,90938', '€/ud' ),
T_TIPO_DATA( 'OM161', 'Ajuste y regulación de frente de armario', 'Actuación técnica', 'Obra menor tarificada', '27,20809', '€/ud' ),
T_TIPO_DATA( 'OM352', 'Anulación y Retirada de Instalación Eléctrica Pre-existente, consistente en: Desconexión permanente de todas las líneas del cuadro eléctrico, retirada del cableado que pueda entorpecer para la posterior conexión de una nueva instalación al cuadro eléctrico, retirada de mecanismos y embellecedores de interruptores y bases de enchufes, y tapado mediante pasta de yeso, mortero o tapas registrables en función del acabado de los paramentos. Se incluye retirada de restos a vertedero autorizado. Vivienda hasta 120 m2', 'Actuación técnica', 'Obra menor tarificada', '150', '€/ud' ),
T_TIPO_DATA( 'OM366', 'Apertura de cata en falso techo continuo/tabique/pared maestra/suelo o similar, incluso p/p de replanteo, cortes, limpieza, acopio, retirada y carga manual de escombros sobre vehículo o contenedor. (máx 3m2). Aplicable para destapiado de puertas y ventanas.', 'Actuación técnica', 'Limpieza', '33,51', '€/ud' ),
T_TIPO_DATA( 'OM138', 'Apertura/Descerraje de cerradura estándar o de seguridad media sin sustitución ni reposición de elementos.', 'Actuación técnica', 'Obra menor tarificada', '42,271', '€/ud' ),
T_TIPO_DATA( 'OM270', 'Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen', 'Actuación técnica', 'Obra menor tarificada', '19,3828', '€/ml' ),
T_TIPO_DATA( 'OM233', 'Calentador de gas de agua interior mural, vertical para 6l/min con tiro natural, colocado y probado. Incluyendo boletín y legalización', 'Actuación técnica', 'Obra menor tarificada', '355,2', '€/ud' ),
T_TIPO_DATA( 'OM259', 'Cartelería "Prohibido el paso a todo personal ajeno a la obra. Precaución con los menores"', 'Actuación técnica', 'Obra menor tarificada', '14,1173333333333', '€/ud' ),
T_TIPO_DATA( 'OM261', 'Cartelería de instalación de protección contra incendios (salidas de evacuación, extintores, etc.)', 'Actuación técnica', 'Obra menor tarificada', '8,29955', '€/ud' ),
T_TIPO_DATA( 'OM160', 'Cepillado de puerta por roce', 'Actuación técnica', 'Obra menor tarificada', '18,7642', '€/ud' ),
T_TIPO_DATA( 'OM166', 'Clavado y sellado de jambas (precio por puerta)', 'Actuación técnica', 'Obra menor tarificada', '22,7851', '€/ud' ),
T_TIPO_DATA( 'OM32', 'Colocación de gebo 1 unidad hasta 1/2 pulgada', 'Actuación técnica', 'Obra menor tarificada', '23,6', '€/ud' ),
T_TIPO_DATA( 'OM33', 'Colocación de gebo 1 unidad hasta 3/4 pulgada', 'Actuación técnica', 'Obra menor tarificada', '29,6', '€/ud' ),
T_TIPO_DATA( 'OM94', 'Composición con vidrio impreso climalit o similar 4+6+4  m²)', 'Actuación técnica', 'Obra menor tarificada', '84,63479', '€/m2' ),
T_TIPO_DATA( 'OM91', 'Composición incoloro climalit o similar 4+6+4 (m²)', 'Actuación técnica', 'Obra menor tarificada', '67,015', '€/m2' ),
T_TIPO_DATA( 'OM92', 'Composición incoloro climalit o similar 5+6+4 (m²)', 'Actuación técnica', 'Obra menor tarificada', '86,8102', '€/m2' ),
T_TIPO_DATA( 'OM93', 'Composición incoloro climalit o similar 6+6+4 (m²)', 'Actuación técnica', 'Obra menor tarificada', '94,44991', '€/m2' ),
T_TIPO_DATA( 'OM332', 'Coordinación de Seguridad y Salud > 30.000 €', 'Actuación técnica', 'Obra menor tarificada', '0,0115', '%PEM' ),
T_TIPO_DATA( 'OM331', 'Coordinación de Seguridad y Salud Módulo mínimo', 'Actuación técnica', 'Obra menor tarificada', '250', '€/ud' ),
T_TIPO_DATA( 'OM303', 'Derribo de cielo raso + Carga escombros', 'Actuación técnica', 'Obra menor tarificada', '8,248', '€/m2' ),
T_TIPO_DATA( 'OM365', 'Derribo de cielo raso + Carga escombros', 'Actuación técnica', 'Obra menor tarificada', '8,248', '€/m2' ),
T_TIPO_DATA( 'OM156', 'Descolgamiento de puerta acorazada', 'Actuación técnica', 'Obra menor tarificada', '50,61179', '€/ud' ),
T_TIPO_DATA( 'OM155', 'Descolgamiento de puerta blindada', 'Actuación técnica', 'Obra menor tarificada', '41,24', '€/ud' ),
T_TIPO_DATA( 'OM154', 'Descolgamiento de puerta corredera', 'Actuación técnica', 'Obra menor tarificada', '30,93', '€/ud' ),
T_TIPO_DATA( 'OM153', 'Descolgamiento de puerta de paso', 'Actuación técnica', 'Obra menor tarificada', '25,775', '€/ud' ),
T_TIPO_DATA( 'OM35', 'Desmontaje y montaje de sanitarios (lavabo, bidet e inodoro)', 'Actuación técnica', 'Obra menor tarificada', '36,28089', '€/ud' ),
T_TIPO_DATA( 'OM317', 'Desmontaje y retirada de Parquet flotante, incluso zócalo, capas inferiores de aislamiento y pasos de puerta existentes, incluyendo gestión de residuos a vertedero autorizado', 'Actuación técnica', 'Obra menor tarificada', '3,47', '€/m2' ),
T_TIPO_DATA( 'OM308', 'Desmontaje y retirada de puerta antiocupa.', 'Actuación técnica', 'Obra menor tarificada', '75', '€/ud' ),
T_TIPO_DATA( 'OM200', 'Desplazamiento de camión de desatranco', 'Actuación técnica', 'Obra menor tarificada', '125', '€/h' ),
T_TIPO_DATA( 'OM326', 'Dirección Facultativa > 60.000 €   ', 'Actuación técnica', 'Obra menor tarificada', '0,03', '%PEM' ),
T_TIPO_DATA( 'OM325', 'Dirección Facultativa 10.000 - 60.000 € ', 'Actuación técnica', 'Obra menor tarificada', '0,04', '%PEM' ),
T_TIPO_DATA( 'OM111', 'Doble punto de luz con doble interruptor', 'Actuación técnica', 'Obra menor tarificada', '37,76553', '€/ud' ),
T_TIPO_DATA( 'OM275', 'Drenaje de trasdós de muro mediante excavación, colocación de lámina de drenaje, instalación de tubo dren y relleno posterior con grava según CTE, hasta 3 m de profundidad', 'Actuación técnica', 'Obra menor tarificada', '73,4716666666666', '€/ml' ),
T_TIPO_DATA( 'OM324', 'Ejecución de riostra de cimentación, para posterior ejecución de muro de vallado de obra, de 40 cms de ancho y 60 cms de profundidad armada con 4Ø12 y estribos de Ø10 cada 30 cms, con hormigón HA-25-B-20-IIA, incluso excavación en terreno blando. Incluidos todos los medios auxiliares necesarios, completamente ejecutada y retirada de restos de excavación.', 'Actuación técnica', 'Obra menor tarificada', '32,47', '€/ml' ),
T_TIPO_DATA( 'OM27', 'Encasquillado de bote sifónico ', 'Actuación técnica', 'Obra menor tarificada', '16,41352', '€/ud' ),
T_TIPO_DATA( 'OM54', 'Esmalte, hasta 10 metros cuadrados', 'Actuación técnica', 'Obra menor tarificada', '86,8102', '€/ud' ),
T_TIPO_DATA( 'OM55', 'Esmalte, metro cuadrado adicional, a partir de 10 m²', 'Actuación técnica', 'Obra menor tarificada', '6,37158', '€/m2' ),
T_TIPO_DATA( 'OM296', 'Excavación tierras + transporte a vertedero', 'Actuación técnica', 'Obra menor tarificada', '8,11397', '€/m3' ),
T_TIPO_DATA( 'OM48', 'Gotelet, acabado plástico, hasta 10 metros cuadrados', 'Actuación técnica', 'Obra menor tarificada', '79,64475', '€/ud' ),
T_TIPO_DATA( 'OM49', 'Gotelet, acabado plástico, metro adicional, a partir de 10 m²', 'Actuación técnica', 'Obra menor tarificada', '4,9488', '€/m2' ),
T_TIPO_DATA( 'OM29', 'Hacer junta de manguetón WC. con inodoro o bajante general (un)', 'Actuación técnica', 'Obra menor tarificada', '26,99158', '€/ud' ),
T_TIPO_DATA( 'OM61', 'Hasta 3 metros lineales de moldura de escayola', 'Actuación técnica', 'Obra menor tarificada', '31,53829', '€/ud' ),
T_TIPO_DATA( 'OM202', 'Hora de mano trabajo de cerrajería urgente', 'Actuación técnica', 'Obra menor tarificada', '42,50813', '€/h' ),
T_TIPO_DATA( 'OM196', 'Hora de trabajo de Auxiliar Administrativo', 'Actuación técnica', 'Obra menor tarificada', '17,3208', '€/h' ),
T_TIPO_DATA( 'OM198', 'Hora de trabajo de Ayudante de oficio', 'Actuación técnica', 'Obra menor tarificada', '16,23825', '€/h' ),
T_TIPO_DATA( 'OM201', 'Hora de trabajo de camión de desatranco', 'Actuación técnica', 'Obra menor tarificada', '75,25', '€/h' ),
T_TIPO_DATA( 'OM195', 'Hora de trabajo de Encargado', 'Actuación técnica', 'Obra menor tarificada', '20,94992', '€/h' ),
T_TIPO_DATA( 'OM192', 'Hora de trabajo de Limpiador', 'Actuación técnica', 'Limpieza', '17,6301', '€/h' ),
T_TIPO_DATA( 'OM186', 'Hora de trabajo de Oficial albañil', 'Actuación técnica', 'Obra menor tarificada', '18,94978', '€/h' ),
T_TIPO_DATA( 'OM190', 'Hora de trabajo de Oficial calefactor', 'Actuación técnica', 'Obra menor tarificada', '18,94978', '€/h' ),
T_TIPO_DATA( 'OM184', 'Hora de trabajo de Oficial carpintero', 'Actuación técnica', 'Obra menor tarificada', '18,94978', '€/h' ),
T_TIPO_DATA( 'OM188', 'Hora de trabajo de Oficial cerrajero', 'Actuación técnica', 'Obra menor tarificada', '18,94978', '€/h' ),
T_TIPO_DATA( 'OM197', 'Hora de trabajo de Oficial de 2ª', 'Actuación técnica', 'Obra menor tarificada', '16,78468', '€/h' ),
T_TIPO_DATA( 'OM182', 'Hora de trabajo de Oficial electricista', 'Actuación técnica', 'Obra menor tarificada', '18,94978', '€/h' ),
T_TIPO_DATA( 'OM187', 'Hora de trabajo de Oficial fontanero', 'Actuación técnica', 'Obra menor tarificada', '18,94978', '€/h' ),
T_TIPO_DATA( 'OM189', 'Hora de trabajo de Oficial frigorista', 'Actuación técnica', 'Obra menor tarificada', '18,94978', '€/h' ),
T_TIPO_DATA( 'OM183', 'Hora de trabajo de Oficial parquetista', 'Actuación técnica', 'Obra menor tarificada', '18,94978', '€/h' ),
T_TIPO_DATA( 'OM185', 'Hora de trabajo de Oficial pintor', 'Actuación técnica', 'Obra menor tarificada', '18,94978', '€/h' ),
T_TIPO_DATA( 'OM191', 'Hora de trabajo de Oficial polivalente', 'Actuación técnica', 'Obra menor tarificada', '18,94978', '€/h' ),
T_TIPO_DATA( 'OM194', 'Hora de trabajo de Oficial polivalente (de 22:00 a 08:00 horas y festivos)', 'Actuación técnica', 'Obra menor tarificada', '28,1463', '€/h' ),
T_TIPO_DATA( 'OM199', 'Hora de trabajo de Peón especializado', 'Actuación técnica', 'Obra menor tarificada', '16,23825', '€/h' ),
T_TIPO_DATA( 'OM193', 'Hora de trabajo de peón no cualificado', 'Actuación técnica', 'Obra menor tarificada', '16,23825', '€/h' ),
T_TIPO_DATA( 'OM271', 'Impermeabilización de cubierta plana asfáltica, no incluyendo retirada ni reposición de material de protección de la lámina. Incluyendo p.p. de remates de desagües, esquinas y cualquier otro elemento que interrumpa la tela', 'Actuación técnica', 'Obra menor tarificada', '13,51', '€/m2' ),
T_TIPO_DATA( 'OM273', 'Impermeabilización de cubierta plana de PVC, no incluyendo retirada ni reposición de material de protección de la lámina. Incluyendo p.p. de remates de desagües, esquinas y cualquier otro elemento que interrumpa la membrana', 'Actuación técnica', 'Obra menor tarificada', '22,88', '€/m2' ),
T_TIPO_DATA( 'OM341', 'Levantado y posterior recolocación de mampara de ducha o bañera, incluidos todos los trabajos necesarios para la correcta ejecución. Se contabilizará cada uno de los elementos. Se incluye el sellado final del elemento.', 'Actuación técnica', 'Obra menor tarificada', '55,96', '€/ud' ),
T_TIPO_DATA( 'OM168', 'Lijado y barnizado hasta 15 m²', 'Actuación técnica', 'Obra menor tarificada', '178,23928', '€/ud' ),
T_TIPO_DATA( 'OM169', 'Lijado y barnizado por m² adicional', 'Actuación técnica', 'Obra menor tarificada', '13,403', '€/m2' ),
T_TIPO_DATA( 'OM280', 'Limpieza de arqueta de cualquier tipo', 'Actuación técnica', 'Limpieza', '4,7', '€/ud' ),
T_TIPO_DATA( 'OM284', 'Limpieza de canalones de cualquier material y sección', 'Actuación técnica', 'Limpieza', '3,04145', '€/ml' ),
T_TIPO_DATA( 'OM279', 'Limpieza de sumidero en cubierta / patio / garaje', 'Actuación técnica', 'Limpieza', '1,84', '€/ud' ),
T_TIPO_DATA( 'OM318', 'Limpieza de terraza. Incluidos los imbornales, sumideros y elementos existentes hasta 15m²', 'Actuación técnica', 'Limpieza', '45', '€/ud' ),
T_TIPO_DATA( 'OM319', 'Limpieza general de piscina de Sup. <=35 m2  (Incluido vaciado)', 'Actuación técnica', 'Limpieza', '250', '€/ud' ),
T_TIPO_DATA( 'OM320', 'Limpieza general de piscina de Sup. De >35 m2  (Incluido vaciado)', 'Actuación técnica', 'Limpieza', '315', '€/ud' ),
T_TIPO_DATA( 'OM283', 'Limpieza y desatranco de canaletas e cubierta / patio / garaje con retirada de escombro a vertedero', 'Actuación técnica', 'Limpieza', '2,06866666666667', '€/ml' ),
T_TIPO_DATA( 'OM127', 'M línea de 2 x 1,5 m m² + 2 x 2,5 m m² + TT', 'Actuación técnica', 'Obra menor tarificada', '10,86674', '€/ml' ),
T_TIPO_DATA( 'OM126', 'M línea de 2 x 2,5 m m² + TT', 'Actuación técnica', 'Obra menor tarificada', '6,91801', '€/ml' ),
T_TIPO_DATA( 'OM129', 'M línea de 2x6mni2+TT', 'Actuación técnica', 'Obra menor tarificada', '9,94915', '€/ml' ),
T_TIPO_DATA( 'OM125', 'M lineal de 2x1,5m m²', 'Actuación técnica', 'Obra menor tarificada', '5,59833', '€/ml' ),
T_TIPO_DATA( 'OM128', 'M lineal de 2x4m m²+TT', 'Actuación técnica', 'Obra menor tarificada', '8,71195', '€/ml' ),
T_TIPO_DATA( 'OM209', 'M Vallado con bloque de hormigón, hasta una altura de 2 m enfoscado, con pilares cada 3m, maestreado y pintado en blanco. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos', 'Actuación técnica', 'Obra menor tarificada', '54,3', '€/ml' ),
T_TIPO_DATA( 'OM208', 'M Vallado con simple torsión hasta 2 m de altura, incluso postes de sujeción cada 3 metros. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos', 'Actuación técnica', 'Obra menor tarificada', '17,78475', '€/ml' ),
T_TIPO_DATA( 'OM206', 'M² Aplicación de herbicida sistémico no selectivo junto con herbicida de post-emergencia', 'Actuación técnica', 'Obra menor tarificada', '0,12', '€/m2' ),
T_TIPO_DATA( 'OM69', 'M² de alicatado o solado hasta 3 m (precio por metro)', 'Actuación técnica', 'Obra menor tarificada', '23,9666666666667', '€/m2' ),
T_TIPO_DATA( 'OM70', 'M² de alicatado o solado más de 3 m (precio por metro)', 'Actuación técnica', 'Obra menor tarificada', '21,2', '€/m2' ),
T_TIPO_DATA( 'OM203', 'M² Desbroce de parcela con maquinaria. Gestión de residuos incluida', 'Actuación técnica', 'Obra menor tarificada', '0,36', '€/m2' ),
T_TIPO_DATA( 'OM204', 'M² Desbroce manual de parcela/jardín. Gestión de residuos incluida ', 'Actuación técnica', 'Obra menor tarificada', '0,77', '€/m2' ),
T_TIPO_DATA( 'OM174', 'M² parquet eucalipto damas', 'Actuación técnica', 'Obra menor tarificada', '43,302', '€/m2' ),
T_TIPO_DATA( 'OM175', 'M² parquet eucalipto tablillas', 'Actuación técnica', 'Obra menor tarificada', '41,24', '€/m2' ),
T_TIPO_DATA( 'OM176', 'M² parquet pino oregón', 'Actuación técnica', 'Obra menor tarificada', '73,77836', '€/m2' ),
T_TIPO_DATA( 'OM172', 'M² parquet roble baldosa', 'Actuación técnica', 'Obra menor tarificada', '35,83756', '€/m2' ),
T_TIPO_DATA( 'OM170', 'M² parquet roble damas', 'Actuación técnica', 'Obra menor tarificada', '25,16671', '€/m2' ),
T_TIPO_DATA( 'OM171', 'M² parquet roble tablillas', 'Actuación técnica', 'Obra menor tarificada', '49,7973', '€/m2' ),
T_TIPO_DATA( 'OM80', 'M² picar cemento (azulejo, plaqueta o terrazo) para alicatar o solar', 'Actuación técnica', 'Obra menor tarificada', '8,248', '€/m2' ),
T_TIPO_DATA( 'OM81', 'M² picar hormigón e=10cm', 'Actuación técnica', 'Obra menor tarificada', '23,74393', '€/m2' ),
T_TIPO_DATA( 'OM77', 'M² picar yeso', 'Actuación técnica', 'Obra menor tarificada', '8,248', '€/m2' ),
T_TIPO_DATA( 'OM207', 'M² Poda, puntual y selectiva, manual, con todos los útiles necesarios. Gestión de residuos incluida', 'Actuación técnica', 'Obra menor tarificada', '2,63936', '€/m2' ),
T_TIPO_DATA( 'OM248', 'M² Recolocación de placas de escayola desmontable con perfiles, situados a una altura de hasta 4m ', 'Actuación técnica', 'Obra menor tarificada', '5,6705', '€/m2' ),
T_TIPO_DATA( 'OM220', 'M² Reparación de humedades en cubierta con impermeabilizante', 'Actuación técnica', 'Obra menor tarificada', '14,9333333333333', '€/m2' ),
T_TIPO_DATA( 'OM218', 'M² Reparación de humedades en fachada de unifamiliares', 'Actuación técnica', 'Obra menor tarificada', '19,3243333333333', '€/m2' ),
T_TIPO_DATA( 'OM221', 'M² Reparación grietas en cubierta con impermeabilizante', 'Actuación técnica', 'Obra menor tarificada', '21,3333333333333', '€/m2' ),
T_TIPO_DATA( 'OM219', 'M² Reparación grietas en fachada de unifamiliares', 'Actuación técnica', 'Obra menor tarificada', '11,9466666666667', '€/m2' ),
T_TIPO_DATA( 'OM76', 'M² solo raseado con arena y cemento', 'Actuación técnica', 'Obra menor tarificada', '12,372', '€/m2' ),
T_TIPO_DATA( 'OM177', 'M² tarima pino viejo', 'Actuación técnica', 'Obra menor tarificada', '76,86105', '€/m2' ),
T_TIPO_DATA( 'OM173', 'M² tarima roble', 'Actuación técnica', 'Obra menor tarificada', '61,38574', '€/m2' ),
T_TIPO_DATA( 'OM79', 'M² tender yeso blanco', 'Actuación técnica', 'Obra menor tarificada', '8,6604', '€/m2' ),
T_TIPO_DATA( 'OM78', 'M² tender yeso negro', 'Actuación técnica', 'Obra menor tarificada', '8,6604', '€/m2' ),
T_TIPO_DATA( 'OM364', 'M2. Aplicación de lechada y llagueado de material cerámico en paramentos verticales.', 'Actuación técnica', 'Obra menor tarificada', '1,91', '€/m2' ),
T_TIPO_DATA( 'OM62', 'Metro lineal de moldura de escayola adicional', 'Actuación técnica', 'Obra menor tarificada', '10,05225', '€/ml' ),
T_TIPO_DATA( 'OM178', 'MI rodapié aglomerado', 'Actuación técnica', 'Obra menor tarificada', '5,89732', '€/ml' ),
T_TIPO_DATA( 'OM179', 'MI rodapié macizo 7 cm', 'Actuación técnica', 'Obra menor tarificada', '7,48506', '€/ml' ),
T_TIPO_DATA( 'OM181', 'Ml barnizado de rodapié poliuretano', 'Actuación técnica', 'Obra menor tarificada', '3,51571', '€/ml' ),
T_TIPO_DATA( 'OM180', 'Ml rodapié macizo 10 cm', 'Actuación técnica', 'Obra menor tarificada', '8,69133', '€/ml' ),
T_TIPO_DATA( 'OM362', 'Ml. Rejuntado o sellado de rodapié con mortero hidrófugo o silicona resistencia UV ', 'Actuación técnica', 'Obra menor tarificada', '5,09', '€/ml' ),
T_TIPO_DATA( 'OM313', 'ML. Sellado de carpintería de aluminio con encuentros de fabrica de fachada y albardillas', 'Actuación técnica', 'Obra menor tarificada', '5,11', '€/ml' ),
T_TIPO_DATA( 'OM363', 'Ml. Sellado de juntas con mortero hidrófugo', 'Actuación técnica', 'Obra menor tarificada', '5,09', '€/ml' ),
T_TIPO_DATA( 'OM361', 'ML. Suministro y colocación de rodapié cerámico incluido material. ', 'Actuación técnica', 'Obra menor tarificada', '6,1', '€/ml' ),
T_TIPO_DATA( 'OM52', 'Pasta rayada, hasta 10 m²', 'Actuación técnica', 'Obra menor tarificada', '80,8304', '€/ud' ),
T_TIPO_DATA( 'OM53', 'Pasta rayada, metro cuadrado adicional, a partir de 10 m²', 'Actuación técnica', 'Obra menor tarificada', '5,155', '€/m2' ),
T_TIPO_DATA( 'OM46', 'Picado, acabado plástico, hasta 10 m²', 'Actuación técnica', 'Obra menor tarificada', '32,4765', '€/ud' ),
T_TIPO_DATA( 'OM47', 'Picado, acabado plástico, m² adicional (a partir de 10 m²)', 'Actuación técnica', 'Obra menor tarificada', '4,20648', '€/m2' ),
T_TIPO_DATA( 'OM72', 'Picar y tapar 1 m² de enlucido, en paredes verticales', 'Actuación técnica', 'Obra menor tarificada', '66,10772', '€/ud' ),
T_TIPO_DATA( 'OM71', 'Picar y tapar 1/2 m² de enlucido en paredes verticales', 'Actuación técnica', 'Obra menor tarificada', '65,21075', '€/ud' ),
T_TIPO_DATA( 'OM73', 'Picar y tapar 2 m² de enlucido, en paredes verticales', 'Actuación técnica', 'Obra menor tarificada', '96,54284', '€/ud' ),
T_TIPO_DATA( 'OM74', 'Picar y tapar 3 m² de enlucido, en paredes verticales', 'Actuación técnica', 'Obra menor tarificada', '119,70941', '€/ud' ),
T_TIPO_DATA( 'OM75', 'Picar y tapar m² adicional de enlucido, en paredes verticales (a partir de 3 m)', 'Actuación técnica', 'Obra menor tarificada', '18,74358', '€/m2' ),
T_TIPO_DATA( 'CM-CER1', 'Sustitución de bombillo normal (Azbe, Tesa, Lince, Fiam, Ucem o similar) incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.', 'Actuación técnica', 'Cambio de cerradura', '77,7374', '€/ud' ),
T_TIPO_DATA( 'CM-CER2', 'Sustitución de bombillo de seguridad (Azbe, Tesa, Linceo similar) gama baja  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.', 'Actuación técnica', 'Cambio de cerradura', '113,28628', '€/ud' ),
T_TIPO_DATA( 'CM-CER3', 'Sustitución de bombillo de seguridad (Fac, Mia de Borjas, Iseo o similar) gama media  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.', 'Actuación técnica', 'Cambio de cerradura', '127,02951', '€/ud' ),
T_TIPO_DATA( 'CM-CER4', 'Sustitución de bombillo de seguridad (Potent Borjas, Cr Acoraz, Cr doble) gama alta  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.', 'Actuación técnica', 'Cambio de cerradura', '169,69229', '€/ud' ),
T_TIPO_DATA( 'CM-CER5', 'Sustitución de cerrojo (Fac, Lince, Ezcurra o similar)  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.', 'Actuación técnica', 'Cambio de cerradura', '89,85165', '€/ud' ),
T_TIPO_DATA( 'CM-CER6', 'Reparación de cerradura (sin aporte de piezas)', 'Actuación técnica', 'Cambio de cerradura', '43,302', '€/ud' ),
T_TIPO_DATA( 'OM258', 'Piezas pétreas en fachada mediante anclajes de acero inox', 'Actuación técnica', 'Obra menor tarificada', '73,62371', '€/m2' ),
T_TIPO_DATA( 'OM51', 'Pintura tisotrópica (paramentos muy afect.) m² adicional a partir de 10 m²', 'Actuación técnica', 'Obra menor tarificada', '6,06228', '€/m2' ),
T_TIPO_DATA( 'OM50', 'Pintura tisotrópica (paramentos muy afectados) hasta 10 m²', 'Actuación técnica', 'Obra menor tarificada', '89,89289', '€/ud' ),
T_TIPO_DATA( 'OM44', 'Plástico liso, hasta 10 m²', 'Actuación técnica', 'Obra menor tarificada', '86,37718', '€/ud' ),
T_TIPO_DATA( 'OM45', 'Plástico liso, m² adicional (a partir de 10 m²)', 'Actuación técnica', 'Obra menor tarificada', '4,14462', '€/m2' ),
T_TIPO_DATA( 'OM300', 'Poda de árbol con cesta de 15 a 20 m de altura', 'Actuación técnica', 'Obra menor tarificada', '109,1829', '€/ud' ),
T_TIPO_DATA( 'OM301', 'Poda de árbol con cesta de 6 a 10 m de altura', 'Actuación técnica', 'Obra menor tarificada', '47,37445', '€/ud' ),
T_TIPO_DATA( 'OM302', 'Poda de árbol con trepa de 15 a 20 m de altura', 'Actuación técnica', 'Obra menor tarificada', '240,5323', '€/ud' ),
T_TIPO_DATA( 'OM167', 'Preparación de suelo con pasta niveladora por m² espesor entre 5 mm-25 mm', 'Actuación técnica', 'Obra menor tarificada', '6,47468', '€/m2' ),
T_TIPO_DATA( 'OM112', 'Punto de luz conmutado', 'Actuación técnica', 'Obra menor tarificada', '35,86849', '€/ud' ),
T_TIPO_DATA( 'OM118', 'Punto de luz conmutado con dos bases de enchufe', 'Actuación técnica', 'Obra menor tarificada', '66,57167', '€/ud' ),
T_TIPO_DATA( 'OM115', 'Punto de luz conmutado con regulación lumínica', 'Actuación técnica', 'Obra menor tarificada', '69,20072', '€/ud' ),
T_TIPO_DATA( 'OM117', 'Punto de luz conmutado con una base de enchufe', 'Actuación técnica', 'Obra menor tarificada', '60,28257', '€/ud' ),
T_TIPO_DATA( 'OM113', 'Punto de luz cruzamiento', 'Actuación técnica', 'Obra menor tarificada', '43,07518', '€/ud' ),
T_TIPO_DATA( 'OM119', 'Punto de luz cruzamiento con dos bases de enchufe', 'Actuación técnica', 'Obra menor tarificada', '77,38686', '€/ud' ),
T_TIPO_DATA( 'OM116', 'Punto de luz cruzamiento con regulación lumínica', 'Actuación técnica', 'Obra menor tarificada', '67,12841', '€/ud' ),
T_TIPO_DATA( 'OM110', 'Punto de luz sencillo', 'Actuación técnica', 'Obra menor tarificada', '22,69231', '€/ud' ),
T_TIPO_DATA( 'OM114', 'Punto de luz sencillo con regulación lumínica', 'Actuación técnica', 'Obra menor tarificada', '56,46787', '€/ud' ),
T_TIPO_DATA( 'OM120', 'Punto de timbre', 'Actuación técnica', 'Obra menor tarificada', '24,48625', '€/ud' ),
T_TIPO_DATA( 'OM297', 'Relleno de zanjas con arena', 'Actuación técnica', 'Obra menor tarificada', '14,3309', '€/m3' ),
T_TIPO_DATA( 'OM281', 'Reparación de acera mediante elemento continuo de hormigón pulido / impreso', 'Actuación técnica', 'Obra menor tarificada', '19,83644', '€/m2' ),
T_TIPO_DATA( 'OM282', 'Reparación de acera mediante elemento discontinuo de baldosa / adoquín', 'Actuación técnica', 'Obra menor tarificada', '27,56', '€/m2' ),
T_TIPO_DATA( 'OM388', 'Reparación de persiana hasta 1 m² ', 'Actuación técnica', 'Obra menor tarificada', '21,90875', '€/ud' ),
T_TIPO_DATA( 'OM389', 'Reparación de persiana hasta 2 m² ', 'Actuación técnica', 'Obra menor tarificada', '39,43575', '€/ud' ),
T_TIPO_DATA( 'OM390', 'Reparación de persiana hasta 4 m² ', 'Actuación técnica', 'Obra menor tarificada', '74,48975', '€/ud' ),
T_TIPO_DATA( 'OM31', 'Reparar mangueta o bote sifónico o desagüe o tubería sin sustitución', 'Actuación técnica', 'Obra menor tarificada', '39,61102', '€/ud' ),
T_TIPO_DATA( 'OM274', 'Retirada de teja cerámica o de hormigón, reparación de la impermeabilización y reposición posterior de la teja, con recibido si es necesario (sin aporte de material)', 'Actuación técnica', 'Obra menor tarificada', '24,5086666666667', '€/m2' ),
T_TIPO_DATA( 'OM277', 'Revisión, legalización y puesta en marcha de ascensor de hasta 4 alturas', 'Actuación técnica', 'Obra menor tarificada', '175,27', '€/ud' ),
T_TIPO_DATA( 'OM278', 'Revisión, legalización y puesta en marcha de ascensor de hasta 9 alturas', 'Actuación técnica', 'Obra menor tarificada', '350,54', '€/ud' ),
T_TIPO_DATA( 'OM3', 'Segunda localización: verificación y observación de avería', 'Actuación técnica', 'Obra menor tarificada', '21,58914', '€/ud' ),
T_TIPO_DATA( 'OM339', 'Sellado de perímetro de bañera o plato de ducha con silicona anti moho al acido.', 'Actuación técnica', 'Obra menor tarificada', '8,3', '€/ud' ),
T_TIPO_DATA( 'OM334', 'Servicio mínimo de horas de camión de desatranco, incluidos los operarios necesarios para la ejecución de los trabajos. Partida complementaria al desplazamiento del camión (a esta partida falta añadirle las horas de servicio).', 'Actuación técnica', 'Obra menor tarificada', '120', '€/ud' ),
T_TIPO_DATA( 'OM335', 'Servicio mínimo para Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen.', 'Actuación técnica', 'Obra menor tarificada', '360', '€/ud' ),
T_TIPO_DATA( 'OM256', 'Solado o alicatado de elementos de gran formato y/o porcelánicos (sin material)', 'Actuación técnica', 'Obra menor tarificada', '20,47566', '€/m2' ),
T_TIPO_DATA( 'OM257', 'Solado o alicatado de piedra natural incluyendo el material pétreo, todo el resto de material y trabajos auxiliares', 'Actuación técnica', 'Obra menor tarificada', '73,7165', '€/m2' ),
T_TIPO_DATA( 'OM4', 'Soldadura de tuberías generales y reparación de bajantes PVC ', 'Actuación técnica', 'Obra menor tarificada', '9,50582', '€/ud' ),
T_TIPO_DATA( 'OM304', 'Suministro de copia de llave de seguridad intermedia (llave de puntos o similar)', 'Actuación técnica', 'Obra menor tarificada', '7,5', '€/ud' ),
T_TIPO_DATA( 'OM382', 'Suministro e instalación de bañera de chapa lacada de hasta 160 cm de longitud, sin incluir grifería', 'Actuación técnica', 'Obra menor tarificada', '165,75', '€/ud' ),
T_TIPO_DATA( 'OM262', 'Suministro e instalación de boca de incendio equipada 25 m incluyendo señalización(s/ CTE)', 'Actuación técnica', 'Obra menor tarificada', '241,29524', '€/ud' ),
T_TIPO_DATA( 'OM263', 'Suministro e instalación de boca de incendio equipada 45 m incluyendo señalización(s/ CTE)', 'Actuación técnica', 'Obra menor tarificada', '350,75651', '€/ud' ),
T_TIPO_DATA( 'OM373', 'Suministro e instalación de campana extractora de cocina hasta 10m² de acero inoxidable visto de calidad media alta>500m³/h', 'Actuación técnica', 'Obra menor tarificada', '412,4', '€/ud' ),
T_TIPO_DATA( 'OM372', 'Suministro e instalación de campana extractora de cocina hasta 16m² de acero inoxidable visto de calidad media alta>500m³/h', 'Actuación técnica', 'Obra menor tarificada', '412,4', '€/ud' ),
T_TIPO_DATA( 'OM307', 'Suministro e instalación de candado, incluida cadena hasta 0,5mts en caso necesario y descerraje de candado existente si fuere necesario', 'Actuación técnica', 'Obra menor tarificada', '35', '€/ud' ),
T_TIPO_DATA( 'OM338', 'Suministro e instalación de conjunto flexo y alcachofa de ducha o bañera.', 'Actuación técnica', 'Obra menor tarificada', '27,15', '€/ud' ),
T_TIPO_DATA( 'OM260', 'Suministro e instalación de detector de presencia para instalación eléctrica', 'Actuación técnica', 'Obra menor tarificada', '92,6869', '€/ud' ),
T_TIPO_DATA( 'OM375', 'Suministro e instalación de encimera de cocina de calidad alta de silestone con acabado pulido o similar, color a elegir ', 'Actuación técnica', 'Obra menor tarificada', '258,41', '€/ml' ),
T_TIPO_DATA( 'OM377', 'Suministro e instalación de encimera de cocina de calidad económica con acabado en tablero, incluyendo copas y remates de extremos, ángulos y esquinas', 'Actuación técnica', 'Obra menor tarificada', '58,767', '€/ml' ),
T_TIPO_DATA( 'OM376', 'Suministro e instalación de encimera de cocina de calidad media de granito nacional pulido o similar', 'Actuación técnica', 'Obra menor tarificada', '145,166666666667', '€/ml' ),
T_TIPO_DATA( 'OM306', 'Suministro e instalación de escudo de seguridad media', 'Actuación técnica', 'Obra menor tarificada', '20', '€/ud' ),
T_TIPO_DATA( 'OM272', 'Suministro e instalación de extintor de incendios portátil de eficacia 21A -113B incluyendo soporte y señalización (s/ CTE)', 'Actuación técnica', 'Obra menor tarificada', '53,12743', '€/ud' ),
T_TIPO_DATA( 'OM336', 'Suministro e instalación de extractora de baño o espacio cerrado con necesidad de ventilación i/instalación eléctrica,', 'Actuación técnica', 'Obra menor tarificada', '75', '€/ud' ),
T_TIPO_DATA( 'OM337', 'Suministro e instalación de flexo de ducha de hasta 2m.', 'Actuación técnica', 'Obra menor tarificada', '12,1', '€/ud' ),
T_TIPO_DATA( 'OM287', 'Suministro e instalación de grifería monomando de bañera de acero, con doble salida a grifo y flexo. Incluyendo manguera y ducha', 'Actuación técnica', 'Obra menor tarificada', '121,55', '€/ud' ),
T_TIPO_DATA( 'OM285', 'Suministro e instalación de grifería monomando de cocina de acero, para colocar empotrado en fregadero', 'Actuación técnica', 'Obra menor tarificada', '56,88027', '€/ud' ),
T_TIPO_DATA( 'OM286', 'Suministro e instalación de grifería monomando de lavabo/bidet de acero', 'Actuación técnica', 'Obra menor tarificada', '46,0013333333333', '€/ud' ),
T_TIPO_DATA( 'OM310', 'Suministro e instalación de Hoja de Puerta abatible interior de hasta 100 cms gama media en acabado lacado blanco, incluyendo: puerta, bisagras y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '175', '€/ud' ),
T_TIPO_DATA( 'OM347', 'Suministro e instalación de HORNO GAMA MEDIA E INSTALACIÓN ESTANDAR.', 'Actuación técnica', 'Obra menor tarificada', '250', '€/ud' ),
T_TIPO_DATA( 'OM309', 'Suministro e instalación de juego de tapetas gama media en acabado lacado blanco, para las dos caras de una puerta', 'Actuación técnica', 'Obra menor tarificada', '48,25', '€/ud' ),
T_TIPO_DATA( 'OM242', 'Suministro e instalación de lavabo cerámico color estándar a elegir de un seno y sustentado sobre pie cerámico, sin incluir grifería', 'Actuación técnica', 'Obra menor tarificada', '74,1081666666667', '€/ud' ),
T_TIPO_DATA( 'OM268', 'Suministro e instalación de luminaria de emergencia (s/ CTE)', 'Actuación técnica', 'Obra menor tarificada', '80,42831', '€/ud' ),
T_TIPO_DATA( 'SOL1', 'Limpieza de parcela/solar para retirada de escombros u otros restos voluminosos, incluida retirada y gestión de restos a vertedero autorizado. Se deberá aportar justificación del volumen real retirado.', 'Actuación técnica', 'Limpieza, desinfección, desbroces y vallados de solares', '35', '€/m3' ),
T_TIPO_DATA( 'OM105', 'Suministro e instalación de luna en color templada de 10 mm (metro cuadrado)', 'Actuación técnica', 'Obra menor tarificada', '146,83502', '€/m2' ),
T_TIPO_DATA( 'OM104', 'Suministro e instalación de luna en color templada de6 mm (metro cuadrado)', 'Actuación técnica', 'Obra menor tarificada', '104,4403', '€/m2' ),
T_TIPO_DATA( 'OM103', 'Suministro e instalación de luna incolora templada de 10 mm (metro cuadrado)', 'Actuación técnica', 'Obra menor tarificada', '120,91568', '€/m2' ),
T_TIPO_DATA( 'OM101', 'Suministro e instalación de luna incolora templada de 6mrn (metro cuadrado)', 'Actuación técnica', 'Obra menor tarificada', '90,82', '€/m2' ),
T_TIPO_DATA( 'OM102', 'Suministro e instalación de luna incolora templada de 8mm (metro cuadrado)', 'Actuación técnica', 'Obra menor tarificada', '107,33', '€/m2' ),
T_TIPO_DATA( 'OM106', 'Suministro e instalación de luna templada en puertas de 10 mm (metro cuadrado', 'Actuación técnica', 'Obra menor tarificada', '209,83943', '€/m2' ),
T_TIPO_DATA( 'OM84', 'Suministro e instalación de lunas incoloras de 3 mm (un metro cuadrado) incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '30,93', '€/m2' ),
T_TIPO_DATA( 'OM346', 'Suministro e instalación de placa cocción de gas de 60x60 cms, incluidos todos los trabajos para la correcta ejecución y conexionado a la instalación existente. Quedan expresamente excluidos los trabajos de adaptación de la instalación de gas a normativa en caso de ser necesario.', 'Actuación técnica', 'Obra menor tarificada', '220', '€/ud' ),
T_TIPO_DATA( 'OM348', 'Suministro e instalación de placa de inducción de 60x60 cms, incluidos todos los trabajos para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '250', '€/ud' ),
T_TIPO_DATA( 'OM386', 'Suministro e instalación de plato de ducha acrílico de hasta 90x90 cm, sin incluir grifería', 'Actuación técnica', 'Obra menor tarificada', '157,743', '€/ud' ),
T_TIPO_DATA( 'SOL2', 'Ud Desratización con anticoagulantes, administrados mediante cebos, incluido certificado. (Superficie hasta 400 m²)', 'Actuación técnica', 'Limpieza, desinfección, desbroces y vallados de solares', '256,066666666667', '€/ud' ),
T_TIPO_DATA( 'SOL3', 'Ud Desinfección contra hongos, virus y bacterias, incluido certificado. (Sup. Hasta 400 m²)', 'Actuación técnica', 'Limpieza, desinfección, desbroces y vallados de solares', '264,316666666667', '€/ud' ),
T_TIPO_DATA( 'OM387', 'Suministro e instalación de plato de ducha acrílico mayor de 90x90 cm, sin incluir grifería', 'Actuación técnica', 'Obra menor tarificada', '227,851', '€/ud' ),
T_TIPO_DATA( 'OM384', 'Suministro e instalación de plato de ducha cerámico de hasta 90x90 cm, sin incluir grifería ', 'Actuación técnica', 'Obra menor tarificada', '113,9255', '€/ud' ),
T_TIPO_DATA( 'OM385', 'Suministro e instalación de plato de ducha cerámico mayor de 90x90 cm, sin incluir grifería', 'Actuación técnica', 'Obra menor tarificada', '131,4525', '€/ud' ),
T_TIPO_DATA( 'OM311', 'Suministro e instalación de Puerta abatible block interior de hasta 100 cms gama media en acabado lacado blanco, incluyendo: puerta, bisagras, batientes, tapetas y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '245,6', '€/ud' ),
T_TIPO_DATA( 'OTR2', ' PA Trámites Oficinas suministradoras', 'Obtención documentación', 'Obtención certificados y documentación', '38,5', '€/h' ),
T_TIPO_DATA( 'OTR1', ' PA Trámites Entidades Locales', 'Obtención documentación', 'Obtención certificados y documentación', '45,5', '€/h' ),
T_TIPO_DATA( 'BOL4', 'PA Obtención/Tramitación de Boletín Agua', 'Obtención documentación', 'Boletín agua', '90', '€/ud' ),
T_TIPO_DATA( 'BOL5', 'Emisión de proyecto y boletín de legalización de instalación de gas en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos ', 'Obtención documentación', 'Boletín gas', '120', '€/ud' ),
T_TIPO_DATA( 'CED1', 'PA Obtención/Tramitación de Nueva cédula de habitabilidad', 'Obtención documentación', 'Cédula de Habitabilidad', '103,1', '€/ud' ),
T_TIPO_DATA( 'CED2', 'PA Obtención/Tramitación de Duplicado de LPO o Cédula', 'Obtención documentación', 'Cédula de Habitabilidad', '40', '€/ud' ),
T_TIPO_DATA( 'INF4', 'Hr Técnico en elaboración de informes o realización de gestiones', 'Obtención documentación', 'Informes', '21,651', '€/ud' ),
T_TIPO_DATA( 'OM312', 'Suministro e instalación de Puerta abatible de Entrada en block de hasta 100 cms BLINDADA (gama media) en acabado de melamina, incluyendo: puerta, bisagras, batientes, tapetas, cerradura, pomo y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '557,51', '€/ud' ),
T_TIPO_DATA( 'OM252', 'Suministro e instalación de puerta antiocupa homologada cumpliendo normativa europea y suministrada igualmente por fabricante competente para emitir su certificado de idoneidad', 'Actuación técnica', 'Obra menor tarificada', '788,715', '€/ud' ),
T_TIPO_DATA( 'OM266', 'Suministro e instalación de puerta EF 30 (s/ CTE), 90x210 totalmente rematada y terminada', 'Actuación técnica', 'Obra menor tarificada', '216,86054', '€/m2' ),
T_TIPO_DATA( 'OM267', 'Suministro e instalación de puerta EF 60 (s/ CTE), 90x210 totalmente rematada y terminada', 'Actuación técnica', 'Obra menor tarificada', '236,00621', '€/m2' ),
T_TIPO_DATA( 'OM244', 'Suministro e instalación de tapa de inodoro', 'Actuación técnica', 'Obra menor tarificada', '30,925', '€/ud' ),
T_TIPO_DATA( 'OM367', 'Suministro e instalación de teja árabe, incluidos materiales de fijación, remate y sellado del mismo en caso de ser necesario para la completa y correcta ejecución. Partida mínima de ejecución de 1 m2.', 'Actuación técnica', 'Obra menor tarificada', '21,81', '€/m2' ),
T_TIPO_DATA( 'OM368', 'Suministro e instalación de teja de hormigón, incluidos materiales de fijación, remate y sellado del mismo en caso de ser necesario para la completa y correcta ejecución. Partida mínima de ejecución de 1 m2.', 'Actuación técnica', 'Obra menor tarificada', '30,63', '€/m2' ),
T_TIPO_DATA( 'OM316', 'Suministro e instalación de vidrio con cámara de 4/8/4 mm, incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '51,01', '€/m2' ),
T_TIPO_DATA( 'OM89', 'Suministro e instalación de vidrio simple de 10 mm, incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '92,33', '€/m2' ),
T_TIPO_DATA( 'OM90', 'Suministro e instalación de vidrio simple de 15 mm, incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '145,04', '€/m2' ),
T_TIPO_DATA( 'OM85', 'Suministro e instalación de vidrio simple de 4 mm, incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '36,085', '€/m2' ),
T_TIPO_DATA( 'OM86', 'Suministro e instalación de vidrio simple de 5 mm, incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '41,24', '€/m2' ),
T_TIPO_DATA( 'OM87', 'Suministro e instalación de vidrio simple de 6 mm, incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '46,395', '€/m2' ),
T_TIPO_DATA( 'OM88', 'Suministro e instalación de vidrio simple de 8 mm, incluidos todos los trabajos necesarios para la correcta ejecución', 'Actuación técnica', 'Obra menor tarificada', '78,21', '€/m2' ),
T_TIPO_DATA( 'OM95', 'Suministro e instalación de vidrios laminados de seguridad de 3+3 mm (m²)', 'Actuación técnica', 'Obra menor tarificada', '61,97341', '€/m2' ),
T_TIPO_DATA( 'OM96', 'Suministro e instalación de vidrios laminados de seguridad de 4+4 mm (m²)', 'Actuación técnica', 'Obra menor tarificada', '83,3048', '€/m2' ),
T_TIPO_DATA( 'OM97', 'Suministro e instalación de vidrios laminados de seguridad de 5+5 mm m²)', 'Actuación técnica', 'Obra menor tarificada', '95,18192', '€/m2' ),
T_TIPO_DATA( 'OM98', 'Suministro e instalación de vidrios laminados de seguridad de 6+6 mm (m²)', 'Actuación técnica', 'Obra menor tarificada', '105,13107', '€/m2' ),
T_TIPO_DATA( 'OM276', 'Suministro e instalación mediante anclajes epoxi de rejas de protección en ventanas/ puertas, realizadas con hierro tratado contra la corrosión', 'Actuación técnica', 'Obra menor tarificada', '82,83054', '€/m2' ),
T_TIPO_DATA( 'OM343', 'Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 100 m2 o 3 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros.', 'Actuación técnica', 'Obra menor tarificada', '549,31', '€/ud' ),
T_TIPO_DATA( 'OM344', 'Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 120 m2 o 4 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros', 'Actuación técnica', 'Obra menor tarificada', '658,8', '€/ud' ),
T_TIPO_DATA( 'OM345', 'Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 150 m2 o 5 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros. Para mayores superficies o habitaciones se realizará valoración específica del inmueble.', 'Actuación técnica', 'Obra menor tarificada', '823,5', '€/ud' ),
T_TIPO_DATA( 'OM342', 'Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 80 m2 o 2 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros.', 'Actuación técnica', 'Obra menor tarificada', '439,2', '€/ud' ),
T_TIPO_DATA( 'OM349', 'Suministro y colocación de amueblamiento de cocina gama baja-económica, compuesta por 3,5 m de muebles bajos con zócalo inferior y un módulo de muebles altos de 80 cm, acabado laminado, cantos verticales post formados. Incluso zócalo inferior, y remates a juego con el acabado, guías de rodamientos metálicos y tiradores en puertas, incluso piezas especiales de desagües de electrodomésticos. Totalmente montado, sin incluir encimera, electrodomésticos ni fregadero. ', 'Actuación técnica', 'Obra menor tarificada', '750', '€/ud' ),
T_TIPO_DATA( 'OM323', 'Suministro y colocación de cercado mediante chapa plegada o similar en acabado galvanizado y altura hasta 200 cms, con los postes y tensores necesarios en función de la geometría del solar, incluidos los pies, anclajes y/o empotramientos necesarios para su completa y correcta ejecución.', 'Actuación técnica', 'Obra menor tarificada', '29,22', '€/ml' ),
T_TIPO_DATA( 'OM269', 'Suministro y colocación de suelos formado por lamas machihembradas/encoladas de aspecto similar al parquet flotante con un laminado plástico estratificado o un recubrimiento melamínico', 'Actuación técnica', 'Obra menor tarificada', '33,73432', '€/m2' ),
T_TIPO_DATA( 'OM321', 'Suministro y colocación de Valla trasladable de obra o similar de 3,50x2,00 m, formada por panel de malla electrosoldada y postes verticales, acabado galvanizado, colocados sobre bases prefabricadas de hormigón, con malla de ocultación colocada sobre la valla, incluidos todos los trabajos necesarios para su completa y correcta ejecución.', 'Actuación técnica', 'Obra menor tarificada', '8,3', '€/ml' ),
T_TIPO_DATA( 'OM353', 'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda hasta 120 m2', 'Actuación técnica', 'Obra menor tarificada', '1755', '€/ud' ),
T_TIPO_DATA( 'OM354', 'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda entre 121 y 200 m2', 'Actuación técnica', 'Obra menor tarificada', '2003', '€/ud' ),
T_TIPO_DATA( 'OM355', 'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda hasta 120 m2', 'Actuación técnica', 'Obra menor tarificada', '1955', '€/ud' ),
T_TIPO_DATA( 'OM356', 'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda entre 121 y 200 m2', 'Actuación técnica', 'Obra menor tarificada', '2203', '€/ud' ),
T_TIPO_DATA( 'OM357', 'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda hasta 120 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico', 'Actuación técnica', 'Obra menor tarificada', '2038,74', '€/ud' ),
T_TIPO_DATA( 'OM358', 'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda entre 121 y 200 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico', 'Actuación técnica', 'Obra menor tarificada', '2328,14', '€/ud' ),
T_TIPO_DATA( 'OM359', 'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda hasta 120 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico', 'Actuación técnica', 'Obra menor tarificada', '2339,99', '€/ud' ),
T_TIPO_DATA( 'OM360', 'Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda entre 121 y 200 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico', 'Actuación técnica', 'Obra menor tarificada', '2629,39', '€/ud' ),
T_TIPO_DATA( 'OM264', 'Suministro y sustitución de manguera en BIE de 25m (incluyendo material)', 'Actuación técnica', 'Obra menor tarificada', '80,7273', '€/ud' ),
T_TIPO_DATA( 'OM265', 'Suministro y sustitución de manguera en BIE de 45m (incluyendo material)', 'Actuación técnica', 'Obra menor tarificada', '90,4187', '€/ud' ),
T_TIPO_DATA( 'OM38', 'Sustitución de bañera (sin material)', 'Actuación técnica', 'Obra menor tarificada', '82,48', '€/ud' ),
T_TIPO_DATA( 'OM158', 'Sustitución de bisagras puerta de paso', 'Actuación técnica', 'Obra menor tarificada', '24,5378', '€/ud' ),
T_TIPO_DATA( 'OM305', 'Sustitución de bombillo de buzón', 'Actuación técnica', 'Obra menor tarificada', '20', '€/ud' ),
T_TIPO_DATA( 'OM28', 'Sustitución de bote sifónico de PVC', 'Actuación técnica', 'Obra menor tarificada', '90,64552', '€/ud' ),
T_TIPO_DATA( 'OM26', 'Sustitución de bote sifónico normal', 'Actuación técnica', 'Obra menor tarificada', '90,64552', '€/ud' ),
T_TIPO_DATA( 'OM157', 'Sustitución de cerradura puerta de paso', 'Actuación técnica', 'Obra menor tarificada', '36,085', '€/ud' ),
T_TIPO_DATA( 'OM11', 'Sustitución de desagüe de plomo hasta 1 metro (reemplazar por un material autorizado)', 'Actuación técnica', 'Obra menor tarificada', '28,07413', '€/ud ' ),
T_TIPO_DATA( 'OM12', 'Sustitución de desagüe de plomo hasta 2 metros (reemplazar por un material autorizado)', 'Actuación técnica', 'Obra menor tarificada', '48,37452', '€/ud ' ),
T_TIPO_DATA( 'OM13', 'Sustitución de desagüe de plomo hasta 3 metros (reemplazar por un material autorizado)', 'Actuación técnica', 'Obra menor tarificada', '64,04572', '€/ud ' ),
T_TIPO_DATA( 'OM14', 'Sustitución de desagüe de PVC hasta 1 metro ', 'Actuación técnica', 'Obra menor tarificada', '10,79457', '€/ud' ),
T_TIPO_DATA( 'OM15', 'Sustitución de desagüe de PVC hasta 3 metros ', 'Actuación técnica', 'Obra menor tarificada', '38,43568', '€/ud' ),
T_TIPO_DATA( 'OM132', 'Sustitución de diferencial de 2 x 63 A 30 mA', 'Actuación técnica', 'Obra menor tarificada', '80,49908', '€/ud' ),
T_TIPO_DATA( 'OM134', 'Sustitución de diferencial de 4 x 63 A 300 mA', 'Actuación técnica', 'Obra menor tarificada', '210,28276', '€/ud' ),
T_TIPO_DATA( 'OM131', 'Sustitución de diferencial hasta 2 x 40 A 30 mA', 'Actuación técnica', 'Obra menor tarificada', '60,49908', '€/ud' ),
T_TIPO_DATA( 'OM133', 'Sustitución de diferencial hasta 4 x 40 A 300 mA', 'Actuación técnica', 'Obra menor tarificada', '142,11304', '€/ud' ),
T_TIPO_DATA( 'OM37', 'Sustitución de grifería (sin material)', 'Actuación técnica', 'Obra menor tarificada', '21,39325', '€/ud' ),
T_TIPO_DATA( 'OM147', 'Sustitución de hoja de puerta blindada (solo mano de obra)', 'Actuación técnica', 'Obra menor tarificada', '49,23025', '€/ud' ),
T_TIPO_DATA( 'OM146', 'Sustitución de hoja de puerta corredera (solo mano de obra)', 'Actuación técnica', 'Obra menor tarificada', '41,24', '€/ud' ),
T_TIPO_DATA( 'OM145', 'Sustitución de hoja de puerta de paso (solo mano de obra)', 'Actuación técnica', 'Obra menor tarificada', '28,07413', '€/ud' ),
T_TIPO_DATA( 'OM130', 'Sustitución de interruptor, enchufe, timbre Mod. Simón 31 o similar', 'Actuación técnica', 'Obra menor tarificada', '25,26981', '€/ud' ),
T_TIPO_DATA( 'OM135', 'Sustitución de magnetotérmico de 2 x 25 A', 'Actuación técnica', 'Obra menor tarificada', '36,40461', '€/ud' ),
T_TIPO_DATA( 'OM136', 'Sustitución de magnetotérmico de 2 x 40', 'Actuación técnica', 'Obra menor tarificada', '42,80712', '€/ud' ),
T_TIPO_DATA( 'OM137', 'Sustitución de magnetotérmico de 2 x 50', 'Actuación técnica', 'Obra menor tarificada', '68,81925', '€/ud' ),
T_TIPO_DATA( 'OM159', 'Sustitución de manetas puerta de paso', 'Actuación técnica', 'Obra menor tarificada', '25,775', '€/ud' ),
T_TIPO_DATA( 'OM36', 'Sustitución de mecanismo de cisterna (sin material)', 'Actuación técnica', 'Obra menor tarificada', '22,1665', '€/ud' ),
T_TIPO_DATA( 'OM163', 'Sustitución de molduras metro lineal', 'Actuación técnica', 'Obra menor tarificada', '6,76336', '€/ud' ),
T_TIPO_DATA( 'OM148', 'Sustitución de puerta acorazada (solo mano de obra)', 'Actuación técnica', 'Obra menor tarificada', '56,14826', '€/ud' ),
T_TIPO_DATA( 'OM10', 'Sustitución de tramo de bajante fecal con injerto doble', 'Actuación técnica', 'Obra menor tarificada', '116,17308', '€/ml' ),
T_TIPO_DATA( 'OM9', 'Sustitución de tramo de bajante fecal con injerto sencillo', 'Actuación técnica', 'Obra menor tarificada', '92,09923', '€/ml' ),
T_TIPO_DATA( 'OM5', 'Sustitución de tubería bajante general fecales hasta 3 metros', 'Actuación técnica', 'Obra menor tarificada', '129,56577', '€/ud' ),
T_TIPO_DATA( 'OM6', 'Sustitución de tubería bajante PVC general pluviales hasta 3 metros lineales', 'Actuación técnica', 'Obra menor tarificada', '88,09895', '€/ud' ),
T_TIPO_DATA( 'OM20', 'Sustitución de tubería de agua fría y caliente 1 metro lineal cada una', 'Actuación técnica', 'Obra menor tarificada', '70,108', '€/ud' ),
T_TIPO_DATA( 'OM23', 'Sustitución de tubería de agua fría y caliente hasta 6 m 1 cada una', 'Actuación técnica', 'Obra menor tarificada', '212,91181', '€/ud' ),
T_TIPO_DATA( 'OM16', 'Sustitución de tubería de alimentación hasta 1 metro lineal', 'Actuación técnica', 'Obra menor tarificada', '44,05463', '€/ud' ),
T_TIPO_DATA( 'OM17', 'Sustitución de tubería de alimentación hasta 2 metros lineales', 'Actuación técnica', 'Obra menor tarificada', '60,3135', '€/ud' ),
T_TIPO_DATA( 'OM18', 'Sustitución de tubería de alimentación hasta 3 metros lineales', 'Actuación técnica', 'Obra menor tarificada', '78,8715', '€/ud' ),
T_TIPO_DATA( 'OM19', 'Sustitución de tubería de alimentación hasta 6 metros lineales', 'Actuación técnica', 'Obra menor tarificada', '147,9485', '€/ud' ),
T_TIPO_DATA( 'OM7', 'Sustitución de tubería general de alimentación hasta 3 m 1 Pulgada', 'Actuación técnica', 'Obra menor tarificada', '87,635', '€/ud' ),
T_TIPO_DATA( 'OM8', 'Sustitución de tubería general de alimentación hasta 3m 2 Pulgadas', 'Actuación técnica', 'Obra menor tarificada', '117,534', '€/ud' ),
T_TIPO_DATA( 'OM30', 'Sustitución de válvula y rebosadero de bañera ', 'Actuación técnica', 'Obra menor tarificada', '25,69252', '€/ud' ),
T_TIPO_DATA( 'OM25', 'Sustitución manguetón plomo (Incluido desmontar y montar inodoro) (reemplazar por un material autorizado)', 'Actuación técnica', 'Obra menor tarificada', '152,23746', '€/ud ' ),
T_TIPO_DATA( 'OM24', 'Sustitución manguetón PVC (Incluido desmontar y montar inodoro)', 'Actuación técnica', 'Obra menor tarificada', '111,8635', '€/ud' ),
T_TIPO_DATA( 'OM21', 'Sustitución tubería de agua fría y caliente 2 metros lineales cada una ', 'Actuación técnica', 'Obra menor tarificada', '99,55336', '€/ud' ),
T_TIPO_DATA( 'OM22', 'Sustitución tubería de agua fría y caliente hasta 3 metros lineales cada una', 'Actuación técnica', 'Obra menor tarificada', '140,57685', '€/ud' ),
T_TIPO_DATA( 'OM162', 'Sustituir puerta de armario (Sin material)', 'Actuación técnica', 'Obra menor tarificada', '19,43435', '€/ud' ),
T_TIPO_DATA( 'OM289', 'Tala de árbol < 6 m de altura sacando el tocón', 'Actuación técnica', 'Obra menor tarificada', '118,58562', '€/ud' ),
T_TIPO_DATA( 'OM290', 'Tala de árbol < 6 m de altura sin sacar el tocón', 'Actuación técnica', 'Obra menor tarificada', '75,72695', '€/ud' ),
T_TIPO_DATA( 'OM291', 'Tala de árbol 10/15m de altura sacando el tocón', 'Actuación técnica', 'Obra menor tarificada', '570,35951', '€/ud' ),
T_TIPO_DATA( 'OM292', 'Tala de árbol 10/15m de altura sin sacar el tocón', 'Actuación técnica', 'Obra menor tarificada', '455,91851', '€/ud' ),
T_TIPO_DATA( 'OM293', 'Tala de árbol 6/10m de altura sacando el tocón', 'Actuación técnica', 'Obra menor tarificada', '170,36244', '€/ud' ),
T_TIPO_DATA( 'OM294', 'Tala de árbol 6/10m de altura sin sacar el tocón', 'Actuación técnica', 'Obra menor tarificada', '110,27576', '€/m3' ),
T_TIPO_DATA( 'OM109', 'Taladros grosor de 7 a 10 mm, hasta 25 mm de diámetros', 'Actuación técnica', 'Obra menor tarificada', '5,83546', '€/ud' ),
T_TIPO_DATA( 'OM108', 'Taladros grosor hasta 6 mm, hasta 25 mm de diámetro', 'Actuación técnica', 'Obra menor tarificada', '4,10338', '€/ud' ),
T_TIPO_DATA( 'OM107', 'Taladros punto de luces (metro lineal o unidad)', 'Actuación técnica', 'Obra menor tarificada', '14,89795', '€/ud' ),
T_TIPO_DATA( 'OM57', 'Tapar 1 m² de techo de escayola', 'Actuación técnica', 'Obra menor tarificada', '50,94171', '€/ud' ),
T_TIPO_DATA( 'OM56', 'Tapar 1/2 m² de techo de escayola', 'Actuación técnica', 'Obra menor tarificada', '40,60078', '€/ud' ),
T_TIPO_DATA( 'OM58', 'Tapar 2 m² de techo de escayola', 'Actuación técnica', 'Obra menor tarificada', '63,4065', '€/ud' ),
T_TIPO_DATA( 'OM59', 'Tapar 3 m² de techo de escayola', 'Actuación técnica', 'Obra menor tarificada', '84,70696', '€/ud' ),
T_TIPO_DATA( 'OM66', 'Tapar cala con alicatado o solado 1 m²', 'Actuación técnica', 'Obra menor tarificada', '33,5075', '€/ud' ),
T_TIPO_DATA( 'OM65', 'Tapar cala con alicatado o solado 1/2 m²', 'Actuación técnica', 'Obra menor tarificada', '22,1665', '€/ud' ),
T_TIPO_DATA( 'OM67', 'Tapar cala con alicatado o solado 2 m²', 'Actuación técnica', 'Obra menor tarificada', '79,9025', '€/ud' ),
T_TIPO_DATA( 'OTR3', 'Redacción de proyecto técnico para su visado (sin tasas de visado) módulo mínimo', 'Obtención documentación', 'Obtención certificados y documentación', '400', '€/ud' ),
T_TIPO_DATA( 'OTR4', 'Redacción de proyecto técnico para su visado (sin tasas de visado)', 'Obtención documentación', 'Obtención certificados y documentación', '0,04', '%PEM' ),
T_TIPO_DATA( 'OTR5', 'Proyecto y dirección de obra (un solo técnico) 10.000 - 60.000 €', 'Obtención documentación', 'Obtención certificados y documentación', '0,07', '%PEM' ),
T_TIPO_DATA( 'OTR6', 'Proyecto y dirección de obra (un solo técnico) >60.000 €', 'Obtención documentación', 'Obtención certificados y documentación', '0,05', '%PEM' ),
T_TIPO_DATA( 'OM68', 'Tapar cala con alicatado o solado 3 m²', 'Actuación técnica', 'Obra menor tarificada', '103,1', '€/ud' ),
T_TIPO_DATA( 'OM64', 'Tapar cala enlucido una o dos caras 1 m²', 'Actuación técnica', 'Obra menor tarificada', '29,14637', '€/ud' ),
T_TIPO_DATA( 'OTR7', 'Levantamiento topográfico (Día de trabajo de campo hasta 8h Desp < 100km)', 'Obtención documentación', 'Obtención certificados y documentación', '300', '€/dia' ),
T_TIPO_DATA( 'OM63', 'Tapar cala enlucido una o dos caras 1/2 m²', 'Actuación técnica', 'Obra menor tarificada', '20,62', '€/ud' ),
T_TIPO_DATA( 'OM82', 'Tapar cala hormigón 1 m²', 'Actuación técnica', 'Obra menor tarificada', '30,93', '€/ud' ),
T_TIPO_DATA( 'OM83', 'Tapar cala hormigón m² adicional', 'Actuación técnica', 'Obra menor tarificada', '20,62', '€/m2' ),
T_TIPO_DATA( 'OM60', 'Tapar m² adicional (a partir de 3 m²) de techo de escayola', 'Actuación técnica', 'Obra menor tarificada', '24,09447', '€/m2' ),
T_TIPO_DATA( 'OM254', 'Tapiado con fábrica de bloque de hormigón armado', 'Actuación técnica', 'Tapiado', '34', '€/m2' ),
T_TIPO_DATA( 'OM253', 'Tapiado con fábrica de ladrillo de 1/2 pie', 'Actuación técnica', 'Tapiado', '23', '€/m2' ),
T_TIPO_DATA( 'OM255', 'Tapiado con malla armada plastificada Pecafil, fabricada por Max Frank GmbH & Co. KG, o similar', 'Actuación técnica', 'Tapiado', '10,7366666666667', '€/m2' ),
T_TIPO_DATA( 'OM40', 'Temple liso, hasta 10 m²', 'Actuación técnica', 'Obra menor tarificada', '46,23004', '€/ud' ),
T_TIPO_DATA( 'OM41', 'Temple liso, metro cuadrado adicional (a partir de 10 m²)', 'Actuación técnica', 'Obra menor tarificada', '2,96928', '€/m2' ),
T_TIPO_DATA( 'OM42', 'Temple picado, hasta 10 m²', 'Actuación técnica', 'Obra menor tarificada', '34,62098', '€/ud' ),
T_TIPO_DATA( 'OM43', 'Temple picado, metro cuadrado adicional (a partir de 10 m²)', 'Actuación técnica', 'Obra menor tarificada', '3,41261', '€/m2' ),
T_TIPO_DATA( 'OM298', 'Terraplenado con tierras adecuadas 95% PM', 'Actuación técnica', 'Obra menor tarificada', '3,48478', '€/m3' ),
T_TIPO_DATA( 'OM299', 'Terraplenado con zahorra artificial 95% PM', 'Actuación técnica', 'Obra menor tarificada', '15,88771', '€/m3' ),
T_TIPO_DATA( 'OM122', 'Toma de corriente con toma de tierra lateral de 16 A', 'Actuación técnica', 'Obra menor tarificada', '27,2184', '€/ud' ),
T_TIPO_DATA( 'OM123', 'Toma de corriente con toma de tierra lateral de 20 A', 'Actuación técnica', 'Obra menor tarificada', '31,53829', '€/ud' ),
T_TIPO_DATA( 'OM124', 'Toma de corriente con toma de tierra lateral de 25 A', 'Actuación técnica', 'Obra menor tarificada', '36,02314', '€/ud' ),
T_TIPO_DATA( 'OM121', 'Toma de corriente de 10 A', 'Actuación técnica', 'Obra menor tarificada', '20,42411', '€/ud' ),
T_TIPO_DATA( 'BOL4', 'Emisión de Proyecto y Boletín de legalización de instalación eléctrica en local comercial superior a 1500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.', 'Obtención documentación', 'Boletín electricidad', '550', '€/ud' ),
T_TIPO_DATA( 'OM100', 'Tres lunas antibala 10+10+2,5 mm (metro cuadrado)', 'Actuación técnica', 'Obra menor tarificada', '341,69402', '€/m2' ),
T_TIPO_DATA( 'OM99', 'Tres lunas antirrobo 6+6+6 mm (metro cuadrado)', 'Actuación técnica', 'Obra menor tarificada', '137,123', '€/m2' ),
T_TIPO_DATA( 'OM230', 'Ud Colocación de caja general de protección de la vivienda según normativa de instalación, totalmente terminada', 'Actuación técnica', 'Obra menor tarificada', '107,224', '€/ud' ),
T_TIPO_DATA( 'OM215', 'Ud Desinsectación contra todo tipo de insectos voladores o rastreros, incluido certificado. (Superficie hasta 400 m²)', 'Actuación técnica', 'Obra menor tarificada', '166,666666666667', '€/ud' ),
T_TIPO_DATA( 'OM236', 'Ud Instalación de salida de humos calentador, de chapa de acero de 150mm, sin incluir perforación de fachada, aunque sí su sellado y resolución de encuentros', 'Actuación técnica', 'Obra menor tarificada', '216,51', '€/ud' ),
T_TIPO_DATA( 'OM232', 'Ud Instalación de toma de corriente para calentador, incluido cableado, mecanismo de superficie o empotrado y canaleta', 'Actuación técnica', 'Obra menor tarificada', '31,91976', '€/ud' ),
T_TIPO_DATA( 'OM237', 'Ud Instalación fontanería para calentador', 'Actuación técnica', 'Obra menor tarificada', '61,86', '€/ud' ),
T_TIPO_DATA( 'OM340', 'Ud Instalación fontanería para termo. Dejando instalación lista para colocación.', 'Actuación técnica', 'Obra menor tarificada', '60', '€/ud' ),
T_TIPO_DATA( 'OM213', 'Ud Limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escombros, etc. (utilizando un contenedor de aprox 6 m3) Gestión de residuos incluida', 'Actuación técnica', 'Limpieza', '194,49815', '€/ud' ),
T_TIPO_DATA( 'OM212', 'Ud Limpieza general del inmueble: retirada de basuras, restos de comida, etc… sin contenedor (únicamente bolsas). Gestión de residuos incluida. Hasta 1 m3', 'Actuación técnica', 'Limpieza', '66,75725', '€/ud' ),
T_TIPO_DATA( 'OM229', 'Ud Repaso de instalación eléctrica y telecomunicaciones de vivienda NO incluida la colocación de las tapas de cajas y mecanismos faltantes', 'Actuación técnica', 'Obra menor tarificada', '119,0805', '€/ud' ),
T_TIPO_DATA( 'OM380', 'Ud Revisión de instalación fontanería en local comercial de más de 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente', 'Actuación técnica', 'Obra menor tarificada', '262,905', '€/ud' ),
T_TIPO_DATA( 'OM378', 'Ud Revisión de instalación fontanería en vivienda, incluyendo pruebas de presión, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente', 'Actuación técnica', 'Obra menor tarificada', '157,743', '€/ud' ),
T_TIPO_DATA( 'OM250', 'Ud Revisión de la instalación de gas de vivienda', 'Actuación técnica', 'Obra menor tarificada', '49,488', '€/ud' ),
T_TIPO_DATA( 'OM350', 'Ud Revisión y prueba de instalación eléctrica, telecomunicaciones y video portero en vivienda, incluso rotulación de cuadro eléctrico sin considerar elementos de protección o mecanismos que pudieran faltar.', 'Actuación técnica', 'Obra menor tarificada', '72,75', '€/ud' ),
T_TIPO_DATA( 'OM246', 'Ud suministro de llave magnética codificada', 'Actuación técnica', 'Obra menor tarificada', '9,279', '€/ud' ),
T_TIPO_DATA( 'OM247', 'Ud suministro de mando de garaje codificado ', 'Actuación técnica', 'Obra menor tarificada', '40', '€/ud' ),
T_TIPO_DATA( 'BOL1', 'Emisión de proyecto y boletín de legalización de instalación eléctrica en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos', 'Obtención documentación', 'Boletín electricidad', '150', '€/ud' ),
T_TIPO_DATA( 'BOL2', 'Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos', 'Obtención documentación', 'Boletín electricidad', '257,75', '€/ud' ),
T_TIPO_DATA( 'BOL3', 'Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 1500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos', 'Obtención documentación', 'Boletín electricidad', '412,4', '€/ud' ),
T_TIPO_DATA( 'OM241', 'Ud Suministro e instalación de bidet cerámico color estándar a elegir, sin incluir grifería', 'Actuación técnica', 'Obra menor tarificada', '90,1983333333333', '€/ud' ),
T_TIPO_DATA( 'OM251', 'Ud Suministro e instalación de caldera de condensación de gas de vivienda, incluyendo la instalación de ventilación, el boletín y la legalización.', 'Actuación técnica', 'Obra menor tarificada', '1488,33333333333', '€/ud' ),
T_TIPO_DATA( 'OM245', 'Ud Suministro e instalación de descarga de inodoro', 'Actuación técnica', 'Obra menor tarificada', '39,0315', '€/ud' ),
T_TIPO_DATA( 'OM239', 'Ud Suministro e instalación de fregadero de cocina metálico, de hasta 90 cm de anchura, con senos y/o escurridor', 'Actuación técnica', 'Obra menor tarificada', '162,30002', '€/ud' ),
T_TIPO_DATA( 'OM243', 'Ud Suministro e instalación de inodoro cerámico color estándar a elegir, con tanque bajo', 'Actuación técnica', 'Obra menor tarificada', '135,416666666667', '€/ud' ),
T_TIPO_DATA( 'OM211', 'Ud suministro e instalación puerta abatible de 3x2 m., candado incluido. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos', 'Actuación técnica', 'Obra menor tarificada', '280', '€/ud' ),
T_TIPO_DATA( 'OM210', 'Ud suministro e instalación puerta metálica de malla de acero galvanizado para acceso peatonal (0,8 - 1m) de paso, candado incluido. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos', 'Actuación técnica', 'Obra menor tarificada', '179,666666666667', '€/ud' ),
T_TIPO_DATA( 'OM240', 'Ud Suministro e instalación Rejilla de baño', 'Actuación técnica', 'Obra menor tarificada', '9,279', '€/ud' ),
T_TIPO_DATA( 'OM231', 'Ud Suministro y colocación de timbre. Con instalación de cableado', 'Actuación técnica', 'Obra menor tarificada', '34,60036', '€/ud' ),
T_TIPO_DATA( 'OM235', 'Ud Suministro y colocación Termo eléctrico 100 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado ', 'Actuación técnica', 'Obra menor tarificada', '288,066666666667', '€/ud' ),
T_TIPO_DATA( 'OM234', 'Ud Suministro y colocación Termo eléctrico 50 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado', 'Actuación técnica', 'Obra menor tarificada', '220,64', '€/ud' ),
T_TIPO_DATA( 'OM381', 'Ud Suministro y colocación Termo eléctrico 75 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado', 'Actuación técnica', 'Obra menor tarificada', '265,65', '€/ud' ),
T_TIPO_DATA( 'OM238', 'Ud Sustitución de llave de paso ', 'Actuación técnica', 'Obra menor tarificada', '30,93', '€/ud' ),
T_TIPO_DATA( 'OM315', 'UD. Ajuste o reparación de cierres de carpintería metálica abatible. Ventana o puerta', 'Actuación técnica', 'Obra menor tarificada', '5', '€/ud' ),
T_TIPO_DATA( 'OM314', 'UD. Ajuste o reparación de cierres de carpintería metálica corredera. Ventana o puerta', 'Actuación técnica', 'Obra menor tarificada', '3,5', '€/ud' ),
T_TIPO_DATA( 'OM34', 'Únicamente sustitución de sanitario', 'Actuación técnica', 'Obra menor tarificada', '39,178', '€/ud' ),
T_TIPO_DATA( 'OM39', 'Unidad de desatasco en vivienda particular (En ciudad)', 'Actuación técnica', 'Obra menor tarificada', '107,224', '€/ud' ),
T_TIPO_DATA( 'OM322', 'Vallado de 2m de altura, compuesto por paneles opacos de chapa perfilada nervada de acero UNE-EN 10346 S320 GD galvanizado de 0,6 mm espesor y 30 mm altura de cresta, incluidos postes de sujeción cada 2ml.', 'Actuación técnica', 'Obra menor tarificada', '29,22', '€/ml' ),
T_TIPO_DATA( 'OM288', 'Visita para verificación de activo', 'Actuación técnica', 'Obra menor tarificada', '36,085', '€/ud' ),
T_TIPO_DATA( 'CEE1', 'Vivienda suelta con documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '70', '(1-30) €/unidad' ),
T_TIPO_DATA( 'CEE10', 'Promociones (viviendas integradas en una promoción) con documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '730', 'Más de 121 €/promoción' ),
T_TIPO_DATA( 'CEE11', 'Promociones (viviendas integradas en una promoción) sin documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '550', '(4-30) €/promoción' ),
T_TIPO_DATA( 'CEE12', 'Promociones (viviendas integradas en una promoción) sin documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '660', '(31-60) €/promoción' ),
T_TIPO_DATA( 'CEE13', 'Promociones (viviendas integradas en una promoción) sin documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '760', '(61-120) €/promoción' ),
T_TIPO_DATA( 'CEE14', 'Promociones (viviendas integradas en una promoción) sin documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '840', 'Más de 121 €/promoción' ),
T_TIPO_DATA( 'CEE15', 'Terciario (local comercial y oficina) con documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '101', '< 10 Oficinas €/unidad' ),
T_TIPO_DATA( 'CEE16', 'Terciario (local comercial y oficina) con documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '94', '(10-50) €/unidad' ),
T_TIPO_DATA( 'CEE17', 'Terciario (local comercial y oficina) con documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '87', '> 50 €/unidad' ),
T_TIPO_DATA( 'CEE18', 'Terciario (local comercial y oficina) sin documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '113', '<10 €/unidad' ),
T_TIPO_DATA( 'CEE19', 'Terciario (local comercial y oficina) sin documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '104', '(10-50) €/unidad' ),
T_TIPO_DATA( 'CEE2', 'Vivienda suelta con documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '70', '(31-60) €/unidad' ),
T_TIPO_DATA( 'CEE20', 'Terciario (local comercial y oficina) sin documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '97', '>50 €/unidad' ),
T_TIPO_DATA( 'CEE3', 'Vivienda suelta con documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '70', 'Más de 60 €/unidad' ),
T_TIPO_DATA( 'CEE4', 'Vivienda suelta sin documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '70', '(1-30) €/unidad' ),
T_TIPO_DATA( 'CEE5', 'Vivienda suelta sin documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '70', '(31-60) €/unidad' ),
T_TIPO_DATA( 'CEE6', 'Vivienda suelta sin documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '70', 'Más de 60 €/unidad' ),
T_TIPO_DATA( 'CEE7', 'Promociones (viviendas integradas en una promoción) con documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '450', '(4-30) €/promoción' ),
T_TIPO_DATA( 'CEE8', 'Promociones (viviendas integradas en una promoción) con documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '550', '(31-60) €/promoción' ),
T_TIPO_DATA( 'CEE9', 'Promociones (viviendas integradas en una promoción) con documentación del activo', 'Obtención documentación', 'Certificado Eficiencia Energética (CEE)', '590', '(61-120) €/promoción' )

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-------------------------------------------------------------------------------------------------------
	-- Se cambia de subtipo las partidas:

	
	DBMS_OUTPUT.PUT_LINE('[INFO]: se cambia de subtipo a Limpieza ');

	V_MSQL := ' UPDATE REM01.ACT_CFT_CONFIG_TARIFA
		    SET DD_STR_ID = (   SELECT DD_STR_ID 
					FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_DESCRIPCION = ''Limpieza''),
		    USUARIOMODIFICAR = ''REMVIP_6411'',
		    FECHAMODIFICAR = SYSDATE
		    WHERE 1 = 1
		    AND DD_TTF_ID IN ( SELECT DD_TTF_ID 
				       FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO IN ( ''AP-OM192'',
													''AP-OM212'',
													''AP-OM213'',
													''AP-OM214'',
													''AP-OM279'',
													''AP-OM280'',
													''AP-OM283'',
													''AP-OM284'',
													''AP-OM318'',
													''AP-OM319'',
													''AP-OM320'',
													''AP-OM366'' ) )
		   AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_DESCRIPCION = ''Actuación técnica'')  
		   AND DD_SCR_ID IN ( SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO IN ( ''138'', ''150'' ) )
		   AND BORRADO = 0';



	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_CFT_CONFIG_TARIFA ');  


-------------------

	DBMS_OUTPUT.PUT_LINE('[INFO]: se cambia de subtipo a Tapiado ');
	V_MSQL := ' UPDATE REM01.ACT_CFT_CONFIG_TARIFA
		    SET DD_STR_ID = (   SELECT DD_STR_ID 
					FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_DESCRIPCION = ''Tapiado''),
		    USUARIOMODIFICAR = ''REMVIP_6411'',
		    FECHAMODIFICAR = SYSDATE
		    WHERE 1 = 1
		    AND DD_TTF_ID IN ( SELECT DD_TTF_ID 
				       FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO IN ( ''AP-OM253'',
													''AP-OM254'',
													''AP-OM255'' ) )
		   AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_DESCRIPCION = ''Actuación técnica'')  
		   AND DD_SCR_ID IN ( SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO IN ( ''138'', ''150'' ) )
		   AND BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en ACT_CFT_CONFIG_TARIFA ');  
	


	-------------------------------------------------------------------------------------------------------
	-- Se actualizan los nuevos valores:
	-- se itera por el array
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		------------------------------------------------------------------
		-- Se trata apple:

		
		V_MSQL := ' SELECT COUNT(1) FROM REM01.ACT_CFT_CONFIG_TARIFA
			    WHERE 1 = 1
			    AND DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = ''AP-'' || '''||TRIM(V_TMP_TIPO_DATA(1))||''')
		 	    AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''')    			 
			    AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||''')
			    AND DD_CRA_ID = ( SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'' )
			    AND DD_SCR_ID = ( SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'' ) ';
			
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
		IF ( V_NUM = 0 ) THEN

		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

			V_MSQL := 
		'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		 ( CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, DD_SCR_ID, CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, 
		   VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                 SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL AS CFT_ID, 
		 (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = ''AP-'' || '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
		 (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),    			 (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||'''),

                 DD_CRA_ID,
		 DD_SCR_ID,

                 TO_NUMBER( REPLACE( ''' || TRIM(V_TMP_TIPO_DATA(5))||''', '','', ''.'' ) ), '''||TRIM(V_TMP_TIPO_DATA(6))||''', 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0 
		 FROM REM01.DD_SCR_SUBCARTERA
	         WHERE DD_SCR_CODIGO IN ( ''138'' )
		 AND BORRADO = 0 ';

		 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
 		
		ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

		V_MSQL := 
		'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		 SET  	CFT_PRECIO_UNITARIO = TO_NUMBER( REPLACE( ''' || TRIM(V_TMP_TIPO_DATA(5))||''', '','', ''.'' ) ),
			CFT_UNIDAD_MEDIDA = '''||TRIM(V_TMP_TIPO_DATA(6))||''',
			USUARIOMODIFICAR = ''REMVIP-6411'',
			FECHAMODIFICAR = SYSDATE
		 WHERE 1 = 1
		 AND DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = ''AP-'' || '''||TRIM(V_TMP_TIPO_DATA(1))||''')
		 AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''')    			 
		 AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||''')

	 	 AND DD_CRA_ID = ( SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'' )
		 AND DD_SCR_ID = ( SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'' )';

		 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');
			

		END IF;

		------------------------------------------------------------------
		-- Se trata DIVARIAN:

		
		V_MSQL := ' SELECT COUNT(1) FROM REM01.ACT_CFT_CONFIG_TARIFA
			    WHERE 1 = 1
			    AND DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = ''AP-'' || '''||TRIM(V_TMP_TIPO_DATA(1))||''')
		 	    AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''')    			 
			    AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||''')
			    AND DD_CRA_ID = ( SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'' )
			    AND DD_SCR_ID = ( SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''150'' ) ';
		
		
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
	
		IF ( V_NUM = 0 ) THEN

		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

			V_MSQL := 
		'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		 ( CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, DD_SCR_ID, CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, 
		   VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                 SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL AS CFT_ID, 
		 (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = ''AP-'' || '''||TRIM(V_TMP_TIPO_DATA(1))||'''),
		 (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),    			 (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||'''),

                 DD_CRA_ID,
		 DD_SCR_ID,

                 TO_NUMBER( REPLACE( ''' || TRIM(V_TMP_TIPO_DATA(5))||''', '','', ''.'' ) ), '''||TRIM(V_TMP_TIPO_DATA(6))||''', 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0 
		 FROM REM01.DD_SCR_SUBCARTERA
	         WHERE DD_SCR_CODIGO IN ( ''150'' )
		 AND BORRADO = 0 ';

		 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
 		
		ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO]: SE ACTUALIZA EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

			V_MSQL := 
		'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
		 SET  	CFT_PRECIO_UNITARIO = TO_NUMBER( REPLACE( ''' || TRIM(V_TMP_TIPO_DATA(5))||''', '','', ''.'' ) ),
			CFT_UNIDAD_MEDIDA = '''||TRIM(V_TMP_TIPO_DATA(6))||''',
			USUARIOMODIFICAR = ''REMVIP-6411'',
			FECHAMODIFICAR = SYSDATE
		 WHERE 1 = 1
		 AND DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = ''AP-'' || '''||TRIM(V_TMP_TIPO_DATA(1))||''')
		 AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''')    			 
		 AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||''')

	 	 AND DD_CRA_ID = ( SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'' )
		 AND DD_SCR_ID = ( SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''150'' )';

		 EXECUTE IMMEDIATE V_MSQL;

		 DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ACTUALIZADO CORRECTAMENTE');
			

		END IF;


	END LOOP;



	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado el tarifario de apple y divarian ');


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
