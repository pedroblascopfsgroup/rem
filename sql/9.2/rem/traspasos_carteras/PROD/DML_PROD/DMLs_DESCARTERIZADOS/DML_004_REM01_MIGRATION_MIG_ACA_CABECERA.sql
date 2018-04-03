--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(20 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_ACTIVO';
V_TABLA_2 VARCHAR2(40 CHAR) := 'BIE_BIEN';
V_TABLA_3 VARCHAR2(40 CHAR) := 'BIE_ADJ_ADJUDICACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ACA_CABECERA';
V_TABLA_MIG_2 VARCHAR2(40 CHAR) := 'MIG_ADA_DATOS_ADI'; --COMPROBACION: PARA DAR DE ALTA UN NUEVO ACTIVO, DEBE VENIR TAMBIEN INFORMADO EN LA INTERFAZ
V_SENTENCIA VARCHAR2(2600 CHAR);

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  EXECUTE IMMEDIATE ('
  alter table '||V_ESQUEMA||'.'||V_TABLA||' disable constraint FK_ACTIVO_BIEN
	')
	;
	
	EXECUTE IMMEDIATE ('
  alter table '||V_ESQUEMA||'.'||V_TABLA||' disable constraint FK_ACTIVO_SUBDIVI
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
  NVL(MIG.ACT_DIVISION_HORIZONTAL,0)                                       ACT_DIVISION_HORIZONTAL,
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
  '''||V_USUARIO||'''                                               USUARIOCREAR,
  SYSDATE                                                           FECHACREAR,
  NULL                                                              USUARIOMODIFICAR,
  NULL                                                              FECHAMODIFICAR,
  NULL                                                              USUARIOBORRAR,
  NULL                                                              FECHABORRAR,
  0                                                                 BORRADO
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG_2||' MIG2
  ON MIG.ACT_NUMERO_ACTIVO = MIG2.ACT_NUMERO_ACTIVO
	AND MIG.VALIDACION = 0 AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' AUX WHERE AUX.ACT_NUM_aCTIVO = MIG.ACT_NUMERO_ACTIVO)
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  --ASIGNAMOS EL DD_ENO_ID CORRESPONDIENTE AL CODIGO 9999 PENDIENTE DE DEFINIR PARA EL CAMPO DD_ENO_ORIGEN_ANT_ID, CUANDO SEA NULO
  
  EXECUTE IMMEDIATE '
  UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
  SET DD_ENO_ORIGEN_ANT_ID = (SELECT DD_ENO_ID FROM '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN WHERE DD_ENO_CODIGO = ''9999'')
  WHERE DD_ENO_ORIGEN_ANT_ID IS NULL
  '
  ;
  

  EXECUTE IMMEDIATE '
    MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
    USING (SELECT ACT_NUMERO_ACTIVO, TIPO_ACTIVO, SUBTIPO_ACTIVO, ESTADO_ACTIVO, ESTADO_GESTION, SITUACION_COMERCIAL
        , ACT_CON_CARGAS, ACT_FECHA_REV_CARGAS, ESTADO_ADMISION, TIPO_TITULO, SUBTIPO_TITULO
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
      WHERE VALIDACION IN (0,1)) T2
    ON (T1.ACT_NUM_ACTIVO = T2.ACT_NUMERO_ACTIVO)
    WHEN MATCHED THEN UPDATE SET
      T1.DD_TPA_ID = (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA WHERE TPA.DD_TPA_CODIGO = T2.TIPO_ACTIVO)
      , T1.DD_SAC_ID = (SELECT DD_SAC_ID FROM '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC WHERE SAC.DD_SAC_CODIGO = T2.SUBTIPO_ACTIVO)
      , T1.DD_EAC_ID = (SELECT DD_EAC_ID FROM '||V_ESQUEMA||'.DD_EAC_ESTADO_ACTIVO EAC WHERE EAC.DD_EAC_CODIGO = T2.ESTADO_ACTIVO)
      , T1.ACT_GESTION = T2.ESTADO_GESTION, T1.ACT_ADMISION = T2.ESTADO_ADMISION
      , T1.DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM WHERE SCM.DD_SCM_CODIGO = T2.SITUACION_COMERCIAL)
      , T1.ACT_CON_CARGAS = T2.ACT_CON_CARGAS, T1.ACT_FECHA_REV_CARGAS = T2.ACT_FECHA_REV_CARGAS
      , T1.DD_TTA_ID = (SELECT DD_TTA_ID FROM '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO TTA WHERE TTA.DD_TTA_CODIGO = T2.TIPO_TITULO)
      , T1.DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA WHERE STA.DD_STA_CODIGO = T2.SUBTIPO_TITULO)';
  ----------
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' tipos y subtipos actualizados. '||SQL%ROWCOUNT||' Filas.');
  
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
  ACT.ACT_NUM_ACTIVO_UVEM											                      BIE_NUMERO_ACTIVO,
  ''0''                                                             VERSION,
  '''||V_USUARIO||'''                                               USUARIOCREAR,
  SYSDATE                                                           FECHACREAR,
  0                                                                 BORRADO
  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.BIE_BIEN BIE WHERE BIE.BIE_ID = ACT.BIE_ID
    )
   AND ACT.USUARIOCREAR = '''||V_USUARIO||''' 
  ')
  ;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
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
  '''||V_USUARIO||'''                                               USUARIOCREAR,
  SYSDATE                                                           FECHACREAR,
  0                                                                 BORRADO
  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION BIE WHERE BIE.BIE_ID = ACT.BIE_ID
    )
  AND ACT.USUARIOCREAR = '''||V_USUARIO||''' 
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_3||' cargada. '||SQL%ROWCOUNT||' Filas.');
 
  EXECUTE IMMEDIATE ('
  alter table '||V_ESQUEMA||'.'||V_TABLA||' enable constraint FK_ACTIVO_BIEN
	')
	;
	
	EXECUTE IMMEDIATE ('
  alter table '||V_ESQUEMA||'.'||V_TABLA||' enable constraint FK_ACTIVO_SUBDIVI
	')
	;
  
  COMMIT;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''2''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_2||''',''2''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_3||''',''2''); END;';
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
