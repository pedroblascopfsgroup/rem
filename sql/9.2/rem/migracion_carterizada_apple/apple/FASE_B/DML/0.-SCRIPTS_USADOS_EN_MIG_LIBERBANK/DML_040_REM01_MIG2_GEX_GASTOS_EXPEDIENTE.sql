--/*
--#########################################
--## AUTOR=gUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GEX_GASTOS_EXPEDIENTE -> GEX_GASTOS_EXPEDIENTE
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
    V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
    V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
    V_TABLA VARCHAR2(40 CHAR) := 'GEX_GASTOS_EXPEDIENTE';
    V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GEX_GASTOS_EXPEDIENTE';
    V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN

      --Inicio del proceso de volcado sobre GEX_GASTOS_EXPEDIENTE
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' GEX (
             GEX_ID
            ,ECO_ID
            ,DD_ACC_ID
            ,GEX_CODIGO
            ,GEX_NOMBRE
            ,DD_TCC_ID
            ,GEX_IMPORTE_CALCULO
            ,GEX_IMPORTE_FINAL
            ,GEX_PAGADOR
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,USUARIOMODIFICAR
            ,FECHAMODIFICAR
            ,USUARIOBORRAR
            ,FECHABORRAR
            ,BORRADO
            ,GEX_WEBCOM_ID
            ,GEX_PROVEEDOR
            ,GEX_OBSERVACIONES
            ,GEX_APROBADO
            ,DD_DEG_ID
            ,ACT_ID
          )
          SELECT  
            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                     AS GEX_ID
            ,ECO.ECO_ID                                                                                                 AS ECO_ID
            ,(SELECT DD_ACC.DD_ACC_ID FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS DD_ACC WHERE DD_ACC.DD_ACC_CODIGO = MIG2.GEX_COD_CONCEPTO_GASTO AND DD_ACC.BORRADO = 0) DD_ACC_ID
            ,MIG2.GEX_CODIGO
            ,MIG2.GEX_NOMBRE
            ,(SELECT DD_TCC.DD_TCC_ID FROM '||V_ESQUEMA||'.DD_TCC_TIPO_CALCULO DD_TCC WHERE DD_TCC.DD_TCC_CODIGO = MIG2.GEX_COD_TIPO_CALCULO AND DD_TCC.BORRADO = 0) DD_TCC_ID
            ,CASE 
              WHEN MIG2.GEX_IMPORTE_CALCULO = 0 AND MIG2.GEX_COD_TIPO_CALCULO = ''01'' 
                THEN 0 
              WHEN MIG2.GEX_COD_TIPO_CALCULO = ''02'' 
                THEN MIG2.GEX_IMPORTE_FINAL 
              WHEN MIG2.GEX_COD_TIPO_CALCULO = ''01'' 
                THEN MIG2.GEX_IMPORTE_FINAL/MIG2.GEX_IMPORTE_CALCULO*100 
              END GEX_IMPORTE_CALCULO
            ,MIG2.GEX_IMPORTE_FINAL
            ,MIG2.GEX_IND_PAGADOR
            ,0 VERSION
            ,'''||V_USUARIO||''' USUARIOCREAR
            ,SYSDATE FECHACREAR
            ,NULL USUARIOMODIFICAR
            ,NULL FECHAMODIFICAR
            ,NULL USUARIOBORRAR
            ,NULL FECHABORRAR
            ,0 BORRADO
            ,MIG2.GEX_WEBCOM_ID
            ,(SELECT PVE.PVE_ID FROM ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_COD_PRINEX = MIG2.GEX_COD_PROVEEDOR and pve.DD_TPR_ID is not null AND PVE.PVE_FECHA_BAJA IS NULL AND ROWNUM = 1) GEX_PROVEEDOR
            ,NULL GEX_OBSERVACIONES
            ,MIG2.GEX_IND_APROBADO
            ,(SELECT DD_DEG.DD_DEG_ID FROM '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DD_DEG WHERE DD_DEG.DD_DEG_CODIGO = MIG2.GEX_COD_DESTINATARIO AND DD_DEG.BORRADO = 0) DD_DEG_ID
            ,ACT.ACT_ID
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = MIG2.GEX_COD_OFERTA
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
		      LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG2.GEX_ACT_NUMERO_ACTIVO
		  WHERE MIG2.VALIDACION = 0
      '
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
