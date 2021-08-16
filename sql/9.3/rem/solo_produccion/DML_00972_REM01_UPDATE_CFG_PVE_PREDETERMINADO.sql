--/*
--######################################### 
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210726
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10049
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  Modificar config proveedores
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(30 CHAR) := 'REMVIP-10049';
    V_TEXT_TABLA VARCHAR2(30 CHAR) := 'CFG_PVE_PREDETERMINADO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_NUM_TABLAS NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
				--CRA	SCR		TTR		PVE_COD_REM		PRV
				T_TIPO_DATA('01','01','03','10009594', '1'),
				T_TIPO_DATA('01','01','03','10009594', '2'),
				T_TIPO_DATA('01','01','03','10009594', '5'),
				T_TIPO_DATA('01','01','03','10009594', '6'),
				T_TIPO_DATA('01','01','03','10009594', '7'),
				T_TIPO_DATA('01','01','03','10009594', '8'),
				T_TIPO_DATA('01','01','03','10009594', '9'),
				T_TIPO_DATA('01','01','03','10009594', '10'),
				T_TIPO_DATA('01','01','03','10009594', '12'),
				T_TIPO_DATA('01','01','03','10009594', '13'),
				T_TIPO_DATA('01','01','03','10009594', '14'),
				T_TIPO_DATA('01','01','03','10009594', '15'),
				T_TIPO_DATA('01','01','03','10009594', '16'),
				T_TIPO_DATA('01','01','03','10009594', '17'),
				T_TIPO_DATA('01','01','03','10009594', '19'),
				T_TIPO_DATA('01','01','03','10009594', '20'),
				T_TIPO_DATA('01','01','03','10009594', '21'),
				T_TIPO_DATA('01','01','03','10009594', '22'),
				T_TIPO_DATA('01','01','03','10009594', '23'),
				T_TIPO_DATA('01','01','03','10009594', '24'),
				T_TIPO_DATA('01','01','03','10009594', '25'),
				T_TIPO_DATA('01','01','03','10009594', '26'),
				T_TIPO_DATA('01','01','03','10009594', '27'),
				T_TIPO_DATA('01','01','03','10009594', '28'),
				T_TIPO_DATA('01','01','03','10009594', '31'),
				T_TIPO_DATA('01','01','03','10009594', '32'),
				T_TIPO_DATA('01','01','03','10009594', '33'),
				T_TIPO_DATA('01','01','03','10009594', '34'),
				T_TIPO_DATA('01','01','03','10009594', '35'),
				T_TIPO_DATA('01','01','03','10009594', '36'),
				T_TIPO_DATA('01','01','03','10009594', '37'),
				T_TIPO_DATA('01','01','03','10009594', '38'),
				T_TIPO_DATA('01','01','03','10009594', '39'),
				T_TIPO_DATA('01','01','03','10009594', '40'),
				T_TIPO_DATA('01','01','03','10009594', '41'),
				T_TIPO_DATA('01','01','03','10009594', '42'),
				T_TIPO_DATA('01','01','03','10009594', '43'),
				T_TIPO_DATA('01','01','03','10009594', '44'),
				T_TIPO_DATA('01','01','03','10009594', '45'),
				T_TIPO_DATA('01','01','03','10009594', '46'),
				T_TIPO_DATA('01','01','03','10009594', '47'),
				T_TIPO_DATA('01','01','03','10009594', '48'),
				T_TIPO_DATA('01','01','03','10009594', '49'),
				T_TIPO_DATA('01','01','03','10009594', '50'),
				T_TIPO_DATA('01','01','03','10009594', '51'),
				T_TIPO_DATA('01','02','03','10009594', '1'),
				T_TIPO_DATA('01','02','03','10009594', '2'),
				T_TIPO_DATA('01','02','03','10009594', '5'),
				T_TIPO_DATA('01','02','03','10009594', '6'),
				T_TIPO_DATA('01','02','03','10009594', '7'),
				T_TIPO_DATA('01','02','03','10009594', '8'),
				T_TIPO_DATA('01','02','03','10009594', '9'),
				T_TIPO_DATA('01','02','03','10009594', '10'),
				T_TIPO_DATA('01','02','03','10009594', '12'),
				T_TIPO_DATA('01','02','03','10009594', '13'),
				T_TIPO_DATA('01','02','03','10009594', '14'),
				T_TIPO_DATA('01','02','03','10009594', '15'),
				T_TIPO_DATA('01','02','03','10009594', '16'),
				T_TIPO_DATA('01','02','03','10009594', '17'),
				T_TIPO_DATA('01','02','03','10009594', '19'),
				T_TIPO_DATA('01','02','03','10009594', '20'),
				T_TIPO_DATA('01','02','03','10009594', '21'),
				T_TIPO_DATA('01','02','03','10009594', '22'),
				T_TIPO_DATA('01','02','03','10009594', '23'),
				T_TIPO_DATA('01','02','03','10009594', '24'),
				T_TIPO_DATA('01','02','03','10009594', '25'),
				T_TIPO_DATA('01','02','03','10009594', '26'),
				T_TIPO_DATA('01','02','03','10009594', '27'),
				T_TIPO_DATA('01','02','03','10009594', '28'),
				T_TIPO_DATA('01','02','03','10009594', '31'),
				T_TIPO_DATA('01','02','03','10009594', '32'),
				T_TIPO_DATA('01','02','03','10009594', '33'),
				T_TIPO_DATA('01','02','03','10009594', '34'),
				T_TIPO_DATA('01','02','03','10009594', '35'),
				T_TIPO_DATA('01','02','03','10009594', '36'),
				T_TIPO_DATA('01','02','03','10009594', '37'),
				T_TIPO_DATA('01','02','03','10009594', '38'),
				T_TIPO_DATA('01','02','03','10009594', '39'),
				T_TIPO_DATA('01','02','03','10009594', '40'),
				T_TIPO_DATA('01','02','03','10009594', '41'),
				T_TIPO_DATA('01','02','03','10009594', '42'),
				T_TIPO_DATA('01','02','03','10009594', '43'),
				T_TIPO_DATA('01','02','03','10009594', '44'),
				T_TIPO_DATA('01','02','03','10009594', '45'),
				T_TIPO_DATA('01','02','03','10009594', '46'),
				T_TIPO_DATA('01','02','03','10009594', '47'),
				T_TIPO_DATA('01','02','03','10009594', '48'),
				T_TIPO_DATA('01','02','03','10009594', '49'),
				T_TIPO_DATA('01','02','03','10009594', '50'),
				T_TIPO_DATA('01','02','03','10009594', '51')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET 
					PVE_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||V_TMP_TIPO_DATA(4)||'''),
					USUARIOMODIFICAR = '''||V_USU||''',
					FECHAMODIFICAR = SYSDATE
					WHERE 
					DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') AND
					DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') AND
					DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||V_TMP_TIPO_DATA(3)||''') AND
					DD_PRV_ID = (SELECT DD_PRV_ID FROM '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = '''||V_TMP_TIPO_DATA(5)||''')';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADO REGISTRO EN '||V_TEXT_TABLA||' PARA PROVEEDOR PVE_COD_REM -> '||V_TMP_TIPO_DATA(4)||' EN CÓDIGO PROVINCIA -> '||V_TMP_TIPO_DATA(5)||'');
        
	END LOOP;

    COMMIT;
	
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;