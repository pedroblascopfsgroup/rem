--/*
--#########################################
--## AUTOR=vIOREL rEMUS oiVIDIU
--## FECHA_CREACION=20201215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8512
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar gastos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE

    -- Ejecutar
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    -- Esquemas 
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    -- Errores
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    -- Usuario
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP_8512';
    -- ID
    V_GASTO_ID NUMBER(16); -- Vble. para el id del activo
    -- Tablas
    V_TABLA_GASTOS VARCHAR2(50 CHAR):= 'GPV_GASTOS_PROVEEDOR';
    V_TABLA_PROVISION VARCHAR2(50 CHAR):= 'PRG_PROVISION_GASTOS';
    V_TABLA_DETALLE VARCHAR2(50 CHAR):= 'GDE_GASTOS_DETALLE_ECONOMICO';
    -- Contador
	V_COUNT NUMBER(16); -- Vble. para comprobar
    

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR GASTOS');
    
    	V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'|| V_TABLA_GASTOS ||' T1 USING 
			(select GPV.GPV_ID
			from REM01.gpv_gastos_proveedor gpv 
			inner join rem01.aux_remvip_8512 aux on aux.num_gasto_rem = gpv.gpv_num_gasto_haya) T2
		ON (T1.GPV_ID = T2.GPV_ID)
		WHEN MATCHED THEN UPDATE SET 
			T1.DD_EGA_ID = (SELECT DD_EGA_ID FROM REM01.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05''),
			T1.USUARIOMODIFICAR = ''REMVIP-8512'',
			T1.FECHAMODIFICAR = SYSDATE ';

		EXECUTE IMMEDIATE V_MSQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   
	
	V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.'|| V_TABLA_DETALLE ||' T1 USING 
			(select GDE.GDE_ID, AUX.FECHA_PAGADO
			from REM01.gde_gastos_detalle_economico gde 
			inner join REM01.gpv_gastos_proveedor gpv on gpv.gpv_id = gde.gpv_id 
			inner join rem01.aux_remvip_8512 aux on aux.num_gasto_rem = gpv.gpv_num_gasto_haya) T2
		ON (T1.GDE_ID = T2.GDE_ID)
		WHEN MATCHED THEN UPDATE SET 
			T1.GDE_FECHA_PAGO = TO_DATE(T2.FECHA_PAGADO,''DD/MM/YYYY''),
			T1.USUARIOMODIFICAR = ''REMVIP-8512'',
			T1.FECHAMODIFICAR = SYSDATE ';

		EXECUTE IMMEDIATE V_MSQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   


    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
