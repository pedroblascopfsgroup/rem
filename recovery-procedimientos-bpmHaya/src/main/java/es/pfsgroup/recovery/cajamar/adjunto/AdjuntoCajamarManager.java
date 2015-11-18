package es.pfsgroup.recovery.cajamar.adjunto;

import java.util.List;

import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjuntos.api.AdjuntoApi;
import es.capgemini.pfs.adjuntos.manager.AdjuntoManager;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.adjunto.AdjuntoAssembler;

@Component("adjuntoManagerImpl")
public class AdjuntoCajamarManager implements AdjuntoApi {


	@Override
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
		//return (List<? extends EXTAdjuntoDto>) listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, null);
		return null;
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		return AdjuntoAssembler.listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		return AdjuntoAssembler.listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		return AdjuntoAssembler.listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
	}

	@Override
	@BusinessOperation(overrides = AdjuntoManager.BO_ADJ_UPLOAD_PERSONA_ASUNTO)
	public String upload(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return AdjuntoAssembler.altaDocumento(Long.parseLong(uploadForm.getParameter("id")), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, null, uploadForm);
		}else{
			return null;
		}
	}

	@Override
	@BusinessOperation(overrides = AdjuntoManager.BO_ADJ_UPLOAD_PERSONA_ASUNTO)
	public String uploadPersona(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return AdjuntoAssembler.altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null, uploadForm);
		}else{
			return null;
		}
	}

	@Override
	@BusinessOperation(overrides = AdjuntoManager.BO_ADJ_UPLOAD_EXPEDIENTE_ASUNTO)
	public String uploadExpediente(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return AdjuntoAssembler.altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null, uploadForm);
		}else{
			return null;
		}
	}

	@Override
	@BusinessOperation(overrides = AdjuntoManager.BO_ADJ_UPLOAD_CONTRATO_ASUNTO)
	public String uploadContrato(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return AdjuntoAssembler.altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null, uploadForm);
		}else{
			return null;
		}
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		return AdjuntoAssembler.listadoDocumentos(prcId, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, null);
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		return AdjuntoAssembler.listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		return AdjuntoAssembler.listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		return AdjuntoAssembler.listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id) {
		return AdjuntoAssembler.listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		return AdjuntoAssembler.listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);
	}
	
	@Override
	@BusinessOperation(overrides = AdjuntoManager.BO_ADJ_BAJAR_ADJUNTO_ASUNTO)
	public FileItem bajarAdjuntoAsunto(Long asuntoId, Long adjuntoId) {
		return AdjuntoAssembler.recuperacionDocumento(adjuntoId);
	}
	
	@Override
	@BusinessOperation(overrides = AdjuntoManager.BO_ADJ_BAJAR_ADJUNTO_EXPEDIENTE)
	public FileItem bajarAdjuntoExpediente(Long adjuntoId) {
		return AdjuntoAssembler.recuperacionDocumento(adjuntoId);
	}

	@Override
	@BusinessOperation(overrides = AdjuntoManager.BO_ADJ_BAJAR_ADJUNTO_CONTRATO)
	public FileItem bajarAdjuntoContrato(Long adjuntoId) {
		return AdjuntoAssembler.recuperacionDocumento(adjuntoId);
	}

	@Override
	@BusinessOperation(overrides = AdjuntoManager.BO_ADJ_BAJAR_ADJUNTO_PERSONA)
	public FileItem bajarAdjuntoPersona(Long adjuntoId) {
		return AdjuntoAssembler.recuperacionDocumento(adjuntoId);
	}


}
