--/*
--#########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20190224
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3398
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3398';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_PAC VARCHAR2 (30 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO';



BEGIN
  
  ------------------------------------------------------------------------
  -----------	----------
  ------------------------------------------------------------------------
  
		DBMS_OUTPUT.PUT_LINE('[INFO] - SACAMOS DE PERIMETRO EL ACTIVO 6527616.');

    
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PAC||' SET
					PAC_INCLUIDO = 0,
					USUARIOMODIFICAR = '''||V_USUARIO||''', 
					FECHAMODIFICAR = SYSDATE
				 WHERE PAC_ID = (SELECT PAC_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT JOIN '||V_ESQUEMA||'.'||V_TABLA_PAC||' PAC ON PAC.ACT_ID = ACT.ACT_ID WHERE ACT_NUM_ACTIVO = 6527616)';
					  
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ACTIVO ACTUALIZADAS. '||SQL%ROWCOUNT||' Filas.');
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
