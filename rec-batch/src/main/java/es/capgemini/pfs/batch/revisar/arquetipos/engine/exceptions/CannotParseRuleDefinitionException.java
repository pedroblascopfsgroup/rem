package es.capgemini.pfs.batch.revisar.arquetipos.engine.exceptions;

public class CannotParseRuleDefinitionException extends RuntimeException {

	public CannotParseRuleDefinitionException() {
		super();
	}

	public CannotParseRuleDefinitionException(String message, Throwable cause) {
		super(message, cause);
	}

	public CannotParseRuleDefinitionException(String message) {
		super(message);
	}

	public CannotParseRuleDefinitionException(Throwable cause) {
		super(cause);
	}

	private static final long serialVersionUID = -5497832827598396414L;

}
