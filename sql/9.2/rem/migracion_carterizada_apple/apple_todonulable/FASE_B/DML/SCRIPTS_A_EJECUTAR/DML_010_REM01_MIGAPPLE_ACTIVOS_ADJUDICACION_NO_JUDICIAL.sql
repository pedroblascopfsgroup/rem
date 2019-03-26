--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ADJ_NO_JUDICIAL' -> 'ACT_ADN_ADJNOJUDICIAL'
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_ADN_ADJNOJUDICIAL';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ADJ_NO_JUDICIAL';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de ACTIVOS NO-JUDICIALES');

    -------------------------------------------------
    --INSERCION EN ACT_ADN_ADJNOJUDICIAL--
    -------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_ADN_ADJNOJUDICIAL');
    

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		ADN_ID,
		ACT_ID,
		DD_EEJ_ID,
		ADN_FECHA_TITULO,
		ADN_FECHA_FIRMA_TITULO,
		ADN_VALOR_ADQUISICION,
		ADN_TRAMITADOR_TITULO,
		ADN_NUM_REFERENCIA,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		USUARIOMODIFICAR,
		FECHAMODIFICAR,
		USUARIOBORRAR,
		FECHABORRAR,
		BORRADO,
		ADN_EXP_DEF_TESTI
	)
	SELECT
		'||V_ESQUEMA||'.S_ACT_ADN_ADJNOJUDICIAL.NEXTVAL       ADN_ID,
		ACT.ACT_ID											  ACT_ID,
		(SELECT DD_EEJ_ID
		  FROM '||V_ESQUEMA||'.DD_EEJ_ENTIDAD_EJECUTANTE
		  WHERE DD_EEJ_CODIGO = MIG.ENTIDAD_EJECUTANTE)       DD_EEJ_ID,
		MIG.ADN_FECHA_TITULO                                  ADN_FECHA_TITULO,
		MIG.ADN_FECHA_FIRMA_TITULO                            ADN_FECHA_FIRMA_TITULO,
		MIG.ADN_VALOR_ADQUISICION                             ADN_VALOR_ADQUISICION,
		MIG.ADN_TRAMITADOR_TITULO                             ADN_TRAMITADOR_TITULO,
		MIG.ADN_NUM_REFERENCIA                                ADN_NUM_REFERENCIA,
		''0''                                                 VERSION,
		'''||V_USUARIO||'''                                   USUARIOCREAR,
		SYSDATE                                               FECHACREAR,
		NULL                                                  USUARIOMODIFICAR,
		NULL                                                  FECHAMODIFICAR,
		NULL                                                  USUARIOBORRAR,
		NULL                                                  FECHABORRAR,
		0                                                     BORRADO,
		MIG.ADN_EXP_DEF_TESTI
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE MIG.VALIDACION = 0 AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' AUX WHERE AUX.ACT_ID = ACT.ACT_ID AND AUX.BORRADO = 0)
   ');
  
   DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  

   /*
   --YA SE CALCULA EN EL DML DE DATOS_ADICIONALES
   EXECUTE IMMEDIATE 
   'MERGE INTO ACT_SPS_SIT_POSESORIA T1
	USING (
		SELECT 
			T1.ACT_ID, 
			T2.ADN_FECHA_TITULO
		FROM ACT_SPS_SIT_POSESORIA 	T1
		JOIN ACT_ADN_ADJNOJUDICIAL 	T2 ON T1.ACT_ID = T2.ACT_ID AND T2.BORRADO = 0
		JOIN ACT_ACTIVO 			T3 ON T3.ACT_ID = T2.ACT_ID AND T3.BORRADO = 0
		WHERE T1.BORRADO = 0 AND T2.ADN_FECHA_TITULO IS NOT NULL AND T1.SPS_FECHA_TOMA_POSESION IS NULL
	) T2
	ON (T1.ACT_ID = T2.ACT_ID)
	WHEN MATCHED THEN UPDATE SET
	    T1.SPS_FECHA_TOMA_POSESION = T2.ADN_FECHA_TITULO
   ';
  
   DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA actualizada. '||SQL%ROWCOUNT||' Filas.');
   */
  
  
   V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA ||''',''10''); END;';
   EXECUTE IMMEDIATE V_SENTENCIA;

   COMMIT; 
      
   DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de ACTIVOS JUDICIALES'); 
  
  
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
