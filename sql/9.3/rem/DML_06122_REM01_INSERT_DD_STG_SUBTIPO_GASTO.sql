--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220725
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11782
--## PRODUCTO=NO
--## 
--## Finalidad: INSERTAMOS SUBTIPO GASTO
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [REMVIP-11782] - Juan Bautista Alfonso
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-11782'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	V_TGA_ID NUMBER(16); 
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--DD_STG_CODIGO  --DESCRIPCION  --DD_TGA_CODIGO
        T_TIPO_DATA('319','DI Gestión Externa','15'),
        T_TIPO_DATA('320','DI Postventa OPEX','15'),
        T_TIPO_DATA('321','Limpieza Activos Singulares','15'),
        T_TIPO_DATA('322','Mantenimiento Activos Singulares','15'),
        T_TIPO_DATA('323','Suelos Informes técnicos','15'),
        T_TIPO_DATA('324','Suelos Obra OPEX','15'),
        T_TIPO_DATA('325','CCPP Activos Singulares','05'),
        T_TIPO_DATA('326','Impuesto de Vivienda Vacías (IVV)','01'),
        T_TIPO_DATA('327','Marketing Activos Singulares','17'),
        T_TIPO_DATA('328','Seguros Activos Singulares','10'),
        T_TIPO_DATA('329','Seguros Alquileres','10'),
        T_TIPO_DATA('330','Burofax DI','20'),
        T_TIPO_DATA('331','Burofax RAM','20'),
        T_TIPO_DATA('332','Burofax SSJJ','20'),
        T_TIPO_DATA('333','Servicios jurídicos Activos Singulares','20'),
        T_TIPO_DATA('334','SSJJ Certificaciones de dominio y  cargas','20'),
        T_TIPO_DATA('335','SSJJ Daños','20'),
        T_TIPO_DATA('336','SSJJ Declarativos de posesión (en v.2020.01.15)','20'),
        T_TIPO_DATA('337','SSJJ Desahución y reclamacion de Deuda','20'),
        T_TIPO_DATA('338','SSJJ Ejecuciones hipotecarias - Tomas de posesión','20'),
        T_TIPO_DATA('339','SSJJ Ejecuciones hipotecarias - Tomas de posesión Extrajudicial','20'),
        T_TIPO_DATA('340','SSJJ Incentivos proveedores','20'),
        T_TIPO_DATA('341','SSJJ Notas Simples','20'),
        T_TIPO_DATA('342','SSJJ Ocupaciones Ilegales Extrajudiciales','20'),
        T_TIPO_DATA('343','SSJJ Otros procedimientos','20'),
        T_TIPO_DATA('344','SSJJ Unificación de letrados y procuradores','11'),
        T_TIPO_DATA('345','Gerencia Activos Singulares','11'),
        T_TIPO_DATA('346','Honorarios EV y CFK','11'),
        T_TIPO_DATA('347','Honorarios Rotación','11'),
        T_TIPO_DATA('348','Seguridad Activos Singulares','16')
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