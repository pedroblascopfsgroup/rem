package es.pfsgroup.plugin.recovery.masivo.callbacks.admisionDemanda;

import es.pfsgroup.plugin.recovery.masivo.callbacks.admisionDemanda.api.MSVAdmisionDemandaCallbackApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;

public class MSVAdmisionDemandaBPMCallback implements RecoveryBPMfwkCallback{

	@Override
	public String onError() {
		return MSVAdmisionDemandaCallbackApi.MSV_ADMISION_DEMANDA_CALLBACK_ONERROR;
	}

	@Override
	public String onProcessEnd() {
		return MSVAdmisionDemandaCallbackApi.MSV_ADMISION_DEMANDA_CALLBACK_ONEND;
	}

	@Override
	public String onProcessStart() {
		return MSVAdmisionDemandaCallbackApi.MSV_ADMISION_DEMANDA_CALLBACK_ONSTART;
	}

	@Override
	public String onSuccess() {
		
		return MSVAdmisionDemandaCallbackApi.MSV_ADMISION_DEMANDA_CALLBACK_ONSUCCESS;
	}

}
