--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9508
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade distribuciones
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9508'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
        T_TIPO_DATA('01','3'),
        T_TIPO_DATA('02','2'),
        T_TIPO_DATA('03','1'),
        T_TIPO_DATA('06','1')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:='SELECT ICO_ID FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 7053541)';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID;

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
	
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);

			V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION (DIS_ID, DIS_NUM_PLANTA, DD_TPH_ID, DIS_CANTIDAD,
			USUARIOCREAR, FECHACREAR, ICO_ID) 
			VALUES (
				'||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL,
				1,
				(SELECT DD_TPH_ID FROM '||V_ESQUEMA||'.DD_TPH_TIPO_HABITACULO WHERE DD_TPH_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''),
				'||V_TMP_TIPO_DATA(2)||',
				'''||V_USU||''',
				SYSDATE,
				'||V_ID||'
			)';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] SE HA INSERTADO EL PROPIETARIO');

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