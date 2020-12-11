--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200929
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8150
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8150_1';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
	V_TABLA VARCHAR2 (30 CHAR) := 'GEE_GESTOR_ENTIDAD';
	V_TABLA1 VARCHAR2 (30 CHAR) := 'GAC_GESTOR_ADD_ACTIVO';
	V_TABLA2 VARCHAR2 (30 CHAR) := 'GEH_GESTOR_ENTIDAD_HIST';
	V_TABLA3 VARCHAR2 (30 CHAR) := 'GAH_GESTOR_ACTIVO_HISTORICO';
	
BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');

	EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA1||' disable constraint FK_GESTORADDI_GESTORENTIDAD');

      -------------------------------------------------
      --INSERCION EN GEE_GESTOR_ENTIDAD--
      -------------------------------------------------
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
    
            DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA GEE_GESTOR_ENTIDAD');
        
    ELSE 
      
            ------------------------------
      --INSERCION EN GAC_GESTOR_ADD_ACTIVO--
      -------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GAC_GESTOR_ADD_ACTIVO ');
      
       V_SQL := '
        INSERT INTO /*+ APPEND */ '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO (GEE_ID, ACT_ID)
        SELECT REM01.S_GEE_GESTOR_ENTIDAD.NEXTVAL , ACT2.ACT_ID
        FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
		JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
		JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
		JOIN '||V_ESQUEMA||'.'||V_TABLA1||' GAC ON ACT.ACT_ID = GAC.ACT_ID
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO cargada. '||SQL%ROWCOUNT||' Filas.'); 
      
      COMMIT;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GEE_GESTOR_ENTIDAD ');
      
       V_SQL := '
        INSERT INTO /*+ APPEND */ REM01.GEE_GESTOR_ENTIDAD (GEE_ID, USU_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
        SELECT DISTINCT GAC1.GEE_ID , GEE.USU_ID, GEE.DD_TGE_ID, '''||V_USUARIO||''', SYSDATE
            FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
			JOIN '||V_ESQUEMA||'.'||V_TABLA1||' GAC ON ACT.ACT_ID = GAC.ACT_ID
			JOIN '||V_ESQUEMA||'.'||V_TABLA1||' GAC1 ON ACT2.ACT_ID = GAC1.ACT_ID
			JOIN '||V_ESQUEMA||'.'||V_TABLA||' GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.BORRADO = 0'
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD cargada. '||SQL%ROWCOUNT||' Filas.');     
      
    END IF;
    
    
      EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA1||' enable constraint FK_GESTORADDI_GESTORENTIDAD');



--------------------------------*******************************************************-------------------------------------------------------------------------



	EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA3||' disable constraint FK_GESTORADDI_GESTORENTIDADH');

      -------------------------------------------------
      --INSERCION EN GEH_GESTOR_ENTIDAD_HIST--
      -------------------------------------------------
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA2||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
    
            DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA GEE_GESTOR_ENTIDAD');
        
    ELSE 
      
            ------------------------------
      --INSERCION EN GAH_GESTOR_ACTIVO_HISTORICO--
      -------------------------------------------------
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GAH_GESTOR_ACTIVO_HISTORICO ');
      
       V_SQL := '
        INSERT INTO /*+ APPEND */ '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO (GEH_ID, ACT_ID)
        SELECT REM01.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL , ACT2.ACT_ID
        FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
		JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
		JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
		JOIN '||V_ESQUEMA||'.'||V_TABLA3||' GAC ON ACT.ACT_ID = GAC.ACT_ID
      '
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO cargada. '||SQL%ROWCOUNT||' Filas.'); 
      
      COMMIT;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] INSERCION EN GEH_GESTOR_ENTIDAD_HIST ');
      
       V_SQL := '
        INSERT INTO /*+ APPEND */ REM01.GEH_GESTOR_ENTIDAD_HIST (GEH_ID, USU_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
        SELECT DISTINCT GAH1.GEE_ID , GEH.USU_ID, GEH.DD_TGE_ID, '''||V_USUARIO||''', SYSDATE
            FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
			JOIN '||V_ESQUEMA||'.'||V_TABLA3||' GAH ON ACT.ACT_ID = GAH.ACT_ID
			JOIN '||V_ESQUEMA||'.'||V_TABLA3||' GAH1 ON ACT2.ACT_ID = GAH1.ACT_ID
			JOIN '||V_ESQUEMA||'.'||V_TABLA2||' GEH ON GEH.GEH_ID = GAH.GEH_ID AND GEH.BORRADO = 0'
      ;
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST cargada. '||SQL%ROWCOUNT||' Filas.');     
      
    END IF;
    
    
      EXECUTE IMMEDIATE ('alter table '||V_ESQUEMA||'.'||V_TABLA1||' enable constraint FK_GESTORADDI_GESTORENTIDADH');

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
