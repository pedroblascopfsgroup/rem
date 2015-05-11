package es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions;

import es.capgemini.pfs.ruleengine.RuleExecutorConfig;

/**
 * Si el tipo de regla no está soportado.
 * 
 * @author bruno
 * 
 */
public class RuleDefinitionTypeNotSupportedException extends
		ExtendedRuleExecutorException {

	private static final long serialVersionUID = 7391632027480125509L;

	public RuleDefinitionTypeNotSupportedException(
			final RuleExecutorConfig config) {
		super(
				"'"
						+ config.getRuleDefinitionType()
						+ "': no es un tipo de definición de reglas soportado por elmomento.");
	}
}
