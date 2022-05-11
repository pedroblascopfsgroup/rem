--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220511
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-17849
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
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-17849';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);


--Tabla ACTIVOS
V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_GCP_GESTION_CCPP';
V_TABLA_ACT_GCP VARCHAR2 (30 CHAR) := 'ACT_GCP_GESTION_CCPP';
V_SENTENCIA VARCHAR2(2600 CHAR);


BEGIN



	--INSERT EN ACT_GCP_GESTION_CCPP
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_ACT_GCP||' (
			GCP_ID,
            CPR_ID,
            DD_ELO_ID,
            DD_SEG_ID,
            USU_ID,
            GCP_FECHA_INI,
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
			'||V_ESQUEMA||'.S_ACT_GCP_GESTION_CCPP.NEXTVAL              GCP_ID,
			ACT.CPR_ID                                                  CPR_ID,
            (SELECT ELO.DD_ELO_ID FROM '||V_ESQUEMA||'.DD_ELO_ESTADO_LOCALIZACION ELO WHERE ELO.DD_ELO_CODIGO = AUX.DD_ELO_CODIGO)      DD_ELO_ID,
			(SELECT SEG.DD_SEG_ID FROM '||V_ESQUEMA||'.DD_SEG_SUBESTADO_GESTION SEG WHERE SEG.DD_SEG_CODIGO = AUX.DD_SEG_CODIGO)        DD_SEG_ID,
            1      														 USU_ID,
            SYSDATE     												 GCP_FECHA_INI,
			''0''                                                            VERSION,
			'''||V_USUARIO||'''                                          USUARIOCREAR,
			SYSDATE                                                      FECHACREAR,
			NULL                                                         USUARIOMODIFICAR,
			NULL                                                         FECHAMODIFICAR,
			NULL                                                         USUARIOBORRAR,
			NULL                                                         FECHABORRAR,
			0                                                            BORRADO
		FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
		INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
		INNER JOIN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS CPR ON CPR.CPR_ID = ACT.CPR_ID
		WHERE ACT.BORRADO = 0';
      EXECUTE IMMEDIATE V_SQL;
				
		

  
  COMMIT;


  
  
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
