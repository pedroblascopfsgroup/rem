package es.pfsgroup.recovery.integration;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.integration.core.Message;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.Rule;

public class TypePayloadRegexRule<T extends TypePayload> implements Rule<T> {

	private Pattern tipo;
	
	public void setTipo(Pattern tipo) {
		this.tipo = tipo;
	}

	protected boolean match(Pattern pattern, String value) {
		Matcher matcher = pattern.matcher(value);
		return matcher.matches();
	}

	protected boolean isValidRule() {
		return (!Checks.esNulo(this.tipo));
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
		return true;
	}

}
