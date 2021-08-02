--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210526
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9812
--## PRODUCTO=NO
--##
--## Finalidad: Modificar prescriptor
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9812'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_OFR_ID NUMBER(16);

		TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('243964'),
            T_TIPO_DATA('243880'),
            T_TIPO_DATA('243881')
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

		IF V_COUNT = 1 THEN

			V_MSQL := 'SELECT OFR_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL INTO V_OFR_ID;	

			V_MSQL:= 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET 
							PVE_ID_PRESCRIPTOR = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_WEBCOM_ID = 11780),
							USUARIOMODIFICAR = '''||V_USU||''',
							FECHAMODIFICAR = SYSDATE
							WHERE OFR_ID = '||V_OFR_ID||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] PRESCRIPTOR ACTUALIZADO PARA EL EXPEDIENTE '||V_TMP_TIPO_DATA(1)||'');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL EXPEDIENTE');

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
