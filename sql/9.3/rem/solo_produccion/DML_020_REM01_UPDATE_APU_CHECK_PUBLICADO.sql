--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190717
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4781
--## PRODUCTO=NO
--## 
--## Finalidad: [REMVIP-4781] Incongruencia activos no publicados con check de publicado marcados
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
	V_USUARIO VARCHAR2(40 CHAR) := 'REMVIP-4781'; --Vble. para el usuario REMVIP.

BEGIN

	DBMS_OUTPUT.put_line('[INICIO]');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION T1
				USING (
					SELECT ACT.ACT_ID 
					FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID
					WHERE ACT.BORRADO = 0
					AND DD_EPV_ID = 1
					AND APU.DD_TCO_ID IN (1,2)
					AND (APU_CHECK_PUBLICAR_V = 1 OR APU_CHECK_OCULTAR_V = 1)
				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.APU_CHECK_PUBLICAR_V = 0
					,T1.APU_CHECK_OCULTAR_V = 0
					,T1.APU_MOT_OCULTACION_MANUAL_V = NULL
					,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
					,T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.put_line('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' activos de venta.');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION T1
				USING (
					SELECT ACT.ACT_ID 
					FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = APU.ACT_ID
					WHERE ACT.BORRADO = 0
					AND DD_EPA_ID = 1
					AND APU.DD_TCO_ID IN (2,3)
					AND (APU_CHECK_PUBLICAR_A = 1 OR APU_CHECK_OCULTAR_A = 1)
				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.APU_CHECK_PUBLICAR_A = 0
					,T1.APU_CHECK_OCULTAR_A = 0
					,T1.APU_MOT_OCULTACION_MANUAL_A = NULL
					,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
					,T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.put_line('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' activos de alquiler.');

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
