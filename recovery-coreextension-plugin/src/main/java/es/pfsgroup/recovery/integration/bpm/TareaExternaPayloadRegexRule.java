package es.pfsgroup.recovery.integration.bpm;

import java.util.regex.Pattern;

import org.springframework.integration.core.Message;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.TypePayloadRegexRule;
import es.pfsgroup.recovery.integration.bpm.payload.TareaExternaPayload;

public class TareaExternaPayloadRegexRule extends TypePayloadRegexRule<DataContainerPayload> {

	private Pattern codigoProcedimiento;
	private Pattern codigoTarea;
	
	public void setCodigoProcedimiento(Pattern tipoProcedimiento) {
		this.codigoProcedimiento = tipoProcedimiento;
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
	public boolean check(Message<DataContainerPayload> message) {
		boolean padreValidado = super.check(message);
		if (!padreValidado) {
			return false;
		}
		DataContainerPayload payload = message.getPayload();
		TareaExternaPayload tex = new TareaExternaPayload(payload);
		if (!Checks.esNulo(codigoProcedimiento)) {
			boolean matches = match(codigoProcedimiento, tex.getProcedimiento().getTipoProcedimiento());
			if (!matches) {
				return false;
			}
		}
		if (!Checks.esNulo(codigoTarea)) {
			boolean matches = match(codigoTarea, tex.getCodigoTAPTarea());
			if (!matches) {
				return false;
			}
		}
		return true;
	}

}
