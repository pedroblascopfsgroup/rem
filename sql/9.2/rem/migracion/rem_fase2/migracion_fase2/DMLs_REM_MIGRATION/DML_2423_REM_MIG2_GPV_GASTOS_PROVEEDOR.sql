--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=20161007
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GPV_GASTOS_PROVEEDORES -> GPV_GASTOS_PROVEEDOR
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
      MAX_NUM_GASTO_HAYA NUMBER(10,0) := 0;
      V_NUM_TABLAS NUMBER(10,0) := 0;
      V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
      V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
      V_TABLA VARCHAR2(40 CHAR) := 'GPV_GASTOS_PROVEEDOR';
      V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GPV_GASTOS_PROVEEDORES';
      V_SENTENCIA VARCHAR2(32000 CHAR);
      V_REG_MIG NUMBER(10,0) := 0;
      V_REG_INSERTADOS NUMBER(10,0) := 0;
      V_REG_ADMINISTRACION NUMBER(10,0) := 0;
      V_REG_ENTIDAD NUMBER(10,0) := 0;
      V_REG_PROVEEDOR NUMBER(10,0) := 0;
      V_REG_PVE_GESTORIA NUMBER(10,0) := 0;
      V_REG_PVE_OTROS NUMBER(10,0) := 0;
      V_REJECTS NUMBER(10,0) := 0;
      V_COD NUMBER(10,0) := 0;
      V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
      
      --COMPROBACIONES PREVIAS - DD_TGA_TIPOS_GASTO
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO TIPOS DE GASTOS...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
      SELECT 1 
      FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO DD 
      WHERE DD.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN    
            DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS TIPOS DE GASTOS EXISTEN EN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO');    
      ELSE
      
            DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' TIPOS DE GASTOS INEXISTENTES EN DD_TGA_TIPOS_GASTO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
            
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
                  GPV_COD_GASTO_PROVEEDOR,
                  '''||V_TABLA_MIG||''',
                  ''GPV_COD_TIPO_GASTO'',
                  ''DD_TGA_ID'',
                  GPV_COD_TIPO_GASTO,
                  SYSDATE
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
            SELECT 1 
            FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO DD 
            WHERE DD.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
            )'
            ;
            
            V_COD := SQL%ROWCOUNT;
            
            COMMIT;
            
      END IF; 
      
      
      --COMPROBACIONES PREVIAS - DD_STG_SUBTIPOS_GASTO
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO SUBTIPOS DE GASTOS...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
      SELECT 1 
      FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO DD 
      WHERE DD.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
      
      IF TABLE_COUNT_2 = 0 THEN    
            DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS SUBTIPOS DE GASTOS EXISTEN EN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO');    
      ELSE
      
            DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' SUBTIPOS DE GASTOS INEXISTENTES EN DD_STG_SUBTIPOS_GASTO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
            
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
                  GPV_COD_GASTO_PROVEEDOR,
                  '''||V_TABLA_MIG||''',
                  ''GPV_COD_SUBTIPO_GASTO'',
                  ''DD_STG_ID'',
                  GPV_COD_SUBTIPO_GASTO,
                  SYSDATE
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
                  SELECT 1 
                  FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO DD 
                  WHERE DD.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
            )'
            ;
            
            V_COD := V_COD + SQL%ROWCOUNT;
            
            COMMIT;    
      
      END IF;   
      
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      --BLOQUE DE ADMINISTRACION
      V_SENTENCIA := '
      INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            GPV_ID
            ,GPV_NUM_GASTO_HAYA
            ,GPV_NUM_GASTO_GESTORIA
            ,GPV_REF_EMISOR
            ,DD_TGA_ID
            ,DD_STG_ID
            ,GPV_CONCEPTO
            ,DD_TPE_ID
            ,PVE_ID_EMISOR
            ,PRO_ID
            ,GPV_FECHA_EMISION
            ,GPV_FECHA_NOTIFICACION
            ,DD_DEG_ID
            ,GPV_CUBRE_SEGURO
            ,GPV_OBSERVACIONES
            ,GPV_COD_GASTO_AGRUPADO
            ,GPV_COD_TIPO_OPERACION
            ,GPV_NUMERO_FACTURA_UVEM
            ,GPV_NUMERO_PROVISION_FONDOS
            ,GPV_NUMERO_PRESUPUESTO
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,USUARIOMODIFICAR
            ,FECHAMODIFICAR
            ,USUARIOBORRAR
            ,FECHABORRAR
            ,BORRADO
            ,PRG_ID
      )
      WITH INSERTAR AS (
            SELECT DISTINCT MIG.GPV_ID    
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
            WHERE NOT EXISTS ( 
                  SELECT 1
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' GPV2
                  WHERE GPV2.GPV_NUM_GASTO_HAYA = MIG.GPV_ID
            )  
      )
      SELECT
            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                     GPV_ID
            ,MIG2.GPV_ID                                                GPV_NUM_GASTO_HAYA
            ,MIG2.GPV_COD_GASTO_PROVEEDOR                               GPV_NUM_GASTO_GESTORIA
            ,MIG2.GPV_REFERENCIA_EMISOR                                 GPV_REF_EMISOR
            ,TGA.DD_TGA_ID                                              DD_TGA_ID
            ,STG.DD_STG_ID                                              DD_STG_ID
            ,MIG2.GPV_CONCEPTO                                          GPV_CONCEPTO
            ,TPE.DD_TPE_ID                                              DD_TPE_ID
            ,PVE.PVE_ID                                                 PVE_ID_EMISOR
            ,NULL                                                       PRO_ID
            ,MIG2.GPV_FECHA_EMISION                                     GPV_FECHA_EMISION
            ,MIG2.GPV_FECHA_NOTIFICACION                                GPV_FECHA_NOTIFICACION
            ,DEG.DD_DEG_ID                                              DD_DEG_ID
            ,MIG2.GPV_IND_CUBRE_SEGURO                                  GPV_CUBRE_SEGURO
            ,MIG2.GPV_OBSERVACIONES                                     GPV_OBSERVACIONES
            ,MIG2.GPV_COD_GASTO_AGRUPADO                                GPV_COD_GASTO_AGRUPADO
            ,MIG2.GPV_COD_TIPO_OPERACION                                GPV_COD_TIPO_OPERACION   
            ,MIG2.GPV_NUMERO_FACTURA_UVEM                               GPV_NUMERO_FACTURA_UVEM
            ,MIG2.GPV_NUMERO_PROVISION_FONDOS                           GPV_NUMERO_PROVISION_FONDOS
            ,MIG2.GPV_NUMERO_PRESUPUESTO                                GPV_NUMERO_PRESUPUESTO
            ,0                                                          VERSION
            ,''MIG2''                                                   USUARIOCREAR
            ,SYSDATE                                                    FECHACREAR
            ,NULL                                                       USUARIOMODIFICAR
            ,NULL                                                       FECHAMODIFICAR
            ,NULL                                                       USUARIOBORRAR
            ,NULL                                                       FECHABORRAR
            ,0                                                          BORRADO
            ,NULL                                                       PRG_ID
      FROM INSERTAR INS
            INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON INS.GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
            INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID  = TPR.DD_TPR_ID 
            LEFT JOIN  '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, ''01'')            
            LEFT JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_CODIGO = MIG2.GPV_COD_DESTINATARIO
      WHERE  ((TGA.DD_TGA_CODIGO = ''01'' AND TPR.DD_TPR_CODIGO IN (''13'', ''15''))
            OR (TGA.DD_TGA_CODIGO = ''02'' AND TPR.DD_TPR_CODIGO IN (''13'', ''16''))
            OR (TGA.DD_TGA_CODIGO = ''03'' AND TPR.DD_TPR_CODIGO IN (''13'', ''17''))
            OR (TGA.DD_TGA_CODIGO = ''04'' AND TPR.DD_TPR_CODIGO IN (''13'',''16'',''17'')))
      '
      ;
      
      
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas de gastos de proveedores de tipo ADMINISTRACION.');
      
      V_REG_ADMINISTRACION := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      
      --BLOQUE DE ENTIDAD
      V_SENTENCIA := '
      INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            GPV_ID
            ,GPV_NUM_GASTO_HAYA
            ,GPV_NUM_GASTO_GESTORIA
            ,GPV_REF_EMISOR
            ,DD_TGA_ID
            ,DD_STG_ID
            ,GPV_CONCEPTO
            ,DD_TPE_ID
            ,PVE_ID_EMISOR
            ,PRO_ID
            ,GPV_FECHA_EMISION
            ,GPV_FECHA_NOTIFICACION
            ,DD_DEG_ID
            ,GPV_CUBRE_SEGURO
            ,GPV_OBSERVACIONES
            ,GPV_COD_GASTO_AGRUPADO
            ,GPV_COD_TIPO_OPERACION
            ,GPV_NUMERO_FACTURA_UVEM
            ,GPV_NUMERO_PROVISION_FONDOS
            ,GPV_NUMERO_PRESUPUESTO
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,USUARIOMODIFICAR
            ,FECHAMODIFICAR
            ,USUARIOBORRAR
            ,FECHABORRAR
            ,BORRADO
            ,PRG_ID
      )
      WITH INSERTAR AS (
            SELECT DISTINCT MIG.GPV_ID    
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
            WHERE NOT EXISTS ( 
                  SELECT 1
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' GPV2
                  WHERE GPV2.GPV_NUM_GASTO_HAYA = MIG.GPV_ID
            )  
      )
      SELECT
            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                     GPV_ID
            ,MIG2.GPV_ID                                                GPV_NUM_GASTO_HAYA
            ,MIG2.GPV_COD_GASTO_PROVEEDOR                               GPV_NUM_GASTO_GESTORIA
            ,MIG2.GPV_REFERENCIA_EMISOR                                 GPV_REF_EMISOR
            ,TGA.DD_TGA_ID                                              DD_TGA_ID
            ,STG.DD_STG_ID                                              DD_STG_ID
            ,MIG2.GPV_CONCEPTO                                          GPV_CONCEPTO
            ,TPE.DD_TPE_ID                                              DD_TPE_ID
            ,PVE.PVE_ID                                                 PVE_ID_EMISOR
            ,NULL                                                       PRO_ID
            ,MIG2.GPV_FECHA_EMISION                                     GPV_FECHA_EMISION
            ,MIG2.GPV_FECHA_NOTIFICACION                                GPV_FECHA_NOTIFICACION
            ,DEG.DD_DEG_ID                                              DD_DEG_ID
            ,MIG2.GPV_IND_CUBRE_SEGURO                                  GPV_CUBRE_SEGURO
            ,MIG2.GPV_OBSERVACIONES                                     GPV_OBSERVACIONES
            ,MIG2.GPV_COD_GASTO_AGRUPADO                                GPV_COD_GASTO_AGRUPADO
            ,MIG2.GPV_COD_TIPO_OPERACION                                GPV_COD_TIPO_OPERACION   
            ,MIG2.GPV_NUMERO_FACTURA_UVEM                               GPV_NUMERO_FACTURA_UVEM
            ,MIG2.GPV_NUMERO_PROVISION_FONDOS                           GPV_NUMERO_PROVISION_FONDOS
            ,MIG2.GPV_NUMERO_PRESUPUESTO                                GPV_NUMERO_PRESUPUESTO
            ,0                                                          VERSION
            ,''MIG2''                                                   USUARIOCREAR
            ,SYSDATE                                                    FECHACREAR
            ,NULL                                                       USUARIOMODIFICAR
            ,NULL                                                       FECHAMODIFICAR
            ,NULL                                                       USUARIOBORRAR
            ,NULL                                                       FECHABORRAR
            ,0                                                          BORRADO
            ,NULL                                                       PRG_ID
      FROM INSERTAR INS
            INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON INS.GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
            INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID  = TPR.DD_TPR_ID 
            LEFT JOIN  '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, ''01'')            
            LEFT JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_CODIGO = MIG2.GPV_COD_DESTINATARIO
      WHERE  ((TGA.DD_TGA_CODIGO = ''05'' AND TPR.DD_TPR_CODIGO IN (''07''))
            OR (TGA.DD_TGA_CODIGO = ''06'' AND TPR.DD_TPR_CODIGO IN (''08''))
            OR (TGA.DD_TGA_CODIGO = ''07'' AND TPR.DD_TPR_CODIGO IN (''10''))
            OR (TGA.DD_TGA_CODIGO = ''08'' AND TPR.DD_TPR_CODIGO IN (''12'')))
      '
      ;
      
      
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas de gastos de proveedores de tipo ENTIDAD.');
      
      V_REG_ENTIDAD := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      
      --BLOQUE DE PROVEEDOR
      V_SENTENCIA := '
      INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            GPV_ID
            ,GPV_NUM_GASTO_HAYA
            ,GPV_NUM_GASTO_GESTORIA
            ,GPV_REF_EMISOR
            ,DD_TGA_ID
            ,DD_STG_ID
            ,GPV_CONCEPTO
            ,DD_TPE_ID
            ,PVE_ID_EMISOR
            ,PRO_ID
            ,GPV_FECHA_EMISION
            ,GPV_FECHA_NOTIFICACION
            ,DD_DEG_ID
            ,GPV_CUBRE_SEGURO
            ,GPV_OBSERVACIONES
            ,GPV_COD_GASTO_AGRUPADO
            ,GPV_COD_TIPO_OPERACION
            ,GPV_NUMERO_FACTURA_UVEM
            ,GPV_NUMERO_PROVISION_FONDOS
            ,GPV_NUMERO_PRESUPUESTO
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,USUARIOMODIFICAR
            ,FECHAMODIFICAR
            ,USUARIOBORRAR
            ,FECHABORRAR
            ,BORRADO
            ,PRG_ID
      )
      WITH INSERTAR AS (
            SELECT DISTINCT MIG.GPV_ID    
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
            WHERE NOT EXISTS ( 
                  SELECT 1
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' GPV2
                  WHERE GPV2.GPV_NUM_GASTO_HAYA = MIG.GPV_ID
            ) 
      )
      SELECT
            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                     GPV_ID
            ,MIG2.GPV_ID                                                GPV_NUM_GASTO_HAYA
            ,MIG2.GPV_COD_GASTO_PROVEEDOR                               GPV_NUM_GASTO_GESTORIA
            ,MIG2.GPV_REFERENCIA_EMISOR                                 GPV_REF_EMISOR
            ,TGA.DD_TGA_ID                                              DD_TGA_ID
            ,STG.DD_STG_ID                                              DD_STG_ID
            ,MIG2.GPV_CONCEPTO                                          GPV_CONCEPTO
            ,TPE.DD_TPE_ID                                              DD_TPE_ID
            ,PVE.PVE_ID                                                 PVE_ID_EMISOR
            ,NULL                                                       PRO_ID
            ,MIG2.GPV_FECHA_EMISION                                     GPV_FECHA_EMISION
            ,MIG2.GPV_FECHA_NOTIFICACION                                GPV_FECHA_NOTIFICACION
            ,DEG.DD_DEG_ID                                              DD_DEG_ID
            ,MIG2.GPV_IND_CUBRE_SEGURO                                  GPV_CUBRE_SEGURO
            ,MIG2.GPV_OBSERVACIONES                                     GPV_OBSERVACIONES
            ,MIG2.GPV_COD_GASTO_AGRUPADO                                GPV_COD_GASTO_AGRUPADO
            ,MIG2.GPV_COD_TIPO_OPERACION                                GPV_COD_TIPO_OPERACION   
            ,MIG2.GPV_NUMERO_FACTURA_UVEM                               GPV_NUMERO_FACTURA_UVEM
            ,MIG2.GPV_NUMERO_PROVISION_FONDOS                           GPV_NUMERO_PROVISION_FONDOS
            ,MIG2.GPV_NUMERO_PRESUPUESTO                                GPV_NUMERO_PRESUPUESTO
            ,0                                                          VERSION
            ,''MIG2''                                                   USUARIOCREAR
            ,SYSDATE                                                    FECHACREAR
            ,NULL                                                       USUARIOMODIFICAR
            ,NULL                                                       FECHAMODIFICAR
            ,NULL                                                       USUARIOBORRAR
            ,NULL                                                       FECHABORRAR
            ,0                                                          BORRADO
            ,NULL                                                       PRG_ID
      FROM INSERTAR INS
            INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON INS.GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
            INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID  = TPR.DD_TPR_ID 
            LEFT JOIN  '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, ''01'')            
            LEFT JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_CODIGO = MIG2.GPV_COD_DESTINATARIO
      WHERE ((TGA.DD_TGA_CODIGO = ''09'' AND TPR.DD_TPR_CODIGO IN (''25''))
            OR (TGA.DD_TGA_CODIGO = ''10'' AND TPR.DD_TPR_CODIGO IN (''03''))
            OR (TGA.DD_TGA_CODIGO = ''11'' AND TPR.DD_TPR_CODIGO IN (''02'',''05'',''19'',''21'',''24''))
            OR (TGA.DD_TGA_CODIGO = ''12'' AND TPR.DD_TPR_CODIGO IN (''01''))
            OR (TGA.DD_TGA_CODIGO = ''13'' AND TPR.DD_TPR_CODIGO IN (''04'',''18''))
            OR (TGA.DD_TGA_CODIGO = ''14'' AND TPR.DD_TPR_CODIGO IN (''01'',''05'',''06''))
            OR (TGA.DD_TGA_CODIGO = ''15'' AND TPR.DD_TPR_CODIGO IN (''05''))
            OR (TGA.DD_TGA_CODIGO = ''16'' AND TPR.DD_TPR_CODIGO IN (''05''))
            OR (TGA.DD_TGA_CODIGO = ''17'' AND TPR.DD_TPR_CODIGO IN (''27''))
            OR (TGA.DD_TGA_CODIGO = ''18'' AND TPR.DD_TPR_CODIGO IN (''27'')))
      '
      ;
      
      
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas de gastos de proveedores de tipo PROVEEDOR.');
      
      V_REG_PROVEEDOR := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      
      --APARTIR DE AQUI INSERTAMREMOS POR DEFECTO PRIMERO LOS PROVEEDORES QUE SEAN DE TIPO 'GESTORIA' Y DESPUES, PROVEEDORES DEL PRIMER TIPO QUE APAREZCA PARA EL RESTO.
       
      --INSERCION POR DEFECTO DE PROVEEDORES DE GESTORIAS
      V_SENTENCIA := '
      INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            GPV_ID
            ,GPV_NUM_GASTO_HAYA
            ,GPV_NUM_GASTO_GESTORIA
            ,GPV_REF_EMISOR
            ,DD_TGA_ID
            ,DD_STG_ID
            ,GPV_CONCEPTO
            ,DD_TPE_ID
            ,PVE_ID_EMISOR
            ,PRO_ID
            ,GPV_FECHA_EMISION
            ,GPV_FECHA_NOTIFICACION
            ,DD_DEG_ID
            ,GPV_CUBRE_SEGURO
            ,GPV_OBSERVACIONES
            ,GPV_COD_GASTO_AGRUPADO
            ,GPV_COD_TIPO_OPERACION
            ,GPV_NUMERO_FACTURA_UVEM
            ,GPV_NUMERO_PROVISION_FONDOS
            ,GPV_NUMERO_PRESUPUESTO
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,USUARIOMODIFICAR
            ,FECHAMODIFICAR
            ,USUARIOBORRAR
            ,FECHABORRAR
            ,BORRADO
            ,PRG_ID
      )
      WITH INSERTAR AS (
            SELECT DISTINCT MIG.GPV_ID    
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
            WHERE NOT EXISTS ( 
                  SELECT 1
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' GPV2
                  WHERE GPV2.GPV_NUM_GASTO_HAYA = MIG.GPV_ID
            ) 
      )
      SELECT
            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                     GPV_ID
            ,MIG2.GPV_ID                                                GPV_NUM_GASTO_HAYA
            ,MIG2.GPV_COD_GASTO_PROVEEDOR                               GPV_NUM_GASTO_GESTORIA
            ,MIG2.GPV_REFERENCIA_EMISOR                                 GPV_REF_EMISOR
            ,TGA.DD_TGA_ID                                              DD_TGA_ID
            ,STG.DD_STG_ID                                              DD_STG_ID
            ,MIG2.GPV_CONCEPTO                                          GPV_CONCEPTO
            ,TPE.DD_TPE_ID                                              DD_TPE_ID
            ,PVE.PVE_ID                                                 PVE_ID_EMISOR
            ,NULL                                                       PRO_ID
            ,MIG2.GPV_FECHA_EMISION                                     GPV_FECHA_EMISION
            ,MIG2.GPV_FECHA_NOTIFICACION                                GPV_FECHA_NOTIFICACION
            ,DEG.DD_DEG_ID                                              DD_DEG_ID
            ,MIG2.GPV_IND_CUBRE_SEGURO                                  GPV_CUBRE_SEGURO
            ,MIG2.GPV_OBSERVACIONES                                     GPV_OBSERVACIONES
            ,MIG2.GPV_COD_GASTO_AGRUPADO                                GPV_COD_GASTO_AGRUPADO
            ,MIG2.GPV_COD_TIPO_OPERACION                                GPV_COD_TIPO_OPERACION   
            ,MIG2.GPV_NUMERO_FACTURA_UVEM                               GPV_NUMERO_FACTURA_UVEM
            ,MIG2.GPV_NUMERO_PROVISION_FONDOS                           GPV_NUMERO_PROVISION_FONDOS
            ,MIG2.GPV_NUMERO_PRESUPUESTO                                GPV_NUMERO_PRESUPUESTO
            ,0                                                          VERSION
            ,''MIG2''                                                   USUARIOCREAR
            ,SYSDATE                                                    FECHACREAR
            ,NULL                                                       USUARIOMODIFICAR
            ,NULL                                                       FECHAMODIFICAR
            ,NULL                                                       USUARIOBORRAR
            ,NULL                                                       FECHABORRAR
            ,0                                                          BORRADO
            ,NULL                                                       PRG_ID
      FROM INSERTAR INS
            INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON INS.GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
            INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID  = TPR.DD_TPR_ID 
            LEFT JOIN  '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, ''01'')            
            LEFT JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_CODIGO = MIG2.GPV_COD_DESTINATARIO
	  WHERE TPR.DD_TPR_CODIGO = ''01''
      '
      ;
      
      
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas de gastos de proveedores de tipo ''GESTORIA''.');
      
      V_REG_PVE_GESTORIA := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      
      --INSERCION POR DEFECTO DE PROVEEDORES DEL PRIMER TIPO QUE APAREZCA
      V_SENTENCIA := '
      INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            GPV_ID
            ,GPV_NUM_GASTO_HAYA
            ,GPV_NUM_GASTO_GESTORIA
            ,GPV_REF_EMISOR
            ,DD_TGA_ID
            ,DD_STG_ID
            ,GPV_CONCEPTO
            ,DD_TPE_ID
            ,PVE_ID_EMISOR
            ,PRO_ID
            ,GPV_FECHA_EMISION
            ,GPV_FECHA_NOTIFICACION
            ,DD_DEG_ID
            ,GPV_CUBRE_SEGURO
            ,GPV_OBSERVACIONES
            ,GPV_COD_GASTO_AGRUPADO
            ,GPV_COD_TIPO_OPERACION
            ,GPV_NUMERO_FACTURA_UVEM
            ,GPV_NUMERO_PROVISION_FONDOS
            ,GPV_NUMERO_PRESUPUESTO
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,USUARIOMODIFICAR
            ,FECHAMODIFICAR
            ,USUARIOBORRAR
            ,FECHABORRAR
            ,BORRADO
            ,PRG_ID
      )
      WITH INSERTAR AS (
            SELECT DISTINCT MIG.GPV_ID    
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
            WHERE NOT EXISTS ( 
                  SELECT 1
                  FROM '||V_ESQUEMA||'.'||V_TABLA||' GPV2
                  WHERE GPV2.GPV_NUM_GASTO_HAYA = MIG.GPV_ID
            ) 
      )
      SELECT 
       '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                     		GPV_ID
      ,GPV_NUM_GASTO_HAYA									
      ,GPV_NUM_GASTO_GESTORIA                                    
      ,GPV_REF_EMISOR                                    
      ,DD_TGA_ID                                    
      ,DD_STG_ID                                    
      ,GPV_CONCEPTO                                    
      ,DD_TPE_ID                                    
      ,PVE_ID_EMISOR                                    
      ,PRO_ID                                    
      ,GPV_FECHA_EMISION                                    
      ,GPV_FECHA_NOTIFICACION                                    
      ,DD_DEG_ID                                    
      ,GPV_CUBRE_SEGURO                                    
      ,GPV_OBSERVACIONES                                    
      ,GPV_COD_GASTO_AGRUPADO                                    
      ,GPV_COD_TIPO_OPERACION                                       
      ,GPV_NUMERO_FACTURA_UVEM                                    
      ,GPV_NUMERO_PROVISION_FONDOS                                    
      ,GPV_NUMERO_PRESUPUESTO                                    
      ,VERSION                                    
      ,USUARIOCREAR                                    
      ,FECHACREAR                                    
      ,USUARIOMODIFICAR                                    
      ,FECHAMODIFICAR                                    
      ,USUARIOBORRAR                                    
      ,FECHABORRAR                                    
      ,BORRADO                                    
      ,PRG_ID                                    
      FROM(
			SELECT
				ROW_NUMBER() OVER (PARTITION BY MIG2.GPV_ID  ORDER BY PVE.DD_TPR_ID) AS PARTICION
				,MIG2.GPV_ID                                            GPV_NUM_GASTO_HAYA    
				,MIG2.GPV_COD_GASTO_PROVEEDOR                           GPV_NUM_GASTO_GESTORIA    
				,MIG2.GPV_REFERENCIA_EMISOR                             GPV_REF_EMISOR    
				,TGA.DD_TGA_ID                                          DD_TGA_ID    
				,STG.DD_STG_ID                                          DD_STG_ID    
				,MIG2.GPV_CONCEPTO                                      GPV_CONCEPTO    
				,TPE.DD_TPE_ID                                          DD_TPE_ID    
				,PVE.PVE_ID                                             PVE_ID_EMISOR    
				,NULL                                                   PRO_ID    
				,MIG2.GPV_FECHA_EMISION                                 GPV_FECHA_EMISION    
				,MIG2.GPV_FECHA_NOTIFICACION                            GPV_FECHA_NOTIFICACION    
				,DEG.DD_DEG_ID                                          DD_DEG_ID    
				,MIG2.GPV_IND_CUBRE_SEGURO                              GPV_CUBRE_SEGURO    
				,MIG2.GPV_OBSERVACIONES                                 GPV_OBSERVACIONES    
				,MIG2.GPV_COD_GASTO_AGRUPADO                            GPV_COD_GASTO_AGRUPADO    
				,MIG2.GPV_COD_TIPO_OPERACION                            GPV_COD_TIPO_OPERACION       
				,MIG2.GPV_NUMERO_FACTURA_UVEM                           GPV_NUMERO_FACTURA_UVEM    
				,MIG2.GPV_NUMERO_PROVISION_FONDOS                       GPV_NUMERO_PROVISION_FONDOS    
				,MIG2.GPV_NUMERO_PRESUPUESTO                            GPV_NUMERO_PRESUPUESTO    
				,0                                                      VERSION    
				,''MIG2''                                               USUARIOCREAR    
				,SYSDATE                                                FECHACREAR    
				,NULL                                                   USUARIOMODIFICAR    
				,NULL                                                   FECHAMODIFICAR    
				,NULL                                                   USUARIOBORRAR    
				,NULL                                                   FECHABORRAR    
				,0                                                      BORRADO    
				,NULL                                                   PRG_ID    
			FROM INSERTAR INS
				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON INS.GPV_ID = MIG2.GPV_ID
				INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
				INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
				INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
				INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID  = TPR.DD_TPR_ID 
				LEFT JOIN  '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, ''01'')            
				LEFT JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_CODIGO = MIG2.GPV_COD_DESTINATARIO)
				WHERE PARTICION = 1
      '
      ;      
      
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas de gastos de proveedores asignadas POR DEFECTO.');
      
      V_REG_PVE_OTROS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      V_REG_INSERTADOS := V_REG_ADMINISTRACION + V_REG_ENTIDAD + V_REG_PROVEEDOR + V_REG_PVE_GESTORIA + V_REG_PVE_OTROS;
      
      -- Inicializamos la secuencia S_GPV_NUM_GASTO_HAYA    
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE INICIALIZACION DE LA SECUENCIA S_GPV_NUM_GASTO_HAYA DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      -- Obtenemos el valor maximo de la columna GPV_NUM_GASTO_HAYA y lo incrementamos en 1
      V_SENTENCIA := 'SELECT NVL(MAX(GPV_NUM_GASTO_HAYA),0) FROM '||V_ESQUEMA||'.'||V_TABLA||'';
      EXECUTE IMMEDIATE V_SENTENCIA INTO MAX_NUM_GASTO_HAYA;
      
      MAX_NUM_GASTO_HAYA := MAX_NUM_GASTO_HAYA +1;
      
      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_GPV_NUM_GASTO_HAYA'' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS; 
      
      -- Si existe secuencia la borramos
      IF V_NUM_TABLAS = 1 THEN
            EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_GPV_NUM_GASTO_HAYA';
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_GPV_NUM_GASTO_HAYA... Secuencia eliminada');    
      END IF;
      
      EXECUTE IMMEDIATE 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_GPV_NUM_GASTO_HAYA MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH '||MAX_NUM_GASTO_HAYA||' NOCACHE NOORDER  NOCYCLE';
      
      DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.S_GPV_NUM_GASTO_HAYA... Secuencia creada e inicializada correctamente.');
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;        
      
      -- Validacion de PROVEEDORES inexistentes
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
					  WHERE NOT EXISTS (
					  SELECT 1 FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_COD_UVEM = TO_CHAR(MIG.GPV_COD_PVE_UVEM_EMISOR))
					 ';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_3;
      
      -- Observaciones
      IF V_REJECTS != 0 THEN      
            V_OBSERVACIONES := 'Se han rechazado, '||V_REJECTS||' registros. ';
            
            IF TABLE_COUNT != 0 THEN            
                  V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' CODIGOS DD_TGA_TIPOS_GASTO inexistentes. ';             
            END IF;
            
            IF TABLE_COUNT_2 != 0 THEN          
                  V_OBSERVACIONES := V_OBSERVACIONES ||  ' Hay, '||TABLE_COUNT_2||' CODIGOS DD_STG_SUBTIPOS_GASTO inexistentes. ';              
            END IF;
            
            IF TABLE_COUNT_3 != 0 THEN          
                  V_OBSERVACIONES := V_OBSERVACIONES ||  ' Hay, '||TABLE_COUNT_3||' Proveedores inexistentes. ';              
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
