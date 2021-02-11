--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210211
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8878
--## PRODUCTO=NO
--## 
--## Finalidad: PONER DD_DFA_ID
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
   V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
   V_USUARIO VARCHAR(25 CHAR) := 'REMVIP-8878';
   V_TABLA VARCHAR(25 CHAR) := 'ACT_FOT_FOTO';
 
BEGIN
   DBMS_OUTPUT.put_line('[INICIO]');

   DBMS_OUTPUT.PUT_LINE('[INFO] Actualizacion en '||V_TABLA||'');

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING (
               SELECT DISTINCT FOT.FOT_ID, DD.DD_DFA_ID 
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                  INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON (
                        TRIM(LOWER(TRANSLATE(DD.DD_DFA_DESCRIPCION,''ÁáÉéÍíÓóÚú'',''AaEeIiOoUu''))) = TRIM(LOWER(TRANSLATE(FOT.FOT_DESCRIPCION,''ÁáÉéÍíÓóÚú'',''AaEeIiOoUu'')))
                                                                                    )
                  WHERE DD.DD_SAC_ID = 23 AND FOT.SDV_ID IS NULL AND FOT.ACT_ID IS NULL AND FOT.BORRADO = 0 AND FOT.DD_DFA_ID IS NULL) T2
            ON (T1.FOT_ID = T2.FOT_ID)
            WHEN MATCHED THEN UPDATE SET
            DD_DFA_ID = T2.DD_DFA_ID,
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

   DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS AGRUPACIONES');

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING (
               SELECT DISTINCT FOT.FOT_ID, FOT.FOT_DESCRIPCION,DD.DD_DFA_DESCRIPCION, DD.DD_DFA_ID 
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                  INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON (
                        TRIM(LOWER(TRANSLATE(DD.DD_DFA_DESCRIPCION,''ÁáÉéÍíÓóÚú'',''AaEeIiOoUu''))) = TRIM(LOWER(TRANSLATE(FOT.FOT_DESCRIPCION,''ÁáÉéÍíÓóÚú'',''AaEeIiOoUu'')))
                                                                                    )
                  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = FOT.ACT_ID
                  INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_aCTIVO SAC ON SAC.DD_SAC_ID = DD.DD_sAC_ID AND ACT.DD_sAC_ID = SAC.DD_sAC_ID
                  WHERE FOT.SDV_ID IS NULL AND FOT.AGR_ID IS NULL AND FOT.BORRADO = 0  AND FOT.DD_DFA_ID IS NULL) T2
            ON (T1.FOT_ID = T2.FOT_ID)
            WHEN MATCHED THEN UPDATE SET
            DD_DFA_ID = T2.DD_DFA_ID,
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;


   DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS ACTIVOS');

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING (
               SELECT DISTINCT FOT.FOT_ID, FOT.FOT_DESCRIPCION,DD.DD_DFA_DESCRIPCION, DD.DD_DFA_ID 
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' FOT
                  INNER JOIN '||V_ESQUEMA||'.DD_DFA_DESCRIPCION_FOTO_ACTIVO DD ON (
                        TRIM(LOWER(TRANSLATE(DD.DD_DFA_DESCRIPCION,''ÁáÉéÍíÓóÚú'',''AaEeIiOoUu''))) = TRIM(LOWER(TRANSLATE(FOT.FOT_DESCRIPCION,''ÁáÉéÍíÓóÚú'',''AaEeIiOoUu'')))
                                                                                    )
                  inner join '||V_ESQUEMA||'.v_subdivisiones_agrupacion sub on sub.id = fot.sdv_id
                  INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_aCTIVO SAC ON SAC.DD_SAC_ID = DD.DD_sAC_ID AND sac.dd_sac_codigo = sub.cod_subtipo_activo
                  WHERE FOT.SDV_ID IS NOT NULL AND FOT.ACT_ID IS NULL AND FOT.BORRADO = 0  AND FOT.DD_DFA_ID IS NULL) T2
            ON (T1.FOT_ID = T2.FOT_ID)
            WHEN MATCHED THEN UPDATE SET
            DD_DFA_ID = T2.DD_DFA_ID,
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;


   DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS SUBDIVISIONES');
               
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]');

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
