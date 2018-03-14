--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK=REMVIP-185
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-185';

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T1
		USING (SELECT AGA.AGA_ID
		    FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
		    JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID
		    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID
		    WHERE (ACT.ACT_NUM_ACTIVO_UVEM, AGR.AGR_NUM_AGRUP_REM) 
		        IN ((''9591234'',''1000001826''), (''5964762'', ''1000001945''), (''5184455'', ''1000001945''))
		        AND AGA.BORRADO = 0) T2
		ON (T1.AGA_ID = T2.AGA_ID)
		WHEN MATCHED THEN UPDATE SET
		    T1.BORRADO = 1, T1.USUARIOBORRAR = '''||V_USUARIO||''', T1.FECHABORRAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' activos sacados de agrupaciones');

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.PUT_LINE(ERR_MSG);
      ROLLBACK;
      RAISE;
END;
/
EXIT;