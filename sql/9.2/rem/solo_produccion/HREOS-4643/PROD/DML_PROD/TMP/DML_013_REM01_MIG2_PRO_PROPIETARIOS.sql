--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_PRO_PROPIETARIO -> ACT_PRO_PROPIETARIO
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
V_USUARIO VARCHAR2(50 CHAR) := 'TRASPASO_TANGO';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PRO_PROPIETARIO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_PRO_PROPIETARIOS';
V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN

      --Inicio del proceso de volcado sobre ACT_PRO_PROPIETARIO
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
       V_SENTENCIA := '
		UPDATE '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO
		SET DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''02'')
			,PRO.USUARIOMODIFICAR = '''||V_USUARIO||'''
			,PRO.FECHAMODIFICAR = SYSDATE
		WHERE PRO.PRO_CODIGO_UVEM = 100000002
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_SENTENCIA := '
		UPDATE ACT_PRO_PROPIETARIO PRO
		SET DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''01'')
			,PRO.USUARIOMODIFICAR = '''||V_USUARIO||'''
			,PRO.FECHAMODIFICAR = SYSDATE
		WHERE PRO.USUARIOCREAR = ''MIG''
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;


    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO A NULO NIF A86602158 CARTERA CAJAMAR...');

    EXECUTE IMMEDIATE 'UPDATE ACT_PRO_PROPIETARIO
                          SET PRO_DOCIDENTIF = NULL
                       where PRO_DOCIDENTIF = ''A86602158''
                         and DD_CRA_ID = (select DD_CRA_ID FROM REM01.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''01'')';

    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO actualizada. '||SQL%ROWCOUNT||' Filas.');   


            
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
