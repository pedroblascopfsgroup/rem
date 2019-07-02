--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190626
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3842
--## PRODUCTO=NO
--## 
--## Finalidad: [REMVIP-3842] Calcular el rating
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
	V_USUARIO VARCHAR2(40 CHAR) := 'REMVIP-3842'; --Vble. para el usuario REMVIP.
   
BEGIN

	DBMS_OUTPUT.put_line('[INICIO]');

    V_SQL := 'MERGE INTO REM01.ACT_ACTIVO T1
				USING (
					SELECT ACT_ID FROM REM01.ACT_ACTIVO WHERE DD_RTG_ID IS NOT NULL AND DD_TPA_ID <> 2
				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					DD_RTG_ID = NULL
					,USUARIOMODIFICAR = '''||V_USUARIO||'''
					,FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se ha eliminado el rating para '||SQL%ROWCOUNT||' activos de tipo distinto a vivienda');

	V_SQL := 'MERGE INTO REM01.ACT_ACTIVO T1
				USING (
					SELECT * FROM REM01.ACT_ACTIVO ACT
					WHERE ACT.DD_RTG_ID IS NOT NULL AND DD_TPA_ID = 2 AND BORRADO = 0
					AND NOT EXISTS (
						SELECT * FROM REM01.ACT_HIC_EST_INF_COMER_HIST EST
						JOIN REM01.DD_AIC_ACCION_INF_COMERCIAL AIC ON AIC.DD_AIC_ID = EST.DD_AIC_ID
						WHERE AIC.DD_AIC_CODIGO = ''02'' AND EST.ACT_ID = ACT.ACT_ID
					)
				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					DD_RTG_ID = NULL
					,USUARIOMODIFICAR = '''||V_USUARIO||'''
					,FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se ha eliminado el rating para '||SQL%ROWCOUNT||' activos cuyo informe comercial no había sido aprobado');

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
