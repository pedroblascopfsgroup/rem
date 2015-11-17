package es.capgemini.pfs.adjuntos.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface AdjuntoApi {
	

	public static final String BO_ADJ_UPLOAD_ASUNTO = "adjuntosManager.upload";
	public static final String BO_ADJ_UPLOAD_PERSONA_ASUNTO = "adjuntosManager.uploadPersona";
	public static final String BO_ADJ_UPLOAD_EXPEDIENTE_ASUNTO = "adjuntosManager.uploadExpediente";
	public static final String BO_ADJ_UPLOAD_CONTRATO_ASUNTO = "adjuntosManager.uploadContrato";
	public static final String BO_ADJ_BAJAR_ADJUNTO_ASUNTO = "adjuntosManager.bajarAdjuntoAsunto";
	public static final String BO_ADJ_BAJAR_ADJUNTO_PERSONA = "adjuntosManager.bajarAdjuntoPersona";
	public static final String BO_ADJ_BAJAR_ADJUNTO_EXPEDIENTE = "adjuntosManager.bajarAdjuntoExpediente";
	public static final String BO_ADJ_BAJAR_ADJUNTO_CONTRATO = "adjuntosManager.bajarAdjuntoContrato";
	
	
	

	
	/*ASUNTO*/
	@Transactional(readOnly=false)
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id);
	
	@Transactional(readOnly=false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id);
	
	@Transactional(readOnly=false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id);
	
	@Transactional(readOnly=false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id);
	
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
	public FileItem bajarAdjuntoAsunto(Long asuntoId, Long adjuntoId);
	
	/*PROCEDIMIENTO*/
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId);
	
	/*EXPEDIENTE*/
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id);
	
	@Transactional(readOnly = false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id);
	
	@Transactional(readOnly = false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id);
	
	@BusinessOperationDefinition(BO_ADJ_BAJAR_ADJUNTO_EXPEDIENTE)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoExpediente(Long adjuntoId);
	
	/*CONTRATO*/
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id);
	
	@BusinessOperationDefinition(BO_ADJ_BAJAR_ADJUNTO_CONTRATO)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoContrato(Long adjuntoId);
	
	/*CLIENTE*/
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id);
	
	@BusinessOperationDefinition(BO_ADJ_BAJAR_ADJUNTO_PERSONA)
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoPersona(Long adjuntoId);

}
