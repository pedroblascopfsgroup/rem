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
	

	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';

	V_TABLA VARCHAR2(40 CHAR) := 'ACT_DIS_DISTRIBUCION';
	V_TABLA1 VARCHAR2(40 CHAR) := 'ACT_ICO_INFO_COMERCIAL';
	V_TABLA_AUX_MIG VARCHAR2 (30 CHAR) := 'AUX_SEGUIR_MIGRACION';



BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  -- La migracion de los datos de esta tabla se hace en funcion de los datos que ya esten migrados en ACT_VIV, no esten insertados en
  --  ACT_DIS y esten para migrar en MIG_AID.
  -- Ejemplo: Si hay X filas para migrar en MIG_AID de las cuales el ICO_ID de sus corresponientes ACTIVOS no estan insertados en
  --  la tabla ACT_VIV, no se hara el migrado de tales filas, ya que daria error por FK de ACT_VIV a ACT_ICO.
  -- Para ello el WITH obtiene los ICO_ID y ACT_ID de ACT_ICO que estan en la tabla ACT_VIV y no en ACT_DIS para luego cruzarlos con
  --  ACT_ACTIVO y obtener los ACT_NUM_ACTI de los datos que hay que de migrar de la tabla MIG_AID.
	
  	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AUX_MIG||' WHERE SEGUIR_MIGRACION = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 0  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA HAY ACTIVOS INSERTADOS EN ACT_ACTIVO DE LOS QUE SE QUIEREN INSERTAR');
        
    ELSE
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	DIS_ID,
	ICO_ID,
	DIS_NUM_PLANTA,
	DD_TPH_ID,
	DIS_CANTIDAD,
	DIS_SUPERFICIE,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	SELECT	'||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL				DIS_ID,
	ICO.ICO_ID    ICO_ID,
		DIS.DIS_NUM_PLANTA												DIS_NUM_PLANTA,
		DIS.DD_TPH_ID													DD_TPH_ID,
		DIS.DIS_CANTIDAD												DIS_CANTIDAD,
		DIS.DIS_SUPERFICIE												DIS_SUPERFICIE,
		''0''															VERSION,
		'''||V_USUARIO||'''												USUARIOCREAR,
		SYSDATE 														FECHACREAR,
		DIS.BORRADO																BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO ON ICO.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' ICO2 ON ICO2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' DIS ON DIS.ICO_ID = ICO2.ICO_ID
	')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''1''); END;';
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
