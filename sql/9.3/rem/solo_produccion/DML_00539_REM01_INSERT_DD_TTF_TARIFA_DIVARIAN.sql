--/*
--######################################### 
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20201120
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8292
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Insertar tarifas divarian
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_ACTIVO NUMBER(16); -- Vble. sin prefijo.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8292'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='DD_TTF_TIPO_TARIFA'; --Vble. auxiliar para almacenar la tabla a insertar
    V_ID NUMBER(16); -- id de la nueva tarifa a insertar
    V_COUNT NUMBER(16):=0;
    V_COUNT_TOTAL NUMBER(16):=0;

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('DIV-BOL1','Emisión de proyecto y boletín de legalización de instalación eléctrica en vivienda s/ normativa vige','Emisión de proyecto y boletín de legalización de instalación eléctrica en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos'),
        T_TIPO_DATA('DIV-BOL2','Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 5','Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos'),
        T_TIPO_DATA('DIV-BOL3','Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 1','Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 1500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos'),
        T_TIPO_DATA('DIV-BOL4','PA Obtención/Tramitación de Boletín Agua','PA Obtención/Tramitación de Boletín Agua'),
        T_TIPO_DATA('DIV-BOL5','Emisión de proyecto y boletín de legalización de instalación de gas en vivienda s/ normativa vigente','Emisión de proyecto y boletín de legalización de instalación de gas en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos'),
        T_TIPO_DATA('DIV-BOL8','Emisión de Proyecto y Boletín de legalización de instalación eléctrica en local comercial superior a','Emisión de Proyecto y Boletín de legalización de instalación eléctrica en local comercial superior a 1500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.'),
        T_TIPO_DATA('DIV-CED1','PA Obtención/Tramitación de Nueva cédula de habitabilidad','PA Obtención/Tramitación de Nueva cédula de habitabilidad'),
        T_TIPO_DATA('DIV-CED2','PA Obtención/Tramitación de Duplicado de LPO o Cédula','PA Obtención/Tramitación de Duplicado de LPO o Cédula'),
        T_TIPO_DATA('DIV-CEE1','Vivienda suelta con documentación del activo','Vivienda suelta con documentación del activo'),
        T_TIPO_DATA('DIV-CEE10','Promociones (viviendas integradas en una promoción) con documentación del activo','Promociones (viviendas integradas en una promoción) con documentación del activo'),
        T_TIPO_DATA('DIV-CEE11','Promociones (viviendas integradas en una promoción) sin documentación del activo','Promociones (viviendas integradas en una promoción) sin documentación del activo'),
        T_TIPO_DATA('DIV-CEE12','Promociones (viviendas integradas en una promoción) sin documentación del activo','Promociones (viviendas integradas en una promoción) sin documentación del activo'),
        T_TIPO_DATA('DIV-CEE13','Promociones (viviendas integradas en una promoción) sin documentación del activo','Promociones (viviendas integradas en una promoción) sin documentación del activo'),
        T_TIPO_DATA('DIV-CEE14','Promociones (viviendas integradas en una promoción) sin documentación del activo','Promociones (viviendas integradas en una promoción) sin documentación del activo'),
        T_TIPO_DATA('DIV-CEE15','Terciario (local comercial y oficina) con documentación del activo','Terciario (local comercial y oficina) con documentación del activo'),
        T_TIPO_DATA('DIV-CEE16','Terciario (local comercial y oficina) con documentación del activo','Terciario (local comercial y oficina) con documentación del activo'),
        T_TIPO_DATA('DIV-CEE17','Terciario (local comercial y oficina) con documentación del activo','Terciario (local comercial y oficina) con documentación del activo'),
        T_TIPO_DATA('DIV-CEE18','Terciario (local comercial y oficina) sin documentación del activo','Terciario (local comercial y oficina) sin documentación del activo'),
        T_TIPO_DATA('DIV-CEE19','Terciario (local comercial y oficina) sin documentación del activo','Terciario (local comercial y oficina) sin documentación del activo'),
        T_TIPO_DATA('DIV-CEE2','Vivienda suelta con documentación del activo','Vivienda suelta con documentación del activo'),
        T_TIPO_DATA('DIV-CEE20','Terciario (local comercial y oficina) sin documentación del activo','Terciario (local comercial y oficina) sin documentación del activo'),
        T_TIPO_DATA('DIV-CEE3','Vivienda suelta con documentación del activo','Vivienda suelta con documentación del activo'),
        T_TIPO_DATA('DIV-CEE4','Vivienda suelta sin documentación del activo','Vivienda suelta sin documentación del activo'),
        T_TIPO_DATA('DIV-CEE5','Vivienda suelta sin documentación del activo','Vivienda suelta sin documentación del activo'),
        T_TIPO_DATA('DIV-CEE6','Vivienda suelta sin documentación del activo','Vivienda suelta sin documentación del activo'),
        T_TIPO_DATA('DIV-CEE7','Promociones (viviendas integradas en una promoción) con documentación del activo','Promociones (viviendas integradas en una promoción) con documentación del activo'),
        T_TIPO_DATA('DIV-CEE8','Promociones (viviendas integradas en una promoción) con documentación del activo','Promociones (viviendas integradas en una promoción) con documentación del activo'),
        T_TIPO_DATA('DIV-CEE9','Promociones (viviendas integradas en una promoción) con documentación del activo','Promociones (viviendas integradas en una promoción) con documentación del activo'),
        T_TIPO_DATA('DIV-CM-CER1','Sustitución de bombillo normal (Azbe, Tesa, Lince, Fiam, Ucem o similar) incluye apertura de puerta,','Sustitución de bombillo normal (Azbe, Tesa, Lince, Fiam, Ucem o similar) incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.'),
        T_TIPO_DATA('DIV-CM-CER2','Sustitución de bombillo de seguridad (Azbe, Tesa, Linceo similar) gama baja  incluye apertura de pue','Sustitución de bombillo de seguridad (Azbe, Tesa, Linceo similar) gama baja  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.'),
        T_TIPO_DATA('DIV-CM-CER3','Sustitución de bombillo de seguridad (Fac, Mia de Borjas, Iseo o similar) gama media  incluye apertu','Sustitución de bombillo de seguridad (Fac, Mia de Borjas, Iseo o similar) gama media  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.'),
        T_TIPO_DATA('DIV-CM-CER4','Sustitución de bombillo de seguridad (Potent Borjas, Cr Acoraz, Cr doble) gama alta  incluye apertur','Sustitución de bombillo de seguridad (Potent Borjas, Cr Acoraz, Cr doble) gama alta  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.'),
        T_TIPO_DATA('DIV-CM-CER5','Sustitución de cerrojo (Fac, Lince, Ezcurra o similar)  incluye apertura de puerta, descerraje y cer','Sustitución de cerrojo (Fac, Lince, Ezcurra o similar)  incluye apertura de puerta, descerraje y cerradura en el caso de ser necesario.'),
        T_TIPO_DATA('DIV-CM-CER6','Reparación de cerradura (sin aporte de piezas)','Reparación de cerradura (sin aporte de piezas)'),
        T_TIPO_DATA('DIV-INF4','Hr Técnico en elaboración de informes o realización de gestiones','Hr Técnico en elaboración de informes o realización de gestiones'),
        T_TIPO_DATA('DIV-INF4','Hr Técnico en elaboración de informes o realización de gestiones','Hr Técnico en elaboración de informes o realización de gestiones'),
        T_TIPO_DATA('DIV-OM1','Verificación y localización de avería','Verificación y localización de avería'),
        T_TIPO_DATA('DIV-OM10','Sustitución de tramo de bajante fecal con injerto doble','Sustitución de tramo de bajante fecal con injerto doble'),
        T_TIPO_DATA('DIV-OM100','Tres lunas antibala 10+10+2,5 mm (metro cuadrado)','Tres lunas antibala 10+10+2,5 mm (metro cuadrado)'),
        T_TIPO_DATA('DIV-OM101','Suministro e instalación de luna incolora templada de 6mrn (metro cuadrado)','Suministro e instalación de luna incolora templada de 6mrn (metro cuadrado)'),
        T_TIPO_DATA('DIV-OM102','Suministro e instalación de luna incolora templada de 8mm (metro cuadrado)','Suministro e instalación de luna incolora templada de 8mm (metro cuadrado)'),
        T_TIPO_DATA('DIV-OM103','Suministro e instalación de luna incolora templada de 10 mm (metro cuadrado)','Suministro e instalación de luna incolora templada de 10 mm (metro cuadrado)'),
        T_TIPO_DATA('DIV-OM104','Suministro e instalación de luna en color templada de6 mm (metro cuadrado)','Suministro e instalación de luna en color templada de6 mm (metro cuadrado)'),
        T_TIPO_DATA('DIV-OM105','Suministro e instalación de luna en color templada de 10 mm (metro cuadrado)','Suministro e instalación de luna en color templada de 10 mm (metro cuadrado)'),
        T_TIPO_DATA('DIV-OM106','Suministro e instalación de luna templada en puertas de 10 mm (metro cuadrado','Suministro e instalación de luna templada en puertas de 10 mm (metro cuadrado'),
        T_TIPO_DATA('DIV-OM107','Taladros punto de luces (metro lineal o unidad)','Taladros punto de luces (metro lineal o unidad)'),
        T_TIPO_DATA('DIV-OM108','Taladros grosor hasta 6 mm, hasta 25 mm de diámetro','Taladros grosor hasta 6 mm, hasta 25 mm de diámetro'),
        T_TIPO_DATA('DIV-OM109','Taladros grosor de 7 a 10 mm, hasta 25 mm de diámetros','Taladros grosor de 7 a 10 mm, hasta 25 mm de diámetros'),
        T_TIPO_DATA('DIV-OM11','Sustitución de desagüe de plomo hasta 1 metro (reemplazar por un material autorizado)','Sustitución de desagüe de plomo hasta 1 metro (reemplazar por un material autorizado)'),
        T_TIPO_DATA('DIV-OM110','Punto de luz sencillo','Punto de luz sencillo'),
        T_TIPO_DATA('DIV-OM111','Doble punto de luz con doble interruptor','Doble punto de luz con doble interruptor'),
        T_TIPO_DATA('DIV-OM112','Punto de luz conmutado','Punto de luz conmutado'),
        T_TIPO_DATA('DIV-OM113','Punto de luz cruzamiento','Punto de luz cruzamiento'),
        T_TIPO_DATA('DIV-OM114','Punto de luz sencillo con regulación lumínica','Punto de luz sencillo con regulación lumínica'),
        T_TIPO_DATA('DIV-OM115','Punto de luz conmutado con regulación lumínica','Punto de luz conmutado con regulación lumínica'),
        T_TIPO_DATA('DIV-OM116','Punto de luz cruzamiento con regulación lumínica','Punto de luz cruzamiento con regulación lumínica'),
        T_TIPO_DATA('DIV-OM117','Punto de luz conmutado con una base de enchufe','Punto de luz conmutado con una base de enchufe'),
        T_TIPO_DATA('DIV-OM118','Punto de luz conmutado con dos bases de enchufe','Punto de luz conmutado con dos bases de enchufe'),
        T_TIPO_DATA('DIV-OM119','Punto de luz cruzamiento con dos bases de enchufe','Punto de luz cruzamiento con dos bases de enchufe'),
        T_TIPO_DATA('DIV-OM12','Sustitución de desagüe de plomo hasta 2 metros (reemplazar por un material autorizado)','Sustitución de desagüe de plomo hasta 2 metros (reemplazar por un material autorizado)'),
        T_TIPO_DATA('DIV-OM120','Punto de timbre','Punto de timbre'),
        T_TIPO_DATA('DIV-OM121','Toma de corriente de 10 A','Toma de corriente de 10 A'),
        T_TIPO_DATA('DIV-OM122','Toma de corriente con toma de tierra lateral de 16 A','Toma de corriente con toma de tierra lateral de 16 A'),
        T_TIPO_DATA('DIV-OM123','Toma de corriente con toma de tierra lateral de 20 A','Toma de corriente con toma de tierra lateral de 20 A'),
        T_TIPO_DATA('DIV-OM124','Toma de corriente con toma de tierra lateral de 25 A','Toma de corriente con toma de tierra lateral de 25 A'),
        T_TIPO_DATA('DIV-OM125','M lineal de 2x1,5m m²','M lineal de 2x1,5m m²'),
        T_TIPO_DATA('DIV-OM126','M línea de 2 x 2,5 m m² + TT','M línea de 2 x 2,5 m m² + TT'),
        T_TIPO_DATA('DIV-OM127','M línea de 2 x 1,5 m m² + 2 x 2,5 m m² + TT','M línea de 2 x 1,5 m m² + 2 x 2,5 m m² + TT'),
        T_TIPO_DATA('DIV-OM128','M lineal de 2x4m m²+TT','M lineal de 2x4m m²+TT'),
        T_TIPO_DATA('DIV-OM129','M línea de 2x6mni2+TT','M línea de 2x6mni2+TT'),
        T_TIPO_DATA('DIV-OM13','Sustitución de desagüe de plomo hasta 3 metros (reemplazar por un material autorizado)','Sustitución de desagüe de plomo hasta 3 metros (reemplazar por un material autorizado)'),
        T_TIPO_DATA('DIV-OM130','Sustitución de interruptor, enchufe, timbre Mod. Simón 31 o similar','Sustitución de interruptor, enchufe, timbre Mod. Simón 31 o similar'),
        T_TIPO_DATA('DIV-OM131','Sustitución de diferencial hasta 2 x 40 A 30 mA','Sustitución de diferencial hasta 2 x 40 A 30 mA'),
        T_TIPO_DATA('DIV-OM132','Sustitución de diferencial de 2 x 63 A 30 mA','Sustitución de diferencial de 2 x 63 A 30 mA'),
        T_TIPO_DATA('DIV-OM133','Sustitución de diferencial hasta 4 x 40 A 300 mA','Sustitución de diferencial hasta 4 x 40 A 300 mA'),
        T_TIPO_DATA('DIV-OM134','Sustitución de diferencial de 4 x 63 A 300 mA','Sustitución de diferencial de 4 x 63 A 300 mA'),
        T_TIPO_DATA('DIV-OM135','Sustitución de magnetotérmico de 2 x 25 A','Sustitución de magnetotérmico de 2 x 25 A'),
        T_TIPO_DATA('DIV-OM136','Sustitución de magnetotérmico de 2 x 40','Sustitución de magnetotérmico de 2 x 40'),
        T_TIPO_DATA('DIV-OM137','Sustitución de magnetotérmico de 2 x 50','Sustitución de magnetotérmico de 2 x 50'),
        T_TIPO_DATA('DIV-OM138','Apertura/Descerraje de cerradura estándar o de seguridad media sin sustitución ni reposición de elem','Apertura/Descerraje de cerradura estándar o de seguridad media sin sustitución ni reposición de elementos.'),
        T_TIPO_DATA('DIV-OM14','Sustitución de desagüe de PVC hasta 1 metro','Sustitución de desagüe de PVC hasta 1 metro'),
        T_TIPO_DATA('DIV-OM145','Sustitución de hoja de puerta de paso (solo mano de obra)','Sustitución de hoja de puerta de paso (solo mano de obra)'),
        T_TIPO_DATA('DIV-OM146','Sustitución de hoja de puerta corredera (solo mano de obra)','Sustitución de hoja de puerta corredera (solo mano de obra)'),
        T_TIPO_DATA('DIV-OM147','Sustitución de hoja de puerta blindada (solo mano de obra)','Sustitución de hoja de puerta blindada (solo mano de obra)'),
        T_TIPO_DATA('DIV-OM148','Sustitución de puerta acorazada (solo mano de obra)','Sustitución de puerta acorazada (solo mano de obra)'),
        T_TIPO_DATA('DIV-OM149','Ajuste de puerta de paso','Ajuste de puerta de paso'),
        T_TIPO_DATA('DIV-OM15','Sustitución de desagüe de PVC hasta 3 metros','Sustitución de desagüe de PVC hasta 3 metros'),
        T_TIPO_DATA('DIV-OM150','Ajuste de puerta corredera','Ajuste de puerta corredera'),
        T_TIPO_DATA('DIV-OM151','Ajuste de puerta blindada','Ajuste de puerta blindada'),
        T_TIPO_DATA('DIV-OM152','Ajuste de puerta acorazada','Ajuste de puerta acorazada'),
        T_TIPO_DATA('DIV-OM153','Descolgamiento de puerta de paso','Descolgamiento de puerta de paso'),
        T_TIPO_DATA('DIV-OM154','Descolgamiento de puerta corredera','Descolgamiento de puerta corredera'),
        T_TIPO_DATA('DIV-OM155','Descolgamiento de puerta blindada','Descolgamiento de puerta blindada'),
        T_TIPO_DATA('DIV-OM156','Descolgamiento de puerta acorazada','Descolgamiento de puerta acorazada'),
        T_TIPO_DATA('DIV-OM157','Sustitución de cerradura puerta de paso','Sustitución de cerradura puerta de paso'),
        T_TIPO_DATA('DIV-OM158','Sustitución de bisagras puerta de paso','Sustitución de bisagras puerta de paso'),
        T_TIPO_DATA('DIV-OM159','Sustitución de manetas puerta de paso','Sustitución de manetas puerta de paso'),
        T_TIPO_DATA('DIV-OM16','Sustitución de tubería de alimentación hasta 1 metro lineal','Sustitución de tubería de alimentación hasta 1 metro lineal'),
        T_TIPO_DATA('DIV-OM160','Cepillado de puerta por roce','Cepillado de puerta por roce'),
        T_TIPO_DATA('DIV-OM161','Ajuste y regulación de frente de armario','Ajuste y regulación de frente de armario'),
        T_TIPO_DATA('DIV-OM162','Sustituir puerta de armario (Sin material)','Sustituir puerta de armario (Sin material)'),
        T_TIPO_DATA('DIV-OM163','Sustitución de molduras metro lineal','Sustitución de molduras metro lineal'),
        T_TIPO_DATA('DIV-OM164','Ajuste de puertas armarios cocina','Ajuste de puertas armarios cocina'),
        T_TIPO_DATA('DIV-OM165','Ajuste de muebles de cocina','Ajuste de muebles de cocina'),
        T_TIPO_DATA('DIV-OM166','Clavado y sellado de jambas (precio por puerta)','Clavado y sellado de jambas (precio por puerta)'),
        T_TIPO_DATA('DIV-OM167','Preparación de suelo con pasta niveladora por m² espesor entre 5 mm-25 mm','Preparación de suelo con pasta niveladora por m² espesor entre 5 mm-25 mm'),
        T_TIPO_DATA('DIV-OM168','Lijado y barnizado hasta 15 m²','Lijado y barnizado hasta 15 m²'),
        T_TIPO_DATA('DIV-OM169','Lijado y barnizado por m² adicional','Lijado y barnizado por m² adicional'),
        T_TIPO_DATA('DIV-OM17','Sustitución de tubería de alimentación hasta 2 metros lineales','Sustitución de tubería de alimentación hasta 2 metros lineales'),
        T_TIPO_DATA('DIV-OM170','M² parquet roble damas','M² parquet roble damas'),
        T_TIPO_DATA('DIV-OM171','M² parquet roble tablillas','M² parquet roble tablillas'),
        T_TIPO_DATA('DIV-OM172','M² parquet roble baldosa','M² parquet roble baldosa'),
        T_TIPO_DATA('DIV-OM173','M² tarima roble','M² tarima roble'),
        T_TIPO_DATA('DIV-OM174','M² parquet eucalipto damas','M² parquet eucalipto damas'),
        T_TIPO_DATA('DIV-OM175','M² parquet eucalipto tablillas','M² parquet eucalipto tablillas'),
        T_TIPO_DATA('DIV-OM176','M² parquet pino oregón','M² parquet pino oregón'),
        T_TIPO_DATA('DIV-OM177','M² tarima pino viejo','M² tarima pino viejo'),
        T_TIPO_DATA('DIV-OM178','MI rodapié aglomerado','MI rodapié aglomerado'),
        T_TIPO_DATA('DIV-OM179','MI rodapié macizo 7 cm','MI rodapié macizo 7 cm'),
        T_TIPO_DATA('DIV-OM18','Sustitución de tubería de alimentación hasta 3 metros lineales','Sustitución de tubería de alimentación hasta 3 metros lineales'),
        T_TIPO_DATA('DIV-OM180','Ml rodapié macizo 10 cm','Ml rodapié macizo 10 cm'),
        T_TIPO_DATA('DIV-OM181','Ml barnizado de rodapié poliuretano','Ml barnizado de rodapié poliuretano'),
        T_TIPO_DATA('DIV-OM182','Hora de trabajo de Oficial electricista','Hora de trabajo de Oficial electricista'),
        T_TIPO_DATA('DIV-OM183','Hora de trabajo de Oficial parquetista','Hora de trabajo de Oficial parquetista'),
        T_TIPO_DATA('DIV-OM184','Hora de trabajo de Oficial carpintero','Hora de trabajo de Oficial carpintero'),
        T_TIPO_DATA('DIV-OM185','Hora de trabajo de Oficial pintor','Hora de trabajo de Oficial pintor'),
        T_TIPO_DATA('DIV-OM186','Hora de trabajo de Oficial albañil','Hora de trabajo de Oficial albañil'),
        T_TIPO_DATA('DIV-OM187','Hora de trabajo de Oficial fontanero','Hora de trabajo de Oficial fontanero'),
        T_TIPO_DATA('DIV-OM188','Hora de trabajo de Oficial cerrajero','Hora de trabajo de Oficial cerrajero'),
        T_TIPO_DATA('DIV-OM189','Hora de trabajo de Oficial frigorista','Hora de trabajo de Oficial frigorista'),
        T_TIPO_DATA('DIV-OM19','Sustitución de tubería de alimentación hasta 6 metros lineales','Sustitución de tubería de alimentación hasta 6 metros lineales'),
        T_TIPO_DATA('DIV-OM190','Hora de trabajo de Oficial calefactor','Hora de trabajo de Oficial calefactor'),
        T_TIPO_DATA('DIV-OM191','Hora de trabajo de Oficial polivalente','Hora de trabajo de Oficial polivalente'),
        T_TIPO_DATA('DIV-OM192','Hora de trabajo de Limpiador','Hora de trabajo de Limpiador'),
        T_TIPO_DATA('DIV-OM193','Hora de trabajo de peón no cualificado','Hora de trabajo de peón no cualificado'),
        T_TIPO_DATA('DIV-OM194','Hora de trabajo de Oficial polivalente (de 22:00 a 08:00 horas y festivos)','Hora de trabajo de Oficial polivalente (de 22:00 a 08:00 horas y festivos)'),
        T_TIPO_DATA('DIV-OM195','Hora de trabajo de Encargado','Hora de trabajo de Encargado'),
        T_TIPO_DATA('DIV-OM196','Hora de trabajo de Auxiliar Administrativo','Hora de trabajo de Auxiliar Administrativo'),
        T_TIPO_DATA('DIV-OM197','Hora de trabajo de Oficial de 2ª','Hora de trabajo de Oficial de 2ª'),
        T_TIPO_DATA('DIV-OM198','Hora de trabajo de Ayudante de oficio','Hora de trabajo de Ayudante de oficio'),
        T_TIPO_DATA('DIV-OM199','Hora de trabajo de Peón especializado','Hora de trabajo de Peón especializado'),
        T_TIPO_DATA('DIV-OM20','Sustitución de tubería de agua fría y caliente 1 metro lineal cada una','Sustitución de tubería de agua fría y caliente 1 metro lineal cada una'),
        T_TIPO_DATA('DIV-OM200','Desplazamiento de camión de desatranco','Desplazamiento de camión de desatranco'),
        T_TIPO_DATA('DIV-OM201','Hora de trabajo de camión de desatranco','Hora de trabajo de camión de desatranco'),
        T_TIPO_DATA('DIV-OM202','Hora de mano trabajo de cerrajería urgente','Hora de mano trabajo de cerrajería urgente'),
        T_TIPO_DATA('DIV-OM203','M² Desbroce de parcela con maquinaria. Gestión de residuos incluida','M² Desbroce de parcela con maquinaria. Gestión de residuos incluida'),
        T_TIPO_DATA('DIV-OM204','M² Desbroce manual de parcela/jardín. Gestión de residuos incluida','M² Desbroce manual de parcela/jardín. Gestión de residuos incluida'),
        T_TIPO_DATA('DIV-OM206','M² Aplicación de herbicida sistémico no selectivo junto con herbicida de post-emergencia','M² Aplicación de herbicida sistémico no selectivo junto con herbicida de post-emergencia'),
        T_TIPO_DATA('DIV-OM207','M² Poda, puntual y selectiva, manual, con todos los útiles necesarios. Gestión de residuos incluida','M² Poda, puntual y selectiva, manual, con todos los útiles necesarios. Gestión de residuos incluida'),
        T_TIPO_DATA('DIV-OM208','M Vallado con simple torsión hasta 2 m de altura, incluso postes de sujeción cada 3 metros. Unidad t','M Vallado con simple torsión hasta 2 m de altura, incluso postes de sujeción cada 3 metros. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos'),
        T_TIPO_DATA('DIV-OM209','M Vallado con bloque de hormigón, hasta una altura de 2 m enfoscado, con pilares cada 3m, maestreado','M Vallado con bloque de hormigón, hasta una altura de 2 m enfoscado, con pilares cada 3m, maestreado y pintado en blanco. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de'),
        T_TIPO_DATA('DIV-OM21','Sustitución tubería de agua fría y caliente 2 metros lineales cada una','Sustitución tubería de agua fría y caliente 2 metros lineales cada una'),
        T_TIPO_DATA('DIV-OM210','Ud suministro e instalación puerta metálica de malla de acero galvanizado para acceso peatonal (0,8 ','Ud suministro e instalación puerta metálica de malla de acero galvanizado para acceso peatonal (0,8 - 1m) de paso, candado incluido. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso'),
        T_TIPO_DATA('DIV-OM211','Ud suministro e instalación puerta abatible de 3x2 m., candado incluido. Unidad totalmente terminada','Ud suministro e instalación puerta abatible de 3x2 m., candado incluido. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos'),
        T_TIPO_DATA('DIV-OM212','Ud Limpieza general del inmueble: retirada de basuras, restos de comida, etc… sin contenedor (únicam','Ud Limpieza general del inmueble: retirada de basuras, restos de comida, etc… sin contenedor (únicamente bolsas). Gestión de residuos incluida. Hasta 1 m3'),
        T_TIPO_DATA('DIV-OM213','Ud Limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escomb','Ud Limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escombros, etc. (utilizando un contenedor de aprox 6 m3) Gestión de residuos incluida'),
        T_TIPO_DATA('DIV-OM214','Ud Contenedor adicional (6 m3) en limpieza general del inmueble: retirada de basuras, restos de comi','Ud Contenedor adicional (6 m3) en limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escombros, etc. Gestión de residuos incluida'),
        T_TIPO_DATA('DIV-OM215','Ud Desinsectación contra todo tipo de insectos voladores o rastreros, incluido certificado. (Superfi','Ud Desinsectación contra todo tipo de insectos voladores o rastreros, incluido certificado. (Superficie hasta 400 m²)'),
        T_TIPO_DATA('DIV-OM218','M² Reparación de humedades en fachada de unifamiliares','M² Reparación de humedades en fachada de unifamiliares'),
        T_TIPO_DATA('DIV-OM219','M² Reparación grietas en fachada de unifamiliares','M² Reparación grietas en fachada de unifamiliares'),
        T_TIPO_DATA('DIV-OM22','Sustitución tubería de agua fría y caliente hasta 3 metros lineales cada una','Sustitución tubería de agua fría y caliente hasta 3 metros lineales cada una'),
        T_TIPO_DATA('DIV-OM220','M² Reparación de humedades en cubierta con impermeabilizante','M² Reparación de humedades en cubierta con impermeabilizante'),
        T_TIPO_DATA('DIV-OM221','M² Reparación grietas en cubierta con impermeabilizante','M² Reparación grietas en cubierta con impermeabilizante'),
        T_TIPO_DATA('DIV-OM229','Ud Repaso de instalación eléctrica y telecomunicaciones de vivienda NO incluida la colocación de las','Ud Repaso de instalación eléctrica y telecomunicaciones de vivienda NO incluida la colocación de las tapas de cajas y mecanismos faltantes'),
        T_TIPO_DATA('DIV-OM23','Sustitución de tubería de agua fría y caliente hasta 6 m 1 cada una','Sustitución de tubería de agua fría y caliente hasta 6 m 1 cada una'),
        T_TIPO_DATA('DIV-OM230','Ud Colocación de caja general de protección de la vivienda según normativa de instalación, totalment','Ud Colocación de caja general de protección de la vivienda según normativa de instalación, totalmente terminada'),
        T_TIPO_DATA('DIV-OM231','Ud Suministro y colocación de timbre. Con instalación de cableado','Ud Suministro y colocación de timbre. Con instalación de cableado'),
        T_TIPO_DATA('DIV-OM232','Ud Instalación de toma de corriente para calentador, incluido cableado, mecanismo de superficie o em','Ud Instalación de toma de corriente para calentador, incluido cableado, mecanismo de superficie o empotrado y canaleta'),
        T_TIPO_DATA('DIV-OM233','Calentador de gas de agua interior mural, vertical para 6l/min con tiro natural, colocado y probado.','Calentador de gas de agua interior mural, vertical para 6l/min con tiro natural, colocado y probado. Incluyendo boletín y legalización'),
        T_TIPO_DATA('DIV-OM234','Ud Suministro y colocación Termo eléctrico 50 litros para A.C.S. mural vertical con resistencia blin','Ud Suministro y colocación Termo eléctrico 50 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado'),
        T_TIPO_DATA('DIV-OM235','Ud Suministro y colocación Termo eléctrico 100 litros para A.C.S. mural vertical con resistencia bli','Ud Suministro y colocación Termo eléctrico 100 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado'),
        T_TIPO_DATA('DIV-OM236','Ud Instalación de salida de humos calentador, de chapa de acero de 150mm, sin incluir perforación de','Ud Instalación de salida de humos calentador, de chapa de acero de 150mm, sin incluir perforación de fachada, aunque sí su sellado y resolución de encuentros'),
        T_TIPO_DATA('DIV-OM237','Ud Instalación fontanería para calentador','Ud Instalación fontanería para calentador'),
        T_TIPO_DATA('DIV-OM238','Ud Sustitución de llave de paso','Ud Sustitución de llave de paso'),
        T_TIPO_DATA('DIV-OM239','Ud Suministro e instalación de fregadero de cocina metálico, de hasta 90 cm de anchura, con senos y/','Ud Suministro e instalación de fregadero de cocina metálico, de hasta 90 cm de anchura, con senos y/o escurridor'),
        T_TIPO_DATA('DIV-OM24','Sustitución manguetón PVC (Incluido desmontar y montar inodoro)','Sustitución manguetón PVC (Incluido desmontar y montar inodoro)'),
        T_TIPO_DATA('DIV-OM240','Ud Suministro e instalación Rejilla de baño','Ud Suministro e instalación Rejilla de baño'),
        T_TIPO_DATA('DIV-OM241','Ud Suministro e instalación de bidet cerámico color estándar a elegir, sin incluir grifería','Ud Suministro e instalación de bidet cerámico color estándar a elegir, sin incluir grifería'),
        T_TIPO_DATA('DIV-OM242','Suministro e instalación de lavabo cerámico color estándar a elegir de un seno y sustentado sobre pi','Suministro e instalación de lavabo cerámico color estándar a elegir de un seno y sustentado sobre pie cerámico, sin incluir grifería'),
        T_TIPO_DATA('DIV-OM243','Ud Suministro e instalación de inodoro cerámico color estándar a elegir, con tanque bajo','Ud Suministro e instalación de inodoro cerámico color estándar a elegir, con tanque bajo'),
        T_TIPO_DATA('DIV-OM244','Suministro e instalación de tapa de inodoro','Suministro e instalación de tapa de inodoro'),
        T_TIPO_DATA('DIV-OM245','Ud Suministro e instalación de descarga de inodoro','Ud Suministro e instalación de descarga de inodoro'),
        T_TIPO_DATA('DIV-OM246','Ud suministro de llave magnética codificada','Ud suministro de llave magnética codificada'),
        T_TIPO_DATA('DIV-OM247','Ud suministro de mando de garaje codificado','Ud suministro de mando de garaje codificado'),
        T_TIPO_DATA('DIV-OM248','M² Recolocación de placas de escayola desmontable con perfiles, situados a una altura de hasta 4m','M² Recolocación de placas de escayola desmontable con perfiles, situados a una altura de hasta 4m'),
        T_TIPO_DATA('DIV-OM249','M² Recolocación de placas de escayola desmontable sin perfiles, situados a una altura de hasta 4m','M² Recolocación de placas de escayola desmontable sin perfiles, situados a una altura de hasta 4m'),
        T_TIPO_DATA('DIV-OM25','Sustitución manguetón plomo (Incluido desmontar y montar inodoro) (reemplazar por un material autori','Sustitución manguetón plomo (Incluido desmontar y montar inodoro) (reemplazar por un material autorizado)'),
        T_TIPO_DATA('DIV-OM250','Ud Revisión de la instalación de gas de vivienda','Ud Revisión de la instalación de gas de vivienda'),
        T_TIPO_DATA('DIV-OM251','Ud Suministro e instalación de caldera de condensación de gas de vivienda, incluyendo la instalación','Ud Suministro e instalación de caldera de condensación de gas de vivienda, incluyendo la instalación de ventilación, el boletín y la legalización.'),
        T_TIPO_DATA('DIV-OM252','Suministro e instalación de puerta antiocupa homologada cumpliendo normativa europea y suministrada ','Suministro e instalación de puerta antiocupa homologada cumpliendo normativa europea y suministrada igualmente por fabricante competente para emitir su certificado de idoneidad'),
        T_TIPO_DATA('DIV-OM253','Tapiado con fábrica de ladrillo de 1/2 pie','Tapiado con fábrica de ladrillo de 1/2 pie'),
        T_TIPO_DATA('DIV-OM254','Tapiado con fábrica de bloque de hormigón armado','Tapiado con fábrica de bloque de hormigón armado'),
        T_TIPO_DATA('DIV-OM255','Tapiado con malla armada plastificada Pecafil, fabricada por Max Frank GmbH y Co. KG, o similar','Tapiado con malla armada plastificada Pecafil, fabricada por Max Frank GmbH y Co. KG, o similar'),
        T_TIPO_DATA('DIV-OM256','Solado o alicatado de elementos de gran formato y/o porcelánicos (sin material)','Solado o alicatado de elementos de gran formato y/o porcelánicos (sin material)'),
        T_TIPO_DATA('DIV-OM257','Solado o alicatado de piedra natural incluyendo el material pétreo, todo el resto de material y trab','Solado o alicatado de piedra natural incluyendo el material pétreo, todo el resto de material y trabajos auxiliares'),
        T_TIPO_DATA('DIV-OM258','Piezas pétreas en fachada mediante anclajes de acero inox','Piezas pétreas en fachada mediante anclajes de acero inox'),
        T_TIPO_DATA('DIV-OM259','Cartelería "Prohibido el paso a todo personal ajeno a la obra. Precaución con los menores"','Cartelería "Prohibido el paso a todo personal ajeno a la obra. Precaución con los menores"'),
        T_TIPO_DATA('DIV-OM26','Sustitución de bote sifónico normal','Sustitución de bote sifónico normal'),
        T_TIPO_DATA('DIV-OM260','Suministro e instalación de detector de presencia para instalación eléctrica','Suministro e instalación de detector de presencia para instalación eléctrica'),
        T_TIPO_DATA('DIV-OM261','Cartelería de instalación de protección contra incendios (salidas de evacuación, extintores, etc.)','Cartelería de instalación de protección contra incendios (salidas de evacuación, extintores, etc.)'),
        T_TIPO_DATA('DIV-OM262','Suministro e instalación de boca de incendio equipada 25 m incluyendo señalización(s/ CTE)','Suministro e instalación de boca de incendio equipada 25 m incluyendo señalización(s/ CTE)'),
        T_TIPO_DATA('DIV-OM263','Suministro e instalación de boca de incendio equipada 45 m incluyendo señalización(s/ CTE)','Suministro e instalación de boca de incendio equipada 45 m incluyendo señalización(s/ CTE)'),
        T_TIPO_DATA('DIV-OM264','Suministro y sustitución de manguera en BIE de 25m (incluyendo material)','Suministro y sustitución de manguera en BIE de 25m (incluyendo material)'),
        T_TIPO_DATA('DIV-OM265','Suministro y sustitución de manguera en BIE de 45m (incluyendo material)','Suministro y sustitución de manguera en BIE de 45m (incluyendo material)'),
        T_TIPO_DATA('DIV-OM266','Suministro e instalación de puerta EF 30 (s/ CTE), 90x210 totalmente rematada y terminada','Suministro e instalación de puerta EF 30 (s/ CTE), 90x210 totalmente rematada y terminada'),
        T_TIPO_DATA('DIV-OM267','Suministro e instalación de puerta EF 60 (s/ CTE), 90x210 totalmente rematada y terminada','Suministro e instalación de puerta EF 60 (s/ CTE), 90x210 totalmente rematada y terminada'),
        T_TIPO_DATA('DIV-OM268','Suministro e instalación de luminaria de emergencia (s/ CTE)','Suministro e instalación de luminaria de emergencia (s/ CTE)'),
        T_TIPO_DATA('DIV-OM269','Suministro y colocación de suelos formado por lamas machihembradas/encoladas de aspecto similar al p','Suministro y colocación de suelos formado por lamas machihembradas/encoladas de aspecto similar al parquet flotante con un laminado plástico estratificado o un recubrimiento melamínico'),
        T_TIPO_DATA('DIV-OM27','Encasquillado de bote sifónico','Encasquillado de bote sifónico'),
        T_TIPO_DATA('DIV-OM270','Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen','Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen'),
        T_TIPO_DATA('DIV-OM271','Impermeabilización de cubierta plana asfáltica, no incluyendo retirada ni reposición de material de ','Impermeabilización de cubierta plana asfáltica, no incluyendo retirada ni reposición de material de protección de la lámina. Incluyendo p.p. de remates de desagües, esquinas y cualquier otro elemento que interrumpa la tela'),
        T_TIPO_DATA('DIV-OM272','Suministro e instalación de extintor de incendios portátil de eficacia 21A -113B incluyendo soporte ','Suministro e instalación de extintor de incendios portátil de eficacia 21A -113B incluyendo soporte y señalización (s/ CTE)'),
        T_TIPO_DATA('DIV-OM273','Impermeabilización de cubierta plana de PVC, no incluyendo retirada ni reposición de material de pro','Impermeabilización de cubierta plana de PVC, no incluyendo retirada ni reposición de material de protección de la lámina. Incluyendo p.p. de remates de desagües, esquinas y cualquier otro elemento que interrumpa la membrana'),
        T_TIPO_DATA('DIV-OM274','Retirada de teja cerámica o de hormigón, reparación de la impermeabilización y reposición posterior ','Retirada de teja cerámica o de hormigón, reparación de la impermeabilización y reposición posterior de la teja, con recibido si es necesario (sin aporte de material)'),
        T_TIPO_DATA('DIV-OM275','Drenaje de trasdós de muro mediante excavación, colocación de lámina de drenaje, instalación de tubo','Drenaje de trasdós de muro mediante excavación, colocación de lámina de drenaje, instalación de tubo dren y relleno posterior con grava según CTE, hasta 3 m de profundidad'),
        T_TIPO_DATA('DIV-OM276','Suministro e instalación mediante anclajes epoxi de rejas de protección en ventanas/ puertas, realiz','Suministro e instalación mediante anclajes epoxi de rejas de protección en ventanas/ puertas, realizadas con hierro tratado contra la corrosión'),
        T_TIPO_DATA('DIV-OM277','Revisión, legalización y puesta en marcha de ascensor de hasta 4 alturas','Revisión, legalización y puesta en marcha de ascensor de hasta 4 alturas'),
        T_TIPO_DATA('DIV-OM278','Revisión, legalización y puesta en marcha de ascensor de hasta 9 alturas','Revisión, legalización y puesta en marcha de ascensor de hasta 9 alturas'),
        T_TIPO_DATA('DIV-OM279','Limpieza de sumidero en cubierta / patio / garaje','Limpieza de sumidero en cubierta / patio / garaje'),
        T_TIPO_DATA('DIV-OM28','Sustitución de bote sifónico de PVC','Sustitución de bote sifónico de PVC'),
        T_TIPO_DATA('DIV-OM280','Limpieza de arqueta de cualquier tipo','Limpieza de arqueta de cualquier tipo'),
        T_TIPO_DATA('DIV-OM281','Reparación de acera mediante elemento continuo de hormigón pulido / impreso','Reparación de acera mediante elemento continuo de hormigón pulido / impreso'),
        T_TIPO_DATA('DIV-OM282','Reparación de acera mediante elemento discontinuo de baldosa / adoquín','Reparación de acera mediante elemento discontinuo de baldosa / adoquín'),
        T_TIPO_DATA('DIV-OM283','Limpieza y desatranco de canaletas e cubierta / patio / garaje con retirada de escombro a vertedero','Limpieza y desatranco de canaletas e cubierta / patio / garaje con retirada de escombro a vertedero'),
        T_TIPO_DATA('DIV-OM284','Limpieza de canalones de cualquier material y sección','Limpieza de canalones de cualquier material y sección'),
        T_TIPO_DATA('DIV-OM285','Suministro e instalación de grifería monomando de cocina de acero, para colocar empotrado en fregade','Suministro e instalación de grifería monomando de cocina de acero, para colocar empotrado en fregadero'),
        T_TIPO_DATA('DIV-OM286','Suministro e instalación de grifería monomando de lavabo/bidet de acero','Suministro e instalación de grifería monomando de lavabo/bidet de acero'),
        T_TIPO_DATA('DIV-OM287','Suministro e instalación de grifería monomando de bañera de acero, con doble salida a grifo y flexo.','Suministro e instalación de grifería monomando de bañera de acero, con doble salida a grifo y flexo. Incluyendo manguera y ducha'),
        T_TIPO_DATA('DIV-OM288','Visita para verificación de activo','Visita para verificación de activo'),
        T_TIPO_DATA('DIV-OM289','Tala de árbol < 6 m de altura sacando el tocón','Tala de árbol < 6 m de altura sacando el tocón'),
        T_TIPO_DATA('DIV-OM29','Hacer junta de manguetón WC. con inodoro o bajante general (un)','Hacer junta de manguetón WC. con inodoro o bajante general (un)'),
        T_TIPO_DATA('DIV-OM290','Tala de árbol < 6 m de altura sin sacar el tocón','Tala de árbol < 6 m de altura sin sacar el tocón'),
        T_TIPO_DATA('DIV-OM291','Tala de árbol 10/15m de altura sacando el tocón','Tala de árbol 10/15m de altura sacando el tocón'),
        T_TIPO_DATA('DIV-OM292','Tala de árbol 10/15m de altura sin sacar el tocón','Tala de árbol 10/15m de altura sin sacar el tocón'),
        T_TIPO_DATA('DIV-OM293','Tala de árbol 6/10m de altura sacando el tocón','Tala de árbol 6/10m de altura sacando el tocón'),
        T_TIPO_DATA('DIV-OM294','Tala de árbol 6/10m de altura sin sacar el tocón','Tala de árbol 6/10m de altura sin sacar el tocón'),
        T_TIPO_DATA('DIV-OM295','Aislamiento espuma poliuret. 4 cm proyectada','Aislamiento espuma poliuret. 4 cm proyectada'),
        T_TIPO_DATA('DIV-OM296','Excavación tierras + transporte a vertedero','Excavación tierras + transporte a vertedero'),
        T_TIPO_DATA('DIV-OM297','Relleno de zanjas con arena','Relleno de zanjas con arena'),
        T_TIPO_DATA('DIV-OM298','Terraplenado con tierras adecuadas 95% PM','Terraplenado con tierras adecuadas 95% PM'),
        T_TIPO_DATA('DIV-OM299','Terraplenado con zahorra artificial 95% PM','Terraplenado con zahorra artificial 95% PM'),
        T_TIPO_DATA('DIV-OM3','Segunda localización: verificación y observación de avería','Segunda localización: verificación y observación de avería'),
        T_TIPO_DATA('DIV-OM30','Sustitución de válvula y rebosadero de bañera','Sustitución de válvula y rebosadero de bañera'),
        T_TIPO_DATA('DIV-OM300','Poda de árbol con cesta de 15 a 20 m de altura','Poda de árbol con cesta de 15 a 20 m de altura'),
        T_TIPO_DATA('DIV-OM301','Poda de árbol con cesta de 6 a 10 m de altura','Poda de árbol con cesta de 6 a 10 m de altura'),
        T_TIPO_DATA('DIV-OM302','Poda de árbol con trepa de 15 a 20 m de altura','Poda de árbol con trepa de 15 a 20 m de altura'),
        T_TIPO_DATA('DIV-OM303','Derribo de cielo raso + Carga escombros','Derribo de cielo raso + Carga escombros'),
        T_TIPO_DATA('DIV-OM304','Suministro de copia de llave de seguridad intermedia (llave de puntos o similar)','Suministro de copia de llave de seguridad intermedia (llave de puntos o similar)'),
        T_TIPO_DATA('DIV-OM305','Sustitución de bombillo de buzón','Sustitución de bombillo de buzón'),
        T_TIPO_DATA('DIV-OM306','Suministro e instalación de escudo de seguridad media','Suministro e instalación de escudo de seguridad media'),
        T_TIPO_DATA('DIV-OM307','Suministro e instalación de candado, incluida cadena hasta 0,5mts en caso necesario y descerraje de ','Suministro e instalación de candado, incluida cadena hasta 0,5mts en caso necesario y descerraje de candado existente si fuere necesario'),
        T_TIPO_DATA('DIV-OM308','Desmontaje y retirada de puerta antiocupa.','Desmontaje y retirada de puerta antiocupa.'),
        T_TIPO_DATA('DIV-OM309','Suministro e instalación de juego de tapetas gama media en acabado lacado blanco, para las dos caras','Suministro e instalación de juego de tapetas gama media en acabado lacado blanco, para las dos caras de una puerta'),
        T_TIPO_DATA('DIV-OM31','Reparar mangueta o bote sifónico o desagüe o tubería sin sustitución','Reparar mangueta o bote sifónico o desagüe o tubería sin sustitución'),
        T_TIPO_DATA('DIV-OM310','Suministro e instalación de Hoja de Puerta abatible interior de hasta 100 cms gama media en acabado ','Suministro e instalación de Hoja de Puerta abatible interior de hasta 100 cms gama media en acabado lacado blanco, incluyendo: puerta, bisagras y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM311','Suministro e instalación de Puerta abatible block interior de hasta 100 cms gama media en acabado la','Suministro e instalación de Puerta abatible block interior de hasta 100 cms gama media en acabado lacado blanco, incluyendo: puerta, bisagras, batientes, tapetas y manetas. Incluidos todos los trabajos necesarios para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM312','Suministro e instalación de Puerta abatible de Entrada en block de hasta 100 cms BLINDADA (gama medi','Suministro e instalación de Puerta abatible de Entrada en block de hasta 100 cms BLINDADA (gama media) en acabado de melamina, incluyendo: puerta, bisagras, batientes, tapetas, cerradura, pomo y manetas. Incluidos todos los trabajos necesarios para l'),
        T_TIPO_DATA('DIV-OM313','ML. Sellado de carpintería de aluminio con encuentros de fabrica de fachada y albardillas','ML. Sellado de carpintería de aluminio con encuentros de fabrica de fachada y albardillas'),
        T_TIPO_DATA('DIV-OM314','UD. Ajuste o reparación de cierres de carpintería metálica corredera. Ventana o puerta','UD. Ajuste o reparación de cierres de carpintería metálica corredera. Ventana o puerta'),
        T_TIPO_DATA('DIV-OM315','UD. Ajuste o reparación de cierres de carpintería metálica abatible. Ventana o puerta','UD. Ajuste o reparación de cierres de carpintería metálica abatible. Ventana o puerta'),
        T_TIPO_DATA('DIV-OM316','Suministro e instalación de vidrio con cámara de 4/8/4 mm, incluidos todos los trabajos necesarios p','Suministro e instalación de vidrio con cámara de 4/8/4 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM317','Desmontaje y retirada de Parquet flotante, incluso zócalo, capas inferiores de aislamiento y pasos d','Desmontaje y retirada de Parquet flotante, incluso zócalo, capas inferiores de aislamiento y pasos de puerta existentes, incluyendo gestión de residuos a vertedero autorizado'),
        T_TIPO_DATA('DIV-OM318','Limpieza de terraza. Incluidos los imbornales, sumideros y elementos existentes hasta 15m²','Limpieza de terraza. Incluidos los imbornales, sumideros y elementos existentes hasta 15m²'),
        T_TIPO_DATA('DIV-OM319','Limpieza general de piscina de Sup. <=35 m2  (Incluido vaciado)','Limpieza general de piscina de Sup. <=35 m2  (Incluido vaciado)'),
        T_TIPO_DATA('DIV-OM32','Colocación de gebo 1 unidad hasta 1/2 pulgada','Colocación de gebo 1 unidad hasta 1/2 pulgada'),
        T_TIPO_DATA('DIV-OM320','Limpieza general de piscina de Sup. De >35 m2  (Incluido vaciado)','Limpieza general de piscina de Sup. De >35 m2  (Incluido vaciado)'),
        T_TIPO_DATA('DIV-OM321','Suministro y colocación de Valla trasladable de obra o similar de 3,50x2,00 m, formada por panel de ','Suministro y colocación de Valla trasladable de obra o similar de 3,50x2,00 m, formada por panel de malla electrosoldada y postes verticales, acabado galvanizado, colocados sobre bases prefabricadas de hormigón, con malla de ocultación colocada sobre'),
        T_TIPO_DATA('DIV-OM322','Vallado de 2m de altura, compuesto por paneles opacos de chapa perfilada nervada de acero UNE-EN 103','Vallado de 2m de altura, compuesto por paneles opacos de chapa perfilada nervada de acero UNE-EN 10346 S320 GD galvanizado de 0,6 mm espesor y 30 mm altura de cresta, incluidos postes de sujeción cada 2ml.'),
        T_TIPO_DATA('DIV-OM323','Suministro y colocación de cercado mediante chapa plegada o similar en acabado galvanizado y altura ','Suministro y colocación de cercado mediante chapa plegada o similar en acabado galvanizado y altura hasta 200 cms, con los postes y tensores necesarios en función de la geometría del solar, incluidos los pies, anclajes y/o empotramientos necesarios p'),
        T_TIPO_DATA('DIV-OM324','Ejecución de riostra de cimentación, para posterior ejecución de muro de vallado de obra, de 40 cms ','Ejecución de riostra de cimentación, para posterior ejecución de muro de vallado de obra, de 40 cms de ancho y 60 cms de profundidad armada con 4Ø12 y estribos de Ø10 cada 30 cms, con hormigón HA-25-B-20-IIA, incluso excavación en terreno blando. Inc'),
        T_TIPO_DATA('DIV-OM325','Dirección Facultativa 10.000 - 60.000 €','Dirección Facultativa 10.000 - 60.000 €'),
        T_TIPO_DATA('DIV-OM326','Dirección Facultativa > 60.000 €','Dirección Facultativa > 60.000 €'),
        T_TIPO_DATA('DIV-OM33','Colocación de gebo 1 unidad hasta 3/4 pulgada','Colocación de gebo 1 unidad hasta 3/4 pulgada'),
        T_TIPO_DATA('DIV-OM331','Coordinación de Seguridad y Salud Módulo mínimo','Coordinación de Seguridad y Salud Módulo mínimo'),
        T_TIPO_DATA('DIV-OM332','Coordinación de Seguridad y Salud > 30.000 €','Coordinación de Seguridad y Salud > 30.000 €'),
        T_TIPO_DATA('DIV-OM334','Servicio mínimo de horas de camión de desatranco, incluidos los operarios necesarios para la ejecuci','Servicio mínimo de horas de camión de desatranco, incluidos los operarios necesarios para la ejecución de los trabajos. Partida complementaria al desplazamiento del camión (a esta partida falta añadirle las horas de servicio).'),
        T_TIPO_DATA('DIV-OM335','Servicio mínimo para Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención','Servicio mínimo para Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen.'),
        T_TIPO_DATA('DIV-OM336','Suministro e instalación de extractora de baño o espacio cerrado con necesidad de ventilación i/inst','Suministro e instalación de extractora de baño o espacio cerrado con necesidad de ventilación i/instalación eléctrica,'),
        T_TIPO_DATA('DIV-OM337','Suministro e instalación de flexo de ducha de hasta 2m.','Suministro e instalación de flexo de ducha de hasta 2m.'),
        T_TIPO_DATA('DIV-OM338','Suministro e instalación de conjunto flexo y alcachofa de ducha o bañera.','Suministro e instalación de conjunto flexo y alcachofa de ducha o bañera.'),
        T_TIPO_DATA('DIV-OM339','Sellado de perímetro de bañera o plato de ducha con silicona anti moho al acido.','Sellado de perímetro de bañera o plato de ducha con silicona anti moho al acido.'),
        T_TIPO_DATA('DIV-OM34','Únicamente sustitución de sanitario','Únicamente sustitución de sanitario'),
        T_TIPO_DATA('DIV-OM340','Ud Instalación fontanería para termo. Dejando instalación lista para colocación.','Ud Instalación fontanería para termo. Dejando instalación lista para colocación.'),
        T_TIPO_DATA('DIV-OM341','Levantado y posterior recolocación de mampara de ducha o bañera, incluidos todos los trabajos necesa','Levantado y posterior recolocación de mampara de ducha o bañera, incluidos todos los trabajos necesarios para la correcta ejecución. Se contabilizará cada uno de los elementos. Se incluye el sellado final del elemento.'),
        T_TIPO_DATA('DIV-OM342','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 80 m2 o 2 habitac','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 80 m2 o 2 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros.'),
        T_TIPO_DATA('DIV-OM343','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 100 m2 o 3 habita','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 100 m2 o 3 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros.'),
        T_TIPO_DATA('DIV-OM344','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 120 m2 o 4 habita','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 120 m2 o 4 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros'),
        T_TIPO_DATA('DIV-OM345','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 150 m2 o 5 habita','Suministro y Aplicación de dos capas de pintura plástica blanca en inmueble (hasta 150 m2 o 5 habitaciones) verticales/horizontales , sobre superficies de colores blancos y neutros. Para mayores superficies o habitaciones se realizará valoración espe'),
        T_TIPO_DATA('DIV-OM346','Suministro e instalación de placa cocción de gas de 60x60 cms, incluidos todos los trabajos para la ','Suministro e instalación de placa cocción de gas de 60x60 cms, incluidos todos los trabajos para la correcta ejecución y conexionado a la instalación existente. Quedan expresamente excluidos los trabajos de adaptación de la instalación de gas a norma'),
        T_TIPO_DATA('DIV-OM347','Suministro e instalación de HORNO GAMA MEDIA E INSTALACIÓN ESTANDAR.','Suministro e instalación de HORNO GAMA MEDIA E INSTALACIÓN ESTANDAR.'),
        T_TIPO_DATA('DIV-OM348','Suministro e instalación de placa de inducción de 60x60 cms, incluidos todos los trabajos para la co','Suministro e instalación de placa de inducción de 60x60 cms, incluidos todos los trabajos para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM349','Suministro y colocación de amueblamiento de cocina gama baja-económica, compuesta por 3,5 m de muebl','Suministro y colocación de amueblamiento de cocina gama baja-económica, compuesta por 3,5 m de muebles bajos con zócalo inferior y un módulo de muebles altos de 80 cm, acabado laminado, cantos verticales post formados. Incluso zócalo inferior, y rema'),
        T_TIPO_DATA('DIV-OM35','Desmontaje y montaje de sanitarios (lavabo, bidet e inodoro)','Desmontaje y montaje de sanitarios (lavabo, bidet e inodoro)'),
        T_TIPO_DATA('DIV-OM350','Ud Revisión y prueba de instalación eléctrica, telecomunicaciones y video portero en vivienda, inclu','Ud Revisión y prueba de instalación eléctrica, telecomunicaciones y video portero en vivienda, incluso rotulación de cuadro eléctrico sin considerar elementos de protección o mecanismos que pudieran faltar.'),
        T_TIPO_DATA('DIV-OM352','Anulación y Retirada de Instalación Eléctrica Pre-existente, consistente en: Desconexión permanente ','Anulación y Retirada de Instalación Eléctrica Pre-existente, consistente en: Desconexión permanente de todas las líneas del cuadro eléctrico, retirada del cableado que pueda entorpecer para la posterior conexión de una nueva instalación al cuadro elé'),
        T_TIPO_DATA('DIV-OM353','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante ','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria'),
        T_TIPO_DATA('DIV-OM354','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante ','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria'),
        T_TIPO_DATA('DIV-OM355','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante ','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria'),
        T_TIPO_DATA('DIV-OM356','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante ','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria'),
        T_TIPO_DATA('DIV-OM357','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante ','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria'),
        T_TIPO_DATA('DIV-OM358','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante ','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria'),
        T_TIPO_DATA('DIV-OM359','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante ','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria'),
        T_TIPO_DATA('DIV-OM36','Sustitución de mecanismo de cisterna (sin material)','Sustitución de mecanismo de cisterna (sin material)'),
        T_TIPO_DATA('DIV-OM360','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante ','Suministro y Ejecución de Instalación Eléctrica Nueva para Vivienda, de manera superficial mediante canaleta, o aprovechando las canalizaciones existentes en caso de ser posible, cumpliendo las reglamentaciones mínimas exigibles según REBT, Industria'),
        T_TIPO_DATA('DIV-OM361','ML. Suministro y colocación de rodapié cerámico incluido material.','ML. Suministro y colocación de rodapié cerámico incluido material.'),
        T_TIPO_DATA('DIV-OM362','Ml. Rejuntado o sellado de rodapié con mortero hidrófugo o silicona resistencia UV','Ml. Rejuntado o sellado de rodapié con mortero hidrófugo o silicona resistencia UV'),
        T_TIPO_DATA('DIV-OM363','Ml. Sellado de juntas con mortero hidrófugo','Ml. Sellado de juntas con mortero hidrófugo'),
        T_TIPO_DATA('DIV-OM364','M2. Aplicación de lechada y llagueado de material cerámico en paramentos verticales.','M2. Aplicación de lechada y llagueado de material cerámico en paramentos verticales.'),
        T_TIPO_DATA('DIV-OM365','Derribo de cielo raso + Carga escombros','Derribo de cielo raso + Carga escombros'),
        T_TIPO_DATA('DIV-OM366','Apertura de cata en falso techo continuo/tabique/pared maestra/suelo o similar, incluso p/p de repla','Apertura de cata en falso techo continuo/tabique/pared maestra/suelo o similar, incluso p/p de replanteo, cortes, limpieza, acopio, retirada y carga manual de escombros sobre vehículo o contenedor. (máx 3m2). Aplicable para destapiado de puertas y ve'),
        T_TIPO_DATA('DIV-OM367','Suministro e instalación de teja árabe, incluidos materiales de fijación, remate y sellado del mismo','Suministro e instalación de teja árabe, incluidos materiales de fijación, remate y sellado del mismo en caso de ser necesario para la completa y correcta ejecución. Partida mínima de ejecución de 1 m2.'),
        T_TIPO_DATA('DIV-OM368','Suministro e instalación de teja de hormigón, incluidos materiales de fijación, remate y sellado del','Suministro e instalación de teja de hormigón, incluidos materiales de fijación, remate y sellado del mismo en caso de ser necesario para la completa y correcta ejecución. Partida mínima de ejecución de 1 m2.'),
        T_TIPO_DATA('DIV-OM37','Sustitución de grifería (sin material)','Sustitución de grifería (sin material)'),
        T_TIPO_DATA('DIV-OM372','Suministro e instalación de campana extractora de cocina hasta 16m² de acero inoxidable visto de cal','Suministro e instalación de campana extractora de cocina hasta 16m² de acero inoxidable visto de calidad media alta>500m³/h'),
        T_TIPO_DATA('DIV-OM373','Suministro e instalación de campana extractora de cocina hasta 10m² de acero inoxidable visto de cal','Suministro e instalación de campana extractora de cocina hasta 10m² de acero inoxidable visto de calidad media alta>500m³/h'),
        T_TIPO_DATA('DIV-OM374','Suministro e instalación de campana extractora de cocina hasta 10m²empotrable de calidad media baja>','Suministro e instalación de campana extractora de cocina hasta 10m²empotrable de calidad media baja>500m³/h'),
        T_TIPO_DATA('DIV-OM375','Suministro e instalación de encimera de cocina de calidad alta de silestone con acabado pulido o sim','Suministro e instalación de encimera de cocina de calidad alta de silestone con acabado pulido o similar, color a elegir'),
        T_TIPO_DATA('DIV-OM376','Suministro e instalación de encimera de cocina de calidad media de granito nacional pulido o similar','Suministro e instalación de encimera de cocina de calidad media de granito nacional pulido o similar'),
        T_TIPO_DATA('DIV-OM377','Suministro e instalación de encimera de cocina de calidad económica con acabado en tablero, incluyen','Suministro e instalación de encimera de cocina de calidad económica con acabado en tablero, incluyendo copas y remates de extremos, ángulos y esquinas'),
        T_TIPO_DATA('DIV-OM378','Ud Revisión de instalación fontanería en vivienda, incluyendo pruebas de presión, corrección de fuga','Ud Revisión de instalación fontanería en vivienda, incluyendo pruebas de presión, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente'),
        T_TIPO_DATA('DIV-OM379','Ud Revisión de instalación fontanería en local comercial de hasta 100m², incluyendo pruebas de servi','Ud Revisión de instalación fontanería en local comercial de hasta 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente'),
        T_TIPO_DATA('DIV-OM38','Sustitución de bañera (sin material)','Sustitución de bañera (sin material)'),
        T_TIPO_DATA('DIV-OM380','Ud Revisión de instalación fontanería en local comercial de más de 100m², incluyendo pruebas de serv','Ud Revisión de instalación fontanería en local comercial de más de 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente'),
        T_TIPO_DATA('DIV-OM381','Ud Suministro y colocación Termo eléctrico 75 litros para A.C.S. mural vertical con resistencia blin','Ud Suministro y colocación Termo eléctrico 75 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado'),
        T_TIPO_DATA('DIV-OM382','Suministro e instalación de bañera de chapa lacada de hasta 160 cm de longitud, sin incluir grifería','Suministro e instalación de bañera de chapa lacada de hasta 160 cm de longitud, sin incluir grifería'),
        T_TIPO_DATA('DIV-OM383','Suministro e instalación de bañera acrílica de hasta 160 cm de longitud, sin incluir grifería','Suministro e instalación de bañera acrílica de hasta 160 cm de longitud, sin incluir grifería'),
        T_TIPO_DATA('DIV-OM384','Suministro e instalación de plato de ducha cerámico de hasta 90x90 cm, sin incluir grifería','Suministro e instalación de plato de ducha cerámico de hasta 90x90 cm, sin incluir grifería'),
        T_TIPO_DATA('DIV-OM385','Suministro e instalación de plato de ducha cerámico mayor de 90x90 cm, sin incluir grifería','Suministro e instalación de plato de ducha cerámico mayor de 90x90 cm, sin incluir grifería'),
        T_TIPO_DATA('DIV-OM386','Suministro e instalación de plato de ducha acrílico de hasta 90x90 cm, sin incluir grifería','Suministro e instalación de plato de ducha acrílico de hasta 90x90 cm, sin incluir grifería'),
        T_TIPO_DATA('DIV-OM387','Suministro e instalación de plato de ducha acrílico mayor de 90x90 cm, sin incluir grifería','Suministro e instalación de plato de ducha acrílico mayor de 90x90 cm, sin incluir grifería'),
        T_TIPO_DATA('DIV-OM388','Reparación de persiana hasta 1 m²','Reparación de persiana hasta 1 m²'),
        T_TIPO_DATA('DIV-OM389','Reparación de persiana hasta 2 m²','Reparación de persiana hasta 2 m²'),
        T_TIPO_DATA('DIV-OM39','Unidad de desatasco en vivienda particular (En ciudad)','Unidad de desatasco en vivienda particular (En ciudad)'),
        T_TIPO_DATA('DIV-OM390','Reparación de persiana hasta 4 m²','Reparación de persiana hasta 4 m²'),
        T_TIPO_DATA('DIV-OM4','Soldadura de tuberías generales y reparación de bajantes PVC','Soldadura de tuberías generales y reparación de bajantes PVC'),
        T_TIPO_DATA('DIV-OM40','Temple liso, hasta 10 m²','Temple liso, hasta 10 m²'),
        T_TIPO_DATA('DIV-OM41','Temple liso, metro cuadrado adicional (a partir de 10 m²)','Temple liso, metro cuadrado adicional (a partir de 10 m²)'),
        T_TIPO_DATA('DIV-OM42','Temple picado, hasta 10 m²','Temple picado, hasta 10 m²'),
        T_TIPO_DATA('DIV-OM43','Temple picado, metro cuadrado adicional (a partir de 10 m²)','Temple picado, metro cuadrado adicional (a partir de 10 m²)'),
        T_TIPO_DATA('DIV-OM44','Plástico liso, hasta 10 m²','Plástico liso, hasta 10 m²'),
        T_TIPO_DATA('DIV-OM45','Plástico liso, m² adicional (a partir de 10 m²)','Plástico liso, m² adicional (a partir de 10 m²)'),
        T_TIPO_DATA('DIV-OM46','Picado, acabado plástico, hasta 10 m²','Picado, acabado plástico, hasta 10 m²'),
        T_TIPO_DATA('DIV-OM47','Picado, acabado plástico, m² adicional (a partir de 10 m²)','Picado, acabado plástico, m² adicional (a partir de 10 m²)'),
        T_TIPO_DATA('DIV-OM48','Gotelet, acabado plástico, hasta 10 metros cuadrados','Gotelet, acabado plástico, hasta 10 metros cuadrados'),
        T_TIPO_DATA('DIV-OM49','Gotelet, acabado plástico, metro adicional, a partir de 10 m²','Gotelet, acabado plástico, metro adicional, a partir de 10 m²'),
        T_TIPO_DATA('DIV-OM5','Sustitución de tubería bajante general fecales hasta 3 metros','Sustitución de tubería bajante general fecales hasta 3 metros'),
        T_TIPO_DATA('DIV-OM50','Pintura tisotrópica (paramentos muy afectados) hasta 10 m²','Pintura tisotrópica (paramentos muy afectados) hasta 10 m²'),
        T_TIPO_DATA('DIV-OM51','Pintura tisotrópica (paramentos muy afect.) m² adicional a partir de 10 m²','Pintura tisotrópica (paramentos muy afect.) m² adicional a partir de 10 m²'),
        T_TIPO_DATA('DIV-OM52','Pasta rayada, hasta 10 m²','Pasta rayada, hasta 10 m²'),
        T_TIPO_DATA('DIV-OM53','Pasta rayada, metro cuadrado adicional, a partir de 10 m²','Pasta rayada, metro cuadrado adicional, a partir de 10 m²'),
        T_TIPO_DATA('DIV-OM54','Esmalte, hasta 10 metros cuadrados','Esmalte, hasta 10 metros cuadrados'),
        T_TIPO_DATA('DIV-OM55','Esmalte, metro cuadrado adicional, a partir de 10 m²','Esmalte, metro cuadrado adicional, a partir de 10 m²'),
        T_TIPO_DATA('DIV-OM56','Tapar 1/2 m² de techo de escayola','Tapar 1/2 m² de techo de escayola'),
        T_TIPO_DATA('DIV-OM57','Tapar 1 m² de techo de escayola','Tapar 1 m² de techo de escayola'),
        T_TIPO_DATA('DIV-OM58','Tapar 2 m² de techo de escayola','Tapar 2 m² de techo de escayola'),
        T_TIPO_DATA('DIV-OM59','Tapar 3 m² de techo de escayola','Tapar 3 m² de techo de escayola'),
        T_TIPO_DATA('DIV-OM6','Sustitución de tubería bajante PVC general pluviales hasta 3 metros lineales','Sustitución de tubería bajante PVC general pluviales hasta 3 metros lineales'),
        T_TIPO_DATA('DIV-OM60','Tapar m² adicional (a partir de 3 m²) de techo de escayola','Tapar m² adicional (a partir de 3 m²) de techo de escayola'),
        T_TIPO_DATA('DIV-OM61','Hasta 3 metros lineales de moldura de escayola','Hasta 3 metros lineales de moldura de escayola'),
        T_TIPO_DATA('DIV-OM62','Metro lineal de moldura de escayola adicional','Metro lineal de moldura de escayola adicional'),
        T_TIPO_DATA('DIV-OM63','Tapar cala enlucido una o dos caras 1/2 m²','Tapar cala enlucido una o dos caras 1/2 m²'),
        T_TIPO_DATA('DIV-OM64','Tapar cala enlucido una o dos caras 1 m²','Tapar cala enlucido una o dos caras 1 m²'),
        T_TIPO_DATA('DIV-OM65','Tapar cala con alicatado o solado 1/2 m²','Tapar cala con alicatado o solado 1/2 m²'),
        T_TIPO_DATA('DIV-OM66','Tapar cala con alicatado o solado 1 m²','Tapar cala con alicatado o solado 1 m²'),
        T_TIPO_DATA('DIV-OM67','Tapar cala con alicatado o solado 2 m²','Tapar cala con alicatado o solado 2 m²'),
        T_TIPO_DATA('DIV-OM68','Tapar cala con alicatado o solado 3 m²','Tapar cala con alicatado o solado 3 m²'),
        T_TIPO_DATA('DIV-OM69','M² de alicatado o solado hasta 3 m (precio por metro)','M² de alicatado o solado hasta 3 m (precio por metro)'),
        T_TIPO_DATA('DIV-OM7','Sustitución de tubería general de alimentación hasta 3 m 1 Pulgada','Sustitución de tubería general de alimentación hasta 3 m 1 Pulgada'),
        T_TIPO_DATA('DIV-OM70','M² de alicatado o solado más de 3 m (precio por metro)','M² de alicatado o solado más de 3 m (precio por metro)'),
        T_TIPO_DATA('DIV-OM71','Picar y tapar 1/2 m² de enlucido en paredes verticales','Picar y tapar 1/2 m² de enlucido en paredes verticales'),
        T_TIPO_DATA('DIV-OM72','Picar y tapar 1 m² de enlucido, en paredes verticales','Picar y tapar 1 m² de enlucido, en paredes verticales'),
        T_TIPO_DATA('DIV-OM73','Picar y tapar 2 m² de enlucido, en paredes verticales','Picar y tapar 2 m² de enlucido, en paredes verticales'),
        T_TIPO_DATA('DIV-OM74','Picar y tapar 3 m² de enlucido, en paredes verticales','Picar y tapar 3 m² de enlucido, en paredes verticales'),
        T_TIPO_DATA('DIV-OM75','Picar y tapar m² adicional de enlucido, en paredes verticales (a partir de 3 m)','Picar y tapar m² adicional de enlucido, en paredes verticales (a partir de 3 m)'),
        T_TIPO_DATA('DIV-OM76','M² solo raseado con arena y cemento','M² solo raseado con arena y cemento'),
        T_TIPO_DATA('DIV-OM77','M² picar yeso','M² picar yeso'),
        T_TIPO_DATA('DIV-OM78','M² tender yeso negro','M² tender yeso negro'),
        T_TIPO_DATA('DIV-OM79','M² tender yeso blanco','M² tender yeso blanco'),
        T_TIPO_DATA('DIV-OM8','Sustitución de tubería general de alimentación hasta 3m 2 Pulgadas','Sustitución de tubería general de alimentación hasta 3m 2 Pulgadas'),
        T_TIPO_DATA('DIV-OM80','M² picar cemento (azulejo, plaqueta o terrazo) para alicatar o solar','M² picar cemento (azulejo, plaqueta o terrazo) para alicatar o solar'),
        T_TIPO_DATA('DIV-OM81','M² picar hormigón e=10cm','M² picar hormigón e=10cm'),
        T_TIPO_DATA('DIV-OM82','Tapar cala hormigón 1 m²','Tapar cala hormigón 1 m²'),
        T_TIPO_DATA('DIV-OM83','Tapar cala hormigón m² adicional','Tapar cala hormigón m² adicional'),
        T_TIPO_DATA('DIV-OM84','Suministro e instalación de lunas incoloras de 3 mm (un metro cuadrado) incluidos todos los trabajos','Suministro e instalación de lunas incoloras de 3 mm (un metro cuadrado) incluidos todos los trabajos necesarios para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM85','Suministro e instalación de vidrio simple de 4 mm, incluidos todos los trabajos necesarios para la c','Suministro e instalación de vidrio simple de 4 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM86','Suministro e instalación de vidrio simple de 5 mm, incluidos todos los trabajos necesarios para la c','Suministro e instalación de vidrio simple de 5 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM87','Suministro e instalación de vidrio simple de 6 mm, incluidos todos los trabajos necesarios para la c','Suministro e instalación de vidrio simple de 6 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM88','Suministro e instalación de vidrio simple de 8 mm, incluidos todos los trabajos necesarios para la c','Suministro e instalación de vidrio simple de 8 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM89','Suministro e instalación de vidrio simple de 10 mm, incluidos todos los trabajos necesarios para la ','Suministro e instalación de vidrio simple de 10 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM9','Sustitución de tramo de bajante fecal con injerto sencillo','Sustitución de tramo de bajante fecal con injerto sencillo'),
        T_TIPO_DATA('DIV-OM90','Suministro e instalación de vidrio simple de 15 mm, incluidos todos los trabajos necesarios para la ','Suministro e instalación de vidrio simple de 15 mm, incluidos todos los trabajos necesarios para la correcta ejecución'),
        T_TIPO_DATA('DIV-OM91','Composición incoloro climalit o similar 4+6+4 (m²)','Composición incoloro climalit o similar 4+6+4 (m²)'),
        T_TIPO_DATA('DIV-OM92','Composición incoloro climalit o similar 5+6+4 (m²)','Composición incoloro climalit o similar 5+6+4 (m²)'),
        T_TIPO_DATA('DIV-OM93','Composición incoloro climalit o similar 6+6+4 (m²)','Composición incoloro climalit o similar 6+6+4 (m²)'),
        T_TIPO_DATA('DIV-OM94','Composición con vidrio impreso climalit o similar 4+6+4  m²)','Composición con vidrio impreso climalit o similar 4+6+4  m²)'),
        T_TIPO_DATA('DIV-OM95','Suministro e instalación de vidrios laminados de seguridad de 3+3 mm (m²)','Suministro e instalación de vidrios laminados de seguridad de 3+3 mm (m²)'),
        T_TIPO_DATA('DIV-OM96','Suministro e instalación de vidrios laminados de seguridad de 4+4 mm (m²)','Suministro e instalación de vidrios laminados de seguridad de 4+4 mm (m²)'),
        T_TIPO_DATA('DIV-OM97','Suministro e instalación de vidrios laminados de seguridad de 5+5 mm m²)','Suministro e instalación de vidrios laminados de seguridad de 5+5 mm m²)'),
        T_TIPO_DATA('DIV-OM98','Suministro e instalación de vidrios laminados de seguridad de 6+6 mm (m²)','Suministro e instalación de vidrios laminados de seguridad de 6+6 mm (m²)'),
        T_TIPO_DATA('DIV-OM99','Tres lunas antirrobo 6+6+6 mm (metro cuadrado)','Tres lunas antirrobo 6+6+6 mm (metro cuadrado)'),
        T_TIPO_DATA('DIV-OTR1','PA Trámites Entidades Locales','PA Trámites Entidades Locales'),
        T_TIPO_DATA('DIV-OTR2','PA Trámites Oficinas suministradoras','PA Trámites Oficinas suministradoras'),
        T_TIPO_DATA('DIV-OTR3','Redacción de proyecto técnico para su visado (sin tasas de visado) módulo mínimo','Redacción de proyecto técnico para su visado (sin tasas de visado) módulo mínimo'),
        T_TIPO_DATA('DIV-OTR4','Redacción de proyecto técnico para su visado (sin tasas de visado)','Redacción de proyecto técnico para su visado (sin tasas de visado)'),
        T_TIPO_DATA('DIV-OTR5','Proyecto y dirección de obra (un solo técnico) 10.000 - 60.000 €','Proyecto y dirección de obra (un solo técnico) 10.000 - 60.000 €'),
        T_TIPO_DATA('DIV-OTR6','Proyecto y dirección de obra (un solo técnico) >60.000 €','Proyecto y dirección de obra (un solo técnico) >60.000 €'),
        T_TIPO_DATA('DIV-OTR7','Levantamiento topográfico (Día de trabajo de campo hasta 8h Desp < 100km)','Levantamiento topográfico (Día de trabajo de campo hasta 8h Desp < 100km)'),
        T_TIPO_DATA('DIV-SOL1','Limpieza de parcela/solar para retirada de escombros u otros restos voluminosos, incluida retirada y','Limpieza de parcela/solar para retirada de escombros u otros restos voluminosos, incluida retirada y gestión de restos a vertedero autorizado. Se deberá aportar justificación del volumen real retirado.'),
        T_TIPO_DATA('DIV-SOL2','Ud Desratización con anticoagulantes, administrados mediante cebos, incluido certificado. (Superfici','Ud Desratización con anticoagulantes, administrados mediante cebos, incluido certificado. (Superficie hasta 400 m²)'),
        T_TIPO_DATA('DIV-SOL3','Ud Desinfección contra hongos, virus y bacterias, incluido certificado. (Sup. Hasta 400 m²)','Ud Desinfección contra hongos, virus y bacterias, incluido certificado. (Sup. Hasta 400 m²)'),
        T_TIPO_DATA('DIV-VACI-LIMP-CER1','INFORME DE ESTADO + REP.FOTOGRAFICO + CAMBIO CERRADURA + LIMPIEZA + PINTURA','INFORME DE ESTADO + REP.FOTOGRAFICO + CAMBIO CERRADURA + LIMPIEZA + PINTURA'),
        T_TIPO_DATA('DIV-VACI-LIMP-CER2','INFORME DE ESTADO + REP.FOTOGRAFICO + CAMBIO + CERRADURA + LIMPIEZA BÁSICA + VACIADO 5M3','INFORME DE ESTADO + REP.FOTOGRAFICO + CAMBIO + CERRADURA + LIMPIEZA BÁSICA + VACIADO 5M3'),
        T_TIPO_DATA('DIV-VACI-LIMP-CER3','INFORME DE ESTADO + REP.FOTOGRAFICO + CAMBIO + CERRADURA + LIMPIEZA BÁSICA','INFORME DE ESTADO + REP.FOTOGRAFICO + CAMBIO + CERRADURA + LIMPIEZA BÁSICA'),
        T_TIPO_DATA('DIV-VACI-LIMP-CER4','COMPROBACIÓN CERRADURA + INFORME DE ESTADO + I. COMERCIAL','COMPROBACIÓN CERRADURA + INFORME DE ESTADO + I. COMERCIAL'),
        T_TIPO_DATA('DIV-VER1','Verificación y localización de avería descubriendo (máximo 2 horas)','Verificación y localización de avería descubriendo (máximo 2 horas)')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACT_NUM_ACTIVO EN '||V_TABLA);

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
        
        --Comprobar si ya existe en la tabla sin el '-'.
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_TTF_CODIGO='''||TRIM(V_TMP_TIPO_DATA(1))||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        -- Si no existe sin el prefijo '-' se actualiza.
        IF V_NUM_TABLAS = 0 THEN

            -- Almacena el id del nuevo registro
            V_MSQL:='SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;
       	
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (DD_TTF_ID, DD_TTF_CODIGO, DD_TTF_DESCRIPCION, DD_TTF_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) 
                        VALUES 
                        ('||V_ID||','''||TRIM(V_TMP_TIPO_DATA(1))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||V_USUARIO||''', SYSDATE,0)';

          	EXECUTE IMMEDIATE V_MSQL;

          	DBMS_OUTPUT.PUT_LINE('[INFO]: Insertada tarifa divarian: '''||TRIM(V_TMP_TIPO_DATA(1))||''' ');
            V_COUNT:=V_COUNT+1;

		ELSE
            -- Si ya existe el código sin el prefijo se muestra por consola
			DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE LA TARIFA CON EL CODIGO '''||TRIM(V_TMP_TIPO_DATA(1))||''' ');

		END IF;

      END LOOP;

    DBMS_OUTPUT.PUT_LINE('[FIN]: INSERTADOS CORRECTAMENTE '||V_COUNT||' DE '||V_COUNT_TOTAL||' EN LA TABLA '||V_TABLA||' ');

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]:  ');
    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;
/
EXIT