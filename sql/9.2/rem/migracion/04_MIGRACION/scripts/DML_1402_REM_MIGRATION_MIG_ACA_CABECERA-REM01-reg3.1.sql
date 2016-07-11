--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160212
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ACA_CABECERA' -> 'ACT_ACTIVO', 'BIE_BIEN', 'BIE_ADJ_ADJUDICACION'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_ACTIVO';
V_TABLA_2 VARCHAR2(40 CHAR) := 'BIE_BIEN';
V_TABLA_3 VARCHAR2(40 CHAR) := 'BIE_ADJ_ADJUDICACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ACA_CABECERA';
V_TABLA_MIG_2 VARCHAR2(40 CHAR) := 'MIG_ADA_DATOS_ADI'; --COMPROBACION: PARA DAR DE ALTA UN NUEVO ACTIVO, DEBE VENIR TAMBIEN INFORMADO EN LA INTERFAZ
V_SENTENCIA VARCHAR2(2600 CHAR);
V_NUM NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO NUMEROS DE ACTIVOS...');
  
  V_SENTENCIA := '
  SELECT COUNT(ACT_NUMERO_ACTIVO) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE MIG.ACT_NUMERO_ACTIVO = ACT_NUM_ACTIVO
  )
  '
  ;
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
  
  IF TABLE_COUNT = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS ACTIVOS EXISTEN EN ACT_ACTIVO');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' ACTIVOS INEXISTENTES EN ACT_ACTIVO.');
    DBMS_OUTPUT.PUT_LINE('[INFO] SE PROCEDERÁ AL ALTA DE AQUELLOS ACTIVOS QUE VENGAN INFORMADOS TAMBIÉN EN LAS INTERFACES OBLIGATORIAS.');

	END IF;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  EXECUTE IMMEDIATE ('
  alter table act_activo disable constraint FK_ACTIVO_BIEN
	')
	;
	
	EXECUTE IMMEDIATE ('
  alter table act_activo disable constraint FK_ACTIVO_SUBDIVI
	')
	;
	
EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
  ACT_ID,
  ACT_NUM_ACTIVO,
  ACT_NUM_ACTIVO_REM,
  ACT_NUM_ACTIVO_UVEM,
  ACT_NUM_ACTIVO_SAREB,
  ACT_NUM_ACTIVO_PRINEX,
  ACT_RECOVERY_ID,
  BIE_ID,
  ACT_DESCRIPCION,
  DD_RTG_ID,
  ACT_DIVISION_HORIZONTAL,
  ACT_FECHA_REV_CARGAS,
  ACT_CON_CARGAS,
  ACT_GESTION_HRE,
  DD_TPA_ID,
  DD_SAC_ID,
  DD_EAC_ID,
  DD_TUD_ID,
  DD_TTA_ID,
  DD_STA_ID,
  DD_CRA_ID,
  DD_ENO_ID,
  DD_ENO_ORIGEN_ANT_ID,
  DD_SCM_ID,
  ACT_VPO,
  ACT_ADMISION,
  ACT_GESTION,
  ACT_SELLO_CALIDAD,
  SDV_ID,
  CPR_ID,
  VERSION,
  USUARIOCREAR,
  FECHACREAR,
  USUARIOMODIFICAR,
  FECHAMODIFICAR,
  USUARIOBORRAR,
  FECHABORRAR,
  BORRADO
  )
  SELECT
  '||V_ESQUEMA||'.S_ACT_ACTIVO.NEXTVAL                              ACT_ID,
  MIG.ACT_NUMERO_ACTIVO                                             ACT_NUM_ACTIVO,
  '||V_ESQUEMA||'.S_ACT_NUM_ACTIVO_REM.NEXTVAL                      ACT_NUM_ACTIVO_REM,
  MIG.ACT_NUMERO_UVEM                                               ACT_NUM_ACTIVO_UVEM,
  MIG.ACT_NUMERO_SAREB                                              ACT_NUM_ACTIVO_SAREB,
  MIG.ACT_NUMERO_PRINEX                                             ACT_NUM_ACTIVO_PRINEX,
  NULL                                       						            ACT_RECOVERY_ID,
  '||V_ESQUEMA||'.S_BIE_BIEN.NEXTVAL                                BIE_ID,
  MIG.ACT_DESCRIPCION                                               ACT_DESCRIPCION,
  (SELECT DD_RTG_ID
    FROM '||V_ESQUEMA||'.DD_RTG_RATING_ACTIVO 
    WHERE DD_RTG_CODIGO = MIG.ACT_RATING)                           DD_RTG_ID,
  MIG.ACT_DIVISION_HORIZONTAL                                       ACT_DIVISION_HORIZONTAL,
  MIG.ACT_FECHA_REV_CARGAS                                          ACT_FECHA_REV_CARGAS,
  MIG.ACT_CON_CARGAS                                                ACT_CON_CARGAS,
  MIG.GESTION_HRE                                                   ACT_GESTION_HRE,
  (SELECT DD_TPA_ID 
  FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO 
  WHERE DD_TPA_CODIGO = MIG.TIPO_ACTIVO)                            DD_TPA_ID,
  (SELECT DD_SAC_ID 
  FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO 
  WHERE DD_SAC_CODIGO = MIG.SUBTIPO_ACTIVO)                         DD_SAC_ID,
  (SELECT DD_EAC_ID 
  FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO
  WHERE DD_EAC_CODIGO = MIG.ESTADO_ACTIVO)                          DD_EAC_ID,
  (SELECT DD_TUD_ID 
  FROM '||V_ESQUEMA||'.DD_TUD_TIPO_USO_DESTINO
  WHERE DD_TUD_CODIGO = MIG.USO_ACTIVO)                             DD_TUD_ID,
  (SELECT DD_TTA_ID 
  FROM '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO 
  WHERE DD_TTA_CODIGO = MIG.TIPO_TITULO)                            DD_TTA_ID,
  (SELECT DD_STA_ID 
  FROM '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO 
  WHERE DD_STA_CODIGO = MIG.SUBTIPO_TITULO)                         DD_STA_ID,
  (SELECT DD_CRA_ID 
  FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
  WHERE DD_CRA_CODIGO = MIG.ENTIDAD_PROPIETARIA)                    DD_CRA_ID,
  (SELECT DD_ENO_ID
  FROM '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN
  WHERE DD_ENO_CODIGO = MIG.ENTIDAD_ORIGEN)                         DD_ENO_ID,
  (SELECT DD_ENO_ID
  FROM '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN
  WHERE DD_ENO_CODIGO = MIG.ENTIDAD_ORIGEN_ANTERIOR)                DD_ENO_ORIGEN_ANT_ID,
  (SELECT DD_SCM_ID
  FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL
  WHERE DD_SCM_CODIGO = MIG.SITUACION_COMERCIAL)                	  DD_SCM_ID,
  MIG.ACT_VPO                                                       ACT_VPO,
  MIG.ESTADO_ADMISION                                               ACT_ADMISION,
  MIG.ESTADO_GESTION                                                ACT_GESTION,
  MIG.SELLO_CALIDAD                                                 ACT_SELLO_CALIDAD,
  NULL                     			                                    SDV_ID,
  NULL												                                      CPR_ID,
  ''0''                                                             VERSION,
  ''MIG''                                                           USUARIOCREAR,
  SYSDATE                                                           FECHACREAR,
  NULL                                                              USUARIOMODIFICAR,
  NULL                                                              FECHAMODIFICAR,
  NULL                                                              USUARIOBORRAR,
  NULL                                                              FECHABORRAR,
  0                                                                 BORRADO
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG_2||' MIG2
  ON MIG.ACT_NUMERO_ACTIVO = MIG2.ACT_NUMERO_ACTIVO
  WHERE MIG2.ACT_NUMERO_ACTIVO IS NOT NULL
  AND NOT EXISTS (
		SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' ACT
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    )
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
    COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  
  
  --ASIGNAMOS EL DD_ENO_ID CORRESPONDIENTE AL CODIGO 9999 PENDIENTE DE DEFINIR PARA EL CAMPO DD_ENO_ORIGEN_ANT_ID, CUANDO SEA NULO
  
  EXECUTE IMMEDIATE '
  UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
  SET DD_ENO_ORIGEN_ANT_ID = (SELECT DD_ENO_ID FROM '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN WHERE DD_ENO_CODIGO = ''9999'')
  WHERE DD_ENO_ORIGEN_ANT_ID IS NULL
  '
  ;
  
  ----------
  
  --DAMOS REGISTROS EN ALTA BIE_BIEN Y BIE_ADJ_ADJUDICACION PARA LOS ACTIVOS QUE TRATAMOS
    
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA_2||'.');
  
  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
  BIE_ID,
  BIE_NUMERO_ACTIVO,
  VERSION,
  USUARIOCREAR,
  FECHACREAR,
  BORRADO
  )
  SELECT
  ACT.BIE_ID                                                        BIE_ID,
  ACT.ACT_NUM_ACTIVO_UVEM											BIE_NUMERO_ACTIVO,
  ''0''                                                             VERSION,
  ''MIG''                                                           USUARIOCREAR,
  SYSDATE                                                           FECHACREAR,
  0                                                                 BORRADO
  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.BIE_BIEN BIE WHERE BIE.BIE_ID = ACT.BIE_ID
    )
  ')
  ;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||' ANALIZADA.');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA_3||'.');
  
  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_3||' (
  BIE_ID,
  BIE_ADJ_ID,
  VERSION,
  USUARIOCREAR,
  FECHACREAR,
  BORRADO
  )
  SELECT
  ACT.BIE_ID 								                	  	                  BIE_ID,
  '||V_ESQUEMA||'.S_BIE_ADJ_ADJUDICACION.NEXTVAL					          BIE_ADJ_ID,
  ''0''                                                             VERSION,
  ''MIG''                                                           USUARIOCREAR,
  SYSDATE                                                           FECHACREAR,
  0                                                                 BORRADO
  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
  LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG_2||' MIG2
  ON ACT.ACT_NUM_ACTIVO = MIG2.ACT_NUMERO_ACTIVO
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION BIE WHERE BIE.BIE_ID = ACT.BIE_ID
    )
  AND MIG2.ACT_NUMERO_ACTIVO IS NOT NULL
  ')
  ;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_3||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_3||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_3||' ANALIZADA.');
 
  EXECUTE IMMEDIATE ('
  alter table act_activo enable constraint FK_ACTIVO_BIEN
	')
	;
	
	EXECUTE IMMEDIATE ('
  alter table act_activo enable constraint FK_ACTIVO_SUBDIVI
	')
	;
  
  --INFORMAMOS LA TABLA MIG_INFO_TABLE
  
  V_SENTENCIA := '
	SELECT COUNT(1) 
	FROM '||V_TABLA_MIG||' ACA
	LEFT JOIN '||V_TABLA_MIG_2||' ADI
	ON ADI.ACT_NUMERO_ACTIVO = ACA.ACT_NUMERO_ACTIVO
	WHERE ADI.ACT_NUMERO_ACTIVO IS NULL
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;
  
  V_SENTENCIA := '
	SELECT COUNT(ACT_NUM_ACTIVO) FROM ACT_NOT_EXISTS WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REJECTS;
  
  IF V_NUM != 0 THEN
  
	V_OBSERVACIONES := 'Se han rechazado '||V_NUM||' activos debido a que no vienen informados en '||V_TABLA_MIG_2||'';
	
  END IF;
  
  V_REJECTS := V_REJECTS + V_NUM;
  
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_TPA_TIPO_ACTIVO'',''DD_SAC_SUBTIPO_ACTIVO'',''DD_EAC_ESTADO_ACTIVO'',''DD_TUD_TIPO_USO_DESTINO'',''DD_TTA_TIPO_TITULO_ACTIVO'',''DD_STA_SUBTIPO_TITULO_ACTIVO'',''DD_CRA_CARTERA'',''DD_ENO_ENTIDAD_ORIGEN'',''DD_SCM_SITUACION_COMERCIAL'',''DD_RTG_RATING_ACTIVO'')
	AND FICHERO_ORIGEN = ''ACTIVO_CABECERA.dat''
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
  
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
	(SELECT COUNT(ACT_NUMERO_ACTIVO) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'),
	(SELECT COUNT(ACT_NUM_ACTIVO) FROM '||V_ESQUEMA||'.'||V_TABLA||'),
	'||V_REJECTS||',
	'||V_COD||',
	SYSDATE,
	'''||V_OBSERVACIONES||'''
	FROM DUAL
  ')
  ;
  
  V_COD := 0;
  
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
	'''||V_TABLA_2||''',
	(SELECT COUNT(ACT_NUMERO_ACTIVO) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'),
	(SELECT COUNT(BIE_ID) FROM '||V_ESQUEMA||'.'||V_TABLA_2||'),
	'||V_REJECTS||',
	'||V_COD||',
	SYSDATE,
	'''||V_OBSERVACIONES||'''
	FROM DUAL
  ')
  ;
  
  V_COD := 0;
  
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
	'''||V_TABLA_3||''',
	(SELECT COUNT(ACT_NUMERO_ACTIVO) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'),
	(SELECT COUNT(BIE_ADJ_ID) FROM '||V_ESQUEMA||'.'||V_TABLA_3||'),
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
