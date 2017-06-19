--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2209
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
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
		V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
		V_TABLA VARCHAR2(40 CHAR) := 'GIC_GASTOS_INFO_CONTABILIDAD';
		V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GIC_GASTOS_INFO_CONTABI';
		V_SENTENCIA VARCHAR2(32000 CHAR);
            V_OBJ VARCHAR2(10 CHAR);

		--Cursor que almacena los objetos del esquema 
      CURSOR EJERCICIOS IS 
      select distinct GIC_EJERCICIO
      from MIG2_GIC_GASTOS_INFO_CONTABI mig
      where not exists (select 1 from ACT_EJE_EJERCICIO eje where eje.EJE_ANYO = mig.GIC_EJERCICIO)
      	and mig.VALIDACION = 0
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
            ,'||V_USUARIO||'									USUARIOCREAR
            ,SYSDATE													FECHACREAR
            ,0															BORRADO
			FROM DUAL            
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('[INFO] Ejercicio creados en '||V_ESQUEMA||'.ACT_EJE_EJERCICIO -> ('||EJERCICIOS%ROWCOUNT||')');
      CLOSE EJERCICIOS;      
      
      
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
                  '''||V_USUARIO||'''                                       AS USUARIOCREAR,
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
      		WHERE MIG2.VALIDACION = 0'
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
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
