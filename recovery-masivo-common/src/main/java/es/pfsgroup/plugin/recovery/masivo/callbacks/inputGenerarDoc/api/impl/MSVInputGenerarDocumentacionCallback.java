package es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.api.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVDocumentoPendienteGenerarApi;
import es.pfsgroup.plugin.recovery.masivo.callbacks.inputGenerarDoc.api.MSVInputGenerarDocumentacionCallbackApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDocumentoPendienteDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.recovery.bpmframework.api.AbstractRecoveryBPMfwCallbackBOTemplate;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;

@Component
public class MSVInputGenerarDocumentacionCallback extends AbstractRecoveryBPMfwCallbackBOTemplate implements MSVInputGenerarDocumentacionCallbackApi{

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Override
	@BusinessOperation(MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONEND)
	public void onEndProcess(Long idProcess) {
		;// Nada que hacer de momento.
		
	}

	@Override
	@BusinessOperation(MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONSTART)
	public void onStartProcess(Long idProcess) {
		MSVDocumentoPendienteDto dto = new MSVDocumentoPendienteDto();
		dto.setToken(idProcess);
		dto.setCodigoEstado(MSVDDEstadoProceso.CODIGO_EN_PROCESO);
		proxyFactory.proxy(MSVDocumentoPendienteGenerarApi.class).modificarDocumentoPendiente(dto);
		
	}

	@Override
	@BusinessOperation(MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONERROR)
	public void onError(Long idProcess, RecoveryBPMfwkInputInfo input, String errorMessage) {
		MSVDocumentoPendienteDto dto = new MSVDocumentoPendienteDto();
		dto.setToken(idProcess);
		dto.setCodigoEstado(MSVDDEstadoProceso.CODIGO_ERROR);
		proxyFactory.proxy(MSVDocumentoPendienteGenerarApi.class).modificarDocumentoPendiente(dto);
		
	}

	@Override
	@BusinessOperation(MSV_INPUT_GENERAR_DOCUMENTACION_CALLBACK_ONSUCCESS)
	public void onSuccess(Long idProcess, RecoveryBPMfwkInputInfo input) {
		MSVDocumentoPendienteDto dto = new MSVDocumentoPendienteDto();
		dto.setToken(idProcess);
		dto.setCodigoEstado(MSVDDEstadoProceso.CODIGO_PROCESADO);
		proxyFactory.proxy(MSVDocumentoPendienteGenerarApi.class).modificarDocumentoPendiente(dto);
		
	}

}
