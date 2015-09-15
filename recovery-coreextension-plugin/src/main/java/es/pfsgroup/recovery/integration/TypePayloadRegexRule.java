package es.pfsgroup.recovery.integration;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.integration.core.Message;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.Rule;

public class TypePayloadRegexRule<T extends TypePayload> implements Rule<T> {

	private Pattern tipo;
	private Pattern entidad;
	
	public void setTipo(Pattern tipo) {
		this.tipo = tipo;
	}

	public void setEntidad(Pattern entidad) {
		this.entidad = entidad;
	}

	protected boolean match(Pattern pattern, String value) {
		Matcher matcher = pattern.matcher(value);
		return matcher.matches();
	}

	protected boolean isValidRule() {
		return (!Checks.esNulo(this.tipo) || !Checks.esNulo(entidad));
	}
	
	@Override
	public boolean check(Message<T> message) {
		if (message==null || !this.isValidRule()) {
			return false;
		}
		TypePayload payload = message.getPayload();
		if (!Checks.esNulo(tipo)) { // comprueba este campo.
			boolean matches = match(tipo, payload.getTipo());
			if (!matches) {
				return false;
			}
		}
		if (!Checks.esNulo(entidad)) { // comprueba este campo.
			boolean matches = match(entidad, payload.getEntidad());
			if (!matches) {
				return false;
			}
		}
		return true;
	}

	public boolean checkHeaders(Message<T> message) {
		if (message==null || !this.isValidRule()) {
			return false;
		}
		if (!Checks.esNulo(tipo)) { // comprueba este campo.
			String tipoHeader = (message.getHeaders().containsKey(TypePayload.HEADER_MSG_TYPE)) ? (String)message.getHeaders().get(TypePayload.HEADER_MSG_TYPE) : "";
			boolean matches = match(tipo, tipoHeader);
			if (!matches) {
				return false;
			}
		}
		if (!Checks.esNulo(entidad)) { // comprueba este campo.
			String entidadHeader = (message.getHeaders().containsKey(TypePayload.HEADER_MSG_TYPE)) ? (String)message.getHeaders().get(TypePayload.HEADER_MSG_ENTIDAD) : "";
			boolean matches = match(entidad, entidadHeader);
			if (!matches) {
				return false;
			}
		}
		return true;
	}
	
}
