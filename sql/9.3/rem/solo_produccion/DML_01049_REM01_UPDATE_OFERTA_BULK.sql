--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210929
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10521
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica trabajo
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'OFR_OFERTAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10521'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.BLK_OFR T1 USING (
					SELECT DISTINCT OFR.OFR_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' OFR
					JOIN '||V_ESQUEMA||'.BLK_OFR BLK ON BLK.OFR_ID = OFR.OFR_ID AND BLK.BORRADO = 0
					WHERE OFR.OFR_NUM_OFERTA = 90343810 AND OFR.BORRADO = 0) T2
				ON (T1.OFR_ID = T2.OFR_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.BORRADO = 1,
				T1.USUARIOBORRAR = '''||V_USU||''',
				T1.FECHABORRAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADOS '||SQL%ROWCOUNT||' OFERTA/S DE BULK');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.H_OEB_OFR_EXCLUSION_BULK T1 USING (
					SELECT DISTINCT OEB_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' OFR
					JOIN '||V_ESQUEMA||'.H_OEB_OFR_EXCLUSION_BULK OEB ON OEB.OFR_ID = OFR.OFR_ID AND OEB.BORRADO = 0
					WHERE OFR.OFR_NUM_OFERTA = 90343810 AND OFR.BORRADO = 0) T2
				ON (T1.OEB_ID = T2.OEB_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.OEB_EXCLUSION_BULK = 1,
				USUARIOMODIFICAR = '''||V_USU||''',
				FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '||SQL%ROWCOUNT||' OFERTA/S EXCLUSION BULK');

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