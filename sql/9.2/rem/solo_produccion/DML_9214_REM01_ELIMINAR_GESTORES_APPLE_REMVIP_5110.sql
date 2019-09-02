--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190823
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5110
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado de gestores Apple para volver a asignar
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

V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

V_TABLA1 VARCHAR2(40 CHAR) := 'AUX_GEE_REMVIP_5110';
V_TABLA2 VARCHAR2(40 CHAR) := 'AUX_GAC_REMVIP_5110';
V_TABLA3 VARCHAR2(40 CHAR) := 'AUX_GEH_REMVIP_5110';
V_TABLA4 VARCHAR2(40 CHAR) := 'AUX_GAH_REMVIP_5110';


V_USUARIO VARCHAR2(200 CHAR);
PL_OUTPUT VARCHAR2(32000 CHAR);
P_ACT_ID NUMBER;
P_ALL_ACTIVOS NUMBER;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL :=  'DELETE FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
                WHERE GAH.GEH_ID IN(
                SELECT GEH_ID FROM '||V_ESQUEMA||'.AUX_GEH_REMVIP_5110)';
                
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS DE  GAH_GESTOR_ACTIVO_HISTORICO'); 
    
    V_MSQL :=  'DELETE FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC
                WHERE GAC.GEE_ID IN(
                SELECT GEE_ID FROM '||V_ESQUEMA||'.AUX_GEE_REMVIP_5110)';
                
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS DE  GAC_GESTOR_ADD_ACTIVO'); 
    
    V_MSQL :=  'DELETE FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH 
                WHERE GEH.GEH_ID IN(
                SELECT GEH_ID FROM '||V_ESQUEMA||'.AUX_GEH_REMVIP_5110)';
                
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS DE  GEH_GESTOR_ENTIDAD_HIST'); 
    
    V_MSQL :=  'DELETE FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE 
                WHERE GEE.GEE_ID IN(
                SELECT GEE_ID FROM '||V_ESQUEMA||'.AUX_GEE_REMVIP_5110)';
                
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ELIMINADOS '||SQL%ROWCOUNT||' REGISTROS DE  GEE_GESTOR_ENTIDAD'); 
    
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN BORRADO GESTORES]');

    DBMS_OUTPUT.PUT_LINE('****************************');

    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de asignar gestores'); 

    DBMS_OUTPUT.PUT_LINE('	[INFO] Activos Immobiliarios'); 

	REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3('REMVIP-5110', PL_OUTPUT, NULL, NULL, '01' );

	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT); 

	PL_OUTPUT := '';

	DBMS_OUTPUT.PUT_LINE('	[INFO] Activos Financieros'); 

	REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3('REMVIP-5110', PL_OUTPUT, NULL, NULL, '02' );

	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT); 

	DBMS_OUTPUT.PUT_LINE('[FIN ASIGNACION GESTORES]');	

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

