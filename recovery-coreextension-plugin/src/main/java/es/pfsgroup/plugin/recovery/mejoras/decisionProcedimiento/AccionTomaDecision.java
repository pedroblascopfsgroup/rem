package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;

public interface AccionTomaDecision {

	public static final String ACCION_TRAS_FINALIZAR = "accionAdicionalTomaDecisionFinProcedimiento";
	public static final String ACCION_TRAS_PARALIZAR = "accionAdicionalTomaDecisionParalizarProcedimiento";
	public static final String ACCION_TRAS_DESPARALIZAR = "accionTrasDesparalizarProcedimiento";

	/**
	 * Ejecuta la acción.
	 * 
	 * @param decisionProcedimiento
	 * @param prc
	 */
	void ejecutar(DecisionProcedimiento decisionProcedimiento, Procedimiento prc);
	
}
