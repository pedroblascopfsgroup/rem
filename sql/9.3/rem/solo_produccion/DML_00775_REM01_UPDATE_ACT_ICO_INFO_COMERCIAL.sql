--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9320
--## PRODUCTO=NO
--##
--## Finalidad: Script informa año contruccion
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_ICO_INFO_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9320'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
					SELECT DISTINCT ICO.ICO_ID, AUX.ICO_ANO_CONSTRUCCION FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ICO
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ICO.ACT_ID AND ACT.BORRADO = 0
					JOIN '||V_ESQUEMA||'.AUX_REMVIP_9320 AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
					WHERE ICO.BORRADO = 0) T2
				ON (T1.ICO_ID = T2.ICO_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.ICO_ANO_CONSTRUCCION = T2.ICO_ANO_CONSTRUCCION,
				T1.USUARIOMODIFICAR = '''||V_USU||''',
				T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS ICO_ANO_CONSTRUCCION EN '|| SQL%ROWCOUNT ||' ACTIVOS DE '||V_TEXT_TABLA);

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