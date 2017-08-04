--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
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
      V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
      V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
      V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#'; 
      V_TABLA VARCHAR2(40 CHAR) := 'GPV_GASTOS_PROVEEDOR';
      V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GPV_GASTOS_PROVEEDORES';
      V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN
      
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
            ,DD_TOG_ID
            ,PVE_ID_GESTORIA
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
            ,PRO.PRO_ID                                                       PRO_ID
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
            ,TOG.DD_TOG_ID                                              DD_TOG_ID
            ,CASE WHEN GDE.GDE_COD_TIPO_IMPUESTO IS NULL THEN PVE.PVE_ID ELSE NULL END PVE_ID_GESTORIA
            ,0                                                          VERSION
            ,'''||V_USUARIO||'''                                    USUARIOCREAR
            ,SYSDATE                                                    FECHACREAR
            ,NULL                                                       USUARIOMODIFICAR
            ,NULL                                                       FECHAMODIFICAR
            ,NULL                                                       USUARIOBORRAR
            ,NULL                                                       FECHABORRAR
            ,0                                                          BORRADO
            ,PRG.PRG_ID                                                 PRG_ID
      FROM INSERTAR INS
            INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON INS.GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GDE.GDE_GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
            INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID  = TPR.DD_TPR_ID
            LEFT  JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO TIT ON TIT.DD_TIT_CODIGO = GDE.GDE_COD_TIPO_IMPUESTO
            LEFT  JOIN '||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG ON PRG.PRG_NUM_PROVISION = MIG2.GPV_NUMERO_PROVISION_FONDOS
            LEFT  JOIN '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, ''01'')            
            LEFT  JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_CODIGO = ''01''
            LEFT  JOIN '||V_ESQUEMA||'.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = MIG2.GPV_COD_TIPO_OPERACION
            LEFT JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_DOCIDENTIF = ''A86602158''
            LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = ''02'' AND CRA.DD_CRA_ID = PRO.DD_CRA_ID
      WHERE MIG2.VALIDACION = 0
            AND ((TGA.DD_TGA_CODIGO = ''01'' AND TPR.DD_TPR_CODIGO IN (''13'', ''15''))
            OR (TGA.DD_TGA_CODIGO = ''02'' AND TPR.DD_TPR_CODIGO IN (''13'', ''16''))
            OR (TGA.DD_TGA_CODIGO = ''03'' AND TPR.DD_TPR_CODIGO IN (''13'', ''17''))
            OR (TGA.DD_TGA_CODIGO = ''04'' AND TPR.DD_TPR_CODIGO IN (''13'',''16'',''17'')))
      '
      ;
      
      
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas de gastos de proveedores de tipo ADMINISTRACION.');
      
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
            ,DD_TOG_ID
            ,PVE_ID_GESTORIA
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
            ,PRO.PRO_ID                                                       PRO_ID
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
            ,TOG.DD_TOG_ID                                                                      DD_TOG_ID
            ,CASE WHEN GDE.GDE_COD_TIPO_IMPUESTO IS NULL THEN PVE.PVE_ID ELSE NULL END PVE_ID_GESTORIA
            ,0                                                          VERSION
            ,'''||V_USUARIO||'''                                    USUARIOCREAR
            ,SYSDATE                                                    FECHACREAR
            ,NULL                                                       USUARIOMODIFICAR
            ,NULL                                                       FECHAMODIFICAR
            ,NULL                                                       USUARIOBORRAR
            ,NULL                                                       FECHABORRAR
            ,0                                                          BORRADO
            ,PRG.PRG_ID                                                 PRG_ID
      FROM INSERTAR INS
            INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON INS.GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GDE.GDE_GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
            INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID  = TPR.DD_TPR_ID 
            LEFT  JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO TIT ON TIT.DD_TIT_CODIGO = GDE.GDE_COD_TIPO_IMPUESTO
            LEFT JOIN  '||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG ON PRG.PRG_NUM_PROVISION = MIG2.GPV_NUMERO_PROVISION_FONDOS
            LEFT JOIN  '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, ''01'')            
            LEFT JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_CODIGO = ''01''
            LEFT JOIN '||V_ESQUEMA||'.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = MIG2.GPV_COD_TIPO_OPERACION
            LEFT JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_DOCIDENTIF = ''A86602158''
            LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = ''02'' AND CRA.DD_CRA_ID = PRO.DD_CRA_ID
      WHERE MIG2.VALIDACION = 0
            AND ((TGA.DD_TGA_CODIGO = ''05'' AND TPR.DD_TPR_CODIGO IN (''07''))
            OR (TGA.DD_TGA_CODIGO = ''06'' AND TPR.DD_TPR_CODIGO IN (''08''))
            OR (TGA.DD_TGA_CODIGO = ''07'' AND TPR.DD_TPR_CODIGO IN (''10''))
            OR (TGA.DD_TGA_CODIGO = ''08'' AND TPR.DD_TPR_CODIGO IN (''12'')))
      '
      ;
      
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas de gastos de proveedores de tipo ENTIDAD.');
      
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
            ,DD_TOG_ID
            ,PVE_ID_GESTORIA
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
            ,PRO.PRO_ID                                                       PRO_ID
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
            ,TOG.DD_TOG_ID                                                                      DD_TOG_ID
            ,CASE WHEN GDE.GDE_COD_TIPO_IMPUESTO IS NULL THEN PVE.PVE_ID ELSE NULL END PVE_ID_GESTORIA
            ,0                                                          VERSION
            ,'''||V_USUARIO||'''                                                  USUARIOCREAR
            ,SYSDATE                                                    FECHACREAR
            ,NULL                                                       USUARIOMODIFICAR
            ,NULL                                                       FECHAMODIFICAR
            ,NULL                                                       USUARIOBORRAR
            ,NULL                                                       FECHABORRAR
            ,0                                                          BORRADO
            ,PRG.PRG_ID                                                 PRG_ID
      FROM INSERTAR INS
            INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON INS.GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GDE.GDE_GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
            INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID  = TPR.DD_TPR_ID
            LEFT  JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO TIT ON TIT.DD_TIT_CODIGO = GDE.GDE_COD_TIPO_IMPUESTO
            LEFT JOIN '||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG ON PRG.PRG_NUM_PROVISION = MIG2.GPV_NUMERO_PROVISION_FONDOS 
            LEFT JOIN '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, ''01'')            
            LEFT JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_CODIGO = ''01''
            LEFT JOIN '||V_ESQUEMA||'.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = MIG2.GPV_COD_TIPO_OPERACION
                        LEFT JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_DOCIDENTIF = ''A86602158''
            LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = ''02'' AND CRA.DD_CRA_ID = PRO.DD_CRA_ID
      WHERE MIG2.VALIDACION = 0 
            AND ((TGA.DD_TGA_CODIGO = ''09'' AND TPR.DD_TPR_CODIGO IN (''25''))
            OR (TGA.DD_TGA_CODIGO = ''10'' AND TPR.DD_TPR_CODIGO IN (''03''))            
            OR (TGA.DD_TGA_CODIGO = ''11'' AND STG.DD_STG_CODIGO = ''51'' AND TPR.DD_TPR_CODIGO = ''02'')
            OR (TGA.DD_TGA_CODIGO = ''11'' AND STG.DD_STG_CODIGO = ''50'' AND TPR.DD_TPR_CODIGO = ''05'')
            OR (TGA.DD_TGA_CODIGO = ''11'' AND STG.DD_STG_CODIGO IN (''45'', ''95'', ''96'', ''97'', ''46'', ''47'', ''48'', ''49'', ''52'') AND TPR.DD_TPR_CODIGO = ''19'')
            OR (TGA.DD_TGA_CODIGO = ''11'' AND STG.DD_STG_CODIGO = ''44'' AND TPR.DD_TPR_CODIGO = ''21'')
            OR (TGA.DD_TGA_CODIGO = ''11'' AND STG.DD_STG_CODIGO = ''43'' AND TPR.DD_TPR_CODIGO = ''24'')
            OR (TGA.DD_TGA_CODIGO = ''12'' AND TPR.DD_TPR_CODIGO IN (''01''))
            OR (TGA.DD_TGA_CODIGO = ''13'' AND STG.DD_STG_CODIGO = ''55'' AND TPR.DD_TPR_CODIGO = ''04'')
            OR (TGA.DD_TGA_CODIGO = ''13'' AND STG.DD_STG_CODIGO = ''56'' AND TPR.DD_TPR_CODIGO = ''18'')            
            OR (TGA.DD_TGA_CODIGO = ''14'' AND STG.DD_STG_CODIGO IN (''60'', ''63'', ''64'', ''65'', ''66'', ''67'') AND TPR.DD_TPR_CODIGO = ''01'')
            OR (TGA.DD_TGA_CODIGO = ''14'' AND STG.DD_STG_CODIGO IN (''57'', ''59'', ''61'', ''62'', ''68'', ''69'') AND TPR.DD_TPR_CODIGO = ''05'')
            OR (TGA.DD_TGA_CODIGO = ''14'' AND STG.DD_STG_CODIGO = ''58'' AND TPR.DD_TPR_CODIGO = ''06'')            
            OR (TGA.DD_TGA_CODIGO = ''15'' AND TPR.DD_TPR_CODIGO IN (''05''))
            OR (TGA.DD_TGA_CODIGO = ''16'' AND TPR.DD_TPR_CODIGO IN (''05''))
            OR (TGA.DD_TGA_CODIGO = ''17'' AND TPR.DD_TPR_CODIGO IN (''27''))
            OR (TGA.DD_TGA_CODIGO = ''18'' AND TPR.DD_TPR_CODIGO IN (''27'')))
      '
      ;
      
      
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas de gastos de proveedores de tipo PROVEEDOR.');
      
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
            ,DD_TOG_ID
            ,PVE_ID_GESTORIA
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
            ,PRO.PRO_ID                                                       PRO_ID
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
            ,TOG.DD_TOG_ID                                                                      DD_TOG_ID
            ,CASE WHEN GDE.GDE_COD_TIPO_IMPUESTO IS NULL THEN PVE.PVE_ID ELSE NULL END PVE_ID_GESTORIA
            ,0                                                          VERSION
            ,'''||V_USUARIO||'''                                                   USUARIOCREAR
            ,SYSDATE                                                    FECHACREAR
            ,NULL                                                       USUARIOMODIFICAR
            ,NULL                                                       FECHAMODIFICAR
            ,NULL                                                       USUARIOBORRAR
            ,NULL                                                       FECHABORRAR
            ,0                                                          BORRADO
            ,PRG.PRG_ID                                                 PRG_ID
      FROM INSERTAR INS
            INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON INS.GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GDE.GDE_GPV_ID = MIG2.GPV_ID
            INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
            INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
            INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID  = TPR.DD_TPR_ID
            LEFT  JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO TIT ON TIT.DD_TIT_CODIGO = GDE.GDE_COD_TIPO_IMPUESTO
            LEFT JOIN  '||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG ON PRG.PRG_NUM_PROVISION = MIG2.GPV_NUMERO_PROVISION_FONDOS
            LEFT JOIN  '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, ''01'')            
            LEFT JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_CODIGO = ''01''
            LEFT JOIN '||V_ESQUEMA||'.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = MIG2.GPV_COD_TIPO_OPERACION
            LEFT JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_DOCIDENTIF = ''A86602158''
            LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = ''02'' AND CRA.DD_CRA_ID = PRO.DD_CRA_ID
        WHERE TPR.DD_TPR_CODIGO = ''01'' AND MIG2.VALIDACION = 0
      '
      ;
      
      
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas de gastos de proveedores de tipo ''GESTORIA''.');
      
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
            ,DD_TOG_ID
            ,PVE_ID_GESTORIA
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
            AND MIG.VALIDACION = 0
      )
      SELECT 
       '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                GPV_ID
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
      ,DD_TOG_ID
      ,PVE_ID_GESTORIA                                    
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
                  ,PRO.PRO_ID                                                   PRO_ID    
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
                  ,TOG.DD_TOG_ID                                          DD_TOG_ID
                  ,CASE WHEN GDE.GDE_COD_TIPO_IMPUESTO IS NULL THEN PVE.PVE_ID ELSE NULL END PVE_ID_GESTORIA
                  ,0                                                      VERSION    
                  ,'''||V_USUARIO||'''                                               USUARIOCREAR    
                  ,SYSDATE                                                FECHACREAR    
                  ,NULL                                                   USUARIOMODIFICAR    
                  ,NULL                                                   FECHAMODIFICAR    
                  ,NULL                                                   USUARIOBORRAR    
                  ,NULL                                                   FECHABORRAR    
                  ,0                                                      BORRADO    
                  ,PRG.PRG_ID                                             PRG_ID    
            FROM INSERTAR INS
                  INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON INS.GPV_ID = MIG2.GPV_ID
                  INNER JOIN '||V_ESQUEMA||'.MIG2_GDE_GASTOS_DET_ECONOMICO GDE ON GDE.GDE_GPV_ID = MIG2.GPV_ID
                  INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_CODIGO = MIG2.GPV_COD_TIPO_GASTO
                  INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_CODIGO = MIG2.GPV_COD_SUBTIPO_GASTO
                  INNER JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_UVEM = TO_CHAR(MIG2.GPV_COD_PVE_UVEM_EMISOR)
                  INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID  = TPR.DD_TPR_ID
                  LEFT  JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO TIT ON TIT.DD_TIT_CODIGO = GDE.GDE_COD_TIPO_IMPUESTO
                  LEFT JOIN '||V_ESQUEMA||'.PRG_PROVISION_GASTOS PRG ON PRG.PRG_NUM_PROVISION = MIG2.GPV_NUMERO_PROVISION_FONDOS
                  LEFT JOIN '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_CODIGO = NVL(MIG2.GPV_COD_PERIODICIDAD, ''01'')            
                  LEFT JOIN '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_CODIGO = ''01''
                  LEFT JOIN '||V_ESQUEMA||'.DD_TOG_TIPO_OPERACION_GASTO TOG ON TOG.DD_TOG_CODIGO = MIG2.GPV_COD_TIPO_OPERACION
                  LEFT JOIN REM01.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_DOCIDENTIF = ''A86602158''
            LEFT JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = ''02'' AND CRA.DD_CRA_ID = PRO.DD_CRA_ID
            )
      WHERE PARTICION = 1 
      '
      ;      
      
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas de gastos de proveedores asignadas POR DEFECTO.');
      
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