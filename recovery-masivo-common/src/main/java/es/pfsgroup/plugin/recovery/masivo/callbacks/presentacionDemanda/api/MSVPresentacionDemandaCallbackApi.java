package es.pfsgroup.plugin.recovery.masivo.callbacks.presentacionDemanda.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

public interface MSVPresentacionDemandaCallbackApi {
	
	public static final String MSV_PRESENTACION_DEMANDA_CALLBACK_ONEND="es.pfsgroup.plugin.recovery.masivo.callbacks.presentacionDemanda.MSVPresentacionDemandaCallbackApi.onEndProcess";
	public static final String MSV_PRESENTACION_DEMANDA_CALLBACK_ONERROR="es.pfsgroup.plugin.recovery.masivo.callbacks.presentacionDemanda.MSVPresentacionDemandaCallbackApi.onError";
	public static final String MSV_PRESENTACION_DEMANDA_CALLBACK_ONSTART="es.pfsgroup.plugin.recovery.masivo.callbacks.presentacionDemanda.MSVPresentacionDemandaCallbackApi.onStart";
	public static final String MSV_PRESENTACION_DEMANDA_CALLBACK_ONSUCCESS="es.pfsgroup.plugin.recovery.masivo.callbacks.presentacionDemanda.MSVPresentacionDemandaCallbackApi.onSuccess";
	
	@BusinessOperationDefinition(MSV_PRESENTACION_DEMANDA_CALLBACK_ONEND)
	public abstract void onEndProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_PRESENTACION_DEMANDA_CALLBACK_ONERROR)
	public abstract void onError(Long tokenProceso, RecoveryBPMfwkInputDto input,
			String errorMessage);

	@BusinessOperationDefinition(MSV_PRESENTACION_DEMANDA_CALLBACK_ONSTART)
	public abstract void onStartProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_PRESENTACION_DEMANDA_CALLBACK_ONSUCCESS)
	public abstract void onSuccess(Long tokenProceso, RecoveryBPMfwkInputDto input);

}