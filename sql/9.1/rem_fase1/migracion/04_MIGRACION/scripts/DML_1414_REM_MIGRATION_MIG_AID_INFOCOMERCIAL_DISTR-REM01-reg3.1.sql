--/*
--#########################################
--## AUTOR=Manuel Rodriguez
--## FECHA_CREACION=20160302
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AID_INFOCOMERCIAL_DISTR' -> 'ACT_DIS_DISTRIBUCION'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_DIS_DISTRIBUCION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AID_INFOCOMERCIAL_DISTR';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
VAR1 NUMBER(10,0) := 0;
VAR2 NUMBER(10,0) := 0;
VAR3 NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO ACTIVOS...');
  
  V_SENTENCIA := '
  SELECT COUNT(ACT_NUMERO_ACTIVO) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
  )
  '
  ;
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
  
  IF TABLE_COUNT = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS ACTIVOS EXISTEN EN ACT_ACTIVO');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' ACTIVOS INEXISTENTES EN ACT_ACTIVO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.ACT_NOT_EXISTS.');
    V_OBSERVACIONES := 'Del total de registros rechazados, '||TABLE_COUNT||' han sido por ACTIVOS inexistentes en ACT_ACTIVO. ';
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.ACT_NOT_EXISTS (
    ACT_NUM_ACTIVO,
    TABLA_MIG,
    FECHA_COMPROBACION
    )
    WITH ACT_NUM_ACTIVO AS (
		SELECT
		MIG.ACT_NUMERO_ACTIVO 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		WHERE NOT EXISTS (
		  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE MIG.ACT_NUMERO_ACTIVO = ACT_NUM_ACTIVO
		)
    )
    SELECT
    MIG.ACT_NUMERO_ACTIVO                              							 ACT_NUM_ACTIVO,
    '''||V_TABLA_MIG||'''                                                        TABLA_MIG,
    SYSDATE                                                                      FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN ACT_NUM_ACTIVO
    ON ACT_NUM_ACTIVO.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    '
    ;
    
    /*
    DBMS_OUTPUT.PUT_LINE('[INFO] SE BORRARÁN DE '||V_ESQUEMA||'.'||V_TABLA_MIG||' LOS ACTIVOS INEXISTENTES. MIRAR '||V_ESQUEMA||'.ACT_NOT_EXISTS.');
    
    EXECUTE IMMEDIATE '
    DELETE 
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    WHERE EXISTS (
      SELECT 1 FROM ACT_NOT_EXISTS WHERE MIG.ACT_NUMERO_ACTIVO = ACT_NUM_ACTIVO
    )
    '
    ;
    */
    COMMIT;

  END IF;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  -- La migracion de los datos de esta tabla se hace en funcion de los datos que ya esten migrados en ACT_VIV, no esten insertados en
  --  ACT_DIS y esten para migrar en MIG_AID.
  -- Ejemplo: Si hay X filas para migrar en MIG_AID de las cuales el ICO_ID de sus corresponientes ACTIVOS no estan insertados en
  --  la tabla ACT_VIV, no se hara el migrado de tales filas, ya que daria error por FK de ACT_VIV a ACT_ICO.
  -- Para ello el WITH obtiene los ICO_ID y ACT_ID de ACT_ICO que estan en la tabla ACT_VIV y no en ACT_DIS para luego cruzarlos con
  --  ACT_ACTIVO y obtener los ACT_NUM_ACTI de los datos que hay que de migrar de la tabla MIG_AID.
  
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
WITH DESCARTES AS (
  SELECT ACT_NUMERO_ACTIVO FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WHERE ACT_NUMERO_ACTIVO IN (
  SELECT ACT_NUMERO_ACTIVO FROM (
  SELECT MIG.ACT_NUMERO_ACTIVO, ACT.ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
  ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  WHERE ACT.ACT_NUM_ACTIVO IS NULL
  )
  )
  UNION
  SELECT ACT_NUMERO_ACTIVO FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WHERE ACT_NUMERO_ACTIVO IN (
  SELECT ACT_NUMERO_ACTIVO FROM (
  SELECT DISTINCT(ACT_NUMERO_ACTIVO||DIS_NUM_PLANTA||TIPO_HABITACULO), count(*), ACT_NUMERO_ACTIVO FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  group by  (ACT_NUMERO_ACTIVO||DIS_NUM_PLANTA||TIPO_HABITACULO),ACT_NUMERO_ACTIVO
  having count(*)> 1
  )
  )
),
ICO AS (
    SELECT ICOW.ICO_ID, ICOW.ACT_ID  
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICOW
    INNER JOIN '||V_ESQUEMA||'.ACT_VIV_VIVIENDA VIVW
      ON VIVW.ICO_ID = ICOW.ICO_ID
    WHERE NOT EXISTS (
      SELECT 1 
      FROM '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DISW
      WHERE DISW.ICO_ID = VIVW.ICO_ID
      )
  )
