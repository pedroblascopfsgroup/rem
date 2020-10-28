--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20200928
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
	V_ITEM VARCHAR2(30 CHAR) := 'HREOS-11745';
    
    V_PROPIETARIO VARCHAR2(4000 CHAR);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','03','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','01','10','021'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','02','15','021'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','05','10','016'),
		T_TIPO_DATA('1','03','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','01','10','021'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','02','15','021'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','05','10','016'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','90','10','021'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','90','10','021'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('0','03','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','01','10','009'),
		T_TIPO_DATA('1','03','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','01','10','009'),
		T_TIPO_DATA('0','03','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','1','01','10','009'),
		T_TIPO_DATA('1','03','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','1','01','10','009'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','02','0','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('0','','0','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','0','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('1','','0','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('0','02','0','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('0','','0','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','0','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('1','','0','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('0','02','0','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('0','','0','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','0','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('1','','0','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('0','03','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','01','15','002'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','02','17','002'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','05','25','002'),
		T_TIPO_DATA('0','','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','90','10','029'),
		T_TIPO_DATA('1','03','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','01','15','002'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','02','17','002'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','05','25','002'),
		T_TIPO_DATA('1','','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','90','10','029'),
		T_TIPO_DATA('0','','0','Gestoría','Honorarios gestión activos','0','BAS','','GES_ADM','0','90','10','025'),
		T_TIPO_DATA('1','','0','Gestoría','Honorarios gestión activos','0','BAS','','GES_ADM','0','90','10','025'),
		T_TIPO_DATA('0','','0','Gestoría','Honorarios gestión activos','0','BAS','','ALT','0','90','10','025'),
		T_TIPO_DATA('1','','0','Gestoría','Honorarios gestión activos','0','BAS','','ALT','0','90','10','027'),
		T_TIPO_DATA('0','03','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','01','10','031'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','02','15','031'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','05','10','021'),
		T_TIPO_DATA('0','','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','90','10','029'),
		T_TIPO_DATA('1','03','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','01','10','031'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','02','15','031'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','05','10','021'),
		T_TIPO_DATA('1','','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','90','10','029'),
		T_TIPO_DATA('0','03','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','01','10','39 '),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','02','15','39 '),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','05','10','26 '),
		T_TIPO_DATA('1','03','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','01','10','39 '),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','02','15','39 '),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','05','10','26 '),
		T_TIPO_DATA('0','','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','90','10','024'),
		T_TIPO_DATA('1','','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','90','10','024'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','05','25','005'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','02','17','005'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','05','25','005'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','02','17','005'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','05','10','024'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','05','10','024'),
		T_TIPO_DATA('0','03','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','01','10','039'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','02','15','039'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','05','10','026'),
		T_TIPO_DATA('1','03','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','01','10','039'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','02','15','039'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','05','10','026'),
		T_TIPO_DATA('0','03','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','01','10','003'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','02','15','003'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','05','10','002'),
		T_TIPO_DATA('1','03','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','01','10','003'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','02','15','003'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','05','10','002'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI rústica','0','BAS','','','0','01','10','001'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI rústica','0','BAS','','','0','02','15','001'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI rústica','0','BAS','','','0','05','20','001'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI rústica','0','BAS','','','0','01','10','001'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI rústica','0','BAS','','','0','02','15','001'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI rústica','0','BAS','','','0','05','20','001'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI rústica','0','REC','','','0','01','10','023'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI rústica','0','INT','','','0','01','10','024'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI rústica','0','REC','','','0','02','15','023'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI rústica','0','INT','','','0','02','15','024'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI rústica','0','REC','','','0','01','10','023'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI rústica','0','INT','','','0','01','10','024'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI rústica','0','REC','','','0','02','15','023'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI rústica','0','INT','','','0','02','15','024'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI rústica','0','REC','','','0','05','20','005'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI rústica','0','INT','','','0','05','20','006'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI rústica','0','REC','','','0','05','20','005'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI rústica','0','INT','','','0','05','20','006'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI urbana','0','BAS','','','0','01','10','001'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI urbana','0','BAS','','','0','02','15','001'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI urbana','0','BAS','','','0','05','20','001'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI urbana','0','BAS','','','0','01','10','001'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI urbana','0','BAS','','','0','02','15','001'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI urbana','0','BAS','','','0','05','20','001'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI urbana','0','REC','','','0','01','10','023'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI urbana','0','INT','','','0','01','10','024'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI urbana','0','REC','','','0','02','15','023'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI urbana','0','INT','','','0','02','15','024'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI urbana','0','REC','','','0','01','10','023'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI urbana','0','INT','','','0','01','10','024'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI urbana','0','REC','','','0','02','15','023'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI urbana','0','INT','','','0','02','15','024'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI urbana','0','REC','','','0','05','20','005'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI urbana','0','INT','','','0','05','20','006'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI urbana','0','REC','','','0','05','20','005'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI urbana','0','INT','','','0','05','20','006'),
		T_TIPO_DATA('0','02','0','Impuesto','ITPAJD','1','BAS','','','0','05','10','007'),
		T_TIPO_DATA('0','','1','Impuesto','ITPAJD','0','BAS','','','0','07','01','002'),
		T_TIPO_DATA('0','','1','Impuesto','ITPAJD','0','BAS','','','0','07','02','002'),
		T_TIPO_DATA('0','','1','Impuesto','ITPAJD','0','BAS','','','0','07','05','003'),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0','07','01','002'),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0','07','02','002'),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0','07','05','003'),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0','07','01','002'),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0','07','02','002'),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0','07','05','003'),
		T_TIPO_DATA('0','03','0','Impuesto','ITPAJD','0','REC','','','0','01','10','033'),
		T_TIPO_DATA('0','07','0','Impuesto','ITPAJD','0','REC','','','0','02','15','033'),
		T_TIPO_DATA('0','02','0','Impuesto','ITPAJD','0','REC','','','0','05','20','011'),
		T_TIPO_DATA('1','03','0','Impuesto','ITPAJD','0','REC','','','0','01','10','033'),
		T_TIPO_DATA('1','07','0','Impuesto','ITPAJD','0','REC','','','0','02','15','033'),
		T_TIPO_DATA('1','02','0','Impuesto','ITPAJD','0','REC','','','0','05','20','011'),
		T_TIPO_DATA('0','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','01','10','026'),
		T_TIPO_DATA('0','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','02','15','026'),
		T_TIPO_DATA('0','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','05','20','007'),
		T_TIPO_DATA('1','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','01','10','026'),
		T_TIPO_DATA('1','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','02','15','026'),
		T_TIPO_DATA('1','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','05','20','007'),
		T_TIPO_DATA('0','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','01','10','046'),
		T_TIPO_DATA('0','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','01','10','43 '),
		T_TIPO_DATA('0','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','02','15','048'),
		T_TIPO_DATA('0','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','02','15','45 '),
		T_TIPO_DATA('0','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','05','20','013'),
		T_TIPO_DATA('0','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','05','20','014'),
		T_TIPO_DATA('1','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','01','10','046'),
		T_TIPO_DATA('1','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','01','10','043'),
		T_TIPO_DATA('1','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','02','15','048'),
		T_TIPO_DATA('1','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','02','15','045'),
		T_TIPO_DATA('1','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','05','20','013'),
		T_TIPO_DATA('1','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','05','20','014'),
		T_TIPO_DATA('0','03','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('1','03','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','07','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','02','15','043'),
		T_TIPO_DATA('1','07','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','02','15','043'),
		T_TIPO_DATA('0','02','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','05','10','013'),
		T_TIPO_DATA('1','02','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','05','10','013'),
		T_TIPO_DATA('0','','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('0','03','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','07','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('0','02','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('0','','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','03','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('1','07','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('1','02','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('0','03','0','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('0','03','0','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('1','03','0','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('1','03','0','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('0','03','0','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('0','03','0','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('1','03','0','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('1','03','0','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('0','02','0','Otros gastos','Costas judiciales','0','BAS','','','0','05','10','030'),
		T_TIPO_DATA('0','','0','Otros gastos','Costas judiciales','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','0','Otros gastos','Costas judiciales','0','BAS','','','0','05','10','030'),
		T_TIPO_DATA('1','','0','Otros gastos','Costas judiciales','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('0','02','0','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('0','','0','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','0','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('1','','0','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('0','02','0','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','05','10','030'),
		T_TIPO_DATA('0','','0','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','0','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','05','10','030'),
		T_TIPO_DATA('1','','0','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','05','10','019'),
		T_TIPO_DATA('1','03','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','01','10','030'),
		T_TIPO_DATA('1','07','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','02','15','030'),
		T_TIPO_DATA('0','02','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','05','10','019'),
		T_TIPO_DATA('0','03','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','01','10','030'),
		T_TIPO_DATA('0','07','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','02','15','030'),
		T_TIPO_DATA('0','','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','90','10','023'),
		T_TIPO_DATA('0','02','0','Otros gastos','Otros','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('1','02','0','Otros gastos','Otros','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','07','0','Otros gastos','Otros','0','BAS','','','0','02','15','018'),
		T_TIPO_DATA('1','07','0','Otros gastos','Otros','0','BAS','','','0','02','15','018'),
		T_TIPO_DATA('0','03','0','Otros gastos','Otros','0','BAS','','','0','01','10','999'),
		T_TIPO_DATA('1','03','0','Otros gastos','Otros','0','BAS','','','0','01','10','999'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','BAS','K03','','0','05','10','011'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','BAS','K03','','0','01','10','018'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','BAS','K03','','0','02','15','017'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','BAS','K04','','0','05','10','011'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','BAS','K04','','0','01','10','018'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','BAS','K04','','0','02','15','017'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','BAS','K06','','0','05','10','011'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','BAS','K06','','0','01','10','018'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','BAS','K06','','0','02','15','017'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','BAS','K03','','0','05','10','011'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','BAS','K03','','0','01','10','018'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','BAS','K03','','0','02','15','017'),
		T_TIPO_DATA('0','07','0','Sanción','Multa coercitiva','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','02','0','Sanción','Otros','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','02','0','Sanción','Ruina','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','02','0','Sanción','Tributaria','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','02','0','Sanción','Urbanística','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','02','0','Seguros','Parte daños a terceros','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('0','','0','Seguros','Parte daños a terceros','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('1','','0','Seguros','Parte daños a terceros','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('0','02','0','Seguros','Parte daños propios','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('0','','0','Seguros','Parte daños propios','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('1','','0','Seguros','Parte daños propios','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('0','02','0','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('0','','0','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('1','02','0','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('1','','0','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('0','02','0','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('0','','0','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('1','02','0','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('1','','0','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Asesoría','0','BAS','','','0','90','10','024'),
		T_TIPO_DATA('1','','0','Servicios profesionales independientes','Asesoría','0','BAS','','','0','90','10','024'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('1','','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','01','10','012'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','02','15','011'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','05','25','010'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','05','10','005'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','90','10','005'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','90','10','005'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','01','10','012'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','02','15','011'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','05','25','010'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','05','10','005'),
		T_TIPO_DATA('1','','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','90','10','005'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','90','10','005'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','07','01','003'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','07','02','003'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','07','05','004'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','07','01','003'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','07','02','003'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','07','05','004'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','07','01','003'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','07','02','003'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','07','05','004'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Otros','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Otros','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Otros','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Otros','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Otros','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Otros','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Registro','0','BAS','','','0','01','10','013'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Registro','0','BAS','','','0','02','15','012'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Registro','0','BAS','','','0','05','10','006'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Registro','0','BAS','','','0','90','30','005'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Registro','0','BAS','','','0','01','10','013'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Registro','0','BAS','','','0','02','15','012'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Registro','0','BAS','','','0','05','10','006'),
		T_TIPO_DATA('1','','0','Servicios profesionales independientes','Registro','0','BAS','','','0','90','30','005'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','02','0','Suministro','Agua','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('1','02','0','Suministro','Agua','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('0','','0','Suministro','Agua','0','BAS','','','0','90','10','012'),
		T_TIPO_DATA('1','','0','Suministro','Agua','0','BAS','','','0','90','10','012'),
		T_TIPO_DATA('0','02','0','Suministro','Electricidad','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('1','02','0','Suministro','Electricidad','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('0','','0','Suministro','Electricidad','0','BAS','','','0','90','10','013'),
		T_TIPO_DATA('1','','0','Suministro','Electricidad','0','BAS','','','0','90','10','013'),
		T_TIPO_DATA('0','02','0','Suministro','Gas','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('1','02','0','Suministro','Gas','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('0','','0','Suministro','Gas','0','BAS','','','0','90','10','014'),
		T_TIPO_DATA('1','','0','Suministro','Gas','0','BAS','','','0','90','10','014'),
		T_TIPO_DATA('0','02','0','Suministro','Otros','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('1','02','0','Suministro','Otros','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('0','','0','Suministro','Otros','0','BAS','','','0','90','10','016'),
		T_TIPO_DATA('1','','0','Suministro','Otros','0','BAS','','','0','90','10','016'),
		T_TIPO_DATA('0','03','0','Tasa','Agua','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','0','Tasa','Agua','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','0','Tasa','Agua','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','0','Tasa','Agua','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','0','Tasa','Agua','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','0','Tasa','Agua','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Agua','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Agua','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Agua','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Agua','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Agua','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Agua','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Agua','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Agua','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Agua','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Agua','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Agua','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Agua','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','0','Tasa','Alcantarillado','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','0','Tasa','Alcantarillado','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','0','Tasa','Alcantarillado','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','0','Tasa','Alcantarillado','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','0','Tasa','Alcantarillado','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','0','Tasa','Alcantarillado','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Alcantarillado','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Alcantarillado','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Alcantarillado','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Alcantarillado','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Alcantarillado','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Alcantarillado','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Alcantarillado','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Alcantarillado','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Alcantarillado','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Alcantarillado','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Alcantarillado','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Alcantarillado','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','0','Tasa','Basura','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('1','07','0','Tasa','Basura','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','0','Tasa','Basura','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('0','02','0','Tasa','Basura','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('0','','0','Tasa','Basura','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','03','0','Tasa','Basura','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Basura','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Basura','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Basura','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Basura','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Basura','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Basura','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Basura','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Basura','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Basura','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Basura','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Basura','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Basura','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','0','Tasa','Ecotasa','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','0','Tasa','Ecotasa','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','0','Tasa','Ecotasa','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','0','Tasa','Ecotasa','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','0','Tasa','Ecotasa','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','0','Tasa','Ecotasa','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Ecotasa','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Ecotasa','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Ecotasa','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Ecotasa','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Ecotasa','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Ecotasa','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Ecotasa','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Ecotasa','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Ecotasa','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Ecotasa','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Ecotasa','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Ecotasa','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','0','Tasa','Expedición documentos','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','0','Tasa','Expedición documentos','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','0','Tasa','Expedición documentos','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','0','Tasa','Expedición documentos','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','0','Tasa','Expedición documentos','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','0','Tasa','Expedición documentos','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Expedición documentos','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Expedición documentos','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Expedición documentos','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Expedición documentos','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Expedición documentos','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Expedición documentos','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Expedición documentos','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Expedición documentos','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Expedición documentos','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Expedición documentos','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Expedición documentos','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Expedición documentos','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','0','Tasa','Judicial','0','BAS','','','0','01','10','032'),
		T_TIPO_DATA('0','02','0','Tasa','Judicial','0','BAS','','','0','05','20','010'),
		T_TIPO_DATA('1','02','0','Tasa','Judicial','0','BAS','','','0','05','20','010'),
		T_TIPO_DATA('1','03','0','Tasa','Judicial','0','BAS','','','0','01','10','032'),
		T_TIPO_DATA('0','','0','Tasa','Judicial','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','03','0','Tasa','Judicial','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Judicial','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Judicial','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Judicial','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Judicial','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Judicial','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Judicial','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Judicial','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Judicial','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Judicial','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Judicial','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Judicial','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Judicial','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('1','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('0','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','0','Tasa','Otras tasas','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Otras tasas','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Otras tasas','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','0','Tasa','Regularización catastral','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','0','Tasa','Regularización catastral','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','0','Tasa','Regularización catastral','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','0','Tasa','Regularización catastral','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','0','Tasa','Regularización catastral','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','0','Tasa','Regularización catastral','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Regularización catastral','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Regularización catastral','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Regularización catastral','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Regularización catastral','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Regularización catastral','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Regularización catastral','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Regularización catastral','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Regularización catastral','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Regularización catastral','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Regularización catastral','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Regularización catastral','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Regularización catastral','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','0','Tasa','Vado','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','0','Tasa','Vado','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','0','Tasa','Vado','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','0','Tasa','Vado','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','0','Tasa','Vado','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','0','Tasa','Vado','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','0','Tasa','Vado','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','0','Tasa','Vado','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','0','Tasa','Vado','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','0','Tasa','Vado','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','0','Tasa','Vado','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','0','Tasa','Vado','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','0','Tasa','Vado','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','0','Tasa','Vado','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','0','Tasa','Vado','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','0','Tasa','Vado','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','0','Tasa','Vado','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','0','Tasa','Vado','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('0','07','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('0','02','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('1','03','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('1','07','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('1','02','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('0','03','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('0','07','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('0','02','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('1','03','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('1','07','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('1','02','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('0','03','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('0','07','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('0','02','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('1','03','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('1','07','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('1','02','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','INT','K03','','0','05','10','011'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','INT','K03','','0','01','10','018'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','INT','K03','','0','02','15','017'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','INT','K04','','0','05','10','011'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','INT','K04','','0','01','10','018'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','INT','K04','','0','02','15','017'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','INT','K06','','0','05','10','011'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','INT','K06','','0','01','10','018'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','INT','K06','','0','02','15','017'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','INT','K03','','0','05','10','011'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','INT','K03','','0','01','10','018'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','INT','K03','','0','02','15','017'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','REC','K03','','0','05','10','011'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','REC','K03','','0','01','10','018'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','REC','K03','','0','02','15','017'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','REC','K04','','0','05','10','011'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','REC','K04','','0','01','10','018'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','REC','K04','','0','02','15','017'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','REC','K06','','0','05','10','011'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','REC','K06','','0','01','10','018'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','REC','K06','','0','02','15','017'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','REC','K03','','0','05','10','011'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','REC','K03','','0','01','10','018'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','REC','K03','','0','02','15','017'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','BAS','K04','','0','05','10','011'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','BAS','K04','','0','01','10','018'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','BAS','K04','','0','02','15','017'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','BAS','K06','','0','05','10','011'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','BAS','K06','','0','01','10','018'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','BAS','K06','','0','02','15','017'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','INT','K04','','0','05','10','011'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','INT','K04','','0','01','10','018'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','INT','K04','','0','02','15','017'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','INT','K06','','0','05','10','011'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','INT','K06','','0','01','10','018'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','INT','K06','','0','02','15','017'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','REC','K04','','0','05','10','011'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','REC','K04','','0','01','10','018'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','REC','K04','','0','02','15','017'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','REC','K06','','0','05','10','011'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','REC','K06','','0','01','10','018'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','REC','K06','','0','02','15','017'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','03','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','01','10','021'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','02','15','021'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','05','10','016'),
		T_TIPO_DATA('1','03','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','01','10','021'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','02','15','021'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','05','10','016'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','90','10','021'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','90','10','021'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('0','03','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','01','10','009'),
		T_TIPO_DATA('1','03','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','01','10','009'),
		T_TIPO_DATA('0','03','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','1','01','10','009'),
		T_TIPO_DATA('1','03','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','1','01','10','009'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','05','15','003'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','90','10','018'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','05','15','001'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','1','05','15','001'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','02','15','008'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','90','10','002'),
		T_TIPO_DATA('0','02','1','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('0','','1','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','1','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('1','','1','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('0','02','1','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('0','','1','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','1','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('1','','1','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('0','02','1','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('0','','1','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','1','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('1','','1','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('0','03','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','01','15','002'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','02','17','002'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','05','25','002'),
		T_TIPO_DATA('0','','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','90','10','029'),
		T_TIPO_DATA('1','03','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','01','15','002'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','02','17','002'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','05','25','002'),
		T_TIPO_DATA('1','','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','90','10','029'),
		T_TIPO_DATA('0','','1','Gestoría','Honorarios gestión activos','0','BAS','','GES_ADM','0','90','10','025'),
		T_TIPO_DATA('1','','1','Gestoría','Honorarios gestión activos','0','BAS','','GES_ADM','0','90','10','025'),
		T_TIPO_DATA('0','','1','Gestoría','Honorarios gestión activos','0','BAS','','ALT','0','90','10','025'),
		T_TIPO_DATA('1','','1','Gestoría','Honorarios gestión activos','0','BAS','','ALT','0','90','10','027'),
		T_TIPO_DATA('0','03','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','01','10','031'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','02','15','031'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','05','10','021'),
		T_TIPO_DATA('0','','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','90','10','029'),
		T_TIPO_DATA('1','03','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','01','10','031'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','02','15','031'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','05','10','021'),
		T_TIPO_DATA('1','','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','90','10','029'),
		T_TIPO_DATA('0','03','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','01','10','39 '),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','02','15','39 '),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','05','10','26 '),
		T_TIPO_DATA('1','03','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','01','10','39 '),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','02','15','39 '),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','05','10','26 '),
		T_TIPO_DATA('0','','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','90','10','024'),
		T_TIPO_DATA('1','','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','90','10','024'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','05','25','005'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','02','17','005'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','05','25','005'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','02','17','005'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','05','10','024'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','05','10','024'),
		T_TIPO_DATA('0','03','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','01','10','039'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','02','15','039'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','05','10','026'),
		T_TIPO_DATA('1','03','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','01','10','039'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','02','15','039'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','05','10','026'),
		T_TIPO_DATA('0','03','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','01','10','003'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','02','15','003'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','05','10','002'),
		T_TIPO_DATA('1','03','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','01','10','003'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','02','15','003'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','05','10','002'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI rústica','0','BAS','','','0','01','10','001'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI rústica','0','BAS','','','0','02','15','001'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI rústica','0','BAS','','','0','05','20','001'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI rústica','0','BAS','','','0','01','10','001'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI rústica','0','BAS','','','0','02','15','001'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI rústica','0','BAS','','','0','05','20','001'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI rústica','0','REC','','','0','01','10','023'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI rústica','0','INT','','','0','01','10','024'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI rústica','0','REC','','','0','02','15','023'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI rústica','0','INT','','','0','02','15','024'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI rústica','0','REC','','','0','01','10','023'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI rústica','0','INT','','','0','01','10','024'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI rústica','0','REC','','','0','02','15','023'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI rústica','0','INT','','','0','02','15','024'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI rústica','0','REC','','','0','05','20','005'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI rústica','0','INT','','','0','05','20','006'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI rústica','0','REC','','','0','05','20','005'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI rústica','0','INT','','','0','05','20','006'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI urbana','0','BAS','','','0','01','10','001'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI urbana','0','BAS','','','0','02','15','001'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI urbana','0','BAS','','','0','05','20','001'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI urbana','0','BAS','','','0','01','10','001'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI urbana','0','BAS','','','0','02','15','001'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI urbana','0','BAS','','','0','05','20','001'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI urbana','0','REC','','','0','01','10','023'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI urbana','0','INT','','','0','01','10','024'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI urbana','0','REC','','','0','02','15','023'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI urbana','0','INT','','','0','02','15','024'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI urbana','0','REC','','','0','01','10','023'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI urbana','0','INT','','','0','01','10','024'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI urbana','0','REC','','','0','02','15','023'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI urbana','0','INT','','','0','02','15','024'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI urbana','0','REC','','','0','05','20','005'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI urbana','0','INT','','','0','05','20','006'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI urbana','0','REC','','','0','05','20','005'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI urbana','0','INT','','','0','05','20','006'),
		T_TIPO_DATA('0','02','1','Impuesto','ITPAJD','1','BAS','','','0','05','10','007'),
		T_TIPO_DATA('0','03','1','Impuesto','ITPAJD','0','REC','','','0','01','10','033'),
		T_TIPO_DATA('0','07','1','Impuesto','ITPAJD','0','REC','','','0','02','15','033'),
		T_TIPO_DATA('0','02','1','Impuesto','ITPAJD','0','REC','','','0','05','20','011'),
		T_TIPO_DATA('1','03','1','Impuesto','ITPAJD','0','REC','','','0','01','10','033'),
		T_TIPO_DATA('1','07','1','Impuesto','ITPAJD','0','REC','','','0','02','15','033'),
		T_TIPO_DATA('1','02','1','Impuesto','ITPAJD','0','REC','','','0','05','20','011'),
		T_TIPO_DATA('0','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','01','10','026'),
		T_TIPO_DATA('0','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','02','15','026'),
		T_TIPO_DATA('0','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','05','20','007'),
		T_TIPO_DATA('1','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','01','10','026'),
		T_TIPO_DATA('1','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','02','15','026'),
		T_TIPO_DATA('1','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','05','20','007'),
		T_TIPO_DATA('0','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','01','10','046'),
		T_TIPO_DATA('0','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','01','10','43 '),
		T_TIPO_DATA('0','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','02','15','048'),
		T_TIPO_DATA('0','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','02','15','45 '),
		T_TIPO_DATA('0','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','05','20','013'),
		T_TIPO_DATA('0','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','05','20','014'),
		T_TIPO_DATA('1','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','01','10','046'),
		T_TIPO_DATA('1','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','01','10','043'),
		T_TIPO_DATA('1','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','02','15','048'),
		T_TIPO_DATA('1','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','02','15','045'),
		T_TIPO_DATA('1','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','05','20','013'),
		T_TIPO_DATA('1','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','05','20','014'),
		T_TIPO_DATA('0','03','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('1','03','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','07','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','02','15','043'),
		T_TIPO_DATA('1','07','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','02','15','043'),
		T_TIPO_DATA('0','02','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','05','10','013'),
		T_TIPO_DATA('1','02','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','05','10','013'),
		T_TIPO_DATA('0','','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('0','03','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','07','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('0','02','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('0','','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','03','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('1','07','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('1','02','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('0','03','1','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('0','03','1','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('1','03','1','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('1','03','1','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('0','03','1','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('0','03','1','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('1','03','1','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('1','03','1','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','01','10','005'),
		T_TIPO_DATA('0','02','1','Otros gastos','Costas judiciales','0','BAS','','','0','05','10','030'),
		T_TIPO_DATA('0','','1','Otros gastos','Costas judiciales','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','1','Otros gastos','Costas judiciales','0','BAS','','','0','05','10','030'),
		T_TIPO_DATA('1','','1','Otros gastos','Costas judiciales','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('0','02','1','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('0','','1','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','1','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','05','15','004'),
		T_TIPO_DATA('1','','1','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('0','02','1','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','05','10','030'),
		T_TIPO_DATA('0','','1','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','1','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','05','10','030'),
		T_TIPO_DATA('1','','1','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','90','10','004'),
		T_TIPO_DATA('1','02','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','05','10','019'),
		T_TIPO_DATA('1','03','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','01','10','030'),
		T_TIPO_DATA('1','07','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','02','15','030'),
		T_TIPO_DATA('0','02','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','05','10','019'),
		T_TIPO_DATA('0','03','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','01','10','030'),
		T_TIPO_DATA('0','07','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','02','15','030'),
		T_TIPO_DATA('0','','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','90','10','023'),
		T_TIPO_DATA('0','02','1','Otros gastos','Otros','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('1','02','1','Otros gastos','Otros','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','07','1','Otros gastos','Otros','0','BAS','','','0','02','15','018'),
		T_TIPO_DATA('1','07','1','Otros gastos','Otros','0','BAS','','','0','02','15','018'),
		T_TIPO_DATA('0','03','1','Otros gastos','Otros','0','BAS','','','0','01','10','999'),
		T_TIPO_DATA('1','03','1','Otros gastos','Otros','0','BAS','','','0','01','10','999'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','BAS','K03','','0','05','10','011'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','BAS','K03','','0','01','10','018'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','BAS','K03','','0','02','15','017'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','BAS','K04','','0','05','10','011'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','BAS','K04','','0','01','10','018'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','BAS','K04','','0','02','15','017'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','BAS','K06','','0','05','10','011'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','BAS','K06','','0','01','10','018'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','BAS','K06','','0','02','15','017'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','BAS','K03','','0','05','10','011'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','BAS','K03','','0','01','10','018'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','BAS','K03','','0','02','15','017'),
		T_TIPO_DATA('0','07','1','Sanción','Multa coercitiva','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','02','1','Sanción','Otros','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','02','1','Sanción','Ruina','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','02','1','Sanción','Tributaria','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','02','1','Sanción','Urbanística','0','BAS','','','0','05','15','999'),
		T_TIPO_DATA('0','02','1','Seguros','Parte daños a terceros','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('0','','1','Seguros','Parte daños a terceros','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('1','','1','Seguros','Parte daños a terceros','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('0','02','1','Seguros','Parte daños propios','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('0','','1','Seguros','Parte daños propios','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('1','','1','Seguros','Parte daños propios','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('0','02','1','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('0','','1','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('1','02','1','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('1','','1','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('0','02','1','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('0','','1','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('1','02','1','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','05','10','004'),
		T_TIPO_DATA('1','','1','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','90','10','022'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Asesoría','0','BAS','','','0','90','10','024'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Asesoría','0','BAS','','','0','90','10','024'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','01','10','012'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','02','15','011'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','05','25','010'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','05','10','005'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','90','10','005'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','90','10','005'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','01','10','012'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','02','15','011'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','05','25','010'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','05','10','005'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','90','10','005'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','90','10','005'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Otros','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Otros','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Otros','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Otros','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Otros','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Otros','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','01','10','019'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','02','15','019'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','05','10','014'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Registro','0','BAS','','','0','01','10','013'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Registro','0','BAS','','','0','02','15','012'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Registro','0','BAS','','','0','05','10','006'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Registro','0','BAS','','','0','90','30','005'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Registro','0','BAS','','','0','01','10','013'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Registro','0','BAS','','','0','02','15','012'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Registro','0','BAS','','','0','05','10','006'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Registro','0','BAS','','','0','90','30','005'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','90','90','001'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','02','15','002'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','05','10','001'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','01','10','002'),
		T_TIPO_DATA('0','02','1','Suministro','Agua','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('1','02','1','Suministro','Agua','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('0','','1','Suministro','Agua','0','BAS','','','0','90','10','012'),
		T_TIPO_DATA('1','','1','Suministro','Agua','0','BAS','','','0','90','10','012'),
		T_TIPO_DATA('0','02','1','Suministro','Electricidad','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('1','02','1','Suministro','Electricidad','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('0','','1','Suministro','Electricidad','0','BAS','','','0','90','10','013'),
		T_TIPO_DATA('1','','1','Suministro','Electricidad','0','BAS','','','0','90','10','013'),
		T_TIPO_DATA('0','02','1','Suministro','Gas','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('1','02','1','Suministro','Gas','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('0','','1','Suministro','Gas','0','BAS','','','0','90','10','014'),
		T_TIPO_DATA('1','','1','Suministro','Gas','0','BAS','','','0','90','10','014'),
		T_TIPO_DATA('0','02','1','Suministro','Otros','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('1','02','1','Suministro','Otros','0','BAS','','','0','05','15','002'),
		T_TIPO_DATA('0','','1','Suministro','Otros','0','BAS','','','0','90','10','016'),
		T_TIPO_DATA('1','','1','Suministro','Otros','0','BAS','','','0','90','10','016'),
		T_TIPO_DATA('0','03','1','Tasa','Agua','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','1','Tasa','Agua','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','1','Tasa','Agua','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','1','Tasa','Agua','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','1','Tasa','Agua','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','1','Tasa','Agua','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Agua','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Agua','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Agua','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Agua','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Agua','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Agua','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Agua','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Agua','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Agua','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Agua','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Agua','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Agua','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','1','Tasa','Alcantarillado','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','1','Tasa','Alcantarillado','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','1','Tasa','Alcantarillado','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','1','Tasa','Alcantarillado','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','1','Tasa','Alcantarillado','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','1','Tasa','Alcantarillado','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Alcantarillado','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Alcantarillado','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Alcantarillado','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Alcantarillado','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Alcantarillado','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Alcantarillado','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Alcantarillado','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Alcantarillado','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Alcantarillado','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Alcantarillado','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Alcantarillado','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Alcantarillado','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','1','Tasa','Basura','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('1','07','1','Tasa','Basura','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','1','Tasa','Basura','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('0','02','1','Tasa','Basura','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('0','','1','Tasa','Basura','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','03','1','Tasa','Basura','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Basura','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Basura','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Basura','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Basura','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Basura','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Basura','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Basura','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Basura','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Basura','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Basura','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Basura','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Basura','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','1','Tasa','Ecotasa','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','1','Tasa','Ecotasa','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','1','Tasa','Ecotasa','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','1','Tasa','Ecotasa','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','1','Tasa','Ecotasa','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','1','Tasa','Ecotasa','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Ecotasa','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Ecotasa','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Ecotasa','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Ecotasa','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Ecotasa','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Ecotasa','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Ecotasa','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Ecotasa','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Ecotasa','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Ecotasa','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Ecotasa','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Ecotasa','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','1','Tasa','Expedición documentos','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','1','Tasa','Expedición documentos','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','1','Tasa','Expedición documentos','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','1','Tasa','Expedición documentos','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','1','Tasa','Expedición documentos','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','1','Tasa','Expedición documentos','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Expedición documentos','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Expedición documentos','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Expedición documentos','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Expedición documentos','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Expedición documentos','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Expedición documentos','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Expedición documentos','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Expedición documentos','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Expedición documentos','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Expedición documentos','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Expedición documentos','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Expedición documentos','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','1','Tasa','Judicial','0','BAS','','','0','01','10','032'),
		T_TIPO_DATA('0','02','1','Tasa','Judicial','0','BAS','','','0','05','20','010'),
		T_TIPO_DATA('1','02','1','Tasa','Judicial','0','BAS','','','0','05','20','010'),
		T_TIPO_DATA('1','03','1','Tasa','Judicial','0','BAS','','','0','01','10','032'),
		T_TIPO_DATA('0','','1','Tasa','Judicial','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','03','1','Tasa','Judicial','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Judicial','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Judicial','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Judicial','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Judicial','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Judicial','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Judicial','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Judicial','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Judicial','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Judicial','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Judicial','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Judicial','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Judicial','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('1','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('0','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','1','Tasa','Otras tasas','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Otras tasas','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Otras tasas','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','1','Tasa','Regularización catastral','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','1','Tasa','Regularización catastral','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','1','Tasa','Regularización catastral','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','1','Tasa','Regularización catastral','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','1','Tasa','Regularización catastral','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','1','Tasa','Regularización catastral','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Regularización catastral','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Regularización catastral','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Regularización catastral','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Regularización catastral','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Regularización catastral','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Regularización catastral','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Regularización catastral','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Regularización catastral','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Regularización catastral','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Regularización catastral','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Regularización catastral','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Regularización catastral','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','1','Tasa','Vado','0','BAS','','','0','01','10','011'),
		T_TIPO_DATA('0','07','1','Tasa','Vado','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('0','','1','Tasa','Vado','0','BAS','','','0','90','20','004'),
		T_TIPO_DATA('1','07','1','Tasa','Vado','0','BAS','','','0','02','15','010'),
		T_TIPO_DATA('1','02','1','Tasa','Vado','0','BAS','','','0','05','20','002'),
		T_TIPO_DATA('1','03','1','Tasa','Vado','0','BAS','','','0','01','10','11 '),
		T_TIPO_DATA('0','03','1','Tasa','Vado','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('0','03','1','Tasa','Vado','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('1','03','1','Tasa','Vado','0','REC','','','0','01','10','044'),
		T_TIPO_DATA('1','03','1','Tasa','Vado','0','INT','','','0','01','10','045'),
		T_TIPO_DATA('0','07','1','Tasa','Vado','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('0','07','1','Tasa','Vado','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','02','1','Tasa','Vado','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('0','02','1','Tasa','Vado','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','02','1','Tasa','Vado','0','REC','','','0','05','20','015'),
		T_TIPO_DATA('1','02','1','Tasa','Vado','0','INT','','','0','05','20','016'),
		T_TIPO_DATA('1','07','1','Tasa','Vado','0','REC','','','0','02','15','046'),
		T_TIPO_DATA('1','07','1','Tasa','Vado','0','INT','','','0','02','15','047'),
		T_TIPO_DATA('0','03','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('0','07','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('0','02','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('1','03','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('1','07','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('1','02','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('0','03','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('0','07','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('0','02','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('1','03','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('1','07','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('1','02','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('0','03','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('0','07','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('0','02','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('1','03','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','01','10','007'),
		T_TIPO_DATA('1','07','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','02','15','006'),
		T_TIPO_DATA('1','02','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','05','15','005'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','INT','K03','','0','05','10','011'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','INT','K03','','0','01','10','018'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','INT','K03','','0','02','15','017'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','INT','K04','','0','05','10','011'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','INT','K04','','0','01','10','018'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','INT','K04','','0','02','15','017'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','INT','K06','','0','05','10','011'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','INT','K06','','0','01','10','018'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','INT','K06','','0','02','15','017'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','INT','K03','','0','05','10','011'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','INT','K03','','0','01','10','018'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','INT','K03','','0','02','15','017'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','REC','K03','','0','05','10','011'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','REC','K03','','0','01','10','018'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','REC','K03','','0','02','15','017'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','REC','K04','','0','05','10','011'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','REC','K04','','0','01','10','018'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','REC','K04','','0','02','15','017'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','REC','K06','','0','05','10','011'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','REC','K06','','0','01','10','018'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','REC','K06','','0','02','15','017'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','REC','K03','','0','05','10','011'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','REC','K03','','0','01','10','018'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','REC','K03','','0','02','15','017'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','BAS','K04','','0','05','10','011'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','BAS','K04','','0','01','10','018'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','BAS','K04','','0','02','15','017'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','BAS','K06','','0','05','10','011'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','BAS','K06','','0','01','10','018'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','BAS','K06','','0','02','15','017'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','INT','K04','','0','05','10','011'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','INT','K04','','0','01','10','018'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','INT','K04','','0','02','15','017'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','INT','K06','','0','05','10','011'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','INT','K06','','0','01','10','018'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','INT','K06','','0','02','15','017'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','REC','K04','','0','05','10','011'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','REC','K04','','0','01','10','018'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','REC','K04','','0','02','15','017'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','REC','K06','','0','05','10','011'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','REC','K06','','0','01','10','018'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','REC','K06','','0','02','15','017')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN
    
	DBMS_OUTPUT.PUT_LINE('[INICIO] Vaciamos tabla temporal... ');
    V_SQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA;
    EXECUTE IMMEDIATE V_SQL;

	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TMP_'||V_TEXT_TABLA);

	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_'||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: No existe la tabla');
	ELSE
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
            DBMS_OUTPUT.put_line('[INFO]: Insertando fila '||I||'.'); 
--T_TIPO_DATA('BANCO'1,'BDE'2,'VENDIDO'3,'TIPO DE GASTO'4,'SUBTIPO DE GASTO'5,'ACTIVABLE'6,'TIPO_IMPORTE'7,'TRIBUTOS TERCEROS'8,'COMISIONAMIENTO'9,'PLAN VISITAS'10,'APARTADO'11,'CAPITULO'12,'PARTIDA'13)
                IF TRIM(V_TMP_TIPO_DATA(1)) = 0 THEN
                    V_PROPIETARIO := '''A15011489'', ''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''7758258''';
                ELSE
                    V_PROPIETARIO := '''A86201993''';
                END IF;
                
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' (
							CPP_PTDAS_ID
							, CPP_PARTIDA_PRESUPUESTARIA
							, CPP_APARTADO
							, CPP_CAPITULO
							, DD_TGA_ID
							, DD_STG_ID
							, DD_CRA_ID
							, PRO_ID
							, EJE_ID
							, FECHACREAR
							, DD_TBE_ID
							, CPP_ACTIVABLE
							, CPP_PLAN_VISITAS
							, DD_TCH_ID
							, DD_TIM_ID
							, DD_TRT_ID
							, CPP_VENDIDO
							) 
							SELECT 
								'||I||'
								, '''||TRIM(V_TMP_TIPO_DATA(13))||''' CPP_PARTIDA_PRESUPUESTARIA
								, '''||TRIM(V_TMP_TIPO_DATA(11))||''' CPP_APARTADO
								, '''||TRIM(V_TMP_TIPO_DATA(12))||''' CPP_CAPITULO
								, TGA.DD_TGA_ID
								, STG.DD_STG_ID
								, CRA.DD_CRA_ID
								, PRO.PRO_ID
								, EJE.EJE_ID
								, SYSDATE FECHACREAR
								, TBE.DD_TBE_ID
								, '||TRIM(V_TMP_TIPO_DATA(6))||' CPP_ACTIVABLE
								, '||TRIM(V_TMP_TIPO_DATA(10))||' CPP_PLAN_VISITAS
								, TCH.DD_TCH_ID
								, TIM.DD_TIM_ID
								, TRT.DD_TRT_ID
								, '||TRIM(V_TMP_TIPO_DATA(3))||' CPP_VENDIDO
							FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO
							JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(4))||'''
								AND TGA.BORRADO = 0 
                            JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON TGA.DD_TGA_ID = STG.DD_TGA_ID 
                            	AND STG.DD_STG_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(5))||'''
                            	AND STG.BORRADO = 0 
							JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.BORRADO = 0 
								AND EJE.EJE_ANYO IN (2020, 2019)
                            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = PRO.DD_CRA_ID
                                AND CRA.BORRADO = 0
							LEFT JOIN '||V_ESQUEMA||'.DD_TCH_TIPO_COMISIONADO_HRE TCH ON 1 = 1 AND TCH.BORRADO = 0 AND TCH.DD_TCH_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(9))||'''
							LEFT JOIN '||V_ESQUEMA||'.DD_TBE_TIPO_ACTIVO_BDE TBE ON 1 = 1 AND TBE.BORRADO = 0 AND TBE.DD_TBE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
							LEFT JOIN '||V_ESQUEMA||'.DD_TIM_TIPO_IMPORTE TIM ON 1 = 1 AND TIM.BORRADO = 0 AND TIM.DD_TIM_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(7))||'''
							LEFT JOIN '||V_ESQUEMA||'.DD_TRT_TRIBUTOS_A_TERCEROS TRT ON 1 = 1 AND TRT.BORRADO = 0 AND TRT.DD_TRT_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(8))||'''
							WHERE PRO.BORRADO = 0 
								AND CRA.DD_CRA_CODIGO = ''08''
								AND PRO.PRO_DOCIDENTIF IN ('||V_PROPIETARIO||')';                          
				EXECUTE IMMEDIATE V_MSQL;
                
                IF SQL%ROWCOUNT = 1 THEN 
                    DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado 1 registro para la fila '||I||'.');
                ELSIF SQL%ROWCOUNT > 1 THEN
                    DBMS_OUTPUT.PUT_LINE('[INFO]: Se han insertado '||SQL%ROWCOUNT||' registros para la fila '||I||'.');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO]: No se insertó ningún registro para la fila '||I||'.');
                END IF;
                
		END LOOP;
	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO]: TABLA TMP_'||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: Preparamos partidas para tabla de negocio.');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
		SET CPP_PTDAS_ID = ROWNUM';
	EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' T1
      USING (
          SELECT CPP_PTDAS_ID
              , ROW_NUMBER() OVER(
                  PARTITION BY DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID
                      , PRO_ID, EJE_ID, CPP_ARRENDAMIENTO, CPP_REFACTURABLE, DD_TBE_ID
                      , CPP_ACTIVABLE, CPP_PLAN_VISITAS, DD_TCH_ID, DD_TRT_ID
                      , CPP_VENDIDO
                  ORDER BY CPP_PTDAS_ID
              ) RN
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      ) T2
      ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID)
      WHEN MATCHED THEN 
          UPDATE SET T1.CPP_PRINCIPAL = CASE WHEN T2.RN = 1 THEN 1 ELSE 0 END';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      SET DD_TIM_ID = (SELECT DD_TIM_ID FROM DD_TIM_TIPO_IMPORTE WHERE DD_TIM_CODIGO = ''BAS'')
      WHERE DD_TIM_ID IS NULL';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' T1
      USING (
          SELECT CPP_PTDAS_ID
              , ROW_NUMBER() OVER(
                  PARTITION BY DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID
                      , PRO_ID, EJE_ID, CPP_ARRENDAMIENTO, CPP_REFACTURABLE, DD_TBE_ID
                      , CPP_ACTIVABLE, CPP_PLAN_VISITAS, DD_TCH_ID, DD_TRT_ID
                      , CPP_VENDIDO
                  ORDER BY CPP_PTDAS_ID
              ) RN
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
          WHERE CPP_PRINCIPAL = 0
      ) T2
      ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID AND T2.RN > 1)
      WHEN MATCHED THEN
          UPDATE SET T1.BORRADO = 1';
    EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
		WHERE DD_STG_ID IS NULL
			OR CPP_PARTIDA_PRESUPUESTARIA IS NULL';
	EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: Partidas preparadas.');
	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
          CPP_PTDAS_ID
          , CPP_PARTIDA_PRESUPUESTARIA
          , CPP_APARTADO
          , CPP_CAPITULO
          , DD_TGA_ID
          , DD_STG_ID
          , DD_TIM_ID
          , DD_CRA_ID
          , DD_SCR_ID
          , PRO_ID
          , EJE_ID
          , CPP_ARRENDAMIENTO
          , CPP_REFACTURABLE
          , USUARIOCREAR
          , FECHACREAR
          , DD_TBE_ID
          , CPP_ACTIVABLE
          , CPP_PLAN_VISITAS
          , DD_TCH_ID
          , CPP_PRINCIPAL
          , DD_TRT_ID
          , CPP_VENDIDO
      )
      SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
          , CPP.CPP_PARTIDA_PRESUPUESTARIA
          , CPP.CPP_APARTADO
          , CPP.CPP_CAPITULO
          , CPP.DD_TGA_ID
          , CPP.DD_STG_ID
          , CPP.DD_TIM_ID
          , CPP.DD_CRA_ID
          , CPP.DD_SCR_ID
          , CPP.PRO_ID
          , CPP.EJE_ID
          , CPP.CPP_ARRENDAMIENTO
          , CPP.CPP_REFACTURABLE
          , '''||V_ITEM||'''
          , SYSDATE
          , CPP.DD_TBE_ID
          , CPP.CPP_ACTIVABLE
          , CPP.CPP_PLAN_VISITAS
          , CPP.DD_TCH_ID
          , CPP.CPP_PRINCIPAL
          , CPP.DD_TRT_ID
          , CPP.CPP_VENDIDO
      FROM (
          SELECT TMP.CPP_PARTIDA_PRESUPUESTARIA
          	  , TMP.CPP_APARTADO
          	  , TMP.CPP_CAPITULO
              , TMP.DD_TGA_ID
              , TMP.DD_STG_ID
              , TMP.DD_TIM_ID
              , TMP.DD_CRA_ID
              , SCR.DD_SCR_ID
              , TMP.PRO_ID
              , TMP.EJE_ID
              , ARR.NUMERO CPP_ARRENDAMIENTO
              , 0 CPP_REFACTURABLE
              , TMP.DD_TBE_ID
              , TMP.CPP_ACTIVABLE
              , TMP.CPP_PLAN_VISITAS
              , TMP.DD_TCH_ID
              , TMP.CPP_PRINCIPAL
              , TMP.DD_TRT_ID
              , TMP.CPP_VENDIDO
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' TMP
          JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = TMP.DD_CRA_ID
          	  AND SCR.BORRADO = 0
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO ARR ON 1 = 1
          WHERE NVL(TMP.BORRADO, 0) = 0
      ) CPP
      WHERE NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX
              WHERE AUX.DD_TGA_ID = CPP.DD_TGA_ID
                  AND AUX.DD_STG_ID = CPP.DD_STG_ID
                  AND AUX.DD_TIM_ID = CPP.DD_TIM_ID
                  AND AUX.DD_CRA_ID = CPP.DD_CRA_ID
                  AND NVL(AUX.DD_SCR_ID, 0) = NVL(CPP.DD_SCR_ID, NVL(AUX.DD_SCR_ID, 0))
                  AND AUX.PRO_ID = CPP.PRO_ID
                  AND AUX.EJE_ID = CPP.EJE_ID
                  AND NVL(AUX.CPP_ARRENDAMIENTO, 0) = NVL(CPP.CPP_ARRENDAMIENTO, NVL(AUX.CPP_ARRENDAMIENTO, 0))
                  AND AUX.CPP_REFACTURABLE = CPP.CPP_REFACTURABLE
                  AND NVL(AUX.DD_TBE_ID, 0) = NVL(CPP.DD_TBE_ID, 0)
                  AND AUX.CPP_ACTIVABLE = CPP.CPP_ACTIVABLE
                  AND AUX.CPP_PLAN_VISITAS = CPP.CPP_PLAN_VISITAS
                  AND NVL(AUX.DD_TCH_ID, 0) = NVL(CPP.DD_TCH_ID, 0)
                  AND AUX.CPP_PRINCIPAL = CPP.CPP_PRINCIPAL
                  AND NVL(AUX.DD_TRT_ID, 0) = NVL(CPP.DD_TRT_ID, 0)
                  AND NVL(AUX.CPP_VENDIDO, 0) = NVL(CPP.CPP_VENDIDO, NVL(AUX.CPP_VENDIDO, 0))
                  AND AUX.BORRADO = 0
          )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' partidas sin subcartera inicial insertadas');

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
          CPP_PTDAS_ID
          , CPP_PARTIDA_PRESUPUESTARIA
          , CPP_APARTADO
          , CPP_CAPITULO
          , DD_TGA_ID
          , DD_STG_ID
          , DD_TIM_ID
          , DD_CRA_ID
          , DD_SCR_ID
          , PRO_ID
          , EJE_ID
          , CPP_ARRENDAMIENTO
          , CPP_REFACTURABLE
          , USUARIOCREAR
          , FECHACREAR
          , DD_TBE_ID
          , CPP_ACTIVABLE
          , CPP_PLAN_VISITAS
          , DD_TCH_ID
          , CPP_PRINCIPAL
          , DD_TRT_ID
          , CPP_VENDIDO
      )
      SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
          , CPP.CPP_PARTIDA_PRESUPUESTARIA
          , CPP.CPP_APARTADO
          , CPP.CPP_CAPITULO
          , CPP.DD_TGA_ID
          , CPP.DD_STG_ID
          , CPP.DD_TIM_ID
          , CPP.DD_CRA_ID
          , CPP.DD_SCR_ID
          , CPP.PRO_ID
          , CPP.EJE_ID
          , CPP.CPP_ARRENDAMIENTO
          , CPP.CPP_REFACTURABLE
          , '''||V_ITEM||'''
          , SYSDATE
          , CPP.DD_TBE_ID
          , CPP.CPP_ACTIVABLE
          , CPP.CPP_PLAN_VISITAS
          , CPP.DD_TCH_ID
          , CPP.CPP_PRINCIPAL
          , CPP.DD_TRT_ID
          , CPP.CPP_VENDIDO
      FROM (
          SELECT TMP.CPP_PARTIDA_PRESUPUESTARIA
          	  , TMP.CPP_APARTADO
          	  , TMP.CPP_CAPITULO
              , TMP.DD_TGA_ID
              , TMP.DD_STG_ID
              , TMP.DD_TIM_ID
              , TMP.DD_CRA_ID
              , NULL DD_SCR_ID
              , TMP.PRO_ID
              , TMP.EJE_ID
              , NULL CPP_ARRENDAMIENTO
              , 0 CPP_REFACTURABLE
              , TMP.DD_TBE_ID
              , TMP.CPP_ACTIVABLE
              , TMP.CPP_PLAN_VISITAS
              , TMP.DD_TCH_ID
              , TMP.CPP_PRINCIPAL
              , TMP.DD_TRT_ID
              , TMP.CPP_VENDIDO
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' TMP
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO ARR ON 1 = 1
          WHERE NVL(TMP.BORRADO, 0) = 0
          		AND TMP.DD_TBE_ID IS NULL
      ) CPP
      WHERE NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX
              WHERE AUX.DD_TGA_ID = CPP.DD_TGA_ID
                  AND AUX.DD_STG_ID = CPP.DD_STG_ID
                  AND AUX.DD_TIM_ID = CPP.DD_TIM_ID
                  AND AUX.DD_CRA_ID = CPP.DD_CRA_ID
                  AND NVL(AUX.DD_SCR_ID, 0) = NVL(CPP.DD_SCR_ID, NVL(AUX.DD_SCR_ID, 0))
                  AND AUX.PRO_ID = CPP.PRO_ID
                  AND AUX.EJE_ID = CPP.EJE_ID
                  AND NVL(AUX.CPP_ARRENDAMIENTO, 0) = NVL(CPP.CPP_ARRENDAMIENTO, NVL(AUX.CPP_ARRENDAMIENTO, 0))
                  AND AUX.CPP_REFACTURABLE = CPP.CPP_REFACTURABLE
                  AND NVL(AUX.DD_TBE_ID, 0) = NVL(CPP.DD_TBE_ID, 0)
                  AND AUX.CPP_ACTIVABLE = CPP.CPP_ACTIVABLE
                  AND AUX.CPP_PLAN_VISITAS = CPP.CPP_PLAN_VISITAS
                  AND NVL(AUX.DD_TCH_ID, 0) = NVL(CPP.DD_TCH_ID, 0)
                  AND AUX.CPP_PRINCIPAL = CPP.CPP_PRINCIPAL
                  AND NVL(AUX.DD_TRT_ID, 0) = NVL(CPP.DD_TRT_ID, 0)
                  AND NVL(AUX.CPP_VENDIDO, 0) = NVL(CPP.CPP_VENDIDO, NVL(AUX.CPP_VENDIDO, 0))
                  AND AUX.BORRADO = 0
          )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||SQL%ROWCOUNT||' partidas sin subcartera final insertadas');

    COMMIT;

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
