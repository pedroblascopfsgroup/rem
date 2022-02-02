--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17018
--## PRODUCTO=NO
--## 
--## Finalidad: INSERTAMOS SUBTIPO GASTO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-16682] - Alejandra García
--##        0.2 Cambio de cógidos porque se pisaban las descripciones debido al HREOS-16512 - [HREOS-16953] - Alejandra García
--##        0.3 Añadir subtipos de promociones y cambiar todos los códigos de los subtipos nuevos del PEP - [HREOS-17018] - Alejandra García
--##        0.3 Añadir update - [HREOS-17087] - Alejandra García
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
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-17018'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	V_TGA_ID NUMBER(16); 
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--DD_STG_CODIGO  --DESCRIPCION  --DD_TGA_CODIGO
      T_TIPO_DATA('157','Informes localizar arrendatario inmueble','14'),
      T_TIPO_DATA('158','Informes Ocupacionales Morosidad +  Inf. 24h AL','14'),
      T_TIPO_DATA('159','Informes Reocupados','14'),
      T_TIPO_DATA('160','Legal - Procedimientos fiscales','11'),
      T_TIPO_DATA('161','Abogado (Ley Vivienda)','11'),
      T_TIPO_DATA('162','Legal - Procedimientos desahucios','11'),
      T_TIPO_DATA('163','Deshaucios','02'),
      T_TIPO_DATA('164','Legal - Procedimientos reocupados','11'),
      T_TIPO_DATA('165','Reocupados','02'),
      T_TIPO_DATA('166','Comisión alta nuevos alquileres','13'),
      T_TIPO_DATA('167','Feria','17'),
      T_TIPO_DATA('168','Comisión gestión ventas','13'),
      T_TIPO_DATA('169','Comisión gestión ventas','12'),
      T_TIPO_DATA('170','Campañas','17'),
      T_TIPO_DATA('171','Cuota devengo anterior título','05'),
      T_TIPO_DATA('172','IBI devengo anterior título','01'),
      T_TIPO_DATA('173','Adecuaciones para el cumplimiento de habitabilidad según normativa','15'),
      T_TIPO_DATA('174','Acometidas','15'),
      T_TIPO_DATA('175','Rehabilitaciones','15'),
      T_TIPO_DATA('176','Comisión Gestión stock Prorrata 0%','13'),
      T_TIPO_DATA('177','Comisión Gestión stock Prorrata 100%','13'),
      T_TIPO_DATA('178','Comisión Gestión Gestorías Prorrata 0%','13'),
      T_TIPO_DATA('179','Comisión Gestión Gestorías Prorrata 100%','13'),
      T_TIPO_DATA('180','Comisión Gestión Gestorías Cuota Fijo','13'),
      T_TIPO_DATA('181','Tarifa plana Prorrata 0%','13'),
      T_TIPO_DATA('182','Tarifa plana Prorrata 100%','13'),
      T_TIPO_DATA('183','Monitorio','05'),
      T_TIPO_DATA('184','Derribos','15'),
      T_TIPO_DATA('185','Duplicado Certif. eficiencia energética (CEE)','14'),
      T_TIPO_DATA('186','Humedades','15'),
      T_TIPO_DATA('187','Acompañamiento','15'),
      T_TIPO_DATA('188','Acompañamiento','11'),
	    T_TIPO_DATA('189','Requerimientos Derribos','15'),
      T_TIPO_DATA('190','Requerimientos Limpiezas','15'),
      T_TIPO_DATA('191','Requerimientos Otros','15'),
      T_TIPO_DATA('192','Comisión Tarifa Plana','13'),
      T_TIPO_DATA('193','Comisión broker','10'),
      T_TIPO_DATA('194','Duplicado Cédula Habitabilidad','14'),
	  --Promociones
      T_TIPO_DATA('195','Ejecución de obra principal','21'),
      T_TIPO_DATA('196','Ejecución de obra adicional 1','21'),
      T_TIPO_DATA('197','Ejecución de obra adicional 2','21'),
      T_TIPO_DATA('198','Urbanización','21'),
      T_TIPO_DATA('199','Control de calidad','21'),
      T_TIPO_DATA('200','Compañia eléctrica','21'),
      T_TIPO_DATA('201','Compañia agua','21'),
      T_TIPO_DATA('202','Compañia gas','21'),
      T_TIPO_DATA('203','Compañia telefónica','21'),
      T_TIPO_DATA('204','Compañia OTRAS','21'),
      T_TIPO_DATA('205','Terceros afectados','21'),
      T_TIPO_DATA('206','Dirección técnica urbanización','22'),
      T_TIPO_DATA('207','Proyecto Básico','22'),
      T_TIPO_DATA('208','Proyecto de Urbanización','22'),
      T_TIPO_DATA('209','Proyectos específicos','22'),
      T_TIPO_DATA('210','Dirección de obra arquitecto','22'),
      T_TIPO_DATA('211','Dirección de obra aparejador','22'),
      T_TIPO_DATA('212','Coordinador Seguridad y Salud','22'),
      T_TIPO_DATA('213','Project Manager (Gestión integral)','22'),
      T_TIPO_DATA('214','Project Controller (Controlador de obra)','22'),
      T_TIPO_DATA('215','OCT','22'),
      T_TIPO_DATA('216','Proyecto topográfico','22'),
      T_TIPO_DATA('217','Proyecto Geotécnico','22'),
      T_TIPO_DATA('218','Reparcelación','22'),
      T_TIPO_DATA('219','Proyecto Ejecución','22'),
      T_TIPO_DATA('220','Otros honorarios técnicos','22'),
      T_TIPO_DATA('221','Gastos suplidos','22'),
      T_TIPO_DATA('222','Seguro Decenal','23'),
      T_TIPO_DATA('223','Gastos de notario y registro (D.H.)','23'),
      T_TIPO_DATA('224','Gastos de notario y registro (O.N.)','23'),
      T_TIPO_DATA('225','Gastos de notario y registro (AFO)','23'),
      T_TIPO_DATA('226','Gastos de notario y registro (Segreg./Agrup.)','23'),
      T_TIPO_DATA('227','Gastos de notario y registro (Otros)','23'),
      T_TIPO_DATA('228','Licencia obra (mayor/menor)','23'),
      T_TIPO_DATA('229','ICIO','23'),
      T_TIPO_DATA('230','Licencia 1ª Ocupación/Actividad','23'),
      T_TIPO_DATA('231','Tasas otros organismos','23'),
      T_TIPO_DATA('232','AJD: O.N., D.H., Segr/Agr. y otros','24'),
      T_TIPO_DATA('233','Publicidad','24'),
      T_TIPO_DATA('234','Otros gastos no activables','24'),
      T_TIPO_DATA('235','Avales','24'),
      T_TIPO_DATA('236','Contingencias generales','25')

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

      -- Si existe se modifica.
      DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

      V_MSQL := 'SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_TGA_ID;

      V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_STG_SUBTIPOS_GASTO 
                SET DD_TGA_ID = '||V_TGA_ID||'
              , DD_STG_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
              , DD_STG_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
              , USUARIOMODIFICAR = '''||V_USUARIO||''' 
              , FECHAMODIFICAR = SYSDATE 
               WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');


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