--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210531
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9577
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar participación de activos
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9577'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ T1 USING (
					SELECT TBJ.TBJ_ID FROM REM01.ACT_TBJ_TRABAJO TBJ
					JOIN REM01.ACT_TBJ ATB ON TBJ.TBJ_ID = ATB.TBJ_ID 
					JOIN REM01.ACT_ACTIVO ACT ON ATB.ACT_ID = ACT.ACT_ID
					WHERE
					ATB.TBJ_ID IN (SELECT TBJ_ID FROM REM01.ACT_TBJ GROUP BY TBJ_ID HAVING COUNT (TBJ_ID) = 1)
					AND TBJ.DD_TTR_ID != 23 AND TBJ.DD_EST_ID NOT IN (2, 64) AND TBJ.BORRADO = 0 AND ACT_TBJ_PARTICIPACION != 100) T2
				ON (T1.TBJ_ID = T2.TBJ_ID)
				WHEN MATCHED THEN UPDATE SET
					ACT_TBJ_PARTICIPACION = 100';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADAS '||SQL%ROWCOUNT||' PARTICIPACIONES');

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
