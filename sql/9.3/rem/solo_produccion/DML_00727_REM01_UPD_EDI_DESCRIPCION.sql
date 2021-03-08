--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210303
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9090
--## PRODUCTO=NO
--## 
--## Finalidad: DESCRIPCION DE EDIFICIO ACTUALIZAR 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##        0.2 Reemplazar <BR> por CHR(10)
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
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP-9090';

BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_EDI_EDIFICIO T1 USING (
                SELECT DISTINCT EDI.EDI_ID, AUX.EDI_DESCRIPCION FROM '||V_ESQUEMA||'.act_activo act
                join '||V_ESQUEMA||'.act_ico_info_comercial ico on ico.act_id = act.act_id and ICO.BORRADO = 0
                join '||V_ESQUEMA||'.act_edi_edificio edi on ico.ico_id = edi.ico_id AND EDI.BORRADO = 0
                JOIN '||V_ESQUEMA||'.AUX_REMVIP_9090 AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
                WHERE ACT.BORRADO = 0 AND EDI.EDI_DESCRIPCION != AUX.EDI_DESCRIPCION
                ) T2
            ON (T1.EDI_ID = T2.EDI_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.EDI_DESCRIPCION = SUBSTR(REPLACE(T2.EDI_DESCRIPCION, ''<BR>'', CHR(10)),1,3000),
            T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado '||SQL%ROWCOUNT||' registros ');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.act_ico_info_comercial T1 USING (
                SELECT DISTINCT ICO.ICO_ID FROM '||V_ESQUEMA||'.act_activo act
                join '||V_ESQUEMA||'.act_ico_info_comercial ico on ico.act_id = act.act_id and ICO.BORRADO = 0
                JOIN '||V_ESQUEMA||'.AUX_REMVIP_9090 AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
                WHERE ACT.BORRADO = 0
                ) T2
            ON (T1.ICO_ID = T2.ICO_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.ICO_INFO_DISTRIBUCION_INTERIOR = NULL';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Eliminado distribucion interior en '||SQL%ROWCOUNT||' registros de act_ico_info_comercial');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_VIV_VIVIENDA T1 USING (
                SELECT DISTINCT VIV.ICO_ID FROM '||V_ESQUEMA||'.act_activo act
                join '||V_ESQUEMA||'.act_ico_info_comercial ico on ico.act_id = act.act_id and ICO.BORRADO = 0
                JOIN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIV ON VIV.ICO_ID = ICO.ICO_ID
                JOIN '||V_ESQUEMA||'.AUX_REMVIP_9090 AUX ON AUX.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO
                WHERE ACT.BORRADO = 0
                ) T2
            ON (T1.ICO_ID = T2.ICO_ID)
            WHEN MATCHED THEN UPDATE SET
            T1.VIV_DISTRIBUCION_TXT = NULL';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Eliminado distribucion interior en '||SQL%ROWCOUNT||' registros de act_viv_vivienda');
    
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