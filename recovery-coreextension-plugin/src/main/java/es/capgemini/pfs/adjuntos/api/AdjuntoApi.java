package es.capgemini.pfs.adjuntos.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;

public interface AdjuntoApi {

	
	/*ASUNTO*/
	@Transactional(readOnly=false)
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id);
	
	@Transactional(readOnly=false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id);
	
	@Transactional(readOnly=false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id);
	
	@Transactional(readOnly=false)
	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id);
	
	@Transactional(readOnly = false)
    public String upload(WebFileItem uploadForm);
	
	@Transactional(readOnly = false)
    public String uploadPersona(WebFileItem uploadForm);
	
	@Transactional(readOnly = false)
	public String uploadExpediente(WebFileItem uploadForm);
	
	@Transactional(readOnly = false)
	public String uploadContrato(WebFileItem uploadForm);
	
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoAsunto(Long asuntoId, String adjuntoId);
	
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
	
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoExpediente(String adjuntoId);
	
	/*CONTRATO*/
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id);
	
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoContrato(String adjuntoId);
	
	/*CLIENTE*/
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id);
	
	@Transactional(readOnly = false)
	public FileItem bajarAdjuntoPersona(String adjuntoId);

}
