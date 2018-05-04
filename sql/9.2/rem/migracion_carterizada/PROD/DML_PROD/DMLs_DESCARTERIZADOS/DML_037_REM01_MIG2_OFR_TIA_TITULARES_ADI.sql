--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_OFR_TIA_TITULARES_ADI' -> 'OFR_TIA_TITULARES_ADICIONALES'
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
V_TABLA VARCHAR2(40 CHAR) := 'OFR_TIA_TITULARES_ADICIONALES';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_OFR_TIA_TITULARES_ADI';
V_SENTENCIA VARCHAR2(2000 CHAR);


BEGIN

  --Inicio del proceso de volcado sobre OFR_TIA_TITULARES_ADICIONALES
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
        EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        TIA_ID,
        OFR_ID,
        TIA_NOMBRE,
        DD_TDI_ID,
        TIA_DOCUMENTO,
        VERSION,
        USUARIOCREAR,
        FECHACREAR,
        BORRADO
        )
        WITH INSERTAR AS (
    SELECT DISTINCT 
                OFR.OFR_ID,
                MIG.OFR_TIA_NOMBRE,
                MIG.OFR_TIA_COD_TIPO_DOC_TITUL_ADI,
                MIG.OFR_TIA_DOCUMENTO
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
      ON OFR.OFR_NUM_OFERTA = MIG.OFR_TIA_COD_OFERTA
    WHERE MIG.VALIDACION = 0
  )
        SELECT
        '||V_ESQUEMA||'.S_OFR_TIA_TIT_ADICIONALES.NEXTVAL                                       TIA_ID,
        TIA.OFR_ID                                                                                                              OFR_ID,
        TIA.OFR_TIA_NOMBRE                                                                                                      TIA_NOMBRE,
        (SELECT DD_TDI_ID 
        FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID
        WHERE DD_TDI_CODIGO = TIA.OFR_TIA_COD_TIPO_DOC_TITUL_ADI)                       DD_TDI_ID,
        TIA.OFR_TIA_DOCUMENTO                                                                                           TIA_DOCUMENTO,
        ''0''                                                                           VERSION,
        '''||V_USUARIO||'''                                                                        USUARIOCREAR,
        SYSDATE                                                                                 FECHACREAR,
        0                                                                               BORRADO
        FROM INSERTAR TIA
        ';
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
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
