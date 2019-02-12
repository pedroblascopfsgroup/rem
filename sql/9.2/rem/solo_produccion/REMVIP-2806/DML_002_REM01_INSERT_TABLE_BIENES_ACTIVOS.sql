--/*
--#########################################
--## AUTOR=Maria Presencia Herrero
--## FECHA_CREACION=20181119
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2806
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 
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
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2806';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);

--Tabla BIENES
V_TABLA VARCHAR2(30 CHAR) := 'BIE_BIEN';
V_TABLA_2 VARCHAR2(30 CHAR) := 'BIE_ADJ_ADJUDICACION';


--Tabla ACTIVOS
V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_GALEON_2';

V_SENTENCIA VARCHAR2(2600 CHAR);


BEGIN
  
	-- INSERTAMOS EN LA TABLA ACT_ACTIVO
   DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_ACT||'.');
  
  
    EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA_ACT||' disable constraint FK_ACTIVO_BIEN');
	
	EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA_ACT||' disable constraint FK_ACTIVO_SUBDIVI');
  
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS ACTIVOS');
        
    ELSE
		EXECUTE IMMEDIATE ('
		INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ACT||' (
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
			DD_SCR_ID,
			ACT_VPO,
			ACT_ADMISION,
			ACT_GESTION,
			ACT_SELLO_CALIDAD,
			SDV_ID,
			CPR_ID,
			ACT_LLAVES_NECESARIAS,
			ACT_LLAVES_HRE,
			ACT_LLAVES_FECHA_RECEP,
			ACT_LLAVES_NUM_JUEGOS,
			DD_TCO_ID,
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
			AUX.ACT_NUM_ACTIVO_NUV                                            ACT_NUM_ACTIVO,
			'||V_ESQUEMA||'.S_ACT_NUM_ACTIVO_REM.NEXTVAL                      ACT_NUM_ACTIVO_REM,
			null			                                                  ACT_NUM_ACTIVO_UVEM,
			null				                                              ACT_NUM_ACTIVO_SAREB,
			null				                                              ACT_NUM_ACTIVO_PRINEX,
			NULL                                						      ACT_RECOVERY_ID,
			'||V_ESQUEMA||'.S_BIE_BIEN.NEXTVAL                                BIE_ID,
			ACT.ACT_DESCRIPCION                                               ACT_DESCRIPCION,
			ACT.DD_RTG_ID						                              DD_RTG_ID,
			NVL(ACT.ACT_DIVISION_HORIZONTAL,0)                                ACT_DIVISION_HORIZONTAL,
			ACT.ACT_FECHA_REV_CARGAS                                          ACT_FECHA_REV_CARGAS,
			ACT.ACT_CON_CARGAS                                                ACT_CON_CARGAS,
			ACT.ACT_GESTION_HRE                                               ACT_GESTION_HRE,
			ACT.DD_TPA_ID						                              DD_TPA_ID,
			ACT.DD_SAC_ID							                          DD_SAC_ID,
			ACT.DD_EAC_ID							                          DD_EAC_ID,
			ACT.DD_TUD_ID						                              DD_TUD_ID,
			ACT.DD_TTA_ID						                              DD_TTA_ID,
			ACT.DD_STA_ID							                          DD_STA_ID,
			AUX.DD_CRA_ID								                      DD_CRA_ID,
			ACT.DD_ENO_ID							                          DD_ENO_ID,
			ACT.DD_ENO_ORIGEN_ANT_ID						                  DD_ENO_ORIGEN_ANT_ID,
			(SELECT DD_SCM_ID
			FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL
			WHERE DD_SCM_CODIGO = ''02'')                	  				  DD_SCM_ID,
			(SELECT DD_SCR_ID
			FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA
			WHERE DD_SCR_CODIGO = ''40'')									  DD_SCR_ID,
			ACT.ACT_VPO                                                       ACT_VPO,
			ACT.ACT_ADMISION                                                  ACT_ADMISION,
			ACT.ACT_GESTION                                                   ACT_GESTION,
			ACT.ACT_SELLO_CALIDAD                                             ACT_SELLO_CALIDAD,
			ACT.SDV_ID                 			                              SDV_ID,
			ACT.CPR_ID											              CPR_ID,
			ACT.ACT_LLAVES_NECESARIAS										  ACT_LLAVES_NECESARIAS,
			ACT.ACT_LLAVES_HRE												  ACT_LLAVES_HRE,
			ACT.ACT_LLAVES_FECHA_RECEP										  ACT_LLAVES_FECHA_RECEP,
			ACT.ACT_LLAVES_NUM_JUEGOS										  ACT_LLAVES_NUM_JUEGOS,
			ACT.DD_TCO_ID													  DD_TCO_ID,
			''0''                                                             VERSION,
			'''||V_USUARIO||'''                                               USUARIOCREAR,
			SYSDATE                                                           FECHACREAR,
			NULL                                                              USUARIOMODIFICAR,
			NULL                                                              FECHAMODIFICAR,
			NULL                                                              USUARIOBORRAR,
			NULL                                                              FECHABORRAR,
			0                                                                 BORRADO
		FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT
		INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
		ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT 
		WHERE ACT.BORRADO = 0
		')
		;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  
  
  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
  IF V_NUM > 1  THEN
        
      DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN BIE_BIEN');
        
  ELSE 
	-- INSERTAMOS EN LA TABLA BIE_BIEN
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA||'.');
  
		EXECUTE IMMEDIATE ('
		INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
			BIE_ID,
			BIE_NUMERO_ACTIVO,
			VERSION,
			USUARIOCREAR,
			FECHACREAR,
			BORRADO
		)
		SELECT
			ACT.BIE_ID                                                        BIE_ID,
			ACT.ACT_NUM_ACTIVO_UVEM											  BIE_NUMERO_ACTIVO,
			''0''                                                             VERSION,
			'''||V_USUARIO||'''                                               USUARIOCREAR,
			SYSDATE                                                           FECHACREAR,
			0                                                                 BORRADO
		FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT
		JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_NUV
		WHERE ACT.USUARIOCREAR = '''||V_USUARIO||''' 
		')
		;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

  END IF;
  
  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_2||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
  IF V_NUM > 1  THEN
        
      DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN BIE_ADJ_ADJUDICACION');
        
  ELSE 

	-- INSERTAMOS EN LA TABLA BIE_ADJ_ADJUDICACION
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA_2||'.');
  
		EXECUTE IMMEDIATE ('
		INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
			BIE_ID,
			BIE_ADJ_ID,
			BIE_ADJ_F_SEN_POSESION,
			BIE_ADJ_IMPORTE_ADJUDICACION,
			BIE_ADJ_F_DECRETO_FIRME,
			VERSION,
			USUARIOCREAR,
			FECHACREAR,
			BORRADO
		)
		SELECT
			ACT.BIE_ID 								                	  	  BIE_ID,
			'||V_ESQUEMA||'.S_BIE_ADJ_ADJUDICACION.NEXTVAL					  BIE_ADJ_ID,
			ADJ.BIE_ADJ_F_SEN_POSESION										  BIE_ADJ_F_SEN_POSESION,
			ADJ.BIE_ADJ_IMPORTE_ADJUDICACION								  BIE_ADJ_IMPORTE_ADJUDICACION,
			ADJ.BIE_ADJ_F_DECRETO_FIRME										  BIE_ADJ_F_DECRETO_FIRME,
			''0''                                                             VERSION,
			'''||V_USUARIO||'''                                               USUARIOCREAR,
			SYSDATE                                                           FECHACREAR,
			0                                                                 BORRADO
		FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT
		JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_NUV
		JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_ANT = ACT2.ACT_NUM_ACTIVO
		JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' ADJ ON ACT2.BIE_ID = ADJ.BIE_ID
		')
		;
		
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  
  EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA_ACT||' enable constraint FK_ACTIVO_BIEN');
	
  EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA_ACT||' enable constraint FK_ACTIVO_SUBDIVI');
  
  COMMIT;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_ACT||''',''2''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''2''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_2||''',''2''); END;';
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
