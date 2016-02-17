package es.capgemini.pfs.adjuntos.api;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface AdjuntoOnlineApi {
	

	public static final String BO_ADJ_UPLOAD_ASUNTO = "adjuntosManager.upload";
	public static final String BO_ADJ_UPLOAD_PERSONA_ASUNTO = "adjuntosManager.uploadPersona";
	public static final String BO_ADJ_UPLOAD_EXPEDIENTE_ASUNTO = "adjuntosManager.uploadExpediente";
	public static final String BO_ADJ_UPLOAD_CONTRATO_ASUNTO = "adjuntosManager.uploadContrato";
	public static final String BO_ADJ_BAJAR_ADJUNTO_ASUNTO = "adjuntosManager.bajarAdjuntoAsunto";
	public static final String BO_ADJ_BAJAR_ADJUNTO_PERSONA = "adjuntosManager.bajarAdjuntoPersona";
	public static final String BO_ADJ_BAJAR_ADJUNTO_EXPEDIENTE = "adjuntosManager.bajarAdjuntoExpediente";
	public static final String BO_ADJ_BAJAR_ADJUNTO_CONTRATO = "adjuntosManager.bajarAdjuntoContrato";
	
	
	

	
	/*ASUNTO*/
	
	@BusinessOperationDefinition(BO_ADJ_UPLOAD_ASUNTO)
	@Transactional(readOnly = false)
    public String upload(WebFileItem uploadForm);
	
	@BusinessOperationDefinition(BO_ADJ_UPLOAD_PERSONA_ASUNTO)
	@Transactional(readOnly = false)
    public String uploadPersona(WebFileItem uploadForm);
	
	@BusinessOperationDefinition(BO_ADJ_UPLOAD_EXPEDIENTE_ASUNTO)
	@Transactional(readOnly = false)
	public String uploadExpediente(WebFileItem uploadForm);
	
	@BusinessOperationDefinition(BO_ADJ_UPLOAD_CONTRATO_ASUNTO)
	@Transactional(readOnly = false)
	public String uploadContrato(WebFileItem uploadForm);
	
	@BusinessOperationDefinition(BO_ADJ_BAJAR_ADJUNTO_ASUNTO)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoAsunto(Long asuntoId, String adjuntoId, String nombre, String extension);
	
	/*PROCEDIMIENTO*/
	@BusinessOperationDefinition(BO_ADJ_BAJAR_ADJUNTO_EXPEDIENTE)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoExpediente(String adjuntoId, String nombre, String extension);
	
	/*CONTRATO*/	
	@BusinessOperationDefinition(BO_ADJ_BAJAR_ADJUNTO_CONTRATO)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoContrato(String adjuntoId, String nombre, String extension);
	
	@BusinessOperationDefinition(BO_ADJ_BAJAR_ADJUNTO_PERSONA)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoPersona(String adjuntoId, String nombre, String extension);

}
