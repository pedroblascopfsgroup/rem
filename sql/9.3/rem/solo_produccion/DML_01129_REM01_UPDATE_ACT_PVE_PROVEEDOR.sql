--/*
--##########################################
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10598
--## PRODUCTO=NO
--##
--## Finalidad: Script informa mediador relacionado para oficinas
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_PVE_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10598'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_PVE_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- 			COD_OFI  COD_MED
		T_TIPO_DATA(8492	,110192669),
		T_TIPO_DATA(8705	,110192669)); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		V_PVE_ID := 0;

		DBMS_OUTPUT.PUT_LINE('[INFO]: INFORMAR MEDIADOR EN '||V_TEXT_TABLA);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE PVE_COD_REM = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 1 THEN

			V_MSQL:= 'SELECT PVE_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE PVE_COD_REM = '||V_TMP_TIPO_DATA(2)||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_PVE_ID;

			IF V_PVE_ID != 0 THEN

				V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
							PVE_ID_MEDIADOR_REL = '||V_PVE_ID||',
							USUARIOMODIFICAR = '''||V_USU||''',
							FECHAMODIFICAR = SYSDATE
							WHERE PVE_COD_REM = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
				EXECUTE IMMEDIATE V_MSQL;
				
				DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS PVE_ID_MEDIADOR_REL = '||V_TMP_TIPO_DATA(2)||' EN OFICINA CON PVE_COD_REM '||V_TMP_TIPO_DATA(1)||'');

			ELSE

				DBMS_OUTPUT.PUT_LINE('[INFO]: PROVEEDOR MEDIADOR '||V_TMP_TIPO_DATA(2)||' NO EXISTE O ESTA BORRADO');

			END IF;

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: OFICINA CON CODIGO REM '||V_TMP_TIPO_DATA(1)||' NO EXISTE O ESTA BORRADO');

		END IF;

	END LOOP;

	COMMIT;

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

EXIT