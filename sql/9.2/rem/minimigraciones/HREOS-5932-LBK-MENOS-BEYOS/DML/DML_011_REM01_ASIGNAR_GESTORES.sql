--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190327
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.9.0
--## INCIDENCIA_LINK=HREOS-5932
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
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(200 CHAR);
    PL_OUTPUT VARCHAR2(32000 CHAR);
    P_ACT_ID NUMBER;
    P_ALL_ACTIVOS NUMBER;

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de asignar gestores'); 

	DBMS_OUTPUT.PUT_LINE('	[INFO] Activos Immobiliarios'); 
	
	REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V5('HREOS-5932', PL_OUTPUT, NULL, NULL, '01' );
	
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT); 
	
	PL_OUTPUT := '';
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Activos Financieros'); 
	
	REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V5('HREOS-5932', PL_OUTPUT, NULL, NULL, '02' );
	
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT); 
	
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
EXIT
