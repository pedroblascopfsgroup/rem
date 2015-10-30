package es.pfsgroup.recovery.integration.bpm;

import java.util.List;
import java.util.regex.Pattern;

import org.springframework.integration.core.Message;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.TypePayloadRegexRule;
import es.pfsgroup.recovery.integration.bpm.payload.DecisionProcedimientoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.ProcedimientoDerivadoPayload;

public class DecisionProcedimientoPayloadRegexRule extends TypePayloadRegexRule<DataContainerPayload> {

	private Pattern codigoTiposProcedimientoDerivados;
	private Boolean paralizar = false;
	private Boolean finalizar = false;
	
	public void setCodigoTiposProcedimientoDerivados(Pattern codigoTiposProcedimientoDerivados) {
		this.codigoTiposProcedimientoDerivados = codigoTiposProcedimientoDerivados;
	}


	public void setParalizar(Boolean paralizar) {
		this.paralizar = (paralizar!=null && paralizar);
	}

	public void setFinalizar(Boolean finalizar) {
		this.finalizar = (finalizar!=null && finalizar);
	}
	
	@Override
	protected boolean isValidRule() {
		return (super.isValidRule() 
				|| !Checks.esNulo(this.codigoTiposProcedimientoDerivados));
	}

	@Override
	public boolean check(Message<DataContainerPayload> message) {
		boolean padreValidado = super.check(message);
		if (!padreValidado) {
			return false;
		}
		DataContainerPayload payload = message.getPayload();
		DecisionProcedimientoPayload decisionProc = new DecisionProcedimientoPayload(payload);

		// comprueba los tipos de procedimientos a los que se está derivando
		List<ProcedimientoDerivadoPayload> procDerivados = decisionProc.getProcedimientoDerivado();
		if (!Checks.esNulo(codigoTiposProcedimientoDerivados) && procDerivados != null) {
			for (ProcedimientoDerivadoPayload prcDerivado : procDerivados) {
				boolean matches = match(codigoTiposProcedimientoDerivados, prcDerivado.getTipoProcedimiento());
				if (!matches) {
					return false;
				}
			}
		}
		if (!paralizar && decisionProc.getParalizada()) {
			return false;
		}
		if (!finalizar && decisionProc.getFinalizada()) {
			return false;
		}
		return true;
	}

}
