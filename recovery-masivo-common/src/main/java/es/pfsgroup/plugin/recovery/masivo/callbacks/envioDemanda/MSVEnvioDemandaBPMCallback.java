package es.pfsgroup.plugin.recovery.masivo.callbacks.envioDemanda;

import es.pfsgroup.plugin.recovery.masivo.callbacks.envioDemanda.api.MSVEnvioDemandaCallbackApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;

public class MSVEnvioDemandaBPMCallback implements RecoveryBPMfwkCallback{

	@Override
	public String onError() {
		return MSVEnvioDemandaCallbackApi.MSV_ENVIO_DEMANDA_CALLBACK_ONERROR;
	}

	@Override
	public String onProcessEnd() {
		return MSVEnvioDemandaCallbackApi.MSV_ENVIO_DEMANDA_CALLBACK_ONEND;
	}

	@Override
	public String onProcessStart() {
		return MSVEnvioDemandaCallbackApi.MSV_ENVIO_DEMANDA_CALLBACK_ONSTART;
	}

	@Override
	public String onSuccess() {
		
		return MSVEnvioDemandaCallbackApi.MSV_ENVIO_DEMANDA_CALLBACK_ONSUCCESS;
	}

}
