--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210414
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9471
--## PRODUCTO=NO
--##
--## Finalidad: Script crea propietario CAIXABANK y actualiza activos BANKIA a dicho propietario
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9471'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO (PRO_ID, DD_LOC_ID, DD_TPE_ID, PRO_NOMBRE, DD_TDI_ID,
	PRO_DOCIDENTIF, PRO_DIR, DD_LOC_ID_CONT, USUARIOCREAR, FECHACREAR, DD_CRA_ID) 
	VALUES (
		'||V_ESQUEMA||'.S_ACT_PRO_PROPIETARIO.NEXTVAL,
		(SELECT DD_LOC_ID FROM '||V_ESQUEMA||'.APR_AUX_DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = ''46002''),
		(SELECT DD_TPE_ID FROM '||V_ESQUEMA_M||'.DD_TPE_TIPO_PERSONA WHERE DD_TPE_CODIGO = ''2''),
		''CaixaBank'',
		(SELECT DD_TDI_ID FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID WHERE DD_TDI_CODIGO = ''15''),
		''A08663619'',
		''C/Pintor Sorolla 2-4, 46002 (Valencia)'',
		(SELECT DD_LOC_ID FROM '||V_ESQUEMA||'.APR_AUX_DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = ''46002''),
		'''||V_USU||''',
		SYSDATE,
		(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03'')
	)';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] SE HA INSERTADO EL PROPIETARIO');

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