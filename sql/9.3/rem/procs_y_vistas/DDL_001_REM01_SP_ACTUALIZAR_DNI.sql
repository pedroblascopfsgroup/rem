--/*
--##########################################
--## AUTOR=Carlos López
--## FECHA_CREACION=20190617
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6668
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar DNI.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_ACTUALIZAR_DNI (P_PLAN NUMBER, resultado out varchar2) AUTHID CURRENT_USER AS		

    CONTADOR NUMBER := 5000;
    TYPE MATRIZ_ROWID IS TABLE OF ROWID;
    TYPE MATRIZ_AUDITORIA IS TABLE OF VARCHAR2(50 CHAR);
    TYPE CURSOR_AUDITORIA IS REF CURSOR;
    M_ROWID MATRIZ_ROWID;
    M_AUDITORIA MATRIZ_AUDITORIA;
    C_AUDITORIA CURSOR_AUDITORIA;
    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    
    CURSOR C_AUXILIAR IS
        SELECT OWNER, TABLE_NAME, COLUMN_NAME
        FROM #ESQUEMA#.AUX_DNI_FASE2
        WHERE PROCESADO = 0
        AND TABLE_PLAN = P_PLAN;
        
    NOMBRE_ESQUEMA VARCHAR2(30 CHAR);
    NOMBRE_TABLA VARCHAR2(30 CHAR);
    NOMBRE_CAMPO VARCHAR2(30 CHAR);
    
    V_MSQL VARCHAR2(4000 CHAR);
    porcentaje varchar2(2000 char);
    
    V_START TIMESTAMP;
    V_ELAPSED TIMESTAMP;
    v_n  INTERVAL DAY TO SECOND ;    
    
BEGIN
    V_START := SYSTIMESTAMP;
    
    SELECT round((select nvl(SUM(NUM_ROWS),0) from #ESQUEMA#.AUX_DNI_FASE2 where procesado = 1)*100/(select nvl(SUM(NUM_ROWS),0) from #ESQUEMA#.AUX_DNI_FASE2 ),2) || ' %' porcentaje
      into porcentaje
      FROM dual;
    
    resultado := 'Parámetro P_PLAN = '||P_PLAN||chr(13)||chr(10);
    resultado := resultado||'[INFO]'||chr(13)||chr(10)||' Porcentaje inicio SP: '||porcentaje ;  
    resultado := resultado||chr(13)||chr(10)||' Hora inicio SP: '||V_START; 
      
    FOR i IN C_AUXILIAR
        LOOP
            NOMBRE_ESQUEMA := i.OWNER;
            NOMBRE_TABLA := i.TABLE_NAME;            
            NOMBRE_CAMPO := i.COLUMN_NAME;
            
            V_MSQL := 'SELECT ROWID, '||NOMBRE_CAMPO||' FROM '||NOMBRE_ESQUEMA||'.'||NOMBRE_TABLA;
            
            OPEN C_AUDITORIA FOR
                V_MSQL;
                LOOP
                    FETCH C_AUDITORIA BULK COLLECT
                        INTO M_ROWID, M_AUDITORIA LIMIT CONTADOR;
                    FORALL i IN 1 .. M_ROWID.LAST
                        EXECUTE IMMEDIATE 'MERGE INTO '||NOMBRE_ESQUEMA||'.'||NOMBRE_TABLA||' T1
                            USING REM01.AUX_USUARIOS_NUEVO_ANTIGUO T2
                            ON (T1.ROWID = :1)
                            WHEN MATCHED THEN UPDATE SET
                                T1.'||NOMBRE_CAMPO||' = T2.USERNAME_DEFINITIVO
                            WHERE T1.'||NOMBRE_CAMPO||' = T2.USERNAME_ACTUAL
                                AND T2.USERNAME_DEFINITIVO IS NOT NULL
                            ' USING M_ROWID(i);
                        COMMIT;
                    EXIT WHEN C_AUDITORIA%NOTFOUND;
                END LOOP;
                
                UPDATE REM01.AUX_DNI_FASE2 
                SET PROCESADO = 1
                WHERE OWNER = NOMBRE_ESQUEMA
                    AND TABLE_NAME = NOMBRE_TABLA
                    AND COLUMN_NAME = NOMBRE_CAMPO;
                COMMIT;
                
            CLOSE C_AUDITORIA;
            
            EXIT WHEN C_AUXILIAR%NOTFOUND;
        END LOOP;
   
    SELECT round((select nvl(SUM(NUM_ROWS),0) from #ESQUEMA#.AUX_DNI_FASE2 where procesado = 1)*100/(select nvl(SUM(NUM_ROWS),0) from #ESQUEMA#.AUX_DNI_FASE2 ),2) || ' %' porcentaje
      into porcentaje
      FROM dual;
    
    resultado := resultado||chr(13)||chr(10);
    resultado := resultado||chr(13)||chr(10)||' Porcentaje fin SP: '||porcentaje||chr(13)||chr(10); 
    
    V_ELAPSED := SYSTIMESTAMP;
       
    v_n := V_ELAPSED - V_START;
       
    resultado := resultado||' Tiempo fin SP: '||v_n||' s.'||chr(13)||chr(10)||'[INFO FIN]';      
              
EXCEPTION
    WHEN OTHERS THEN
        
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        rollback;
        raise;
END;

/

EXIT
