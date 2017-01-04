--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=20161006
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GPR_PROVISION_GASTOS -> PRG_PROVISION_GASTOS
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

TABLE_COUNT    NUMBER(10,0) := 0;
TABLE_COUNT_2 NUMBER(10,0) := 0;
TABLE_COUNT_3 NUMBER(10,0) := 0;
MAX_NUM_PROVISION NUMBER(10,0) := 0;
V_NUM_TABLAS NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'PRG_PROVISION_GASTOS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GPR_PROVISION_GASTOS';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
        --COMPROBACIONES PREVIAS - DD_EPR_ESTADOS_PROVISION_GASTO
    DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO ESTADOS DE PROVISION...');
    
    V_SENTENCIA := '
        SELECT COUNT(1) 
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
        WHERE NOT EXISTS (
          SELECT 1 
          FROM '||V_ESQUEMA||'.DD_EPR_ESTADOS_PROVISION_GASTO DD 
          WHERE DD.DD_EPR_CODIGO = MIG2.GPR_COD_ESTADO_PROVISION
    )
    '
    ;
    EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
    
    IF TABLE_COUNT = 0 THEN    
        DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS ESTADOS DE PROVISION EXISTEN EN '||V_ESQUEMA||'.DD_EPR_ESTADOS_PROVISION_GASTO');    
    ELSE
    
        DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' ESTADOS DE PROVISION INEXISTENTES EN DD_EPR_ESTADOS_PROVISION_GASTO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
        
        --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
        
        EXECUTE IMMEDIATE '
        DELETE FROM '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS
        WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
        '
        ;
        
        COMMIT;
        
        EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS (
              CLAVE           ,  
              TABLA_MIG  , 
              CAMPO_ORIGEN    ,
              DICCIONARIO     ,
              VALOR           ,
              FECHA_COMPROBACION

        )
              SELECT
                      GPR_NUMERO_PROVISION_FONDOS,
                      '''||V_TABLA_MIG||''',
                      ''GPR_COD_ESTADO_PROVISION'',
                      ''DD_EPR_ID'',
                      GPR_COD_ESTADO_PROVISION,
                      SYSDATE
              FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
                    WHERE NOT EXISTS (
                      SELECT 1 
                      FROM '||V_ESQUEMA||'.DD_EPR_ESTADOS_PROVISION_GASTO DD 
                      WHERE DD.DD_EPR_CODIGO = MIG2.GPR_COD_ESTADO_PROVISION
              )'
        ;
        
        V_COD := SQL%ROWCOUNT;
        
        COMMIT;   
        
     END IF;
     
     --COMPROBACIONES PREVIAS - PROVEEDOR (TIPO GESTOR)
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO PROVEEDOR (TIPO GESTOR)...');
  
  V_SENTENCIA := '
  SELECT COUNT(1) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_COD_UVEM = MIG.GPR_COD_GESTORIA
    AND PVE.DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''01'')
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
  
  IF TABLE_COUNT_2 = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS PROVEEDORES (TIPO GESTOR) EXISTEN EN ACT_PVE_PROVEEDOR');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' PROVEEDOR (TIPO GESTOR) INEXISTENTES EN ACT_PVE_PROVEEDOR. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_PVE_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.MIG2_PVE_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.MIG2_PVE_NOT_EXISTS (
          PVE_COD_UVEM,
          TABLA_MIG,
          FECHA_COMPROBACION
    )
    WITH PVE_COD_UVEM AS (
          SELECT
          MIG.GPR_COD_GESTORIA 
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
          WHERE NOT EXISTS (
            SELECT 1 
            FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE 
            WHERE MIG.GPR_COD_GESTORIA = PVE.PVE_COD_UVEM
            AND PVE.DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''01'')
          )
    )
    SELECT DISTINCT
          MIG.GPR_COD_GESTORIA                                                                                  PVE_COD_UVEM,
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN PVE_COD_UVEM ON PVE_COD_UVEM.GPR_COD_GESTORIA = MIG.GPR_COD_GESTORIA
    '
    ;
    
    COMMIT;

  END IF;   

          --Inicio del proceso de volcado sobre PRG_PROVISION_GASTOS
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                PRG_ID,
                PRG_NUM_PROVISION,
                DD_EPR_ID,
                PRG_FECHA_ALTA,
                PVE_ID_GESTORIA,
                PRG_FECHA_ENVIO,
                PRG_FECHA_RESPUESTA,
                PRG_FECHA_ANULACION,
                VERSION,
                USUARIOCREAR,
                FECHACREAR,
                BORRADO
                )
                WITH INSERTAR AS (
			    SELECT
				  	  MIGW.GPR_NUMERO_PROVISION_FONDOS                                        
					  ,EPR.DD_EPR_ID                                                                             
					  ,MIGW.GPR_FECHA_ALTA                                                                           
					  ,PVE.PVE_ID                                                                                    
					  ,MIGW.GPR_FECHA_ENVIO                                                                                   
					  ,MIGW.GPR_FECHA_RESPUESTA                                                                                 
					  ,MIGW.GPR_FECHA_ANULACION
					  ,ROW_NUMBER() OVER (PARTITION BY MIGW.GPR_NUMERO_PROVISION_FONDOS ORDER BY MIGW.GPR_FECHA_RESPUESTA DESC) ORDEN
			    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
			    INNER JOIN '||V_ESQUEMA||'.DD_EPR_ESTADOS_PROVISION_GASTO EPR ON EPR.DD_EPR_CODIGO = MIGW.GPR_COD_ESTADO_PROVISION
			    INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM =  MIGW.GPR_COD_GESTORIA
					   AND PVE.DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''01'')
			 
				)
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                 PRG_ID, 
                MIG.GPR_NUMERO_PROVISION_FONDOS                         PRG_NUM_PROVISION,
                MIG.DD_EPR_ID                                           DD_EPR_ID,
                MIG.GPR_FECHA_ALTA                                      PRG_FECHA_ALTA,
                MIG.PVE_ID                                              PVE_ID_GESTORIA,
                MIG.GPR_FECHA_ENVIO                                     PRG_FECHA_ENVIO,
                MIG.GPR_FECHA_RESPUESTA                                 PRG_FECHA_RESPUESTA,
                MIG.GPR_FECHA_ANULACION                                 PRG_FECHA_ANULACION,
                ''0''                                                   VERSION,                                                                                
                ''MIG2''                                                USUARIOCREAR,
				SYSDATE                                                 FECHACREAR,     
				0                                                       BORRADO
                FROM INSERTAR MIG
                WHERE ORDEN = 1

                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      
      -- Inicializamos la secuencia S_NUM_PROVISION_GASTO    
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE INICIALIZACION DE LA SECUENCIA S_NUM_PROVISION_GASTO DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
    
      -- Obtenemos el valor maximo de la columna PRG_NUM_PROVISION y lo incrementamos en 1
      V_SENTENCIA := 'SELECT NVL(MAX(PRG_NUM_PROVISION),0) FROM '||V_ESQUEMA||'.'||V_TABLA||'';
      EXECUTE IMMEDIATE V_SENTENCIA INTO MAX_NUM_PROVISION;
    
      MAX_NUM_PROVISION := MAX_NUM_PROVISION +1;
    
      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_NUM_PROVISION_GASTO'' 
          AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS; 
    
      -- Si existe secuencia la borramos
      IF V_NUM_TABLAS = 1 THEN
          EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_NUM_PROVISION_GASTO';
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_NUM_PROVISION_GASTO... Secuencia eliminada');    
      END IF;
    
      EXECUTE IMMEDIATE 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_NUM_PROVISION_GASTO  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH '||MAX_NUM_PROVISION||' NOCACHE NOORDER NOCYCLE';
    
      DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.S_NUM_PROVISION_GASTO... Secuencia creada e inicializada correctamente.');
      
      
      -- INFORMAMOS A LA TABLA INFO
      
      --RECHAZOS POR PRG_NUM_PROVISION DUPLICADO
          V_SENTENCIA := '
			SELECT SUM(COUNT(1))-COUNT(1) FROM MIG2_GPR_PROVISION_GASTOS
			GROUP BY GPR_NUMERO_PROVISION_FONDOS
			HAVING COUNT(1)>1
			'
			;
			EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_3;
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;        
      
      -- Observaciones
      IF V_REJECTS != 0 THEN      
        V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros.';
      
        IF TABLE_COUNT != 0 THEN      
          V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' DD_EPR_ESTADOS_PROVISION_GASTO inexistentes.';      
        END IF;
        
        IF TABLE_COUNT_2 != 0 THEN              
          V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT_2||' PROVEEDOR (TIPO GESTOR) inexistentes.';               
        END IF;
        
        IF TABLE_COUNT_3 != 0 THEN              
          V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT_3||' PRG_NUM_PROVISION duplicados, entran solo los de fecha mas actual';               
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
