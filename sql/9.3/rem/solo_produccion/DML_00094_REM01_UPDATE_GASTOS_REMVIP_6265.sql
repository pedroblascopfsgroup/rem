--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200204
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6265
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
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6265';
    V_SQL VARCHAR2(4000 CHAR);
    V_PRG_PROVISION_GASTOS NUMBER(16);   


BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Crear provisión 182515792 ');

	V_SQL := 'SELECT '||V_ESQUEMA||'.S_PRG_PROVISION_GASTOS.NEXTVAL
			  FROM DUAL 
			  WHERE 1 = 1 ';
	EXECUTE IMMEDIATE V_SQL INTO V_PRG_PROVISION_GASTOS;

										
	 V_SQL := 'INSERT INTO '||V_ESQUEMA||'.PRG_PROVISION_GASTOS
		   ( PRG_ID, PRG_NUM_PROVISION, DD_EPR_ID, PVE_ID_GESTORIA, PRG_FECHA_ALTA, PRG_FECHA_ENVIO, PRG_FECHA_RESPUESTA, VERSION, BORRADO, FECHACREAR, USUARIOCREAR )
		   VALUES
		   ( ' || V_PRG_PROVISION_GASTOS || ',
	       	     ''182515792'',
		     ( SELECT DD_EPR_ID FROM '||V_ESQUEMA||'.DD_EPR_ESTADOS_PROVISION_GASTO WHERE DD_EPR_CODIGO = ''07'' ),
		     ( SELECT PVE_ID_GESTORIA FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = ''11046596'' ),
		     TO_DATE( ''21/11/2019'', ''DD/MM/YYYY'' ),
		     TO_DATE( ''21/11/2019'', ''DD/MM/YYYY'' ),
		     TO_DATE( ''21/11/2019'', ''DD/MM/YYYY'' ),
		     0, 0,
		     SYSDATE,
		     ''REMVIP-6265''
		    )
		';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Creada '||SQL%ROWCOUNT||' provisión ');  


-----------------------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza gasto 11046596 ');
										
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
		   SET PRG_ID = ' || V_PRG_PROVISION_GASTOS || ',
		       DD_EGA_ID = ( SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'' ),
		       FECHAMODIFICAR = SYSDATE,
		       USUARIOMODIFICAR = ''REMVIP-6265''
		   WHERE GPV_NUM_GASTO_HAYA = ''11046596'' ';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GPV_GASTOS_PROVEEDOR ');  


-----------------------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualiza datos económicos del gasto 11046596 ');
										
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO
		   SET GDE_IMPORTE_PAGADO = GDE_IMPORTE_TOTAL,
		       GDE_FECHA_PAGO = TO_DATE( ''21/11/2019'', ''DD/MM/YYYY'' ),
		       FECHAMODIFICAR = SYSDATE,
		       USUARIOMODIFICAR = ''REMVIP-6265''
		   WHERE GPV_ID = ( SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = ''11046596'' ) ';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en GDE_GASTOS_DETALLE_ECONOMICO ');  


-----------------------------------------------------------------------------------------------------------------


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
