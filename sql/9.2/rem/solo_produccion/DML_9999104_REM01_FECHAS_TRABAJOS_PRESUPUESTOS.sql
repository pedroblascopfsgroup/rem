--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180510
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-688
--## PRODUCTO=NO
--## Finalidad: Procedimiento que subsana las fechas de tipo 00XX o 0YXX por 20XX o 19XX según corresponda.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_USUARIO                   VARCHAR2(30 CHAR) := 'REMVIP-688';
    V_ESQUEMA                   VARCHAR2(30 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER            VARCHAR2(30 CHAR) := '#ESQUEMA_MASTER#';
    V_MSQL                      VARCHAR2(4000 CHAR);
    PL_OUTPUT                   VARCHAR2(32767 CHAR);
    TYPE TBJ_FECHA IS TABLE OF  VARCHAR2(250 CHAR);
    V_TBJ TBJ_FECHA := TBJ_FECHA('TBJ_FECHA_SOLICITUD', 'TBJ_FECHA_APROBACION'
        , 'TBJ_FECHA_INICIO', 'TBJ_FECHA_FIN', 'TBJ_FECHA_FIN_COMPROMISO', 'TBJ_FECHA_TOPE'
        , 'TBJ_FECHA_RECHAZO', 'TBJ_FECHA_ELECCION_PROVEEDOR', 'TBJ_FECHA_EJECUTADO'
        , 'TBJ_FECHA_ANULACION', 'TBJ_FECHA_VALIDACION', 'TBJ_FECHA_CIERRE_ECONOMICO'
        , 'TBJ_FECHA_PAGO', 'TBJ_FECHA_EMISION_FACTURA');

BEGIN

    PL_OUTPUT := '[INICIO]' || CHR(10);

    FOR I IN V_TBJ.FIRST .. V_TBJ.LAST
    LOOP
        V_MSQL := 'MERGE INTO ' || V_ESQUEMA || '.ACT_TBJ_TRABAJO T1
            USING (
                SELECT TBJ_ID
                    , CASE
                        WHEN TO_NUMBER(TO_CHAR(' || V_TBJ(I) || ',''YYYY'')) BETWEEN 0   AND 99  THEN ''20'' || TO_CHAR(' || V_TBJ(I) || ',''RR'') || TO_CHAR(' || V_TBJ(I) || ',''MMDD'')
                        WHEN TO_NUMBER(TO_CHAR(' || V_TBJ(I) || ',''YYYY'')) BETWEEN 100 AND 899 THEN ''20'' || TO_CHAR(' || V_TBJ(I) || ',''RR'') || TO_CHAR(' || V_TBJ(I) || ',''MMDD'')
                        WHEN TO_NUMBER(TO_CHAR(' || V_TBJ(I) || ',''YYYY'')) BETWEEN 900 AND 999 THEN ''19'' || TO_CHAR(' || V_TBJ(I) || ',''RR'') || TO_CHAR(' || V_TBJ(I) || ',''MMDD'')
                    END ' || V_TBJ(I) || '
                FROM ' || V_ESQUEMA || '.ACT_TBJ_TRABAJO
                WHERE NVL(TO_NUMBER(TO_CHAR(' || V_TBJ(I) || ',''YYYY'')),9999) BETWEEN 0 AND 999
                ) T2
            ON (T1.TBJ_ID = T2.TBJ_ID)
            WHEN MATCHED THEN UPDATE SET
                T1.' || V_TBJ(I) || ' = TO_DATE(T2.' || V_TBJ(I) || ',''YYYYMMDD''), T1.USUARIOMODIFICAR = ''' || V_USUARIO || ''', T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
        PL_OUTPUT := PL_OUTPUT || '   [INFO] - ' || TO_CHAR(SYSDATE,'HH24:MI:SS') || ' - ' || SQL%ROWCOUNT || ' registros actualizados en la tabla ACT_TBJ_TRABAJO, campo ' || V_TBJ(I) || '.' || CHR(10);           
    END LOOP;
    
    V_MSQL := 'INSERT INTO ' || V_ESQUEMA || '.ACT_PTO_PRESUPUESTO (PTO_ID, ACT_ID, EJE_ID, PTO_IMPORTE_INICIAL, PTO_FECHA_ASIGNACION
        , USUARIOCREAR, FECHACREAR)
        WITH PRESUPUESTOS AS (
            SELECT PTO.ACT_ID, EJE.EJE_ID, EJE.EJE_ANYO
            FROM ' || V_ESQUEMA || '.ACT_PTO_PRESUPUESTO PTO
            JOIN ' || V_ESQUEMA || '.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = PTO.EJE_ID AND EJE.BORRADO = 0
            WHERE PTO.BORRADO = 0
            )
        SELECT ' || V_ESQUEMA || '.S_ACT_PTO_PRESUPUESTO.NEXTVAL, ACT.ACT_ID, EJE.EJE_ID, 50000, TO_DATE(''0101'' || TO_CHAR(TBJ.TBJ_FECHA_SOLICITUD,''YYYY''),''DDMMYYYY'')
            , ''' || V_USUARIO || ''', SYSDATE
        FROM ' || V_ESQUEMA || '.ACT_TBJ ATB
        JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = ATB.ACT_ID AND ACT.BORRADO = 0
        JOIN ' || V_ESQUEMA || '.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = ATB.TBJ_ID AND TBJ.BORRADO = 0
        JOIN ' || V_ESQUEMA || '.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ANYO = TO_CHAR(TBJ.TBJ_FECHA_SOLICITUD,''YYYY'')
        LEFT JOIN PRESUPUESTOS PTO ON PTO.ACT_ID = ACT.ACT_ID AND PTO.EJE_ANYO = TO_CHAR(TBJ.TBJ_FECHA_SOLICITUD,''YYYY'')
        WHERE PTO.ACT_ID IS NULL';
    EXECUTE IMMEDIATE V_MSQL;
    PL_OUTPUT := PL_OUTPUT || '   [INFO] - ' || TO_CHAR(SYSDATE,'HH24:MI:SS') || ' - ' || SQL%ROWCOUNT || ' registros insertados en la tabla ACT_PTO_PRESUPUESTO.' || CHR(10);
    
    COMMIT;

    PL_OUTPUT := PL_OUTPUT || '[FIN]'|| CHR(10);
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecucion: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL || CHR(10);
        DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
        ROLLBACK;
        RAISE;
END;
/
EXIT;