package es.pfsgroup.plugin.rem.api.services.webcom;

import java.util.ArrayList;
import java.util.List;

public class FaltanCamposObligatoriosException extends RuntimeException {

	private ArrayList<String> missingFields;

	public FaltanCamposObligatoriosException(ArrayList<String> missingFields) {
		super("Faltan campos obligatorios para invocar el WebService");
		this.missingFields = missingFields;
	}

	@Override
	public String getMessage() {
		StringBuilder msg = new StringBuilder(super.getMessage());
		if ((missingFields != null) && (! missingFields.isEmpty())){
			String separador = ": [";
			for (String f : missingFields){
				msg.append(separador).append(f);
				separador = ", ";
			}
			msg.append("]");
		}
		return msg.toString();
	}

	private static final long serialVersionUID = -1547175880208075313L;

	public List<String> getMissingFields() {
		return missingFields;
	}

}
