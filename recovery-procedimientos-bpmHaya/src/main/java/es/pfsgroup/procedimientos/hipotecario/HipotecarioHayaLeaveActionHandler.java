package es.pfsgroup.procedimientos.hipotecario;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.procedimientos.hipotecario.dto.ActualizarProcedimientoDto;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class HipotecarioHayaLeaveActionHandler extends PROGenericLeaveActionHandler {
	
	private static final long serialVersionUID = -8809466674007625934L;
	private static final String TAP_DEMANDA_CERTIFICACION_CARGAS = "DemandaCertificacionCargas";
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private JBPMProcessManager jbpmUtil;
	
	@Autowired
	private Executor executor;
	
	private ExecutionContext executionContext;
	
	
	protected void process(Object delegateTransitionClass,
			Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass,
				executionContext);
		this.executionContext = executionContext;

		Boolean tareaTemporal = (executionContext.getTransition().getName()
				.equals(BPMContants.TRANSICION_PARALIZAR_TAREAS) || executionContext
				.getTransition().getName()
				.equals(BPMContants.TRANSICION_ACTIVAR_TAREAS));
		if (!tareaTemporal) {
			Procedimiento procedimiento = getProcedimiento(executionContext);
			TareaExterna tareaExterna = getTareaExterna(executionContext);
			if (!Checks.esNulo(tareaExterna) && !Checks.esNulo(tareaExterna.getTareaProcedimiento())
					&& (!Checks.esNulo(tareaExterna.getTareaProcedimiento().getCodigo()) && 
					tareaExterna.getTareaProcedimiento().getCodigo().contains(TAP_DEMANDA_CERTIFICACION_CARGAS))) {
				
				actualizarProcedimiento(tareaExterna,procedimiento);
			}
		}
	}
	
	private void actualizarProcedimiento(TareaExterna tex, Procedimiento proc){
		
		@SuppressWarnings("unchecked")
		List<EXTTareaExternaValor> listadoValores = (List<EXTTareaExternaValor>)executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_VALORES_TAREA, tex.getId());
    	
		
		for (TareaExternaValor val : listadoValores) {

			if ("principalDeLaDemanda".equals(val.getNombre())) {
				if(!Checks.esNulo(val.getValor())){
					ActualizarProcedimientoDto dto = new ActualizarProcedimientoDto();
					try{
						dto.setId(proc.getId());
						dto.setPrincipal(new BigDecimal(val.getValor()));
						executor.execute("core.procedimiento.save",dto);
						logger.debug("actualizarProcedimiento - el procedimiento " + proc.getId() + " - " + proc.getNombreProcedimiento() + " se ha actualizado");
					}catch(NumberFormatException nfe){
						logger.warn("actualizarProcedimiento - El formato numerico del principal es incorrecto");
					}
				}
			}
		}
	}
}
