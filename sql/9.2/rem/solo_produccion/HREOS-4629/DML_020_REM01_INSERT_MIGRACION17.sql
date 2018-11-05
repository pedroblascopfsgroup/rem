--/*
--#########################################
--## AUTOR=Maria Presencia Herrero
--## FECHA_CREACION=20181102
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4629
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
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-4629';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_GALEON';
	V_TABLA VARCHAR2 (30 CHAR) := 'ACT_PTO_PRESUPUESTO';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');

      -------------------------------------------------
      --insercion en ACT_PTO_PRESUPUESTO--
      -------------------------------------------------
     V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
    
            DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_PTO_PRESUPUESTO');
        
    ELSE 
      
      V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_PTO_PRESUPUESTO'',''2''); END;';
      EXECUTE IMMEDIATE V_SQL;

      V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO (PTO_ID, ACT_ID, EJE_ID, PTO_IMPORTE_INICIAL, PTO_FECHA_ASIGNACION, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_PTO_PRESUPUESTO.NEXTVAL
            , ACT2.ACT_ID, PTO.EJE_ID, PTO.PTO_IMPORTE_INICIAL
            , SYSDATE, '''||USUARIO_MIGRACION||''', SYSDATE
        	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
			JOIN '||V_ESQUEMA||'.'||V_TABLA||' PTO ON PTO.ACT_ID = ACT.ACT_ID';
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_PTO_PRESUPUESTO creados. '||SQL%ROWCOUNT||' Filas.');
     
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
