--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161010
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_PRD_PROVEEDOR_DIRECCION' -> 'ACT_PRD_PROVEEDOR_DIRECCION'
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
      TABLE_COUNT_2 NUMBER(10,0) := 0;
      TABLE_COUNT_3 NUMBER(10,0) := 0;
      V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
      V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
      V_TABLA VARCHAR2(40 CHAR) := 'ACT_PRD_PROVEEDOR_DIRECCION';
      V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_PRD_PROVEEDOR_DIRECCION';
      V_SENTENCIA VARCHAR2(2000 CHAR);
      V_REG_MIG NUMBER(10,0) := 0;
      V_REG_INSERTADOS NUMBER(10,0) := 0;
      V_REJECTS NUMBER(10,0) := 0;
      V_COD NUMBER(10,0) := 0;
      V_DUP NUMBER(10,0) := 0;
      V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';


BEGIN 
      
      --COMPROBACIONES PREVIAS - PROVEEDOR 
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO PROVEEDOR...');
      
      V_SENTENCIA := '
            SELECT COUNT(1) 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
            WHERE NOT EXISTS (
            SELECT 1 FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_COD_UVEM = MIG.PVE_COD_UVEM
            )
            '
            ;      
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN  
            DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS PROVEEDORES EXISTEN EN ACT_PVE_PROVEEDOR');    
      ELSE
            
            DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' PROVEEDOR INEXISTENTES EN ACT_PVE_PROVEEDOR. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_PVE_NOT_EXISTS.');
            
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
                  MIG.PVE_COD_UVEM 
                  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                  WHERE NOT EXISTS (
                  SELECT 1 FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE WHERE MIG.PVE_COD_UVEM = PVE.PVE_COD_UVEM
                  )
            )
            SELECT DISTINCT
                  MIG.PVE_COD_UVEM                              							PVE_COD_UVEM,
                  '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
                  SYSDATE                                                                 FECHA_COMPROBACION
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
                  INNER JOIN PVE_COD_UVEM ON PVE_COD_UVEM.PVE_COD_UVEM = MIG.PVE_COD_UVEM
            '
            ;
            
            COMMIT;
      
      END IF;
      
      
      --COMPROBACIONES PREVIAS - DD_TDP_TIPO_DIR_PROVEEDOR
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO TIPO DE DIRECCION...');
      
      V_SENTENCIA := '
            SELECT COUNT(1) 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
            SELECT 1 
            FROM '||V_ESQUEMA||'.DD_TDP_TIPO_DIR_PROVEEDOR DD 
            WHERE DD.DD_TDP_CODIGO = MIG2.PRD_COD_TIPO_DIRECCION
            )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
      
      IF TABLE_COUNT_2 = 0 THEN    
            DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS TIPOS DE DIRECCION EXISTEN EN '||V_ESQUEMA||'.DD_TDP_TIPO_DIR_PROVEEDOR');    
      ELSE
            
            DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' TIPOS DE DIRECCION INEXISTENTES EN DD_TDP_TIPO_DIR_PROVEEDOR. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
            
            --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
            
            EXECUTE IMMEDIATE '
                  DELETE FROM '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS
                  WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
                  AND DICCIONARIO = ''DD_TDP_TIPO_DIR_PROVEEDOR''
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
                  PVE_COD_UVEM,
                  '''||V_TABLA_MIG||''',
                  ''PRD_COD_TIPO_DIRECCION'',
                  ''DD_TDP_ID'',
                  PRD_COD_TIPO_DIRECCION,
                  SYSDATE
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
                  SELECT 1 
                  FROM '||V_ESQUEMA||'.DD_TDP_TIPO_DIR_PROVEEDOR DD 
                  WHERE DD.DD_TPC_CODIGO = MIG2.PRD_COD_TIPO_DIRECCION
            )'
            ;
            
            V_COD := SQL%ROWCOUNT;
            
            COMMIT;      
      
      END IF;  
      
      --COMPROBACIONES PREVIAS - TIPO VIA
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO TIPO DE VIA...');
      
      V_SENTENCIA := '
            SELECT COUNT(1) 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
            SELECT 1 
            FROM '||V_ESQUEMA_MASTER||'.DD_TVI_TIPO_VIA DD 
            WHERE DD.DD_TVI_CODIGO = MIG2.PRD_COD_TIPO_VIA
            )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_3;
      
      IF TABLE_COUNT_3 = 0 THEN    
            DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS TIPOS DE VIA EXISTEN EN '||V_ESQUEMA_MASTER||'.DD_TVI_TIPO_VIA');    
      ELSE
            
            DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_3||' TIPOS DE VIA INEXISTENTES EN DD_TVI_TIPO_VIA. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
            
            --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
            
            EXECUTE IMMEDIATE '
                  DELETE FROM '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS
                  WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
                  AND DICCIONARIO = ''DD_TVI_TIPO_VIA''
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
                  PVE_COD_UVEM,
                  '''||V_TABLA_MIG||''',
                  ''PRD_COD_TIPO_VIA'',
                  ''DD_TVI_ID'',
                  PRD_COD_TIPO_VIA,
                  SYSDATE
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
                  SELECT 1 
                  FROM '||V_ESQUEMA_MASTER||'.DD_TVI_TIPO_VIA DD 
                  WHERE DD.DD_TVI_CODIGO = MIG2.PRD_COD_TIPO_VIA
            )'
            ;
            
            V_COD := V_COD + SQL%ROWCOUNT;
            
            COMMIT;      
      
      END IF;  
      
      --Inicio del proceso de volcado sobre ACT_PRD_PROVEEDOR_DIRECCION
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE ('
            INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                  PRD_ID,
                  PVE_ID,
                  DD_TDP_ID,
                  DD_TVI_ID,
                  PRD_NOMBRE,
                  PRD_NUM,
                  PRD_PTA,
                  DD_UPO_ID,
                  DD_PRV_ID,
                  PRD_CP,
                  PRD_TELEFONO,
                  PRD_EMAIL,
                  DD_LOC_ID,
                  VERSION,
                  USUARIOCREAR,
                  FECHACREAR,
                  BORRADO,
                  PVE_COD_DIRECC_UVEM
            )
            SELECT 
                  '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL      						PRD_ID,
                  PVE.PVE_ID															PVE_ID,
                  TDP.DD_TDP_ID														DD_TDP_ID,
                  TVI.DD_TVI_ID														DD_TVI_ID,
                  MIG.PRD_NOMBRE														PRD_NOMBRE,
                  MIG.PRD_NUMERO														PRD_NUM,
                  MIG.PRD_PUERTA														PRD_PTA,
                  UPO.DD_UPO_ID														DD_UPO_ID,
                  PRV.DD_PRV_ID														DD_PRV_ID,
                  MIG.PRD_CODIGO_POSTAL												PRD_CP,
                  MIG.PRD_TELEFONO													PRD_TELEFONO,
                  MIG.PRD_EMAIL														PRD_EMAIL,
                  LOC.DD_LOC_ID														DD_LOC_ID,
                  0                                                                   VERSION,
                  ''MIG2''                                                            USUARIOCREAR,
                  SYSDATE                                                             FECHACREAR,
                  0                                                                   BORRADO,
                  MIG.PVD_COD_DIRECCION                             PVE_COD_DIRECC_UVEM
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG		
                  INNER JOIN ACT_PVE_PROVEEDOR PVE 	ON PVE.PVE_COD_UVEM = MIG.PVE_COD_UVEM
                  INNER JOIN '||V_ESQUEMA||'.DD_TDP_TIPO_DIR_PROVEEDOR TDP ON TDP.DD_TDP_CODIGO = MIG.PRD_COD_TIPO_DIRECCION AND TDP.BORRADO = 0
                  INNER JOIN '||V_ESQUEMA_MASTER||'.DD_TVI_TIPO_VIA TVI	ON TVI.DD_TVI_CODIGO = MIG.PRD_COD_TIPO_VIA AND TVI.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_UPO_UNID_POBLACIONAL UPO	ON UPO.DD_UPO_CODIGO = MIG.PRD_COD_UNIDADPOBLACIONAL AND UPO.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA PRV	ON PRV.DD_PRV_CODIGO = MIG.PRD_COD_PROVINCIA AND PRV.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD LOC	ON LOC.DD_LOC_CODIGO = MIG.PRD_COD_LOCALIDAD AND LOC.BORRADO = 0
      ')
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
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
            V_OBSERVACIONES := 'Se han rechazado  '||V_REJECTS||' registros.';    
            
            IF TABLE_COUNT != 0 THEN    
                  V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' PROVEEDORES inexistentes. ';    
            END IF;     
            
            IF TABLE_COUNT_2 != 0 THEN    
                  V_OBSERVACIONES := V_OBSERVACIONES ||  ' Hay, '||TABLE_COUNT_2||'  DD_TDP_TIPO_DIR_PROVEEDOR inexistentes. ';    
            END IF;       
            
            IF TABLE_COUNT_3 != 0 THEN    
                  V_OBSERVACIONES := V_OBSERVACIONES ||  ' Hay, '||TABLE_COUNT_3||'  DD_TVI_TIPO_VIA inexistentes. ';    
            END IF;      
      END IF;
      
      EXECUTE IMMEDIATE ('
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
      ')
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
