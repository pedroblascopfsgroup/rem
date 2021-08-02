--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9769
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
	V_TEXT_TABLA_AUX VARCHAR2(27 CHAR) := 'AUX_REMVIP_9699';
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9769'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
					SELECT ADN.ADN_ID,ACT.ACT_ID,AUX.POSESION FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                        JOIN '||V_ESQUEMA||'.AUX_REMVIP_9699 AUX ON AUX.ACT_NUM_ACTIVO=ACT.ACT_NUM_ACTIVO
						JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=ACT.DD_CRA_ID AND CRA.BORRADO=0
						JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID=ACT.DD_SCR_ID AND SCR.BORRADO=0
                        JOIN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID=ACT.ACT_ID
                        JOIN '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID=ACT.DD_TTA_ID
                        WHERE ACT.BORRADO=0 AND TTA.BORRADO=0 AND ADN.BORRADO=0 AND TTA.DD_TTA_CODIGO = ''02'' AND CRA.DD_CRA_CODIGO=''07''
						AND SCR.DD_SCR_CODIGO IN (''138'',''151'',''152'') AND ADN.FECHA_POSESION IS NULL
				) T2
				ON (T1.ADN_ID = T2.ADN_ID)
				WHEN MATCHED THEN UPDATE SET
				FECHA_POSESION = TO_DATE(TO_CHAR(T2.POSESION,''DD/MM/YYYY''),''DD/MM/YYYY''),               
				USUARIOMODIFICAR = '''||V_USU||''',
				FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA||' INFORMANDO FECHA_POSESION');

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