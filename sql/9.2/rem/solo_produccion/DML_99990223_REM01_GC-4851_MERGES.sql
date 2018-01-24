--/*
--##########################################
--## AUTOR=Dean Ibañez Viño
--## FECHA_CREACION=20180124
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=GC-4815
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET TIMING ON
SET LINESIZE 2000
SET VERIFY OFF
SET FEEDBACK ON


DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_SQL VARCHAR2(4000 CHAR); -- Vble. con sentencia SQL a ejecutar		
	
    
BEGIN	


	DBMS_OUTPUT.PUT_LINE('[INFO] MERGEANDO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR');
    
    
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV USING(
                SELECT GPV_ID 
                FROM   '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                INNER JOIN '||V_ESQUEMA||'.TMP_GASTOS TMP ON 
                GPV.GPV_NUM_GASTO_HAYA = TMP.NUM_GASTO   AND
                GPV.GPV_NUM_GASTO_GESTORIA = TMP.NUM_FACTURA ) TMP
                ON (TMP.GPV_ID = GPV.GPV_ID)
                WHEN MATCHED THEN UPDATE
                SET GPV.dd_ega_id = (select dd_ega_id from '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO where dd_ega_codigo = ''03''),
                usuariomodificar = ''HREOS_3691'',
                fechamodificar = sysdate';
                
                
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADO: '||SQL%ROWCOUNT);
	
	DBMS_OUTPUT.PUT_LINE('[INFO] MERGEANDO '||V_ESQUEMA||'.GGE_GASTOS_GESTION');
    
	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GGE_GASTOS_GESTION GEE USING(
                SELECT GPV_ID 
                FROM   '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                INNER JOIN '||V_ESQUEMA||'.TMP_GASTOS TMP ON 
                GPV.GPV_NUM_GASTO_HAYA = TMP.NUM_GASTO   AND
                GPV.GPV_NUM_GASTO_GESTORIA = TMP.NUM_FACTURA ) TMP
                ON (TMP.GPV_ID = GEE.GPV_ID)
                WHEN MATCHED THEN UPDATE
                SET GEE.DD_EAH_ID = (select DD_EAH_ID from '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA where DD_EAH_CODIGO = ''03''),
                GGE_FECHA_EAH = SYSDATE,
                USU_ID_EAH = ( SELECT usu_id FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME =''eluque'') ,
                DD_EAP_ID = (select DD_EAP_ID from '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP where DD_EAP_CODIGO = ''01''),
                usuariomodificar = ''HREOS_3691'',
                fechamodificar = sysdate';
                
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADO: '||SQL%ROWCOUNT);

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