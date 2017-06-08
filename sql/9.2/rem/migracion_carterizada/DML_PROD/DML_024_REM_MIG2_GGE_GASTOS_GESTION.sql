--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GGE_GASTOS_GESTION -> GGE_GASTOS_GESTION
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
V_TABLA VARCHAR2(40 CHAR) := 'GGE_GASTOS_GESTION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GGE_GASTOS_GESTION';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
                INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                                   GGE_ID
                                  ,GPV_ID
                                  ,GGE_AUTORIZACION_PROPIETARIO
                                  ,DD_MAP_ID
                                  ,GGE_OBSERVACIONES
                                  ,GGE_FECHA_ALTA
                                  ,USU_ID_ALTA
                                  ,DD_EAH_ID
                                  ,GGE_FECHA_EAH
                                  ,USU_ID_EAH
                                  ,DD_MRH_ID
                                  ,DD_EAP_ID
                                  ,GGE_FECHA_EAP
                                  ,GGE_MOTIVO_RECHAZO_PROP
                                  ,GGE_FECHA_ANULACION
                                  ,USU_ID_ANULACION
                                  ,DD_MAG_ID
                                  ,GGE_FECHA_RP
                                  ,USU_ID_RP
                                  ,DD_MRP_ID
                                  ,VERSION
                                  ,USUARIOCREAR
                                  ,FECHACREAR
                                  ,USUARIOMODIFICAR
                                  ,FECHAMODIFICAR
                                  ,USUARIOBORRAR
                                  ,FECHABORRAR
          						  ,BORRADO
                )
                WITH INSERTAR AS (
                SELECT DISTINCT GPV.GPV_ID
                ,MIG.GGE_IND_AUTORIZ_PROP
                ,MIG.GGE_COD_MOT_AUTORIZ_PROP
                ,MIG.GGE_COD_EST_AUTORIZ_PROP
                ,MIG.GGE_FECHA_EST_AUTORIZ_PROP
                ,MIG.GGE_MOT_RECHAZO_PROP
                ,MIG.GGE_OBSERVACIONES
                ,MIG.GGE_FECHA_ALTA
                ,MIG.GGE_COD_USUARIO_ALTA
                ,MIG.GGE_COD_EST_AUTORIZ_HAYA
                ,MIG.GGE_FECHA_ESTADO_AUTORIZ_HAYA
                ,MIG.GGE_COD_USU_EST_AUTORIZ_HAYA
                ,MIG.GGE_COD_MOT_RECH_AUTORIZ_HAYA
                ,MIG.GGE_FECHA_ANULACION
                ,MIG.GGE_COD_USUARIO_ANULACION
                ,MIG.GGE_COD_MOTIVO_ANULACION_GASTO
                ,MIG.GGE_FECHA_RETENCION_PAGO
                ,MIG.GGE_COD_USUARIO_RETENCION_PAGO
                ,MIG.GGE_COD_MOTIVO_RETENCION_PAGO
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                  ON GPV.GPV_NUM_GASTO_HAYA = MIG.GGE_GPV_ID
				WHERE MIG.VALIDACION = 0
          )
                SELECT
                       '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                          GGE_ID
          ,INS.GPV_ID GPV_ID
          ,INS.GGE_IND_AUTORIZ_PROP GGE_AUTORIZACION_PROPIETARIO
          ,(SELECT DD_MAP.DD_MAP_ID FROM '||V_ESQUEMA||'.DD_MAP_MOT_AUT_PROP_GASTO DD_MAP WHERE DD_MAP.DD_MAP_CODIGO = INS.GGE_COD_MOT_AUTORIZ_PROP) DD_MAP_ID
          ,INS.GGE_OBSERVACIONES
          ,INS.GGE_FECHA_ALTA
          ,(SELECT USU.USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = INS.GGE_COD_USUARIO_ALTA) USU_ID_ALTA
          ,(SELECT DD_EAH.DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA DD_EAH WHERE DD_EAH.DD_EAH_CODIGO = INS.GGE_COD_EST_AUTORIZ_HAYA) DD_EAH_ID
          ,INS.GGE_FECHA_ESTADO_AUTORIZ_HAYA GGE_FECHA_EAH
          ,(SELECT USU.USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = INS.GGE_COD_USU_EST_AUTORIZ_HAYA) USU_ID_EAH
          ,(SELECT DD_MRH.DD_MRH_ID FROM '||V_ESQUEMA||'.DD_MRH_MOTIVOS_RECHAZO_HAYA DD_MRH WHERE DD_MRH.DD_MRH_CODIGO = INS.GGE_COD_MOT_RECH_AUTORIZ_HAYA) DD_MRH_ID
          ,(SELECT DD_EAP.DD_EAP_ID FROM '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP DD_EAP WHERE DD_EAP.DD_EAP_CODIGO = INS.GGE_COD_EST_AUTORIZ_PROP) DD_EAP_ID
          ,INS.GGE_FECHA_EST_AUTORIZ_PROP GGE_FECHA_EAP
          ,INS.GGE_MOT_RECHAZO_PROP GGE_MOTIVO_RECHAZO_PROP
          ,INS.GGE_FECHA_ANULACION
          ,(SELECT USU.USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = INS.GGE_COD_USUARIO_ANULACION) USU_ID_ANULACION
          ,(SELECT DD_MAG.DD_MAG_ID FROM '||V_ESQUEMA||'.DD_MAG_MOTIVOS_ANULACION_GASTO DD_MAG WHERE DD_MAG.DD_MAG_CODIGO = INS.GGE_COD_MOTIVO_ANULACION_GASTO) DD_MAG_ID
          ,INS.GGE_FECHA_RETENCION_PAGO GGE_FECHA_RP
          ,(SELECT USU.USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = INS.GGE_COD_USUARIO_RETENCION_PAGO) USU_ID_RP
          ,(SELECT DD_MRP.DD_MRP_ID FROM '||V_ESQUEMA||'.DD_MRP_MOTIVOS_RET_PAGO DD_MRP WHERE DD_MRP.DD_MRP_CODIGO = INS.GGE_COD_MOTIVO_RETENCION_PAGO) DD_MRP_ID
          ,0 VERSION
          ,''#USUARIO_MIGRACION#'' USUARIOCREAR
          ,SYSDATE FECHACREAR
          ,NULL USUARIOMODIFICAR
          ,NULL FECHAMODIFICAR
          ,NULL USUARIOBORRAR
          ,NULL FECHABORRAR
          ,0 BORRADO    
                FROM INSERTAR INS
                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
 
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