SELECT	'||V_ESQUEMA||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL							DIS_ID,
  ICO.ICO_ID    ICO_ID,
	MIG.DIS_NUM_PLANTA														                                          DIS_NUM_PLANTA,
	(SELECT DD_TPH_ID 
	FROM DD_TPH_TIPO_HABITACULO DD 
	WHERE DD.DD_TPH_CODIGO = MIG.TIPO_HABITACULO)							      DD_TPH_ID,
	MIG.DIS_CANTIDAD														                                              DIS_CANTIDAD,
	MIG.DIS_SUPERFICIE														                                              DIS_SUPERFICIE,
	''0''															                                                                  VERSION,
	''MIG''																                                                              USUARIOCREAR,
	SYSDATE 																                                                        FECHACREAR,
	0																		                                                                BORRADO
FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
INNER JOIN ICO
ON ICO.ACT_ID = ACT.ACT_ID
LEFT JOIN DESCARTES DES
ON DES.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
WHERE DES.ACT_NUMERO_ACTIVO IS NULL
AND MIG.TIPO_HABITACULO != ''UNDEFINED''
	')
  ;

	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');

  -- INFORMAMOS A LA TABLA INFO
  
  -- Registros MIG
  V_SENTENCIA := '
	SELECT COUNT(ACT_NUMERO_ACTIVO) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(DIS_ID) FROM '||V_ESQUEMA||'.'||V_TABLA||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
  
  -- Diccionarios rechazados
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_TPH_TIPO_HABITACULO'')
	AND FICHERO_ORIGEN = ''INFOCOMERCIAL_DISTRIBUCION.dat''
	AND CAMPO_ORIGEN IN (''TIPO_HABITACULO'')
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
  
	EXECUTE IMMEDIATE '
	select count(act_numero_activo) from '||V_ESQUEMA||'.'||V_TABLA_MIG||' mig
	left join '||V_ESQUEMA||'.act_activo act
	on act.act_num_activo = mig.act_numero_activo
	left join '||V_ESQUEMA||'.act_ico_info_comercial ico
	on act.act_id = ico.act_id
	left join '||V_ESQUEMA||'.act_viv_vivienda viv
	on viv.ico_id = ico.ico_id
	where act.act_id is  not null
	and ico.ico_id is not null
	and viv.ico_id is null
	'
	INTO VAR1
	;
	
	IF VAR1 != 0 THEN
	
		V_OBSERVACIONES := V_OBSERVACIONES||' '||VAR1||' han sido rechazados por registros inexistentes en ACT_VIV_VIVIENDA. ';
		
	END IF;
	
	EXECUTE IMMEDIATE '
	select count(act_numero_activo) from '||V_ESQUEMA||'.'||V_TABLA_MIG||' mig
	left join '||V_ESQUEMA||'.act_activo act
	on act.act_num_activo = mig.act_numero_activo
	left join '||V_ESQUEMA||'.act_ico_info_comercial ico
	on act.act_id = ico.act_id
	where act.act_id is  not null
	and ico.ico_id is null
	'
	INTO VAR2
	;
	
	IF VAR2 != 0 THEN
	
		V_OBSERVACIONES := V_OBSERVACIONES||' '||VAR2||' han sido rechazados por registros inexistentes en ACT_ICO_INFO_COMERCIAL. ';
		
	END IF;
	
  
  EXECUTE IMMEDIATE '
	SELECT COUNT(ACT_NUMERO_ACTIVO) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WHERE ACT_NUMERO_ACTIVO IN (
	SELECT ACT_NUMERO_ACTIVO FROM (
	SELECT DISTINCT(ACT_NUMERO_ACTIVO||DIS_NUM_PLANTA||TIPO_HABITACULO), COUNT(*), ACT_NUMERO_ACTIVO FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
	GROUP BY  (ACT_NUMERO_ACTIVO||DIS_NUM_PLANTA||TIPO_HABITACULO),ACT_NUMERO_ACTIVO
	HAVING COUNT(*)> 1
	)
	)
	'
	INTO VAR3
	;
	
	IF VAR3 != 0 THEN
	
		V_OBSERVACIONES := V_OBSERVACIONES||' '||VAR3||' han sido rechazados por registros mal informados en MIG_AID_INFOCOMERCIAL_DISTR. ';
		
	END IF;
	
  END IF;
  
    
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
