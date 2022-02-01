--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10962
--## PRODUCTO=NO
--## 
--## Finalidad: INSERTAMOS SUBTIPO GASTO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
	V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
 	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
 	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10962'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	V_TGA_ID NUMBER(16); 
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
T_TIPO_DATA('118','IBI Refacturaciones Urbana','01'),
T_TIPO_DATA('119','IBI Refacturaciones Rústico','01'),
T_TIPO_DATA('120','Obra mayor. Edificación (certif. de obra)','02'),
T_TIPO_DATA('121','QUEBRANTOS EXTRAORDINARIOS','02'),
T_TIPO_DATA('122','Agua Refacturación','02'),
T_TIPO_DATA('123','Alcantarillado Refacturación','02'),
T_TIPO_DATA('124','Vado Refacturación','02'),
T_TIPO_DATA('125','Basura Refacturación','02'),
T_TIPO_DATA('126','Expedición de documentos Refacturación','02'),
T_TIPO_DATA('127','Ecotasa Refacturación','02'),
T_TIPO_DATA('128','Obra mayor. Edificación (certif. de obra) Refacturación','02'),
T_TIPO_DATA('129','Otras tasas Refacturación','02'),
T_TIPO_DATA('130','QUEBRANTOS EXTRAORDINARIOS Refacturación','02'),
T_TIPO_DATA('131','Regularizaciones','05'),
T_TIPO_DATA('132','CCPP Suministros','05'),
T_TIPO_DATA('133','Otros CCPP','05'),
T_TIPO_DATA('134','Refacturaciones','05'),
T_TIPO_DATA('135','EMS Toma de posesión','15'),
T_TIPO_DATA('136','EMS Mantenimiento','15'),
T_TIPO_DATA('137','EMS Limpieza','15'),
T_TIPO_DATA('138','RAM Reparaciones','15'),
T_TIPO_DATA('139','RAM Obra activos vacíos','15'),
T_TIPO_DATA('140','RAM Pack entre contratos','15'),
T_TIPO_DATA('141','RAM Limpieza','15'),
T_TIPO_DATA('142','Teléfono','09'),
T_TIPO_DATA('143','Refacturación','09'),
T_TIPO_DATA('144','Alarmas Instalación','16'),
T_TIPO_DATA('145','Alarmas Mantenimiento','16'),
T_TIPO_DATA('146','Vigilancia','16'),
T_TIPO_DATA('147','Colocación puerta antiocupa','16'),
T_TIPO_DATA('148','Acudas','16'),
T_TIPO_DATA('149','CRA','16'),
T_TIPO_DATA('150','Alquiler PAO','16'),
T_TIPO_DATA('151','Alquiler alarmas','16'),
T_TIPO_DATA('152','Mantenimiento seguridad','16'),
T_TIPO_DATA('153','Judicial Refacturación','02'),
T_TIPO_DATA('154','Burofax Administración','20'),
T_TIPO_DATA('155','Póliza Daños Materiales','04'),
T_TIPO_DATA('156','Responsabilidad Civil','04')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG
        JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID=STG.DD_TGA_ID
        
        WHERE STG.DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND TGA.DD_TGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''  AND STG.BORRADO = 0
        AND TGA.BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 0 THEN

			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

            IF V_COUNT = 1 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAMOS NUEVO SUBTIPO GASTO');

			V_MSQL := 'SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_TGA_ID;

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO (DD_STG_ID,DD_TGA_ID,DD_STG_CODIGO,DD_STG_DESCRIPCION,
							DD_STG_DESCRIPCION_LARGA,USUARIOCREAR,FECHACREAR) VALUES 
							( '||V_ESQUEMA||'.S_DD_STG_SUBTIPOS_GASTO.NEXTVAL, '||V_TGA_ID||', '''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''',
							'''||V_USUARIO||''',SYSDATE)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN DD_STG_SUBTIPOS_GASTO');

            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL TIPO DE GASTO INDICADO '''||TRIM(V_TMP_TIPO_DATA(1))||''' - '''||TRIM(V_TMP_TIPO_DATA(2))||'''- '''||TRIM(V_TMP_TIPO_DATA(3))||''' ');
            END IF;

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE SUBTIPO GASTO CON CODIGO '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

		END IF;

	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	
	EXCEPTION
	
	    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		ROLLBACK;
		RAISE;
END;
/
EXIT;
