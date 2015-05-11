package es.pfsgroup.plugin.recovery.masivo.callbacks.presentacionDemanda;

import es.pfsgroup.plugin.recovery.masivo.callbacks.presentacionDemanda.api.MSVPresentacionDemandaCallbackApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;

public class MSVPresentacionDemandaBPMCallback implements RecoveryBPMfwkCallback{

	@Override
	public String onError() {
		return MSVPresentacionDemandaCallbackApi.MSV_PRESENTACION_DEMANDA_CALLBACK_ONERROR;
	}

	@Override
	public String onProcessEnd() {
		return MSVPresentacionDemandaCallbackApi.MSV_PRESENTACION_DEMANDA_CALLBACK_ONEND;
	}

	@Override
	public String onProcessStart() {
		return MSVPresentacionDemandaCallbackApi.MSV_PRESENTACION_DEMANDA_CALLBACK_ONSTART;
	}

	@Override
	public String onSuccess() {
		
		return MSVPresentacionDemandaCallbackApi.MSV_PRESENTACION_DEMANDA_CALLBACK_ONSUCCESS;
	}

}
