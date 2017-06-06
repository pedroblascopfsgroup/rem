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

		TABLE_COUNT_1 NUMBER(10,0) := 0;
		TABLE_COUNT_2 NUMBER(10,0) := 0;
		V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
		V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
		V_TABLA VARCHAR2(40 CHAR) := 'GIC_GASTOS_INFO_CONTABILIDAD';
		V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GIC_GASTOS_INFO_CONTABI';
		V_SENTENCIA VARCHAR2(32000 CHAR);
		V_REG_MIG NUMBER(10,0) := 0;
		V_REG_INSERTADOS NUMBER(10,0) := 0;
		V_REJECTS NUMBER(10,0) := 0;
		V_COD NUMBER(10,0) := 0;
		V_OBJ VARCHAR2(10 CHAR);
		V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

		--Cursor que almacena los objetos del esquema 
      CURSOR EJERCICIOS IS 
      select distinct GIC_EJERCICIO
      from MIG2_GIC_GASTOS_INFO_CONTABI mig
      where not exists (select 1 from ACT_EJE_EJERCICIO eje where eje.EJE_ANYO = mig.GIC_EJERCICIO)
      order by GIC_EJERCICIO
      ;

BEGIN
	  --INSERCION DE LOS EJERCICIOS INEXISTENTES
	  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] INSERTAMOS LOS EJERCICIOS INEXISTENTES EN ACT_EJE_EJERCICIO...');
			
	  OPEN EJERCICIOS;
	  
	  LOOP
        FETCH EJERCICIOS INTO V_OBJ;
        EXIT WHEN EJERCICIOS%NOTFOUND;               

      V_SENTENCIA := '
	   INSERT INTO ACT_EJE_EJERCICIO (
            EJE_ID
			,EJE_ANYO
			,EJE_FECHAINI
			,EJE_FECHAFIN
			,EJE_DESCRIPCION
			,VERSION
			,USUARIOCREAR
			,FECHACREAR
			,BORRADO
            )
            SELECT
            S_ACT_EJE_EJERCICIO.NEXTVAL									EJE_ID
            ,'||V_OBJ||'												EJE_ANYO
            ,to_date(''01/01/'||V_OBJ||''',''dd/MM/yyyy'')				EJE_FECHAINI
            ,to_date(''31/12/'||V_OBJ||''',''dd/MM/yyyy'')				EJE_FECHAFIN
            ,''Ejercicio correspondiente al año '||V_OBJ||'''			EJE_DESCRIPCION
            ,0															VERSION
            ,''MIG2''													USUARIOCREAR
            ,SYSDATE													FECHACREAR
            ,0															BORRADO
			FROM DUAL            
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('[INFO] Ejercicio creados en '||V_ESQUEMA||'.ACT_EJE_EJERCICIO -> ('||EJERCICIOS%ROWCOUNT||')');
      CLOSE EJERCICIOS;      
      
      --COMPROBACIONES PREVIAS - GASTOS_PROVEEDOR
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO GASTOS_PROVEEDOR...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
        WHERE GPV.GPV_NUM_GASTO_HAYA = MIG2.GIC_GPV_ID
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_1;
      
      /*IF TABLE_COUNT_1 = 0 THEN      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS GASTOS_PROVEEDOR EXISTEN EN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR');      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_1||' GASTOS_PROVEEDOR INEXISTENTES EN GPV_GASTOS_PROVEEDOR. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_GPV_NOT_EXISTS.');
          
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
            GPV_NUM_GASTO_HAYA,            
            FECHA_COMPROBACION
          )
          WITH NOT_EXISTS AS (
            SELECT DISTINCT MIG2.GIC_GPV_ID 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
              WHERE MIG2.GIC_GPV_ID = GPV.GPV_NUM_GASTO_HAYA
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.GIC_GPV_ID                                                                                                 GPV_NUM_GASTO_HAYA,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.GIC_GPV_ID = MIG2.GIC_GPV_ID
          '
          ;
          
          COMMIT;      
      
      END IF;*/


      --COMPROBACIONES PREVIAS - EJERCICIO
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO EJERCICIO...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE 
        WHERE EJE.EJE_ANYO = MIG2.GIC_EJERCICIO
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
      
      /*IF TABLE_COUNT_2 = 0 THEN      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS EJERCICIOS EXISTEN EN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO');      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' EJERCICIOS INEXISTENTES EN ACT_EJE_EJERCICIO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_EJE_NOT_EXISTS.');
          
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
          MIG2.GIC_EJERCICIO                                                                                  EJE_ANYO,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.GIC_EJERCICIO = MIG2.GIC_EJERCICIO
          '
          ;
          
          COMMIT;      
      
      END IF;*/
      
      --Inicio del proceso de volcado sobre GIC_GASTOS_INFO_CONTABILIDAD
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                  GIC_ID
                  ,GPV_ID
                  ,EJE_ID
                  ,GIC_FECHA_CONTABILIZACION
                  ,DD_DEG_ID_CONTABILIZA
                  ,GIC_FECHA_DEVENGO_ESPECIAL
                  ,DD_TPE_ID_ESPECIAL
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
                  ,GIC_CUENTA_CONTABLE
                  ,GIC_PTDA_PRESUPUESTARIA
                  ,GIC_CUENTA_CONTABLE_ESP
                  ,GIC_PTDA_PRESUPUESTARIA_ESP
            )
            SELECT
                  '||V_ESQUEMA||'.S_GIC_GASTOS_INFO_CONTABILIDAD.NEXTVAL        AS GIC_ID,
                  GPV.GPV_ID                                                    AS GPV_ID,
                  EJE.EJE_ID                                                    AS EJE_ID,                 
                  MIG2.GIC_FECHA_CONTABILIZACION                                AS GIC_FECHA_CONTABILIZACION,
                  DEP.DD_DEP_ID                                                 AS DD_DEG_ID_CONTABILIZA,
                  MIG2.GIC_FECHA_DEVENGO_ESPECIAL                               AS GIC_FECHA_DEVENGO_ESPECIAL,
                  TPE.DD_TPE_ID                                                 AS DD_TPE_ID_ESPECIAL,                
                  0                                                             AS VERSION,
                  ''MIG2''                                                      AS USUARIOCREAR,
                  SYSDATE                                                       AS FECHACREAR,
                  0                                                             AS BORRADO,
                  MIG2.GIC_COD_CUENTA_CONTABLE									AS GIC_CUENTA_CONTABLE,
                  MIG2.GIC_COD_PARTIDA_PRESUPUES								AS GIC_PTDA_PRESUPUESTARIA,
                  MIG2.GIC_COD_CUENTA_CONT_ESPECIAL								AS GIC_CUENTA_CONTABLE_ESP,
                  MIG2.GIC_COD_PAR_PRESUP_ESPECIAL								AS GIC_PTDA_PRESUPUESTARIA_ESP
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
                  INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_NUM_GASTO_HAYA = MIG2.GIC_GPV_ID AND GPV.BORRADO = 0
                  INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ANYO = MIG2.GIC_EJERCICIO AND EJE.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_DEP_DESTINATARIOS_PAGO DEP ON DEP.DD_DEP_CODIGO = MIG2.GIC_COD_DESTINA_CONTABILIZA AND DEP.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = MIG2.GIC_COD_PERIODICIDAD_ESPECIAL AND TPE.BORRADO = 0                 
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Registros insertados en REM
      -- V_REG_INSERTADOS
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;        
           
      -- Observaciones
      IF V_REJECTS != 0 THEN
        V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros.';
        
        IF TABLE_COUNT_1 != 0 THEN
               V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT_1||' GASTOS_PROVEEDORES inexistentes.';
        END IF;
        
        IF TABLE_COUNT_2 != 0 THEN
               V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT_2||' EJERCICIOS inexistentes.';
        END IF;
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
