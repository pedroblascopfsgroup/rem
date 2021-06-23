--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210623
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10041
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica solicitante trabajos
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_TBJ_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10041'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_TBJ_ID NUMBER(16);
	V_USU_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('924567879052','mgarciade'),
		T_TIPO_DATA('924567879053','mgarciade'),
		T_TIPO_DATA('924567879054','mgarciade'),
		T_TIPO_DATA('924567879055','mgarciade'),
		T_TIPO_DATA('924567879056','mgarciade'),
		T_TIPO_DATA('924567879057','mgarciade'),
		T_TIPO_DATA('924567879058','mgarciade'),
		T_TIPO_DATA('924567879059','mgarciade'),
		T_TIPO_DATA('924567879060','mgarciade'),
		T_TIPO_DATA('924567879061','mgarciade'),
		T_TIPO_DATA('924567879062','mgarciade'),
		T_TIPO_DATA('924567879063','mgarciade'),
		T_TIPO_DATA('924567879064','mgarciade'),
		T_TIPO_DATA('924567879065','mgarciade'),
		T_TIPO_DATA('924567879066','mgarciade'),
		T_TIPO_DATA('924567879067','mgarciade'),
		T_TIPO_DATA('924567879068','mgarciade'),
		T_TIPO_DATA('924567879069','mgarciade'),
		T_TIPO_DATA('924567879070','mgarciade'),
		T_TIPO_DATA('924567879071','mgarciade'),
		T_TIPO_DATA('924567879072','mgarciade'),
		T_TIPO_DATA('924567879073','mgarciade'),
		T_TIPO_DATA('924567879074','mgarciade'),
		T_TIPO_DATA('924567879075','mgarciade'),
		T_TIPO_DATA('924567879076','mgarciade'),
		T_TIPO_DATA('924567879077','mgarciade'),
		T_TIPO_DATA('924567879078','mgarciade'),
		T_TIPO_DATA('924567879079','mgarciade'),
		T_TIPO_DATA('924567879080','mgarciade'),
		T_TIPO_DATA('924567879081','mgarciade'),
		T_TIPO_DATA('924567879082','mgarciade'),
		T_TIPO_DATA('924567879083','mgarciade'),
		T_TIPO_DATA('924567879084','mgarciade'),
		T_TIPO_DATA('924567879085','mgarciade'),
		T_TIPO_DATA('924567879086','mgarciade'),
		T_TIPO_DATA('924567878180','ext.mquiros'),
		T_TIPO_DATA('924567878181','ext.mquiros'),
		T_TIPO_DATA('924567878182','ext.mquiros'),
		T_TIPO_DATA('924567878183','ext.mquiros'),
		T_TIPO_DATA('924567878184','ext.mquiros'),
		T_TIPO_DATA('924567878185','ext.mquiros'),
		T_TIPO_DATA('924567878186','ext.mquiros'),
		T_TIPO_DATA('924567878187','ext.mquiros'),
		T_TIPO_DATA('924567878188','ext.mquiros'),
		T_TIPO_DATA('924567878189','ext.mquiros'),
		T_TIPO_DATA('924567878190','ext.mquiros'),
		T_TIPO_DATA('924567878191','ext.mquiros'),
		T_TIPO_DATA('924567878192','ext.mquiros'),
		T_TIPO_DATA('924567878193','ext.mquiros'),
		T_TIPO_DATA('924567878194','ext.mquiros'),
		T_TIPO_DATA('924567878195','ext.mquiros'),
		T_TIPO_DATA('924567878196','ext.mquiros'),
		T_TIPO_DATA('924567878197','ext.mquiros'),
		T_TIPO_DATA('924567878198','ext.mquiros'),
		T_TIPO_DATA('924567878199','ext.mquiros'),
		T_TIPO_DATA('924567878200','ext.mquiros'),
		T_TIPO_DATA('924567878201','ext.mquiros'),
		T_TIPO_DATA('924567878202','ext.mquiros'),
		T_TIPO_DATA('924567878203','ext.mquiros'),
		T_TIPO_DATA('924567878204','ext.mquiros'),
		T_TIPO_DATA('924567878205','ext.mquiros'),
		T_TIPO_DATA('924567878206','ext.mquiros'),
		T_TIPO_DATA('924567878207','ext.mquiros'),
		T_TIPO_DATA('924567878208','ext.mquiros'),
		T_TIPO_DATA('924567878209','ext.mquiros'),
		T_TIPO_DATA('924567878210','ext.mquiros'),
		T_TIPO_DATA('924567878211','ext.mquiros'),
		T_TIPO_DATA('924567878212','ext.mquiros'),
		T_TIPO_DATA('924567878213','ext.mquiros')

		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 1 THEN

			V_MSQL:= 'SELECT TBJ_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||'';
			EXECUTE IMMEDIATE V_MSQL INTO V_TBJ_ID;

			V_MSQL:= 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_TIPO_DATA(2)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_USU_ID;

			V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
					USU_ID = '||V_USU_ID||',
					USUARIOMODIFICAR = '''||V_USU||''',
					FECHAMODIFICAR = SYSDATE
					WHERE TBJ_ID = '||V_TBJ_ID||'';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS RESPONSABLE EN TRABAJO '||V_TMP_TIPO_DATA(1)||'');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJO '||V_TMP_TIPO_DATA(1)||' NO EXISTE O ESTA BORRADO');

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