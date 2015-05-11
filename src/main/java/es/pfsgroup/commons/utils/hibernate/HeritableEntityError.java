package es.pfsgroup.commons.utils.hibernate;

public class HeritableEntityError extends RuntimeException {

	
	private static final long serialVersionUID = -6768650144681428893L;

	public HeritableEntityError() {
		super();
	}

	public HeritableEntityError(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

	public HeritableEntityError(String arg0) {
		super(arg0);
	}

	public HeritableEntityError(Throwable arg0) {
		super(arg0);
	}

}
