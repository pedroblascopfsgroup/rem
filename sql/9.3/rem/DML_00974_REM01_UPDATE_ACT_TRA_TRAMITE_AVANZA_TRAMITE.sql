--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20220505
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17749
--## PRODUCTO=NO
--##
--## Finalidad: Avanzar trámite a tarea concreta
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
   
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error;
    PL_OUTPUT VARCHAR2(20000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_ECO_ID NUMBER(16,0);
    V_NUM_ECO NUMBER;
    V_COS_ID NUMBER(16,0);
    V_USUARIO VARCHAR2(25 CHAR) := 'HREOS-17749';
    V_ECO_NUM VARCHAR(50 CHAR); -- Vble. que almacena el num de expediente
    V_CONTADOR NUMBER(16,0) := 1;
    
    CURSOR EXPEDIENTES IS select distinct eco.eco_num_expediente
			from #ESQUEMA#.eco_expediente_comercial eco
			inner join #ESQUEMA#.act_ofr actofr on actofr.ofr_id = eco.ofr_id
			inner join #ESQUEMA#.ofr_ofertas ofr on ofr.ofr_id = actofr.ofr_id
			inner join #ESQUEMA#.act_activo act on act.act_id = actofr.act_id
			inner join #ESQUEMA#.act_tra_tramite atr on eco.tbj_id = atr.tbj_id
			inner join #ESQUEMA#.tac_tareas_activos tac on atr.tra_id = tac.tra_id
			inner join #ESQUEMA#.tar_tareas_notificaciones tar on tar.tar_id = tac.tar_id
			inner join #ESQUEMA#.tex_tarea_externa txt on txt.tar_id = tar.tar_id
			inner join #ESQUEMA#.tap_tarea_procedimiento tap on txt.tap_id = tap.tap_id 
			where tar.tar_tarea_finalizada in (0)
			and tap.tap_codigo in ('T017_PBCReserva')
			AND ofr.OFR_IMPORTE < 20000.00
			and act.dd_cra_id in (SELECT dd_cra_id FROM #ESQUEMA#.DD_CRA_CARTERA WHERE dd_cra_codigo = '07')
			and act.dd_scr_id in (SELECT dd_scr_id FROM #ESQUEMA#.DD_SCR_SUBCARTERA WHERE dd_scr_codigo IN ('138','150','70')); 

BEGIN

	FOR ECO IN EXPEDIENTES LOOP
	
		IF V_CONTADOR = 10 THEN
			COMMIT;
			V_CONTADOR := 1;
		ELSE
			V_ECO_NUM:=ECO.eco_num_expediente;
			DBMS_OUTPUT.PUT_LINE('[INFO]: AVANZAR TRAMITE DE EXPEDIENTE '||V_ECO_NUM);
			#ESQUEMA#.AVANCE_TRAMITE(V_USUARIO,V_ECO_NUM,'T017_InstruccionesReserva',null,null,PL_OUTPUT);
			DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
			DBMS_OUTPUT.PUT_LINE('[INFO]: Nº EXPEDIENTES AVANZADOS '||V_CONTADOR);
			V_CONTADOR := V_CONTADOR +1;
		END IF;
	END LOOP;
		DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' ACTUALIZADO');

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
