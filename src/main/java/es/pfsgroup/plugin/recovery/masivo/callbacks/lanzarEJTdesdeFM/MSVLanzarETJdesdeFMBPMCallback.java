package es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarEJTdesdeFM;

import es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarEJTdesdeFM.api.MSVLanzarETJdesdeFMCallbackApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;

public class MSVLanzarETJdesdeFMBPMCallback implements RecoveryBPMfwkCallback{

	@Override
	public String onError() {
		return MSVLanzarETJdesdeFMCallbackApi.MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONERROR;
	}

	@Override
	public String onProcessEnd() {
		return MSVLanzarETJdesdeFMCallbackApi.MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONEND;
	}

	@Override
	public String onProcessStart() {
		return MSVLanzarETJdesdeFMCallbackApi.MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONSTART;
	}

	@Override
	public String onSuccess() {
		
		return MSVLanzarETJdesdeFMCallbackApi.MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONSUCCESS;
	}

}
