--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11217
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Actuación post-venta',0,0,'NULL',0,'62200000000','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Actuación post-venta',0,0,'NULL',0,'68740000007','05','15','001')/*,
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Actuación post-venta',0,0,'NULL',0,'62200000000','90','10','002'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Actuación post-venta',0,0,'NULL',0,'68740000007','90','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Actuación técnica y mantenimiento','Cambio de cerradura',0,0,'NULL',0,'62200000000','01','10','021'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Cambio de cerradura',0,0,'NULL',0,'62200000000','02','15','021'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Cambio de cerradura',0,0,'NULL',0,'62200000000','05','10','016'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Actuación técnica y mantenimiento','Cambio de cerradura',0,0,'NULL',0,'68740000007','01','10','021'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Cambio de cerradura',0,0,'NULL',0,'68740000007','02','15','021'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Cambio de cerradura',0,0,'NULL',0,'68740000007','05','10','016'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Cambio de cerradura',0,0,'NULL',0,'62200000000','90','10','002'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Cambio de cerradura',0,0,'NULL',0,'68740000007','90','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Colocación puerta antiocupa',0,0,'NULL',0,'62900000000','05','15','005'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Colocación puerta antiocupa',0,0,'NULL',0,'68740000009','05','15','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Colocación puerta antiocupa',0,0,'NULL',0,'62900000000','02','15','006'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Colocación puerta antiocupa',0,0,'NULL',0,'68740000009','02','15','006'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Colocación puerta antiocupa',0,0,'NULL',0,'62900000000','90','10','021'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Colocación puerta antiocupa',0,0,'NULL',0,'68740000009','90','10','021'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Limpieza',0,0,'NULL',0,'62200000000','05','15','003'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Limpieza',0,0,'NULL',0,'68740000007','05','15','003'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Limpieza',0,0,'NULL',0,'62200000000','02','15','008'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Limpieza',0,0,'NULL',0,'68740000007','02','15','008'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Limpieza',0,0,'NULL',0,'62200000000','90','10','018'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Limpieza',0,0,'NULL',0,'68740000007','90','10','018'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)',0,0,'NULL',0,'62200000000','01','10','009'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)',0,0,'NULL',0,'68740000007','01','10','009'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)',0,0,'NULL',0,'62200000000','90','10','018'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)',0,0,'NULL',0,'68740000007','90','10','018'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje',0,0,'NULL',0,'62200000000','05','15','003'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje',0,0,'NULL',0,'68740000007','05','15','003'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje',0,0,'NULL',0,'62200000000','02','15','008'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje',0,0,'NULL',0,'68740000007','02','15','008'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje',0,0,'NULL',0,'62200000000','90','10','018'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje',0,0,'NULL',0,'68740000007','90','10','018'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Limpieza y retirada de enseres',0,0,'NULL',0,'62200000000','05','15','003'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Limpieza y retirada de enseres',0,0,'NULL',0,'68740000007','05','15','003'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Limpieza y retirada de enseres',0,0,'NULL',0,'62200000000','02','15','008'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Limpieza y retirada de enseres',0,0,'NULL',0,'68740000007','02','15','008'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Limpieza y retirada de enseres',0,0,'NULL',0,'62200000000','90','10','018'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Limpieza y retirada de enseres',0,0,'NULL',0,'68740000007','90','10','018'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Mobiliario',0,0,'NULL',0,'62200000000','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Mobiliario',0,0,'NULL',0,'68740000007','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Mobiliario',0,0,'NULL',0,'62200000000','02','15','008'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Mobiliario',0,0,'NULL',0,'68740000007','02','15','008'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Mobiliario',0,0,'NULL',0,'62200000000','90','10','002'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Mobiliario',0,0,'NULL',0,'68740000007','90','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)',0,0,'NULL',0,'62200000000','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)',0,0,'NULL',0,'68740000007','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)',0,0,'NULL',0,'62200000000','02','15','008'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)',0,0,'NULL',0,'68740000007','02','15','008'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)',0,0,'NULL',0,'62200000000','90','10','002'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)',0,0,'NULL',0,'68740000007','90','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Obra menor',0,0,'NULL',0,'62200000000','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Obra menor',0,0,'NULL',0,'68740000007','02','15','008'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Obra menor',0,0,'NULL',0,'62200000000','02','15','008'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Obra menor',0,0,'NULL',0,'68740000007','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Obra menor',0,0,'NULL',0,'62200000000','90','10','002'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Obra menor',0,0,'NULL',0,'68740000007','90','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Retirada de enseres',0,0,'NULL',0,'62200000000','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Retirada de enseres',0,0,'NULL',0,'68740000007','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Retirada de enseres',0,0,'NULL',0,'62200000000','90','10','002'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Retirada de enseres',0,0,'NULL',0,'68740000007','90','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Retirada de enseres',0,0,'NULL',0,'62200000000','02','15','008'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Retirada de enseres',0,0,'NULL',0,'68740000007','02','15','008'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Seguridad y Salud (SS)',0,0,'NULL',0,'62200000000','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Seguridad y Salud (SS)',0,0,'NULL',0,'68740000007','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Seguridad y Salud (SS)',0,0,'NULL',0,'62200000000','90','10','002'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Seguridad y Salud (SS)',0,0,'NULL',0,'68740000007','90','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Seguridad y Salud (SS)',0,0,'NULL',0,'62200000000','02','15','008'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Seguridad y Salud (SS)',0,0,'NULL',0,'68740000007','02','15','008'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Tapiado',0,0,'NULL',0,'62200000000','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Tapiado',0,0,'NULL',0,'68740000007','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Tapiado',0,0,'NULL',0,'62200000000','90','10','002'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Tapiado',0,0,'NULL',0,'68740000007','90','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Tapiado',0,0,'NULL',0,'62200000000','02','15','008'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Tapiado',0,0,'NULL',0,'68740000007','02','15','008'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Verificación de averías',0,0,'NULL',0,'62200000000','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Verificación de averías',0,0,'NULL',0,'68740000007','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Actuación técnica y mantenimiento','Verificación de averías',0,0,'NULL',0,'62200000000','02','15','008'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Actuación técnica y mantenimiento','Verificación de averías',0,0,'NULL',0,'68740000007','02','15','008'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Actuación técnica y mantenimiento','Verificación de averías',0,0,'NULL',0,'62200000000','90','10','002'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Actuación técnica y mantenimiento','Verificación de averías',0,0,'NULL',0,'68740000007','90','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Comunidad de propietarios','Certificado deuda comunidad',0,0,'NULL',0,'62200000000','05','15','004'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Comunidad de propietarios','Certificado deuda comunidad',0,0,'NULL',0,'62200000000','90','10','004'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Comunidad de propietarios','Certificado deuda comunidad',0,0,'NULL',0,'68800000001','05','15','004'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Comunidad de propietarios','Certificado deuda comunidad',0,0,'NULL',0,'68800000001','90','10','004'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Comunidad de propietarios','Cuota extraordinaria (derrama)',0,0,'NULL',0,'62200000000','05','15','004'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Comunidad de propietarios','Cuota extraordinaria (derrama)',0,0,'NULL',0,'62200000000','90','10','004'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Comunidad de propietarios','Cuota extraordinaria (derrama)',0,0,'NULL',0,'68800000001','05','15','004'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Comunidad de propietarios','Cuota extraordinaria (derrama)',0,0,'NULL',0,'68800000001','90','10','004'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Comunidad de propietarios','Cuota ordinaria',0,0,'NULL',0,'62200000000','05','15','004'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Comunidad de propietarios','Cuota ordinaria',0,0,'NULL',0,'62200000000','90','10','004'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Comunidad de propietarios','Cuota ordinaria',0,0,'NULL',0,'68800000001','05','15','004'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Comunidad de propietarios','Cuota ordinaria',0,0,'NULL',0,'68800000001','90','10','004'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Gestoría','Honorarios gestión activos',0,0,'''Venta éxito''',0,'62300000007','01','15','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Gestoría','Honorarios gestión activos',0,0,'''Venta éxito''',0,'62300000007','02','17','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Gestoría','Honorarios gestión activos',0,0,'''Venta éxito''',0,'62300000007','05','25','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Gestoría','Honorarios gestión activos',0,0,'''Venta éxito''',0,'62300000007','90','10','029'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Gestoría','Honorarios gestión activos',0,0,'''Venta éxito''',0,'62930000003','01','15','002'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Gestoría','Honorarios gestión activos',0,0,'''Venta éxito''',0,'62930000003','02','17','002'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Gestoría','Honorarios gestión activos',0,0,'''Venta éxito''',0,'62930000003','05','25','002'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Gestoría','Honorarios gestión activos',0,0,'''Venta éxito''',0,'62930000003','90','10','029'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Gestoría','Honorarios gestión activos',0,0,'''Gestión y administración''',0,'62300000008','90','10','025'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Gestoría','Honorarios gestión activos',0,0,'''Gestión y administración''',0,'68740000019','90','10','025'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Gestoría','Honorarios gestión activos',0,0,'''Altas''',0,'62300000009','90','10','025'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Gestoría','Honorarios gestión activos',0,0,'''Altas''',0,'68740000019','90','10','027'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Gestoría','Honorarios gestión activos',0,0,'''Alquiler''',0,'62300000010','01','10','031'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Gestoría','Honorarios gestión activos',0,0,'''Alquiler''',0,'62300000010','02','15','031'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Gestoría','Honorarios gestión activos',0,0,'''Alquiler''',0,'62300000010','05','10','021'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Gestoría','Honorarios gestión activos',0,0,'''Alquiler''',0,'62300000010','90','10','029'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Gestoría','Honorarios gestión activos',0,0,'''Alquiler''',0,'62930000002','01','10','031'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Gestoría','Honorarios gestión activos',0,0,'''Alquiler''',0,'62930000002','02','15','031'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Gestoría','Honorarios gestión activos',0,0,'''Alquiler''',0,'62930000002','05','10','021'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Gestoría','Honorarios gestión activos',0,0,'''Alquiler''',0,'62930000002','90','10','029'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Gestoría','Honorarios gestión activos',0,0,'''Gestoría''',0,'62300000000','01','10','39 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Gestoría','Honorarios gestión activos',0,0,'''Gestoría''',0,'62300000000','02','15','39 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Gestoría','Honorarios gestión activos',0,0,'''Gestoría''',0,'62300000000','05','10','26 '),
		T_TIPO_DATA('08','''A86201993''','SUELO','Gestoría','Honorarios gestión activos',0,0,'''Gestoría''',0,'68740000008','01','10','39 '),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Gestoría','Honorarios gestión activos',0,0,'''Gestoría''',0,'68740000008','02','15','39 '),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Gestoría','Honorarios gestión activos',0,0,'''Gestoría''',0,'68740000008','05','10','26 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Gestoría','Honorarios gestión activos',0,0,'''Gestoría''',0,'62300000000','90','10','024'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Gestoría','Honorarios gestión activos',0,0,'''Gestoría''',0,'68740000008','90','10','024'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Gestoría','Honorarios gestión activos',0,0,'''Desocupación activos''',0,'62300000011','05','25','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Gestoría','Honorarios gestión activos',0,0,'''Desocupación activos''',0,'62300000011','02','17','005'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Gestoría','Honorarios gestión activos',0,0,'''Desocupación activos''',0,'62930000001','05','25','005'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Gestoría','Honorarios gestión activos',0,0,'''Desocupación activos''',0,'62930000001','02','17','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Gestoría','Honorarios gestión ventas',0,0,'NULL',0,'62300000000','01','10','039'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Gestoría','Honorarios gestión ventas',0,0,'NULL',0,'62300000000','02','15','039'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Gestoría','Honorarios gestión ventas',0,0,'NULL',0,'68740000008','01','10','039'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Gestoría','Honorarios gestión ventas',0,0,'NULL',0,'68740000008','02','15','039'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Impuesto','IBI rústica',0,0,'NULL',0,'63100000004','01','10','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Impuesto','IBI rústica',0,0,'NULL',0,'63100000004','02','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Impuesto','IBI rústica',0,0,'NULL',0,'63100000004','05','20','001'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Impuesto','IBI rústica',0,0,'NULL',0,'68740000002','01','10','001'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Impuesto','IBI rústica',0,0,'NULL',0,'68740000002','02','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Impuesto','IBI rústica',0,0,'NULL',0,'68740000002','05','20','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Impuesto','IBI urbana',0,0,'NULL',0,'63100000004','01','10','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Impuesto','IBI urbana',0,0,'NULL',0,'63100000004','02','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Impuesto','IBI urbana',0,0,'NULL',0,'63100000004','05','20','001'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Impuesto','IBI urbana',0,0,'NULL',0,'68740000002','01','10','001'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Impuesto','IBI urbana',0,0,'NULL',0,'68740000002','02','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Impuesto','IBI urbana',0,0,'NULL',0,'68740000002','05','20','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Impuesto','ITPAJD',1,0,'NULL',0,'63100000002','05','10','007'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','VENDIDO/SUELO','Impuesto','ITPAJD',1,0,'NULL',0,'61980000000','07','01','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','VENDIDO/OBRA EN CURSO','Impuesto','ITPAJD',1,0,'NULL',0,'61980000000','07','02','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','VENDIDO/TERMINADO','Impuesto','ITPAJD',1,0,'NULL',0,'61980000000','07','05','003'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','VENDIDO/TERMINADO','Impuesto','ITPAJD',1,0,'NULL',0,'61980000000','07','05','003'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/ANC SUELO','Impuesto','ITPAJD',1,0,'NULL',0,'6813','07','01','002'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/ANC O. CURSO','Impuesto','ITPAJD',1,0,'NULL',0,'6813','07','02','002'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/ANC TERMINADO','Impuesto','ITPAJD',1,0,'NULL',0,'6813','07','05','003'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/INMOVILIZADO SUELO','Impuesto','ITPAJD',1,0,'NULL',0,'6819','07','01','002'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/INMOVILIZADO O.CURSO','Impuesto','ITPAJD',1,0,'NULL',0,'6819','07','02','002'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/INMOVILIZADO TERMINADO','Impuesto','ITPAJD',1,0,'NULL',0,'6819','07','05','003'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Impuesto','Plusvalía (IIVTNU) compra',0,0,'NULL',0,'63100000005','01','10','026'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Impuesto','Plusvalía (IIVTNU) compra',0,0,'NULL',0,'63100000005','02','15','026'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Impuesto','Plusvalía (IIVTNU) compra',0,0,'NULL',0,'63100000005','05','20','007'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Impuesto','Plusvalía (IIVTNU) compra',0,0,'NULL',0,'68740000003','01','10','026'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Impuesto','Plusvalía (IIVTNU) compra',0,0,'NULL',0,'68740000003','02','15','026'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Impuesto','Plusvalía (IIVTNU) compra',0,0,'NULL',0,'68740000003','05','20','007'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Impuesto','Plusvalía (IIVTNU) venta',0,0,'NULL',0,'63100000005','01','10','026'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Impuesto','Plusvalía (IIVTNU) venta',0,0,'NULL',0,'63100000005','02','15','026'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Impuesto','Plusvalía (IIVTNU) venta',0,0,'NULL',0,'63100000005','05','20','007'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Impuesto','Plusvalía (IIVTNU) venta',0,0,'NULL',0,'68740000003','01','10','026'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Impuesto','Plusvalía (IIVTNU) venta',0,0,'NULL',0,'68740000003','02','15','026'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Impuesto','Plusvalía (IIVTNU) venta',0,0,'NULL',0,'68740000003','05','20','007'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)',0,0,'NULL',0,'62300000003','01','10','002'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)',0,0,'NULL',0,'68740000005','01','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)',0,0,'NULL',0,'62300000003','02','15','043'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)',0,0,'NULL',0,'68740000005','02','15','043'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)',0,0,'NULL',0,'62300000003','05','10','013'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)',0,0,'NULL',0,'68740000005','05','10','013'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)',0,0,'NULL',0,'62300000003','90','90','001'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)',0,0,'NULL',0,'68740000005','90','90','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Informes técnicos y obtención documentos','Informes',0,0,'NULL',0,'62300000004','01','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Informes técnicos y obtención documentos','Informes',0,0,'NULL',0,'62300000004','02','15','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Informes técnicos y obtención documentos','Informes',0,0,'NULL',0,'62300000004','05','10','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Informes técnicos y obtención documentos','Informes',0,0,'NULL',0,'62300000004','90','90','001'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Informes técnicos y obtención documentos','Informes',0,0,'NULL',0,'68740000005','90','90','001'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Informes técnicos y obtención documentos','Informes',0,0,'NULL',0,'68740000005','01','10','002'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Informes técnicos y obtención documentos','Informes',0,0,'NULL',0,'68740000005','02','15','002'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Informes técnicos y obtención documentos','Informes',0,0,'NULL',0,'68740000005','05','10','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Junta de compensación / EUC','Cuotas y derramas',0,0,'NULL',0,'62200000000','01','10','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Junta de compensación / EUC','Cuotas y derramas',0,0,'NULL',0,'62200000000','01','10','005'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Junta de compensación / EUC','Cuotas y derramas',0,0,'NULL',0,'68740000009','01','10','005'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Junta de compensación / EUC','Cuotas y derramas',0,0,'NULL',0,'68800000001','01','10','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Junta de compensación / EUC','Gastos generales',0,0,'NULL',0,'62200000000','01','10','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Junta de compensación / EUC','Gastos generales',0,0,'NULL',0,'62200000000','01','10','005'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Junta de compensación / EUC','Gastos generales',0,0,'NULL',0,'68740000009','01','10','005'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Junta de compensación / EUC','Gastos generales',0,0,'NULL',0,'68800000001','01','10','005'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Otros gastos','Mensajería/correos/copias',0,0,'NULL',0,'68740000009','05','10','019'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Otros gastos','Mensajería/correos/copias',0,0,'NULL',0,'68740000009','01','10','030'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Otros gastos','Mensajería/correos/copias',0,0,'NULL',0,'68740000009','02','15','030'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Otros gastos','Mensajería/correos/copias',0,0,'NULL',0,'62900000000','05','10','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Otros gastos','Mensajería/correos/copias',0,0,'NULL',0,'62900000000','01','10','030'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Otros gastos','Mensajería/correos/copias',0,0,'NULL',0,'62900000000','02','15','030'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Otros gastos','Mensajería/correos/copias',0,0,'NULL',0,'62900000000','90','10','023'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Otros gastos','Otros',0,0,'NULL',0,'62300000000','05','15','999'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Otros gastos','Otros',0,0,'NULL',0,'68740000009','05','15','999'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Otros gastos','Otros',0,0,'NULL',0,'62300000000','02','15','018'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Otros gastos','Otros',0,0,'NULL',0,'68740000009','02','15','018'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Otros gastos','Otros',0,0,'NULL',0,'62300000000','01','10','999'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Otros gastos','Otros',0,0,'NULL',0,'68740000009','01','10','999'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Otros tributos','Contribución especial',0,0,'NULL',0,'63100000003','90','40','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Otros tributos','Otros',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Otros tributos','Otros',0,0,'NULL',0,'63100000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Otros tributos','Otros',0,0,'NULL',0,'63100000003','05','20','002'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Otros tributos','Otros',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Otros tributos','Otros',0,0,'NULL',0,'68740000003','01','10','011'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Otros tributos','Otros',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Sanción','Multa coercitiva',0,0,'NULL',0,'62900000000','05','15','999'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Sanción','Otros',0,0,'NULL',0,'62900000000','05','15','999'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Sanción','Ruina',0,0,'NULL',0,'62900000000','05','15','999'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Sanción','Tributaria',0,0,'NULL',0,'62900000000','05','15','999'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Sanción','Urbanística',0,0,'NULL',0,'62900000000','05','15','999'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Seguros','Parte daños a terceros',0,0,'NULL',0,'62500000000','05','10','004'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Seguros','Parte daños a terceros',0,0,'NULL',0,'62500000000','90','10','022'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Seguros','Parte daños a terceros',0,0,'NULL',0,'68740000006','90','10','022'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Seguros','Parte daños propios',0,0,'NULL',0,'62500000000','05','10','004'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Seguros','Parte daños propios',0,0,'NULL',0,'62500000000','90','10','022'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Seguros','Parte daños propios',0,0,'NULL',0,'68740000006','90','10','022'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Seguros','Prima RC (responsabilidad civil)',0,0,'NULL',0,'62500000000','05','10','004'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Seguros','Prima RC (responsabilidad civil)',0,0,'NULL',0,'62500000000','90','10','022'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Seguros','Prima RC (responsabilidad civil)',0,0,'NULL',0,'68740000006','05','10','004'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Seguros','Prima RC (responsabilidad civil)',0,0,'NULL',0,'68740000006','90','10','022'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Seguros','Prima TRDM (todo riesgo daño material)',0,0,'NULL',0,'62500000000','05','10','004'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Seguros','Prima TRDM (todo riesgo daño material)',0,0,'NULL',0,'62500000000','90','10','022'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Seguros','Prima TRDM (todo riesgo daño material)',0,0,'NULL',0,'68740000006','05','10','004'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Seguros','Prima TRDM (todo riesgo daño material)',0,0,'NULL',0,'68740000006','90','10','022'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Servicios profesionales independientes','Abogado (Asistencia jurídica)',0,0,'NULL',0,'62300000005','01','10','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Servicios profesionales independientes','Abogado (Asistencia jurídica)',0,0,'NULL',0,'62300000005','02','15','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Servicios profesionales independientes','Abogado (Asistencia jurídica)',0,0,'NULL',0,'62300000005','05','10','014'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Servicios profesionales independientes','Abogado (Asistencia jurídica)',0,0,'NULL',0,'68740000009','01','10','019'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Servicios profesionales independientes','Abogado (Asistencia jurídica)',0,0,'NULL',0,'68740000009','02','15','019'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Servicios profesionales independientes','Abogado (Asistencia jurídica)',0,0,'NULL',0,'68740000009','05','10','014'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Servicios profesionales independientes','Abogado (Asuntos generales)',0,0,'NULL',0,'62300000005','01','10','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Servicios profesionales independientes','Abogado (Asuntos generales)',0,0,'NULL',0,'62300000005','02','15','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Servicios profesionales independientes','Abogado (Asuntos generales)',0,0,'NULL',0,'62300000005','05','10','014'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Servicios profesionales independientes','Abogado (Asuntos generales)',0,0,'NULL',0,'68740000009','01','10','019'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Servicios profesionales independientes','Abogado (Asuntos generales)',0,0,'NULL',0,'68740000009','02','15','019'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Servicios profesionales independientes','Abogado (Asuntos generales)',0,0,'NULL',0,'68740000009','05','10','014'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Servicios profesionales independientes','Abogado (Ocupacional)',0,0,'NULL',0,'62300000005','01','10','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Servicios profesionales independientes','Abogado (Ocupacional)',0,0,'NULL',0,'62300000005','02','15','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Servicios profesionales independientes','Abogado (Ocupacional)',0,0,'NULL',0,'62300000005','05','10','014'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Servicios profesionales independientes','Abogado (Ocupacional)',0,0,'NULL',0,'68740000009','01','10','019'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Servicios profesionales independientes','Abogado (Ocupacional)',0,0,'NULL',0,'68740000009','02','15','019'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Servicios profesionales independientes','Abogado (Ocupacional)',0,0,'NULL',0,'68740000009','05','10','014'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Servicios profesionales independientes','Asesoría',0,0,'NULL',0,'62300000000','90','10','024'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Servicios profesionales independientes','Asesoría',0,0,'NULL',0,'68740000008','90','10','024'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Servicios profesionales independientes','Gestión de suelo',0,0,'NULL',0,'62300000004','01','10','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Servicios profesionales independientes','Gestión de suelo',0,0,'NULL',0,'62300000004','02','15','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Servicios profesionales independientes','Gestión de suelo',0,0,'NULL',0,'62300000004','05','10','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Servicios profesionales independientes','Gestión de suelo',0,0,'NULL',0,'62300000004','90','90','001'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Servicios profesionales independientes','Gestión de suelo',0,0,'NULL',0,'68740000005','01','10','002'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Servicios profesionales independientes','Gestión de suelo',0,0,'NULL',0,'68740000005','02','15','002'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Servicios profesionales independientes','Gestión de suelo',0,0,'NULL',0,'68740000005','05','10','001'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Servicios profesionales independientes','Gestión de suelo',0,0,'NULL',0,'68740000005','90','90','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Servicios profesionales independientes','Notaría',0,0,'NULL',0,'62300000001','02','15','011'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Servicios profesionales independientes','Notaría',0,0,'NULL',0,'68740000004','02','15','011'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Servicios profesionales independientes','Notaría',0,0,'NULL',0,'68740000004','90','10','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','VENDIDO/SUELO','Servicios profesionales independientes','Notaría',1,0,'NULL',0,'61980000000','07','01','003'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','VENDIDO/OBRA EN CURSO','Servicios profesionales independientes','Notaría',1,0,'NULL',0,'61980000000','07','02','003'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','VENDIDO/TERMINADO','Servicios profesionales independientes','Notaría',1,0,'NULL',0,'61980000000','07','05','004'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/ANC SUELO','Servicios profesionales independientes','Notaría',1,0,'NULL',0,'6813.PROMOCION','07','01','003'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/ANC O.CURSO','Servicios profesionales independientes','Notaría',1,0,'NULL',0,'6813.PROMOCION','07','02','003'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/ANC TERMINADO','Servicios profesionales independientes','Notaría',1,0,'NULL',0,'6813.PROMOCION','07','05','004'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/ INMV SUELO','Servicios profesionales independientes','Notaría',1,0,'NULL',0,'6819.PROMOCION','07','01','003'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/INMV O CURSO','Servicios profesionales independientes','Notaría',1,0,'NULL',0,'6819.PROMOCION','07','02','003'),
		T_TIPO_DATA('08','''A86201993''','VENDIDO/INMV TERMINADO','Servicios profesionales independientes','Notaría',1,0,'NULL',0,'6819.PROMOCION','07','05','004'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Servicios profesionales independientes','Otros',0,0,'NULL',0,'68740000010','01','10','019'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Servicios profesionales independientes','Otros',0,0,'NULL',0,'68740000010','02','15','019'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Servicios profesionales independientes','Otros',0,0,'NULL',0,'68740000010','05','10','014'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Servicios profesionales independientes','Otros servicios jurídicos',0,0,'NULL',0,'68740000010','01','10','019'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Servicios profesionales independientes','Otros servicios jurídicos',0,0,'NULL',0,'68740000010','02','15','019'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Servicios profesionales independientes','Otros servicios jurídicos',0,0,'NULL',0,'68740000010','05','10','014'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Servicios profesionales independientes','Otros',0,0,'NULL',0,'62300000013','01','10','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Servicios profesionales independientes','Otros',0,0,'NULL',0,'62300000013','02','15','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Servicios profesionales independientes','Otros',0,0,'NULL',0,'62300000013','05','10','014'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Servicios profesionales independientes','Otros servicios jurídicos',0,0,'NULL',0,'62300000013','01','10','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Servicios profesionales independientes','Otros servicios jurídicos',0,0,'NULL',0,'62300000013','02','15','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Servicios profesionales independientes','Otros servicios jurídicos',0,0,'NULL',0,'62300000013','05','10','014'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Servicios profesionales independientes','Procurador',0,0,'NULL',0,'62300000005','01','10','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Servicios profesionales independientes','Procurador',0,0,'NULL',0,'62300000005','02','15','019'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Servicios profesionales independientes','Procurador',0,0,'NULL',0,'62300000005','05','10','014'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Servicios profesionales independientes','Procurador',0,0,'NULL',0,'68740000009','01','10','019'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Servicios profesionales independientes','Procurador',0,0,'NULL',0,'68740000009','02','15','019'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Servicios profesionales independientes','Procurador',0,0,'NULL',0,'68740000009','05','10','014'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Servicios profesionales independientes','Registro',0,0,'NULL',0,'62300000002','01','10','013'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Servicios profesionales independientes','Registro',0,0,'NULL',0,'62300000002','02','15','012'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Servicios profesionales independientes','Registro',0,0,'NULL',0,'62300000002','05','10','006'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Servicios profesionales independientes','Registro',0,0,'NULL',0,'62300000002','90','30','005'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Servicios profesionales independientes','Registro',0,0,'NULL',0,'68740000004','01','10','013'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Servicios profesionales independientes','Registro',0,0,'NULL',0,'68740000004','02','15','012'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Servicios profesionales independientes','Registro',0,0,'NULL',0,'68740000004','05','10','006'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Servicios profesionales independientes','Registro',0,0,'NULL',0,'68740000004','90','30','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Servicios profesionales independientes','Tasación',0,0,'NULL',0,'62300000004','02','15','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Servicios profesionales independientes','Tasación',0,0,'NULL',0,'62300000004','05','10','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Servicios profesionales independientes','Tasación',0,0,'NULL',0,'62300000004','90','90','001'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Servicios profesionales independientes','Tasación',0,0,'NULL',0,'68740000005','90','90','001'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Servicios profesionales independientes','Tasación',0,0,'NULL',0,'68740000005','01','10','002'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Servicios profesionales independientes','Tasación',0,0,'NULL',0,'68740000005','02','15','002'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Servicios profesionales independientes','Tasación',0,0,'NULL',0,'68740000005','05','10','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Suministro','Agua',0,0,'NULL',0,'62800000000','05','15','002'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Suministro','Agua',0,0,'NULL',0,'68740000007','05','15','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Suministro','Agua',0,0,'NULL',0,'62800000000','90','10','012'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Suministro','Agua',0,0,'NULL',0,'68740000007','90','10','012'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Suministro','Electricidad',0,0,'NULL',0,'62800000000','05','15','002'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Suministro','Electricidad',0,0,'NULL',0,'68740000007','05','15','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Suministro','Electricidad',0,0,'NULL',0,'62800000000','90','10','013'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Suministro','Electricidad',0,0,'NULL',0,'68740000007','90','10','013'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Suministro','Gas',0,0,'NULL',0,'62800000000','05','15','002'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Suministro','Gas',0,0,'NULL',0,'68740000007','05','15','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Suministro','Gas',0,0,'NULL',0,'62800000000','90','10','014'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Suministro','Gas',0,0,'NULL',0,'68740000007','90','10','014'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Suministro','Otros',0,0,'NULL',0,'62800000000','05','15','002'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Suministro','Otros',0,0,'NULL',0,'68740000007','05','15','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Suministro','Otros',0,0,'NULL',0,'62800000000','90','10','016'),
		T_TIPO_DATA('08','''A86201993''','GENERICA','Suministro','Otros',0,0,'NULL',0,'68740000007','90','10','016'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Agua',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Tasa','Agua',0,0,'NULL',0,'63100000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Agua',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Tasa','Agua',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Agua',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Agua',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Alcantarillado',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Tasa','Alcantarillado',0,0,'NULL',0,'63100000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Alcantarillado',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Tasa','Alcantarillado',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Alcantarillado',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Alcantarillado',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Basura',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Tasa','Basura',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Basura',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Tasa','Basura',0,0,'NULL',0,'63100000003','05','20','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Basura',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Basura',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Ecotasa',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Tasa','Ecotasa',0,0,'NULL',0,'63100000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Ecotasa',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Tasa','Ecotasa',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Ecotasa',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Ecotasa',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Expedición documentos',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Tasa','Expedición documentos',0,0,'NULL',0,'63100000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Expedición documentos',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Tasa','Expedición documentos',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Expedición documentos',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Expedición documentos',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Judicial',0,0,'NULL',0,'63100000007','01','10','032'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Tasa','Judicial',0,0,'NULL',0,'63100000007','05','20','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Judicial',0,0,'NULL',0,'68740000003','05','20','010'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Judicial',0,0,'NULL',0,'68740000003','01','10','032'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Judicial',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Judicial',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Tasa','Obras / Rehabilitación / Mantenimiento',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Obras / Rehabilitación / Mantenimiento',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Obras / Rehabilitación / Mantenimiento',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Tasa','Obras / Rehabilitación / Mantenimiento',0,0,'NULL',0,'63100000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Obras / Rehabilitación / Mantenimiento',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Obras / Rehabilitación / Mantenimiento',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Otras tasas',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Tasa','Otras tasas',0,0,'NULL',0,'63100000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Otras tasas',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Tasa','Otras tasas',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Otras tasas',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Otras tasas',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Otras tasas ayuntamiento',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Tasa','Otras tasas ayuntamiento',0,0,'NULL',0,'63100000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Otras tasas ayuntamiento',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Tasa','Otras tasas ayuntamiento',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Otras tasas ayuntamiento',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Otras tasas ayuntamiento',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Regularización catastral',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Tasa','Regularización catastral',0,0,'NULL',0,'63100000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Regularización catastral',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Tasa','Regularización catastral',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Regularización catastral',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Regularización catastral',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Tasa','Vado',0,0,'NULL',0,'63100000003','01','10','011'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Tasa','Vado',0,0,'NULL',0,'63100000003','02','15','010'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Tasa','Vado',0,0,'NULL',0,'63100000003','90','20','004'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Tasa','Vado',0,0,'NULL',0,'68740000003','02','15','010'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Tasa','Vado',0,0,'NULL',0,'68740000003','05','20','002'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Tasa','Vado',0,0,'NULL',0,'68740000003','01','10','11 '),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Vigilancia y seguridad','Alarmas',0,0,'NULL',0,'62900000000','01','10','007'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Vigilancia y seguridad','Alarmas',0,0,'NULL',0,'62900000000','02','15','006'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Vigilancia y seguridad','Alarmas',0,0,'NULL',0,'62900000000','05','15','005'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Vigilancia y seguridad','Alarmas',0,0,'NULL',0,'68740000009','01','10','007'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Vigilancia y seguridad','Alarmas',0,0,'NULL',0,'68740000009','02','15','006'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Vigilancia y seguridad','Alarmas',0,0,'NULL',0,'68740000009','05','15','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Vigilancia y seguridad','Servicios auxiliares',0,0,'NULL',0,'62900000000','01','10','007'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Vigilancia y seguridad','Servicios auxiliares',0,0,'NULL',0,'62900000000','02','15','006'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Vigilancia y seguridad','Servicios auxiliares',0,0,'NULL',0,'62900000000','05','15','005'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Vigilancia y seguridad','Servicios auxiliares',0,0,'NULL',0,'68740000009','01','10','007'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Vigilancia y seguridad','Servicios auxiliares',0,0,'NULL',0,'68740000009','02','15','006'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Vigilancia y seguridad','Servicios auxiliares',0,0,'NULL',0,'68740000009','05','15','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Vigilancia y seguridad','Vigilancia y seguridad',0,0,'NULL',0,'62900000000','01','10','007'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','OBRA EN CURSO','Vigilancia y seguridad','Vigilancia y seguridad',0,0,'NULL',0,'62900000000','02','15','006'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Vigilancia y seguridad','Vigilancia y seguridad',0,0,'NULL',0,'62900000000','05','15','005'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Vigilancia y seguridad','Vigilancia y seguridad',0,0,'NULL',0,'68740000009','01','10','007'),
		T_TIPO_DATA('08','''A86201993''','OBRA EN CURSO','Vigilancia y seguridad','Vigilancia y seguridad',0,0,'NULL',0,'68740000009','02','15','006'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Vigilancia y seguridad','Vigilancia y seguridad',0,0,'NULL',0,'68740000009','05','15','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Actuación post-venta',0,0,'NULL',1,'62200000001','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Actuación post-venta',0,0,'NULL',1,'68740000011','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Colocación puerta antiocupa',0,0,'NULL',1,'62200000001','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Colocación puerta antiocupa',0,0,'NULL',1,'68740000011','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)',0,0,'NULL',1,'62200000001','01','10','009'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)',0,0,'NULL',1,'68740000011','01','10','009'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Mobiliario',0,0,'NULL',1,'62200000001','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Mobiliario',0,0,'NULL',1,'68740000011','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)',0,0,'NULL',1,'62200000001','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)',0,0,'NULL',1,'68740000011','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Obra menor',0,0,'NULL',1,'62200000001','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Obra menor',0,0,'NULL',1,'68740000011','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Retirada de enseres',0,0,'NULL',1,'62200000001','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Retirada de enseres',0,0,'NULL',1,'68740000011','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Seguridad y Salud (SS)',0,0,'NULL',1,'62200000001','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Seguridad y Salud (SS)',0,0,'NULL',1,'68740000011','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Tapiado',0,0,'NULL',1,'62200000001','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Tapiado',0,0,'NULL',1,'68740000011','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Actuación técnica y mantenimiento','Verificación de averías',0,0,'NULL',1,'62200000001','05','15','001'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Actuación técnica y mantenimiento','Verificación de averías',0,0,'NULL',1,'68740000011','05','15','001'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Gestoría','Honorarios gestión ventas',0,1,'NULL',0,'62300000000','05','10','026'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Gestoría','Honorarios gestión ventas',0,1,'NULL',0,'68740000008','05','10','026'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Servicios profesionales independientes','Notaría',0,1,'NULL',0,'62300000001','01','10','012'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','TERMINADO','Servicios profesionales independientes','Notaría',0,1,'NULL',0,'62300000001','05','10','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','GENERICA','Servicios profesionales independientes','Notaría',0,1,'NULL',0,'62300000001','90','10','005'),
		T_TIPO_DATA('08','''A86201993''','SUELO','Servicios profesionales independientes','Notaría',0,1,'NULL',0,'68740000004','01','10','012'),
		T_TIPO_DATA('08','''A86201993''','TERMINADO','Servicios profesionales independientes','Notaría',0,1,'NULL',0,'68740000004','05','10','005'),
		T_TIPO_DATA('08','''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''A15011489''','SUELO','Servicios profesionales independientes','Tasación',0,1,'NULL',0,'62300000004','01','10','002')*/
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);

	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: No exista la tabla');
	ELSE
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);

				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
							CPP_PTDAS_ID
							, CPP_PARTIDA_PRESUPUESTARIA
							, DD_TGA_ID
							, DD_STG_ID
							, DD_CRA_ID
							, PRO_ID
							, EJE_ID
							, USUARIOCREAR
							, FECHACREAR
							, CPP_PRINCIPAL
							, DD_TBE_ID
							, CPP_APARTADO
							, CPP_CAPITULO
							, CPP_ACTIVABLE
							, CPP_PLAN_VISITAS
							, DD_TCH_ID
							) 
							SELECT 
								'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL CPP_PTDAS_ID
								, '''||TRIM(V_TMP_TIPO_DATA(13))||''' CPP_PARTIDA_PRESUPUESTARIA
								, TGA.DD_TGA_ID
								, STG.DD_STG_ID
								, CRA.DD_CRA_ID
								, PRO.PRO_ID
								, EJE.EJE_ID
								, ''HREOS-11217'' USUARIOCREAR
								, SYSDATE FECHACREAR
								, '||TRIM(V_TMP_TIPO_DATA(7))||' CPP_PRINCIPAL
								, TBE.DD_TBE_ID
								, '''||TRIM(V_TMP_TIPO_DATA(11))||''' CPP_APARTADO
								, '''||TRIM(V_TMP_TIPO_DATA(12))||''' CPP_CAPITULO
								, '||TRIM(V_TMP_TIPO_DATA(6))||' CPP_ACTIVABLE
								, '||TRIM(V_TMP_TIPO_DATA(9))||' CPP_PLAN_VISITAS
								, TCH.DD_TCH_ID
							FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO
                            LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID AND CRA.BORRADO = 0 AND CRA.DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
                            LEFT JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON 1 = 1 AND STG.BORRADO = 0 AND STG.DD_STG_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(5))||'''
							LEFT JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID AND TGA.BORRADO = 0 AND TGA.DD_TGA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
							LEFT JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON 1 = 1 AND EJE.BORRADO = 0 AND EJE.EJE_ANYO = ''2020''
							LEFT JOIN '||V_ESQUEMA||'.DD_TCH_TIPO_COMISIONADO_HRE TCH ON 1 = 1 AND TCH.BORRADO = 0 AND TCH.DD_TCH_DESCRIPCION = '||TRIM(V_TMP_TIPO_DATA(8))||'
							LEFT JOIN '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE TBE ON 1 = 1 AND TBE.BORRADO = 0 AND TBE.DD_TBE_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
							WHERE PRO.BORRADO = 0 AND PRO.PRO_DOCIDENTIF IN ('||TRIM(V_TMP_TIPO_DATA(2))||')';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(5))||''' y '''||TRIM(V_TMP_TIPO_DATA(13))||'''');
		END LOOP;
	END IF;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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
EXIT;
