--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20200819
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7973
--## PRODUCTO=NO
--## 
--## Finalidad: Modificar los gastos 10910251/10908324 a pagados con fecha de pago 15/10/2019
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIO VARCHAR2(100 CHAR):= 'REMVIP-7973';
    V_SQL VARCHAR2(4000 CHAR); 


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza gasto 10910251 ');
										
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
		   SET DD_EGA_ID = ( SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'' ),
		       FECHAMODIFICAR = SYSDATE,
		       USUARIOMODIFICAR = '''||V_USUARIO||'''
		   WHERE GPV_NUM_GASTO_HAYA = ''10910251'' ';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GPV_GASTOS_PROVEEDOR ');  


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza datos económicos del gasto 10910251 ');
										
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO
		   SET GDE_IMPORTE_PAGADO = GDE_IMPORTE_TOTAL,
		       GDE_FECHA_PAGO = TO_DATE( ''15/10/2019'', ''DD/MM/YYYY'' ),
		       FECHAMODIFICAR = SYSDATE,
		       USUARIOMODIFICAR = '''||V_USUARIO||'''
		   WHERE GPV_ID = ( SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = ''10910251'' ) ';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GDE_GASTOS_DETALLE_ECONOMICO ');  


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza gasto 10908324 ');
										
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
		   SET DD_EGA_ID = ( SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'' ),
		       FECHAMODIFICAR = SYSDATE,
		       USUARIOMODIFICAR = '''||V_USUARIO||'''
		   WHERE GPV_NUM_GASTO_HAYA = ''10908324'' ';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GPV_GASTOS_PROVEEDOR ');  


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza datos económicos del gasto 10908324 ');
										
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO
		   SET GDE_IMPORTE_PAGADO = GDE_IMPORTE_TOTAL,
		       GDE_FECHA_PAGO = TO_DATE( ''15/10/2019'', ''DD/MM/YYYY'' ),
		       FECHAMODIFICAR = SYSDATE,
		       USUARIOMODIFICAR = '''||V_USUARIO||'''
		   WHERE GPV_ID = ( SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = ''10908324'' ) ';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GDE_GASTOS_DETALLE_ECONOMICO ');  


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
