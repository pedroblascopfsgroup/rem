--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200705
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7713
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-7713';

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL :='MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA USING(
	SELECT AGA.AGA_ID FROM '||V_ESQUEMA||'.AUX_REMVIP_7713 TMP
	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = TMP.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_NUM_AGRUP_REM = TMP.AGR_NUM_AGRUPACION
	JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.AGR_ID = AGR.AGR_ID 
	) TMP ON (TMP.AGA_ID = AGA.AGA_ID)
	WHEN MATCHED THEN UPDATE SET
	AGA.BORRADO = 1,
        AGA.FECHABORRAR = SYSDATE,
	AGA.USUARIOBORRAR = ''REMVIP-7713''';

        EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se han modificado en total '||SQL%ROWCOUNT||' registros en la ACT_AGA_AGRUPACION_ACTIVO');
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
