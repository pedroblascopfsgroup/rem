--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_AGR_AGRUPACIONES -> ACT_AGR_AGRUPACION
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AGR_AGRUPACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_AGR_AGRUPACIONES';
V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN
      
      --Inicio del proceso de volcado 
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA:= '
        MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' DEST   
               USING '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                ON (DEST.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM AND MIG.VALIDACION = 0)
        WHEN MATCHED THEN UPDATE
             SET  
             
             DEST.VERSION = DEST.VERSION +1,
             DEST.AGR_PUBLICADO = MIG.AGR_IND_PUBLICADA ,
             DEST.USUARIOMODIFICAR = '''||V_USUARIO||''',
             DEST.FECHAMODIFICAR = SYSDATE  
        WHERE MIG.AGR_IND_PUBLICADA IS NOT NULL';
             
             --(QUERY ELIMINADA DEL HUECO) DEST.DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = MIG.AGR_COD_TIPO_AGRUPACION),

      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
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