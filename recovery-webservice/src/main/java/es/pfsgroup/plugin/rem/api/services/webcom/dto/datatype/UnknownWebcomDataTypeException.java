package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype;

public class UnknownWebcomDataTypeException extends Exception {

	private static final long serialVersionUID = -7180220484523061596L;
	private String customMsg;

	public UnknownWebcomDataTypeException(Class type) {
		this.customMsg = "Tipo de datos deconocido: " + type.getName();
	}

	@Override
	public String getMessage() {
		return customMsg;
	}

}
