--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-15592
--## PRODUCTO=NO
--## 
--## Finalidad:
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
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16329';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);

--Tabla BIENES
V_TABLA VARCHAR2(30 CHAR) := 'BIE_BIEN';
V_TABLA_2 VARCHAR2(30 CHAR) := 'BIE_ADJ_ADJUDICACION';


--Tabla ACTIVOS
V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';

V_TABLA_AUX_MIG VARCHAR2 (30 CHAR) := 'AUX_SEGUIR_MIGRACION';

V_SENTENCIA VARCHAR2(2600 CHAR);


BEGIN

	--INSERTAMOS EN LA TABLA AUX_SEGUIR_MIGRACION UN 1

	EXECUTE IMMEDIATE ('
		INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_AUX_MIG||' (SEGUIR_MIGRACION)
			VALUES (1) ');


  
	-- INSERTAMOS EN LA TABLA ACT_ACTIVO
   DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_ACT||'.');
  
  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' WHERE ACT_NUM_ACTIVO IN (SELECT ACT_NUM_ACTIVO_NUV FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||')';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 0  THEN

	EXECUTE IMMEDIATE ('
		UPDATE '||V_ESQUEMA||'.'||V_TABLA_AUX_MIG||' SET SEGUIR_MIGRACION = 0');
     
        DBMS_OUTPUT.PUT_LINE('[INFO] YA HAY ACTIVOS INSERTADOS EN ACT_ACTIVO DE LOS QUE SE QUIEREN INSERTAR');
        
    ELSE


    EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA_ACT||' disable constraint FK_ACTIVO_BIEN');
	
	EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA_ACT||' disable constraint FK_ACTIVO_SUBDIVI');
	
	
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
			ACT_GESTOR_SELLO_CALIDAD,
			ACT_FECHA_SELLO_CALIDAD,
			SDV_ID,
			
			DD_TCO_ID,
			VERSION,
			USUARIOCREAR,
			FECHACREAR,
			USUARIOMODIFICAR,
			FECHAMODIFICAR,
			USUARIOBORRAR,
			FECHABORRAR,
			BORRADO,
			DD_TCR_ID,
			DD_TAL_ID,
			ACT_IBI_EXENTO,
			
			OK_TECNICO,
			ACT_ACTIVO_DEMANDA_AFECT_COM,
			ACT_EN_TRAMITE,
			DD_SPG_ID,
			ACT_VALOR_LIQUIDEZ,
			DD_TS_ID,
			ACT_DND, 
			DD_OAN_ID,
			ACT_FECHA_TITULO_ANTERIOR,
			DD_TDC_ID,
			DD_ERA_ID,
			DD_EAA_ID,
			DD_SAA_ID,
			ACT_PORCENTAJE_CONSTRUCCION,
			DD_TTR_ID,			
			DD_EQG_ID



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
			(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = AUX.DD_CRA_CODIGO)		    DD_CRA_ID,
			ACT.DD_ENO_ID							                          DD_ENO_ID,
			ACT.DD_ENO_ORIGEN_ANT_ID						                  DD_ENO_ORIGEN_ANT_ID,
			ACT.DD_SCM_ID                                                       DD_SCM_ID,
			(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = AUX.DD_SCR_CODIGO)	  DD_SCR_ID,
			ACT.ACT_VPO                                                       ACT_VPO,
			ACT.ACT_ADMISION                                                  ACT_ADMISION,
			ACT.ACT_GESTION                                                   ACT_GESTION,
			ACT.ACT_SELLO_CALIDAD                                             ACT_SELLO_CALIDAD,
			ACT.ACT_GESTOR_SELLO_CALIDAD											ACT_GESTOR_SELLO_CALIDAD,
			ACT.ACT_FECHA_SELLO_CALIDAD												ACT_FECHA_SELLO_CALIDAD,
			ACT.SDV_ID                 			                              SDV_ID,
		
			ACT.DD_TCO_ID													  DD_TCO_ID,
			''0''                                                             VERSION,
			'''||V_USUARIO||'''                                               USUARIOCREAR,
			SYSDATE                                                           FECHACREAR,
			NULL                                                              USUARIOMODIFICAR,
			NULL                                                              FECHAMODIFICAR,
			NULL                                                              USUARIOBORRAR,
			NULL                                                              FECHABORRAR,
			0                                                                 BORRADO,
			ACT.DD_TCR_ID 													  DD_TCR_ID,
			ACT.DD_TAL_ID													  DD_TAL_ID,
			ACT.ACT_IBI_EXENTO 												  ACT_IBI_EXENTO,
			
			ACT.OK_TECNICO OK_TECNICO,
			ACT.ACT_ACTIVO_DEMANDA_AFECT_COM ACT_ACTIVO_DEMANDA_AFECT_COM,
			ACT.ACT_EN_TRAMITE ACT_EN_TRAMITE,
			ACT.DD_SPG_ID DD_SPG_ID,
			ACT.ACT_VALOR_LIQUIDEZ ACT_VALOR_LIQUIDEZ,
			ACT.DD_TS_ID DD_TS_ID,
			ACT.ACT_DND ACT_DND, 
			ACT.DD_OAN_ID DD_OAN_ID,
			ACT.ACT_FECHA_TITULO_ANTERIOR ACT_FECHA_TITULO_ANTERIOR,
			ACT.DD_TDC_ID DD_TDC_ID,
			ACT.DD_ERA_ID	DD_ERA_ID,
			(SELECT DD_EAA_ID FROM '||V_ESQUEMA||'.DD_EAA_ESTADO_ACT_ADMISION WHERE DD_EAA_CODIGO = ''PSR'' )	AS	DD_EAA_ID,
			(SELECT DD_SAA_ID FROM '||V_ESQUEMA||'.DD_SAA_SUBESTADO_ACT_ADMISION WHERE DD_SAA_CODIGO = ''PIN'' )    AS  DD_SAA_ID,
			ACT.ACT_PORCENTAJE_CONSTRUCCION		ACT_PORCENTAJE_CONSTRUCCION,
			ACT.DD_TTR_ID 		DD_TTR_ID,
			ACT.DD_EQG_ID	DD_EQG_ID
		FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT
		INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
		ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT 
		WHERE ACT.BORRADO = 0
		')
		;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
 
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
			NULL										  BIE_ADJ_F_SEN_POSESION,
			NULL								  BIE_ADJ_IMPORTE_ADJUDICACION,
			NULL										  BIE_ADJ_F_DECRETO_FIRME,
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


  EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA_ACT||' enable constraint FK_ACTIVO_BIEN');
	
  EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA_ACT||' enable constraint FK_ACTIVO_SUBDIVI');
  
  COMMIT;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_ACT||''',''2''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''2''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

    V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_2||''',''2''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;


  END IF;



  
  
  
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
