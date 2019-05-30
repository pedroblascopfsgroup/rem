--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190516
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3842
--## PRODUCTO=NO
--##
--## Finalidad: Limpiar el rating de todos los activos que no sean viviendas
--##
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

 BEGIN
	 
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO T1 SET DD_RTG_ID = NULL, USUARIOMODIFICAR = ''REMVIP-3842'', FECHAMODIFICAR = SYSDATE
                WHERE EXISTS (
                    SELECT * FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                    JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
                    WHERE DD_RTG_ID IS NOT NULL
                    AND T1.ACT_ID = ACT.ACT_ID
                    AND ACT_NUM_ACTIVO IN (
                        7001446,
					    7002675,
					    7001208,
					    7002673,
					    7002671,
					    7002669,
					    7002260,
					    7001018,
					    7002160,
					    7002159,
					    7001980,
					    7001892,
					    7001838,
					    7001570,
					    7001452,
					    7002707,
					    7002704,
					    7002700,
					    7002670,
					    7002388,
					    7002382,
					    7002381,
					    7002375,
					    7002373,
					    7002349
                    )
                )';
	EXECUTE IMMEDIATE V_SQL;
	
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
