--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190711
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4795
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar situación comercializar
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-4795';


 BEGIN

    DBMS_OUTPUT.PUT_LINE('	[INICIO]	');

	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1
				USING (

					SELECT ACT_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					WHERE 1 = 1
					AND EXISTS ( SELECT 1
					             FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
					             WHERE 1 = 1
					             AND PAC.ACT_ID = ACT.ACT_ID
						     AND PAC.PAC_INCLUIDO = 0
					             AND PAC.PAC_CHECK_COMERCIALIZAR = 1
					           )
					AND ACT.DD_SCM_ID <> ( SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''01'' )           
					AND ACT.DD_CRA_ID = ( SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''08'' )

				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET 
				    T1.PAC_CHECK_COMERCIALIZAR = 0,
				    T1.USUARIOMODIFICAR = ''REMVIP-4795'',
				    T1.FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('	[INFO]	'||SQL%ROWCOUNT||' activos con perímetro modificado');
 
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
				USING (

					SELECT ACT_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					WHERE 1 = 1
					AND EXISTS ( SELECT 1
					             FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
					             WHERE 1 = 1
					             AND PAC.ACT_ID = ACT.ACT_ID
						     AND PAC.PAC_INCLUIDO = 0
					             AND PAC.PAC_CHECK_COMERCIALIZAR = 0
					           )
					AND ACT.DD_SCM_ID <> ( SELECT DD_SCM_ID FROM REM01.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''01'' )           
					AND ACT.DD_CRA_ID = ( SELECT DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''08'' )

				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET 
				    T1.DD_SCM_ID = ( SELECT DD_SCM_ID FROM DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''01'' ),
				    T1.USUARIOMODIFICAR = ''REMVIP-4795'',
				    T1.FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_SQL;
	 DBMS_OUTPUT.PUT_LINE('[INFO] Actualizada situación comercial en '||SQL%ROWCOUNT||'  activos ' );
  
 COMMIT;
 
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
