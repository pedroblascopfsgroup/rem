--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5741
--## PRODUCTO=NO
--## 
--## Finalidad:
--##
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
	V_USUARIO VARCHAR2(40 CHAR) := 'REMVIP-5741'; --Vble. para el usuario REMVIP.
   
BEGIN

	DBMS_OUTPUT.put_line('[INICIO]');

	V_SQL := 'MERGE INTO REM01.ACT_ACTIVO T1
				USING (
				    SELECT AUX.ACT_NUM_UVEM, RTG.DD_RTG_ID
				    FROM REM01.AUX_REMVIP_5741 AUX 
				    JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_UVEM = AUX.ACT_NUM_UVEM 
				    JOIN REM01.DD_RTG_RATING_ACTIVO RTG ON AUX.COD_RATING = RTG.DD_RTG_CODIGO 
				) T2
				ON (T1.ACT_NUM_ACTIVO_UVEM = T2.ACT_NUM_UVEM)
				WHEN MATCHED THEN UPDATE SET
					T1.DD_RTG_ID = T2.DD_RTG_ID
				       ,USUARIOMODIFICAR = '''||V_USUARIO||''' 
				       ,FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se ha ACTUALIZADO el rating para '||SQL%ROWCOUNT||' activos');

 	COMMIT;
	DBMS_OUTPUT.put_line('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
