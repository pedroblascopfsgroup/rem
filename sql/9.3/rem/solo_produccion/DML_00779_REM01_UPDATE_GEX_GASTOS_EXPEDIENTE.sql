--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9375
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica ACC_ID
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'GEX_GASTOS_EXPEDIENTE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9375'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
				SELECT GEX.GEX_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
				JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
				JOIN '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE GEX ON GEX.ECO_ID = ECO.ECO_ID AND GEX.BORRADO = 0
				AND OFR.BORRADO = 0 AND OFR.OFR_NUM_OFERTA IN (90275483,90289861,90290280,90286953,90296235,90298891)) T2
				ON (T1.GEX_ID = T2.GEX_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.DD_ACC_ID = 4,
				USUARIOMODIFICAR = '''||V_USU||''',
				FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA||'');

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