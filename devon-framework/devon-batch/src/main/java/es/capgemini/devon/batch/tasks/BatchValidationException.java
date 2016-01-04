package es.capgemini.devon.batch.tasks;

import es.capgemini.devon.batch.BatchException;

/**
 * @author Juan Pablo Bosnjak
 */
public class BatchValidationException extends BatchException {

    private static final long serialVersionUID = 1L;

    private boolean imprimeTraza = true;

    private String originalkey;

    /**
	 * @return the originalkey
	 */
	public String getOriginalkey() {
		return originalkey;
	}

	/**
	 * @param originalkey the originalkey to set
	 */
	public void setOriginalkey(String originalkey) {
		this.originalkey = originalkey;
	}

	protected BatchValidationException() {
        super();
    }

    public BatchValidationException(String messageKey, Object... messageArgs) {
        super(messageKey, messageArgs);
        this.originalkey = messageKey;
    }

    public BatchValidationException(String messageKey, String severidad, int codigo, Object... messageArgs) {
        super(messageKey, codigo, severidad, messageArgs);
        this.originalkey = messageKey;
    }

    public BatchValidationException(Throwable cause) {
        super(cause);
    }

    public BatchValidationException(Throwable cause, String severidad, String messageKey) {
        super(cause, severidad, messageKey);
        this.originalkey = messageKey;
    }

    public BatchValidationException(Throwable cause, String messageKey, Object... messageArgs) {
        super(cause, messageKey, messageArgs);
        this.originalkey = messageKey;
    }

    public BatchValidationException(String messageKey, String severidad) {
        super(messageKey,  severidad);
        this.originalkey = messageKey;
    }

    public BatchValidationException(String messageKey, String severidad, boolean imprimeTraza) {
        super(messageKey,  severidad);
        this.imprimeTraza = imprimeTraza;
        this.originalkey = messageKey;
    }

    public BatchValidationException(String messageKey, String severidad, boolean imprimeTraza, Object... messageArgs) {
        super(messageKey,  severidad, messageArgs);
        this.imprimeTraza = imprimeTraza;
        this.originalkey = messageKey;
    }

	/**
	 * @return the imprimeTraza
	 */
	public boolean getImprimeTraza() {
		return imprimeTraza;
	}

	/**
	 * @param imprimeTraza the imprimeTraza to set
	 */
	public void setImprimeTraza(boolean imprimeTraza) {
		this.imprimeTraza = imprimeTraza;
	}

}
