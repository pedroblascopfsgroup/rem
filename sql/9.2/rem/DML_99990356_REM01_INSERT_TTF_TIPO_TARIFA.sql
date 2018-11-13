--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181008
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1729
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
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-1729'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
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
    	T_TIPO_DATA('SOL13','Tala de árbol < 6 m de altura sacando el tocón'),
	T_TIPO_DATA('SOL14','Tala de árbol < 6 m de altura sin sacar el tocón'),
	T_TIPO_DATA('SOL15','Tala de árbol 10/15m de altura sacando el tocón'),
	T_TIPO_DATA('SOL16','Tala de árbol 10/15m de altura sin sacar el tocón'),
	T_TIPO_DATA('SOL17','Tala de árbol 6/10m de altura sacando el tocón'),
	T_TIPO_DATA('SOL18','Tala de árbol 6/10m de altura sin sacar el tocón'),
	T_TIPO_DATA('SOL19','Poda de árbol inferiores a 6 m de altura. Incluso gestión de residuos.'),
	T_TIPO_DATA('SOL20','Poda de árbol con cesta de 6 a 10 m de altura. Incluso gestión de residuos.'),
	T_TIPO_DATA('SOL21','Poda de árbol con cesta de 15 a 20 m de altura. Incluso gestión de residuos.'),
	T_TIPO_DATA('SOL22','Poda de árbol con trepa de 15 a 20 m de altura. Incluso gestión de residuos.'),
	T_TIPO_DATA('OM274','Aislamiento espuma poliuret. 4 cm proyectada'),
	T_TIPO_DATA('OM275','Terraplenado con tierras adecuadas 95% PM'),
	T_TIPO_DATA('OM276','Terraplenado con zahorra artificial 95% PM'),
	T_TIPO_DATA('OM277','Excavación tierras + transporte a vertedero'),
	T_TIPO_DATA('OM278','Relleno de zanjas con arena'),
	T_TIPO_DATA('SAB-CER12','Suministro de copia de llave de serreta'),
	T_TIPO_DATA('SAB-CER13','Suministro de copia de llave de seguridad intermedia (llave de puntos o similar)'),
	T_TIPO_DATA('SAB-CER14','Sustitución de bombillo de buzón'),
	T_TIPO_DATA('SAB-CER15','Suministro e instalación de escudo de seguridad media'),
	T_TIPO_DATA('SAB-CER16','Suministro e instalación de candado, incluida cadena hasta 0,5mts en caso necesario y descerraje de candado existente si fuere necesario'),
	T_TIPO_DATA('OM279','Desmontaje y retirada de puerta antiocupa.'),
	T_TIPO_DATA('OM280','Suministro e instalación de juego de tapetas gama media en acabado lacado blanco, para las dos caras de una puerta'),
	T_TIPO_DATA('OM281','Suministro e instalación de Hoja de Puerta abatible interior de hasta 100 cms gama media en acabado lacado blanco, incluyendo: puerta, bisagras y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución'),
	T_TIPO_DATA('OM282','Suministro e instalación de Puerta abatible block interior de hasta 100 cms gama media en acabado lacado blanco, incluyendo: puerta, bisagras, batientes, tapetas y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución'),
	T_TIPO_DATA('OM283','Suministro e instalación de Puerta abatible de Entrada en block de hasta 100 cms BLINDADA (gama media) en acabado de melamina, incluyendo: puerta, bisagras, batientes, tapetas, cerradura, pomo y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución'),
	T_TIPO_DATA('OM284','ML. Sellado de carpintería de aluminio con encuentros de fabrica de fachada y albardillas'),
	T_TIPO_DATA('OM285','UD. Ajuste o reparación de cierres de carpintería metálica corredera. Ventana o puerta'),
	T_TIPO_DATA('OM286','UD. Ajuste o reparación de cierres de carpintería metálica abatible. Ventana o puerta'),
	T_TIPO_DATA('OM287','Suministro e instalación de vidrio con cámara de 4/8/4 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
	T_TIPO_DATA('OM288','Desmontaje y retirada de Parquet flotante, incluso zócalo, capas inferiores de aislamiento y pasos de puerta existentes, incluyendo gestión de residuos a vertedero autorizado'),
	T_TIPO_DATA('LIMP9','Limpieza de terraza. Incluidos los imbornales, sumideros y elementos existentes hasta 15m²'),
	T_TIPO_DATA('LIMP10','Limpieza general de piscina de Sup. <=35 m2  (Incluido vaciado)'),
	T_TIPO_DATA('LIMP11','Limpieza general de piscina de Sup. De >35 m2  (Incluido vaciado)'),
	T_TIPO_DATA('OM289','Suministro y colocación de Valla trasladable de obra o similar de 3,50x2,00 m, formada por panel de malla electrosoldada y postes verticales, acabado galvanizado, colocados sobre bases prefabricadas de hormigón, con malla de ocultación colocada sobre la valla, incluidos todos los trabajos necesarios para su completa y correcta ejecución.'),
	T_TIPO_DATA('OM290','Vallado de 2m de altura, compuesto por paneles opacos de chapa perfilada nervada de acero UNE-EN 10346 S320 GD galvanizado de 0,6 mm espesor y 30 mm altura de cresta, incluidos postes de sujeción cada 2ml.'),
	T_TIPO_DATA('OM291','Suministro y colocación de cercado mediante chapa plegada o similar en acabado galvanizado y altura hasta 200 cms, con los postes y tensores necesarios en función de la geometría del solar, incluidos los pies, anclajes y/o empotramientos necesarios para su completa y correcta ejecución.'),
	T_TIPO_DATA('OM292','Ejecución de riostra de cimentación, para posterior ejecución de muro de vallado de obra, de 40 cms de ancho y 60 cms de profundidad armada con 4Ø12 y estribos de Ø10 cada 30 cms, con hormigón HA-25-B-20-IIA, incluso excavación en terreno blando. Incluidos todos los medios auxiliares necesarios, completamente ejecutada y retirada de restos de excavación.'),
	T_TIPO_DATA('OM293','Dirección Facultativa 10.000 - 60.000 € '),
	T_TIPO_DATA('OM294','Dirección Facultativa > 60.000 €   '),
	T_TIPO_DATA('OM295','Redacción de proyecto técnico para su visado (sin tasas de visado) módulo mínimo'),
	T_TIPO_DATA('OM296','Redacción de proyecto técnico para su visado (sin tasas de visado)'),
	T_TIPO_DATA('OM297','Proyecto y dirección de obra (un solo técnico) 10.000 - 60.000 €'),
	T_TIPO_DATA('OM298','Proyecto y dirección de obra (un solo técnico) >60.000 €'),
	T_TIPO_DATA('OM299','Coordinación de Seguridad y Salud Módulo mínimo'),
	T_TIPO_DATA('OM300','Coordinación de Seguridad y Salud > 30.000 €'),
	T_TIPO_DATA('OM301','Levantamiento topográfico (Día de trabajo de campo hasta 8h Desp < 100km)'),
	T_TIPO_DATA('OM302','Servicio mínimo de horas de camión de desatranco, incluidos los operarios necesarios para la ejecución de los trabajos. Partida complementaria al desplazamiento del camión (a esta partida falta añadirle las horas de servicio).'),
	T_TIPO_DATA('OM303','Servicio mínimo para Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen.'),
	T_TIPO_DATA('OM304','Suministro e instalación de extractora de baño o espacio cerrado con necesidad de ventilación i/instalación eléctrica,'),
	T_TIPO_DATA('OM305','Suministro e instalación de flexo de ducha de hasta 2m.'),
	T_TIPO_DATA('OM306','Suministro e instalación de conjunto flexo y alcachofa de ducha o bañera.'),
	T_TIPO_DATA('OM307','Sellado de perímetro de bañera o plato de ducha con silicona anti moho al acido.'),
	T_TIPO_DATA('OM308','Ud Instalación fontanería para termo. Dejando instalación lista para colocación.'),
	T_TIPO_DATA('OM309','Levantado y posterior recolocación de mampara de ducha o bañera, incluidos todos los trabajos necesarios para la correcta ejecución. Se contabilizará cada uno de los elementos. Se incluye el sellado final del elemento.'),
	T_TIPO_DATA('OM310','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 80 m2 o 2 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros.'),
	T_TIPO_DATA('OM311','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 100 m2 o 3 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros.'),
	T_TIPO_DATA('OM312','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 120 m2 o 4 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros'),
	T_TIPO_DATA('OM313','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 150 m2 o 5 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros. Para mayores superficies o habitaciones se realizará valoración específica del inmueble.'),
	T_TIPO_DATA('OM314','Suministro e instalación de placa cocción de gas de 60x60 cms, incluidos todos los trabajos para la correcta ejecución y conexionado a la instalación existente. Quedan expresamente excluidos los trabajos de adaptación de la instalación de gas a normativa en caso de ser necesario.'),
	T_TIPO_DATA('OM315','Suministro e instalación de HORNO GAMA MEDIA E INSTALACIÓN ESTANDAR.'),
	T_TIPO_DATA('OM316','Suministro e instalación de placa de inducción de 60x60 cms, incluidos todos los trabajos para la correcta ejecución'),
	T_TIPO_DATA('OM317','Suministro y colocación de amueblamiento de cocina gama baja-económica, compuesta por 3,5 m de muebles bajos con zócalo inferior y un módulo de muebles altos de 80 cm, acabado laminado, cantos verticales post formados. Incluso zócalo inferior, y remates a juego con el acabado, guías de rodamientos metálicos y tiradores en puertas, incluso piezas especiales de desagües de electrodomésticos. Totalmente montado, sin incluir encimera, electrodomésticos ni fregadero. '),
	T_TIPO_DATA('OM318','Ud Revisión y prueba de instalación eléctrica, telecomunicaciones y video portero en vivienda, incluso rotulación de cuadro eléctrico sin considerar elementos de protección o mecanismos que pudieran faltar.'),
	T_TIPO_DATA('BOL8','Emisión de Proyecto y Boletín de legalización de instalación eléctrica en local comercial superior a 1500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.'),
	T_TIPO_DATA('OM319','Anulación y Retirada de Instalación Eléctrica Pre-existente, consistente en: Desconexión permanente de todas las líneas del cuadro eléctrico, retirada del cableado que pueda entorpecer para la posterior conexión de una nueva instalación al cuadro eléctrico, retirada de mecanismos y embellecedores de interruptores y bases de enchufes, y tapado mediante pasta de yeso, mortero o tapas registrables en función del acabado de los paramentos. Se incluye retirada de restos a vertedero autorizado. Vivienda hasta 120 m2'),
	T_TIPO_DATA('OM320','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda hasta 120 m2'),
	T_TIPO_DATA('OM321','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda entre 121 y 200 m2'),
	T_TIPO_DATA('OM322','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda hasta 120 m2'),
	T_TIPO_DATA('OM323','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 5500 W - Vivienda entre 121 y 200 m2'),
	T_TIPO_DATA('OM324','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda hasta 120 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico'),
	T_TIPO_DATA('OM325','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (NO INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda entre 121 y 200 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico'),
	T_TIPO_DATA('OM326','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda hasta 120 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico'),
	T_TIPO_DATA('OM327','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria, Compañía Eléctrica y Habitabilidad que le sean de aplicación en función de la potencia a contratar. Quedan incluidos todos los trabajos aguas abajo del cuadro eléctrico (INCLUIDO EL CUADRO EN EL PRECIO DE LA PARTIDA) de: cableados, modificación o sustitución de cuadro eléctrico, protecciones generales e individuales, mecanismos, embellecedores, ayudas de albañilería y cualesquiera otros no excluidos expresamente en la descripción de la partida . Queda expresamente excluido: Acometida a la vivienda. Potencia a Contratar: hasta 7500 W - Vivienda entre 121 y 200 m2. Para viviendas de más de 200 m2  o 7500 W se solicitará presupuesto específico'),
	T_TIPO_DATA('OM328','ML. Suministro y colocación de rodapié cerámico incluido material. '),
	T_TIPO_DATA('OM329','Ml. Rejuntado o sellado de rodapié con mortero hidrófugo o silicona resistencia UV '),
	T_TIPO_DATA('OM330','Ml. Sellado de juntas con mortero hidrófugo'),
	T_TIPO_DATA('OM331','M2. Aplicación de lechada y llagueado de material cerámico en paramentos verticales.'),
	T_TIPO_DATA('OM332','Derribo de cielo raso + Carga escombros'),
	T_TIPO_DATA('OM333','Apertura de cata en falso techo continuo/tabique/pared maestra/suelo o similar, incluso p/p de replanteo, cortes, limpieza, acopio, retirada y carga manual de escombros sobre vehículo o contenedor. (máx 3m2). Aplicable para destapiado de puertas y ventanas.'),
	T_TIPO_DATA('OM334','Suministro e instalación de teja árabe, incluidos materiales de fijación, remate y sellado del mismo en caso de ser necesario para la completa y correcta ejecución. Partida mínima de ejecución de 1 m2.'),
	T_TIPO_DATA('OM335','Suministro e instalación de teja de hormigón, incluidos materiales de fijación, remate y sellado del mismo en caso de ser necesario para la completa y correcta ejecución. Partida mínima de ejecución de 1 m2.'),
	T_TIPO_DATA('SOL23','Limpieza de parcela/solar para retirada de escombros u otros restos voluminosos, incluida retirada y gestión de restos a vertedero autorizado. Se deberá aportar justificación del volumen real retirado.'),
	T_TIPO_DATA('OM336','Suministro e instalación de vidrio simple de 5 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
	T_TIPO_DATA('OM337','Sustitución de magnetotérmico de 2 x 40'),
	T_TIPO_DATA('OM338','Suministro e instalación de vidrio simple de 8 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
	T_TIPO_DATA('OM339','Suministro e instalación de vidrio simple de 10 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
	T_TIPO_DATA('OM340','Suministro e instalación de vidrio simple de 15 mm, incluidos todos los trabajos necesarios para la correcta ejecución')
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
