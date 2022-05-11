--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220511
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-17849
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
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-17849';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);


--Tabla ACTIVOS
V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_GCP_GESTION_CCPP';
V_TABLA_ACT_GCP VARCHAR2 (30 CHAR) := 'ACT_GCP_GESTION_CCPP';
V_SENTENCIA VARCHAR2(2600 CHAR);


BEGIN




	--BORRADO LOGICO EN ACT_GCP_GESTION_CCPP
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_ACT_GCP||'
				  SET BORRADO = 1,
				  USUARIOBORRAR = '''||V_USUARIO||''',
				  FECHABORRAR = SYSDATE
				  WHERE BORRADO = 0';
      EXECUTE IMMEDIATE V_SQL;



  
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
