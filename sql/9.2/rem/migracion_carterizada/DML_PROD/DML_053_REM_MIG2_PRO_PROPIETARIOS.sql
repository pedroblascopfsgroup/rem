--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161005
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_PRO_PROPIETARIO -> ACT_PRO_PROPIETARIO
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
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PRO_PROPIETARIO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_PRO_PROPIETARIOS';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

  --COMPROBACIONES PREVIAS - PROPIETARIOS
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO PROPIETARIOS...');
  
  V_SENTENCIA := '
  SELECT COUNT(1) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO.PRO_CODIGO_UVEM = MIG.PRO_PROPIETARIO_CODIGO_UVEM
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;

      --Inicio del proceso de volcado sobre ACT_PRO_PROPIETARIO
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      /*V_SENTENCIA := '
        MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' PRO
        USING ( SELECT DISTINCT 
                                MIG.PRO_PROPIETARIO_CODIGO_UVEM,
                                CRA.DD_CRA_ID
                                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                                INNER JOIN DD_CRA_CARTERA CRA
									ON CRA.DD_CRA_CODIGO = MIG.PRO_COD_CARTERA
                                INNER JOIN ACT_PRO_PROPIETARIO PRO
									ON PRO.PRO_CODIGO_UVEM = MIG.PRO_PROPIETARIO_CODIGO_UVEM
									AND PRO.DD_CRA_ID IS NULL
								WHERE PRO.USUARIOCREAR = ''MIG''								
                          ) AUX
                ON (PRO.PRO_CODIGO_UVEM = AUX.PRO_PROPIETARIO_CODIGO_UVEM AND PRO.USUARIOCREAR = ''MIG'')
                WHEN MATCHED THEN UPDATE SET
          PRO.DD_CRA_ID = AUX.DD_CRA_ID
          ,PRO.USUARIOMODIFICAR = ''MIG2''
          ,PRO.FECHAMODIFICAR = SYSDATE
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS :=SQL%ROWCOUNT;*/
      
      
       V_SENTENCIA := '
		UPDATE '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO
		SET DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''02'')
			,PRO.USUARIOMODIFICAR = ''MIG2''
			,PRO.FECHAMODIFICAR = SYSDATE
		WHERE PRO.PRO_CODIGO_UVEM = 100000002
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS :=SQL%ROWCOUNT;
      
      
      
      V_SENTENCIA := '
		UPDATE ACT_PRO_PROPIETARIO PRO
		SET DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''01'')
			,PRO.USUARIOMODIFICAR = ''MIG2''
			,PRO.FECHAMODIFICAR = SYSDATE
		WHERE PRO.USUARIOCREAR = ''MIG''
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS :=SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
            
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;        
      
      -- Observaciones
          IF V_REJECTS != 0 THEN
         V_OBSERVACIONES := ' Se han rechazado  '||V_REJECTS||' registros.';
                IF TABLE_COUNT != 0 THEN
                
                  V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' PROPIETARIOS inexistentes. ';
                
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
