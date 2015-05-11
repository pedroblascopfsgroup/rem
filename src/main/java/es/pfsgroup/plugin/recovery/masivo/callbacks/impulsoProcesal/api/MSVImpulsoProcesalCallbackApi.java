package es.pfsgroup.plugin.recovery.masivo.callbacks.impulsoProcesal.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

public interface MSVImpulsoProcesalCallbackApi {
	
	public static final String MSV_IMPULSO_PROCESAL_CALLBACK_ONEND="es.pfsgroup.plugin.recovery.masivo.callbacks.impulsoProcesal.MSVImpulsoProcesalCallbackApi.onEndProcess";
	public static final String MSV_IMPULSO_PROCESAL_CALLBACK_ONERROR="es.pfsgroup.plugin.recovery.masivo.callbacks.impulsoProcesal.MSVImpulsoProcesalCallbackApi.onError";
	public static final String MSV_IMPULSO_PROCESAL_CALLBACK_ONSTART="es.pfsgroup.plugin.recovery.masivo.callbacks.impulsoProcesal.MSVImpulsoProcesalCallbackApi.onStart";
	public static final String MSV_IMPULSO_PROCESAL_CALLBACK_ONSUCCESS="es.pfsgroup.plugin.recovery.masivo.callbacks.impulsoProcesal.MSVImpulsoProcesalCallbackApi.onSuccess";
	
	@BusinessOperationDefinition(MSV_IMPULSO_PROCESAL_CALLBACK_ONEND)
	public abstract void onEndProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_IMPULSO_PROCESAL_CALLBACK_ONERROR)
	public abstract void onError(Long tokenProceso, RecoveryBPMfwkInputDto input,
			String errorMessage);

	@BusinessOperationDefinition(MSV_IMPULSO_PROCESAL_CALLBACK_ONSTART)
	public abstract void onStartProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_IMPULSO_PROCESAL_CALLBACK_ONSUCCESS)
	public abstract void onSuccess(Long tokenProceso, RecoveryBPMfwkInputDto input);

}