package es.pfsgroup.plugin.recovery.masivo.callbacks.redaccDem.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

public interface MSVRedaccDemCallbackApi {
	
	public static final String MSV_REDACC_DEM_CALLBACK_ONEND="es.pfsgroup.plugin.recovery.masivo.callbacks.redaccDem.api.MSVRedaccDemCallbackApi.onEndProcess";
	public static final String MSV_REDACC_DEM_CALLBACK_ONERROR="es.pfsgroup.plugin.recovery.masivo.callbacks.redaccDem.api.MSVRedaccDemCallbackApi.onError";
	public static final String MSV_REDACC_DEM_CALLBACK_ONSTART="es.pfsgroup.plugin.recovery.masivo.callbacks.redaccDem.api.MSVRedaccDemCallbackApi.onStart";
	public static final String MSV_REDACC_DEM_CALLBACK_ONSUCCESS="es.pfsgroup.plugin.recovery.masivo.callbacks.redaccDem.api.MSVRedaccDemCallbackApi.onSuccess";
	
	@BusinessOperationDefinition(MSV_REDACC_DEM_CALLBACK_ONEND)
	public abstract void onEndProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_REDACC_DEM_CALLBACK_ONERROR)
	public abstract void onError(Long tokenProceso, RecoveryBPMfwkInputDto input,
			String errorMessage);

	@BusinessOperationDefinition(MSV_REDACC_DEM_CALLBACK_ONSTART)
	public abstract void onStartProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_REDACC_DEM_CALLBACK_ONSUCCESS)
	public abstract void onSuccess(Long tokenProceso, RecoveryBPMfwkInputDto input);

}