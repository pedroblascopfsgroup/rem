--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191231
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6111
--## PRODUCTO=NO
--## 
--## Finalidad:
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6111'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA_AUX VARCHAR( 100 CHAR ) := 'AUX_REMVIP_6111';
    V_COUNT NUMBER(16);	
    V_ID NUMBER(16);
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO IMPORTES DE PARTICIPACIÓN DE ACTIVOS EN OFERTAS');		

	V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_OFR T1
				USING (
					SELECT ACT.ACT_ID, OFR.OFR_ID, AUX.IMP_ACT_OFERTA, OFR.OFR_IMPORTE 
					FROM '|| V_ESQUEMA ||'.AUX_REMVIP_6111 AUX
					JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
					JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_NUM_EXPEDIENTE = AUX.ECO_NUM_EXPEDIENTE
					JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
				) T2
				ON (T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.ACT_OFR_IMPORTE = T2.IMP_ACT_OFERTA
					,T1.OFR_ACT_PORCEN_PARTICIPACION = (100 * (T2.IMP_ACT_OFERTA / T2.OFR_IMPORTE))
				WHERE T1.OFR_ID = T2.OFR_ID
	';
	
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de ACT_OFR');

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
