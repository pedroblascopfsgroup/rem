--/*
--#########################################
--## AUTOR=RLB
--## FECHA_CREACION=20190805
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-000
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-000';
    V_SQL VARCHAR2(4000 CHAR);


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] RELANZA DETECTOR ');
	

	EXECUTE IMMEDIATE 'delete from REM01.PWH_PROVEEDOR_WEBCOM_HIST where  TO_DATE(FECHA_ACCION, ''YYYY-MM-DD"T"HH24:MI:SS'') > TO_DATE(''2019/08/01'', ''yyyy/mm/dd'')';
	EXECUTE IMMEDIATE 'delete from REM01.AWH_AGRUP_ONV_WEBCOM_HIST where  TO_DATE(FECHA_ACCION, ''YYYY-MM-DD"T"HH24:MI:SS'') > TO_DATE(''2019/08/01'', ''yyyy/mm/dd'')';
	EXECUTE IMMEDIATE 'delete from REM01.CWH_CABEC_ONV_WEBCOM_HIST where  TO_DATE(FECHA_ACCION, ''YYYY-MM-DD"T"HH24:MI:SS'') > TO_DATE(''2019/08/01'', ''yyyy/mm/dd'')';
	EXECUTE IMMEDIATE 'delete from REM01.SWH_STOCK_ACT_WEBCOM_HIST where  TO_DATE(FECHA_ACCION, ''YYYY-MM-DD"T"HH24:MI:SS'') > TO_DATE(''2019/08/01'', ''yyyy/mm/dd'')';
	EXECUTE IMMEDIATE 'delete from REM01.OWH_OFERTAS_WEBCOM_HIST where  TO_DATE(FECHA_ACCION, ''YYYY-MM-DD"T"HH24:MI:SS'') > TO_DATE(''2019/08/01'', ''yyyy/mm/dd'')';
	EXECUTE IMMEDIATE 'delete from REM01.CWH_COMISIONES_WEBCOM_HIST where  TO_DATE(FECHA_ACCION, ''YYYY-MM-DD"T"HH24:MI:SS'') > TO_DATE(''2019/08/01'', ''yyyy/mm/dd'')';
	EXECUTE IMMEDIATE 'delete from REM01.IWH_INFORME_WEBCOM_HIST where  TO_DATE(FECHA_ACCION, ''YYYY-MM-DD"T"HH24:MI:SS'') > TO_DATE(''2019/08/01'', ''yyyy/mm/dd'')';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ok ');  

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
