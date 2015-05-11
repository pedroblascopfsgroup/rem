package es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions;

import es.capgemini.pfs.batch.revisar.arquetipos.engine.ExtendedRuleExecutor;

/**
 * {@link ExtendedRuleExecutor} ha fallado.
 * @author bruno
 *
 */
public class ExtendedRuleExecutorException extends RuntimeException {

	public ExtendedRuleExecutorException() {
		super();
	}

	public ExtendedRuleExecutorException(String message, Throwable cause) {
		super(message, cause);
	}

	public ExtendedRuleExecutorException(String message) {
		super(message);
	}

	public ExtendedRuleExecutorException(Throwable cause) {
		super(cause);
	}

}
