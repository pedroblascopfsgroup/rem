--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4455
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar estado de gastos
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-4455';    
    S_PVE NUMBER(16) := 0;  
   
   
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV USING (
									SELECT  distinct
										GPV.GPV_ID AS GPV_ID
									,   1 AS GPV_EXISTE_DOCUMENTO
									,   CASE WHEN GDE.GDE_FECHA_PAGO IS NOT NULL 
											AND NVL(GDE.GDE_INCLUIR_PAGO_PROVISION,0) = 0 
											AND (NVL(GDE.GDE_ANTICIPO,0) = 0 AND GDE.GDE_FECHA_ANTICIPO IS NULL)
										THEN
											(select DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'') 
										ELSE
											(select DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''01'') 
										END AS DD_EGA_ID
									,    ''apr_main_gr_documentos_gestoria'' AS USUARIOMODIFICAR
									,    sysdate AS FECHAMODIFICAR  
									FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
									JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
									JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID 
									JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON GPV.DD_EGA_ID = EGA.DD_EGA_ID   
									JOIN '||V_ESQUEMA||'.dgg_doc_ges_gastos DGG on gpv.gpv_id = dgg.gpv_id and dgg.VALIDO  = 1  and trunc(dgg.fechaenvio) = TO_DATE(''09/07/2019'',''DD/MM/YYYY'')
									JOIN '||V_ESQUEMA||'.dd_grf_gestoria_recep_fich grf on gpv.dd_grf_id = grf.dd_grf_id
									WHERE EGA.DD_EGA_CODIGO = ''12'')AUX
				ON (GPV.GPV_ID = AUX.GPV_ID)
				WHEN MATCHED THEN UPDATE SET
					GPV.GPV_EXISTE_DOCUMENTO = AUX.GPV_EXISTE_DOCUMENTO
				,   GPV.DD_EGA_ID = aux.DD_EGA_ID
				,   GPV.USUARIOMODIFICAR = AUX.USUARIOMODIFICAR
				,   GPV.FECHAMODIFICAR = AUX.FECHAMODIFICAR';
	
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');
	
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
