package es.pfsgroup.plugin.rem.restclient.utils;

public class ConverterError extends RuntimeException {

	private static final long serialVersionUID = 3296103152386565377L;
	
	public ConverterError(String msg, Throwable e) {
		super(msg, e);
	}

	
	public ConverterError(Object dto, Throwable e) {
		super("Error al pasar a Map + [" + dto + "]", e);
	}


	public ConverterError(String string) {
		super(string);
	}


}
