--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20201021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8002
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_FOT_FOTO';
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP_8002';
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    DBMS_OUTPUT.PUT_LINE('[ACTUALIZAMOS DESCRIPCIONES FOTOS]');

    DBMS_OUTPUT.PUT_LINE('[AGRUPACIONES]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (SELECT DISTINCT FOT.FOT_ID,DD.DD_DFA_ID
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                    INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON DD.SAC_ID = 23
                    WHERE FOT.BORRADO = 0 AND FOT.ACT_ID IS NULL AND FOT.SDV_ID IS NULL
                    AND LOWER(DD.DD_DFA_DESCRIPCION) = LOWER(FOT.FOT_DESCRIPCION)) T2
                    ON (T1.FOT_ID = T2.FOT_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.DD_DFA_ID = T2.DD_DFA_ID,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');
    COMMIT;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (SELECT DISTINCT FOT.FOT_ID, DD.DD_DFA_ID
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                    INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON DD.DD_SAC_ID = 23
                    WHERE FOT.BORRADO = 0 AND FOT.DD_DFA_ID IS NULL AND FOT.ACT_ID IS NULL AND FOT.SDV_ID IS NULL
                    AND DD.DD_DFA_DESCRIPCION = ''Otros'') T2
                    ON (T1.FOT_ID = T2.FOT_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.DD_DFA_ID = T2.DD_DFA_ID,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[SUBDIVISIONES]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (SELECT DISTINCT FOT.FOT_ID, DD.DD_DFA_ID
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                    INNER JOIN '||V_ESQUEMA||'.V_SUBDIVISIONES_AGRUPACION VIS ON FOT.SDV_ID = VIS.ID
                    INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_aCTIVO SAC ON SAC.DD_SAC_CODIGO = vis.COD_SUBTIPO_ACTIVO
                    INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON sac.dd_sac_id = dd.DD_sac_id
                    WHERE FOT.BORRADO = 0 AND FOT.ACT_ID IS NULL AND FOT.SDV_ID IS NOT NULL
                    AND LOWER(dd.DD_DFA_DESCRIPCION) = LOWER(FOT.FOT_DESCRIPCION)) T2
                    ON (T1.FOT_ID = T2.FOT_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.DD_DFA_ID = T2.DD_DFA_ID,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (SELECT DISTINCT FOT.FOT_ID, DD.DD_DFA_ID
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                    INNER JOIN '||V_ESQUEMA||'.V_SUBDIVISIONES_AGRUPACION VIS ON FOT.SDV_ID = VIS.ID
                    INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_aCTIVO SAC ON SAC.DD_SAC_CODIGO = vis.COD_SUBTIPO_ACTIVO
                    INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON sac.dd_sac_id = dd.sac_id
                    WHERE FOT.BORRADO = 0 AND FOT.DD_DFA_ID IS NULL AND FOT.ACT_ID IS NULL AND FOT.SDV_ID IS NOT NULL
                    AND dd.DD_DFA_DESCRIPCION = ''Otros'' ) T2
                    ON (T1.FOT_ID = T2.FOT_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.DD_DFA_ID = T2.DD_DFA_ID,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[ACTIVOS]');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (SELECT DISTINCT FOT.FOT_ID, DD.DD_DFA_ID
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = FOT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.AUX_REMVIP_8002 AUX ON AUX.DESCRIPCION = FOT.FOT_DESCRIPCION
                    INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_aCTIVO TPA ON TPA.DD_TPA_dESCRIPCION = AUX.TIPO_ACTIVO and tpa.dd_tpa_id = act.dd_tpa_id
                    INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_aCTIVO SAC ON SAC.DD_SAC_dESCRIPCION = AUX.SUBTIPO_ACTIVO and sac.dd_sac_id = act.dd_sac_id
                    INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON DD.DD_DFA_DESCRIPCION = AUX.NUEVA_DESCRIPCION and sac.dd_sac_id = dd.dd_sac_id and tpa.dd_tpa_id = dd.dd_tpa_id
                    WHERE FOT.ACT_ID IS NOT NULL AND FOT.BORRADO = 0 AND ACT.BORRADO = 0 AND FOT.AGR_ID IS NULL AND FOT.SDV_ID IS NULL) T2
                    ON (T1.FOT_ID = T2.FOT_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.DD_DFA_ID = T2.DD_DFA_ID,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');
    COMMIT;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (SELECT DISTINCT FOT.FOT_ID, DD.DD_DFA_ID
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = FOT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_aCTIVO TPA ON tpa.dd_tpa_id = act.dd_tpa_id
                    INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_aCTIVO SAC ON sac.dd_sac_id = act.dd_sac_id
                    INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON sac.dd_sac_id = dd.dd_sac_id and tpa.dd_tpa_id = dd.dd_tpa_id
                    WHERE FOT.BORRADO = 0 AND FOT.DD_DFA_ID IS NULL AND ACT.BORRADO = 0 AND FOT.AGR_ID IS NULL AND FOT.SDV_ID IS NULL
                    AND DD.DD_DFA_DESCRIPCION = ''Otros'') T2
                    ON (T1.FOT_ID = T2.FOT_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.DD_DFA_ID = T2.DD_DFA_ID,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');
    COMMIT;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (SELECT DISTINCT FOT.FOT_ID, DD.DD_DFA_ID
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = FOT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_aCTIVO TPA ON tpa.dd_tpa_id = act.dd_tpa_id
                    INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_aCTIVO SAC ON sac.dd_sac_id = act.dd_sac_id
                    INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON sac.dd_sac_id = dd.dd_sac_id and tpa.dd_tpa_id = dd.dd_tpa_id
                    WHERE FOT.BORRADO = 0 AND ACT.BORRADO = 0 AND FOT.AGR_ID IS not NULL AND FOT.SDV_ID IS NOT NULL
                    AND LOWER(dd.DD_DFA_DESCRIPCION) = LOWER(FOT.FOT_DESCRIPCION)) T2
                    ON (T1.FOT_ID = T2.FOT_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.DD_DFA_ID = T2.DD_DFA_ID,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');
    COMMIT;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 
                    USING (SELECT DISTINCT FOT.FOT_ID, DD.DD_DFA_ID
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = FOT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_aCTIVO TPA ON tpa.dd_tpa_id = act.dd_tpa_id
                    INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_aCTIVO SAC ON sac.dd_sac_id = act.dd_sac_id
                    INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON sac.dd_sac_id = dd.dd_sac_id and tpa.dd_tpa_id = dd.dd_tpa_id
                    WHERE FOT.BORRADO = 0 AND FOT.DD_DFA_ID IS NULL AND ACT.BORRADO = 0 AND FOT.AGR_ID IS not NULL AND FOT.SDV_ID IS NOT NULL
                    AND DD.DD_DFA_DESCRIPCION = ''Otros'') T2
                    ON (T1.FOT_ID = T2.FOT_ID)
                    WHEN MATCHED THEN UPDATE SET 
                    T1.DD_DFA_ID = T2.DD_DFA_ID,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                    T1.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');
    COMMIT;

 DBMS_OUTPUT.PUT_LINE('[FIN]' );

			 
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
