--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210428
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9582
--## PRODUCTO=NO
--## 
--## Finalidad: Insertar USU_ID de Gestor de activo edificación
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

	-- Variables
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9582';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);

	V_TABLA_GEE	VARCHAR2 (30 CHAR)	:= 'GEE_GESTOR_ENTIDAD';	
	V_TABLA_GAC	VARCHAR2 (30 CHAR)	:= 'GAC_GESTOR_ADD_ACTIVO';	
	V_TABLA_GEH	VARCHAR2 (30 CHAR)	:= 'GEH_GESTOR_ENTIDAD_HIST';	
	V_TABLA_GAH	VARCHAR2 (30 CHAR)	:= 'GAH_GESTOR_ACTIVO_HISTORICO';
   	
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR TABLA '||V_ESQUEMA||'.'||V_TABLA_GEE||'.');

	V_SQL := '
		MERGE INTO '||V_TABLA_GEE||' T1
			USING (
				SELECT DISTINCT GEH.USU_ID, GEE.GEE_ID FROM '||V_ESQUEMA||'.'||V_TABLA_GEH||' GEH
				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_GAH||' GAH ON GAH.GEH_ID = GEH.GEH_ID
				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_GAC||' GAC ON GAC.ACT_ID = GAH.ACT_ID
				INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_GEE||' GEE ON GEE.GEE_ID = GAC.GEE_ID
				WHERE GEH.DD_TGE_ID = 543 AND GEH.BORRADO = 0 AND GEE.USU_ID IS NULL AND GEE.BORRADO = 0
				) T2
			ON (T1.GEE_ID = T2.GEE_ID)
				WHEN MATCHED THEN UPDATE
			SET				
				T1.USU_ID = T2.USU_ID,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
				T1.FECHAMODIFICAR = SYSDATE';										
			
	EXECUTE IMMEDIATE V_SQL;
        
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');  
		
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
