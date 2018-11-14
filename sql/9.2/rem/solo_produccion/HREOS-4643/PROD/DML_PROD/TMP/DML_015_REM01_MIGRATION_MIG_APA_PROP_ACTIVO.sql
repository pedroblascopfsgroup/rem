--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_APA_PROP_ACTIVO' -> 'ACT_PAC_PROPIETARIO_ACTIVO'
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
V_USUARIO VARCHAR2(50 CHAR) := 'TRASPASO_TANGO';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PAC_PROPIETARIO_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_APA_PROP_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN

    EXECUTE IMMEDIATE(
    '
		DELETE FROM '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC
		WHERE EXISTS (
		  SELECT 1
		  FROM '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO AUX
		  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ACT_ID = ACT.ACT_ID
		  INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
		  INNER JOIN '||V_ESQUEMA||'.MIG2_USUARIOCREAR_CARTERIZADO USU ON USU.CARTERA = CRA.DD_CRA_CODIGO
		  WHERE USU.USUARIOCREAR = '''||V_USUARIO||''' AND PAC.ACT_ID = ACT.ACT_ID
		)
    '
    )
    ;
    
    COMMIT;

	  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
	  EXECUTE IMMEDIATE V_SENTENCIA;
      
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	PAC_ID,
	ACT_ID,
	PRO_ID,
	DD_TGP_ID,
	PAC_PORC_PROPIEDAD,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	WITH MIG AS (
		SELECT DISTINCT (MIG.ACT_NUMERO_ACTIVO),
		MIG.PRO_CODIGO_UVEM,
		MIG.GRADO_PROPIEDAD,
		MIG.PORCENTAJE
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		INNER JOIN ACT_ACTIVO ACT 
		  ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
		INNER JOIN ACT_PRO_PROPIETARIO PRO 
		  ON PRO.PRO_CODIGO_UVEM = MIG.PRO_CODIGO_UVEM
		  AND ACT.DD_CRA_ID = PRO.DD_CRA_ID
    WHERE NOT EXISTS (
      SELECT 1 FROM ACT_PAC_PROPIETARIO_ACTIVO PAC
      WHERE PAC.ACT_ID = ACT.ACT_ID
		  AND PAC.PRO_ID = PRO.PRO_ID)
	AND MIG.VALIDACION = 0
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_PAC_PROPIETARIO_ACTIVO.NEXTVAL						    PAC_ID,
        act.act_id, 
        pro.pro_id, 
	(SELECT DD_TGP_ID
	FROM '||V_ESQUEMA||'.DD_TGP_TIPO_GRADO_PROPIEDAD  
	WHERE DD_TGP_CODIGO = MIG.GRADO_PROPIEDAD)				                DD_TGP_ID,
	MIG.PORCENTAJE                 					                                          		PAC_PORC_PROPIEDAD,
	''0''                                                                                          	VERSION,
	'''||V_USUARIO||'''                                                                                         	USUARIOCREAR,
	SYSDATE                                                                                	FECHACREAR,
	0                                                                                           	BORRADO
	FROM MIG
    inner join  '||V_ESQUEMA||'.ACT_ACTIVO ACT 
	   on ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO 
    inner join  '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO pro
       on pro.PRO_CODIGO_UVEM = MIG.PRO_CODIGO_UVEM and act.dd_cra_id = pro.dd_cra_id
	')
	;
	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
        EXECUTE IMMEDIATE ('  
               MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' PAC_OLD
             USING (
             select a.idactivo from
             (
                 select idactivo
                 from (
                      select
                         PAC1.ACT_ID idactivo,
                       COUNT(*) num_propietarios
                       FROM '||V_ESQUEMA||'.'||V_TABLA||' PAC1
                       GROUP BY PAC1.ACT_ID
                       ) where num_propietarios = 1
                       ) a
                     inner join '||V_ESQUEMA||'.'||V_TABLA||' PAC2 on a.idactivo = PAC2.ACT_ID
                     where PAC2.PAC_PORC_PROPIEDAD = 0
                     and pac2.usuariocrear = '''||V_USUARIO||'''
                     ) PAC_NEW
                 ON (PAC_OLD.ACT_ID = PAC_NEW.idactivo)
                 WHEN MATCHED THEN UPDATE
                   SET PAC_OLD.PAC_PORC_PROPIEDAD = 100
        ')  
        ;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizado porc_propiedad . '||SQL%ROWCOUNT||' Filas.');
  
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
