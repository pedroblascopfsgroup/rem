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

-- Variables
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16329';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);
V_SENTENCIA VARCHAR2(2000 CHAR);

V_TABLA VARCHAR2(30 CHAR) := 'BIE_CAR_CARGAS';
V_TABLA_2 VARCHAR2(30 CHAR) := 'ACT_CRG_CARGAS';

V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
V_TABLA_AUX_MIG VARCHAR2 (30 CHAR) := 'AUX_SEGUIR_MIGRACION';

BEGIN


  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA||'.');
  	
  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AUX_MIG||' WHERE SEGUIR_MIGRACION = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 0  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA HAY ACTIVOS INSERTADOS EN ACT_ACTIVO DE LOS QUE SE QUIEREN INSERTAR');
        
    ELSE
    
  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		BIE_ID,
		BIE_CAR_ID,
		DD_TPC_ID,
		BIE_CAR_TITULAR,
		BIE_CAR_IMPORTE_REGISTRAL,
		BIE_CAR_IMPORTE_ECONOMICO,
		BIE_CAR_FECHA_PRESENTACION,
		BIE_CAR_FECHA_INSCRIPCION,
		BIE_CAR_FECHA_CANCELACION,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
  )
  SELECT
		ACT2.BIE_ID                                                     	BIE_ID,
		'||V_ESQUEMA||'.S_BIE_CAR_CARGAS.NEXTVAL    		            	BIE_CAR_ID,
		CAR.DD_TPC_ID							                        	DD_TPC_ID,
		CAR.BIE_CAR_TITULAR													BIE_CAR_TITULAR,
		CAR.BIE_CAR_IMPORTE_REGISTRAL										BIE_CAR_IMPORTE_REGISTRAL,
		CAR.BIE_CAR_IMPORTE_ECONOMICO										BIE_CAR_IMPORTE_ECONOMICO,
		CAR.BIE_CAR_FECHA_PRESENTACION										BIE_CAR_FECHA_PRESENTACION,
		CAR.BIE_CAR_FECHA_INSCRIPCION										BIE_CAR_FECHA_INSCRIPCION,
		CAR.BIE_CAR_FECHA_CANCELACION										BIE_CAR_FECHA_CANCELACION,
		0                                                               	VERSION,
		'''||V_USUARIO||'''                                             	USUARIOCREAR,
		SYSDATE                                                         	FECHACREAR,
		CAR.BORRADO                                                               	BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' CAR ON ACT.BIE_ID = CAR.BIE_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
  ')
  ;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');  

  
 
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA_2||'.');
  
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA HAY ACTIVOS INSERTADOS EN ACT_ACTIVO DE LOS QUE SE QUIEREN INSERTAR');
        
    
    
  
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
		CRG_ID,
		ACT_ID,
		BIE_CAR_ID,
		DD_TCA_ID,
		DD_STC_ID,
		CRG_DESCRIPCION,
		CRG_ORDEN,
		CRG_FECHA_CANCEL_REGISTRAL,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
	)
	SELECT
		'||V_ESQUEMA||'.S_ACT_CRG_CARGAS.NEXTVAL                CRG_ID,
		ACT2.ACT_ID                                             ACT_ID,
		BIE_CAR.BIE_CAR_ID                                      BIE_CAR_ID,
		CAR.DD_TCA_ID                   						DD_TCA_ID,
		CAR.DD_STC_ID                							DD_STC_ID,
		CAR.CRG_DESCRIPCION								        CRG_DESCRIPCION,
		CAR.CRG_ORDEN							                CRG_ORDEN,
		CAR.CRG_FECHA_CANCEL_REGISTRAL							CRG_FECHA_CANCEL_REGISTRAL,
		0                                                 	    VERSION,
		'''||V_USUARIO||'''                                     USUARIOCREAR,
		SYSDATE                                               	FECHACREAR,
		CAR.BORRADO                                                     	BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' CAR ON ACT.ACT_ID = CAR.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' BIE_CAR ON ACT2.BIE_ID = BIE_CAR.BIE_ID
	')
	;

  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_2||''',''10''); END;';
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
