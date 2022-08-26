--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12279
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en MJR_MAPEO_JUPITER_REM Y USU_USUARIOS
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA_J VARCHAR2(50 CHAR) := 'MJR_MAPEO_JUPITER_REM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_U VARCHAR2(50 CHAR) := 'USU_USUARIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-12279'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_PERFIL VARCHAR2(30 CHAR) := 'grupo'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('GR403', 'Usuario_grupo_wallner',	'Grupo de usuarios - WALLNER',	'grupowallner', 'WALLNER','S2B8E1N2F4'),
		T_TIPO_DATA('GR404', 'Usuario_grupo_selectra',	'Grupo de usuarios - SELECTRA',	'gruposelectra', 'SELECTRA','N9C6M4G1B1'),
		T_TIPO_DATA('GR405', 'Usuario_grupo_j2projects_associats',	'Grupo de usuarios - J2 PROJECTS & ASSOCIATS',	'grupoprojectsassociats', 'J2 PROJECTS & ASSOCIATS','M1I6I8E5O1'),
		T_TIPO_DATA('GR406', 'Usuario_grupo_siem_consult',	'Grupo de usuarios - SIEM CONSULT, S.L.U.',	'gruposiem', 'SIEM CONSULT, S.L.U.','Q1H3B1J1L2'),
		T_TIPO_DATA('GR407', 'Usuario_grupo_geser_iberia',	'Grupo de usuarios - GESER IBERIA S.L.',	'grupogeser', 'GESER IBERIA S.L.','F6K1C4E2S2'),
		T_TIPO_DATA('GR408', 'Usuario_grupo_conspime_cerdaña',	'Grupo de usuarios - CONSPIME CERDAÑA, S.L.',	'grupoconspime', 'CONSPIME CERDAÑA, S.L.','O2O2O1P2Q1'),
		T_TIPO_DATA('GR409', 'Usuario_grupo_edifest',	'Grupo de usuarios - EDIFEST S.L.',	'grupoedifest', 'EDIFEST S.L.','E4D5S2D4B1')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA_U||' Y '||V_TABLA_J);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA_U||' WHERE USU_USERNAME = '''||TRIM(V_TMP_TIPO_DATA(4))||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
			DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE REGISTRO');
        ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(4)) ||'''');

			V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.'||V_TABLA_U||' 
					(USU_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE, USU_APELLIDO1, USU_APELLIDO2,USU_GRUPO, USUARIOCREAR, FECHACREAR)
                      SELECT '|| V_ESQUEMA_M ||'.S_'||V_TABLA_U||'.NEXTVAL,'''||TRIM(V_TMP_TIPO_DATA(4))||''',
					  '''||V_TMP_TIPO_DATA(6)||''','''||TRIM(V_TMP_TIPO_DATA(5))||''',''Usuario'', ''Genérico'',
					  1,'''||V_USU||''',SYSDATE  FROM DUAL';
          
                      
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE'||V_TABLA_U);

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_J||' 
					(MJR_ID, MJR_CODIGO_JUPITER, MJR_NOMBRE, MJR_DESCRIPCION, MJR_TIPO_PERFIL, MJR_CODIGO_REM, USUARIOCREAR, FECHACREAR)
                      SELECT '||V_ESQUEMA||'.S_'||V_TABLA_J||'.NEXTVAL,'''||V_TMP_TIPO_DATA(1)||''', '''||V_TMP_TIPO_DATA(2)||''',
					  '''||TRIM(V_TMP_TIPO_DATA(3))||''','''||V_PERFIL||''','''||TRIM(V_TMP_TIPO_DATA(4))||''','''|| V_USU ||''',SYSDATE FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE'||V_TABLA_J);

		END IF;
	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA_J||' ACTUALIZADO CORRECTAMENTE ');
	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TABLA_U||' ACTUALIZADO CORRECTAMENTE ');


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