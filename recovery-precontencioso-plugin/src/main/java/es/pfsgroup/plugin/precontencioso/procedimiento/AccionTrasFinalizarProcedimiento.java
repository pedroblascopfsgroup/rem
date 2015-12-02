package es.pfsgroup.plugin.precontencioso.procedimiento;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.manager.ProcedimientoPcoManager;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDEstadoPreparacionPCO;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.AccionTomaDecision;

@Component
@Qualifier(AccionTomaDecision.ACCION_TRAS_FINALIZAR)
public class AccionTrasFinalizarProcedimiento implements AccionTomaDecision {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ProcedimientoPcoManager procedimientoPCOManager;
	
	@Override
	public void ejecutar(DecisionProcedimiento decisionProcedimiento, Procedimiento prc) {
		logger.debug("Finalizando procedimiento precontencioso");
		procedimientoPCOManager.cambiarEstadoExpediente(prc.getId(), DDEstadoPreparacionPCO.CANCELADO);
		logger.debug("Procedimiento precontencioso finalizado!!");
	}

}
