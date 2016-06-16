package es.pfsgroup.plugin.precontencioso.handler;


import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class TramiteEnvioDemandaHandler extends PROBaseActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
			
	@Autowired
	private SubastaProcedimientoApi subastaProcedimientoApi;
	
	@Autowired
	private TareaExternaManager tareaExternaManager;

	@Override
	public void run(ExecutionContext executionContext) throws Exception {
		decision(executionContext);
	}

	private String decision(ExecutionContext executionContext) {
		Procedimiento prc = getProcedimiento(executionContext);
		
		List<TareaExterna> tareas = tareaExternaManager.obtenerTareasPorProcedimiento(prc.getId());
		
		String importeDemanda = "";
		String procIniciar = "";
		String partidoJudicial = "";
		
		for (TareaExterna tarea : tareas) {
			if (tarea.getTareaProcedimiento().getCodigo().contains("RedactarDemandaAdjuntarDocu")) {
				List<EXTTareaExternaValor> valores = subastaProcedimientoApi.obtenerValoresTareaByTexId(tarea.getId());
				for (EXTTareaExternaValor valor : valores) {
					if ("principal".equals(valor.getNombre())) {
						importeDemanda = valor.getValor();
					}
					else if ("proc_a_iniciar".equals(valor.getNombre())) {
						procIniciar = valor.getValor();
					}
					else if ("partidoJudicial".equals(valor.getNombre())) {
						partidoJudicial = valor.getValor();
					}
				}
				break;
			}
		}
		for (TareaExterna tarea : tareas) {
			if(tarea.getTareaProcedimiento().getCodigo().contains("ValidarAsignacion")){
				List<EXTTareaExternaValor> valores = subastaProcedimientoApi.obtenerValoresTareaByTexId(tarea.getId());
				for (EXTTareaExternaValor valor : valores) {
					if ("importeDemanda".equals(valor.getNombre())) {
						if(!importeDemanda.equals(valor.getValor())){
							/*executionContext.getToken().signal("nuevo");
							return "";*/
						}
					}
					else if ("proc_a_iniciar".equals(valor.getNombre())) {
						if(!procIniciar.equals(valor.getValor())){
							/*executionContext.getToken().signal("nuevo");
							return "";*/
						}
					}
					else if ("partidoJudicial".equals(valor.getNombre())) {
						if(!partidoJudicial.equals(valor.getValor())){
							/*executionContext.getToken().signal("nuevo");
							return "";*/
						}
					}
				}
				break;
			}
		}

		List<TareaExterna> tareasPadrePCO = tareaExternaManager.obtenerTareasPorProcedimiento(prc.getProcedimientoPadre().getId());
		
		for (TareaExterna tarea : tareasPadrePCO) {
			if (tarea.getTareaProcedimiento().getCodigo().contains("ValidarAsignacion")) {
				List<EXTTareaExternaValor> valores = subastaProcedimientoApi.obtenerValoresTareaByTexId(tarea.getId());
				for (EXTTareaExternaValor valor : valores) {
					if ("importeDemanda".equals(valor.getNombre())) {
						if(!importeDemanda.equals(valor.getValor())){
							/*executionContext.getToken().signal("nuevo");
							return "";*/
						}
					}
					else if ("proc_a_iniciar".equals(valor.getNombre())) {
						if(!procIniciar.equals(valor.getValor())){
							/*executionContext.getToken().signal("nuevo");
							return "";*/
						}
					}
					else if ("partidoJudicial".equals(valor.getNombre())) {
						if(!partidoJudicial.equals(valor.getValor())){
							/*executionContext.getToken().signal("nuevo");
							return "";*/
						}
					}
					break;
				}
			}
		}

		
		executionContext.getToken().signal("normal");
		return "";
	}

}