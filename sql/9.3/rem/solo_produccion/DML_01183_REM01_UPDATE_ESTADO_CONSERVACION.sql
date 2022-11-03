--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12391
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica DD_ECV_ID
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
	V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_ICO_INFO_COMERCIAL';
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-12391'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
                SELECT ICO.ICO_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
                JOIN '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION ECV ON ECV.DD_ECV_ID = ICO.DD_ECV_ID
                WHERE ICO.BORRADO = 0 AND ECV.DD_ECV_CODIGO IN (''03'',''04'')) T2
            ON (T1.ICO_ID = T2.ICO_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.DD_ECV_ID = (SELECT DD_ECV_ID FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION WHERE DD_ECV_CODIGO = ''07''),
            T1.USUARIOMODIFICAR = '''||V_USU||''',
            T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS');

        V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA T1 USING (
                SELECT CBX.CBX_ID, AUX.EST_CONSERVACION 
                FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CBX ON CBX.ACT_ID = ACT.ACT_ID AND CBX.BORRADO = 0
                JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_IDENTIFICATIVO = ACT.ACT_NUM_ACTIVO_CAIXA
                WHERE ACT.BORRADO = 0) T2
            ON (T1.CBX_ID = T2.CBX_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.DD_ECV_STOCK_BC = T2.EST_CONSERVACION';
        EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS');

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