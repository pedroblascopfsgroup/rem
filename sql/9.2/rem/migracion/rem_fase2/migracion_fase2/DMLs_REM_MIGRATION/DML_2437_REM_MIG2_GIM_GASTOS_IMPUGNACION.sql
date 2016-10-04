--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161003
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GIM_GASTOS_IMPUGANCION -> GIM_GASTOS_IMPUGNACION
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
V_TABLA VARCHAR2(40 CHAR) := 'GIM_GASTOS_IMPUGNACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GIM_GASTOS_IMPUGNACION';
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
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
        WHERE GPV.GPV_NUM_GASTO_GESTORIA = MIG2.GIM_COD_GASTO_PROVEEDOR
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
            SELECT DISTINCT MIG2.GIM_COD_GASTO_PROVEEDOR 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
              WHERE MIG2.GIM_COD_GASTO_PROVEEDOR = GPV.GPV_NUM_GASTO_GESTORIA
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.GIM_COD_GASTO_PROVEEDOR    						      			  GPV_NUM_GASTO_GESTORIA,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.GIM_COD_GASTO_PROVEEDOR = MIG2.GIM_COD_GASTO_PROVEEDOR
          '
          ;
          
          COMMIT;      
      
      END IF;


      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		GIM_ID,
		GPV_ID,
		GIM_FECHA_TOPE,
		GIM_FECHA_PRESENTACION,
		GIM_FECHA_RESOLUCION,
		DD_RIM_ID,
		GIM_OBSERVACIONES,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
		)
		WITH INSERTAR AS (
		SELECT DISTINCT GPV.GPV_ID, 
						MIG.GIM_FECHA_TOPE_IMPUGNACION,
						MIG.GIM_FECHA_PRESEN_IMPUG,
						MIG.GIM_FECHA_RESOLUCION,
						MIG.GIM_COD_RESULTADO_IMPUGNACION,
						MIG.GIM_OBSERVACIONES
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
		  ON GPV.GPV_NUM_GASTO_GESTORIA = MIG.GIM_COD_GASTO_PROVEEDOR
	  )
		SELECT
		'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL            		 		GIM_ID, 
		GIM.GPV_ID  													GPV_ID,
		GIM.GIM_FECHA_TOPE_IMPUGNACION												GIM_FECHA_TOPE,
		GIM.GIM_FECHA_PRESEN_IMPUG										GIM_FECHA_PRESENTACION,
		GIM.GIM_FECHA_RESOLUCION										GIM_FECHA_RESOLUCION,
		(SELECT DD_RIM_ID 
		FROM DD_RIM_RESULTADOS_IMPUGNACION
		WHERE DD_RIM_CODIGO = GIM.GIM_COD_RESULTADO_IMPUGNACION)		DD_RIM_ID,
		GIM.GIM_OBSERVACIONES											GIM_OBSERVACIONES,
		0																VERSION,
		''MIG2''                                            			USUARIOCREAR,
		SYSDATE                                            				FECHACREAR,
		0                                                  				BORRADO
		FROM INSERTAR GIM
		'
		;
      EXECUTE IMMEDIATE V_SENTENCIA	;
      
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
	  
		IF TABLE_COUNT != 0 THEN
		
		  V_OBSERVACIONES := 'Del total de registros rechazados, '||TABLE_COUNT||' han sido por Codigos de GASTOS_PROVEEDOR inexistentes. ';
		
		END IF;
      END IF;
        
      V_SENTENCIA := '
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
      EXECUTE IMMEDIATE V_SENTENCIA;
      
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
