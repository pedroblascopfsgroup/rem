package es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarEJTdesdeFM.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

public interface MSVLanzarETJdesdeFMCallbackApi {
	
	public static final String MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONEND="es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarETJdesdeFM.MSVLanzarETJdesdeFMCallbackApi.onEndProcess";
	public static final String MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONERROR="es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarETJdesdeFM.MSVLanzarETJdesdeFMCallbackApi.onError";
	public static final String MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONSTART="es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarETJdesdeFM.MSVLanzarETJdesdeFMCallbackApi.onStart";
	public static final String MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONSUCCESS="es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarETJdesdeFM.MSVLanzarETJdesdeFMCallbackApi.onSuccess";
	
	@BusinessOperationDefinition(MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONEND)
	public abstract void onEndProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONERROR)
	public abstract void onError(Long tokenProceso, RecoveryBPMfwkInputDto input,
			String errorMessage);

	@BusinessOperationDefinition(MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONSTART)
	public abstract void onStartProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONSUCCESS)
	public abstract void onSuccess(Long tokenProceso, RecoveryBPMfwkInputDto input);

}