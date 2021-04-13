--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210401
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9419
--## PRODUCTO=NO
--##
--## Finalidad: Script informa fecha posesion
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_ADN_ADJNOJUDICIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_TABLA_AUX VARCHAR2(27 CHAR) := 'AUX_REMVIP_9419';
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9419'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
					SELECT DISTINCT ADN.ADN_ID, AUX.SPS_FECHA_TOMA_POSESION FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADN
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ADN.ACT_ID AND ACT.BORRADO = 0
					JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX||' AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
					AND ADN.BORRADO = 0 
				) T2
				ON (T1.ADN_ID = T2.ADN_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.ADN_FECHA_TITULO = TO_DATE(T2.SPS_FECHA_TOMA_POSESION,''DD/MM/YYYY''),
				USUARIOMODIFICAR = '''||V_USU||''',
				FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA||' INFORMANDO ADN_FECHA_TITULO');

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