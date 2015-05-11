package es.pfsgroup.plugin.recovery.mejoras.historicoProcedimiento;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.registro.HistoricoProcedimientoApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.HistoricoAsuntoAbrirDetalleHandler;

@Component
public class HistoricoAsuntoAbrirDetalleTareaProcedimiento implements
		HistoricoAsuntoAbrirDetalleHandler {

	@Autowired
	private Executor executor;
	@Override
	public String getJspName() {
		return "plugin/mejoras/generico/genericForm";
	}

	@Override
	public Object getViewData(Long idTarea, Long idTraza, Long idEntidad) {
		//executor.execute('tareaNotificacionManager.get',id)
		
		Map<String,Object> res= new HashMap<String,Object>();
		TareaNotificacion tarea = (TareaNotificacion) executor.execute("tareaNotificacionManager.get",idEntidad);

		if(tarea == null){
			TareaExterna tax = (TareaExterna)executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_GET,idEntidad);
			tarea = tax.getTareaPadre();
		}
		Long idTareaExterna = tarea.getTareaExterna().getId();
		Long idProcedimiento = tarea.getProcedimiento().getId();
		
		GenericForm genericForm = (GenericForm) executor.execute("genericFormManager.get",idTareaExterna);
		Map<String, Map<String, String>> valores = (Map<String, Map<String, String>>) executor.execute("genericFormManager.getValoresTareas",idProcedimiento);
		
		res.put("form", genericForm);
		res.put("valores", valores);
		res.put("isConsulta",true);
		res.put("readOnly",true);
		return res;
	}
	
	@Override
	public String getValidString() {
		return HistoricoProcedimientoApi.TIPO_TAREA_PROCEDIMIENTO;
	}

	public void setExecutor(Executor executor) {
		this.executor = executor;
	}

	public Executor getExecutor() {
		return executor;
	}

	

}
