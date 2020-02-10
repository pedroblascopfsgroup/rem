--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200208
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6211
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
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas.

    V_SQL VARCHAR2(4000 CHAR);
    V_NUM NUMBER(16);
    V_GEH_ID NUMBER(16);
    V_NUEVO_GEH NUMBER(16);    
    ----------------------------------
	TYPE CurTyp IS REF CURSOR;
	v_cursor    CurTyp;
    ----------------------------------

BEGIN					

-----------------------------------------------------------------------------------------------------------------
--Paso 1: Borra GAH:

	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de GAH_GESTOR_ACTIVO_HISTORICO');
	
	V_SQL := ' DELETE FROM REM01.GAH_GESTOR_ACTIVO_HISTORICO
		   WHERE GEH_ID IN ( SELECT GEH_ID FROM REM01.AUX_GAH_REMVIP_6211 ) ';
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados '||SQL%ROWCOUNT||' registros en GAH_GESTOR_ACTIVO_HISTORICO ');  


-----------------------------------------------------------------------------------------------------------------
--Paso 2: Borra GEH:

	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de GEH_GESTOR_ENTIDAD_HIST');
	
	V_SQL := ' DELETE FROM REM01.GEH_GESTOR_ENTIDAD_HIST
		   WHERE GEH_ID IN ( SELECT GEH_ID FROM REM01.AUX_GEH_REMVIP_6211 ) ';
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados '||SQL%ROWCOUNT||' registros en GEH_GESTOR_ENTIDAD_HIST ');


-----------------------------------------------------------------------------------------------------------------
--Paso 3: Borra GAC:

	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de GAC_GESTOR_ADD_ACTIVO');
	
	V_SQL := ' DELETE FROM REM01.GAC_GESTOR_ADD_ACTIVO
		   WHERE GEE_ID IN ( SELECT GEE_ID FROM REM01.AUX_GAC_REMVIP_6211 ) ';
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados '||SQL%ROWCOUNT||' registros en GAC_GESTOR_ADD_ACTIVO ');


-----------------------------------------------------------------------------------------------------------------
--Paso 4: Borra GEE:

	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de GEE_GESTOR_ENTIDAD');
	
	V_SQL := ' DELETE FROM REM01.GEE_GESTOR_ENTIDAD
		   WHERE GEE_ID IN ( SELECT GEE_ID FROM REM01.AUX_GEE_REMVIP_6211 ) ';
	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados '||SQL%ROWCOUNT||' registros en GEE_GESTOR_ENTIDAD ');


	DBMS_OUTPUT.PUT_LINE(' [INFO] Proceso realizado ');


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
