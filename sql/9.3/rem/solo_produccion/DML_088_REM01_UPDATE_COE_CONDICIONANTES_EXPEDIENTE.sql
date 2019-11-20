--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20191017
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5340
--## PRODUCTO=NO
--##
--## Finalidad: Actualización campo COE_SOLICITA_RESERVA
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- Updatear los valores en ACT_ACTIVO -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN COE_CONDICIONANTES_EXPEDIENTE] ');
         
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: Modificamos el campo COE_CONDICIONANTES_EXPEDIENTE');
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE COE
						SET COE_SOLICITA_RESERVA = 0,
						USUARIOMODIFICAR = ''REMVIP-5340'',
						FECHAMODIFICAR = SYSDATE
						WHERE COE.ECO_ID IN (SELECT ECO_ID FROM ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE IN (SELECT ECO.ECO_NUM_EXPEDIENTE FROM REM01.OFR_OFERTAS OFR
						join rem01.eco_expediente_comercial eco on eco.ofr_id = ofr.ofr_id
						join rem01.act_ofr ao on ao.ofr_id = ofr.ofr_id
						join rem01.act_activo act on act.act_id = ao.act_id
						join rem01.dd_cra_cartera cra on cra.dd_cra_id = act.dd_cra_id
						join rem01.dd_scr_subcartera scr on scr.dd_scr_id = act.dd_scr_id
						left join REM01.COE_CONDICIONANTES_EXPEDIENTE coe on coe.eco_id = eco.eco_id
						join REM01.DD_EEC_EST_EXP_COMERCIAL eec on eec.dd_eec_id = eco.DD_EEC_ID
						join REM01.DD_EOF_ESTADOS_OFERTA eof on eof.dd_eof_id = ofr.dd_eof_id
						where cra.dd_cra_descripcion = ''Cerberus'' and scr.dd_scr_descripcion = ''Apple - Inmobiliario'' and coe.COE_SOLICITA_RESERVA is null))
						';
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' CONDICION ACTUALIZADO');
          
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE ACTUALIZADA CORRECTAMENTE');   

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