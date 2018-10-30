--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2388
--## PRODUCTO=NO
--## 
--## Finalidad: Fusion activos
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= '';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2388';
    --ACT_NUM_ACTIVO NUMBER(16);
    --ACT_ID VARCHAR2(55 CHAR);

BEGIN

	      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de fusion de activos.');
		
	      V_SQL := 'MERGE INTO REM01.ACT_ACTIVO T1 
			USING ( 
			SELECT  
			ACT.ACT_ID AS ACT_ID 
			FROM REM01.TMP_BOLT_INVICTUS        TMP 
			JOIN REM01.ACT_ACTIVO               ACT 
			ON ACT.ACT_NUM_ACTIVO = TMP.ACT_NUM_ACTIVO 
			JOIN REM01.DD_CRA_CARTERA           CRA 
			ON CRA.DD_CRA_ID = ACT.DD_CRA_ID 
			JOIN REM01.DD_SCR_SUBCARTERA        SCR 
			ON SCR.DD_SCR_ID = ACT.DD_SCR_ID 
			WHERE SCR.DD_SCR_CODIGO = ''58'' 
			 AND CRA.DD_CRA_CODIGO = ''08''  
			) T2 
			ON (T1.ACT_ID = T2.ACT_ID) 
			WHEN MATCHED THEN 
			UPDATE SET  
			 T1.DD_SCR_ID = (SELECT DD_SCR_ID FROM REM01.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''56''), 
			 T1.USUARIOMODIFICAR = ''REMVIP-2388'', 
			 T1.FECHAMODIFICAR = SYSDATE';

	      EXECUTE IMMEDIATE V_SQL;
		
	      DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla de ACT_ACTIVO.');
	      COMMIT;

	      DBMS_OUTPUT.PUT_LINE('[FIN] Finaliza el proceso de fusion.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;

