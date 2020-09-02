--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20200831
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7867
--## PRODUCTO=NO
--## 
--## Finalidad: Asignar SCOM cajamar
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

V_USUARIO VARCHAR2(200 CHAR);
PL_OUTPUT VARCHAR2(32000 CHAR);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de asignar gestores'); 

    DBMS_OUTPUT.PUT_LINE('	[INFO] Activos Immobiliarios'); 

	REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3('REMVIP-7867', PL_OUTPUT, NULL, NULL, '01' );

	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT); 

	PL_OUTPUT := '';

	DBMS_OUTPUT.PUT_LINE('	[INFO] Activos Financieros'); 

	REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3('REMVIP-7867', PL_OUTPUT, NULL, NULL, '02' );

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

