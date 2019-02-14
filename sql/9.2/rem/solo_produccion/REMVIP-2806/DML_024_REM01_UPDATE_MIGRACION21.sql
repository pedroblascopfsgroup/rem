--/*
--#########################################
--## AUTOR=Maria Presencia Herrero
--## FECHA_CREACION=20181119
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2806
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2806';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	
	V_TABLA1 VARCHAR2 (30 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
	V_TABLA2 VARCHAR2 (30 CHAR) := 'OFR_OFERTAS';
	V_TABLA3 VARCHAR2 (30 CHAR) := 'ACT_OFR';
	V_TABLA4 VARCHAR2 (30 CHAR) := 'ACT_SPS_SIT_POSESORIA';
	V_TABLA5 VARCHAR2 (30 CHAR) := 'DD_EEC_EST_EXP_COMERCIAL';
	V_TABLA6 VARCHAR2 (30 CHAR) := 'DD_SCM_SITUACION_COMERCIAL';
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_GALEON_2';


BEGIN
  
  ------------------------------------------------------------------------
  -----------	ACTUALIZAMOS LOS ACTIVOS DE CAJAMAR A VENDIDO	----------
  ------------------------------------------------------------------------
  
   
     V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' WHERE ACT_NUM_ACTIVO IN (SELECT ACT_NUM_ACTIVO_ANT FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||') AND DD_SCM_ID != (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''05'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM = 0  THEN
    
            DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS ACTIVOS DE CAJAMAR ESTAN VENDIDOS');
        
    ELSE 
		
		
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA1||' SET
					DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.'||V_TABLA5||' WHERE DD_EEC_CODIGO = ''08''),
					ECO_FECHA_CONT_PROPIETARIO = TRUNC(SYSDATE),
					ECO_ESTADO_PBC = 1,
					ECO_BLOQUEADO = 1,
					USUARIOMODIFICAR = '''||V_USUARIO||''', 
					FECHAMODIFICAR = SYSDATE
				WHERE OFR_ID IN (SELECT OFR.OFR_ID 
									FROM '||V_ESQUEMA||'.'||V_TABLA2||' OFR
									JOIN '||V_ESQUEMA||'.'||V_TABLA3||' ACF ON OFR.OFR_ID = ACF.OFR_ID
									JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT ON ACF.ACT_ID = ACT.ACT_ID
								WHERE ACT.ACT_ID IN (SELECT ACT_ID 
											FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' 
											WHERE ACT_NUM_ACTIVO IN (SELECT ACT_NUM_ACTIVO_ANT FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' ) 
											AND DD_SCM_ID != (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''05'')))
				 AND DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.'||V_TABLA5||' WHERE DD_EEC_CODIGO = ''06'')';
												
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ACTUALIZADAS. '||SQL%ROWCOUNT||' Filas.');
		COMMIT;

		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA4||' SET
					SPS_FECHA_TOMA_POSESION = TRUNC(SYSDATE),
					SPS_OCUPADO = 1,
					SPS_CON_TITULO = 1,
					USUARIOMODIFICAR = '''||V_USUARIO||''', 
					FECHAMODIFICAR = SYSDATE
				 WHERE ACT_ID IN (SELECT ACT_ID 
									FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' 
								WHERE ACT_NUM_ACTIVO IN (SELECT ACT_NUM_ACTIVO_ANT FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' ) 
								AND DD_SCM_ID != (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''05''))';
		  
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA ACTUALIZADAS. '||SQL%ROWCOUNT||' Filas.');
		COMMIT;

		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACT||' SET
					DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.'||V_TABLA6||' WHERE DD_SCM_CODIGO = ''05''),
					USUARIOMODIFICAR = '''||V_USUARIO||''', 
					FECHAMODIFICAR = SYSDATE
				 WHERE ACT_NUM_ACTIVO IN (SELECT ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' WHERE ACT_NUM_ACTIVO IN (SELECT ACT_NUM_ACTIVO_ANT FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||') 
								AND DD_SCM_ID != (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''05''))';
					  
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ACTIVO ACTUALIZADAS. '||SQL%ROWCOUNT||' Filas.');
		COMMIT;
    
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
