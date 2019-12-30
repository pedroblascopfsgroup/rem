--###########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6013
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar gastos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-6013';
    
BEGIN	
	
    V_NUM_TABLAS := 0;
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('	[INFO]: ACTUALIZAR GASTOS');


V_MSQL := ' MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
USING (

SELECT DISTINCT GPV.GPV_ID
FROM '||V_ESQUEMA||'.AUX_REMVIP_6013 AUX, '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV, '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG
WHERE 1 = 1
AND AUX.GPV_NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
AND GPV.DD_STG_ID = STG.DD_STG_ID
AND DD_STG_CODIGO = ''01''

) AUX
ON ( GIC.GPV_ID = AUX.GPV_ID )
WHEN MATCHED THEN UPDATE SET
GIC_CUENTA_CONTABLE = ''6310000000'',
USUARIOMODIFICAR = ''REMVIP-6013'',
FECHAMODIFICAR = SYSDATE

' ;


    --DBMS_OUTPUT.PUT_LINE(V_MSQL);        
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' GASTOS DE IBI ACTUALIZADOS ');  


V_MSQL := ' MERGE INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC
USING (

SELECT DISTINCT GPV.GPV_ID
FROM '||V_ESQUEMA||'.AUX_REMVIP_6013 AUX, '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV, '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG
WHERE 1 = 1
AND AUX.GPV_NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA
AND GPV.DD_STG_ID = STG.DD_STG_ID
AND DD_STG_CODIGO = ''92''

) AUX
ON ( GIC.GPV_ID = AUX.GPV_ID )
WHEN MATCHED THEN UPDATE SET
GIC_CUENTA_CONTABLE = ''6780000004'',
USUARIOMODIFICAR = ''REMVIP-6013'',
FECHAMODIFICAR = SYSDATE

' ;
				                       
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros');

    DBMS_OUTPUT.PUT_LINE('[FIN]');

  COMMIT;

EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;

/

EXIT
