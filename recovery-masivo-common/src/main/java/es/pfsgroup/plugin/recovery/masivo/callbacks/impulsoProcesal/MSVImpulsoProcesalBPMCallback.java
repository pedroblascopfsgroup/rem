package es.pfsgroup.plugin.recovery.masivo.callbacks.impulsoProcesal;

import es.pfsgroup.plugin.recovery.masivo.callbacks.impulsoProcesal.api.MSVImpulsoProcesalCallbackApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;

public class MSVImpulsoProcesalBPMCallback implements RecoveryBPMfwkCallback{

	@Override
	public String onError() {
		return MSVImpulsoProcesalCallbackApi.MSV_IMPULSO_PROCESAL_CALLBACK_ONERROR;
	}

	@Override
	public String onProcessEnd() {
		return MSVImpulsoProcesalCallbackApi.MSV_IMPULSO_PROCESAL_CALLBACK_ONEND;
	}

	@Override
	public String onProcessStart() {
		return MSVImpulsoProcesalCallbackApi.MSV_IMPULSO_PROCESAL_CALLBACK_ONSTART;
	}

	@Override
	public String onSuccess() {
		
		return MSVImpulsoProcesalCallbackApi.MSV_IMPULSO_PROCESAL_CALLBACK_ONSUCCESS;
	}

}
