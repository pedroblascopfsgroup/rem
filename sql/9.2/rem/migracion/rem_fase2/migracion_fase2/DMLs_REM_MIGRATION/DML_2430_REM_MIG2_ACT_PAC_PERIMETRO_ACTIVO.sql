--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160930
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_PAC_PERIMETRO_ACTIVO -> ACT_PAC_PERIMETRO_ACTIVO
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_PAC_PERIMETRO_ACTIVO';
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
		SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = MIG.PAC_NUMERO_ACTIVO
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
			MIG.PAC_NUMERO_ACTIVO 
			FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
			WHERE NOT EXISTS (
			  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.PAC_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
			)
		)
		SELECT DISTINCT
		MIG.PAC_NUMERO_ACTIVO                              						ACT_NUM_ACTIVO,
		'''||V_TABLA_MIG||'''                                                   TABLA_MIG,
		SYSDATE                                                                 FECHA_COMPROBACION
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
		INNER JOIN ACT_NUM_ACTIVO
		ON ACT_NUM_ACTIVO.PAC_NUMERO_ACTIVO = MIG.PAC_NUMERO_ACTIVO
		'
		;
		
		COMMIT;

	  END IF;


      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		   PAC_ID
          ,ACT_ID
          ,PAC_INCLUIDO
          ,PAC_CHECK_TRA_ADMISION
          ,PAC_FECHA_TRA_ADMISION
          ,PAC_MOTIVO_TRA_ADMISION
          ,PAC_CHECK_GESTIONAR
          ,PAC_FECHA_GESTIONAR
          ,PAC_MOTIVO_GESTIONAR
          ,PAC_CHECK_ASIGNAR_MEDIADOR
          ,PAC_FECHA_ASIGNAR_MEDIADOR
          ,PAC_MOTIVO_ASIGNAR_MEDIADOR
          ,PAC_CHECK_COMERCIALIZAR
          ,PAC_FECHA_COMERCIALIZAR
          ,DD_MCO_ID
          ,PAC_CHECK_FORMALIZAR
          ,PAC_FECHA_FORMALIZAR
          ,PAC_MOTIVO_FORMALIZAR
          ,VERSION
          ,USUARIOCREAR
          ,FECHACREAR
          ,BORRADO
          ,PAC_MOT_EXCL_COMERCIALIZAR
        )
        WITH INSERTAR AS (
          SELECT DISTINCT PAC_NUMERO_ACTIVO
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WMIG2
          INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
          ON WMIG2.PAC_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO 
          WHERE NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA||'.'||V_TABLA||' PAC
            WHERE PAC.ACT_ID = ACT.ACT_ID
          )  
        )
        SELECT 
          '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                        	AS PAC_ID,
          AUX.*
        FROM (      
          SELECT DISTINCT      
          (SELECT ACT.ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
          WHERE ACT.ACT_NUM_ACTIVO = MIG2.PAC_NUMERO_ACTIVO)           AS ACT_ID,      
          MIG2.PAC_IND_INCLUIDO                                                                  AS PAC_INCLUIDO,
		  MIG2.PAC_IND_CHECK_TRA_ADMISION									                                  AS PAC_CHECK_TRA_ADMISION,
		  MIG2.PAC_FECHA_TRA_ADMISION										                                      AS PAC_FECHA_TRA_ADMISION,
		  MIG2.PAC_MOTIVO_TRA_ADMISION										                                    AS PAC_MOTIVO_TRA_ADMISION,
		  MIG2.PAC_IND_CHECK_GESTIONAR										                                    AS PAC_CHECK_GESTIONAR,
		  MIG2.PAC_FECHA_GESTIONAR											                                          AS PAC_FECHA_GESTIONAR,
		  MIG2.PAC_MOTIVO_GESTIONAR											                                        AS PAC_MOTIVO_GESTIONAR,
		  MIG2.PAC_IND_CHECK_ASIG_MEDIA										                                    AS PAC_CHECK_ASIGNAR_MEDIADOR,
		  MIG2.PAC_FECHA_ASIGNAR_MEDIADOR									                                AS PAC_FECHA_ASIGNAR_MEDIADOR,
		  MIG2.PAC_MOTIVO_ASIGNAR_MEDIADOR									                              AS PAC_MOTIVO_ASIGNAR_MEDIADOR,
		  MIG2.PAC_IND_CHECK_COMERCIALIZAR									                                AS PAC_CHECK_COMERCIALIZAR,
		  MIG2.PAC_FECHA_COMERCIALIZAR										                                    AS PAC_FECHA_COMERCIALIZAR,
		  (SELECT DD_MCO_ID 
            FROM '||V_ESQUEMA||'.DD_MCO_MOTIVO_COMERCIALIZACION
            WHERE DD_MCO_CODIGO = MIG2.PAC_COD_MOTIVO_COMERCIAL)				AS DD_MCO_ID,
		  MIG2.PAC_IND_CHECK_FORMALIZAR										                                        AS PAC_CHECK_FORMALIZAR,
		  MIG2.PAC_FECHA_FORMALIZAR											                                              AS PAC_FECHA_FORMALIZAR,
		  MIG2.PAC_MOTIVO_FORMALIZAR										                                              AS PAC_MOTIVO_FORMALIZAR,
          0                                                               	                                          AS VERSION, 
          ''MIG2''                                                                                                  AS USUARIOCREAR,                            
          SYSDATE                                                                                               AS FECHACREAR,                             
          0                                                                                                         AS BORRADO,
          (SELECT DD_MNC_DESCRIPCION 
            FROM '||V_ESQUEMA||'.DD_MNC_MOT_NOCOMERCIALIZACION
            WHERE DD_MNC_CODIGO = MIG2.PAC_COD_MOTIVO_NOCOMERCIAL)			AS PAC_MOT_EXCL_COMERCIALIZAR
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          INNER JOIN INSERTAR INS 
          ON INS.PAC_NUMERO_ACTIVO = MIG2.PAC_NUMERO_ACTIVO
        ) AUX
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
		V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' PERIMETROS_ACTIVOS.';
		
		IF TABLE_COUNT != 0 THEN
			V_OBSERVACIONES := V_OBSERVACIONES || ' Hay un total de '||TABLE_COUNT||' ACTIVOS inexistentes.';
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
