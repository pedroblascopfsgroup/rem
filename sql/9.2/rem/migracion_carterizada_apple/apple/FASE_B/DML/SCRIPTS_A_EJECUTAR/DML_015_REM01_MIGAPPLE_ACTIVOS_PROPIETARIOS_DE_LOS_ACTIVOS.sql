--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_APA_PROP_ACTIVO' -> 'ACT_PAC_PROPIETARIO_ACTIVO'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PAC_PROPIETARIO_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_APA_PROP_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de ACTIVOS PROPIETARIO-ACTIVO');

   -------------------------------------------------
   --INSERCION EN ACT_PAC_PROPIETARIO_ACTIVO--
   -------------------------------------------------
   DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_PAC_PROPIETARIO_ACTIVO');
    
   
   --BORRAMOS TODAS LA RELACIONES PROPIETARIO-ACTIVO QUE HUBIERA CON USUCREAR DE LA MIGRACION.
   EXECUTE IMMEDIATE(
    'DELETE FROM '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC
		WHERE EXISTS (
		  SELECT 1
		  FROM '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO 			AUX
		  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO 					ACT ON AUX.ACT_ID = ACT.ACT_ID
		  INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA 				CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
		  INNER JOIN '||V_ESQUEMA||'.MIG2_USUARIOCREAR_CARTERIZADO 	USU ON USU.CARTERA = CRA.DD_CRA_CODIGO
		  WHERE USU.USUARIOCREAR = '''||V_USUARIO||''' AND PAC.ACT_ID = ACT.ACT_ID
		)
   ');
   DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' borrados de la migración actual. '||SQL%ROWCOUNT||' Filas.'); 
   COMMIT;

   V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''10''); END;';
   EXECUTE IMMEDIATE V_SENTENCIA;
      
  
   --INSERTAMOS EN LA ACT_PAC_PROPIETARIO_ACTIVO
   EXECUTE IMMEDIATE ('
   INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
   (
		PAC_ID,
		ACT_ID,
		PRO_ID,
		DD_TGP_ID,
		PAC_PORC_PROPIEDAD,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
    )
	WITH MIG AS (
		SELECT DISTINCT (MIG.ACT_NUMERO_ACTIVO),
						 MIG2.PRO_NIF,
						 MIG.GRADO_PROPIEDAD,
						 MIG.PORCENTAJE
			FROM '||V_ESQUEMA||'.MIG_APA_PROP_ACTIVO 	MIG
			JOIN '||V_ESQUEMA||'.ACT_ACTIVO 			ACT 
					ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
			JOIN '||V_ESQUEMA||'.MIG_APC_PROP_CABECERA 	MIG2
					ON MIG2.PRO_CODIGO = MIG.PRO_CODIGO
			JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO 	PRO 
					ON PRO.PRO_DOCIDENTIF = MIG2.PRO_NIF
			JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA      	CRA
					ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		WHERE NOT EXISTS 
		(
			  SELECT 1 
			  FROM  '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO PAC
			  WHERE PAC.ACT_ID = ACT.ACT_ID
				AND PAC.PRO_ID = PRO.PRO_ID
		)
		AND MIG.VALIDACION = 0
	)
	SELECT
		'||V_ESQUEMA||'.S_ACT_PAC_PROPIETARIO_ACTIVO.NEXTVAL						                                                PAC_ID,
		ACT.ACT_ID, 
		PRO.PRO_ID, 
		(SELECT DD_TGP_ID FROM '||V_ESQUEMA||'.DD_TGP_TIPO_GRADO_PROPIEDAD WHERE DD_TGP_CODIGO = MIG.GRADO_PROPIEDAD)				DD_TGP_ID,
		MIG.PORCENTAJE                 					                                          		                            PAC_PORC_PROPIEDAD,
		''0''                                                                                        	                            VERSION,
		'''||V_USUARIO||'''                                                                                         	            USUARIOCREAR,
		SYSDATE                                                                                	                                    FECHACREAR,
		0                                                                                           	                            BORRADO
	FROM MIG
	JOIN '||V_ESQUEMA||'.ACT_ACTIVO 					ACT 
	  ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO 
	JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO 			PRO
	  ON PRO.PRO_DOCIDENTIF = MIG.PRO_NIF 
	JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA 				CRA
	  ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
  ');
	
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
        
  --CALCULAMOS EL PORCENTAJE DE PROPIEDAD DEL PROPIETARIO.      
  EXECUTE IMMEDIATE ('  
  MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' PAC_OLD
  USING (
	 SELECT A.IDACTIVO FROM
	 (
		 SELECT IDACTIVO
		 FROM (
			  SELECT
				 PAC1.ACT_ID  IDACTIVO,
			     COUNT(*)     NUM_PROPIETARIOS
			   FROM '||V_ESQUEMA||'.'||V_TABLA||' PAC1
			   GROUP BY PAC1.ACT_ID
			   ) WHERE NUM_PROPIETARIOS = 1
	 ) A
	 JOIN '||V_ESQUEMA||'.'||V_TABLA||' PAC2 ON A.IDACTIVO = PAC2.ACT_ID
	 WHERE PAC2.PAC_PORC_PROPIEDAD = 0
	   AND PAC2.USUARIOCREAR = '''||V_USUARIO||'''
	) PAC_NEW
	ON (PAC_OLD.ACT_ID = PAC_NEW.IDACTIVO)
	WHEN MATCHED THEN UPDATE SET 
		PAC_OLD.PAC_PORC_PROPIEDAD = 100
  ');
  
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizado el porcentaje de propiedad del propietario. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de ACTIVOS PROPIETARIOS-ACTIVO');


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
