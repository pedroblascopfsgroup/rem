--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190312
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3555
--## PRODUCTO=NO
--## 
--## Finalidad: Unificar registros AHP seguidos con el mismo estado de publicación
--##
--## INSTRUCCIONES:  
--## VERSIONES:i pjut
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-3555'; -- Usuario modificar
    
BEGIN	
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('	[INFO]	Inicio unificar registros seguidos con el mismo estado de publicación venta');
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    WITH HIST AS (
                        SELECT DISTINCT AHP.AHP_ID, AHP.ACT_ID, AHP.AHP_FECHA_INI_VENTA, AHP.AHP_FECHA_FIN_VENTA, AHP.DD_EPV_ID, AHP.DD_MTO_V_ID,
                        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_FECHA_INI_VENTA, AHP.AHP_FECHA_FIN_VENTA ASC) RN
                        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        WHERE ((AHP.AHP_FECHA_INI_VENTA IS NOT NULL OR AHP.AHP_FECHA_FIN_VENTA IS NOT NULL) AND DD_TCO_ID IN (1,2))
                        AND AHP.BORRADO = 0
                        ORDER BY 1,2,3,5
                    )
                    SELECT DISTINCT H.AHP_ID, H.RN,
                        CASE 
                            WHEN H0.DD_EPV_ID = H.DD_EPV_ID AND H2.DD_EPV_ID = H.DD_EPV_ID THEN
                                CASE
                                    WHEN H.DD_EPV_ID = 4 THEN 
                                        CASE
                                            WHEN H0.DD_MTO_V_ID = H.DD_MTO_V_ID AND H2.DD_MTO_V_ID = H.DD_MTO_V_ID THEN 1
                                            ELSE 0
                                        END
                                    ELSE 1
                                END
                            ELSE 0
                        END AS BORRAR_FILA
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
                    LEFT JOIN HIST H0 ON AHP.ACT_ID = H0.ACT_ID AND H0.RN = H.RN-1
                    LEFT JOIN HIST H2 ON AHP.ACT_ID = H2.ACT_ID AND H2.RN = H.RN+1
                    WHERE AHP.DD_TCO_ID in (1,2)
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.BORRADO = 1
                    ,T1.USUARIOBORRAR = '''||V_USUARIO||'''
                    ,T1.FECHABORRAR = SYSDATE
                WHERE T2.BORRAR_FILA = 1';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    WITH HIST AS (
                        SELECT DISTINCT AHP.AHP_ID, AHP.ACT_ID, AHP.AHP_FECHA_INI_VENTA, AHP.AHP_FECHA_FIN_VENTA, AHP.DD_EPV_ID, AHP.DD_MTO_V_ID,
                        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_FECHA_INI_VENTA, AHP.AHP_FECHA_FIN_VENTA ASC) RN
                        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        WHERE ((AHP.AHP_FECHA_INI_VENTA IS NOT NULL OR AHP.AHP_FECHA_FIN_VENTA IS NOT NULL) AND DD_TCO_ID IN (1,2))
                        AND AHP.BORRADO = 0
                        ORDER BY 1,2,3,5
                    )
                    SELECT DISTINCT H.AHP_ID, H.AHP_FECHA_INI_VENTA, H.AHP_FECHA_FIN_VENTA, H.RN, H2.AHP_FECHA_FIN_VENTA AS FECHA_FIN_NUEVA,
                        CASE 
                            WHEN H2.DD_EPV_ID = H.DD_EPV_ID THEN
                                CASE
                                    WHEN H.DD_EPV_ID = 4 THEN 
                                        CASE
                                            WHEN H2.DD_MTO_V_ID = H.DD_MTO_V_ID THEN 1
                                            ELSE 0
                                        END
                                    ELSE 1
                                END
                            ELSE 0
                        END AS ACTUALIZAR
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
                    LEFT JOIN HIST H2 ON AHP.ACT_ID = H2.ACT_ID AND H2.RN = H.RN+1
                    WHERE AHP.DD_TCO_ID in (1,2)
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.AHP_FECHA_FIN_VENTA = T2.FECHA_FIN_NUEVA
                    ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,T1.FECHAMODIFICAR = SYSDATE
                WHERE T2.ACTUALIZAR = 1';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    WITH HIST AS (
                        SELECT DISTINCT AHP.AHP_ID, AHP.ACT_ID, AHP.AHP_FECHA_INI_VENTA, AHP.AHP_FECHA_FIN_VENTA, AHP.DD_EPV_ID, AHP.DD_MTO_V_ID,
                        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_FECHA_INI_VENTA, AHP.AHP_FECHA_FIN_VENTA ASC) RN
                        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        WHERE ((AHP.AHP_FECHA_INI_VENTA IS NOT NULL OR AHP.AHP_FECHA_FIN_VENTA IS NOT NULL) AND DD_TCO_ID IN (1,2))
                        AND AHP.BORRADO = 0
                        ORDER BY 1,2,3,5
                    )
                    SELECT DISTINCT H.AHP_ID, H.AHP_FECHA_INI_VENTA, H.AHP_FECHA_FIN_VENTA, H.RN,
                        CASE 
                            WHEN H2.DD_EPV_ID = H.DD_EPV_ID THEN
                                CASE
                                    WHEN H.DD_EPV_ID = 4 THEN 
                                        CASE
                                            WHEN H2.DD_MTO_V_ID = H.DD_MTO_V_ID THEN 1
                                            ELSE 0
                                        END
                                    ELSE 1
                                END
                            ELSE 0
                        END AS BORRAR_FILA
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
                    LEFT JOIN HIST H2 ON AHP.ACT_ID = H2.ACT_ID AND H2.RN = H.RN-1
                    WHERE AHP.DD_TCO_ID in (1,2)
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.BORRADO = 1
                    ,T1.USUARIOBORRAR = '''||V_USUARIO||'''
                    ,T1.FECHABORRAR = SYSDATE
                WHERE T2.BORRAR_FILA = 1';
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('	[INFO]	Inicio unificar registros seguidos con el mismo estado de publicación alquiler');
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    WITH HIST AS (
                        SELECT DISTINCT AHP.AHP_ID, AHP.ACT_ID, AHP.AHP_FECHA_INI_ALQUILER, AHP.AHP_FECHA_FIN_ALQUILER, AHP.DD_EPA_ID, AHP.DD_MTO_A_ID,
                        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_FECHA_INI_ALQUILER, AHP.AHP_FECHA_FIN_ALQUILER ASC) RN
                        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        WHERE ((AHP.AHP_FECHA_INI_ALQUILER IS NOT NULL OR AHP.AHP_FECHA_FIN_ALQUILER IS NOT NULL) AND DD_TCO_ID IN (2,3))
                        AND AHP.BORRADO = 0
                        ORDER BY 1,2,3,5
                    )
                    SELECT DISTINCT H.AHP_ID, H.RN,
                        CASE 
                            WHEN H0.DD_EPA_ID = H.DD_EPA_ID AND H2.DD_EPA_ID = H.DD_EPA_ID THEN
                                CASE
                                    WHEN H.DD_EPA_ID = 4 THEN 
                                        CASE
                                            WHEN H0.DD_MTO_A_ID = H.DD_MTO_A_ID AND H2.DD_MTO_A_ID = H.DD_MTO_A_ID THEN 1
                                            ELSE 0
                                        END
                                    ELSE 1
                                END
                            ELSE 0
                        END AS BORRAR_FILA
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
                    LEFT JOIN HIST H0 ON AHP.ACT_ID = H0.ACT_ID AND H0.RN = H.RN-1
                    LEFT JOIN HIST H2 ON AHP.ACT_ID = H2.ACT_ID AND H2.RN = H.RN+1
                    WHERE AHP.DD_TCO_ID IN (2,3)
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.BORRADO = 1
                    ,T1.USUARIOBORRAR = '''||V_USUARIO||'''
                    ,T1.FECHABORRAR = SYSDATE
                WHERE T2.BORRAR_FILA = 1';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    WITH HIST AS (
                        SELECT DISTINCT AHP.AHP_ID, AHP.ACT_ID, AHP.AHP_FECHA_INI_ALQUILER, AHP.AHP_FECHA_FIN_ALQUILER, AHP.DD_EPA_ID, AHP.DD_MTO_A_ID,
                        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_FECHA_INI_ALQUILER, AHP.AHP_FECHA_FIN_ALQUILER ASC) RN
                        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        WHERE ((AHP.AHP_FECHA_INI_ALQUILER IS NOT NULL OR AHP.AHP_FECHA_FIN_ALQUILER IS NOT NULL) AND DD_TCO_ID IN (2,3))
                        AND AHP.BORRADO = 0
                        ORDER BY 1,2,3,5
                    )
                    SELECT DISTINCT H.AHP_ID, H.AHP_FECHA_INI_ALQUILER, H.AHP_FECHA_FIN_ALQUILER, H.RN, H2.AHP_FECHA_FIN_ALQUILER AS FECHA_FIN_NUEVA,
                        CASE 
                            WHEN H2.DD_EPA_ID = H.DD_EPA_ID THEN
                                CASE
                                    WHEN H.DD_EPA_ID = 4 THEN 
                                        CASE
                                            WHEN H2.DD_MTO_A_ID = H.DD_MTO_A_ID THEN 1
                                            ELSE 0
                                        END
                                    ELSE 1
                                END
                            ELSE 0
                        END AS ACTUALIZAR
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
                    LEFT JOIN HIST H2 ON AHP.ACT_ID = H2.ACT_ID AND H2.RN = H.RN+1
                    WHERE AHP.DD_TCO_ID IN (2,3)
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.AHP_FECHA_FIN_ALQUILER = T2.FECHA_FIN_NUEVA
                    ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,T1.FECHAMODIFICAR = SYSDATE
                WHERE T2.ACTUALIZAR = 1';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    WITH HIST AS (
                        SELECT DISTINCT AHP.AHP_ID, AHP.ACT_ID, AHP.AHP_FECHA_INI_ALQUILER, AHP.AHP_FECHA_FIN_ALQUILER, AHP.DD_EPA_ID, AHP.DD_MTO_A_ID,
                        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_FECHA_INI_ALQUILER, AHP.AHP_FECHA_FIN_ALQUILER ASC) RN
                        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        WHERE ((AHP.AHP_FECHA_INI_ALQUILER IS NOT NULL OR AHP.AHP_FECHA_FIN_ALQUILER IS NOT NULL) AND DD_TCO_ID IN (2,3))
                        AND AHP.BORRADO = 0
                        ORDER BY 1,2,3,5
                    )
                    SELECT DISTINCT H.AHP_ID, H.AHP_FECHA_INI_ALQUILER, H.AHP_FECHA_FIN_ALQUILER, H.RN,
                        CASE 
                            WHEN H2.DD_EPA_ID = H.DD_EPA_ID THEN
                                CASE
                                    WHEN H.DD_EPA_ID = 4 THEN 
                                        CASE
                                            WHEN H2.DD_MTO_A_ID = H.DD_MTO_A_ID THEN 1
                                            ELSE 0
                                        END
                                    ELSE 1
                                END
                            ELSE 0
                        END AS BORRAR_FILA
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
                    LEFT JOIN HIST H2 ON AHP.ACT_ID = H2.ACT_ID AND H2.RN = H.RN-1
                    WHERE AHP.DD_TCO_ID IN (2,3)
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.BORRADO = 1
                    ,T1.USUARIOBORRAR = '''||V_USUARIO||'''
                    ,T1.FECHABORRAR = SYSDATE
                WHERE T2.BORRAR_FILA = 1';
    EXECUTE IMMEDIATE V_MSQL;
    
	COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;

/
EXIT;