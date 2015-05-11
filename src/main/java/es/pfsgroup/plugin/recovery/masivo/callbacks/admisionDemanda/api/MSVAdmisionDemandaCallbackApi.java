package es.pfsgroup.plugin.recovery.masivo.callbacks.admisionDemanda.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

public interface MSVAdmisionDemandaCallbackApi {
	
	public static final String MSV_ADMISION_DEMANDA_CALLBACK_ONEND="es.pfsgroup.plugin.recovery.masivo.callbacks.admisionDemanda.MSVAdmisionDemandaCallbackApi.onEndProcess";
	public static final String MSV_ADMISION_DEMANDA_CALLBACK_ONERROR="es.pfsgroup.plugin.recovery.masivo.callbacks.admisionDemanda.MSVAdmisionDemandaCallbackApi.onError";
	public static final String MSV_ADMISION_DEMANDA_CALLBACK_ONSTART="es.pfsgroup.plugin.recovery.masivo.callbacks.admisionDemanda.MSVAdmisionDemandaCallbackApi.onStart";
	public static final String MSV_ADMISION_DEMANDA_CALLBACK_ONSUCCESS="es.pfsgroup.plugin.recovery.masivo.callbacks.admisionDemanda.MSVAdmisionDemandaCallbackApi.onSuccess";
	
	@BusinessOperationDefinition(MSV_ADMISION_DEMANDA_CALLBACK_ONEND)
	public abstract void onEndProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_ADMISION_DEMANDA_CALLBACK_ONERROR)
	public abstract void onError(Long tokenProceso, RecoveryBPMfwkInputDto input,
			String errorMessage);

	@BusinessOperationDefinition(MSV_ADMISION_DEMANDA_CALLBACK_ONSTART)
	public abstract void onStartProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_ADMISION_DEMANDA_CALLBACK_ONSUCCESS)
	public abstract void onSuccess(Long tokenProceso, RecoveryBPMfwkInputDto input);

}