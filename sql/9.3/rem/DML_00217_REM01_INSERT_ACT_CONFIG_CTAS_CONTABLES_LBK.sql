--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11745
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_CTAS_CONTABLES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ITEM VARCHAR2(30 CHAR) := 'HREOS-11745';
    
    V_CONSTRAINT_NAME VARCHAR2(30 CHAR);

    CURSOR CONSTRAINTS_ENABLED IS SELECT CONSTRAINT_NAME
      FROM ALL_CONSTRAINTS
      WHERE TABLE_NAME = 'ACT_CONFIG_CTAS_CONTABLES'
          AND STATUS = 'ENABLED'
          AND CONSTRAINT_TYPE IN ('C', 'U', 'F', 'P');

    CURSOR CONSTRAINTS_DISABLED IS SELECT CONSTRAINT_NAME 
      FROM ALL_CONSTRAINTS
      WHERE TABLE_NAME = 'ACT_CONFIG_CTAS_CONTABLES'
          AND STATUS = 'DISABLED'
          AND CONSTRAINT_TYPE IN ('C', 'U', 'F', 'P');

    V_PROPIETARIO VARCHAR2(4000 CHAR);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','03','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','03','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','03','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','03','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','03','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','03','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','07','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','0','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','','0','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('1','','0','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','02','0','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','','0','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('1','','0','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','02','0','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','','0','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('1','','0','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','03','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62300000007'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62300000007'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62300000007'),
		T_TIPO_DATA('0','','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62300000007'),
		T_TIPO_DATA('1','03','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62930000003'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62930000003'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62930000003'),
		T_TIPO_DATA('1','','0','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62930000003'),
		T_TIPO_DATA('0','','0','Gestoría','Honorarios gestión activos','0','BAS','','GES_ADM','0','62300000008'),
		T_TIPO_DATA('1','','0','Gestoría','Honorarios gestión activos','0','BAS','','GES_ADM','0','68740000019'),
		T_TIPO_DATA('0','','0','Gestoría','Honorarios gestión activos','0','BAS','','ALT','0','62300000009'),
		T_TIPO_DATA('1','','0','Gestoría','Honorarios gestión activos','0','BAS','','ALT','0','68740000019'),
		T_TIPO_DATA('0','03','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62300000010'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62300000010'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62300000010'),
		T_TIPO_DATA('0','','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62300000010'),
		T_TIPO_DATA('1','03','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62930000002'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62930000002'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62930000002'),
		T_TIPO_DATA('1','','0','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62930000002'),
		T_TIPO_DATA('0','03','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','62300000000'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','62300000000'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','62300000000'),
		T_TIPO_DATA('1','03','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','68740000008'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','68740000008'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','68740000008'),
		T_TIPO_DATA('0','','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','62300000000'),
		T_TIPO_DATA('1','','0','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','68740000008'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','62300000011'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','62300000011'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','62930000001'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','62930000001'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('0','03','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','03','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión ventas','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('0','03','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('0','07','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('0','02','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','03','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('1','07','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('1','02','0','Gestoría','Honorarios gestión activos','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI rústica','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI rústica','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI rústica','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI rústica','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI rústica','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI rústica','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI rústica','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI rústica','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI rústica','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI rústica','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI rústica','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI rústica','0','INT','','','0','68740000002'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI rústica','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI rústica','0','INT','','','0','68740000002'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI rústica','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI rústica','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI rústica','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI rústica','0','INT','','','0','68740000002'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI urbana','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI urbana','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI urbana','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI urbana','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI urbana','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI urbana','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI urbana','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Impuesto','IBI urbana','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI urbana','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Impuesto','IBI urbana','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI urbana','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','03','0','Impuesto','IBI urbana','0','INT','','','0','68740000002'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI urbana','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','07','0','Impuesto','IBI urbana','0','INT','','','0','68740000002'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI urbana','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Impuesto','IBI urbana','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI urbana','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','02','0','Impuesto','IBI urbana','0','INT','','','0','68740000002'),
		T_TIPO_DATA('0','02','0','Impuesto','ITPAJD','1','BAS','','','0','63100000002'),
		T_TIPO_DATA('0','','1','Impuesto','ITPAJD','0','BAS','','','0','61980000000'),
		T_TIPO_DATA('0','','1','Impuesto','ITPAJD','0','BAS','','','0',''),
		T_TIPO_DATA('0','','1','Impuesto','ITPAJD','0','BAS','','','0',''),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0','6813.PROMOCION'),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0',''),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0',''),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0',''),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0',''),
		T_TIPO_DATA('1','','1','Impuesto','ITPAJD','0','BAS','','','0',''),
		T_TIPO_DATA('0','03','0','Impuesto','ITPAJD','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Impuesto','ITPAJD','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Impuesto','ITPAJD','0','REC','','','0','67800000001'),
		T_TIPO_DATA('1','03','0','Impuesto','ITPAJD','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Impuesto','ITPAJD','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Impuesto','ITPAJD','0','REC','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','63100000005'),
		T_TIPO_DATA('0','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','63100000005'),
		T_TIPO_DATA('0','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','63100000005'),
		T_TIPO_DATA('1','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','62300000003'),
		T_TIPO_DATA('1','03','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','07','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','62300000003'),
		T_TIPO_DATA('1','07','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','02','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','62300000003'),
		T_TIPO_DATA('1','02','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','62300000003'),
		T_TIPO_DATA('1','','0','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','03','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','07','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','02','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('1','','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','03','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','07','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','02','0','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','03','0','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','03','0','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','03','0','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','03','0','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','03','0','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','03','0','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','02','0','Otros gastos','Costas judiciales','0','BAS','','','0','67800000002'),
		T_TIPO_DATA('0','','0','Otros gastos','Costas judiciales','0','BAS','','','0','67800000002'),
		T_TIPO_DATA('1','02','0','Otros gastos','Costas judiciales','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','','0','Otros gastos','Costas judiciales','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','0','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','','0','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','0','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('1','','0','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','02','0','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','67800000002'),
		T_TIPO_DATA('0','','0','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','67800000002'),
		T_TIPO_DATA('1','02','0','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','','0','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','03','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','07','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','','0','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','0','Otros gastos','Otros','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','02','0','Otros gastos','Otros','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','07','0','Otros gastos','Otros','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','07','0','Otros gastos','Otros','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','0','Otros gastos','Otros','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','03','0','Otros gastos','Otros','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','BAS','K03','','0','67800000003'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','BAS','K03','','0','67800000003'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','BAS','K03','','0','67800000003'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','BAS','K04','','0','67800000004'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','BAS','K04','','0','67800000004'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','BAS','K04','','0','67800000004'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','BAS','K06','','0','67800000006'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','BAS','K06','','0','67800000006'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','BAS','K06','','0','67800000006'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','BAS','K03','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','BAS','K03','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','BAS','K03','','0','68740000009'),
		T_TIPO_DATA('0','07','0','Sanción','Multa coercitiva','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','0','Sanción','Otros','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','0','Sanción','Ruina','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','0','Sanción','Tributaria','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','0','Sanción','Urbanística','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','0','Seguros','Parte daños a terceros','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('0','','0','Seguros','Parte daños a terceros','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('1','','0','Seguros','Parte daños a terceros','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('0','02','0','Seguros','Parte daños propios','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('0','','0','Seguros','Parte daños propios','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('1','','0','Seguros','Parte daños propios','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('0','02','0','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('0','','0','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('1','02','0','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('1','','0','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('0','02','0','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('0','','0','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('1','02','0','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('1','','0','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Asesoría','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','','0','Servicios profesionales independientes','Asesoría','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','','0','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Notaría','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','','0','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','61980000000'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','6813.PROMOCION'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Otros','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Otros','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Otros','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Otros','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Otros','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Otros','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Procurador','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Registro','0','BAS','','','0','62300000002'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Registro','0','BAS','','','0','62300000002'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Registro','0','BAS','','','0','62300000002'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Registro','0','BAS','','','0','62300000002'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Registro','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Registro','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Registro','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','','0','Servicios profesionales independientes','Registro','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','07','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','02','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('1','','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','03','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','07','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','02','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','03','0','Servicios profesionales independientes','Tasación','0','BAS','','','0','62300000003'),
		T_TIPO_DATA('0','02','0','Suministro','Agua','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','02','0','Suministro','Agua','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','0','Suministro','Agua','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','','0','Suministro','Agua','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Suministro','Electricidad','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','02','0','Suministro','Electricidad','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','0','Suministro','Electricidad','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','','0','Suministro','Electricidad','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Suministro','Gas','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','02','0','Suministro','Gas','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','0','Suministro','Gas','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','','0','Suministro','Gas','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','0','Suministro','Otros','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','02','0','Suministro','Otros','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','0','Suministro','Otros','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','','0','Suministro','Otros','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','03','0','Tasa','Agua','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','0','Tasa','Agua','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','0','Tasa','Agua','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','0','Tasa','Agua','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Agua','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Agua','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Agua','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Agua','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Agua','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Agua','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Agua','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Agua','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Agua','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Agua','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Agua','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Agua','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Agua','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Agua','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Alcantarillado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','0','Tasa','Alcantarillado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','0','Tasa','Alcantarillado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','0','Tasa','Alcantarillado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Alcantarillado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Alcantarillado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Alcantarillado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Alcantarillado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Alcantarillado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Alcantarillado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Alcantarillado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Alcantarillado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Alcantarillado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Alcantarillado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Alcantarillado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Alcantarillado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Alcantarillado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Alcantarillado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Basura','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','0','Tasa','Basura','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Basura','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','02','0','Tasa','Basura','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','0','Tasa','Basura','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','03','0','Tasa','Basura','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Basura','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Basura','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Basura','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Basura','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Basura','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Basura','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Basura','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Basura','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Basura','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Basura','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Basura','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Basura','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Ecotasa','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','0','Tasa','Ecotasa','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','0','Tasa','Ecotasa','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','0','Tasa','Ecotasa','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Ecotasa','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Ecotasa','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Ecotasa','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Ecotasa','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Ecotasa','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Ecotasa','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Ecotasa','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Ecotasa','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Ecotasa','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Ecotasa','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Ecotasa','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Ecotasa','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Ecotasa','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Ecotasa','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Expedición documentos','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','0','Tasa','Expedición documentos','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','0','Tasa','Expedición documentos','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','0','Tasa','Expedición documentos','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Expedición documentos','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Expedición documentos','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Expedición documentos','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Expedición documentos','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Expedición documentos','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Expedición documentos','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Expedición documentos','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Expedición documentos','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Expedición documentos','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Expedición documentos','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Expedición documentos','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Expedición documentos','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Expedición documentos','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Expedición documentos','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Judicial','0','BAS','','','0','63100000007'),
		T_TIPO_DATA('0','02','0','Tasa','Judicial','0','BAS','','','0','63100000007'),
		T_TIPO_DATA('1','02','0','Tasa','Judicial','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Judicial','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','','0','Tasa','Judicial','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','03','0','Tasa','Judicial','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Judicial','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Judicial','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Judicial','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Judicial','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Judicial','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Judicial','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Judicial','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Judicial','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Judicial','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Judicial','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Judicial','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Judicial','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','0','Tasa','Otras tasas','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Otras tasas','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Otras tasas','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas ayuntamiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Otras tasas ayuntamiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Regularización catastral','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','0','Tasa','Regularización catastral','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','0','Tasa','Regularización catastral','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','0','Tasa','Regularización catastral','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Regularización catastral','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Regularización catastral','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Regularización catastral','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Regularización catastral','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Regularización catastral','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Regularización catastral','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Regularización catastral','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Regularización catastral','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Regularización catastral','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Regularización catastral','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Regularización catastral','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Regularización catastral','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Regularización catastral','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Regularización catastral','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Vado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','0','Tasa','Vado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','0','Tasa','Vado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','0','Tasa','Vado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Vado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Vado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Tasa','Vado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','0','Tasa','Vado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','0','Tasa','Vado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','0','Tasa','Vado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','0','Tasa','Vado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','0','Tasa','Vado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','0','Tasa','Vado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','0','Tasa','Vado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','0','Tasa','Vado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','0','Tasa','Vado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Vado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','0','Tasa','Vado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','07','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','03','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Vigilancia y seguridad','Alarmas','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','07','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','03','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','07','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','03','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','INT','K03','','0','67800000003'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','INT','K03','','0','67800000003'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','INT','K03','','0','67800000003'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','INT','K04','','0','67800000004'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','INT','K04','','0','67800000004'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','INT','K04','','0','67800000004'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','INT','K06','','0','67800000006'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','INT','K06','','0','67800000006'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','INT','K06','','0','67800000006'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','INT','K03','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','INT','K03','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','INT','K03','','0','68740000009'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','REC','K03','','0','67800000003'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','REC','K03','','0','67800000003'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','REC','K03','','0','67800000003'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','REC','K04','','0','67800000004'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','REC','K04','','0','67800000004'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','REC','K04','','0','67800000004'),
		T_TIPO_DATA('0','02','0','Otros tributos','Otros','0','REC','K06','','0','67800000006'),
		T_TIPO_DATA('0','03','0','Otros tributos','Otros','0','REC','K06','','0','67800000006'),
		T_TIPO_DATA('0','07','0','Otros tributos','Otros','0','REC','K06','','0','67800000006'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','REC','K03','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','REC','K03','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','REC','K03','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','BAS','K04','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','BAS','K04','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','BAS','K04','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','BAS','K06','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','BAS','K06','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','BAS','K06','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','INT','K04','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','INT','K04','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','INT','K04','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','INT','K06','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','INT','K06','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','INT','K06','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','REC','K04','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','REC','K04','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','REC','K04','','0','68740000009'),
		T_TIPO_DATA('1','02','0','Otros tributos','Otros','0','REC','K06','','0','68740000009'),
		T_TIPO_DATA('1','03','0','Otros tributos','Otros','0','REC','K06','','0','68740000009'),
		T_TIPO_DATA('1','07','0','Otros tributos','Otros','0','REC','K06','','0','68740000009'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Actuación post-venta','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','03','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','03','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Cambio de cerradura','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Colocación puerta antiocupa','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Limpieza','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','03','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','03','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','03','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','03','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Limpieza, desinfección… (solares)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Limpieza, retirada de enseres y descerraje','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Limpieza y retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Mobiliario','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Obra mayor. Edificación (certif. de obra)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Obra menor','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Retirada de enseres','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Seguridad y Salud (SS)','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Tapiado','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','1','62200000001'),
		T_TIPO_DATA('1','02','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','1','68740000011'),
		T_TIPO_DATA('0','07','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','07','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','','1','Actuación técnica y mantenimiento','Verificación de averías','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','','1','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('1','','1','Comunidad de propietarios','Certificado deuda comunidad','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','02','1','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','','1','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('1','','1','Comunidad de propietarios','Cuota extraordinaria (derrama)','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','02','1','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','','1','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('1','','1','Comunidad de propietarios','Cuota ordinaria','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','03','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62300000007'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62300000007'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62300000007'),
		T_TIPO_DATA('0','','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62300000007'),
		T_TIPO_DATA('1','03','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62930000003'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62930000003'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62930000003'),
		T_TIPO_DATA('1','','1','Gestoría','Honorarios gestión activos','0','BAS','','VEN_EXI','0','62930000003'),
		T_TIPO_DATA('0','','1','Gestoría','Honorarios gestión activos','0','BAS','','GES_ADM','0','62300000008'),
		T_TIPO_DATA('1','','1','Gestoría','Honorarios gestión activos','0','BAS','','GES_ADM','0','68740000019'),
		T_TIPO_DATA('0','','1','Gestoría','Honorarios gestión activos','0','BAS','','ALT','0','62300000009'),
		T_TIPO_DATA('1','','1','Gestoría','Honorarios gestión activos','0','BAS','','ALT','0','68740000019'),
		T_TIPO_DATA('0','03','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62300000010'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62300000010'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62300000010'),
		T_TIPO_DATA('0','','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62300000010'),
		T_TIPO_DATA('1','03','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62930000002'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62930000002'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62930000002'),
		T_TIPO_DATA('1','','1','Gestoría','Honorarios gestión activos','0','BAS','','ALQ','0','62930000002'),
		T_TIPO_DATA('0','03','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','62300000000'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','62300000000'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','62300000000'),
		T_TIPO_DATA('1','03','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','68740000008'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','68740000008'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','68740000008'),
		T_TIPO_DATA('0','','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','62300000000'),
		T_TIPO_DATA('1','','1','Gestoría','Honorarios gestión activos','0','BAS','','GES','0','68740000008'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','62300000011'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','62300000011'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','62930000001'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión activos','0','BAS','','DES_ACT','0','62930000001'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('0','03','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','03','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión ventas','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('0','03','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('0','07','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('0','02','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','03','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('1','07','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('1','02','1','Gestoría','Honorarios gestión activos','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI rústica','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI rústica','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI rústica','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI rústica','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI rústica','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI rústica','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI rústica','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI rústica','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI rústica','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI rústica','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI rústica','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI rústica','0','INT','','','0','68740000002'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI rústica','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI rústica','0','INT','','','0','68740000002'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI rústica','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI rústica','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI rústica','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI rústica','0','INT','','','0','68740000002'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI urbana','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI urbana','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI urbana','0','BAS','','','0','63100000004'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI urbana','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI urbana','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI urbana','0','BAS','','','0','68740000002'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI urbana','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Impuesto','IBI urbana','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI urbana','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Impuesto','IBI urbana','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI urbana','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','03','1','Impuesto','IBI urbana','0','INT','','','0','68740000002'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI urbana','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','07','1','Impuesto','IBI urbana','0','INT','','','0','68740000002'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI urbana','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Impuesto','IBI urbana','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI urbana','0','REC','','','0','68740000002'),
		T_TIPO_DATA('1','02','1','Impuesto','IBI urbana','0','INT','','','0','68740000002'),
		T_TIPO_DATA('0','02','1','Impuesto','ITPAJD','1','BAS','','','0','63100000002'),
		T_TIPO_DATA('0','03','1','Impuesto','ITPAJD','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Impuesto','ITPAJD','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Impuesto','ITPAJD','0','REC','','','0','67800000001'),
		T_TIPO_DATA('1','03','1','Impuesto','ITPAJD','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Impuesto','ITPAJD','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Impuesto','ITPAJD','0','REC','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','63100000005'),
		T_TIPO_DATA('0','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','63100000005'),
		T_TIPO_DATA('0','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','63100000005'),
		T_TIPO_DATA('1','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Impuesto','Plusvalía (IIVTNU) venta','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','62300000003'),
		T_TIPO_DATA('1','03','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','07','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','62300000003'),
		T_TIPO_DATA('1','07','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','02','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','62300000003'),
		T_TIPO_DATA('1','02','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','62300000003'),
		T_TIPO_DATA('1','','1','Informes técnicos y obtención documentos','Certif. eficiencia energética (CEE)','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','03','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','07','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','02','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('1','','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','03','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','07','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','02','1','Informes técnicos y obtención documentos','Informes','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','03','1','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','03','1','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','03','1','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Junta de compensación / EUC','Cuotas y derramas','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','03','1','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','03','1','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','03','1','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Junta de compensación / EUC','Gastos generales','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','02','1','Otros gastos','Costas judiciales','0','BAS','','','0','67800000002'),
		T_TIPO_DATA('0','','1','Otros gastos','Costas judiciales','0','BAS','','','0','67800000002'),
		T_TIPO_DATA('1','02','1','Otros gastos','Costas judiciales','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','','1','Otros gastos','Costas judiciales','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','1','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('0','','1','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','62200000000'),
		T_TIPO_DATA('1','02','1','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('1','','1','Otros gastos','Costas judiciales (demanda comunidad propietarios)','0','BAS','','','0','68800000001'),
		T_TIPO_DATA('0','02','1','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','67800000002'),
		T_TIPO_DATA('0','','1','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','67800000002'),
		T_TIPO_DATA('1','02','1','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','','1','Otros gastos','Costas judiciales (otras demandas)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','03','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','07','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','','1','Otros gastos','Mensajería/correos/copias','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','1','Otros gastos','Otros','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','02','1','Otros gastos','Otros','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','07','1','Otros gastos','Otros','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','07','1','Otros gastos','Otros','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','1','Otros gastos','Otros','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','03','1','Otros gastos','Otros','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','BAS','K03','','0','67800000003'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','BAS','K03','','0','67800000003'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','BAS','K03','','0','67800000003'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','BAS','K04','','0','67800000004'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','BAS','K04','','0','67800000004'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','BAS','K04','','0','67800000004'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','BAS','K06','','0','67800000006'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','BAS','K06','','0','67800000006'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','BAS','K06','','0','67800000006'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','BAS','K03','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','BAS','K03','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','BAS','K03','','0','68740000009'),
		T_TIPO_DATA('0','07','1','Sanción','Multa coercitiva','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','1','Sanción','Otros','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','1','Sanción','Ruina','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','1','Sanción','Tributaria','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','1','Sanción','Urbanística','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','1','Seguros','Parte daños a terceros','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('0','','1','Seguros','Parte daños a terceros','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('1','','1','Seguros','Parte daños a terceros','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('0','02','1','Seguros','Parte daños propios','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('0','','1','Seguros','Parte daños propios','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('1','','1','Seguros','Parte daños propios','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('0','02','1','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('0','','1','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('1','02','1','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('1','','1','Seguros','Prima RC (responsabilidad civil)','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('0','02','1','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('0','','1','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','62500000000'),
		T_TIPO_DATA('1','02','1','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('1','','1','Seguros','Prima TRDM (todo riesgo daño material)','0','BAS','','','0','68740000006'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Abogado (Asistencia jurídica)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Abogado (Asuntos generales)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Abogado (Ocupacional)','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Asesoría','0','BAS','','','0','62300000000'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Asesoría','0','BAS','','','0','68740000008'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Gestión de suelo','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','62300000001'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Notaría','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Notaría','0','BAS','','','0',''),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Otros','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Otros','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Otros','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','68740000010'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Otros','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Otros','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Otros','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Otros servicios jurídicos','0','BAS','','','0','62300000013'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','62300000005'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Procurador','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Registro','0','BAS','','','0','62300000002'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Registro','0','BAS','','','0','62300000002'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Registro','0','BAS','','','0','62300000002'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Registro','0','BAS','','','0','62300000002'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Registro','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Registro','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Registro','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Registro','0','BAS','','','0','68740000004'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','07','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','02','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('0','','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','62300000004'),
		T_TIPO_DATA('1','','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','03','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','07','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('1','02','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','68740000005'),
		T_TIPO_DATA('0','03','1','Servicios profesionales independientes','Tasación','0','BAS','','','0','62300000003'),
		T_TIPO_DATA('0','02','1','Suministro','Agua','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','02','1','Suministro','Agua','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','1','Suministro','Agua','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','','1','Suministro','Agua','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Suministro','Electricidad','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','02','1','Suministro','Electricidad','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','1','Suministro','Electricidad','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','','1','Suministro','Electricidad','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Suministro','Gas','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','02','1','Suministro','Gas','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','1','Suministro','Gas','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','','1','Suministro','Gas','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','02','1','Suministro','Otros','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','02','1','Suministro','Otros','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','','1','Suministro','Otros','0','BAS','','','0','62800000000'),
		T_TIPO_DATA('1','','1','Suministro','Otros','0','BAS','','','0','68740000007'),
		T_TIPO_DATA('0','03','1','Tasa','Agua','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','1','Tasa','Agua','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','1','Tasa','Agua','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','1','Tasa','Agua','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Agua','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Agua','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Agua','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Agua','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Agua','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Agua','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Agua','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Agua','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Agua','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Agua','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Agua','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Agua','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Agua','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Agua','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Alcantarillado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','1','Tasa','Alcantarillado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','1','Tasa','Alcantarillado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','1','Tasa','Alcantarillado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Alcantarillado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Alcantarillado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Alcantarillado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Alcantarillado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Alcantarillado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Alcantarillado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Alcantarillado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Alcantarillado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Alcantarillado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Alcantarillado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Alcantarillado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Alcantarillado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Alcantarillado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Alcantarillado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Basura','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','1','Tasa','Basura','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Basura','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','02','1','Tasa','Basura','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','1','Tasa','Basura','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','03','1','Tasa','Basura','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Basura','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Basura','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Basura','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Basura','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Basura','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Basura','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Basura','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Basura','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Basura','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Basura','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Basura','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Basura','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Ecotasa','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','1','Tasa','Ecotasa','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','1','Tasa','Ecotasa','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','1','Tasa','Ecotasa','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Ecotasa','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Ecotasa','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Ecotasa','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Ecotasa','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Ecotasa','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Ecotasa','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Ecotasa','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Ecotasa','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Ecotasa','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Ecotasa','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Ecotasa','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Ecotasa','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Ecotasa','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Ecotasa','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Expedición documentos','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','1','Tasa','Expedición documentos','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','1','Tasa','Expedición documentos','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','1','Tasa','Expedición documentos','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Expedición documentos','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Expedición documentos','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Expedición documentos','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Expedición documentos','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Expedición documentos','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Expedición documentos','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Expedición documentos','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Expedición documentos','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Expedición documentos','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Expedición documentos','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Expedición documentos','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Expedición documentos','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Expedición documentos','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Expedición documentos','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Judicial','0','BAS','','','0','63100000007'),
		T_TIPO_DATA('0','02','1','Tasa','Judicial','0','BAS','','','0','63100000007'),
		T_TIPO_DATA('1','02','1','Tasa','Judicial','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Judicial','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','','1','Tasa','Judicial','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','03','1','Tasa','Judicial','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Judicial','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Judicial','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Judicial','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Judicial','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Judicial','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Judicial','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Judicial','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Judicial','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Judicial','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Judicial','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Judicial','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Judicial','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Obras / Rehabilitación / Mantenimiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','1','Tasa','Otras tasas','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Otras tasas','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Otras tasas','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas ayuntamiento','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas ayuntamiento','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Otras tasas ayuntamiento','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Regularización catastral','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','1','Tasa','Regularización catastral','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','1','Tasa','Regularización catastral','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','1','Tasa','Regularización catastral','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Regularización catastral','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Regularización catastral','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Regularización catastral','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Regularización catastral','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Regularización catastral','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Regularización catastral','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Regularización catastral','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Regularización catastral','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Regularización catastral','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Regularización catastral','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Regularización catastral','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Regularización catastral','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Regularización catastral','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Regularización catastral','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Vado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','07','1','Tasa','Vado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('0','','1','Tasa','Vado','0','BAS','','','0','63100000003'),
		T_TIPO_DATA('1','07','1','Tasa','Vado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Vado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Vado','0','BAS','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Tasa','Vado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','03','1','Tasa','Vado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','03','1','Tasa','Vado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','03','1','Tasa','Vado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','07','1','Tasa','Vado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','07','1','Tasa','Vado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('0','02','1','Tasa','Vado','0','REC','','','0','67800000001'),
		T_TIPO_DATA('0','02','1','Tasa','Vado','0','INT','','','0','66990000000'),
		T_TIPO_DATA('1','02','1','Tasa','Vado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','02','1','Tasa','Vado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Vado','0','REC','','','0','68740000003'),
		T_TIPO_DATA('1','07','1','Tasa','Vado','0','INT','','','0','68740000003'),
		T_TIPO_DATA('0','03','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','07','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','03','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Vigilancia y seguridad','Alarmas','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','07','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','03','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Vigilancia y seguridad','Servicios auxiliares','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','03','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','07','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('0','02','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','62900000000'),
		T_TIPO_DATA('1','03','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Vigilancia y seguridad','Vigilancia y seguridad','0','BAS','','','0','68740000009'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','INT','K03','','0','67800000003'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','INT','K03','','0','67800000003'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','INT','K03','','0','67800000003'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','INT','K04','','0','67800000004'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','INT','K04','','0','67800000004'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','INT','K04','','0','67800000004'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','INT','K06','','0','67800000006'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','INT','K06','','0','67800000006'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','INT','K06','','0','67800000006'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','INT','K03','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','INT','K03','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','INT','K03','','0','68740000009'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','REC','K03','','0','67800000003'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','REC','K03','','0','67800000003'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','REC','K03','','0','67800000003'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','REC','K04','','0','67800000004'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','REC','K04','','0','67800000004'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','REC','K04','','0','67800000004'),
		T_TIPO_DATA('0','02','1','Otros tributos','Otros','0','REC','K06','','0','67800000006'),
		T_TIPO_DATA('0','03','1','Otros tributos','Otros','0','REC','K06','','0','67800000006'),
		T_TIPO_DATA('0','07','1','Otros tributos','Otros','0','REC','K06','','0','67800000006'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','REC','K03','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','REC','K03','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','REC','K03','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','BAS','K04','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','BAS','K04','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','BAS','K04','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','BAS','K06','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','BAS','K06','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','BAS','K06','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','INT','K04','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','INT','K04','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','INT','K04','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','INT','K06','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','INT','K06','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','INT','K06','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','REC','K04','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','REC','K04','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','REC','K04','','0','68740000009'),
		T_TIPO_DATA('1','02','1','Otros tributos','Otros','0','REC','K06','','0','68740000009'),
		T_TIPO_DATA('1','03','1','Otros tributos','Otros','0','REC','K06','','0','68740000009'),
		T_TIPO_DATA('1','07','1','Otros tributos','Otros','0','REC','K06','','0','68740000009')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    --DESACTIVAMOS CLAVES ANTES DE EMPEZAR PARA MEJORAR EL DESEMPEÑO
    FOR CLAVES IN CONSTRAINTS_ENABLED 
      LOOP

        V_CONSTRAINT_NAME := CLAVES.CONSTRAINT_NAME; 

        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
          DISABLE CONSTRAINT '||V_CONSTRAINT_NAME;
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Desactivada la clave '||V_CONSTRAINT_NAME);

      END LOOP;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Vaciamos tabla temporal... ');
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
--T_TIPO_DATA('BANCO'1,'BDE'2,'VENDIDO'3,'TIPO DE GASTO'4,'SUBTIPO DE GASTO'5,'ACTIVABLE'6,'TIPO_IMPORTE'7,'TRIBUTOS TERCEROS'8,'COMISIONAMIENTO'9,'PLAN VISITAS'10,'CUENTA'11)
                IF TRIM(V_TMP_TIPO_DATA(1)) = 0 THEN
                    V_PROPIETARIO := '''A15011489'', ''A78485752'', ''A86486461'', ''B84921758'', ''999999999999999'', ''B39690516'', ''B10488328'', ''B88385117'', ''7758258''';
                ELSE
                    V_PROPIETARIO := '''A86201993''';
                END IF;
                
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' (
							CCC_CTAS_ID
							, CCC_CUENTA_CONTABLE
							, DD_TGA_ID
							, DD_STG_ID
							, DD_CRA_ID
							, PRO_ID
							, EJE_ID
							, FECHACREAR
							, DD_TBE_ID
							, CCC_ACTIVABLE
							, CCC_PLAN_VISITAS
							, DD_TCH_ID
							, DD_TIM_ID
							, DD_TRT_ID
							, CCC_VENDIDO
							) 
							SELECT 
								'||I||'
								, '''||TRIM(V_TMP_TIPO_DATA(11))||''' CCC_CUENTA_CONTABLE
								, TGA.DD_TGA_ID
								, STG.DD_STG_ID
								, CRA.DD_CRA_ID
								, PRO.PRO_ID
								, EJE.EJE_ID
								, SYSDATE FECHACREAR
								, TBE.DD_TBE_ID
								, '||TRIM(V_TMP_TIPO_DATA(6))||' CCC_ACTIVABLE
								, '||TRIM(V_TMP_TIPO_DATA(10))||' CCC_PLAN_VISITAS
								, TCH.DD_TCH_ID
								, TIM.DD_TIM_ID
								, TRT.DD_TRT_ID
								, '||TRIM(V_TMP_TIPO_DATA(3))||' CCC_VENDIDO
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

    DBMS_OUTPUT.PUT_LINE('[INFO]: Preparamos cuentas para tabla de negocio.');

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
		SET CCC_CTAS_ID = ROWNUM';
	EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' T1
      USING (
          SELECT CCC_CTAS_ID
              , ROW_NUMBER() OVER(
                  PARTITION BY DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID
                      , PRO_ID, EJE_ID, CCC_ARRENDAMIENTO, CCC_REFACTURABLE, DD_TBE_ID
                      , CCC_ACTIVABLE, CCC_PLAN_VISITAS, DD_TCH_ID, DD_TRT_ID
                      , CCC_VENDIDO
                  ORDER BY CCC_CTAS_ID
              ) RN
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      ) T2
      ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
      WHEN MATCHED THEN 
          UPDATE SET T1.CCC_PRINCIPAL = CASE WHEN T2.RN = 1 THEN 1 ELSE 0 END';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      SET DD_TIM_ID = (SELECT DD_TIM_ID FROM DD_TIM_TIPO_IMPORTE WHERE DD_TIM_CODIGO = ''BAS'')
      WHERE DD_TIM_ID IS NULL';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' T1
      USING (
          SELECT CCC_CTAS_ID
              , ROW_NUMBER() OVER(
                  PARTITION BY DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID
                      , PRO_ID, EJE_ID, CCC_ARRENDAMIENTO, CCC_REFACTURABLE, DD_TBE_ID
                      , CCC_ACTIVABLE, CCC_PLAN_VISITAS, DD_TCH_ID, DD_TRT_ID
                      , CCC_VENDIDO
                  ORDER BY CCC_CTAS_ID
              ) RN
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
          WHERE CCC_PRINCIPAL = 0
      ) T2
      ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID AND T2.RN > 1)
      WHEN MATCHED THEN
          UPDATE SET T1.BORRADO = 1';
    EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
		WHERE DD_STG_ID IS NULL
			OR CCC_CUENTA_CONTABLE IS NULL';
	EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: Cuentas preparadas.');
	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
          CCC_CTAS_ID
          , CCC_CUENTA_CONTABLE
          , DD_TGA_ID
          , DD_STG_ID
          , DD_TIM_ID
          , DD_CRA_ID
          , DD_SCR_ID
          , PRO_ID
          , EJE_ID
          , CCC_ARRENDAMIENTO
          , CCC_REFACTURABLE
          , USUARIOCREAR
          , FECHACREAR
          , DD_TBE_ID
          , CCC_SUBCUENTA_CONTABLE
          , CCC_ACTIVABLE
          , CCC_PLAN_VISITAS
          , DD_TCH_ID
          , CCC_PRINCIPAL
          , DD_TRT_ID
          , CCC_VENDIDO
      )
      SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
          , CCC.CCC_CUENTA_CONTABLE
          , CCC.DD_TGA_ID
          , CCC.DD_STG_ID
          , CCC.DD_TIM_ID
          , CCC.DD_CRA_ID
          , CCC.DD_SCR_ID
          , CCC.PRO_ID
          , CCC.EJE_ID
          , CCC.CCC_ARRENDAMIENTO
          , CCC.CCC_REFACTURABLE
          , '''||V_ITEM||'''
          , SYSDATE
          , CCC.DD_TBE_ID
          , CCC.CCC_SUBCUENTA_CONTABLE
          , CCC.CCC_ACTIVABLE
          , CCC.CCC_PLAN_VISITAS
          , CCC.DD_TCH_ID
          , CCC.CCC_PRINCIPAL
          , CCC.DD_TRT_ID
          , CCC.CCC_VENDIDO
      FROM (
          SELECT TMP.CCC_CUENTA_CONTABLE
              , TMP.DD_TGA_ID
              , TMP.DD_STG_ID
              , TMP.DD_TIM_ID
              , TMP.DD_CRA_ID
              , SCR.DD_SCR_ID
              , TMP.PRO_ID
              , TMP.EJE_ID
              , ARR.NUMERO CCC_ARRENDAMIENTO
              , 0 CCC_REFACTURABLE
              , TMP.DD_TBE_ID
              , TMP.CCC_SUBCUENTA_CONTABLE
              , TMP.CCC_ACTIVABLE
              , TMP.CCC_PLAN_VISITAS
              , TMP.DD_TCH_ID
              , TMP.CCC_PRINCIPAL
              , TMP.DD_TRT_ID
              , TMP.CCC_VENDIDO
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' TMP
          JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = TMP.DD_CRA_ID
          	  AND SCR.BORRADO = 0
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO ARR ON 1 = 1
          WHERE NVL(TMP.BORRADO, 0) = 0
      ) CCC
      WHERE NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX
              WHERE AUX.DD_TGA_ID = CCC.DD_TGA_ID
                  AND AUX.DD_STG_ID = CCC.DD_STG_ID
                  AND AUX.DD_TIM_ID = CCC.DD_TIM_ID
                  AND AUX.DD_CRA_ID = CCC.DD_CRA_ID
                  AND NVL(AUX.DD_SCR_ID, 0) = NVL(CCC.DD_SCR_ID, NVL(AUX.DD_SCR_ID, 0))
                  AND AUX.PRO_ID = CCC.PRO_ID
                  AND AUX.EJE_ID = CCC.EJE_ID
                  AND NVL(AUX.CCC_ARRENDAMIENTO, 0) = NVL(CCC.CCC_ARRENDAMIENTO, NVL(AUX.CCC_ARRENDAMIENTO, 0))
                  AND AUX.CCC_REFACTURABLE = CCC.CCC_REFACTURABLE
                  AND NVL(AUX.DD_TBE_ID, 0) = NVL(CCC.DD_TBE_ID, 0)
                  AND AUX.CCC_ACTIVABLE = CCC.CCC_ACTIVABLE
                  AND AUX.CCC_PLAN_VISITAS = CCC.CCC_PLAN_VISITAS
                  AND NVL(AUX.DD_TCH_ID, 0) = NVL(CCC.DD_TCH_ID, 0)
                  AND AUX.CCC_PRINCIPAL = CCC.CCC_PRINCIPAL
                  AND NVL(AUX.DD_TRT_ID, 0) = NVL(CCC.DD_TRT_ID, 0)
                  AND NVL(AUX.CCC_VENDIDO, 0) = NVL(CCC.CCC_VENDIDO, NVL(AUX.CCC_VENDIDO, 0))
                  AND AUX.BORRADO = 0
          )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' cuentas sin subcartera inicial insertadas');

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
          CCC_CTAS_ID
          , CCC_CUENTA_CONTABLE
          , DD_TGA_ID
          , DD_STG_ID
          , DD_TIM_ID
          , DD_CRA_ID
          , DD_SCR_ID
          , PRO_ID
          , EJE_ID
          , CCC_ARRENDAMIENTO
          , CCC_REFACTURABLE
          , USUARIOCREAR
          , FECHACREAR
          , DD_TBE_ID
          , CCC_SUBCUENTA_CONTABLE
          , CCC_ACTIVABLE
          , CCC_PLAN_VISITAS
          , DD_TCH_ID
          , CCC_PRINCIPAL
          , DD_TRT_ID
          , CCC_VENDIDO
      )
      SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
          , CCC.CCC_CUENTA_CONTABLE
          , CCC.DD_TGA_ID
          , CCC.DD_STG_ID
          , CCC.DD_TIM_ID
          , CCC.DD_CRA_ID
          , CCC.DD_SCR_ID
          , CCC.PRO_ID
          , CCC.EJE_ID
          , CCC.CCC_ARRENDAMIENTO
          , CCC.CCC_REFACTURABLE
          , '''||V_ITEM||'''
          , SYSDATE
          , CCC.DD_TBE_ID
          , CCC.CCC_SUBCUENTA_CONTABLE
          , CCC.CCC_ACTIVABLE
          , CCC.CCC_PLAN_VISITAS
          , CCC.DD_TCH_ID
          , CCC.CCC_PRINCIPAL
          , CCC.DD_TRT_ID
          , CCC.CCC_VENDIDO
      FROM (
          SELECT TMP.CCC_CUENTA_CONTABLE
              , TMP.DD_TGA_ID
              , TMP.DD_STG_ID
              , TMP.DD_TIM_ID
              , TMP.DD_CRA_ID
              , NULL DD_SCR_ID
              , TMP.PRO_ID
              , TMP.EJE_ID
              , NULL CCC_ARRENDAMIENTO
              , 0 CCC_REFACTURABLE
              , TMP.DD_TBE_ID
              , TMP.CCC_SUBCUENTA_CONTABLE
              , TMP.CCC_ACTIVABLE
              , TMP.CCC_PLAN_VISITAS
              , TMP.DD_TCH_ID
              , TMP.CCC_PRINCIPAL
              , TMP.DD_TRT_ID
              , TMP.CCC_VENDIDO
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' TMP
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO ARR ON 1 = 1
          WHERE NVL(TMP.BORRADO, 0) = 0
          		AND TMP.DD_TBE_ID IS NULL
      ) CCC
      WHERE NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX
              WHERE AUX.DD_TGA_ID = CCC.DD_TGA_ID
                  AND AUX.DD_STG_ID = CCC.DD_STG_ID
                  AND AUX.DD_TIM_ID = CCC.DD_TIM_ID
                  AND AUX.DD_CRA_ID = CCC.DD_CRA_ID
                  AND NVL(AUX.DD_SCR_ID, 0) = NVL(CCC.DD_SCR_ID, NVL(AUX.DD_SCR_ID, 0))
                  AND AUX.PRO_ID = CCC.PRO_ID
                  AND AUX.EJE_ID = CCC.EJE_ID
                  AND NVL(AUX.CCC_ARRENDAMIENTO, 0) = NVL(CCC.CCC_ARRENDAMIENTO, NVL(AUX.CCC_ARRENDAMIENTO, 0))
                  AND AUX.CCC_REFACTURABLE = CCC.CCC_REFACTURABLE
                  AND NVL(AUX.DD_TBE_ID, 0) = NVL(CCC.DD_TBE_ID, 0)
                  AND AUX.CCC_ACTIVABLE = CCC.CCC_ACTIVABLE
                  AND AUX.CCC_PLAN_VISITAS = CCC.CCC_PLAN_VISITAS
                  AND NVL(AUX.DD_TCH_ID, 0) = NVL(CCC.DD_TCH_ID, 0)
                  AND AUX.CCC_PRINCIPAL = CCC.CCC_PRINCIPAL
                  AND NVL(AUX.DD_TRT_ID, 0) = NVL(CCC.DD_TRT_ID, 0)
                  AND NVL(AUX.CCC_VENDIDO, 0) = NVL(CCC.CCC_VENDIDO, NVL(AUX.CCC_VENDIDO, 0))
                  AND AUX.BORRADO = 0
          )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' cuentas sin subcartera final insertadas');

    COMMIT; 

    --ACTIVAMOS CLAVES ANTES DE EMPEZAR PARA MEJORAR EL DESEMPEÑO
    FOR CLAVES IN CONSTRAINTS_DISABLED 
      LOOP

        V_CONSTRAINT_NAME := CLAVES.CONSTRAINT_NAME; 

        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
          ENABLE CONSTRAINT '||V_CONSTRAINT_NAME;
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Activada la clave '||V_CONSTRAINT_NAME);

      END LOOP;

    DBMS_OUTPUT.PUT_LINE('[FIN]'); 

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_MSQL); 
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
