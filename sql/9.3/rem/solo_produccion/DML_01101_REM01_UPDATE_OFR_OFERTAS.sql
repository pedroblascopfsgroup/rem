--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10899
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica situacion posesoria activos
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10899'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
			T_TIPO_DATA('90361910','04'),
			T_TIPO_DATA('90362182','08'),
			T_TIPO_DATA('90361281','08'),
			T_TIPO_DATA('90364894','08'),
			T_TIPO_DATA('90364981','04'),
			T_TIPO_DATA('90365240','08'),
			T_TIPO_DATA('90360646','04'),
			T_TIPO_DATA('90363061','08'),
			T_TIPO_DATA('90361908','08'),
			T_TIPO_DATA('90361508','04'),
			T_TIPO_DATA('90359719','08'),
			T_TIPO_DATA('90363083','04'),
			T_TIPO_DATA('90362976','08'),
			T_TIPO_DATA('90359350','04'),
			T_TIPO_DATA('90364905','08'),
			T_TIPO_DATA('90365204','08'),
			T_TIPO_DATA('90363423','08'),
			T_TIPO_DATA('90360979','08'),
			T_TIPO_DATA('90363659','08'),
			T_TIPO_DATA('90361721','08'),
			T_TIPO_DATA('90362432','08'),
			T_TIPO_DATA('90365291','08'),
			T_TIPO_DATA('90364991','08'),
			T_TIPO_DATA('90363218','08'),
			T_TIPO_DATA('90365214','08'),
			T_TIPO_DATA('90362817','08'),
			T_TIPO_DATA('90362993','08'),
			T_TIPO_DATA('90363582','08'),
			T_TIPO_DATA('90362337','08'),
			T_TIPO_DATA('90362755','08'),
			T_TIPO_DATA('90362879','08'),
			T_TIPO_DATA('90362665','04'),
			T_TIPO_DATA('90359479','04'),
			T_TIPO_DATA('90362122','04'),
			T_TIPO_DATA('90363390','08'),
			T_TIPO_DATA('90361787','08'),
			T_TIPO_DATA('90362926','08'),
			T_TIPO_DATA('90361420','04'),
			T_TIPO_DATA('90359533','08'),
			T_TIPO_DATA('90362732','04'),
			T_TIPO_DATA('90362969','08'),
			T_TIPO_DATA('90363231','08'),
			T_TIPO_DATA('90364857','08'),
			T_TIPO_DATA('90362511','08'),
			T_TIPO_DATA('90362532','04'),
			T_TIPO_DATA('90361076','08'),
			T_TIPO_DATA('90359585','04'),
			T_TIPO_DATA('90363203','08'),
			T_TIPO_DATA('90365103','08'),
			T_TIPO_DATA('90362155','04'),
			T_TIPO_DATA('90363585','08'),
			T_TIPO_DATA('90363302','08'),
			T_TIPO_DATA('90365340','08'),
			T_TIPO_DATA('90365235','08'),
			T_TIPO_DATA('90364908','08'),
			T_TIPO_DATA('90359849','08'),
			T_TIPO_DATA('90363451','08'),
			T_TIPO_DATA('90361894','08')); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
	V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE 
					OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 1 THEN

			V_MSQL:= 'UPDATE  '||V_ESQUEMA||'.OFR_OFERTAS 
						SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA 
								WHERE DD_EOF_CODIGO = '||V_TMP_TIPO_DATA(2)||' AND BORRADO = 0),
						USUARIOMODIFICAR = '''||V_USU||''', FECHAMODIFICAR = SYSDATE
						WHERE OFR_NUM_OFERTA = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: OFERTA '||V_TMP_TIPO_DATA(1)||' > ESTADO OFERTA CODIGO '||V_TMP_TIPO_DATA(2)||'');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: NO EXISTE OFERTA: '||V_TMP_TIPO_DATA(1)||'');

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