--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20211019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10520
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica fases publicacion activos
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_HFP_HIST_FASES_PUB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10520'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
			
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO] actualizacion en '''||V_TEXT_TABLA||''' ');
	
		V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (

                        SELECT DISTINCT AUX2.ACT_NUM_ACTIVO,AUX2.ACT_ID,AUX2.HFP_ID FROM 
                        (
                            SELECT ACT.ACT_NUM_ACTIVO,ACT.ACT_ID, HFP.HFP_ID,ROW_NUMBER() OVER(PARTITION BY HFP.ACT_ID ORDER BY hfp.HFP_FECHA_INI DESC NULLS LAST) AS RN
                            FROM '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB HFP
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = HFP.ACT_ID 
                            JOIN '||V_ESQUEMA||'.AUX_REMVIP_10520 AUX ON AUX.ID_HAYA=ACT.ACT_NUM_ACTIVO
                            WHERE HFP.BORRADO = 0
                            AND HFP.HFP_FECHA_FIN IS NOT NULL
                            AND ACT.ACT_ID NOT IN (SELECT DISTINCT ACT_ID FROM '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB WHERE BORRADO = 0 AND HFP_FECHA_FIN IS NULL)

                        ) AUX2 WHERE AUX2.RN = 1
                        ORDER BY AUX2.ACT_NUM_ACTIVO
                        
                    ) T2
					ON (T1.HFP_ID = T2.HFP_ID)
					WHEN MATCHED THEN UPDATE SET
					T1.HFP_FECHA_FIN = NULL,
					T1.USUARIOMODIFICAR = '''||V_USU||''',
					T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] QUITADOS FECHA FIN DE '||SQL%ROWCOUNT||' FASES DE PUBLICACION');

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