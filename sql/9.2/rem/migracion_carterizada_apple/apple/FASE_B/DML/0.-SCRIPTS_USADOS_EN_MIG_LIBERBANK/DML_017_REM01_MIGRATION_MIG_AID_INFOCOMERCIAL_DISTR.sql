--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_DIS_DISTRIBUCION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AID_INFCOMERCIAL_DISTR';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
  
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
	AND MIG.VALIDACION = 0
  )
  )
  UNION
  SELECT ACT_NUMERO_ACTIVO FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WHERE ACT_NUMERO_ACTIVO IN (
  SELECT ACT_NUMERO_ACTIVO FROM (
  SELECT DISTINCT(ACT_NUMERO_ACTIVO||DIS_NUM_PLANTA||TIPO_HABITACULO), count(*), ACT_NUMERO_ACTIVO FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  WHERE VALIDACION = 0
  group by  (ACT_NUMERO_ACTIVO||DIS_NUM_PLANTA||TIPO_HABITACULO),ACT_NUMERO_ACTIVO
  having count(*)> 1
  )
  )
),
ICO AS (
    SELECT ICOW.ICO_ID, ICOW.ACT_ID  
    FROM '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICOW
    WHERE NOT EXISTS (
      SELECT 1 
      FROM '||V_ESQUEMA||'.ACT_DIS_DISTRIBUCION DISW
      WHERE DISW.ICO_ID = ICOW.ICO_ID
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
	'''||V_USUARIO||'''																                                                              USUARIOCREAR,
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
AND MIG.VALIDACION = 0
	')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
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
