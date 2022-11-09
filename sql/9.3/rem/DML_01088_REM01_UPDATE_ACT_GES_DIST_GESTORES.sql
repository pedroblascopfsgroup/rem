--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20221005
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11662
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar gestores de publicación
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(124 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-11662'; -- USUARIOCREAR/USUARIOMODIFICAR.    
	V_COUNT NUMBER(16);
	V_CARTERAS VARCHAR2(30 CHAR) := '''2'',''7''';
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;    
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('2','ext.lnestar'),
		T_TIPO_DATA('3','jtamarit'),
		T_TIPO_DATA('4','rdura'),
		T_TIPO_DATA('1','ext.lnestar'),
		T_TIPO_DATA('33','ext.lnestar'),
		T_TIPO_DATA('5','ext.lnestar'),
		T_TIPO_DATA('6','ext.lnestar'),
		T_TIPO_DATA('7','jtamarit'),
		T_TIPO_DATA('8','rabad'),
		T_TIPO_DATA('48','ext.lnestar'),
		T_TIPO_DATA('9','ext.lnestar'),
		T_TIPO_DATA('10','ext.lnestar'),
		T_TIPO_DATA('11','rdura'),
		T_TIPO_DATA('39','ext.lnestar'),
		T_TIPO_DATA('12','jtamarit'),
		T_TIPO_DATA('51','ext.lnestar'),
		T_TIPO_DATA('13','ext.lnestar'),
		T_TIPO_DATA('14','rdura'),
		T_TIPO_DATA('15','ext.lnestar'),
		T_TIPO_DATA('16','ext.lnestar'),
		T_TIPO_DATA('20','ext.lnestar'),
		T_TIPO_DATA('17','jalmendros'),
		T_TIPO_DATA('18','rdura'),
		T_TIPO_DATA('19','ext.lnestar'),
		T_TIPO_DATA('21','rdura'),
		T_TIPO_DATA('22','ext.lnestar'),
		T_TIPO_DATA('23','rdura'),
		T_TIPO_DATA('24','ext.lnestar'),
		T_TIPO_DATA('25','jalmendros'),
		T_TIPO_DATA('27','ext.lnestar'),
		T_TIPO_DATA('28','rabad'),
		T_TIPO_DATA('29','rdura'),
		T_TIPO_DATA('52','rabad'),
		T_TIPO_DATA('30','ext.lnestar'),
		T_TIPO_DATA('31','ext.lnestar'),
		T_TIPO_DATA('32','ext.lnestar'),
		T_TIPO_DATA('34','ext.lnestar'),
		T_TIPO_DATA('35','jtamarit'),
		T_TIPO_DATA('36','ext.lnestar'),
		T_TIPO_DATA('26','ext.lnestar'),
		T_TIPO_DATA('37','ext.lnestar'),
		T_TIPO_DATA('38','jtamarit'),
		T_TIPO_DATA('40','ext.lnestar'),
		T_TIPO_DATA('41','rdura'),
		T_TIPO_DATA('42','ext.lnestar'),
		T_TIPO_DATA('43','jalmendros'),
		T_TIPO_DATA('44','ext.lnestar'),
		T_TIPO_DATA('45','ext.lnestar'),
		T_TIPO_DATA('46','jtamarit'),
		T_TIPO_DATA('47','ext.lnestar'),
		T_TIPO_DATA('49','ext.lnestar'),
		T_TIPO_DATA('50','ext.lnestar')

    );
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		DBMS_OUTPUT.PUT_LINE('[INFO]: USUARIO '''||TRIM(V_TMP_TIPO_DATA(2))||''' - PROVINCIA '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

		V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_GES_DIST_GESTORES T1 USING
						(
						SELECT ID FROM REM01.ACT_GES_DIST_GESTORES
						WHERE TIPO_GESTOR = ''GPUBL'' 
						AND COD_CARTERA NOT IN ('||V_CARTERAS||')
						AND COD_PROVINCIA = '''||V_TMP_TIPO_DATA(1)||'''
						AND BORRADO = 0
						) T2
					ON (T1.ID = T2.ID)
					WHEN MATCHED THEN UPDATE SET
					USERNAME = '''||V_TMP_TIPO_DATA(2)||''',
					NOMBRE_USUARIO = (SELECT USU_NOMBRE ||'' ''|| USU_APELLIDO1 ||'' ''|| USU_APELLIDO2 FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0),
					USUARIOMODIFICAR = '''||V_USR||''',
					FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADOS '||SQL%ROWCOUNT||' GESTORES');
		DBMS_OUTPUT.PUT_LINE('[INFO]: GESTOR DE PUBLICACIÓN '''||TRIM(V_TMP_TIPO_DATA(2))||''' INSERTADO PARA PROVINCIA '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

	END LOOP;

    DBMS_OUTPUT.PUT_LINE('[FIN]');   

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
EXIT;
