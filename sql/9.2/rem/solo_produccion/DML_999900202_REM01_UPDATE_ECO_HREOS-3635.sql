--/*
--##########################################
--## AUTOR=RAMON LLINARES
--## FECHA_CREACION=20180111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3635
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza el estado de un eco y una reserva
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
   
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] PROCESO DE ACTUALIZACIÓN');
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET DD_EEC_ID = (SELECT DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''06'') 
					  WHERE ECO_ID = (SELECT ECO.ECO_ID FROM ECO_EXPEDIENTE_COMERCIAL ECO WHERE ECO.OFR_ID = (SELECT OFR_ID FROM OFR_OFERTAS OFR WHERE OFR.OFR_NUM_OFERTA = 73318211))';
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS EN ECO_EXPEDIENTE_COMERCIAL');
		
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS SET DD_ERE_ID = (SELECT DD_ERE_ID FROM DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = ''02'') 
					  WHERE ECO_ID = (SELECT ECO.ECO_ID FROM ECO_EXPEDIENTE_COMERCIAL ECO WHERE ECO.OFR_ID = (SELECT OFR_ID FROM OFR_OFERTAS OFR WHERE OFR.OFR_NUM_OFERTA = 73318211))';
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' REGISTROS EN RES_RESERVAS');

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
