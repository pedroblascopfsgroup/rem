package es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO;

import es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.api.MSVProcedimientoBackOfficeCallbackApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;

public class MSVProcedimientoBackOfficeBPMCallback implements RecoveryBPMfwkCallback{

	@Override
	public String onError() {
		return MSVProcedimientoBackOfficeCallbackApi.MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONERROR;
	}

	@Override
	public String onProcessEnd() {
		return MSVProcedimientoBackOfficeCallbackApi.MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONEND;
	}

	@Override
	public String onProcessStart() {
		return MSVProcedimientoBackOfficeCallbackApi.MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONSTART;
	}

	@Override
	public String onSuccess() {
		
		return MSVProcedimientoBackOfficeCallbackApi.MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONSUCCESS;
	}

}
