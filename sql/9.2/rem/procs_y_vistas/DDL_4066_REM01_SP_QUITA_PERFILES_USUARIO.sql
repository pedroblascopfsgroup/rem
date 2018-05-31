--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180530
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-926
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

CREATE OR REPLACE PROCEDURE #ESQUEMA#.QUITA_PERFIL_USUARIO (
    V_USUARIO    IN VARCHAR2
    , V_USU_USER IN VARCHAR2
    , V_COD_PERF IN VARCHAR2
    , PL_OUTPUT OUT VARCHAR2
) AS

    V_ESQUEMA   VARCHAR2(25 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';
    V_MSQL      VARCHAR2(4000 CHAR);
    V_CODIGOS_P VARCHAR2(2000 CHAR);
    V_CODIGOS_U VARCHAR2(2000 CHAR);

BEGIN

    V_CODIGOS_P := REPLACE(V_COD_PERF,',', ''',''');
    V_CODIGOS_U := REPLACE(V_USU_USER,',', ''',''');

    PL_OUTPUT := '[INICIO]' || CHR(10);
    
    IF V_USU_USER IS NOT NULL AND V_COD_PERF IS NOT NULL THEN
        V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ZON_PEF_USU ZPU WHERE EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
            JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON PEF.PEF_CODIGO IN ('''||V_CODIGOS_P||''')
            WHERE ZPU.USU_ID = USU.USU_ID AND USU.USU_USERNAME IN ('''||V_CODIGOS_U||''')
                AND PEF.PEF_ID = ZPU.PEF_ID)';
        EXECUTE IMMEDIATE V_MSQL;
        PL_OUTPUT := PL_OUTPUT || '   [INFO] '||SQL%ROWCOUNT|| ' perfil/es ' || V_COD_PERF || ' eliminados para ' || V_USU_USER || CHR(10);
    ELSE
        PL_OUTPUT := PL_OUTPUT || '   [INFO] No se han eliminado perfiles para ningún usuario. Revise el/los perfil/es y/o usuario/s proporcionados' || CHR(10);
    END IF;
            
    PL_OUTPUT := PL_OUTPUT || '[FIN]';

    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecución: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL;
        ROLLBACK;
        RAISE;
END QUITA_PERFIL_USUARIO;
/
EXIT;