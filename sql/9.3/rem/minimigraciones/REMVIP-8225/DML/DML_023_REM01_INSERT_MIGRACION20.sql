--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20201013
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8225
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8225';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
	V_TABLA VARCHAR2 (30 CHAR) := 'ACT_ABA_ACTIVO_BANCARIO';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');


  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
    
            DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_ABA_ACTIVO_BANCARIO');
        
    ELSE 
      
      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_ABA_ACTIVO_BANCARIO'',''2''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO 
			(ABA_ID,
			ACT_ID,
			DD_CLA_ID,
			DD_SCA_ID,
			ABA_NEXPRIESGO,
			DD_TIP_ID,
			DD_EER_ID,
			DD_EEI_ID,
			ABA_TIPO_PRODUCTO,
			BORRADO,
			USUARIOCREAR,
			FECHACREAR
			)
        SELECT '||V_ESQUEMA||'.S_ACT_ABA_ACTIVO_BANCARIO.NEXTVAL,
			ACT2.ACT_ID,
			ABA.DD_CLA_ID,
			ABA.DD_SCA_ID,
			ABA.ABA_NEXPRIESGO,
			ABA.DD_TIP_ID,
			ABA.DD_EER_ID,
			ABA.DD_EEI_ID,
			ABA.ABA_TIPO_PRODUCTO,
                0,'''||V_USUARIO||''', SYSDATE
        	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
			JOIN '||V_ESQUEMA||'.'||V_TABLA||' ABA ON ABA.ACT_ID = ACT.ACT_ID';
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO creados. '||SQL%ROWCOUNT||' Filas.');
     
      END IF;
      
      COMMIT; 
      
      DBMS_OUTPUT.PUT_LINE('[FIN]');
      
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
