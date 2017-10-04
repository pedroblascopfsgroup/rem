--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_COM_COMPRADOR -> COM_COMPRADOR
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'COM_COMPRADOR';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_COM_COMPRADORES';
V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN
 
      --Inicio del proceso de volcado sobre CLC_CLIENTE_COMERCIAL
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
                INSERT INTO REM01.COM_COMPRADOR (
          COM_ID
          ,CLC_ID
          ,DD_TPE_ID
          ,COM_NOMBRE
          ,COM_APELLIDOS
          ,DD_TDI_ID
          ,COM_DOCUMENTO
          ,COM_TELEFONO1
          ,COM_TELEFONO2
          ,COM_EMAIL
          ,COM_DIRECCION
          ,COM_CODIGO_POSTAL
          ,VERSION
          ,USUARIOCREAR
          ,FECHACREAR
          ,BORRADO
          ,DD_LOC_ID
          ,DD_PRV_ID
        )
        SELECT
          REM01.S_COM_COMPRADOR.NEXTVAL                                                 AS COM_ID,
          AUX.CLC_ID, AUX.DD_TPE_ID, AUX.COM_NOMBRE, AUX.COM_APELLIDOS, AUX.DD_TDI_ID, AUX.COM_DOCUMENTO
          , AUX.COM_TELEFONO1, AUX.COM_TELEFONO2, AUX.COM_EMAIL, AUX.COM_DIRECCION, AUX.COM_CODIGO_POSTAL
          , 0, '''||V_USUARIO||''', SYSDATE, 0, AUX.DD_LOC_ID, AUX.DD_PRV_ID
          FROM (
            SELECT DISTINCT
              CLC.CLC_ID                                                                AS CLC_ID,
              TPE.DD_TPE_ID                                                             AS DD_TPE_ID,
              MIG2.COM_NOMBRE                                                           AS COM_NOMBRE,
              MIG2.COM_APELLIDOS                                                        AS COM_APELLIDOS,
              TDI.DD_TDI_ID                                                             AS DD_TDI_ID,
              MIG2.COM_DOCUMENTO                                                        AS COM_DOCUMENTO,
              MIG2.COM_TELEFONO1                                                        AS COM_TELEFONO1,
              MIG2.COM_TELEFONO2                                                        AS COM_TELEFONO2,
              MIG2.COM_EMAIL                                                            AS COM_EMAIL,
              MIG2.COM_DIRECCION                                                        AS COM_DIRECCION,              
              MIG2.COM_CODIGO_POSTAL                                                    AS COM_CODIGO_POSTAL,
              LOC.DD_LOC_ID                                                             AS DD_LOC_ID,
              PRV.DD_PRV_ID                                                             AS DD_PRV_ID,
              ROW_NUMBER() OVER(PARTITION BY MIG2.COM_DOCUMENTO ORDER BY CLC.CLC_ID DESC) RN
            FROM REM01.MIG2_COM_COMPRADORES MIG2
              INNER JOIN REM01.CLC_CLIENTE_COMERCIAL CLC ON CLC.CLC_NUM_CLIENTE_HAYA = MIG2.COM_COD_COMPRADOR
             LEFT JOIN REM01.DD_TPE_TIPO_PERSONA TPE ON TPE.DD_TPE_CODIGO = MIG2.COM_COD_TIPO_PERSONA AND TPE.BORRADO = 0
              LEFT JOIN REM01.DD_TDI_TIPO_DOCUMENTO_ID TDI ON TDI.DD_TDI_CODIGO = MIG2.COM_COD_TIPO_DOCUMENTO AND TDI.BORRADO = 0
             LEFT JOIN REMMASTER.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = MIG2.COM_COD_LOCALIDAD AND LOC.BORRADO = 0
              LEFT JOIN REMMASTER.DD_PRV_PROVINCIA  PRV ON PRV.DD_PRV_CODIGO = MIG2.COM_COD_PROVINCIA AND PRV.BORRADO = 0
              WHERE MIG2.VALIDACION = 0 AND NOT EXISTS (
                SELECT 1
                FROM REM01.COM_COMPRADOR COMP
                WHERE COMP.COM_DOCUMENTO = MIG2.COM_DOCUMENTO
              )
        ) AUX
        WHERE AUX.RN = 1
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
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
