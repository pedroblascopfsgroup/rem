package es.pfsgroup.recovery.integration.bpm;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;

import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.model.Asunto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.TypePayloadRegexRule;
import es.pfsgroup.recovery.integration.bpm.payload.FinAsuntoPayload;

public class FinAsuntoPayloadRegexRule extends TypePayloadRegexRule<DataContainerPayload> {

	@Autowired
    private EXTAsuntoManager extAsuntoManager;

	@Override
	protected boolean isValidRule() {
		return super.isValidRule();
	}

	@Override
	public boolean check(Message<DataContainerPayload> message) {
		boolean padreValidado = super.check(message);
		if (!padreValidado) {
			return false;
		}
		DataContainerPayload payload = message.getPayload();
		FinAsuntoPayload finAsuntoPayload = new FinAsuntoPayload(payload);

		// Se comprueba si existe el asunto
		String asuUUID = finAsuntoPayload.getAsunto().getGuid();
		Asunto asu = extAsuntoManager.getAsuntoByGuid(asuUUID);

		return !Checks.esNulo(asu);
	}
}
