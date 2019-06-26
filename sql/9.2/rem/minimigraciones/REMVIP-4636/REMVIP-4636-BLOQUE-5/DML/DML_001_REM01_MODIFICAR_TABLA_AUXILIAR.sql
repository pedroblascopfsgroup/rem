--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190625
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.9.0
--## INCIDENCIA_LINK=REMVIP-4636
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
	V_MSQL VARCHAR2(5000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_COUNT NUMBER(16);
	
BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de modificar la tabla auxiliar ...'); 

	-- BORRADO DUPLICADOS 
	EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.AUX_HREOS_5932_PERIM 
				WHERE ROWID IN  (select ROWID from ( 
						    select ACT_NUM_ACTIVO , row_number() over (partition by ACT_NUM_ACTIVO order by ACT_NUM_ACTIVO desc) AS ORDEN 
						    from '||V_ESQUEMA||'.AUX_HREOS_5932_PERIM AUX )
						where ORDEN > 1
						)';
						
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han borrado '||SQL%ROWCOUNT||' registros. Motivo -> DUPLICADOS'); 

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
