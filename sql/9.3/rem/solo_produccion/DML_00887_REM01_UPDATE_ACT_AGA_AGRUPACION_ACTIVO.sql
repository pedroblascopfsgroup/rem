--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210601
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9857
--## PRODUCTO=NO
--##
--## Finalidad: Quitar borrado lógico
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9857'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T1 USING (
					SELECT ACT.ACT_ID, AGR.AGR_ID FROM '||V_ESQUEMA||'.AUX_REMVIP_9857 AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
					JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AUX.AGR_NUM_AGRUP_REM = AGR.AGR_NUM_AGRUP_REM) T2
				ON (T1.ACT_ID = T2.ACT_ID AND T1.AGR_ID = T2.AGR_ID)
				WHEN MATCHED THEN UPDATE SET
					USUARIOMODIFICAR = '''||V_USU||''',
					FECHAMODIFICAR = SYSDATE,
					USUARIOBORRAR = NULL,
					FECHABORRAR = NULL,
					BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADAS '||SQL%ROWCOUNT||' AGRUPACIONES');

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
