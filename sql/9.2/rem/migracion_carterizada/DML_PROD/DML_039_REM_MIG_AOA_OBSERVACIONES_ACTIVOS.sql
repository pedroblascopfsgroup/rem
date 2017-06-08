--/*
--#########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20170601
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2206
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AOA_OBSERVACIONES_ACTIVOS' -> 'ACT_AOB_ACTIVO_OBS'
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
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AOB_ACTIVO_OBS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AOA_OBSERVACIONES_ACTIVOS';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';
VAR1 NUMBER(10,0) := 0;

BEGIN
  
	  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  

	--borrado previo en la tabla ACT_AOB_ACTIVO_OBS de todas las observaciones que estén relacionadas 
	--con uno de los activos existentes en la tabla de migración MIG_AOA_OBSERVACIONES_ACT_BNK
	EXECUTE IMMEDIATE '
	DELETE 
	FROM '||V_ESQUEMA||'.'||V_TABLA||' AOB 
	WHERE EXISTS (
		SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG, '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.ACT_NUM_ACTIVO = ACT.ACT_NUM_ACTIVO_UVEM AND ACT.ACT_ID = AOB.ACT_ID
	)';


  -- IMPORTANTE: ESTAMOS TENIENDO EN CUENTA QUE NOS PASEN USU_ID, SI PASARAN NOMBRES DE USUARIO PE TENDRIAMOS
  -- QUE BUSCAR LA ID QUE CORRESPONDE A ESE NOMBRE DE USUARIO PARA APLICAR EL FILTRO
  
  
  -- EL PRIMER WITH OBTIENE LOS ACT_NUM_ACTIVO DE LA TABLA MIG QUE EXISTEN EN AGRUPACIONES Y NO ESTAN INSERTADOS EN 
  --    LA TABLA DE VOLCADO
  
  -- EL SEGUNDO WITH OBTIENE LAS USU_ID DE LA TABLA MIG QUE EXISTEN EN LA TABLA DE USU_USUARIOS 
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	AOB_ID,
	ACT_ID,
	USU_ID,
	AOB_OBSERVACION,
	AOB_FECHA,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO,
	DD_TOB_ID
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_AOB_ACTIVO_OBS.NEXTVAL				AOB_ID,
	(SELECT ACT.ACT_ID 
	  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	  WHERE ACT.ACT_NUM_ACTIVO_UVEM = MIG.ACT_NUM_ACTIVO)    	ACT_ID,
	(SELECT USU_ID 
  FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS
  WHERE USU_USERNAME = ''GESTADM'')                          	USU_ID,
	MIG.AOB_OBSERVACION										    AOB_OBSERVACION,
	MIG.AOB_FECHA											    AOB_FECHA,
	''0''													    VERSION,
	''#USUARIO_MIGRACION#''										USUARIOCREAR,
	SYSDATE													    FECHACREAR,
	0														    BORRADO,
	(SELECT TOB.DD_TOB_ID 
	FROM '||V_ESQUEMA||'.DD_TOB_TIPO_OBSERVACION TOB 
	WHERE MIG.AOB_TIPO_OBSERVACION = TOB.DD_TOB_CODIGO)			DD_TOB_ID

	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  	WHERE MIG.VALIDACION = 0
	')
	;

  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
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