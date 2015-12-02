package es.pfsgroup.procedimientos.creditosContingentes;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.cajamar.manager.BPMManager;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class CreditosContingentesLeaveActionHandler extends PROGenericLeaveActionHandler {

	private static final long serialVersionUID = 1L;

	@Autowired
	private BPMManager bpmManager;
	
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) 
	{
		TareaExterna tareaExterna = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> valores = camposTarea(tareaExterna);
		for(EXTTareaExternaValor valor : valores) {
			if(valor.getNombre().equals("fecha")) {
				String fechaSiguienteVencimiento = bpmManager.dameFechaSiguienteVencimientoCreditoContingente(valor.getValor(), tareaExterna.getTareaPadre().getProcedimiento().getId());
				setVariable("fechaSiguienteVencimiento", fechaSiguienteVencimiento, executionContext);
				break;
			}
		}		
		
		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
	}
	
	private List<EXTTareaExternaValor> camposTarea(TareaExterna tex) {
		return ((SubastaProcedimientoApi) proxyFactory
				.proxy(SubastaProcedimientoApi.class))
				.obtenerValoresTareaByTexId(tex.getId());
	}	
}
