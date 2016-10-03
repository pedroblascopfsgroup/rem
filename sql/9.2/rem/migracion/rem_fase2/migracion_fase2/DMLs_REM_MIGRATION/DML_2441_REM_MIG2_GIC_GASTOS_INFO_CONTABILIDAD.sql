--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161003
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GIC_GASTOS_INFO_CONTABI -> GIC_GASTOS_INFO_CONTABILIDAD
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
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'GIC_GASTOS_INFO_CONTABILIDAD';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GIC_GASTOS_INFO_CONTABI';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
      
      --COMPROBACIONES PREVIAS - GASTOS_PROVEEDOR
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO GASTOS_PROVEEDOR...');
      
      V_SENTENCIA := '
      SELECT COUNT(DISTINCT GIC_COD_GASTO_INFO_CONTABIL) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
        WHERE GPV.GPV_NUM_GASTO_GESTORIA = MIG2.GIC_COD_GASTO_INFO_CONTABIL
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS GASTOS_PROVEEDOR EXISTEN EN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' GASTOS_PROVEEDOR INEXISTENTES EN GPV_GASTOS_PROVEEDOR. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_GPV_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_GPV_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_GPV_NOT_EXISTS (
            TABLA_MIG,
            GPV_NUM_GASTO_GESTORIA,            
            FECHA_COMPROBACION
          )
          WITH NOT_EXISTS AS (
            SELECT DISTINCT MIG2.GIC_COD_GASTO_INFO_CONTABIL 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
              WHERE MIG2.GIC_COD_GASTO_INFO_CONTABIL = GPV.GPV_NUM_GASTO_GESTORIA
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.GIC_COD_GASTO_INFO_CONTABIL    						      GPV_NUM_GASTO_GESTORIA,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.GIC_COD_GASTO_INFO_CONTABIL = MIG2.GIC_COD_GASTO_INFO_CONTABIL
          '
          ;
          
          COMMIT;      
      
      END IF;

      --COMPROBACIONES PREVIAS - EJERCICIO
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO EJERCICIO...');
      
      V_SENTENCIA := '
      SELECT COUNT(DISTINCT GIC_EJERCICIO) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE 
        WHERE EJE.EJE_ANYO = MIG2.GIC_EJERCICIO
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS EJERCICIOS EXISTEN EN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' EJERCICIOS INEXISTENTES EN ACT_EJE_EJERCICIO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_EJE_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_EJE_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_EJE_NOT_EXISTS (
            TABLA_MIG,
            EJE_ANYO,            
            FECHA_COMPROBACION
          )
          WITH NOT_EXISTS AS (
            SELECT DISTINCT MIG2.GIC_EJERCICIO 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE
              WHERE MIG2.GIC_EJERCICIO = EJE.EJE_ANYO
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.GIC_EJERCICIO                                						      EJE_ANYO,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.GIC_EJERCICIO = MIG2.GIC_EJERCICIO
          '
          ;
          
          COMMIT;      
      
      END IF;
      
      --Inicio del proceso de volcado sobre GIC_GASTOS_INFO_CONTABILIDAD
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            GIC_ID
            ,GPV_ID
            ,EJE_ID
            ,DD_PPR_ID
            ,DD_CCO_ID
            ,GIC_FECHA_CONTABILIZACION
            ,DD_DES_ID_CONTABILIZA
            ,GIC_FECHA_DEVENGO_ESPECIAL
            ,DD_TPE_ID_ESPECIAL
            ,DD_PPR_ID_ESPECIAL
            ,DD_CCO_ID_ESPECIAL
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,BORRADO
          )
          SELECT
            '||V_ESQUEMA||'.S_GIC_GASTOS_INFO_CONTABILIDAD.NEXTVAL                                                    AS GIC_ID,
            (SELECT GPV.GPV_ID
              FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
              WHERE GPV.GPV_NUM_GASTO_GESTORIA = MIG2.GIC_COD_GASTO_INFO_CONTABIL
              AND BORRADO = 0)                                                                                                  AS GPV_ID,
            (SELECT EJE.EJE_ID
              FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE
              WHERE EJE.EJE_ANYO = MIG2.GIC_EJERCICIO 
              AND BORRADO = 0)                                                                                                  AS EJE_ID,
            (SELECT PPR.DD_PPR_ID
              FROM '||V_ESQUEMA||'.DD_PPR_PDAS_PRESUPUESTARIAS PPR
              WHERE PPR.DD_PPR_CODIGO = MIG2.GIC_COD_PARTIDA_PRESUPUES
              AND BORRADO = 0)                                                                                                  AS DD_PPR_ID,
            (SELECT CCO.DD_CCO_ID
              FROM '||V_ESQUEMA||'.DD_CCO_CUENTAS_CONTABLES CCO
              WHERE CCO.DD_CCO_CODIGO = MIG2.GIC_COD_CUENTA_CONTABLE
              AND BORRADO = 0)                                                                                                  AS DD_CCO_ID,
            MIG2.GIC_FECHA_CONTABILIZACION                                                                              AS GIC_FECHA_CONTABILIZACION,
            (SELECT DEP.DD_DEP_ID
              FROM '||V_ESQUEMA||'.DD_DEP_DESTINATARIOS_PAGO DEP
              WHERE DEP.DD_DEP_CODIGO = MIG2.GIC_COD_DESTINA_CONTABILIZA
              AND BORRADO = 0)                                                                                                  AS DD_DES_ID_CONTABILIZA,
            MIG2.GIC_FECHA_DEVENGO_ESPECIAL                                                                           AS GIC_FECHA_DEVENGO_ESPECIAL,
            (SELECT TPE.DD_TPE_ID
              FROM '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE
              WHERE TPE.DD_TPE_CODIGO = MIG2.GIC_COD_PERIODICIDAD_ESPECIAL
              AND BORRADO = 0)                                                                                                  AS DD_TPE_ID_ESPECIAL,
            (SELECT PPR.DD_PPR_ID
              FROM '||V_ESQUEMA||'.DD_PPR_PDAS_PRESUPUESTARIAS PPR
              WHERE PPR.DD_PPR_CODIGO = MIG2.GIC_COD_PAR_PRESUP_ESPECIAL
              AND BORRADO = 0)                                                                                                  AS DD_PPR_ID_ESPECIAL,
            (SELECT CCO.DD_CCO_ID
              FROM '||V_ESQUEMA||'.DD_CCO_CUENTAS_CONTABLES CCO
              WHERE CCO.DD_CCO_CODIGO = MIG2.GIC_COD_CUENTA_CONT_ESPECIAL
              AND BORRADO = 0)                                                                                                  AS DD_CCO_ID_ESPECIAL,
            0                                                                                                                                AS VERSION,
            ''MIG2''                                                                                                                         AS USUARIOCREAR,
            SYSDATE                                                                                                                    AS FECHACREAR,
            0                                                                                                                                AS BORRADO
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          LEFT JOIN '||V_ESQUEMA||'.MIG2_EJE_NOT_EXISTS EJE_NOT ON EJE_NOT.EJE_ANYO = MIG2.GIC_EJERCICIO
          LEFT JOIN '||V_ESQUEMA||'.MIG2_GPV_NOT_EXISTS GPV_NOT ON GPV_NOT.GPV_NUM_GASTO_GESTORIA = MIG2.GIC_COD_GASTO_INFO_CONTABIL
          WHERE EJE_NOT.EJE_ANYO IS NULL
          AND GPV_NOT.GPV_NUM_GASTO_GESTORIA IS NULL
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Registros insertados en REM
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = ''MIG2''';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
      
      /*  
      -- Diccionarios rechazados
      V_SENTENCIA := '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
      WHERE DICCIONARIO IN (''DD_TPR_TIPO_PROVEEDOR'',''DD_TDI_TIPO_DOCUMENTO_ID'',''DD_ZNG_ZONA_GEOGRAFICA'',''DD_PRV_PROVINCIA'',''DD_LOC_LOCALIDAD'')
      AND FICHERO_ORIGEN = ''PROVEEDORES.dat''
      AND CAMPO_ORIGEN IN (''TIPO_PROVEEDOR'',''TIPO_DOCUMENTO'',''ZONA_GEOGRAFICA'',''PVE_PROVINCIA'',''PVE_LOCALIDAD'')
      '
      ;
      
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
      */
      
      -- Observaciones
      IF V_REJECTS != 0 THEN
        V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' GASTOS_PROVEEDOR, comprobar la MIG2_GPV_NOT_EXISTS y la MIG2_EJE_NOT_EXISTS.';
      END IF;
      
      EXECUTE IMMEDIATE '
      INSERT INTO '||V_ESQUEMA||'.MIG_INFO_TABLE (
        TABLA_MIG,
        TABLA_REM,
        REGISTROS_TABLA_MIG,
        REGISTROS_INSERTADOS,
        REGISTROS_RECHAZADOS,
        DD_COD_INEXISTENTES,
        FECHA,
        OBSERVACIONES
      )
      SELECT
      '''||V_TABLA_MIG||''',
      '''||V_TABLA||''',
      '||V_REG_MIG||',
      '||V_REG_INSERTADOS||',
      '||V_REJECTS||',
      '||V_COD||',
      SYSDATE,
      '''||V_OBSERVACIONES||'''
      FROM DUAL
      '
      ;
      
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
