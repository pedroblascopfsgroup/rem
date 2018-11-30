--/*
--##########################################
--## AUTOR=Javier Pons
--## FECHA_CREACION=20181130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-2476
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar varios num expediente y capital concedido
--## VERSIONES:
--## 0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(10000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TABLA VARCHAR2(40 CHAR) := 'FOR_FORMALIZACION';
    V_RES VARCHAR2(1000 CHAR); --Vble. auxiliar para el resultado de validación.   
    

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de modificación.');
    
		V_MSQL := 'SELECT FOR_NUMEXPEDIENTE 
							FROM '||V_ESQUEMA||'.'||V_TABLA||' FFF
							JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON FFF.ECO_ID = ECO.ECO_ID
							JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON ECO.OFR_ID = ACTO.OFR_ID
							JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACTO.ACT_ID = ACT.ACT_ID 
							WHERE ACT.ACT_NUM_ACTIVO = 6818326';

		EXECUTE IMMEDIATE V_MSQL INTO V_RES;

		DBMS_OUTPUT.PUT_LINE('[VALIDACION] Para ACT_ACTIVO = 6818326, NUM_EXPEDIENTE es '||V_RES||' Debería actualizarse a 2229585758 | 110.000,00');	

			EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.FOR_FORMALIZACION T1
										USING (
										SELECT DISTINCT FORR.FOR_ID,
														numero_haya,
														num_expediente,
														capital_concedido
										FROM '||V_ESQUEMA||'.AUX_JPR_FOR_FORMALIZACION AUX
										JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 
										ON ACT.ACT_NUM_ACTIVO = AUX.NUMERO_HAYA
										JOIN '||V_ESQUEMA||'.ACT_OFR AOF
										ON AOF.ACT_ID = ACT.ACT_ID
										JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
										ON OFR.OFR_ID = AOF.OFR_ID
										JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
										ON ECO.OFR_ID = OFR.OFR_ID
										JOIN '||V_ESQUEMA||'.FOR_FORMALIZACION FORR
										ON FORR.ECO_ID = ECO.ECO_ID
										) T2
										ON (T1.FOR_ID = T2.FOR_ID)
										WHEN MATCHED THEN UPDATE SET
										T1.FOR_NUMEXPEDIENTE = T2.num_expediente,
										T1.FOR_CAPITALCONCEDIDO = TO_NUMBER(REPLACE(REPLACE(T2.capital_concedido,''.'',''''),'','','''')),
										T1.USUARIOMODIFICAR = ''REMVIP-2476'',
										T1.FECHAMODIFICAR = SYSDATE';
				
    	
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO]'||SQL%ROWCOUNT||' Activos a los que actualizamos el num de expediente y el capital concedido.');  

		  V_MSQL := 'SELECT FOR_NUMEXPEDIENTE 
							FROM '||V_ESQUEMA||'.'||V_TABLA||' FFF
							JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON FFF.ECO_ID = ECO.ECO_ID
							JOIN '||V_ESQUEMA||'.ACT_OFR ACTO ON ECO.OFR_ID = ACTO.OFR_ID
							JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACTO.ACT_ID = ACT.ACT_ID 
							WHERE ACT.ACT_NUM_ACTIVO = 6818326';

		EXECUTE IMMEDIATE V_MSQL INTO V_RES;

		DBMS_OUTPUT.PUT_LINE('[VALIDACION] Para ACT_ACTIVO = 6818326, NUM_EXPEDIENTE es '||V_RES||'');	


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

EXIT;

