--/*
--##########################################
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10738
--## PRODUCTO=NO
--## 
--## Finalidad: FORZAR REENVIO AGRUPACION ON Y ACTIVOS. Forzar envío API a SF
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-9174';

BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO] REENVIAR AGRUPACION WEBCOM' || V_USUARIO);

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.AWH_AGRUP_ONV_WEBCOM_HIST WHERE ID_AGRUPACION_REM = 110879';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS EN AWH_AGRUP_ONV_WEBCOM_HIST');

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.SWH_STOCK_ACT_WEBCOM_HIST WHERE ID_ACTIVO_HAYA IN (
                SELECT SWH.ID_ACTIVO_HAYA FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID 
                JOIN '||V_ESQUEMA||'.SWH_STOCK_ACT_WEBCOM_HIST SWH ON SWH.ID_ACTIVO_HAYA = ACT.ACT_NUM_ACTIVO
                WHERE AGR.AGR_NUM_AGRUP_REM = 110879)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS EN SWH_STOCK_ACT_WEBCOM_HIST');    
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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