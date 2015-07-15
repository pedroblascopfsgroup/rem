/*
--######################################################################################
--## Author: Roberto
--## Finalidad: Corregir Sprint 2
--## VERSIONES:
--##        0.1 Versión inicial
--######################################################################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
declare
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    /*
    * VARIABLES DEL SCRIPT
    *---------------------------------------------------------------------
    */    
    V_MSQL VARCHAR2(32000 CHAR);                        -- Sentencia a ejecutar 
        
begin
   
	--1. Desactivo algún trámite pendiente de desactivar

	update dd_tpo_tipo_procedimiento set borrado=1 where dd_tpo_codigo='P96';

	update dd_tpo_tipo_procedimiento set borrado=1 where dd_tpo_codigo='P31';

	update dd_tpo_tipo_procedimiento set borrado=1 where dd_tpo_codigo='P412';


	--desde el H035 debe apuntar al H023 y desde el H009 debe apuntar al H023

	update tap_tarea_procedimiento set dd_tpo_id_bpm=(SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='H023') where tap_codigo='H035_BPMtramiteDemandaIncidental';

	update tap_tarea_procedimiento set dd_tpo_id_bpm=(SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='H023') where tap_codigo='H009_BPMTramiteDemandaIncidental';



	--desde el H009 debe apuntar al H017
	update tap_tarea_procedimiento set dd_tpo_id_bpm=(SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='H017') where tap_codigo='H009_BPMTramiteFaseConvenioV4';



	--desde el H017 debe apuntar al H037, al H041 y al H033
	update tap_tarea_procedimiento set dd_tpo_id_bpm=(SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='H037') where tap_codigo='H017_BPMtramitePresentacionPropConvenio';

	update tap_tarea_procedimiento set dd_tpo_id_bpm=(SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='H041') where tap_codigo='H017_BPMTramiteSegCumplConvenio';

	update tap_tarea_procedimiento set dd_tpo_id_bpm=(SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='H033') where tap_codigo='H017_BPMTramiteFaseLiquidacion';



	--desde el H043 debe apuntar al H009
	update tap_tarea_procedimiento set dd_tpo_id_bpm=(SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='H009') where tap_codigo='H043_BPMtramiteFaseComunOrdinario';


	--Actualizo trámites antiguos para que puedan apuntar a los nuevos por si derivan en las pruebas
	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H023'
	)
	where tap_codigo='P62_BPMTramiteDemandaIncidental';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H009'
	)
	where tap_codigo='P94_BPMtramiteFaseComunOrdinario';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H009'
	)
	where tap_codigo='P94_BPMtramiteFaseComunAbreviado';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H026'
	)
	where tap_codigo='P420_BPMVerbal';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H018'
	)
	where tap_codigo='P420_BPMETJ';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H009'
	)
	where tap_codigo='P420_BPMFaseComunOrdinario';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H022'
	)
	where tap_codigo='P420_BPMMonitorio';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H001'
	)
	where tap_codigo='P420_BPMHipotecario';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H009'
	)
	where tap_codigo='P420_BPMFaseComunAbreviado';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H009'
	)
	where tap_codigo='P420_BPMOrdinario';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H020'
	)
	where tap_codigo='P420_BPMETNJ';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H021'
	)
	where tap_codigo='P420_BPMSolicitudConcurso';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H023'
	)
	where tap_codigo='P406_BPMTramiteDemandaIncidental';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H028'
	)
	where tap_codigo='P02_JBPMProcedimientoVerbalDesdeMonitorio';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H062'
	)
	where tap_codigo='P17_BPMVigilanciaCaducidadAnotacion';

	update tap_tarea_procedimiento
	set dd_tpo_id_bpm=(
	      select p2.dd_tpo_id
	      from dd_tpo_tipo_procedimiento p2
	      where p2.dd_tpo_codigo='H009'
	)
	where tap_codigo='P22_BPMtramiteFaseComun';
  
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
end;
/
EXIT;
