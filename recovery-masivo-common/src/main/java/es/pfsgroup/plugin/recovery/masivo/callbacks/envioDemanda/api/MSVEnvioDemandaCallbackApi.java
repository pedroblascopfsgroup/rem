package es.pfsgroup.plugin.recovery.masivo.callbacks.envioDemanda.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

public interface MSVEnvioDemandaCallbackApi {
	
	public static final String MSV_ENVIO_DEMANDA_CALLBACK_ONEND="es.pfsgroup.plugin.recovery.masivo.callbacks.envioDemanda.api.MSVEnvioDemandaCallbackApi.onEndProcess";
	public static final String MSV_ENVIO_DEMANDA_CALLBACK_ONERROR="es.pfsgroup.plugin.recovery.masivo.callbacks.envioDemanda.api.MSVEnvioDemandaCallbackApi.onError";
	public static final String MSV_ENVIO_DEMANDA_CALLBACK_ONSTART="es.pfsgroup.plugin.recovery.masivo.callbacks.envioDemanda.api.MSVEnvioDemandaCallbackApi.onStart";
	public static final String MSV_ENVIO_DEMANDA_CALLBACK_ONSUCCESS="es.pfsgroup.plugin.recovery.masivo.callbacks.envioDemanda.api.MSVEnvioDemandaCallbackApi.onSuccess";
	
	@BusinessOperationDefinition(MSV_ENVIO_DEMANDA_CALLBACK_ONEND)
	public abstract void onEndProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_ENVIO_DEMANDA_CALLBACK_ONERROR)
	public abstract void onError(Long tokenProceso, RecoveryBPMfwkInputDto input,
			String errorMessage);

	@BusinessOperationDefinition(MSV_ENVIO_DEMANDA_CALLBACK_ONSTART)
	public abstract void onStartProcess(Long tokenProceso);

	@BusinessOperationDefinition(MSV_ENVIO_DEMANDA_CALLBACK_ONSUCCESS)
	public abstract void onSuccess(Long tokenProceso, RecoveryBPMfwkInputDto input);

}