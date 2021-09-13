--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10368
--## PRODUCTO=NO
--##
--## Finalidad: Script cambia de fase
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
    V_NUM NUMBER(16); -- Vble. auxiliar para almacenar el número de registros
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10368'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[INFO]: FINALIZAR FASE');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB T1
				USING (
					SELECT DISTINCT HFP.HFP_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
					JOIN '||V_ESQUEMA||'.AUX_REMVIP_10368 AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
					JOIN '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB HFP ON ACT.ACT_ID = HFP.ACT_ID AND HFP.BORRADO = 0
					WHERE HFP.HFP_FECHA_FIN IS NULL AND HFP.DD_FSP_ID = 1
						) T2 
				ON (T1.HFP_ID = T2.HFP_ID)
				WHEN MATCHED THEN UPDATE SET 
				HFP_FECHA_FIN = SYSDATE,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
				T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] FINALIZADAS  '|| SQL%ROWCOUNT ||' FASES EN ACT_HFP_HIST_FASES_PUB');

	DBMS_OUTPUT.PUT_LINE('[INFO]: AÑADIR FASE');

	-- NO ejecutar más de una vez este insert con el mismo where usuariomodificar para no crear duplicados
	V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB (HFP_ID, ACT_ID, DD_FSP_ID, DD_SFP_ID, USU_ID, HFP_FECHA_INI, USUARIOCREAR, FECHACREAR)
			SELECT '||V_ESQUEMA||'.S_ACT_HFP_HIST_FASES_PUB.NEXTVAL,
					ACT_ID,
					(SELECT DD_FSP_ID FROM '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION WHERE DD_FSP_CODIGO = ''02''),
					(SELECT DD_SFP_ID FROM '||V_ESQUEMA||'.DD_SFP_SUBFASE_PUBLICACION WHERE DD_SFP_CODIGO = ''01''),
					(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''SUPER''),
					SYSDATE,
					'''||V_USUARIO||''',
					SYSDATE
					FROM '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB
					WHERE USUARIOMODIFICAR = '''||V_USUARIO||'''
				';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADAS  '|| SQL%ROWCOUNT ||' FASES EN ACT_HFP_HIST_FASES_PUB');

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