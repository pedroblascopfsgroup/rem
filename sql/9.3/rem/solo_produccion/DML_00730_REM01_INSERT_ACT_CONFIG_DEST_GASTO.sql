--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210303
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9018
--## PRODUCTO=NO
--##
--## Finalidad: Script inserta destinatario gasto
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CONFIG_DEST_GASTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9018'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- 		DEG_ID	CRA_ID 	IRE_ID
		T_TIPO_DATA(2, 	  21,     2),
		T_TIPO_DATA(2, 	  21,     4),
		T_TIPO_DATA(2, 	  21,     6),
		T_TIPO_DATA(2, 	  21,     8)
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR VALORES EN '||V_TEXT_TABLA);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_DEG_ID = '||V_TMP_TIPO_DATA(1)||' AND DD_CRA_ID = '||V_TMP_TIPO_DATA(2)||' 
					AND DD_IRE_ID = '||V_TMP_TIPO_DATA(3)||' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 0 THEN

			V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||'(DGA_ID,DGA_FECHA_INICIO,DGA_FECHA_FIN,DD_CRA_ID,DD_IRE_ID,DD_DEG_ID,USUARIOCREAR,FECHACREAR) VALUES (
						'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL, TO_TIMESTAMP(CONCAT(''01/01/1900'', '' 00:00:00''), ''DD/MM/YYYY HH24:MI:SS.FF''),
						TO_TIMESTAMP(CONCAT(''31/12/2099'', '' 00:00:00''), ''DD/MM/YYYY HH24:MI:SS.FF''), '||V_TMP_TIPO_DATA(2)||','||V_TMP_TIPO_DATA(3)||',
						'||V_TMP_TIPO_DATA(1)||', '''||V_USU||''', SYSDATE)';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS REGISTRO CON DD_DEG_ID = '||V_TMP_TIPO_DATA(1)||' AND DD_CRA_ID = '||V_TMP_TIPO_DATA(2)||' AND DD_IRE_ID = '||V_TMP_TIPO_DATA(3)||'');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE REGISTRO');

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