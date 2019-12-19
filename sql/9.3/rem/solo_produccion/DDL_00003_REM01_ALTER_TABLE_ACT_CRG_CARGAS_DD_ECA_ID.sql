--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191008
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-0000
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar columna DD_ECA_ID
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
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-0000';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);


--Tabla TCC
V_TABLA VARCHAR2 (30 CHAR) := 'ACT_CRG_CARGAS';


BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL ALTER SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
   
	
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' DROP COLUMN DD_ECA_ID');

  
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
