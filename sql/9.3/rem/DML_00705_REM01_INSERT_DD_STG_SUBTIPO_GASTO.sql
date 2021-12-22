--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16682
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
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16682'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	V_TGA_ID NUMBER(16); 
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--DD_STG_CODIGO  --DESCRIPCION  --DD_TGA_CODIGO
      T_TIPO_DATA('152','Monitorio','05'),
      T_TIPO_DATA('153','Derribos','15'),
      T_TIPO_DATA('118','Requerimientos Derribos','15'),
      T_TIPO_DATA('119','Requerimientos Limpiezas','15'),
      T_TIPO_DATA('120','Requerimientos Otros','15'),
      T_TIPO_DATA('121','ComisiónTarifa Plana','13'),
      T_TIPO_DATA('122','Comisión broker','10'),
      T_TIPO_DATA('123','Colocación puerta antiocupa - 1ª Posesión','15'),
      T_TIPO_DATA('124','Alarmas - Primera Posesión','16'),
      T_TIPO_DATA('125','Duplicado Cédula Habitabilidad','14'),
      T_TIPO_DATA('126','Informes localizar arrendatario inmueble','14'),
      T_TIPO_DATA('127','Informes Ocupacionales Morosidad +  Inf. 24h AL','14'),
      T_TIPO_DATA('128','Informes Reocupados','14'),
      T_TIPO_DATA('129','Legal - Procedimientos fiscales','11'),
      T_TIPO_DATA('130','Abogado (Ley Vivienda)','11'),
      T_TIPO_DATA('131','Legal - Procedimientos desahucios','11'),
      T_TIPO_DATA('132','Deshaucios','02'),
      T_TIPO_DATA('133','Legal - Procedimientos reocupados','11'),
      T_TIPO_DATA('134','Reocupados','02'),
      T_TIPO_DATA('135','Comisión alta nuevos alquileres','13'),
      T_TIPO_DATA('136','Feria','17'),
      T_TIPO_DATA('137','Comisión gestión ventas','13'),
      T_TIPO_DATA('138','Comisión gestión ventas','12'),
      T_TIPO_DATA('139','Campañas','17'),
      T_TIPO_DATA('140','Cuota devengo anterior título','05'),
      T_TIPO_DATA('141','IBI devengo anterior título','01'),
      T_TIPO_DATA('142','Adecuaciones para el cumplimiento de habitabilidad según normativa','15'),
      T_TIPO_DATA('143','Acometidas','15'),
      T_TIPO_DATA('144','Rehabilitaciones','15'),
      T_TIPO_DATA('145','Comisión Gestión stock Prorrata 0%','13'),
      T_TIPO_DATA('146','Comisión Gestión stock Prorrata 100%','13'),
      T_TIPO_DATA('147','Comisión Gestión Gestorías Prorrata 0%','13'),
      T_TIPO_DATA('148','Comisión Gestión Gestorías Prorrata 100%','13'),
      T_TIPO_DATA('149','Comisión Gestión Gestorías Cuota Fijo','13'),
      T_TIPO_DATA('150','Tarifa plana Prorrata 0%','13'),
      T_TIPO_DATA('151','Tarifa plana Prorrata 100%','13'),
      T_TIPO_DATA('158','Humedades','15'),
      T_TIPO_DATA('159','Acompañamiento','15'),
      T_TIPO_DATA('160','Acompañamiento','11'),
      T_TIPO_DATA('157','Duplicado Certif. eficiencia energética (CEE)','14')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 0 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAMOS NUEVO SUBTIPO GASTO');

			V_MSQL := 'SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_TGA_ID;

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO (
							 DD_STG_ID
							,DD_TGA_ID
							,DD_STG_CODIGO
							,DD_STG_DESCRIPCION
							,DD_STG_DESCRIPCION_LARGA
							,USUARIOCREAR
							,FECHACREAR
						) VALUES ( 
							'||V_ESQUEMA||'.S_DD_STG_SUBTIPOS_GASTO.NEXTVAL
							, '||V_TGA_ID||'
							, '''||TRIM(V_TMP_TIPO_DATA(1))||'''
							, '''||TRIM(V_TMP_TIPO_DATA(2))||'''
							, '''||TRIM(V_TMP_TIPO_DATA(2))||'''
							, '''||V_USUARIO||'''
							,SYSDATE)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS EL REGISTRO '||TRIM(V_TMP_TIPO_DATA(1))||' EN DD_STG_SUBTIPOS_GASTO');

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