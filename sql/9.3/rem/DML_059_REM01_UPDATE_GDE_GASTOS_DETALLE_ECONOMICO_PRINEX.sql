--/*
--###########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190923
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5108
--## PRODUCTO=NO
--## 
--## Finalidad: UPDATEAR GDE_GASTOS_DETALLE_ECONOMICO PARA GASTOS DE PRINEX
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-5108';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE
				USING (
				   SELECT * FROM (SELECT
				   GPV_ID,
				   GPL_DIARIO1,
				   GPL_DIARIO2,
				   CASE WHEN GPL_DIARIO1 = ''1'' OR GPL_DIARIO1 = ''20'' THEN GPL_DIARIO1_BASE ELSE 0 END AS PRINCIPAL_SUJETO,
				   CASE WHEN GPL_DIARIO1 = ''1'' OR GPL_DIARIO1 = ''20'' AND GPL_DIARIO2 = ''60'' THEN GPL_DIARIO2_BASE
				       WHEN GPL_DIARIO1 = ''2'' OR GPL_DIARIO1 = ''60'' AND GPL_DIARIO2 <> ''60'' THEN GPL_DIARIO1_BASE
				       WHEN GPL_DIARIO1 = ''2'' AND GPL_DIARIO2 = ''60'' THEN GPL_DIARIO1_BASE + GPL_DIARIO2_BASE
				       ELSE 0 END AS PRINCIPAL_NO_SUJETO,
				   CASE GPL_DIARIO1 WHEN ''60'' THEN 1 ELSE 0 END AS IMP_IND_EXENTO,
				   GPL_DIARIO1_TIPO AS IMP_IND_TIPO_IMPOSITIVO,
				   GPL_DIARIO1_CUOTA AS IMP_IND_CUOTA,
				   GPL_PROCENTAJE_IRPF AS IRPF_TIPO_IMPOSITIVO,
				   GPL_IMPORTE_IRPF AS IRPF_CUOTA,
				   ROW_NUMBER() OVER (PARTITION BY gpv_id ORDER BY act_id ASC) AS RN
				   FROM '||V_ESQUEMA||'.GPL_GASTOS_PRINEX_LBK WHERE GPV_ID = (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = 10834205) AND GPL_DIARIO1 IS NOT NULL AND BORRADO = 0) WHERE RN = 1) AUX ON (AUX.GPV_ID = GDE.GPV_ID)
				WHEN MATCHED THEN UPDATE SET GDE.GDE_PRINCIPAL_SUJETO = AUX.PRINCIPAL_SUJETO,
				                       GDE.GDE_PRINCIPAL_NO_SUJETO = AUX.PRINCIPAL_NO_SUJETO,
				                       GDE.DD_TIT_ID = 1,
				                       GDE.GDE_IMP_IND_EXENTO = AUX.IMP_IND_EXENTO,
				                       GDE.GDE_IMP_IND_TIPO_IMPOSITIVO = AUX.IMP_IND_TIPO_IMPOSITIVO,
				                       GDE.GDE_IMP_IND_CUOTA = AUX.IMP_IND_CUOTA,
				                       GDE.GDE_IRPF_TIPO_IMPOSITIVO = AUX.IRPF_TIPO_IMPOSITIVO,
				                       GDE.GDE_IRPF_CUOTA = AUX.IRPF_CUOTA,
				                       GDE.GDE_IMPORTE_TOTAL = (SELECT SUM(GPL_IMPORTE_GASTO) FROM '||V_ESQUEMA||'.GPL_GASTOS_PRINEX_LBK WHERE GPV_ID = AUX.GPV_ID),
				                       GDE.USUARIOMODIFICAR = ''REMVIP-5108'',
				                       GDE.FECHAMODIFICAR = SYSDATE';
				                       
	EXECUTE IMMEDIATE V_MSQL;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

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