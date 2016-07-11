--/*
--##########################################
--## AUTOR=ANAHECT DE VICENTE
--## FECHA_CREACION=20151102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(5050);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('TAS1','Sin descripción','Sin descripción (unidad)'),
		T_TIPO_DATA('TAS2','Sin descripción','Sin descripción (unidad)'),
		T_TIPO_DATA('TAS3','Sin descripción','Sin descripción (unidad)'),
		T_TIPO_DATA('TAS4','Sin descripción','Sin descripción (unidad)'),
		T_TIPO_DATA('TAS5','Sin descripción','Sin descripción (unidad)'),
		T_TIPO_DATA('TAS6','Sin descripción','Sin descripción (unidad)'),
		T_TIPO_DATA('TAS7','Sin descripción','Sin descripción (unidad)'),
		T_TIPO_DATA('INF1','Informes','Informes (unidad)'),
		T_TIPO_DATA('INF2','Due Diligence y mediciones','Due Diligence y mediciones (unidad)'),
		T_TIPO_DATA('INF3','Project management','Project management (unidad)'),
		T_TIPO_DATA('INF4','Hr Técnico en elaboración de informes o realización de gestiones','Hr Técnico en elaboración de informes o realización de gestiones (€/h)'),
		T_TIPO_DATA('CEE1','Vivienda suelta con documentación del activo','Vivienda suelta con documentación del activo ((1-30) €/unidad)'),
		T_TIPO_DATA('CEE2','Vivienda suelta con documentación del activo','Vivienda suelta con documentación del activo ((31-60) €/unidad)'),
		T_TIPO_DATA('CEE3','Vivienda suelta con documentación del activo','Vivienda suelta con documentación del activo (Más de 60 €/unidad)'),
		T_TIPO_DATA('CEE4','Vivienda suelta sin documentación del activo','Vivienda suelta sin documentación del activo ((1-30) €/unidad)'),
		T_TIPO_DATA('CEE5','Vivienda suelta sin documentación del activo','Vivienda suelta sin documentación del activo ((31-60) €/unidad)'),
		T_TIPO_DATA('CEE6','Vivienda suelta sin documentación del activo','Vivienda suelta sin documentación del activo (Más de 60 €/unidad)'),
		T_TIPO_DATA('CEE7','Promociones (viviendas integradas en una promoción) con documentación del activo','Promociones (viviendas integradas en una promoción) con documentación del activo ((4-30) €/promoción)'),
		T_TIPO_DATA('CEE8','Promociones (viviendas integradas en una promoción) con documentación del activo','Promociones (viviendas integradas en una promoción) con documentación del activo ((31-60) €/promoción)'),
		T_TIPO_DATA('CEE9','Promociones (viviendas integradas en una promoción) con documentación del activo','Promociones (viviendas integradas en una promoción) con documentación del activo ((61-120) €/promoción)'),
		T_TIPO_DATA('CEE10','Promociones (viviendas integradas en una promoción) con documentación del activo','Promociones (viviendas integradas en una promoción) con documentación del activo (Más de 121 €/promoción)'),
		T_TIPO_DATA('CEE11','Promociones (viviendas integradas en una promoción) sin documentación del activo','Promociones (viviendas integradas en una promoción) sin documentación del activo ((4-30) €/promoción)'),
		T_TIPO_DATA('CEE12','Promociones (viviendas integradas en una promoción) sin documentación del activo','Promociones (viviendas integradas en una promoción) sin documentación del activo ((31-60) €/promoción)'),
		T_TIPO_DATA('CEE13','Promociones (viviendas integradas en una promoción) sin documentación del activo','Promociones (viviendas integradas en una promoción) sin documentación del activo ((61-120) €/promoción)'),
		T_TIPO_DATA('CEE14','Promociones (viviendas integradas en una promoción) sin documentación del activo','Promociones (viviendas integradas en una promoción) sin documentación del activo (Más de 121 €/promoción)'),
		T_TIPO_DATA('CEE15','Terciario (local comercial y oficina) con documentación del activo','Terciario (local comercial y oficina) con documentación del activo (< 10 Oficinas €/unidad)'),
		T_TIPO_DATA('CEE16','Terciario (local comercial y oficina) con documentación del activo','Terciario (local comercial y oficina) con documentación del activo ((10-50) €/unidad)'),
		T_TIPO_DATA('CEE17','Terciario (local comercial y oficina) con documentación del activo','Terciario (local comercial y oficina) con documentación del activo (> 50 €/unidad)'),
		T_TIPO_DATA('CEE18','Terciario (local comercial y oficina) sin documentación del activo','Terciario (local comercial y oficina) sin documentación del activo (<10 €/unidad)'),
		T_TIPO_DATA('CEE19','Terciario (local comercial y oficina) sin documentación del activo','Terciario (local comercial y oficina) sin documentación del activo ((10-50) €/unidad)'),
		T_TIPO_DATA('CEE20','Terciario (local comercial y oficina) sin documentación del activo','Terciario (local comercial y oficina) sin documentación del activo (>50 €/unidad)'),
		T_TIPO_DATA('LPO1','PA Obtención/Tramitación de Nueva cédula de habitabilidad','PA Obtención/Tramitación de Nueva cédula de habitabilidad (€/un)'),
		T_TIPO_DATA('LPO2','PA Obtención/Tramitación de Duplicado de LPO o Cédula','PA Obtención/Tramitación de Duplicado de LPO o Cédula (€/un)'),
		T_TIPO_DATA('CED1','PA Obtención/Tramitación de Nueva cédula de habitabilidad','PA Obtención/Tramitación de Nueva cédula de habitabilidad (€/un)'),
		T_TIPO_DATA('CED2','PA Obtención/Tramitación de Duplicado de LPO o Cédula','PA Obtención/Tramitación de Duplicado de LPO o Cédula (€/un)'),
		T_TIPO_DATA('CFO1','Emisión por el técnico competente del CFO','Emisión por el técnico competente del CFO (€/un)'),
		T_TIPO_DATA('BOL1','Emisión de proyecto y boletín de legalización de instalación eléctrica en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.','Emisión de proyecto y boletín de legalización de instalación eléctrica en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos. (€/un)'),
		T_TIPO_DATA('BOL2','Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.','Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos. (€/un)'),
		T_TIPO_DATA('BOL3','Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 1500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.','Emisión de proyecto y boletín de legalización de instalación eléctrica en local comercial de hasta 1500 m² s/ normativa vigente. Incluyendo técnico competente y visados preceptivos. (€/un)'),
		T_TIPO_DATA('BOL4','PA Obtención/Tramitación de Boletín Agua','PA Obtención/Tramitación de Boletín Agua (€/un)'),
		T_TIPO_DATA('BOL5','Emisión de proyecto y boletín de legalización de instalación de gas en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos.','Emisión de proyecto y boletín de legalización de instalación de gas en vivienda s/ normativa vigente. Incluyendo técnico competente y visados preceptivos. (€/un)'),
		T_TIPO_DATA('BOL6','PA Trámites Oficinas suministradoras (Alta)','PA Trámites Oficinas suministradoras (Alta) (€/h)'),
		T_TIPO_DATA('BOL7','PA Trámites Oficinas suministradoras (Baja)','PA Trámites Oficinas suministradoras (Baja) ()'),
		T_TIPO_DATA('OTR1','PA Trámites Entidades Locales / otras gestiones','PA Trámites Entidades Locales / otras gestiones (€/h)'),
		T_TIPO_DATA('NS1','Solicitud y obtención de una nota simple del activo','Solicitud y obtención de una nota simple del activo (trámite)'),
		T_TIPO_DATA('VPO1','Gestión de la devolución de las ayudas concedidas','Gestión de la devolución de las ayudas concedidas (trámite)'),
		T_TIPO_DATA('VPO2','Notificación a la administración de la adquisición de una VPO','Notificación a la administración de la adquisición de una VPO (trámite)'),
		T_TIPO_DATA('VPO3','Solicitud de la autorización de venta de una VPO','Solicitud de la autorización de venta de una VPO (trámite)'),
		T_TIPO_DATA('CM-CER1','Bombillo Gama Baja','Bombillo Gama Baja (unidad)'),
		T_TIPO_DATA('CM-CER2','Bombillo Gama Baja 2º Descerraje','Bombillo Gama Baja 2º Descerraje (unidad)'),
		T_TIPO_DATA('CM-CER3','Bombillo Gama Media','Bombillo Gama Media (unidad)'),
		T_TIPO_DATA('CM-CER4','Bombillo Gama Media 2ª Descerraje','Bombillo Gama Media 2ª Descerraje (unidad)'),
		T_TIPO_DATA('CM-CER5','Bombillo Gama Alta','Bombillo Gama Alta (unidad)'),
		T_TIPO_DATA('CM-CER6','Bombillo Gama Alta 2ª Descerraje','Bombillo Gama Alta 2ª Descerraje (unidad)'),
		T_TIPO_DATA('SAB-CER1','Sustitución de bombillo normal (Azbe, Tesa, Lince, Fiam, Ucem o similar)','Sustitución de bombillo normal (Azbe, Tesa, Lince, Fiam, Ucem o similar) (unidad)'),
		T_TIPO_DATA('SAB-CER2','Sustitución de bombillo de seguridad (Azbe, Tesa, Linceo similar) gama baja','Sustitución de bombillo de seguridad (Azbe, Tesa, Linceo similar) gama baja (unidad)'),
		T_TIPO_DATA('SAB-CER3','Sustitución de bombillo de seguridad (Fac, Mia de Borjas, Iseo o similar) gama media','Sustitución de bombillo de seguridad (Fac, Mia de Borjas, Iseo o similar) gama media (unidad)'),
		T_TIPO_DATA('SAB-CER4','Sustitución de bombillo de seguridad (Potent Borjas, Cr Acoraz, Cr doble) gama alta','Sustitución de bombillo de seguridad (Potent Borjas, Cr Acoraz, Cr doble) gama alta (unidad)'),
		T_TIPO_DATA('SAB-CER5','Sustitución de cerrojo (Fac, Lince, Ezcurra o similar)','Sustitución de cerrojo (Fac, Lince, Ezcurra o similar) (unidad)'),
		T_TIPO_DATA('SAB-CER6','Ud suministro de llave magnética codificada','Ud suministro de llave magnética codificada (unidad)'),
		T_TIPO_DATA('SAB-CER7','Ud suministro de mando de garaje codificado','Ud suministro de mando de garaje codificado (unidad)'),
		T_TIPO_DATA('TAP1','Tapiado con fábrica de ladrillo de 1/2 pie.','Tapiado con fábrica de ladrillo de 1/2 pie. (m²)'),
		T_TIPO_DATA('TAP2','Tapiado con fábrica de bloque de hormigón armado.','Tapiado con fábrica de bloque de hormigón armado. (m²)'),
		T_TIPO_DATA('VACI1','Vaciado enseres 2m3','Vaciado enseres 2m3 (unidad)'),
		T_TIPO_DATA('VACI2','Vaciado enseres 5 m3','Vaciado enseres 5 m3 (unidad)'),
		T_TIPO_DATA('VACI3','Tramos sucesivos 5m3','Tramos sucesivos 5m3 (unidad)'),
		T_TIPO_DATA('LIMP1','Limpiezas hasta 80m2','Limpiezas hasta 80m2 (unidad)'),
		T_TIPO_DATA('LIMP2','Limpiezas entre 80-100m2','Limpiezas entre 80-100m2 (unidad)'),
		T_TIPO_DATA('LIMP3','Limpiezas entre 100-120m2','Limpiezas entre 100-120m2 (unidad)'),
		T_TIPO_DATA('LIMP4','Limpiezas entre 121-150m2','Limpiezas entre 121-150m2 (unidad)'),
		T_TIPO_DATA('LIMP5','Limpiezas mantenimiento hasta 80m2','Limpiezas mantenimiento hasta 80m2 (unidad)'),
		T_TIPO_DATA('LIMP6','Limpiezas mantenimiento entre 80-100m2','Limpiezas mantenimiento entre 80-100m2 (unidad)'),
		T_TIPO_DATA('LIMP7','Limpiezas mantenimiento entre 100-120m2','Limpiezas mantenimiento entre 100-120m2 (unidad)'),
		T_TIPO_DATA('LIMP8','Limpiezas mantenimiento entre 121-150m2','Limpiezas mantenimiento entre 121-150m2 (unidad)'),
		T_TIPO_DATA('VACI-LIMP1','Ud Limpieza general del inmueble: retirada de basuras, restos de comida, etc… sin contenedor (únicamente bolsas). Gestión de residuos incluida. Hasta 1m3','Ud Limpieza general del inmueble: retirada de basuras, restos de comida, etc… sin contenedor (únicamente bolsas). Gestión de residuos incluida. Hasta 1m3 (unidad)'),
		T_TIPO_DATA('VACI-LIMP2','Ud Limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escombros, etc. (utilizando un contenedor de aprox 6m3) Gestión de residuos incluida.','Ud Limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escombros, etc. (utilizando un contenedor de aprox 6m3) Gestión de residuos incluida. (unidad)'),
		T_TIPO_DATA('VACI-LIMP3','Ud Contenedor adicional (6m3)en limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escombros, etc. Gestión de residuos incluida.','Ud Contenedor adicional (6m3)en limpieza general del inmueble: retirada de basuras, restos de comida, enseres, mobiliario, escombros, etc. Gestión de residuos incluida. (unidad)'),
		T_TIPO_DATA('VACI-LIMP-CER1','Vaciado 5m3+limpieza menor 100 m2+cambio de cerradura gama media','Vaciado 5m3+limpieza menor 100 m2+cambio de cerradura gama media (unidad)'),
		T_TIPO_DATA('VACI-LIMP-CER2','Vaciado 5m3+limpieza hasta 150 m2+cambio de cerradura gama media','Vaciado 5m3+limpieza hasta 150 m2+cambio de cerradura gama media (unidad)'),
		T_TIPO_DATA('SOL1','M2 Desbroce de parcela con maquinaria. Gestión de residuos incluida.','M2 Desbroce de parcela con maquinaria. Gestión de residuos incluida. (unidad)'),
		T_TIPO_DATA('SOL2','M2 Desbroce manual de parcela/jardín. Gestión de residuos incluida.','M2 Desbroce manual de parcela/jardín. Gestión de residuos incluida. (unidad)'),
		T_TIPO_DATA('SOL3','M2 Retirada de escombros con maquinaria. Gestión de residuos incluida.','M2 Retirada de escombros con maquinaria. Gestión de residuos incluida. (unidad)'),
		T_TIPO_DATA('SOL4','M2 Aplicación de herbicida sistémico no selectivo junto con herbicida de post-emergencia','M2 Aplicación de herbicida sistémico no selectivo junto con herbicida de post-emergencia (unidad)'),
		T_TIPO_DATA('SOL5','M2 Poda, puntual y selectiva, manual, con todos los útiles necesarios. Gestión de residuos incluida.','M2 Poda, puntual y selectiva, manual, con todos los útiles necesarios. Gestión de residuos incluida. (unidad)'),
		T_TIPO_DATA('SOL6','M Vallado con simple torsión hasta 2 m de altura, incluso postes de sujección cada 3 metros. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos.','M Vallado con simple torsión hasta 2 m de altura, incluso postes de sujección cada 3 metros. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos. (unidad)'),
		T_TIPO_DATA('SOL7','M Vallado con bloque de hormigón, hasta una altura de 2 m enfoscado, con pilares cada 3m, maestreado y pintado en blanco. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos.','M Vallado con bloque de hormigón, hasta una altura de 2 m enfoscado, con pilares cada 3m, maestreado y pintado en blanco. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos. (unidad)'),
		T_TIPO_DATA('SOL8','Ud suministro e instalación puerta metálica de malla de acero galvanizado para acceso peatonal (0,8 - 1m) de paso, candado incluido. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos.','Ud suministro e instalación puerta metálica de malla de acero galvanizado para acceso peatonal (0,8 - 1m) de paso, candado incluido. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos. (unidad)'),
		T_TIPO_DATA('SOL9','Ud Desinsectación contra todo tipo de insectos voladores o rastreros, incluido certificado. (Superficie hasta 400 m2)','Ud Desinsectación contra todo tipo de insectos voladores o rastreros, incluido certificado. (Superficie hasta 400 m2) (unidad)'),
		T_TIPO_DATA('SOL10','Ud Desratización con anticoagulantes, administrados mediante cebos, incluido certificado. (Superficie hasta 400 m2)','Ud Desratización con anticoagulantes, administrados mediante cebos, incluido certificado. (Superficie hasta 400 m2) (unidad)'),
		T_TIPO_DATA('SOL11','Ud Desinfección contra hongos, virus y bacterias, incluido certificado. (Sup. Hasta 400 m2)','Ud Desinfección contra hongos, virus y bacterias, incluido certificado. (Sup. Hasta 400 m2) (unidad)'),
		T_TIPO_DATA('SS1','Auditoría de Seguridad y Salud','Auditoría de Seguridad y Salud (unidad)'),
		T_TIPO_DATA('SS2','Medidas correctoras de riesgos','Medidas correctoras de riesgos (unidad)'),
		T_TIPO_DATA('SEG1','Vigilante seguridad sin arma 24 horas 7 días/semana','Vigilante seguridad sin arma 24 horas 7 días/semana (unidad)'),
		T_TIPO_DATA('SEG2','Vigilante seguridad sin arma 12 horas 7 días/semana (diurno)','Vigilante seguridad sin arma 12 horas 7 días/semana (diurno) (unidad)'),
		T_TIPO_DATA('SEG3','Vigilante seguridad sin arma 12 horas 7 dias/semana (8 horas nocturno + 4 diurno)','Vigilante seguridad sin arma 12 horas 7 dias/semana (8 horas nocturno + 4 diurno) (unidad)'),
		T_TIPO_DATA('SEG4','Vigilante seguridad sin arma 8 horas (noche) + festivos y fines de semana 24h','Vigilante seguridad sin arma 8 horas (noche) + festivos y fines de semana 24h (unidad)'),
		T_TIPO_DATA('SEG5','Vigilante seguridad','Vigilante seguridad (unidad)'),
		T_TIPO_DATA('SEG6','H laborable diurno','H laborable diurno (unidad)'),
		T_TIPO_DATA('SEG7','H laborable nocturno','H laborable nocturno (unidad)'),
		T_TIPO_DATA('SEG8','H festivo diurno','H festivo diurno (unidad)'),
		T_TIPO_DATA('SEG9','H festivo nocturno','H festivo nocturno (unidad)'),
		T_TIPO_DATA('SEG10','Auxiliar 8 horas 7 días/semana (diurno)','Auxiliar 8 horas 7 días/semana (diurno) (unidad)'),
		T_TIPO_DATA('SEG11','Auxiliar 12 horas 7 días/semana (diurno)','Auxiliar 12 horas 7 días/semana (diurno) (unidad)'),
		T_TIPO_DATA('SEG12','Auxiliar','Auxiliar (unidad)'),
		T_TIPO_DATA('SEG13','H laborable diurno','H laborable diurno (unidad)'),
		T_TIPO_DATA('SEG14','H laborable nocturno','H laborable nocturno (unidad)'),
		T_TIPO_DATA('SEG15','H festivo diurno','H festivo diurno (unidad)'),
		T_TIPO_DATA('SEG16','H festivo nocturno','H festivo nocturno (unidad)'),
		T_TIPO_DATA('SEG17','Servicio de vigilante de seguridad sin arma 8 horas nocturno laborables y 24 horas fines de semana y festivos, y Servicio de auxiliar 16 horas diurnas los laborables','Servicio de vigilante de seguridad sin arma 8 horas nocturno laborables y 24 horas fines de semana y festivos, y Servicio de auxiliar 16 horas diurnas los laborables (unidad)'),
		T_TIPO_DATA('SEG18','Servicio de vigilante de seguridad sin arma 12 horas nocturno laborables y 24 horas fines de semana y festivos, y Servicio de auxiliar 12 horas diurnas los laborables','Servicio de vigilante de seguridad sin arma 12 horas nocturno laborables y 24 horas fines de semana y festivos, y Servicio de auxiliar 12 horas diurnas los laborables (unidad)'),
		T_TIPO_DATA('SEG19','Diaria, 7 días/semana','Diaria, 7 días/semana (unidad)'),
		T_TIPO_DATA('SEG20','Diaria adicional','Diaria adicional (unidad)'),
		T_TIPO_DATA('SEG21','Semanal','Semanal (unidad)'),
		T_TIPO_DATA('SEG22','Semanal adicional','Semanal adicional (unidad)'),
		T_TIPO_DATA('SEG23','Quincenal','Quincenal (unidad)'),
		T_TIPO_DATA('SEG24','Mensual','Mensual (unidad)'),
		T_TIPO_DATA('SEG25','WC químico','WC químico (unidad)'),
		T_TIPO_DATA('SEG26','Garita','Garita (unidad)'),
		T_TIPO_DATA('SEG27','Grupo electrógeno (i/combustible)','Grupo electrógeno (i/combustible) (unidad)'),
		T_TIPO_DATA('SEG28','Vehículo-motocicleta (i/combustible)','Vehículo-motocicleta (i/combustible) (unidad)'),
		T_TIPO_DATA('SEG29','Vehículo-turismo (i/combustible)','Vehículo-turismo (i/combustible) (unidad)'),
		T_TIPO_DATA('SEG30','Vehículo-todoterreno (i/combustible)','Vehículo-todoterreno (i/combustible) (unidad)'),
		T_TIPO_DATA('ALR1','Instalación de Central, consola, 2 detectores volumétricos con cámara, 1 detector con cámara y sirena. Alimentación mediante baterías de larga duración','Instalación de Central, consola, 2 detectores volumétricos con cámara, 1 detector con cámara y sirena. Alimentación mediante baterías de larga duración (unidad)'),
		T_TIPO_DATA('ALR2','Conexión a CRA y mantenimiento instalación','Conexión a CRA y mantenimiento instalación (unidad mes)'),
		T_TIPO_DATA('ALR3','Custodia de llaves','Custodia de llaves (unidad año)'),
		T_TIPO_DATA('ALR4','Servicio de acudas con salidas ilimitadas','Servicio de acudas con salidas ilimitadas (unidad año)'),
		T_TIPO_DATA('VER1','Verificación y localización de avería','Verificación y localización de avería (unidad)'),
		T_TIPO_DATA('VER2','Verificación y localización de avería descubriendo (máximo 2 horas)','Verificación y localización de avería descubriendo (máximo 2 horas) (unidad)'),
		T_TIPO_DATA('VER3','2ª localizacion: verificacion y observacion de averia','2ª localizacion: verificacion y observacion de averia (unidad)'),
		T_TIPO_DATA('OM1','Soldadura de tuberias generales y reparacion de bajantes PVC (un/€)','Soldadura de tuberias generales y reparacion de bajantes PVC (un/€) (€/un)'),
		T_TIPO_DATA('OM2','Sustitucion de tubena bajante general fecales hasta 3 metros','Sustitucion de tubena bajante general fecales hasta 3 metros (€/metro lineal)'),
		T_TIPO_DATA('OM3','Sustitucion de tuberia bajante PVC general pluviales hasta 3 metros (METRO LINEAL)','Sustitucion de tuberia bajante PVC general pluviales hasta 3 metros (METRO LINEAL) (€/metro lineal)'),
		T_TIPO_DATA('OM4','Sustitucion de tuberia general de alimentacion hasta 3 m 1 Pulgada','Sustitucion de tuberia general de alimentacion hasta 3 m 1 Pulgada (€/metro lineal)'),
		T_TIPO_DATA('OM5','Sustitucion de tuberia general de alimentacion hasta 3 m 2 Pulgadas','Sustitucion de tuberia general de alimentacion hasta 3 m 2 Pulgadas (€/metro lineal)'),
		T_TIPO_DATA('OM6','Sustitucion de tramo de bajante fecal con injerto sencillo','Sustitucion de tramo de bajante fecal con injerto sencillo (€/metro lineal)'),
		T_TIPO_DATA('OM7','Sustitucion de tramo de bajante fecal con injerto doble','Sustitucion de tramo de bajante fecal con injerto doble (€/metro lineal)'),
		T_TIPO_DATA('OM8','Sustitución de desagüe de plomo hasta 1 metro (UN/€)','Sustitución de desagüe de plomo hasta 1 metro (UN/€) (€/metro lineal (reemplazar por un material autorizado))'),
		T_TIPO_DATA('OM9','Sustitución de desagüe de plomo hasta 2 metros (UN/€)','Sustitución de desagüe de plomo hasta 2 metros (UN/€) (€/metro lineal (reemplazar por un material autorizado))'),
		T_TIPO_DATA('OM10','Sustitución de desagüe de plomo hasta 3 metros','Sustitución de desagüe de plomo hasta 3 metros (€/metro lineal (reemplazar por un material autorizado))'),
		T_TIPO_DATA('OM11','Sustitución de desagüe de PVC hasta 1 metro (UN/€)','Sustitución de desagüe de PVC hasta 1 metro (UN/€) (€/metro lineal)'),
		T_TIPO_DATA('OM12','Sustitución de desagüe de PVC hasta 3 metros (UN/€)','Sustitución de desagüe de PVC hasta 3 metros (UN/€) (€/metro lineal)'),
		T_TIPO_DATA('OM13','Sustitución de tuberia de alimentación hasta 1 metro lineal','Sustitución de tuberia de alimentación hasta 1 metro lineal (€/metro lineal)'),
		T_TIPO_DATA('OM14','Sustitución de tuberia de alimentación hasta 2 metros lineales','Sustitución de tuberia de alimentación hasta 2 metros lineales (€/metro lineal)'),
		T_TIPO_DATA('OM15','Sustitución de tuberia de alimentación hasta 3 metros lineales','Sustitución de tuberia de alimentación hasta 3 metros lineales (€/metro lineal)'),
		T_TIPO_DATA('OM16','Sustitución de tuberia de alimentación hasta 6 metros lineales','Sustitución de tuberia de alimentación hasta 6 metros lineales (€/metro lineal)'),
		T_TIPO_DATA('OM17','Sustitución de tuberia de agua fría y caliente 1 metro lineal cada una','Sustitución de tuberia de agua fría y caliente 1 metro lineal cada una (€/metro lineal)'),
		T_TIPO_DATA('OM18','Sustitución tuberia de agua fría y caliente 2 metros lineales cada una (UN/€)','Sustitución tuberia de agua fría y caliente 2 metros lineales cada una (UN/€) (€/un)'),
		T_TIPO_DATA('OM19','Sustitución tuberia de agua fría y caliente hasta 3 metros lineales cada una','Sustitución tuberia de agua fría y caliente hasta 3 metros lineales cada una (€/un)'),
		T_TIPO_DATA('OM20','Sustitución de tuberia de agua fría y caliente hasta 6 m 1 cada una','Sustitución de tuberia de agua fría y caliente hasta 6 m 1 cada una (€/metro lineal)'),
		T_TIPO_DATA('OM21','Sustitución manguetón PVC (Incluido desmontar y montar inodoro)','Sustitución manguetón PVC (Incluido desmontar y montar inodoro) (€/un)'),
		T_TIPO_DATA('OM22','Sustitución manguetón plomo (Incluido desmontar y montar inodoro)','Sustitución manguetón plomo (Incluido desmontar y montar inodoro) (€/un (reemplazar por un material autorizado))'),
		T_TIPO_DATA('OM23','Sustitución de bote sifónico normal','Sustitución de bote sifónico normal (€/un)'),
		T_TIPO_DATA('OM24','Encasquillado de bote sifónico (UN/€)','Encasquillado de bote sifónico (UN/€) (€/un)'),
		T_TIPO_DATA('OM25','Sustitución de bote sifónico de PVC','Sustitución de bote sifónico de PVC (€/un)'),
		T_TIPO_DATA('OM26','Hacer junta de manguetón WC. con inodoro o bajante general (un)','Hacer junta de manguetón WC. con inodoro o bajante general (un) (€/un)'),
		T_TIPO_DATA('OM27','Sustitución de válvula y rebosadero de bañera (un/€)','Sustitución de válvula y rebosadero de bañera (un/€) (€/un)'),
		T_TIPO_DATA('OM28','Reparar mangueta o bote sifónico o desagüe o tuberia sin sustitución','Reparar mangueta o bote sifónico o desagüe o tuberia sin sustitución (€/un)'),
		T_TIPO_DATA('OM29','Colocación de gebo 1 unidad hasta 1/2 pulgada','Colocación de gebo 1 unidad hasta 1/2 pulgada (€/un)'),
		T_TIPO_DATA('OM30','Colocación de gebo i unidad hasta 3/4 pulgada','Colocación de gebo i unidad hasta 3/4 pulgada (€/un)'),
		T_TIPO_DATA('OM31','Únicamente sustitución de sanitario','Únicamente sustitución de sanitario (€/un)'),
		T_TIPO_DATA('OM32','Desmontaje y montaje de sanitarios (lavabo, bidet e inodoro)','Desmontaje y montaje de sanitarios (lavabo, bidet e inodoro) (€/un)'),
		T_TIPO_DATA('OM33','Sustitución de mecanismo de cisterna (sin material)','Sustitución de mecanismo de cisterna (sin material) (€/un)'),
		T_TIPO_DATA('OM34','Sustitución de grifería (sin material)','Sustitución de grifería (sin material) (€/un)'),
		T_TIPO_DATA('OM35','Sustitución de bañera (sin material)','Sustitución de bañera (sin material) (€/un)'),
		T_TIPO_DATA('OM36','Unidad de desatasco en vivienda particular (En ciudad)','Unidad de desatasco en vivienda particular (En ciudad) (€/h)'),
		T_TIPO_DATA('OM37','Temple liso, hasta 10 metros cuadrados','Temple liso, hasta 10 metros cuadrados (€/m2)'),
		T_TIPO_DATA('OM38','Temple liso, metro cuadrado adicional (a partir de 10 m2)','Temple liso, metro cuadrado adicional (a partir de 10 m2) (€/m2)'),
		T_TIPO_DATA('OM39','Temple picado, hasta 10 metros cuadrados','Temple picado, hasta 10 metros cuadrados (€/m2)'),
		T_TIPO_DATA('OM40','Temple picado, metro cuadrado adicional (a partir de 10 m2)','Temple picado, metro cuadrado adicional (a partir de 10 m2) (€/m2)'),
		T_TIPO_DATA('OM41','Plástico liso, hasta 10 metros cuadrados','Plástico liso, hasta 10 metros cuadrados (€/m2)'),
		T_TIPO_DATA('OM42','Plástico liso, metro cuadrado adicional (a partir de 10 m2)','Plástico liso, metro cuadrado adicional (a partir de 10 m2) (€/m2)'),
		T_TIPO_DATA('OM43','Picado, acabado pIástico, hasta 10 metros cuadrados','Picado, acabado pIástico, hasta 10 metros cuadrados (€/m2)'),
		T_TIPO_DATA('OM44','Picado, acabado plástico, m2 adicional (a partir de 10 m2)','Picado, acabado plástico, m2 adicional (a partir de 10 m2) (€/m2)'),
		T_TIPO_DATA('OM45','Gotelet, acabado plástico, hasta 10 metros cuadrados','Gotelet, acabado plástico, hasta 10 metros cuadrados (€/m2)'),
		T_TIPO_DATA('OM46','Gotelet, acabado plástico, metro adicional, a partir de 10 m2','Gotelet, acabado plástico, metro adicional, a partir de 10 m2 (€/m2)'),
		T_TIPO_DATA('OM47','Pintura tisotrópica (paramentos muy afectados) hasta 10 m2','Pintura tisotrópica (paramentos muy afectados) hasta 10 m2 (€/m2)'),
		T_TIPO_DATA('OM48','Pintura tisotrópica (paramentos muy afect.) m2 adicional a partir de 10 m2','Pintura tisotrópica (paramentos muy afect.) m2 adicional a partir de 10 m2 (€/m2)'),
		T_TIPO_DATA('OM49','Pasta rayada, hasta 10 metros cuadrados','Pasta rayada, hasta 10 metros cuadrados (€/m2)'),
		T_TIPO_DATA('OM50','Pasta rayada, metro cuadrado adicional, a partir de 10 m2','Pasta rayada, metro cuadrado adicional, a partir de 10 m2 (€/m2)'),
		T_TIPO_DATA('OM51','Esmalte, hasta 10 metros cuadrados','Esmalte, hasta 10 metros cuadrados (€/m2)'),
		T_TIPO_DATA('OM52','Esmalte, metro cuadrado adicional, a partir de 10 m2','Esmalte, metro cuadrado adicional, a partir de 10 m2 (€/m2)'),
		T_TIPO_DATA('OM53','Tapar 1/2 m2 de techo de escayola','Tapar 1/2 m2 de techo de escayola (€/m2)'),
		T_TIPO_DATA('OM54','Tapar 1 m2 de techo de escayola','Tapar 1 m2 de techo de escayola (€/m2)'),
		T_TIPO_DATA('OM55','Tapar 2m2 de techo de escayola','Tapar 2m2 de techo de escayola (€/m2)'),
		T_TIPO_DATA('OM56','Tapar 3 m2 de techo de escayola','Tapar 3 m2 de techo de escayola (€/m2)'),
		T_TIPO_DATA('OM57','Tapar m2 adicional (a partir de 3 m2) de techo de escayola','Tapar m2 adicional (a partir de 3 m2) de techo de escayola (€/m2)'),
		T_TIPO_DATA('OM58','Hasta 3 metros lineales de moldura de escayola','Hasta 3 metros lineales de moldura de escayola (€/metro lineal)'),
		T_TIPO_DATA('OM59','Metro lineal de moldura de escayola adicional','Metro lineal de moldura de escayola adicional (€/metro lineal)'),
		T_TIPO_DATA('OM60','Tapar cala enlucido una o dos caras 1/2 m2','Tapar cala enlucido una o dos caras 1/2 m2 (€/m2)'),
		T_TIPO_DATA('OM61','Tapar cala enlucido una odos caras 1 m2','Tapar cala enlucido una odos caras 1 m2 (€/m2)'),
		T_TIPO_DATA('OM62','Tapar cala con alicatado o solado 1/2 m2','Tapar cala con alicatado o solado 1/2 m2 (€/m2)'),
		T_TIPO_DATA('OM63','Tapar cala con alicatado o solado 1 m2','Tapar cala con alicatado o solado 1 m2 (€/m2)'),
		T_TIPO_DATA('OM64','Tapar cala con alicatado o solado 2 m2','Tapar cala con alicatado o solado 2 m2 (€/m2)'),
		T_TIPO_DATA('OM65','Tapar cala con alicatado o solado 3 m2','Tapar cala con alicatado o solado 3 m2 (€/m2)'),
		T_TIPO_DATA('OM66','Metro cuadrado de alicatado o solado hasta 3 m (precio por metro)','Metro cuadrado de alicatado o solado hasta 3 m (precio por metro) (€/m2)'),
		T_TIPO_DATA('OM67','Metro cuadrado de alicatado o solado más de 3 m (precio por metro)','Metro cuadrado de alicatado o solado más de 3 m (precio por metro) (€/m2)'),
		T_TIPO_DATA('OM68','Picar y tapar 1/2 m2 de enlucido en paredes verticales','Picar y tapar 1/2 m2 de enlucido en paredes verticales (€/m2)'),
		T_TIPO_DATA('OM69','Picar y tapar 1 m2 de enlucido, en paredes verticales','Picar y tapar 1 m2 de enlucido, en paredes verticales (€/m2)'),
		T_TIPO_DATA('OM70','Picar y tapar 2 m2 de enlucido, en paredes verticales','Picar y tapar 2 m2 de enlucido, en paredes verticales (€/m2)'),
		T_TIPO_DATA('OM71','Picar y tapar 3 m2 de enlucido, en paredes verticales','Picar y tapar 3 m2 de enlucido, en paredes verticales (€/m2)'),
		T_TIPO_DATA('OM72','Picar y tapar m2 adicional de enlucido, en paredes verticales (a partir de 3 m)','Picar y tapar m2 adicional de enlucido, en paredes verticales (a partir de 3 m) (€/m2)'),
		T_TIPO_DATA('OM73','Metro cuadrado solo raseado con arena y cemento','Metro cuadrado solo raseado con arena y cemento (€/m2)'),
		T_TIPO_DATA('OM74','Metro cuadrado picar yeso','Metro cuadrado picar yeso (€/m2)'),
		T_TIPO_DATA('OM75','Metro cuadrado tender yeso negro','Metro cuadrado tender yeso negro (€/m2)'),
		T_TIPO_DATA('OM76','Metro cuadrado tender yeso blanco','Metro cuadrado tender yeso blanco (€/m2)'),
		T_TIPO_DATA('OM77','Metro cuadrado picar cemento (azulejo, plaqueta o terrazo) para alicatar o solar','Metro cuadrado picar cemento (azulejo, plaqueta o terrazo) para alicatar o solar (€/m2)'),
		T_TIPO_DATA('OM78','Metro cuadrado picar hormigón e=10cm','Metro cuadrado picar hormigón e=10cm (€/m2)'),
		T_TIPO_DATA('OM79','Tapar cala hormigón 1 m2','Tapar cala hormigón 1 m2 (€/m2)'),
		T_TIPO_DATA('OM80','Tapar cala hormigón m2 adicional','Tapar cala hormigón m2 adicional (€/m2)'),
		T_TIPO_DATA('OM81','Lunas incoloras de 3 mm (un metro cuadrado)','Lunas incoloras de 3 mm (un metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM82','Lunas incoloras de 4 mm (un metro cuadrado)','Lunas incoloras de 4 mm (un metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM83','Lunas incoloras de 5 mm (un metro cuadrado)','Lunas incoloras de 5 mm (un metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM84','Lunas incoloras de 6 mm (un metro cuadrado)','Lunas incoloras de 6 mm (un metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM85','Lunas incoloras de 8 mm (un metro cuadrado)','Lunas incoloras de 8 mm (un metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM86','Lunas incoloras de 10 mm (un metro cuadrado)','Lunas incoloras de 10 mm (un metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM87','Lunas incoloras de 15 mm (un metro cuadrado)','Lunas incoloras de 15 mm (un metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM88','Composición incoloro climalit o similar 4+6+4 (m2)','Composición incoloro climalit o similar 4+6+4 (m2) (€/m2)'),
		T_TIPO_DATA('OM89','Composición incoloro climalit o similar 5+6+4 (m2)','Composición incoloro climalit o similar 5+6+4 (m2) (€/m2)'),
		T_TIPO_DATA('OM90','Composición incoloro clinialit o smiliar 6+6+4 (m2)','Composición incoloro clinialit o smiliar 6+6+4 (m2) (€/m2)'),
		T_TIPO_DATA('OM91','Composición con vidrio impreso climalit o similar 4+6+4 (m2)','Composición con vidrio impreso climalit o similar 4+6+4 (m2) (€/m2)'),
		T_TIPO_DATA('OM92','Vidrios laminados de seguridad de 3+3 mm (m2)','Vidrios laminados de seguridad de 3+3 mm (m2) (€/m2)'),
		T_TIPO_DATA('OM93','Vidrios laminados de seguridad de 4+4 mm (m2)','Vidrios laminados de seguridad de 4+4 mm (m2) (€/m2)'),
		T_TIPO_DATA('OM94','Vidrios laminados de seguridad de 5+5 mm m2)','Vidrios laminados de seguridad de 5+5 mm m2) (€/m2)'),
		T_TIPO_DATA('OM95','Vidrios laminados de seguridad de 6+6 mm (m2)','Vidrios laminados de seguridad de 6+6 mm (m2) (€/m2)'),
		T_TIPO_DATA('OM96','Tres lunas antirrobo 6+6÷6 mm (metro cuadrado)','Tres lunas antirrobo 6+6÷6 mm (metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM97','Tres lunas antibala 10+10+2,5 mm (metro cuadrado)','Tres lunas antibala 10+10+2,5 mm (metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM98','Luna incolora templada de 6mrn (metro cuadrado)','Luna incolora templada de 6mrn (metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM99','Luna incolora templada de 8mm (metro cuadrado)','Luna incolora templada de 8mm (metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM100','Luna incolora templada de 10 mm (metro cuadrado)','Luna incolora templada de 10 mm (metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM101','Luna en color templada de6 mm (metro cuadrado)','Luna en color templada de6 mm (metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM102','Luna en color templada de 10 mm (metro cuadrado)','Luna en color templada de 10 mm (metro cuadrado) (€/m2)'),
		T_TIPO_DATA('OM103','Luna templada en puertas de 10 mm (metro cuadrado','Luna templada en puertas de 10 mm (metro cuadrado (€/m2)'),
		T_TIPO_DATA('OM104','Taladros punto de luces (metro lineal o unidad)','Taladros punto de luces (metro lineal o unidad) (€/un)'),
		T_TIPO_DATA('OM105','Taladros grosor hasta 6 mm, hasta 25 mm de diámetro','Taladros grosor hasta 6 mm, hasta 25 mm de diámetro (€/un)'),
		T_TIPO_DATA('OM106','Taladros grosor de 7 a 10 mm, hasta 25 mm de diámetros','Taladros grosor de 7 a 10 mm, hasta 25 mm de diámetros (€/un)'),
		T_TIPO_DATA('OM107','Punto de luz sencillo','Punto de luz sencillo (€/un)'),
		T_TIPO_DATA('OM108','Doble punto de luz con doble interruptor','Doble punto de luz con doble interruptor (€/un)'),
		T_TIPO_DATA('OM109','Punto de luz conmutado','Punto de luz conmutado (€/un)'),
		T_TIPO_DATA('OM110','Punto de luz cruzamiento','Punto de luz cruzamiento (€/un)'),
		T_TIPO_DATA('OM111','Punto de luz sencillo con regulación lumínica','Punto de luz sencillo con regulación lumínica (€/un)'),
		T_TIPO_DATA('OM112','Punto de luz conmutado con regulación lumínica','Punto de luz conmutado con regulación lumínica (€/un)'),
		T_TIPO_DATA('OM113','Punto de luz cruzamiento con regulación lumínica','Punto de luz cruzamiento con regulación lumínica (€/un)'),
		T_TIPO_DATA('OM114','Punto de luz conmutado con una base de enchufe','Punto de luz conmutado con una base de enchufe (€/un)'),
		T_TIPO_DATA('OM115','Punto de luz conmutado con dos bases de enchufe','Punto de luz conmutado con dos bases de enchufe (€/un)'),
		T_TIPO_DATA('OM116','Punto de luz cruzamiento con dos bases de enchufe','Punto de luz cruzamiento con dos bases de enchufe (€/un)'),
		T_TIPO_DATA('OM117','Punto de timbre','Punto de timbre (€/un)'),
		T_TIPO_DATA('OM118','Toma de corriente de 10 A','Toma de corriente de 10 A (€/un)'),
		T_TIPO_DATA('OM119','Toma de corriente con toma de tierra lateral de 16 A','Toma de corriente con toma de tierra lateral de 16 A (€/un)'),
		T_TIPO_DATA('OM120','Toma de corriente con toma de tierra lateral de 20 A','Toma de corriente con toma de tierra lateral de 20 A (€/un)'),
		T_TIPO_DATA('OM121','Toma de corriente con toma de tierra lateral de 25 A','Toma de corriente con toma de tierra lateral de 25 A (€/un)'),
		T_TIPO_DATA('OM122','M líneal de 2x1,5mm2','M líneal de 2x1,5mm2 (€/metro lineal)'),
		T_TIPO_DATA('OM123','Ml línea de 2 x 2,5 mm2 + TT','Ml línea de 2 x 2,5 mm2 + TT (€/metro lineal)'),
		T_TIPO_DATA('OM124','Ml línea de 2 x 1,5 mm2 + 2 x 2,5 mm2 + TT','Ml línea de 2 x 1,5 mm2 + 2 x 2,5 mm2 + TT (€/metro lineal)'),
		T_TIPO_DATA('OM125','M línealde 2x4mm2+TT','M línealde 2x4mm2+TT (€/metro lineal)'),
		T_TIPO_DATA('OM126','M línea de 2x6mni2+TT','M línea de 2x6mni2+TT (€/metro lineal)'),
		T_TIPO_DATA('OM127','Sustitución de interruptor, enchufe, timbre Mod. Simón 31 o similar','Sustitución de interruptor, enchufe, timbre Mod. Simón 31 o similar (€/un)'),
		T_TIPO_DATA('OM128','Sustitución de diferencial hasta 2 x 40 A 30 mA','Sustitución de diferencial hasta 2 x 40 A 30 mA (€/un)'),
		T_TIPO_DATA('OM129','Sustitución de diferencial de 2 x 63 A 30 mA','Sustitución de diferencial de 2 x 63 A 30 mA (€/un)'),
		T_TIPO_DATA('OM130','Sustitución de diferencial hasta 4 x 40 A 300 mA','Sustitución de diferencial hasta 4 x 40 A 300 mA (€/un)'),
		T_TIPO_DATA('OM131','Sustitución de diferencial de 4 x 63 A 300 mA','Sustitución de diferencial de 4 x 63 A 300 mA (€/un)'),
		T_TIPO_DATA('OM132','Sustitución de magnetotérmico de 2 x 25 A','Sustitución de magnetotérmico de 2 x 25 A (€/un)'),
		T_TIPO_DATA('OM133','Sustitución de magrtetotérmico de 2 x 40','Sustitución de magrtetotérmico de 2 x 40 (€/un)'),
		T_TIPO_DATA('OM134','Sustitución de magnetotérmico de 2 x 50','Sustitución de magnetotérmico de 2 x 50 (€/un)'),
		T_TIPO_DATA('OM135','Apertura de puerta','Apertura de puerta (€/un)'),
		T_TIPO_DATA('OM136','Reparación de cerradura (sin aporte de piezas)','Reparación de cerradura (sin aporte de piezas) (€/un)'),
		T_TIPO_DATA('OM137','Sustitución de hoja de puerta de paso (solo mano de obra)','Sustitución de hoja de puerta de paso (solo mano de obra) (€/un)'),
		T_TIPO_DATA('OM138','Sustitución de hoja de puerta corredera (solo mano de obra)','Sustitución de hoja de puerta corredera (solo mano de obra) (€/un)'),
		T_TIPO_DATA('OM139','Sustitución de hoja de puerta blindada (solo mano de obra)','Sustitución de hoja de puerta blindada (solo mano de obra) (€/un)'),
		T_TIPO_DATA('OM140','Sustitución de puerta acorazada (solo mano de obra)','Sustitución de puerta acorazada (solo mano de obra) (€/un)'),
		T_TIPO_DATA('OM141','Ajuste de puerta de pas','Ajuste de puerta de pas (€/un)'),
		T_TIPO_DATA('OM142','Ajuste de puerta corredera','Ajuste de puerta corredera (€/un)'),
		T_TIPO_DATA('OM143','Ajuste de puerta blindada','Ajuste de puerta blindada (€/un)'),
		T_TIPO_DATA('OM144','Ajuste de puerta acorazada','Ajuste de puerta acorazada (€/un)'),
		T_TIPO_DATA('OM145','Descolgamiento de puerta de paso','Descolgamiento de puerta de paso (€/un)'),
		T_TIPO_DATA('OM146','Descolgamiento de puerta corredera','Descolgamiento de puerta corredera (€/un)'),
		T_TIPO_DATA('OM147','Descolgamiento de puerta blindada','Descolgamiento de puerta blindada (€/un)'),
		T_TIPO_DATA('OM148','Descolgamiento de puerta acorazada','Descolgamiento de puerta acorazada (€/un)'),
		T_TIPO_DATA('OM149','Sustitución de cerradura puerta de paso','Sustitución de cerradura puerta de paso (€/un)'),
		T_TIPO_DATA('OM150','Sustitución de bisagras puerta de paso','Sustitución de bisagras puerta de paso (€/un)'),
		T_TIPO_DATA('OM151','Sustitución de manetas puerta de paso','Sustitución de manetas puerta de paso (€/un)'),
		T_TIPO_DATA('OM152','Cepillado de puerta por roce','Cepillado de puerta por roce (€/un)'),
		T_TIPO_DATA('OM153','Ajuste y regulación de frente de armario','Ajuste y regulación de frente de armario (€/un)'),
		T_TIPO_DATA('OM154','Sustituir puerta de armario (Sin material)','Sustituir puerta de armario (Sin material) (€/un)'),
		T_TIPO_DATA('OM155','Sustitución de molduras metro lineal','Sustitución de molduras metro lineal (€/un)'),
		T_TIPO_DATA('OM156','Ajuste de puertas armarios cocina','Ajuste de puertas armarios cocina (€/un)'),
		T_TIPO_DATA('OM157','Ajuste de muebles de cocina','Ajuste de muebles de cocina (€/un)'),
		T_TIPO_DATA('OM158','Clavado y sellado de jambas (Precio por puerta)','Clavado y sellado de jambas (Precio por puerta) (€/un)'),
		T_TIPO_DATA('OM159','Preparación de suelo con pasta niveladora por m2 espesor entre 5mm-25mm','Preparación de suelo con pasta niveladora por m2 espesor entre 5mm-25mm (€/m2)'),
		T_TIPO_DATA('OM160','Lijado y barnizado hasta 15 m2','Lijado y barnizado hasta 15 m2 (€/m2)'),
		T_TIPO_DATA('OM161','Lijado y barnizado por m2 adicional','Lijado y barnizado por m2 adicional (€/m2)'),
		T_TIPO_DATA('OM162','M2 parquet roble damas','M2 parquet roble damas (€/m2)'),
		T_TIPO_DATA('OM163','M2 parquet roble tablillas','M2 parquet roble tablillas (€/m2)'),
		T_TIPO_DATA('OM164','M2 parquet roble baldosa','M2 parquet roble baldosa (€/m2)'),
		T_TIPO_DATA('OM165','M2 tarima roble','M2 tarima roble (€/m2)'),
		T_TIPO_DATA('OM166','M2 parquet eucalipto damas','M2 parquet eucalipto damas (€/m2)'),
		T_TIPO_DATA('OM167','M2 parquet eucalipto tablillas','M2 parquet eucalipto tablillas (€/m2)'),
		T_TIPO_DATA('OM168','M2 parquet pino oregón','M2 parquet pino oregón (€/m2)'),
		T_TIPO_DATA('OM169','M2 tarima pino viejo','M2 tarima pino viejo (€/m2)'),
		T_TIPO_DATA('OM170','MI rodapié aglomerado','MI rodapié aglomerado (€/metro lineal)'),
		T_TIPO_DATA('OM171','MI rodapié macizo 7cm','MI rodapié macizo 7cm (€/metro lineal)'),
		T_TIPO_DATA('OM172','Ml rodapié macizo 10 cm','Ml rodapié macizo 10 cm (€/metro lineal)'),
		T_TIPO_DATA('OM173','Ml barnizado de rodapié poliuretano','Ml barnizado de rodapié poliuretano (€/metro lineal)'),
		T_TIPO_DATA('OM174','Hora de trabajo de Oficial electricista','Hora de trabajo de Oficial electricista (€/h)'),
		T_TIPO_DATA('OM175','Hora de trabajo de Oficial parquetista','Hora de trabajo de Oficial parquetista (€/h)'),
		T_TIPO_DATA('OM176','Hora de trabajo de Oficial carpintero','Hora de trabajo de Oficial carpintero (€/h)'),
		T_TIPO_DATA('OM177','Hora de trabajo de Oficial pintor','Hora de trabajo de Oficial pintor (€/h)'),
		T_TIPO_DATA('OM178','Hora de trabajo de Oficial albañil','Hora de trabajo de Oficial albañil (€/h)'),
		T_TIPO_DATA('OM179','Hora de trabajo de Oficial fontanero','Hora de trabajo de Oficial fontanero (€/h)'),
		T_TIPO_DATA('OM180','Hora de trabajo de Oficial cerrajero','Hora de trabajo de Oficial cerrajero (€/h)'),
		T_TIPO_DATA('OM181','Hora de trabajo de Oficial frigorista','Hora de trabajo de Oficial frigorista (€/h)'),
		T_TIPO_DATA('OM182','Hora de trabajo de Oficial calefactor','Hora de trabajo de Oficial calefactor (€/h)'),
		T_TIPO_DATA('OM183','Hora de trabajo de Oficial polivalente','Hora de trabajo de Oficial polivalente (€/h)'),
		T_TIPO_DATA('OM184','Hora de trabajo de Limpiador','Hora de trabajo de Limpiador (€/h)'),
		T_TIPO_DATA('OM185','Hora de trabajo de peón no cualificado','Hora de trabajo de peón no cualificado (€/h)'),
		T_TIPO_DATA('OM186','Hora de trabajo de Oficial polivalente (De 22:00 a 08:00 h. Y festivos)','Hora de trabajo de Oficial polivalente (De 22:00 a 08:00 h. Y festivos) (€/h)'),
		T_TIPO_DATA('OM187','Hora de trabajo de Encargado','Hora de trabajo de Encargado (€/h)'),
		T_TIPO_DATA('OM188','Hora de trabajo de Auxiliar Administrativo','Hora de trabajo de Auxiliar Administrativo (€/h)'),
		T_TIPO_DATA('OM189','Hora de trabajo de Oficial de 2ª','Hora de trabajo de Oficial de 2ª (€/h)'),
		T_TIPO_DATA('OM190','Hora de trabajo de Ayudante de oficio','Hora de trabajo de Ayudante de oficio (€/h)'),
		T_TIPO_DATA('OM191','Hora de trabajo de Peón especializado','Hora de trabajo de Peón especializado (€/h)'),
		T_TIPO_DATA('OM192','Desplazamiento de camión de desatranco','Desplazamiento de camión de desatranco (€/h)'),
		T_TIPO_DATA('OM193','Hora de trabajo de camión de desatranco','Hora de trabajo de camión de desatranco (€/h)'),
		T_TIPO_DATA('OM194','Hora de mano trabajo de cerajería urgente','Hora de mano trabajo de cerajería urgente (€/h)'),
		T_TIPO_DATA('OM195','Desplazamiento de operario (oficial, cerrajero, etc.)','Desplazamiento de operario (oficial, cerrajero, etc.) (€/h)'),
		T_TIPO_DATA('OM196','M2 Reparación de humedades en fachada de unifamiliares','M2 Reparación de humedades en fachada de unifamiliares (€/m2)'),
		T_TIPO_DATA('OM197','M2 Reparación grietas en fachada de unifamiliares','M2 Reparación grietas en fachada de unifamiliares (€/m2)'),
		T_TIPO_DATA('OM198','M2 Reparación de humedades en cubierta con impermeabilizante','M2 Reparación de humedades en cubierta con impermeabilizante (€/m2)'),
		T_TIPO_DATA('OM199','M2 Reparación grietas en cubierta con impermeabilizante','M2 Reparación grietas en cubierta con impermeabilizante (€/m2)'),
		T_TIPO_DATA('OM200','Ud Repaso de instalación eléctrica y telecomunicaciones de vivienda NO incluido la colocación de las tapas de cajas y mecanismos Sin descripciónntes','Ud Repaso de instalación eléctrica y telecomunicaciones de vivienda NO incluido la colocación de las tapas de cajas y mecanismos Sin descripciónntes (€/un)'),
		T_TIPO_DATA('OM201','Ud Colocación de caja general de protección de la vivienda según normativa de instalación, totalmente terminada','Ud Colocación de caja general de protección de la vivienda según normativa de instalación, totalmente terminada (€/un)'),
		T_TIPO_DATA('OM202','Ud Suministro y colocación de timbre. Con instalación de cableado.','Ud Suministro y colocación de timbre. Con instalación de cableado. (€/un)'),
		T_TIPO_DATA('OM203','Ud Instalación de toma de corriente para calentador, incluido cableado, mecanismo de superficie o empotrado y canaleta','Ud Instalación de toma de corriente para calentador, incluido cableado, mecanismo de superficie o empotrado y canaleta (€/un)'),
		T_TIPO_DATA('OM204','Suministro e instalación de campana extractora de cocina hasta 16m² de acero inoxidable visto de calidad media alta>500m³/h.','Suministro e instalación de campana extractora de cocina hasta 16m² de acero inoxidable visto de calidad media alta>500m³/h. (€/un)'),
		T_TIPO_DATA('OM205','Suministro e instalación de campana extractora de cocina hasta 10m² de acero inoxidable visto de calidad media alta>500m³/h.','Suministro e instalación de campana extractora de cocina hasta 10m² de acero inoxidable visto de calidad media alta>500m³/h. (€/un)'),
		T_TIPO_DATA('OM206','Suministro e instalación de campana extractora de cocina hasta 10m²empotrable de calidad media baja>500m³/h.','Suministro e instalación de campana extractora de cocina hasta 10m²empotrable de calidad media baja>500m³/h. (€/un)'),
		T_TIPO_DATA('OM207','Suministro e instalación de encimera de cocina de calidad alta de silestone con acabado pulido o similar, color a elegir.','Suministro e instalación de encimera de cocina de calidad alta de silestone con acabado pulido o similar, color a elegir. (€/ml)'),
		T_TIPO_DATA('OM208','Suministro e instalación de encimerta de cocina de calidad media de granito nacional pulido o similar.','Suministro e instalación de encimerta de cocina de calidad media de granito nacional pulido o similar. (€/ml)'),
		T_TIPO_DATA('OM209','Suministro e instalación de encimera de cocina de calidad económica con acabado en tablero, incluyendo copas y remates de extremos, ángulos y esquinas.','Suministro e instalación de encimera de cocina de calidad económica con acabado en tablero, incluyendo copas y remates de extremos, ángulos y esquinas. (€/ml)'),
		T_TIPO_DATA('OM210','Ud Revisión de instalación fontanería en vivienda, incluyendo pruebas de presión, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente.','Ud Revisión de instalación fontanería en vivienda, incluyendo pruebas de presión, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente. (€/un)'),
		T_TIPO_DATA('OM211','Ud Revisión de instalación fontanería en local comercial de hasta 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente.','Ud Revisión de instalación fontanería en local comercial de hasta 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente. (€/un)'),
		T_TIPO_DATA('OM212','Ud Revisión de instalación fontanería en local comercial de más de 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente.','Ud Revisión de instalación fontanería en local comercial de más de 100m², incluyendo pruebas de servicio, corrección de fugas, sin incluir el suministro e instalación de elementos necesarios para cumplir la normativa vigente. (€/un)'),
		T_TIPO_DATA('OM213','Calentador de gas de agua interior mural, vertical para 6l/min con tiro natural, colocado y probado. Incluyendo boletín y legalización.','Calentador de gas de agua interior mural, vertical para 6l/min con tiro natural, colocado y probado. Incluyendo boletín y legalización. (€/ud)'),
		T_TIPO_DATA('OM214','Ud Suministro y colocación Termo eléctrico 50 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado','Ud Suministro y colocación Termo eléctrico 50 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado (€/un)'),
		T_TIPO_DATA('OM215','Ud Suministro y colocación Termo eléctrico 75 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado','Ud Suministro y colocación Termo eléctrico 75 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado (€/un)'),
		T_TIPO_DATA('OM216','Ud Suministro y colocación Termo eléctrico 100 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado','Ud Suministro y colocación Termo eléctrico 100 litros para A.C.S. mural vertical con resistencia blindada, totalmente montado y probado (€/un)'),
		T_TIPO_DATA('OM217','Ud Instalación de salida de humos calentador, de chapa de acero de 150mm, sin incluir perforación de fachada, aunque sí su sellado y resolución de encuentros','Ud Instalación de salida de humos calentador, de chapa de acero de 150mm, sin incluir perforación de fachada, aunque sí su sellado y resolución de encuentros (€/un)'),
		T_TIPO_DATA('OM218','Ud Instalación fontanería para calentador','Ud Instalación fontanería para calentador (€/un)'),
		T_TIPO_DATA('OM219','Ud Sustitución de llave de paso','Ud Sustitución de llave de paso (€/un)'),
		T_TIPO_DATA('OM220','Ud Suministro e instalación de fregadero de cocina metálico, de hasta 90 cm de anchura, con senos y/o escurridor.','Ud Suministro e instalación de fregadero de cocina metálico, de hasta 90 cm de anchura, con senos y/o escurridor. (€/un)'),
		T_TIPO_DATA('OM221','Ud Suministro e instalación Rejilla de baño','Ud Suministro e instalación Rejilla de baño (€/un)'),
		T_TIPO_DATA('OM222','Ud Suministro e instalación de bidet cerámico color estándar a elegir, sin incluir grifería.','Ud Suministro e instalación de bidet cerámico color estándar a elegir, sin incluir grifería. (€/un)'),
		T_TIPO_DATA('OM223','Ud Suministro e instalación de lavabo cerámico color estándar a elegir de un seno y sustentado sobre pie cerámico, sin incluir grifería.','Ud Suministro e instalación de lavabo cerámico color estándar a elegir de un seno y sustentado sobre pie cerámico, sin incluir grifería. (€/un)'),
		T_TIPO_DATA('OM224','Ud Suministro e instalación de inodoro cerámico color estándar a elegir, con tanque bajo.','Ud Suministro e instalación de inodoro cerámico color estándar a elegir, con tanque bajo. (€/un)'),
		T_TIPO_DATA('OM225','Ud Suministro e instalación de tapa de inodoro','Ud Suministro e instalación de tapa de inodoro (€/un)'),
		T_TIPO_DATA('OM226','Ud Suministro e instalación de descarga de inodoro','Ud Suministro e instalación de descarga de inodoro (€/un)'),
		T_TIPO_DATA('OM227','Suministro e instalación de bañera de chapa lacada de hasta 160 cm de longitud, sin incluir grifería.','Suministro e instalación de bañera de chapa lacada de hasta 160 cm de longitud, sin incluir grifería. (€/un)'),
		T_TIPO_DATA('OM228','Suministro e instalación de bañera acrílica de hasta 160 cm de longitud, sin incluir grifería.','Suministro e instalación de bañera acrílica de hasta 160 cm de longitud, sin incluir grifería. (€/un)'),
		T_TIPO_DATA('OM229','Suministro e instalación de plato de ducha cerámico de hasta 90x90 cm, sin incluir grifería.','Suministro e instalación de plato de ducha cerámico de hasta 90x90 cm, sin incluir grifería. (€/un)'),
		T_TIPO_DATA('OM230','Suministro e instalación de plato de ducha cerámico mayor de 90x90 cm, sin incluir grifería.','Suministro e instalación de plato de ducha cerámico mayor de 90x90 cm, sin incluir grifería. (€/un)'),
		T_TIPO_DATA('OM231','Suministro e instalación de plato de ducha acrílico de hasta 90x90 cm, sin incluir grifería.','Suministro e instalación de plato de ducha acrílico de hasta 90x90 cm, sin incluir grifería. (€/un)'),
		T_TIPO_DATA('OM232','Suministro e instalación de plato de ducha acrílico mayor de 90x90 cm, sin incluir grifería.','Suministro e instalación de plato de ducha acrílico mayor de 90x90 cm, sin incluir grifería. (€/un)'),
		T_TIPO_DATA('OM233','Reparación de persiana hasta 1 m²','Reparación de persiana hasta 1 m² (€/m2)'),
		T_TIPO_DATA('OM234','Reparación de persiana hasta 2 m²','Reparación de persiana hasta 2 m² (€/m2)'),
		T_TIPO_DATA('OM235','Reparación de persiana hasta 4 m²','Reparación de persiana hasta 4 m² (€/m2)'),
		T_TIPO_DATA('OM236','M2 Recolocación de placas de escayola desmontable con perfiles, situados a una altura de hasta 4m','M2 Recolocación de placas de escayola desmontable con perfiles, situados a una altura de hasta 4m (€/m2)'),
		T_TIPO_DATA('OM237','M2 Recolocación de placas de escayola desmontable sin perfiles, situados a una altura de hasta 4m','M2 Recolocación de placas de escayola desmontable sin perfiles, situados a una altura de hasta 4m (€/m2)'),
		T_TIPO_DATA('OM238','Ud Revisión de la instalación de gas de vivienda','Ud Revisión de la instalación de gas de vivienda (€/un)'),
		T_TIPO_DATA('OM239','Ud Suministro e instalación de caldera de condensación de gas de vivienda, incluyendo la instalación de ventilación, el boletín y la legalización.','Ud Suministro e instalación de caldera de condensación de gas de vivienda, incluyendo la instalación de ventilación, el boletín y la legalización. (€/un)'),
		T_TIPO_DATA('OM240','Suministro e instalación de puerta antiocupa homologada cumpliendo normativa europea y suministrada igualmente por fabricante competente para emitir su certificado de idoneidad','Suministro e instalación de puerta antiocupa homologada cumpliendo normativa europea y suministrada igualmente por fabricante competente para emitir su certificado de idoneidad (ud)'),
		T_TIPO_DATA('OM241','Tapiado con malla armada plastificada Pecafil, fabricada por Max Frank GmbH & Co. KG, o similar.','Tapiado con malla armada plastificada Pecafil, fabricada por Max Frank GmbH & Co. KG, o similar. (m²)'),
		T_TIPO_DATA('OM242','Solado o alicatado de elementos de gran formato y/o porcelánicos (sin material).','Solado o alicatado de elementos de gran formato y/o porcelánicos (sin material). (m²)'),
		T_TIPO_DATA('OM243','Solado o alicatado de piedra natural incluyendo el material pétreo, todo el resto de material y trabajos auxiliares.','Solado o alicatado de piedra natural incluyendo el material pétreo, todo el resto de material y trabajos auxiliares. (m²)'),
		T_TIPO_DATA('OM244','Piezas pétreas en fachada mediante anclajes de acero inox.','Piezas pétreas en fachada mediante anclajes de acero inox. (m²)'),
		T_TIPO_DATA('OM245','Cartelería "Prohibido el paso a todo personal ajeno a la obra. Precaución con los menores"','Cartelería "Prohibido el paso a todo personal ajeno a la obra. Precaución con los menores" (ud)'),
		T_TIPO_DATA('OM246','Suministro e instalación de detector de presencia para instalación eléctrica.','Suministro e instalación de detector de presencia para instalación eléctrica. (ud)'),
		T_TIPO_DATA('OM247','Cartelería de instalación de protección contra incendios (salidas de evacuación, extintores, etc.).','Cartelería de instalación de protección contra incendios (salidas de evacuación, extintores, etc.). (ud)'),
		T_TIPO_DATA('OM248','Suministro e instalación de extintor de incendios portátil de eficacia 21A -113B incluyendo soporte y señalización (s/ CTE)','Suministro e instalación de extintor de incendios portátil de eficacia 21A -113B incluyendo soporte y señalización (s/ CTE) (ud)'),
		T_TIPO_DATA('OM249','Suministro e instalación de boca de indendio equipada 25 m incluyendo señalización(s/ CTE)','Suministro e instalación de boca de indendio equipada 25 m incluyendo señalización(s/ CTE) (ud)'),
		T_TIPO_DATA('OM250','Suministro e instalación de boca de indendio equipada 45 m incluyendo señalización(s/ CTE)','Suministro e instalación de boca de indendio equipada 45 m incluyendo señalización(s/ CTE) (ud)'),
		T_TIPO_DATA('OM251','Suministro y sustitución de manguera en BIE de 25m (incluyendo material).','Suministro y sustitución de manguera en BIE de 25m (incluyendo material). (ud)'),
		T_TIPO_DATA('OM252','Suministro y sustitución de manguera en BIE de 45m (incluyendo material).','Suministro y sustitución de manguera en BIE de 45m (incluyendo material). (ud)'),
		T_TIPO_DATA('OM253','Suministro e instalación de puerta EF 30 (s/ CTE), 90x210 totalmente rematada y terminada.','Suministro e instalación de puerta EF 30 (s/ CTE), 90x210 totalmente rematada y terminada. (m²)'),
		T_TIPO_DATA('OM254','Suministro e instalación de puerta EF 60 (s/ CTE), 90x210 totalmente rematada y terminada.','Suministro e instalación de puerta EF 60 (s/ CTE), 90x210 totalmente rematada y terminada. (m²)'),
		T_TIPO_DATA('OM255','Suministro e instalación de luminaria de emergencia (s/ CTE).','Suministro e instalación de luminaria de emergencia (s/ CTE). (ud)'),
		T_TIPO_DATA('OM256','Suministro y colocación de suelos formado por lamas machihembradas/encoladas de aspecto similar al parquet flotante con un laminado plástico estratificado o un recubrimiento melamínico.','Suministro y colocación de suelos formado por lamas machihembradas/encoladas de aspecto similar al parquet flotante con un laminado plástico estratificado o un recubrimiento melamínico. (m²)'),
		T_TIPO_DATA('OM257','Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen.','Búsqueda de atrancos en instalación de saneamiento mediante equipo de obtención de imagen. (ml)'),
		T_TIPO_DATA('OM258','Impermeabilización de cubierta plana asfáltica, no incluyendo retirada ni reposición de material de protección de la lámina. Incluyendo p.p. de remates de desagües, esquinas y cualquier otro elemento que interrumpa la tela.','Impermeabilización de cubierta plana asfáltica, no incluyendo retirada ni reposición de material de protección de la lámina. Incluyendo p.p. de remates de desagües, esquinas y cualquier otro elemento que interrumpa la tela. (m²)'),
		T_TIPO_DATA('OM259','Impermeabilización de cubierta plana de PVC, no incluyendo retirada ni reposición de material de protección de la lámina. Incluyendo p.p. de remates de desagües, esquinas y cualquier otro elemento que interrumpa la membrana.','Impermeabilización de cubierta plana de PVC, no incluyendo retirada ni reposición de material de protección de la lámina. Incluyendo p.p. de remates de desagües, esquinas y cualquier otro elemento que interrumpa la membrana. (m²)'),
		T_TIPO_DATA('OM260','Retirada de teja cerámica o de hormigón, reparación de la impermeabilización y reposición posterior de la teja, con recibido si es necesario (sin aporte de material).','Retirada de teja cerámica o de hormigón, reparación de la impermeabilización y reposición posterior de la teja, con recibido si es necesario (sin aporte de material). (m²)'),
		T_TIPO_DATA('OM261','Drenaje de trasdós de muro mediante excavación, colocación de lámina de drenaje, instalación de tubo dren y relleno posterior con grava según CTE, hasta 3 m de profundidad.','Drenaje de trasdós de muro mediante excavación, colocación de lámina de drenaje, instalación de tubo dren y relleno posterior con grava según CTE, hasta 3 m de profundidad. (ml)'),
		T_TIPO_DATA('OM262','Suministro e instalación mediante anclajes epoxi de rejas de protección en ventanas/ puertas, realizadas con hierro tratado contra la corrosión.','Suministro e instalación mediante anclajes epoxi de rejas de protección en ventanas/ puertas, realizadas con hierro tratado contra la corrosión. (m²)'),
		T_TIPO_DATA('OM263','Revisión, legalización y puesta en marcha de ascensor de hasta 4 alturas.','Revisión, legalización y puesta en marcha de ascensor de hasta 4 alturas. (ud)'),
		T_TIPO_DATA('OM264','Revisión, legalización y puesta en marcha de ascensor de hasta 9 alturas.','Revisión, legalización y puesta en marcha de ascensor de hasta 9 alturas. (ud)'),
		T_TIPO_DATA('OM265','Limpieza de sumidero en cubierta / patio / garaje.','Limpieza de sumidero en cubierta / patio / garaje. (ud)'),
		T_TIPO_DATA('OM266','Limpieza de arqueta de cualquier tipo.','Limpieza de arqueta de cualquier tipo. (ud)'),
		T_TIPO_DATA('OM267','Reparación de acera mediante elemento continuo de hormigón pulido / impreso.','Reparación de acera mediante elemento continuo de hormigón pulido / impreso. (m²)'),
		T_TIPO_DATA('OM268','Reparación de acera mediante elemento discontinuo de baldosa / adoquín.','Reparación de acera mediante elemento discontinuo de baldosa / adoquín. (m²)'),
		T_TIPO_DATA('OM269','Limpieza y desatranco de canaletas e cubierta / patio / garaje con retirada de escombro a vertedero.','Limpieza y desatranco de canaletas e cubierta / patio / garaje con retirada de escombro a vertedero. (ml)'),
		T_TIPO_DATA('OM270','Limpieza de canalones de cualquier material y sección.','Limpieza de canalones de cualquier material y sección. (ml)'),
		T_TIPO_DATA('OM271','Suministro e instalación de grifería monomando de cocina de acero, para colocar empotrado en fregadero.','Suministro e instalación de grifería monomando de cocina de acero, para colocar empotrado en fregadero. (ud)'),
		T_TIPO_DATA('OM272','Suministro e instalación de grifería monomando de lavabo/bidet de acero.','Suministro e instalación de grifería monomando de lavabo/bidet de acero. (ud)'),
		T_TIPO_DATA('OM273','Suministro e instalación de grifería monomando de bañera de acero, con doble salida a grifo y flexo. Incluyendo manguera y ducha.','Suministro e instalación de grifería monomando de bañera de acero, con doble salida a grifo y flexo. Incluyendo manguera y ducha. (ud)'),
		T_TIPO_DATA('OM274','Ud suministro e instalación puerta abatible de 3x2 m., candado incluido. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos.','Ud suministro e instalación puerta abatible de 3x2 m., candado incluido. Unidad totalmente terminada. Incluye todas las partidas complementarias para la correcta ejecución del mismo, incluso gestión de residuos. ()')
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
                    'SET DD_TTF_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_TTF_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
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
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(2)),1,100)||''','''||SUBSTR(TRIM(V_TMP_TIPO_DATA(3)),1,250)||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
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



   