--/*
--#########################################
--## AUTOR=Sergio Hernández
--## FECHA_CREACION=20161010
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_SUB_SUBSANACIONES -> SUB_SUBSANACIONES
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

TABLE_COUNT NUMBER(10,0) := 0;
--V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
--V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'SUB_SUBSANACIONES';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_SUB_SUBSANACIONES';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;


BEGIN
      
      --COMPROBACIONES PREVIAS - EXPEDIENTE_ECONOMICO
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO EXPEDIENTE_ECONOMICO...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
      WHERE NOT EXISTS (
        SELECT 1 FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
      WHERE ECO.ECO_NUM_EXPEDIENTE = MIG.SUB_COD_OFERTA
      )
      '
      ;
      
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN
      
        DBMS_OUTPUT.PUT_LINE('[INFO] TODAS LAS OFERTAS EXISTEN EN EXPEDIENTE_ECONOMICO');
        
      ELSE
      
        DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' EXPEDIENTE_ECONOMICO INEXISTENTES EN ECO_EXPEDIENTE_COMERCIAL. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_ECO_NOT_EXISTS.');
        
        --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
        
        EXECUTE IMMEDIATE '
        DELETE FROM '||V_ESQUEMA||'.MIG2_ECO_NOT_EXISTS
        WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
        '
        ;
        
        COMMIT;
      
        EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.MIG2_ECO_NOT_EXISTS (
             OFR_NUM_OFERTA,
             TABLA_MIG,
             FECHA_COMPROBACION
		        )
        SELECT 
             MIG.SUB_COD_OFERTA,        
             '''||V_TABLA_MIG||'''         TABLA_MIG,
             SYSDATE                       FECHA_COMPROBACION
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
        WHERE NOT EXISTS (
            SELECT 1 FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
             WHERE ECO.ECO_NUM_EXPEDIENTE = MIG.SUB_COD_OFERTA
          )
        '
        ;
        
        COMMIT;
    
      END IF;

      --Inicio del proceso de volcado sobre SUB_SUBSANACIONES
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA:= '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' SUB (
                SUB_ID                  ,
                ECO_ID                  ,
                DD_ESU_ID               ,
                SUB_PETICIONARIO        ,
                SUB_MOTIVO              ,
                SUB_FECHA_PETICION      ,
                SUB_GASTOS_SUBSANACION  ,
                SUB_GASTOS_INSCRIPCION  ,
                VERSION                 ,
                USUARIOCREAR            ,
                FECHACREAR       )
           SELECT
                S_SUB_SUBSANACIONES.NEXTVAL     ,
                ECO.ECO_ID                      ,
                ESU.DD_ESU_ID                   ,
                SUB_PETICIONARIO                ,
                SUB_MOTIVO                      ,
                SUB_FECHA_PETICION              ,
                SUB_GASTOS_SUBSANACION          ,
                SUB_GASTOS_INSCRIPCION          ,
                0                               ,
                ''MIG2''                        ,
                SYSDATE
           FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_NUM_EXPEDIENTE = MIG.SUB_COD_OFERTA
                LEFT  JOIN '||V_ESQUEMA||'.DD_ESU_ESTADOS_SUBSANACION ESU ON ESU.DD_ESU_CODIGO = MIG.SUB_COD_ESTADO_SUBSANACION';
      EXECUTE IMMEDIATE V_SENTENCIA;
                        
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
