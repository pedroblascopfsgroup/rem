--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GDE_GASTOS_DET_ECONOMICO -> GDE_GASTOS_DETALLE_ECONOMICO
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
V_TABLA VARCHAR2(40 CHAR) := 'GDE_GASTOS_DETALLE_ECONOMICO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GDE_GASTOS_DET_ECONOMICO';
V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                GDE_ID,
                GPV_ID,
                GDE_PRINCIPAL_SUJETO,
                GDE_PRINCIPAL_NO_SUJETO,
                GDE_RECARGO,
                GDE_INTERES_DEMORA,
                GDE_COSTAS,
                GDE_OTROS_INCREMENTOS,
                GDE_PROV_SUPLIDOS,
                DD_TIT_ID,
                GDE_IMP_IND_EXENTO,
                GDE_IMP_IND_RENUNCIA_EXENCION,
                GDE_IMP_IND_TIPO_IMPOSITIVO,
                GDE_IMP_IND_CUOTA,
                GDE_IRPF_TIPO_IMPOSITIVO,
                GDE_IRPF_CUOTA,
                GDE_IMPORTE_TOTAL,
                GDE_FECHA_TOPE_PAGO,
                GDE_REPERCUTIBLE_INQUILINO,
                GDE_IMPORTE_PAGADO,
                GDE_FECHA_PAGO,
                DD_TPA_ID,
                DD_TPP_ID,
                DD_DEP_ID,
                VERSION,
                USUARIOCREAR,
                FECHACREAR,
                BORRADO,
                GDE_REEMBOLSO_TERCERO,
                GDE_INCLUIR_PAGO_PROVISION,
                GDE_ABONO_CUENTA,
                GDE_IBAN,
                GDE_TITULAR_CUENTA,
                GDE_NIF_TITULAR_CUENTA,
                GDE_PAGADO_CONEXION_BANKIA,
                GDE_NUMERO_CONEXION,
                GDE_OFICINA_BANKIA
                )
                WITH INSERTAR AS (
                SELECT DISTINCT GPV.GPV_ID, 
                                                MIG.GDE_PRINCIPAL_SUJETO,
                                                MIG.GDE_PRINCIPAL_NO_SUJETO,
                                                MIG.GDE_RECARGO,
                                                MIG.GDE_INTERES_DEMORA,
                                                MIG.GDE_COSTAS,
                                                MIG.GDE_OTROS_INCREMENTOS,
                                                MIG.GDE_PROVISIONES_SUPLIDOS,
                                                MIG.GDE_COD_TIPO_IMPUESTO,
                                                MIG.GDE_IND_IMP_INDIRECTO_EXENTO,
                                                MIG.GDE_IND_IMP_INDIR_RENUN_EXENC,
                                                MIG.GDE_IMP_INDIR_TIPO_IMPOSITIVO,
                                                MIG.GDE_IMP_IND_CUOTA,
                                                MIG.GDE_IRPF_TIPO_IMPOSITIVO,
                                                MIG.GDE_IRPF_CUOTA,
                                                MIG.GDE_IMPORTE_TOTAL,
                                                MIG.GDE_FECHA_TOPE_PAGO,
                                                MIG.GDE_IND_REPERCUTIBLE_INQUILINO,
                                                MIG.GDE_IMPORTE_PAGADO,
                                                MIG.GDE_FECHA_PAGO,
                                                MIG.GDE_COD_TIPO_PAGADOR,
                                                MIG.GDE_COD_TIPO_PAGO,
                                                MIG.GDE_COD_RESP_PAGO_FUERA_PLAZO,
                                                MIG.GDE_REEMBOLSO_TERCERO,
                                                MIG.GDE_INCLUIR_PAGO_PROVISION,
                                                MIG.GDE_ABONO_CUENTA,
                                                MIG.GDE_IBAN,
                                                MIG.GDE_TITULAR_CUENTA,
                                                MIG.GDE_NIF_TITULAR_CUENTA,
                                                MIG.GDE_PAGADO_CONEXION_BANKIA,
                                                MIG.GDE_NUMERO_CONEXION,
                                                MIG.GDE_OFICINA_BANKIA
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                  ON GPV.GPV_NUM_GASTO_HAYA = MIG.GDE_GPV_ID
				WHERE MIG.VALIDACION = 0
          )
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                         GDE_ID, 
                GDE.GPV_ID                                                                                                  GPV_ID,
                GDE.GDE_PRINCIPAL_SUJETO                                                                                GDE_PRINCIPAL_SUJETO,
                GDE.GDE_PRINCIPAL_NO_SUJETO                                                                             GDE_PRINCIPAL_NO_SUJETO,
                GDE.GDE_RECARGO                                                                                                 GDE_RECARGO,
                GDE.GDE_INTERES_DEMORA                                                                                  GDE_INTERES_DEMORA,
                GDE.GDE_COSTAS                                                                                                  GDE_COSTAS,
                GDE.GDE_OTROS_INCREMENTOS                                                                               GDE_OTROS_INCREMENTOS,
                GDE.GDE_PROVISIONES_SUPLIDOS                                                                    GDE_PROV_SUPLIDOS,
                TIT.DD_TIT_ID                                                                                                   DD_TIT_ID,
                GDE.GDE_IND_IMP_INDIRECTO_EXENTO                                                                GDE_IMP_IND_EXENTO,
                GDE.GDE_IND_IMP_INDIR_RENUN_EXENC                                                               GDE_IMP_IND_RENUNCIA_EXENCION,
                GDE.GDE_IMP_INDIR_TIPO_IMPOSITIVO                                                               GDE_IMP_IND_TIPO_IMPOSITIVO,
                GDE.GDE_IMP_IND_CUOTA                                                                                   GDE_IMP_IND_CUOTA,
                GDE.GDE_IRPF_TIPO_IMPOSITIVO                                                                    GDE_IRPF_TIPO_IMPOSITIVO,
                GDE.GDE_IRPF_CUOTA                                                                                              GDE_IRPF_CUOTA,
                GDE.GDE_IMPORTE_TOTAL                                                                                   GDE_IMPORTE_TOTAL,
                GDE.GDE_FECHA_TOPE_PAGO                                                                                 GDE_FECHA_TOPE_PAGO,
                GDE.GDE_IND_REPERCUTIBLE_INQUILINO                                                              GDE_REPERCUTIBLE_INQUILINO,
                GDE.GDE_IMPORTE_PAGADO                                                                                  GDE_IMPORTE_PAGADO,
                GDE.GDE_FECHA_PAGO                                                                                              GDE_FECHA_PAGO,
                TPA.DD_TPA_ID                                                                                                   DD_TPA_ID,
                TPP.DD_TPP_ID                                                                                                   DD_TPP_ID,
                DEP.DD_DEP_ID                                                                                                   DD_DEP_ID,
                0                                                                                                                               VERSION,
                '''||V_USUARIO||'''                                                                USUARIOCREAR,
                SYSDATE                                                                         FECHACREAR,
                0                                                                               BORRADO,
                GDE.GDE_REEMBOLSO_TERCERO                                                                               GDE_REEMBOLSO_TERCERO,
                GDE.GDE_INCLUIR_PAGO_PROVISION                                                                  GDE_INCLUIR_PAGO_PROVISION,
                GDE.GDE_ABONO_CUENTA                                                                                    GDE_ABONO_CUENTA,
                GDE.GDE_IBAN                                                                                                    GDE_IBAN,
                GDE.GDE_TITULAR_CUENTA                                                                                  GDE_TITULAR_CUENTA,
                GDE.GDE_NIF_TITULAR_CUENTA                                                                              GDE_NIF_TITULAR_CUENTA,
                GDE.GDE_PAGADO_CONEXION_BANKIA                                                                  GDE_PAGADO_CONEXION_BANKIA,
                GDE.GDE_NUMERO_CONEXION                                                                                 GDE_NUMERO_CONEXION,
                GDE.GDE_OFICINA_BANKIA                                                                                  GDE_OFICINA_BANKIA
                FROM INSERTAR GDE
                LEFT JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO TIT
                        ON TIT.DD_TIT_CODIGO = GDE.GDE_COD_TIPO_IMPUESTO
                LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPOS_PAGADOR TPA
                        ON TPA.DD_TPA_CODIGO = GDE.GDE_COD_TIPO_PAGADOR
                LEFT JOIN '||V_ESQUEMA||'.DD_TPP_TIPOS_PAGO TPP
                        ON TPP.DD_TPP_CODIGO = GDE.GDE_COD_TIPO_PAGO
                LEFT JOIN '||V_ESQUEMA||'.DD_DEP_DESTINATARIOS_PAGO DEP
                        ON DEP.DD_DEP_CODIGO = GDE.GDE_COD_RESP_PAGO_FUERA_PLAZO
                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;

    EXECUTE IMMEDIATE 'MERGE INTO REM01.GDE_GASTOS_DETALLE_ECONOMICO T1
        USING (SELECT T1.GDE_ID
            FROM GDE_GASTOS_DETALLE_ECONOMICO T1 
            JOIN DD_TIT_TIPOS_IMPUESTO T2 ON T1.DD_TIT_ID = T2.DD_TIT_ID AND T2.DD_TIT_CODIGO = ''01''
            WHERE T1.GDE_IMP_IND_CUOTA = 0 AND T1.GDE_IMP_IND_EXENTO IS NULL) T2
        ON (T1.GDE_ID = T2.GDE_ID)
        WHEN MATCHED THEN UPDATE SET
            T1.GDE_IMP_IND_EXENTO = (SELECT DD_SIN_ID FROM REMMASTER.DD_SIN_SINO T3 WHERE T3.DD_SIN_CODIGO = ''01'')';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (GDE_IMP_IND_EXENTO). '||SQL%ROWCOUNT||' Filas.');

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
