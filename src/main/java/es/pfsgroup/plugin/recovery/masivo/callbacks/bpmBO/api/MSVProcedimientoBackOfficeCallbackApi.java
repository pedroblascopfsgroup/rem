package es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

public interface MSVProcedimientoBackOfficeCallbackApi {
	
	public static final String MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONEND="es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.MSVProcedimientoBackOfficeCallbackApi.onEndProcess";
	public static final String MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONERROR="es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.MSVProcedimientoBackOfficeCallbackApi.onError";
	public static final String MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONSTART="es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.MSVProcedimientoBackOfficeCallbackApi.onStart";
	public static final String MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONSUCCESS="es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.MSVProcedimientoBackOfficeCallbackApi.onSuccess";
	
	@BusinessOperationDefinition(MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONEND)
	public abstract void onEndProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONERROR)
	public abstract void onError(Long tokenProceso, RecoveryBPMfwkInputDto input,
			String errorMessage);

	@BusinessOperationDefinition(MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONSTART)
	public abstract void onStartProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_PROCEDIMIENTO_BACK_OFFICE_CALLBACK_ONSUCCESS)
	public abstract void onSuccess(Long tokenProceso, RecoveryBPMfwkInputDto input);

}