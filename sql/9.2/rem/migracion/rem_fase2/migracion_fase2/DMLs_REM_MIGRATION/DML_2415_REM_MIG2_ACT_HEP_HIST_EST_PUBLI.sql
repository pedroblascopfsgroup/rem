--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161010
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_ACT_HEP_HIST_EST_PUBLI -> ACT_HEP_HIST_EST_PUBLICACION
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_HEP_HIST_EST_PUBLICACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACT_HEP_HIST_EST_PUBLI';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

	  --COMPROBACIONES PREVIAS - ACTIVOS
	  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO ACTIVOS...');
	  
	  V_SENTENCIA := '
	  SELECT COUNT(1) 
	  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
	  WHERE NOT EXISTS (
		SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = MIG.HEP_ACT_NUMERO_ACTIVO
	  )
	  '
	  ;
	  
	  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
	  
	  IF TABLE_COUNT = 0 THEN
	  
		DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS ACTIVOS EXISTEN EN ACT_ACTIVO');
		
	  ELSE
	  
		DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' ACTIVOS INEXISTENTES EN ACT_ACTIVO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_ACT_NOT_EXISTS.');
		
		--BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
		
		EXECUTE IMMEDIATE '
		DELETE FROM '||V_ESQUEMA||'.MIG2_ACT_NOT_EXISTS
		WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
		'
		;
		
		COMMIT;
	  
		EXECUTE IMMEDIATE '
		INSERT INTO '||V_ESQUEMA||'.MIG2_ACT_NOT_EXISTS (
		ACT_NUM_ACTIVO,
		TABLA_MIG,
		FECHA_COMPROBACION
		)
		WITH ACT_NUM_ACTIVO AS (
			SELECT
			MIG.HEP_ACT_NUMERO_ACTIVO 
			FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
			WHERE NOT EXISTS (
			  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.HEP_ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
			)
		)
		SELECT DISTINCT
		MIG.HEP_ACT_NUMERO_ACTIVO                              						ACT_NUM_ACTIVO,
		'''||V_TABLA_MIG||'''                                                   TABLA_MIG,
		SYSDATE                                                                 FECHA_COMPROBACION
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
		INNER JOIN ACT_NUM_ACTIVO
		ON ACT_NUM_ACTIVO.HEP_ACT_NUMERO_ACTIVO = MIG.HEP_ACT_NUMERO_ACTIVO
		'
		;
		
		COMMIT;

	  END IF;


      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' HEP (
              HEP_ID
              ,ACT_ID
              ,HEP_FECHA_DESDE
              ,HEP_FECHA_HASTA
              ,DD_POR_ID
              ,DD_TPU_ID
              ,DD_EPU_ID
              ,HEP_MOTIVO
              ,VERSION
              ,USUARIOCREAR
              ,FECHACREAR
              ,BORRADO
          )
          SELECT
            '||V_ESQUEMA||'.S_ACT_HEP_HIST_EST_PUBLICACION.NEXTVAL                        AS HEP_ID,
            ACT.ACT_ID                                                                                    AS ACT_ID,
            MIG2.HEP_FECHA_DESDE                                                                  AS HEP_FECHA_DESDE,
            MIG2.HEP_FECHA_HASTA                                                                  AS HEP_FECHA_HASTA,
            POR.DD_POR_ID                                                                               AS DD_POR_ID,
            TPU.DD_TPU_ID                                                                                AS DD_TPU_ID,
            EPU.DD_EPU_ID                                                                               AS DD_EPU_ID,
            MIG2.HEP_MOTIVO                                                                          AS HEP_MOTIVO,
            0                                                                                                   AS VERSION,
            ''MIG2''                                                                                            AS USUARIOCREAR,
            SYSDATE                                                                                       AS FECHACREAR,
            0                                                                                                   AS BORRADO
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG2.HEP_ACT_NUMERO_ACTIVO AND ACT.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_POR_PORTAL POR ON POR.DD_POR_CODIGO = MIG2.HEP_COD_PORTAL AND POR.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION TPU ON TPU.DD_TPU_CODIGO = MIG2.HEP_COD_TIPO_PUBLICACION AND TPU.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION EPU ON EPU.DD_EPU_CODIGO = MIG2.HEP_COD_ESTADO_PUBLI AND EPU.BORRADO = 0      
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA	;
      
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
          
          IF TABLE_COUNT != 0 THEN
              V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' ACTIVOS inexistentes.';
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
