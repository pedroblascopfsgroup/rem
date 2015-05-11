package es.capgemini.pfs.batch.revisar.arquetipos.repo.exception;

import java.util.Map;

/**
 * 
 * @author bruno
 *
 */
public class CannotGetRuleEndState extends RuntimeException {

	public CannotGetRuleEndState(final Map<String, Object> record, final Throwable e) {
		super("No se ha podido obtener el RuleEndState a partir de " + record.toString(), e);
	}

	private static final long serialVersionUID = 7971444465803781759L;

}
