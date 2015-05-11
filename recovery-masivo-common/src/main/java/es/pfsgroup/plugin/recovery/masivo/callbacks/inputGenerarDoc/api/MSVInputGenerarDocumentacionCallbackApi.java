package es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;

public interface MSVInputGenerarDocumentacionCallbackApi {
	
	public static final String MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONEND = "es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.api.MSVInputGenerarDocumentacionCallbackApi.onEndProcess";
	public static final String MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONERROR = "es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.api.MSVInputGenerarDocumentacionCallbackApi.onError";
	public static final String MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONSTART = "es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.api.MSVInputGenerarDocumentacionCallbackApi.onStartProcess";
	public static final String MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONSUCCESS = "es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.api.MSVInputGenerarDocumentacionCallbackApi.onSuccess";

	@BusinessOperationDefinition(MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONEND)
	public abstract void onEndProcess(Long idProcess);

	@BusinessOperationDefinition(MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONERROR)
	public abstract void onError(Long idProcess, RecoveryBPMfwkInputInfo input,
			String errorMessage);

	@BusinessOperationDefinition(MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONSTART)
	public abstract void onStartProcess(Long idProcess);

	@BusinessOperationDefinition(MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONSUCCESS)
	public abstract void onSuccess(Long idProcess, RecoveryBPMfwkInputInfo input);


}
