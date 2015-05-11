package es.pfsgroup.plugin.recovery.masivo.callbacks.redaccDem;

import es.pfsgroup.plugin.recovery.masivo.callbacks.redaccDem.api.MSVRedaccDemCallbackApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;

public class MSVRedaccDemBPMCallback implements RecoveryBPMfwkCallback{

	@Override
	public String onError() {
		return MSVRedaccDemCallbackApi.MSV_REDACC_DEM_CALLBACK_ONERROR;
	}

	@Override
	public String onProcessEnd() {
		return MSVRedaccDemCallbackApi.MSV_REDACC_DEM_CALLBACK_ONEND;
	}

	@Override
	public String onProcessStart() {
		return MSVRedaccDemCallbackApi.MSV_REDACC_DEM_CALLBACK_ONSTART;
	}

	@Override
	public String onSuccess() {
		
		return MSVRedaccDemCallbackApi.MSV_REDACC_DEM_CALLBACK_ONSUCCESS;
	}

}
