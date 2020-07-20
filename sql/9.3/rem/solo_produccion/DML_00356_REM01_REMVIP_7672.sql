--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200713
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7783
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-7783'; -- Vble. para el usuario modificar.
    V_MSQL VARCHAR2(32000 CHAR); -- Vble. auxiliar para almacenar la sentencia a ejecutar.
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO T1
				USING (
				    SELECT GPV.GPV_ID, GPV.GPV_NUM_GASTO_HAYA,
				        TO_DATE(TMP.FC_TOPE_PAGO, ''MM/DD/YY'') AS FC_TOPE_PAGO
				    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				    JOIN REM_EXT.TMP_GASTOS_13072020 TMP ON TMP.ID_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
				) T2
				ON (T1.GPV_ID = T2.GPV_ID)
				WHEN MATCHED THEN UPDATE SET
				    T1.GDE_FECHA_TOPE_PAGO = T2.FC_TOPE_PAGO
				    ,USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
				    ,FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');

    DBMS_OUTPUT.PUT_LINE('[FIN]');
    COMMIT;
 
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
