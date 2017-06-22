--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=migracion
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración Fase 2, para la actualizacion de ACT_ABA_ACTIVO_BANCARIO.
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

    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_TABLA VARCHAR2(40 CHAR) := 'ACT_ABA_ACTIVO_BANCARIO';
    V_SENTENCIA VARCHAR2(32000 CHAR);
    V_REG_ACTUALIZADOS NUMBER(10,0) := 0;
      
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------') ;
    DBMS_OUTPUT.PUT_LINE('PROCESO DE BORRADO DE REGISTROS DE '||V_TABLA||'....') ;
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------') ;

    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE BORRADO SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
    
    V_SENTENCIA := '
        DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||'
      WHERE aba_id IN (SELECT aba_id
                         FROM (SELECT aba.act_id, aba.aba_id, RANK () OVER (PARTITION BY act_id ORDER BY aba_id) rango
                                 FROM '||V_ESQUEMA||'.'||V_TABLA||' aba)
                        WHERE rango > 1)
    '
    ;
    EXECUTE IMMEDIATE V_SENTENCIA;
    
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas.');
    
    COMMIT;
      
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;

/

EXIT;
