--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211203
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-16499
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
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16499';
V_SQL VARCHAR2(30000 CHAR) := '';
V_NUM NUMBER(25);

--Tablas AUX
V_TABLA_AUX VARCHAR2(30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
V_TABLA_AUX1 VARCHAR2(30 CHAR) := 'AUX_OFR_ID';
V_TABLA_AUX2 VARCHAR2(30 CHAR) := 'AUX_ECO_ID';
V_TABLA_AUX3 VARCHAR2(30 CHAR) := 'AUX_COM_ID';
V_TABLA_AUX4 VARCHAR2(30 CHAR) := 'AUX_GEH_ID';

--Tablas OFERTAS

V_TABLA_GEH VARCHAR2 (30 CHAR) := 'GEH_GESTOR_ENTIDAD_HIST';
V_TABLA_GCH VARCHAR2 (30 CHAR) := 'GCH_GESTOR_ECO_HISTORICO';
V_SENTENCIA VARCHAR2(2600 CHAR);


BEGIN

	--INSERT EN AUX_GEH_ID

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_GEH_ID (
				GEH_ID_VIEJO,
				GEH_ID_NUEVO
				)
				SELECT 

						GEH_ID_VIEJO,
						'||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL	GEH_ID_NUEVO

						FROM(
						SELECT DISTINCT
						GCH.GEH_ID AS GEH_ID_VIEJO
					
					FROM '||V_ESQUEMA||'.AUX_OFR_ID AUX_OFR_ID 
						JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON AUX_OFR_ID.OFR_ID_VIEJO = OFR.OFR_ID 
						JOIN '||V_ESQUEMA||'.AUX_OFR_ID AUX_OFR_ID ON AUX_OFR_ID.OFR_ID_VIEJO = OFR.OFR_ID
						JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO_EXP ON ECO_EXP.OFR_ID = OFR.OFR_ID
						JOIN '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO GCH ON GCH.ECO_ID = ECO_EXP.ECO_ID     
						JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GCH.GEH_ID)';

      EXECUTE IMMEDIATE V_SQL;


	
	--INSERT EN GEH_GESTOR_ENTIDAD_HIST

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST  (
				GEH_ID,
				USU_ID,
				DD_TGE_ID,
				GEH_FECHA_DESDE,
				GEH_FECHA_HASTA,
				VERSION,
				USUARIOCREAR,
				FECHACREAR,
				USUARIOMODIFICAR,
				FECHAMODIFICAR,
				USUARIOBORRAR,
				FECHABORRAR,
				BORRADO
				)
						
				SELECT DISTINCT
				AUX_GEH_ID.GEH_ID_NUEVO                 GEH_ID,
				GEH.USU_ID,
				GEH.DD_TGE_ID,
				GEH.GEH_FECHA_DESDE,
				GEH.GEH_FECHA_HASTA,
				''0''                                                    VERSION,
				''HREOS-16499''                                   	  USUARIOCREAR,
				SYSDATE                                                   FECHACREAR,
				NULL                                                      USUARIOMODIFICAR,
				NULL                                                      FECHAMODIFICAR,
				NULL                                                      USUARIOBORRAR,
				NULL                                                      FECHABORRAR,
				0                                                         BORRADO
				
				FROM '||V_ESQUEMA||'.AUX_OFR_ID AUX_OFR_ID 
				JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON AUX_OFR_ID.OFR_ID_VIEJO = OFR.OFR_ID  
				JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO_EXP ON ECO_EXP.OFR_ID = OFR.OFR_ID
				JOIN '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO GCH ON GCH.ECO_ID = ECO_EXP.ECO_ID
				JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GCH.GEH_ID  
				JOIN '||V_ESQUEMA||'.AUX_GEH_ID AUX_GEH_ID ON AUX_GEH_ID.GEH_ID_VIEJO = GEH.GEH_ID';

      EXECUTE IMMEDIATE V_SQL;


	--INSERT EN GCH_GESTOR_ECO_HISTORICO

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO  (
				GEH_ID,
				ECO_ID
					)			
					SELECT DISTINCT
					AUX_GEH_ID.GEH_ID_NUEVO                    GEH_ID,
					AUX_ECO_ID.ECO_ID_NUEVO                     ECO_ID
					
					FROM '||V_ESQUEMA||'.AUX_OFR_ID AUX_OFR_ID 
					JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON AUX_OFR_ID.OFR_ID_VIEJO = OFR.OFR_ID  
					JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO_EXP ON ECO_EXP.OFR_ID = OFR.OFR_ID
					JOIN '||V_ESQUEMA||'.GCH_GESTOR_ECO_HISTORICO GCH ON GCH.ECO_ID = ECO_EXP.ECO_ID
					JOIN '||V_ESQUEMA||'.AUX_ECO_ID AUX_ECO_ID ON AUX_ECO_ID.ECO_ID_VIEJO = ECO_EXP.ECO_ID
					JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GCH.GEH_ID  
					JOIN '||V_ESQUEMA||'.AUX_GEH_ID AUX_GEH_ID ON AUX_GEH_ID.GEH_ID_VIEJO = GEH.GEH_ID';

      EXECUTE IMMEDIATE V_SQL;
  
  COMMIT;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_GEH||''',''2''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_GCH||''',''2''); END;';
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
