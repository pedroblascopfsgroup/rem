--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190222
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3322
--## PRODUCTO=NO
--## 
--## Finalidad: Actuaciones sobre el histórico en función del nuevo funcionamiento
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-3322'; -- Usuario modificar
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
    -- LIMPIAR FECHAS HISTÓRICO ------------------------------------------------
    
	DBMS_OUTPUT.PUT_LINE('	[INFO]	Inicio limpieza fechas histórico venta');
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION
              SET AHP_FECHA_INI_VENTA = NULL
                 ,AHP_FECHA_FIN_VENTA = NULL
                 ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                 ,FECHAMODIFICAR = SYSDATE
              WHERE (AHP_FECHA_INI_VENTA IS NOT NULL OR AHP_FECHA_FIN_VENTA IS NOT NULL)
              AND DD_TCO_ID = 3';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('	[INFO]	Inicio limpieza fechas histórico alquiler');
    
    V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION
              SET AHP_FECHA_INI_ALQUILER = NULL
                 ,AHP_FECHA_FIN_ALQUILER = NULL
                 ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                 ,FECHAMODIFICAR = SYSDATE
              WHERE (AHP_FECHA_INI_ALQUILER IS NOT NULL OR AHP_FECHA_FIN_ALQUILER IS NOT NULL)
              AND DD_TCO_ID = 1';
    EXECUTE IMMEDIATE V_SQL;
    
    -- FECHA_FIN REGISTRO A NULL -----------------------------------------------
    
    DBMS_OUTPUT.PUT_LINE('	[INFO]	Inicio update fecha fin venta null');
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    WITH HIST AS (
                        SELECT DISTINCT AHP.ACT_ID, AHP.AHP_ID, AHP.AHP_FECHA_INI_VENTA, AHP.AHP_FECHA_FIN_VENTA,
                        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_FECHA_INI_VENTA ASC) RN
                        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        WHERE AHP.DD_TCO_ID in (1,2)
                        AND AHP.BORRADO = 0
                        ORDER BY 1,2,3,5
                    )
                    SELECT DISTINCT H.ACT_ID, H.AHP_ID, H.AHP_FECHA_INI_VENTA, H.AHP_FECHA_FIN_VENTA, H.RN, 
                           CASE WHEN RN = 1 THEN H.AHP_FECHA_FIN_VENTA 
                           ELSE (SELECT AHP_FECHA_FIN_VENTA FROM HIST WHERE ACT_ID = AHP.ACT_ID AND RN = H.RN+1) 
                           END AS FECHA_FIN_NUEVA
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
                    WHERE H.AHP_FECHA_INI_VENTA IS NOT NULL AND H.AHP_FECHA_FIN_VENTA IS NULL
                    AND AHP.DD_TCO_ID in (1,2)
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET 
                    T1.AHP_FECHA_FIN_VENTA = T2.FECHA_FIN_NUEVA
                    ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,FECHAMODIFICAR = SYSDATE
                WHERE T2.FECHA_FIN_NUEVA IS NOT NULL';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('	[INFO]	Inicio update fecha fin alquiler null');
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    WITH HIST AS (
                        SELECT DISTINCT AHP.ACT_ID, AHP.AHP_ID, AHP.AHP_FECHA_INI_ALQUILER, AHP.AHP_FECHA_FIN_ALQUILER,
                        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_FECHA_INI_ALQUILER ASC) RN
                        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        WHERE AHP.DD_TCO_ID in (2,3)
                        AND AHP.BORRADO = 0
                        ORDER BY 1,2,3,5
                    )
                    SELECT DISTINCT H.ACT_ID, H.AHP_ID, H.AHP_FECHA_INI_ALQUILER, H.AHP_FECHA_FIN_ALQUILER, H.RN, 
                           CASE WHEN RN = 1 THEN H.AHP_FECHA_FIN_ALQUILER 
                           ELSE (SELECT AHP_FECHA_FIN_ALQUILER FROM HIST WHERE ACT_ID = AHP.ACT_ID AND RN = H.RN+1) 
                           END AS FECHA_FIN_NUEVA
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
                    WHERE H.AHP_FECHA_INI_ALQUILER IS NOT NULL AND H.AHP_FECHA_FIN_ALQUILER IS NULL
                    AND AHP.DD_TCO_ID in (2,3)
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET 
                    T1.AHP_FECHA_FIN_ALQUILER = T2.FECHA_FIN_NUEVA
                    ,USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,FECHAMODIFICAR = SYSDATE
                WHERE T2.FECHA_FIN_NUEVA IS NOT NULL';
    EXECUTE IMMEDIATE V_SQL;
    
    -- CUADRAR FECHA_INI CON FECHA_FIN ANTERIOR --------------------------------
    
    DBMS_OUTPUT.PUT_LINE('	[INFO]	Inicio cuadrar fecha_ini_venta con fecha_fin_venta anterior');
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    WITH HIST AS (
                        SELECT DISTINCT AHP.ACT_ID, AHP.AHP_ID, AHP.AHP_FECHA_INI_VENTA, AHP.AHP_FECHA_FIN_VENTA,
                        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_FECHA_FIN_VENTA ASC) RN
                        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        AND AHP.BORRADO = 0
                        ORDER BY 1,2,3,5
                    )
                    SELECT DISTINCT H.ACT_ID, H.AHP_ID, H.AHP_FECHA_INI_VENTA, H.AHP_FECHA_FIN_VENTA, H.RN, 
                           CASE WHEN RN = 1 AND H.AHP_FECHA_INI_VENTA IS NULL THEN H.AHP_FECHA_FIN_VENTA 
                           ELSE (SELECT AHP_FECHA_FIN_VENTA FROM HIST WHERE ACT_ID = AHP.ACT_ID AND RN = H.RN-1) 
                           END AS FECHA_INI_NUEVA
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
                    AND AHP.DD_TCO_ID in (1,2)
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.AHP_FECHA_INI_VENTA = T2.FECHA_INI_NUEVA
                    ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,T1.FECHAMODIFICAR = SYSDATE
                WHERE T2.FECHA_INI_NUEVA IS NOT NULL
				AND T1.DD_TCO_ID IN (1,2)';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('	[INFO]	Inicio cuadrar fecha_ini_alquiler con fecha_fin_alquiler anterior');
    
    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
                USING (
                    WITH HIST AS (
                        SELECT DISTINCT AHP.ACT_ID, AHP.AHP_ID, AHP.AHP_FECHA_INI_ALQUILER, AHP.AHP_FECHA_FIN_ALQUILER,
                        ROW_NUMBER() OVER (PARTITION BY AHP.ACT_ID ORDER BY AHP.AHP_FECHA_FIN_ALQUILER ASC) RN
                        FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        AND AHP.BORRADO = 0
                        ORDER BY 1,2,3,5
                    )
                    SELECT DISTINCT H.ACT_ID, H.AHP_ID, H.AHP_FECHA_INI_ALQUILER, H.AHP_FECHA_FIN_ALQUILER, H.RN, 
                           CASE WHEN RN = 1  AND H.AHP_FECHA_INI_ALQUILER IS NULL THEN H.AHP_FECHA_FIN_ALQUILER 
                           ELSE (SELECT AHP_FECHA_FIN_ALQUILER FROM HIST WHERE ACT_ID = AHP.ACT_ID AND RN = H.RN-1) 
                           END AS FECHA_INI_NUEVA
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN HIST H ON AHP.ACT_ID = H.ACT_ID
                    AND AHP.DD_TCO_ID in (2,3)
                ) T2
                ON (T1.AHP_ID = T2.AHP_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.AHP_FECHA_INI_ALQUILER = T2.FECHA_INI_NUEVA
                    ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,T1.FECHAMODIFICAR = SYSDATE
                WHERE T2.FECHA_INI_NUEVA IS NOT NULL
				AND T1.DD_TCO_ID IN (2,3)';
    EXECUTE IMMEDIATE V_SQL;
    
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