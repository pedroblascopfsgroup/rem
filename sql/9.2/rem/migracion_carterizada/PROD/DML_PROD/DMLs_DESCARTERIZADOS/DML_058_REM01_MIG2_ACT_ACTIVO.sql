--/*
--#########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20170607
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2195, HREOS-2108
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_ACT_ACTIVO' -> 'ACT_ACTIVO'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACT_ACTIVO';
V_SENTENCIA VARCHAR2(4000 CHAR);

BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' ACT
        USING ( SELECT  
                                ACT_NUMERO_ACTIVO,
                                ACT_COD_CARTERA,
                                ACT_COD_SUBCARTERA,
                                ACT_BLOQUEO_PRECIO_FECHA_INI,
                                ACT_BLOQUEO_PRECIO_USU_ID,
                                ACT_COD_TIPO_PUBLICACION,
                                ACT_COD_ESTADO_PUBLICACION,
                                ACT_COD_TIPO_COMERCIALIZACION,
                                ACT_FECHA_IND_PRECIAR,
                                ACT_FECHA_IND_REPRECIAR,
                                ACT_FECHA_IND_DESCUENTO,
                                ACT_NUMERO_INMOVILIZADO,  
                                ACT_CODIGO_ENTRADA,   
                                SELLO_CALIDAD,      
                                GESTOR_CALIDAD,     
                                FECHA_CALIDAD   
                                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
                WHERE VALIDACION IN (0,1)
                          ) AUX
                ON (ACT.ACT_NUM_ACTIVO = AUX.ACT_NUMERO_ACTIVO)
                WHEN MATCHED THEN UPDATE SET
          ACT.DD_CRA_ID = (SELECT CRA.DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = AUX.ACT_COD_CARTERA)
          ,ACT.DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = AUX.ACT_COD_SUBCARTERA)
                  ,ACT.ACT_BLOQUEO_PRECIO_FECHA_INI = AUX.ACT_BLOQUEO_PRECIO_FECHA_INI
                  ,ACT.ACT_BLOQUEO_PRECIO_USU_ID = AUX.ACT_BLOQUEO_PRECIO_USU_ID
                  ,ACT.DD_TPU_ID = (SELECT DD_TPU_ID FROM '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION WHERE DD_TPU_CODIGO = AUX.ACT_COD_TIPO_PUBLICACION)
                  ,ACT.DD_EPU_ID = (SELECT DD_EPU_ID FROM '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION WHERE DD_EPU_CODIGO = AUX.ACT_COD_ESTADO_PUBLICACION)
                  ,ACT.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = AUX.ACT_COD_TIPO_COMERCIALIZACION)
                  ,ACT.ACT_FECHA_IND_PRECIAR = AUX.ACT_FECHA_IND_PRECIAR
                  ,ACT.ACT_FECHA_IND_REPRECIAR = AUX.ACT_FECHA_IND_REPRECIAR
                  ,ACT.ACT_FECHA_IND_DESCUENTO = AUX.ACT_FECHA_IND_DESCUENTO
                  ,ACT.ACT_NUM_INMOVILIZADO_BNK = AUX.ACT_NUMERO_INMOVILIZADO
                  ,ACT.ACT_SELLO_CALIDAD = AUX.SELLO_CALIDAD
                  ,ACT.ACT_GESTOR_SELLO_CALIDAD = (SELECT USU.USU_ID FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = AUX.GESTOR_CALIDAD)
                  ,ACT.ACT_FECHA_SELLO_CALIDAD = AUX.FECHA_CALIDAD
          ,ACT.USUARIOMODIFICAR = '''||V_USUARIO||'''
          ,ACT.FECHAMODIFICAR = SYSDATE
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      -- ACTUALIZACION DE LA FECHA Y EL IMPORTE DE VENTA EN ACT_ACTIVO     
      V_SENTENCIA := '
    MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' ACT
        USING (  
          SELECT MIG2.ACT_NUMERO_ACTIVO, MIG2.ACT_FECHA_VENTA, MIG2.ACT_IMPORTE_VENTA 
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          WHERE MIG2.VALIDACION IN (0,1) AND MIG2.ACT_NUMERO_ACTIVO NOT IN (
          SELECT DISTINCT MIG.ACT_NUMERO_ACTIVO 
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
          INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
            ON MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
          INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACT_OFR
            ON ACT_OFR.ACT_ID = ACT.ACT_ID
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
            ON ECO.OFR_ID = ACT_OFR.OFR_ID
          WHERE ECO.DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = ''08''))
          ) AUX ON (ACT.ACT_NUM_ACTIVO = AUX.ACT_NUMERO_ACTIVO)
                WHEN MATCHED THEN UPDATE SET
                  ACT.ACT_VENTA_EXTERNA_FECHA = AUX.ACT_FECHA_VENTA,
                  ACT.ACT_VENTA_EXTERNA_IMPORTE  = AUX.ACT_IMPORTE_VENTA
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      -- ACTUALIZACION DE LA FECHA IND PUBLICABLE
      EXECUTE IMMEDIATE 'MERGE INTO REM01.ACT_ACTIVO T1
        USING (SELECT ACT_ID 
            FROM REM01.ACT_ACTIVO A
            JOIN REM01.DD_EPU_ESTADO_PUBLICACION DD ON DD.DD_EPU_ID = A.DD_EPU_ID AND DD.DD_EPU_CODIGO = ''01''
            WHERE A.BORRADO = 0) T2
        ON (T1.ACT_ID = T2.ACT_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.ACT_FECHA_IND_PUBLICABLE = SYSTIMESTAMP';

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||'.ACT_FECHA_IND_PUBLICABLE actualizados. '||SQL%ROWCOUNT||' Filas.');

       -- ACTUALIZACION DE LA FECHA DE VENTA EN ECO_EXPEDIENTE_COMERCIAL     
      V_SENTENCIA := '
        MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
        USING ( 
          SELECT ECO_ID, ACT_FECHA_VENTA 
          FROM(
                SELECT DISTINCT 
                ECO.ECO_ID, 
                MIG.ACT_FECHA_VENTA, 
                ROW_NUMBER() OVER (PARTITION BY ECO.ECO_ID ORDER BY MIG.ACT_FECHA_VENTA DESC) AS ORDEN 
                FROM '||V_ESQUEMA||'.mig2_act_activo MIG 
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
                INNER JOIN '||V_ESQUEMA||'.ACT_OFR ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
                INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = ACT_OFR.OFR_ID
                WHERE ECO.DD_EEC_ID = (SELECT DD_EEC_ID FROM rem01.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = ''08'')
              ) 
          WHERE ORDEN = 1 
        ) AUX ON (ECO.ECO_ID = AUX.ECO_ID)
        WHEN MATCHED THEN UPDATE SET
          ECO.ECO_FECHA_VENTA = AUX.ACT_FECHA_VENTA
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL cargada. '||SQL%ROWCOUNT||' Filas.');                        
      
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
