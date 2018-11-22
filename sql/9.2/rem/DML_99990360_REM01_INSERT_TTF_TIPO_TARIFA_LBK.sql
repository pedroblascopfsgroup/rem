--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2052
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
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-2052'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
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
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('0001APE','Vivienda '),
		T_TIPO_DATA('0002APE','Portal'),
		T_TIPO_DATA('0003APE','Apertura de puerta interior (viviendas)'),
		T_TIPO_DATA('0001CDB','Vivienda (gama media) Tesa, interfer, escurra ó similar'),
		T_TIPO_DATA('0002CDB','Vivienda (gama alta)'),
		T_TIPO_DATA('0003CDB','Cambio de mandos (garajes,...)'),
		T_TIPO_DATA('0004CDB','Cambio de Bombin buzones'),
		T_TIPO_DATA('0005CDB','Cambio de bombin Gama baja (Portal, trasteros, cancelas, etc)'),
		T_TIPO_DATA('0006CDB','Candado con cadena (actuacion aislada)'),
		T_TIPO_DATA('0007CDB','Candado con cadena (servicio integrado en una petición múltiple)'),
		T_TIPO_DATA('0001GNL','Realización de copia de nuevas copias de llaves'),
		T_TIPO_DATA('0002GNL','Codificación de llaves'),
		T_TIPO_DATA('0003GNL','Distribución de llaves'),
		T_TIPO_DATA('0001LMO','Viviendas menores de 80m2'),
		T_TIPO_DATA('0002LMO','Viviendas de 80 a 100 m2'),
		T_TIPO_DATA('0003LMO','Viviendas de 100 a 120 m2'),
		T_TIPO_DATA('0004LMO','Viviendas de 120 a 150 m2'),
		T_TIPO_DATA('0005LMO','Viviendas de más de 150 m2'),
		T_TIPO_DATA('0001LGF','Viviendas de menores de 80m2'),
		T_TIPO_DATA('0002LGF','Viviendas de 80 a 100 m2'),
		T_TIPO_DATA('0003LGF','Viviendas de 100 a 150 m2'),
		T_TIPO_DATA('0004LGF','Viviendas de más de 150 m2'),
		T_TIPO_DATA('0005LGF','Limpieza general del la urbanización'),
		T_TIPO_DATA('0001OTL','Ud. Retirada de nidos o elementos de chimeneas'),
		T_TIPO_DATA('0002OTL','Ud. Retirada y tratamiento de avisperos.'),
		T_TIPO_DATA('0003OTL','Ud. Limpieza de terraza exterior < de 30 m2. Incluidos los imbornales, sumideros y elementos existentes.'),
		T_TIPO_DATA('0004OTL','M2 extra de Limpieza de tarraza exterior  > de 30 m2. Incluidos los imbornales, sumideros y elemnentos existentes.'),
		T_TIPO_DATA('0005OTL','Limpieza de sumidero en cubierta / patio / garaje.'),
		T_TIPO_DATA('0006OTL','Limpieza de arqueta de cualquier tipo.'),
		T_TIPO_DATA('0007OTL','Limpieza y desatranco de canaletas e cubierta / patio / garaje con retirada de escombro a vertedero.'),
		T_TIPO_DATA('0008OTL','Limpieza de canalones de cualquier material y sección.'),
		T_TIPO_DATA('0001ASS','Adecuación de suelos ( limpieza de solar, suelo urbanizable, suelo rústico)'),
		T_TIPO_DATA('0002ASS','Desbroces, sin arbolado, superficie < 200 m². Transporte a vertedero'),
		T_TIPO_DATA('0003ASS','Desbroces, sin arbolado, superficie entre 200 m² y 500 m². Transporte a vertedero.'),
		T_TIPO_DATA('0004ASS','Desbroces, sin arbolado, superficie entre 500 m² y 1.000 m². Transporte a vertedero.'),
		T_TIPO_DATA('0005ASS','Desbroces, sin arbolado, superficie entre 1000 m² y 5.000 m². Transporte a vertedero'),
		T_TIPO_DATA('0006ASS','Desbroces, sin arbolado, superficie entre 5000 m² y 10.000 m². Transporte a vertedero'),
		T_TIPO_DATA('0007ASS','Tratamiento retardador malas hierbas'),
		T_TIPO_DATA('0008ASS','Cerramiento de bloque de hormigón 40x20x20 de hasta 50m2 realizar'),
		T_TIPO_DATA('0009ASS','Cerramiento de bloque de hormigón 40x20x20 de 50 a100 m2'),
		T_TIPO_DATA('0010ASS','Cerramiento de bloque de hormigón 40x20x20 de 100 a 200 m2'),
		T_TIPO_DATA('0011ASS','Cerramiento de Ladrillo de 11cm de espesor,realizada con ladrillos cerámicos huecos de 33x16x11cm hasta 50m2'),
		T_TIPO_DATA('0012ASS','Cerramiento de Ladrillo de 11cm de espesor,realizada con ladrillos cerámicos huecos de 33x16x11cm de 50 m2 a 100 m2'),
		T_TIPO_DATA('0013ASS','Cerramiento de Ladrillo de 11cm de espesor,realizada con ladrillos cerámicos huecos de 33x16x11cm de 100 m2 a 200 m2'),
		T_TIPO_DATA('0014ASS','Cerramiento de ladrillo panal, de 11.5cm de espesor, realizada con ladrillos cerámicosperforados de 24x11.5x9cm hasta 50m2'),
		T_TIPO_DATA('0015ASS','Cerramiento de ladrillo panal, de 11.5cm de espesor, realizada con ladrillos cerámicosperforados de 24x11.5x9cm de 50m2 a 100m2'),
		T_TIPO_DATA('0016ASS','Cerramiento de ladrillo panal, de 11.5cm de espesor, realizada con ladrillos cerámicosperforados de 24x11.5x9cm de 100m2 a 200m2'),
		T_TIPO_DATA('0017ASS','Puerta de paso peatonal'),
		T_TIPO_DATA('0018ASS','Puerta de acceso vehículos/c. colocación de cadena con candado'),
		T_TIPO_DATA('0019ASS','Perimetral solar /simple torsión <100 ml 24 horas 3 días'),
		T_TIPO_DATA('0020ASS','Vallado perimetral solar /simple torsión <100 ml incluyendo la realizacion de pozos cada 3ml para la fijación de postes incluso hormigonado de los mismos'),
		T_TIPO_DATA('0021ASS','Vallado perimetral solar /simple torsión >100 ml'),
		T_TIPO_DATA('0022ASS','Vallado perimetral solar /simple torsión >100 ml incluyendo la realizacion de pozos cada 3ml para la fijación de postes incluso hormigonado de los mismos'),
		T_TIPO_DATA('0001DDV','Ud Desinsectación contra todo tipo de insectos voladores o rastreros, Sin certificado certificado. (Superficie hasta 400 m2)'),
		T_TIPO_DATA('0002DDV','Ud Desinsectación contra todo tipo de insectos voladores o rastreros, con certificado. (Superficie hasta 400 m2)'),
		T_TIPO_DATA('0003DDV','Ud Desratización con anticoagulantes, administrados mediante cebos, incluido certificado. (Superficie hasta 400 m2)'),
		T_TIPO_DATA('0004DDV','Ud Desinfección contra hongos, virus y bacterias, incluido certificado. (Sup. Hasta 400 m2)'),
		T_TIPO_DATA('0005DDV','Viviendas (desinfección y desinsectación)'),
		T_TIPO_DATA('0006DDV','Viviendas (desratización 80/150 m2)'),
		T_TIPO_DATA('0007DDV','Desinfección general de la urbanización'),
		T_TIPO_DATA('0008DDV','Desinfección de suelos'),
		T_TIPO_DATA('0009DDV','Colocación de barreras (garaje)'),
		T_TIPO_DATA('0001VEM','Vaciado de enseres y mobiliario hasta 5 m3 (1contenedor/o recogida en vehículo habilitado)'),
		T_TIPO_DATA('0002VEM','Vaciado de enseres y mobiliario +5m3 (segundo contenedor y sucesivos'),
		T_TIPO_DATA('0003VEM','Desahucios: vaciado de enseres abandonados ( vaciado con bolsas de basura)'),
		T_TIPO_DATA('0004VEM','Gestión de alta/ baja de suministros'),
		T_TIPO_DATA('0005VEM','Informe de estado, incluyendo el reportaje fotográfica. Según modelo HRE'),
		T_TIPO_DATA('0001LAS','PA Trámites Oficinas suministradoras'),
		T_TIPO_DATA('0002LAS','PA Trámites Entidades Locales'),
		T_TIPO_DATA('0003LAS','Emisión de proyecto y boletín de legalización de instalación eléctrica en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.'),
		T_TIPO_DATA('0004LAS','Emisión de boletín de legalización de instalación eléctrica en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.'),
		T_TIPO_DATA('0005LAS','Emisión de boletín de legalización de instalación de gas en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.'),
		T_TIPO_DATA('0006LAS','Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 1500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.'),
		T_TIPO_DATA('0007LAS','PA Obtención/Tramitación de Boletín Agua'),
		T_TIPO_DATA('0008LAS','Emisión de proyecto y boletín de legalización de instalación de gas en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.'),
		T_TIPO_DATA('0009LAS','PA Obtención/Tramitación de Nueva cédula de habitabilidad'),
		T_TIPO_DATA('0010LAS','PA Obtención/Tramitación de Duplicado de LPO o Cédula'),
		T_TIPO_DATA('0011LAS','Hr Técnico en elaboración de informes o realización de gestiones'),
		T_TIPO_DATA('0012LAS','Emisión de CEE. Incluso registro y emisión de etiqueta'),
		T_TIPO_DATA('0013LAS','Revisión según normativa incluso gestión de OCA de Instalaciones Electricas de BT en edificios residenciales. Garaje, Zonas comunes, Portales y Piscina'),
		T_TIPO_DATA('0014LAS','Revisión según normativa incluso gestión de OCA de Instalaciones Electricas de BT en edificios de oficinas Garaje y  Zonas comunes,'),
		T_TIPO_DATA('0015LAS','Revisión según normativa incluso gestión de OCA de Instalaciones Electricas de MT. Centro de Transformación'),
		T_TIPO_DATA('0016LAS','Revisión según normativa incluso gestión de OCA de Instalaciones Térmicas. (Eficiencia energética) en edificos residenciales'),
		T_TIPO_DATA('0017LAS','Revisión según normativa incluso gestión de OCA de Instalaciones Térmicas. (Eficiencia energética) en edificos de oficinas'),
		T_TIPO_DATA('0018LAS','Revisión según normativa incluso gestión de OCA de aparatos elevadores hasta 4 alturas'),
		T_TIPO_DATA('0019LAS','Revisión según normativa incluso gestión de OCA de aparatos elevadores hasta 9 alturas'),
		T_TIPO_DATA('0020LAS','Revisión, legalización y puesta en marcha de ascensor de hasta 4 alturas.'),
		T_TIPO_DATA('0021LAS','Revisión, legalización y puesta en marcha de ascensor de hasta 9 alturas.'),
		T_TIPO_DATA('0001CSP','Colocación de lona publicitaría sin necesidad de grúa'),
		T_TIPO_DATA('0002CSP','Colocación de lona publicitaria con necesidad de apoyo en grúa'),
		T_TIPO_DATA('0003CSP','Coste lona por m/2'),
		T_TIPO_DATA('0004CSP','Cartel publicitario de 2x3 m. Vinilo de impresión digital instalado'),
		T_TIPO_DATA('0005CSP','Soporte metálico para valla 2x3'),
		T_TIPO_DATA('0006CSP','Cartel publicitario de 4x3 m. Vinilo de impresión digital instalado'),
		T_TIPO_DATA('0007CSP','Soporte metálico para valla 4x3'),
		T_TIPO_DATA('0008CSP','Cartel publicitario de 8x3 m. Vinilo de impresión digital instalado'),
		T_TIPO_DATA('0001RMS','Arreglo de pared (caída)'),
		T_TIPO_DATA('0002RMS','Arreglo de pared (agujero)'),
		T_TIPO_DATA('0003RMS','Arreglo de techo (caída)'),
		T_TIPO_DATA('0004RMS','Arreglo de techo (agujero)'),
		T_TIPO_DATA('0005RMS','Arreglo de piscina en urbanización'),
		T_TIPO_DATA('0006RMS','Arreglo de zonas comunes en urbanización'),
		T_TIPO_DATA('0007RMS','Arreglo de puertas de garajes'),
		T_TIPO_DATA('0008RMS','Desmontaje de tuberías'),
		T_TIPO_DATA('0009RMS','Cambio de tuberías'),
		T_TIPO_DATA('0001PTA','Viviendas de menores de 80m2'),
		T_TIPO_DATA('0002PTA','Viviendas de 80 a 100 m2'),
		T_TIPO_DATA('0003PTA','Viviendas de 100 a 120 m2'),
		T_TIPO_DATA('0004PTA','Viviendas de 120 a 150 m2'),
		T_TIPO_DATA('0005PTA','Viviendas de más de 150 m2'),
		T_TIPO_DATA('0006PTA','Pintura de urbanización'),
		T_TIPO_DATA('0007PTA','Colocación de vallas en suelos'),
		T_TIPO_DATA('0008PTA','Instalaciones de electricidad 24 horas'),
		T_TIPO_DATA('0001CPA','Cambio de puerta'),
		T_TIPO_DATA('0002CPA','Cambio de ventana'),
		T_TIPO_DATA('0003CPA','Cambio de persiana'),
		T_TIPO_DATA('0004CPA','Arreglo de puerta'),
		T_TIPO_DATA('0005CPA','Arreglo de ventana/ persiana'),
		T_TIPO_DATA('0001FTA','Sustitucion de tuberia general de alimentacion hasta 3 m 1 Pulgada'),
		T_TIPO_DATA('0002FTA','Sustitucion de tuberia general de alimentacion hasta 3 m 2 Pulgadas'),
		T_TIPO_DATA('0003FTA','Sustitucion de tramo de bajante fecal con injerto sencillo'),
		T_TIPO_DATA('0004FTA','Sustitucion de tramo de bajante fecal con injerto doble'),
		T_TIPO_DATA('0005FTA','Sustitución de desagüe de plomo hasta 1 metro (UN/€)'),
		T_TIPO_DATA('0006FTA','Sustitución de desagüe de plomo hasta 2 metros (UN/€)'),
		T_TIPO_DATA('0007FTA','Sustitución de desagüe de plomo hasta 3 metros'),
		T_TIPO_DATA('0008FTA','Sustitución de desagüe de PVC hasta 1 metro (UN/€)'),
		T_TIPO_DATA('0009FTA','Sustitución de desagüe de PVC hasta 3 metros (UN/€)'),
		T_TIPO_DATA('0010FTA','Sustitución de tuberia de alimentación hasta 1 metro lineal'),
		T_TIPO_DATA('0011FTA','Sustitución de tuberia de alimentación hasta 2 metros lineales'),
		T_TIPO_DATA('0012FTA','Sustitución de tuberia de alimentación hasta 3 metros lineales'),
		T_TIPO_DATA('0013FTA','Sustitución de tuberia de alimentación hasta 6 metros lineales'),
		T_TIPO_DATA('0014FTA','Sustitución de tuberia de agua fría y caliente 1 metro lineal cada una'),
		T_TIPO_DATA('0015FTA','Sustitución tuberia de agua fría y caliente 2 metros lineales cada una (UN/€)'),
		T_TIPO_DATA('0016FTA','Sustitución tuberia de agua fría y caliente hasta 3 metros lineales cada una'),
		T_TIPO_DATA('0017FTA','Sustitución de tuberia de agua fría y caliente hasta 6 m 1 cada una'),
		T_TIPO_DATA('0018FTA','Sustitución manguetón PVC (Incluido desmontar y montar inodoro)'),
		T_TIPO_DATA('0019FTA','Sustitución manguetón plomo (Incluido desmontar y montar inodoro)'),
		T_TIPO_DATA('0020FTA','Sustitución de bote sifónico normal'),
		T_TIPO_DATA('0021FTA','Encasquillado de bote sifónico (UN/€)'),
		T_TIPO_DATA('0022FTA','Sustitución de bote sifónico de PVC'),
		T_TIPO_DATA('0023FTA','Hacer junta de manguetón WC. con inodoro o bajante general (un)'),
		T_TIPO_DATA('0024FTA','Sustitución de válvula y rebosadero de bañera (un/€)'),
		T_TIPO_DATA('0025FTA','Reparar mangueta o bote sifónico o desagüe o tuberia sin sustitución'),
		T_TIPO_DATA('0026FTA','Colocación de gebo 1 unidad hasta 1/2 pulgada'),
		T_TIPO_DATA('0027FTA','Colocación de gebo i unidad hasta 3/4 pulgada'),
		T_TIPO_DATA('0028FTA','Únicamente sustitución de sanitario'),
		T_TIPO_DATA('0029FTA','Desmontaje y montaje de sanitarios (lavabo, bidet e inodoro)'),
		T_TIPO_DATA('0030FTA','Sustitución de mecanismo de cisterna (sin material)'),
		T_TIPO_DATA('0031FTA','Sustitución de grifería (sin material)'),
		T_TIPO_DATA('0032FTA','Sustitución de bañera (sin material)'),
		T_TIPO_DATA('0033FTA','Unidad de desatasco en vivienda particular (En ciudad)'),
		T_TIPO_DATA('0034FTA','Hora de trabajo de Oficial fontanero '),
		T_TIPO_DATA('0035FTA','Desplazamiento de camión de desatranco '),
		T_TIPO_DATA('0036FTA','Hora de trabajo de camión de desatranco '),
		T_TIPO_DATA('0037FTA','Ud Revisión de instalación fontanería en vivienda, incluyendo pruebas de presión, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente.'),
		T_TIPO_DATA('0038FTA','Ud Revisión de instalación fontanería en vivienda, incluso elementos, piezas especiales, llaves y griferias.'),
		T_TIPO_DATA('0039FTA','Ud Revisión de instalación fontanería en local comercial de más de 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente.'),
		T_TIPO_DATA('0040FTA','Ud Sustitución de llave de paso'),
		T_TIPO_DATA('0041FTA','Ud Suministro e instalación de fregadero de cocina metálico, de hasta 90 cm de anchura, con senos y/o escurridor.'),
		T_TIPO_DATA('0042FTA','Ud Suministro e instalación Rejilla de baño'),
		T_TIPO_DATA('0043FTA','Ud Suministro e instalación de bidet cerámico color estándar a elegir, sin incluir grifería.'),
		T_TIPO_DATA('0044FTA','Ud Suministro e instalación de lavabo cerámico color estándar a elegir de un seno y sustentado sobre pie cerámico, sin incluir grifería.'),
		T_TIPO_DATA('0045FTA','Ud Suministro e instalación de inodoro cerámico color estándar a elegir, con tanque bajo.'),
		T_TIPO_DATA('0046FTA','Ud Suministro e instalación de tapa de inodoro'),
		T_TIPO_DATA('0047FTA','Ud Suministro e instalación de descarga de inodoro'),
		T_TIPO_DATA('0048FTA','Suministro e instalación de bañera de chapa lacada de hasta 160 cm de longitud, sin incluir grifería.'),
		T_TIPO_DATA('0049FTA','Suministro e instalación de bañera acrílica de hasta 160 cm de longitud, sin incluir grifería.'),
		T_TIPO_DATA('0050FTA','Suministro e instalación de plato de ducha cerámico de hasta 90x90 cm, sin incluir grifería.'),
		T_TIPO_DATA('0051FTA','Suministro e instalación de plato de ducha cerámico mayor de 90x90 cm, sin incluir grifería.'),
		T_TIPO_DATA('0052FTA','Suministro e instalación de plato de ducha acrílico de hasta 90x90 cm, sin incluir grifería.'),
		T_TIPO_DATA('0053FTA','Suministro e instalación de plato de ducha acrílico mayor de 90x90 cm, sin incluir grifería.'),
		T_TIPO_DATA('0054FTA','Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen.'),
		T_TIPO_DATA('0055FTA','Suministro e instalación de grifería monomando de cocina de acero, para colocar empotrado en fregadero.'),
		T_TIPO_DATA('0056FTA','Suministro e instalación de grifería monomando de lavabo/bidet de acero.'),
		T_TIPO_DATA('0057FTA','Suministro e instalación de grifería monomando de bañera de acero, con doble salida a grifo y flexo. Incluyendo manguera y ducha.'),
		T_TIPO_DATA('0058FTA','Suministro e instalación de grifería monomando de ducha de acero, con salida a flexo. Incluyendo manguera y ducha.'),
		T_TIPO_DATA('0059FTA','Suministor e instalación de flexo de ducha de hasta 2m.'),
		T_TIPO_DATA('0060FTA','Suministor e instalación de conjunto flexo y alcachofa de ducha o bañera.'),
		T_TIPO_DATA('0061FTA','Suministro e instalación de tapón de vávula de desahgue de lavabo o bañera incluso cadenilla de sujección.'),
		T_TIPO_DATA('0062FTA','Sellado de perimetro de bañera o plato de ducha con silicona antimoho al acido.'),
		T_TIPO_DATA('0063FTA','Suministro  e instalación de mampara en bañera, de aluminio y metacrilato.'),
		T_TIPO_DATA('0064FTA','Suministro e instalaciónde de mampara en ducha, de aluminio y metacrilato.'),
		T_TIPO_DATA('0065FTA','Verificación y localización de avería'),
		T_TIPO_DATA('0066FTA','Verificación y localización de avería descubriendo (máximo 2 horas)'),
		T_TIPO_DATA('0067FTA','2ª localizacion: verificacion y observacion de averia'),
		T_TIPO_DATA('0068FTA','Soldadura de tuberias generales y reparacion de bajantes PVC (un/€)'),
		T_TIPO_DATA('0069FTA','Sustitucion de tuberia bajante general fecales hasta 3 metros'),
		T_TIPO_DATA('0070FTA','Sustitucion de tuberia bajante PVC general pluviales hasta 3 metros (METRO LINEAL)'),
		T_TIPO_DATA('0001CCN','Hora de trabajo de Oficial frigorista '),
		T_TIPO_DATA('0002CCN','Hora de trabajo de Oficial calefactor '),
		T_TIPO_DATA('0003CCN','Calentador de gas de agua interior  mural, vertical para 6l/min con tiro natural, colocado y probado. Incluyendo boletín y legalización.'),
		T_TIPO_DATA('0004CCN','Ud Suministro y colocación Termo eléctrico 50 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado'),
		T_TIPO_DATA('0005CCN','Ud Suministro y colocación Termo eléctrico 75 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado'),
		T_TIPO_DATA('0006CCN','Ud Suministro y colocación Termo eléctrico 100 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado'),
		T_TIPO_DATA('0007CCN','Ud Instalación de salida de humos calentador, de chapa de acero de 150mm, sin incluir perforación de fachada, aunque sí su sellado y resolución de encuentros'),
		T_TIPO_DATA('0008CCN','Ud Instalación fontanería para calentador incluido conexión desagüe'),
		T_TIPO_DATA('0009CCN','Ud Instalación fontanería para termo'),
		T_TIPO_DATA('0010CCN','Ud Sustitución de radiador electrico toallero de medida aproximada 50x130x10cm.'),
		T_TIPO_DATA('0011CCN','Ud Revisón y prueba hidráulica de caldera y circuito de calefacción, incluso funcionamiento de llaves de radiadores y reparación de fugas para posterior vaciado de la instalación'),
		T_TIPO_DATA('0012CCN','Ud Revisón y prueba de termo eléctrico, i/pp de llaves, desagüe y latiguillos o accesorios.'),
		T_TIPO_DATA('0013CCN','Sustitución o suministro e instalación de válvula termostática en radiadores incluso despalazamiento'),
		T_TIPO_DATA('0014CCN','Puesta en marcha de caldera o calentador  incluido despalzamisto del operario'),
		T_TIPO_DATA('0015CCN','Ud Suministro e instalación de caldera de condensación de gas de vivienda hasta 24 Kw, incluyendo la instalación de salida de humos y desagüe, i/pp de llaves y elementos de seguridad según normativa. Legalización y Boletín de la Intalación de gas y puesta en marcha incluido.'),
		T_TIPO_DATA('0016CCN','Sustitución, suministro y colcocación de termostato análógico, icluso desplazamiento'),
		T_TIPO_DATA('0017CCN','Sustitución, suministro y colcocación de termostato digital, icluso desplazamiento'),
		T_TIPO_DATA('0018CCN','Suministro de mando distancia universal equipos de climatización'),
		T_TIPO_DATA('0001ELD','Taladros punto de luces (metro lineal o unidad)'),
		T_TIPO_DATA('0002ELD','Taladros grosor hasta 6 mm, hasta 25 mm de diámetro'),
		T_TIPO_DATA('0003ELD','Taladros grosor de 7 a 10 mm, hasta 25 mm de diámetros'),
		T_TIPO_DATA('0004ELD','Punto de luz sencillo'),
		T_TIPO_DATA('0005ELD','Doble punto de luz con doble interruptor'),
		T_TIPO_DATA('0006ELD','Punto de luz conmutado'),
		T_TIPO_DATA('0007ELD','Punto de luz cruzamiento'),
		T_TIPO_DATA('0008ELD','Punto de luz sencillo con regulación lumínica'),
		T_TIPO_DATA('0009ELD','Punto de luz conmutado con regulación lumínica'),
		T_TIPO_DATA('0010ELD','Punto de luz cruzamiento con regulación lumínica'),
		T_TIPO_DATA('0011ELD','Punto de luz conmutado con una base de enchufe'),
		T_TIPO_DATA('0012ELD','Punto de luz conmutado con dos bases de enchufe'),
		T_TIPO_DATA('0013ELD','Punto de luz cruzamiento con dos bases de enchufe'),
		T_TIPO_DATA('0014ELD','Punto de timbre'),
		T_TIPO_DATA('0015ELD','Toma de corriente de 10 A'),
		T_TIPO_DATA('0016ELD','Toma de corriente con toma de tierra lateral de 16 A'),
		T_TIPO_DATA('0017ELD','Toma de corriente con toma de tierra lateral de 20 A'),
		T_TIPO_DATA('0018ELD','Toma de corriente con toma de tierra lateral de 25 A'),
		T_TIPO_DATA('0019ELD','M líneal de 2x1,5mm2'),
		T_TIPO_DATA('0020ELD','Ml línea de 2 x 2,5 mm2 + TT'),
		T_TIPO_DATA('0021ELD','Ml línea de 2 x 1,5 mm2 + 2 x 2,5 mm2 + TT'),
		T_TIPO_DATA('0022ELD','M línealde 2x4mm2+TT'),
		T_TIPO_DATA('0023ELD','M línea de 2x6mni2+TT'),
		T_TIPO_DATA('0024ELD','Sustitución de interruptor, enchufe, timbre Mod. Simón 31 o similar'),
		T_TIPO_DATA('0025ELD','Sustitución de diferencial hasta 2 x 40 A 30 mA'),
		T_TIPO_DATA('0026ELD','Sustitución de diferencial de 2 x 63 A 30 mA'),
		T_TIPO_DATA('0027ELD','Sustitución de diferencial hasta 4 x 40 A 300 mA'),
		T_TIPO_DATA('0028ELD','Sustitución de diferencial de 4 x 63 A 300 mA'),
		T_TIPO_DATA('0029ELD','Sustitución de magnetotérmico de 2 x 25 A'),
		T_TIPO_DATA('0030ELD','Sustitución de magrtetotérmico de 2 x 40'),
		T_TIPO_DATA('0031ELD','Sustitución de magnetotérmico de 2 x 50'),
		T_TIPO_DATA('0032ELD','Suministro y colocación de reloj de temporización de circuito.'),
		T_TIPO_DATA('0033ELD','Hora de trabajo de Oficial electricista  '),
		T_TIPO_DATA('0034ELD','Ud Repaso de instalación eléctrica y telecomunicaciones de vivienda incluido la colocación de las tapas de cajas y mecanismos faltantes'),
		T_TIPO_DATA('0035ELD','Ud Revisión y prueba de instalación electrica, telecomunicaciones y video portero en vivienda, incluso rotulación de cuadro eléctrico sin considerar elementos de proteción o mecanismos que pudieran faltar.'),
		T_TIPO_DATA('0036ELD','Ud Revisión y prueba de video porteroinstalación electrica y de telecomunicaciones en vivienda, incluso rotulación de cuadro eléctrico sin considerar elementos de proteción o mecanismos que pudieran faltar.'),
		T_TIPO_DATA('0037ELD','Ud Suministro y colocación de timbre. Con instalación de cableado.'),
		T_TIPO_DATA('0038ELD','Ud Instalación de toma de corriente para calentador, incluido cableado, mecanismo de superficie o empotrado y canaleta'),
		T_TIPO_DATA('0001ABA','Enlucido de yeso m2'),
		T_TIPO_DATA('0002ABA','Enfoscado de mortero de cemento m2'),
		T_TIPO_DATA('0003ABA','Paño falso techo de escayola m2'),
		T_TIPO_DATA('0004ABA','Pavimento terrazo/gres m2 -rodapié incluido'),
		T_TIPO_DATA('0005ABA','Rehacer enlucido de yeso m2'),
		T_TIPO_DATA('0006ABA','Rehacer m2 alicatado (gres cerámico)'),
		T_TIPO_DATA('0007ABA','Ml escayola'),
		T_TIPO_DATA('0008ABA','Alicatado o solado m2'),
		T_TIPO_DATA('0009ABA','Demolición solado gres m2'),
		T_TIPO_DATA('0010ABA','Demolición terrazo m2'),
		T_TIPO_DATA('0011ABA','Demolición alicatado m2'),
		T_TIPO_DATA('0012ABA','Demolición-mármol m2'),
		T_TIPO_DATA('0013ABA','Picado de yeso (demolición) m2'),
		T_TIPO_DATA('0014ABA','Picado de cemento (demolición) m2'),
		T_TIPO_DATA('0015ABA','Demolición m2 Ladrillo H. sencillo m2'),
		T_TIPO_DATA('0016ABA','Demolición m2 Ladrillo H. Doble m2 2'),
		T_TIPO_DATA('0001CRA','Cristal sencillo-incoloro 5mm-m2'),
		T_TIPO_DATA('0002CRA','Doble cristal tipo Climalit 4+6+4 /m2'),
		T_TIPO_DATA('0003CRA','Doble cristal tipo Climalit 5+6+4 /m2'),
		T_TIPO_DATA('0001UBA','Reparación de acera mediante elemento continuo de hormigón pulido / impreso. Los primeros  5 m2.'),
		T_TIPO_DATA('0002UBA','Reparación de acera mediante elemento continuo de hormigón pulido / impreso. 5 a 50  M2'),
		T_TIPO_DATA('0003UBA','Reparación de acera mediante elemento continuo de hormigón pulido / impreso. > 50 M2'),
		T_TIPO_DATA('0004UBA','Reparación de acera mediante elemento discontinuo de baldosa / adoquín. Los primeros 5 m2.'),
		T_TIPO_DATA('0005UBA','Reparación de acera mediante elemento discontinuo de baldosa / adoquín. De 5 a 50 m2.'),
		T_TIPO_DATA('0006UBA','Reparación de acera mediante elemento discontinuo de baldosa / adoquín. > 50 M2.'),
		T_TIPO_DATA('0001PCI','Cartelería "Prohibido el paso a todo personal ajeno a la obra. Precaución con los menores"'),
		T_TIPO_DATA('0002PCI','Suministro e instalación de detector de presencia para instalación eléctrica.'),
		T_TIPO_DATA('0003PCI','Cartelería de instalación de protección contra incendios (salidas de evacuación, extintores, etc.).'),
		T_TIPO_DATA('0004PCI','Suministro e instalación de extintor de incendios  portátil de eficacia 21A -113B incluyendo soporte y señalización (s/ CTE)'),
		T_TIPO_DATA('0005PCI','Suministro e instalación de boca de indendio equipada 25 m incluyendo señalización(s/ CTE)'),
		T_TIPO_DATA('0006PCI','Suministro e instalación de boca de indendio equipada 45 m incluyendo señalización(s/ CTE)'),
		T_TIPO_DATA('0007PCI','Suministro y sustitución de manguera en BIE de 25m (incluyendo material).'),
		T_TIPO_DATA('0008PCI','Suministro y sustitución de manguera en BIE de 45m (incluyendo material).'),
		T_TIPO_DATA('0009PCI','Suministro e instalación de puerta EF 30 (s/ CTE), 90x210 totalmente rematada y terminada.'),
		T_TIPO_DATA('0010PCI','Suministro e instalación de puerta EF 60 (s/ CTE), 90x210 totalmente rematada y terminada.'),
		T_TIPO_DATA('0011PCI','Suministro e instalación de luminaria de emergencia (s/ CTE).'),
		T_TIPO_DATA('0001SGD','Alquiler'),
		T_TIPO_DATA('0002SGD','Compra'),
		T_TIPO_DATA('0003SGD','Cerrojo FAC'),
		T_TIPO_DATA('0004SGD','Escudo protector'),
		T_TIPO_DATA('0001TSU','Visita técnico no especilizado (1 hora)'),
		T_TIPO_DATA('0002TSU','Visita técnico no especilizado (1 hora) por lanzamiento fallido'),
		T_TIPO_DATA('0003TSU','1º Hora Oficial Albañil (incluido desplazamiento) para los oficios de Cerrajero, Fontanero, Electricista, Cerrajero, Pintor, Parquetista, Cristalero y Carpintero . …'),
		T_TIPO_DATA('0004TSU','1º Hora Oficial de Climatización (incluido desplazamiento) …'),
		T_TIPO_DATA('0005TSU','2º Hora y sucesivas Oficial Albañil (incluido desplazamiento) para los oficios de Cerrajero, Fontanero, Electricista, Cerrajero, Pintor, Parquetista, Cristalero y Carpintero, peón, climatización ….'),
		T_TIPO_DATA('0006TSU','2º hora y sucesivas Oficial de climatización'),
		T_TIPO_DATA('0007TSU','Incremento de tarifa a partir de las 20:00 hrs. De Lunes a Viernes'),
		T_TIPO_DATA('0008TSU','Incremento de tarifa para Sábados, Domingos y Festivos …'),
		T_TIPO_DATA('0001MC','Encimera 60cm,base tablero fib. madera+resinas sint.MDF,e=30mm. '),
		T_TIPO_DATA('0002MC','m2 Encimera inox AISI 316,e=1mm,pulido+esmerilado,ancho=60cm,5 pliegos,agujeros,colocada'),
		T_TIPO_DATA('0003MC','Módulo estándard p/mueble cocina alto <=600x330mm h<=900mm,precio medio,+ti+her.+reg'),
		T_TIPO_DATA('0004MC','Módulo rinconero angular p/mueble cocina alto <=(900x900)x330mm h<=900mm,precio medio,+ti+her+reg.'),
		T_TIPO_DATA('0005MC','Módulo campana p/mueble cocina alto <=600x330mm h<=600mm,precio medio,+tir.+her.+reg. '),
		T_TIPO_DATA('0006MC','Columna mueble cocina <=600x600mm h<=2200mm,2estantes+2cazueleros,precio medio,+pie.+tir.+her.'),
		T_TIPO_DATA('0007MC','Columna mueble cocina <=600x600mm h<=2200mm,2estantes+2,precio medio,+pies.+tir+her.'),
		T_TIPO_DATA('0008MC','Módulo estándard p/mueble cocina bajo <=600x600mm h=700mm, puerta, precio medio,+pie.+tir.+her.'),
		T_TIPO_DATA('0009MC','Módulo estándard p/mueble cocina bajo <=600x600mm h=700mm,cajones/cazuelero,p.medio,+pie+tir.+her. '),
		T_TIPO_DATA('0010MC','Módulo estándard p/mueble cocina bajo <=600x600mm h=700mm,1cajón+1puerta,p.medio,+pie.+tir.+her.'),
		T_TIPO_DATA('0011MC','Módulo fregadero p/mueble cocina bajo 600x600mm h=700mm,puerta,precio medio,+pie.+tir.+her.'),
		T_TIPO_DATA('0012MC','Módulo rinconero angular p/mueble cocina bajo <=(900x900)x600mm '),
		T_TIPO_DATA('0013MC','Mobiliario p/cocina long<=3m,precio medio,módulos altos + módulos bajos.+ti.+her.+reg.'),
		T_TIPO_DATA('0014MC','Mobiliario p/cocina long.3-4m,precio medio,módulos altos + módulos bajos.+ti.+her.+reg. '),
		T_TIPO_DATA('0015MC','Mobiliario p/cocina long.4-5m,precio medio,módulos altos + módulos bajos.+ti.+her.+reg.'),
		T_TIPO_DATA('0001E','Cocina gas inox. 4 quemadores,conex.red gas. precio bajo.'),
		T_TIPO_DATA('0002E','Cocina gas inox. 4 quemadores,conex.red gas. precio medio.'),
		T_TIPO_DATA('0003E','Placa vitrocerámica, marco inox.3/4 elemen. precio medio.  '),
		T_TIPO_DATA('0004E','Placa vitrocerámica, canto bisel. 3/4 elemen. precio medio. '),
		T_TIPO_DATA('0005E','Campana horizontal blanco,60cm,1motor,interruptor, 3 velocidads,filtros,2 lámp.40W'),
		T_TIPO_DATA('0006E','Campana horizontal inox. 60cm,1motor,interruptor,3velocidads,filtros,2 lámp.40W'),
		T_TIPO_DATA('0007E','Horno multifunción color blanco precio bajo.'),
		T_TIPO_DATA('0008E','Horno multifunción inox. precio bajo.'),
		T_TIPO_DATA('0009E','Horno multifunción color blanco precio medio. '),
		T_TIPO_DATA('0010E','Suministro y colocación de caldera atmosferica 24 Kw. '),
		T_TIPO_DATA('0011E','Suministro y colocación de caldera estanca 24 Kw.'),
		T_TIPO_DATA('0012E','Suministro y colocación de caldera estanca 20/20 F o similar con microacumulación'),
		T_TIPO_DATA('0013E','Termo eléctrico 50l'),
		T_TIPO_DATA('0014E','Termo eléctrico 80l'),
		T_TIPO_DATA('0001PE','Pack entrada (Apertura, Bombin, Escudo protector, Retirada enseres, Limpieza, Informe estado)') 
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
					', USUARIOMODIFICAR = '||V_USU_MODIFICAR||' , FECHAMODIFICAR = SYSDATE '||
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
