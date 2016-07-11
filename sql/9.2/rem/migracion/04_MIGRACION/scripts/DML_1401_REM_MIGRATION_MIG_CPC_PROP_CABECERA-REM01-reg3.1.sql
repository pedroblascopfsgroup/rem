--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160212
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_CPC_PROP_CABECERA' -> 'ACT_CPR_COM_PROPIETARIOS'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_CPR_COM_PROPIETARIOS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_CPC_PROP_CABECERA';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	CPR_ID,
	CPR_COD_COM_PROP_UVEM,
	CPR_CONSTITUIDA,
	CPR_NOMBRE,
	CPR_NIF,
	CPR_DIRECCION,
	CPR_NUM_CUENTA,
	CPR_PRESIDENTE_NOMBRE,
	CPR_PRESIDENTE_TELF,
	CPR_PRESIDENTE_TELF2,
	CPR_PRESIDENTE_EMAIL,
	CPR_PRESIDENTE_DIR,
	CPR_PRESIDENTE_FECHA_INI,
	CPR_PRESIDENTE_FECHA_FIN,
	CPR_ADMINISTRADOR_NOMBRE,
	CPR_ADMINISTRADOR_TELF,
	CPR_ADMINISTRADOR_TELF2,
	CPR_ADMINISTRADOR_DIR,
	CPR_ADMINISTRADOR_EMAIL,
	CPR_IMPORTEMEDIO,
	CPR_ESTATUTOS,
	CPR_LIBRO_EDIFICIO,
	CPR_CERTIFICADO_ITE,
	CPR_OBSERVACIONES,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO
	)
	WITH CPR_COD_COM_PROP_UVEM AS (
		SELECT CPR_COD_COM_PROP_UVEM 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
		WHERE CPR_COD_COM_PROP_UVEM NOT IN (
		  SELECT CPR_COD_COM_PROP_UVEM 
		  FROM '||V_ESQUEMA||'.'||V_TABLA||' 
			)
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_CPR_COM_PROPIETARIOS.NEXTVAL    	CPR_ID,
	MIG.CPR_COD_COM_PROP_UVEM							  	CPR_COD_COM_PROP_UVEM,
	MIG.CPR_CONSTITUIDA       							  	CPR_CONSTITUIDA,
	MIG.CPR_NOMBRE                                  	  	CPR_NOMBRE,
	MIG.CPR_NIF                            				  	CPR_NIF,
	MIG.CPR_DIRECCION                             		  	CPR_DIRECCION,
	MIG.CPR_NUM_CUENTA                             		  	CPR_NUM_CUENTA,
	MIG.CPR_PRESIDENTE_NOMBRE                             	CPR_PRESIDENTE_NOMBRE,
	MIG.CPR_PRESIDENTE_TELF									CPR_PRESIDENTE_TELF,
	MIG.CPR_PRESIDENTE_TELF2								CPR_PRESIDENTE_TELF2,
	MIG.CPR_PRESIDENTE_EMAIL								CPR_PRESIDENTE_EMAIL,
	MIG.CPR_PRESIDENTE_DIR									CPR_PRESIDENTE_DIR,
	NULL													CPR_PRESIDENTE_FECHA_INI,
	NULL													CPR_PRESIDENTE_FECHA_FIN,
	MIG.CPR_ADMINISTRADOR_NOMBRE							CPR_ADMINISTRADOR_NOMBRE,
	MIG.CPR_ADMINISTRADOR_TELF								CPR_ADMINISTRADOR_TELF,
	MIG.CPR_ADMINISTRADOR_TELF2								CPR_ADMINISTRADOR_TELF2,
	MIG.CPR_ADMINISTRADOR_DIR								CPR_ADMINISTRADOR_DIR,
	MIG.CPR_ADMINISTRADOR_EMAIL								CPR_ADMINISTRADOR_EMAIL,
	MIG.CPR_IMPORTEMEDIO									CPR_IMPORTEMEDIO,
	MIG.CPR_ESTATUTOS										CPR_ESTATUTOS,
	MIG.CPR_LIBRO_EDIFICIO									CPR_LIBRO_EDIFICIO,
	MIG.CPR_CERTIFICADO_ITE									CPR_CERTIFICADO_ITE,
	MIG.CPR_OBSERVACIONES									CPR_OBSERVACIONES,
	''0''                                                 	VERSION,
	''MIG''                                               	USUARIOCREAR,
	SYSDATE                                               	FECHACREAR,
	NULL                                                  	USUARIOMODIFICAR,
	NULL                                                  	FECHAMODIFICAR,
	NULL                                                  	USUARIOBORRAR,
	NULL                                                  	FECHABORRAR,
	0                                                     	BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN CPR_COD_COM_PROP_UVEM CPR
	ON CPR.CPR_COD_COM_PROP_UVEM = MIG.CPR_COD_COM_PROP_UVEM
	')
	;

	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  --INFORMAMOS LA TABLA MIG_INFO_TABLE
  
  -- Registros MIG
  V_SENTENCIA := '
	SELECT COUNT(CPR_COD_COM_PROP_UVEM) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(CPR_COD_COM_PROP_UVEM) FROM '||V_ESQUEMA||'.'||V_TABLA||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	

  
  EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.MIG_INFO_TABLE (
	TABLA_MIG,
	TABLA_REM,
	REGISTROS_TABLA_MIG,
	REGISTROS_INSERTADOS,
	REGISTROS_RECHAZADOS,
	DD_COD_INEXISTENTES,
	FECHA,
	OBSERVACIONES
	)
	SELECT
	'''||V_TABLA_MIG||''',
	'''||V_TABLA||''',
	'||V_REG_MIG||',
	'||V_REG_INSERTADOS||',
	'||V_REJECTS||',
	'||V_COD||',
	SYSDATE,
	'''||V_OBSERVACIONES||'''
	FROM DUAL
  ')
  ;
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] INFORMADA LA TABLA '||V_ESQUEMA||'.MIG_INFO_TABLE CON LOS REGISTROS INSERTADOS Y RECHAZADOS.');  
  
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
