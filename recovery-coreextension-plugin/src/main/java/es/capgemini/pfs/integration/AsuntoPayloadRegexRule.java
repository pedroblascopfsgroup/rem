package es.capgemini.pfs.integration;

import java.util.regex.Pattern;

import org.springframework.integration.core.Message;

import es.pfsgroup.commons.utils.Checks;

public class AsuntoPayloadRegexRule extends TypePayloadRegexRule<AsuntoPayload> {

	private Pattern codigoProcedimiento;
	private Pattern codigoTarea;
	
	public void setCodigoProcedimiento(Pattern codigoProcedimiento) {
		this.codigoProcedimiento = codigoProcedimiento;
	}

	public void setCodigoTarea(Pattern codigoTarea) {
		this.codigoTarea = codigoTarea;
	}

	@Override
	protected boolean isValidRule() {
		return (super.isValidRule() 
				|| !Checks.esNulo(this.codigoProcedimiento) 
				|| !Checks.esNulo(this.codigoTarea));
	}

	@Override
	public boolean check(Message<AsuntoPayload> message) {
		boolean padreValidado = super.check(message);
		if (!padreValidado) {
			return false;
		}
		AsuntoPayload payload = message.getPayload();
		if (!Checks.esNulo(codigoProcedimiento)) {
			boolean matches = match(codigoProcedimiento, payload.getCodigoProcedimiento());
			if (!matches) {
				return false;
			}
		}
		if (!Checks.esNulo(codigoTarea)) {
			boolean matches = match(codigoTarea, payload.getCodigoTAPTarea());
			if (!matches) {
				return false;
			}
		}
		return true;
	}

}
