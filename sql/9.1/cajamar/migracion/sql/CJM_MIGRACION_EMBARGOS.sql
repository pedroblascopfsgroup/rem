--/*
--##########################################
--## AUTOR=JAIME SANCHEZ-CUENCA
--## FECHA_CREACION=20160330
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de Embargos
--## INSTRUCCIONES:  
--## VERSIONES:
--##         0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        TABLE_COUNT  NUMBER(3);
        EXISTE       NUMBER;
        V_SQL        VARCHAR2(12000 CHAR);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'CM01';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRACM01';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
  
        
BEGIN    
    ------------------
    --    EMBARGOS
    ------------------


    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  EMPIEZA LA MIGRACION DE EMBARGOS');

    
      EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.EMP_NMBEMBARGOS_PROCEDIMIENTOS (
            EMP_ID,
            BIE_ID,
            PRC_ID,
            EMP_FECHA_SOLICITUD_EMBARGO,
            EMP_FECHA_DECRETO_EMBARGO,
            EMP_FECHA_REGISTRO_EMBARGO,
            EMP_FECHA_ADJUDICACION_EMBARGO,
            VERSION,
            USUARIOCREAR,
            FECHACREAR,
            BORRADO,
            EMP_IMPORTE_AVAL,
            EMP_FECHA_AVAL,
            EMP_IMPORTE_TASACION,
            EMP_FECHA_TASACION,
            EMP_IMPORTE_ADJUDICACION,
            EMP_IMPORTE_VALOR,
            EMP_LETRA,
            EMP_FECHA_DENEGACION_EMBARGO )
        SELECT '||V_ESQUEMA||'.S_EMP_EMBARGOS_PROCEDIMIENTOS.NEXTVAL,
             BIE_ID,
             PRC_ID,
             FECHA_SOLICITUD_EMBARGO
            ,FECHA_DECRETO_EMBARGO
            ,FECHA_REGISTRO_EMBARGO
            ,FECHA_ADJUDICACION_EMBARGO
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,BORRADO
            ,IMPORTE_AVALUO
            ,FECHA_AVALUO
            ,IMPORTE_TASACION
            ,FECHA_TASACION
            ,IMPORTE_ADJUDICACION
            ,IMPORTE_VALOR
            ,LETRA
            ,EMP_FECHA_DENEGACION_EMBARGO
        FROM( 
SELECT DISTINCT 
            BIE.BIE_ID,
            (SELECT MIN(PRC_ID) MIN_PRC FROM '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS PRC WHERE PRC.ASU_ID = ASU.ASU_ID) AS PRC_ID,
            MPE.FECHA_SOLICITUD_EMBARGO,
            MPE.FECHA_DECRETO_EMBARGO,
            MPE.FECHA_REGISTRO_EMBARGO,
            MPE.FECHA_ADJUDICACION_EMBARGO,
            0 AS VERSION,
            '''||USUARIO||''' AS USUARIOCREAR,
            TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'') FECHACREAR,
            0 AS BORRADO,
            MPE.IMPORTE_AVALUO,
            MPE.FECHA_AVALUO,
            MPE.IMPORTE_TASACION,
            MPE.FECHA_TASACION,
            ADJ.BIE_ADJ_IMPORTE_ADJUDICACION as IMPORTE_ADJUDICACION,
            MPE.IMPORTE_VALOR,
            MPE.LETRA,
            NULL AS EMP_FECHA_DENEGACION_EMBARGO
        FROM '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_EMBARGOS MPE
           , '||V_ESQUEMA||'.MIG_PROCEDIMIENTOS_CABECERA CAB
           , '||V_ESQUEMA||'.ASU_ASUNTOS ASU
           , '||V_ESQUEMA||'.BIE_BIEN BIE
           , '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION ADJ
        WHERE CAB.CD_PROCEDIMIENTO = MPE.CD_PROCEDIMIENTO
        AND MPE.CD_PROCEDIMIENTO = ASU.ASU_ID_EXTERNO
        AND MPE.CD_BIEN = TO_CHAR(BIE.BIE_CODIGO_INTERNO)
        AND BIE.BIE_ID = ADJ.BIE_ID (+))');


    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  EMP_NMBEMBARGOS_PROCEDIMIENTOS cargada. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.EMP_NMBEMBARGOS_PROCEDIMIENTOS COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  EMP_NMBEMBARGOS_PROCEDIMIENTOS Analizada');

    DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;
