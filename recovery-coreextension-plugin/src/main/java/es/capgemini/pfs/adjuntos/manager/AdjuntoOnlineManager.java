package es.capgemini.pfs.adjuntos.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjuntos.api.AdjuntoApi;
import es.capgemini.pfs.adjuntos.api.AdjuntoOnlineApi;

@Component
public class AdjuntoOnlineManager implements AdjuntoOnlineApi{

	@Autowired
	private AdjuntoApi adjuntoApi;
	
	
	@Override
	@BusinessOperation(BO_ADJ_UPLOAD_ASUNTO)
	@Transactional(readOnly = false)
	public String upload(WebFileItem uploadForm) {
		return adjuntoApi.upload(uploadForm);
	}
	
	
	@Override
	@BusinessOperation(BO_ADJ_UPLOAD_PERSONA_ASUNTO)
	@Transactional(readOnly = false)
	public String uploadPersona(WebFileItem uploadForm) {
        return adjuntoApi.uploadPersona(uploadForm);
	}
	
	
	@Override
	@BusinessOperation(BO_ADJ_UPLOAD_EXPEDIENTE_ASUNTO)
	@Transactional(readOnly = false)
	public String uploadExpediente(WebFileItem uploadForm) {
		return adjuntoApi.uploadExpediente(uploadForm);
	}
	
	
	@Override
	@BusinessOperation(BO_ADJ_UPLOAD_CONTRATO_ASUNTO)
	@Transactional(readOnly = false)
	public String uploadContrato(WebFileItem uploadForm) {
        return adjuntoApi.uploadContrato(uploadForm);
	}
	
	
	@Override
	@BusinessOperation(BO_ADJ_BAJAR_ADJUNTO_ASUNTO)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoAsunto(Long asuntoId, String adjuntoId) {
		return adjuntoApi.bajarAdjuntoAsunto(asuntoId, adjuntoId);
	}
	
	
	@Override
	@BusinessOperation(BO_ADJ_BAJAR_ADJUNTO_PERSONA)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoPersona(String adjuntoId) {
		return adjuntoApi.bajarAdjuntoPersona(adjuntoId);
	}
	
	
	@Override
	@BusinessOperation(BO_ADJ_BAJAR_ADJUNTO_EXPEDIENTE)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoExpediente(String adjuntoId) {
		return adjuntoApi.bajarAdjuntoExpediente(adjuntoId);
	}
	
	
	@Override
	@BusinessOperation(BO_ADJ_BAJAR_ADJUNTO_CONTRATO)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoContrato(String adjuntoId) {
		return adjuntoApi.bajarAdjuntoContrato(adjuntoId);
	}


	
}
