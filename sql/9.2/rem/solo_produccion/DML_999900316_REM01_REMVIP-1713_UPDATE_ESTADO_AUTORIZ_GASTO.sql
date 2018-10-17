--/*
--##########################################
--## AUTOR=Ivan Castelló Cabrelles
--## FECHA_CREACION=20180905
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1713
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar el DD_EAH_ID gastos
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_EXISTS NUMBER(10);


BEGIN


	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
    
    --UPDATEAMOS       
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE
				USING (   
				        SELECT GPV.GPV_ID
				        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				            JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE           ON GGE.GPV_ID = GPV.GPV_ID
				            JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO DD          ON GPV.DD_EGA_ID = DD.DD_EGA_ID
				            JOIN '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH  ON EAH.DD_EAH_ID = GGE.DD_EAH_ID 
				        WHERE GPV.GPV_NUM_GASTO_HAYA IN (10013070,10013071)
				       ) ORIGEN
				ON (GGE.GPV_ID = ORIGEN.GPV_ID)
				WHEN MATCHED THEN
				UPDATE SET GGE.DD_EAH_ID = (SELECT DD_EAH_ID FROM '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA WHERE DD_EAH_CODIGO = ''03''),
				           GGE.USUARIOMODIFICAR = ''REMVIP-1713'',
				           GGE.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;  


    DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros en GPV_GASTOS_PROVEEDOR');    
    
    
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('KO no modificada');
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        ROLLBACK;
        RAISE;          
END;
/
EXIT
