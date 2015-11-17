package es.pfsgroup.recovery.haya.adjunto;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjuntos.api.AdjuntoApi;
import es.capgemini.pfs.adjuntos.manager.AdjuntoManager;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.adjunto.AdjuntoAssembler;

@Component("adjuntoManagerHayaImpl")
public class AdjuntoHayaManager extends AdjuntoManager  implements AdjuntoApi {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	private String ENTIDAD_CAJAMAR = "CAJAMAR";

	@Override
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
		//return (List<? extends EXTAdjuntoDto>) listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, null);
		return null;
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);	
		}else{
			return super.getAdjuntosContratosAsu(id);
		}
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);	
		}else{
			return super.getAdjuntosPersonaAsu(id);
		}
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);	
		}else{
			return super.getAdjuntosExpedienteAsu(id);
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJ_UPLOAD_PERSONA_ASUNTO)
	public String upload(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return AdjuntoAssembler.altaDocumento(Long.parseLong(uploadForm.getParameter("id")), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, null, uploadForm);
			}else{
				return super.upload(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJ_UPLOAD_PERSONA_ASUNTO)
	public String uploadPersona(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return AdjuntoAssembler.altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null, uploadForm);	
			}else{
				return super.uploadPersona(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJ_UPLOAD_EXPEDIENTE_ASUNTO)
	public String uploadExpediente(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return AdjuntoAssembler.altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null, uploadForm);	
			}else{
				return super.uploadExpediente(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJ_UPLOAD_CONTRATO_ASUNTO)
	public String uploadContrato(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return AdjuntoAssembler.altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null, uploadForm);	
			}else{
				return super.uploadContrato(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.listadoDocumentos(prcId, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, null);	
		}else{
			return super.getAdjuntosConBorradoByPrcId(prcId);
		}
		
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);	
		}else{
			return super.getAdjuntosConBorradoExp(id);
		}
		
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);	
		}else{
			return super.getAdjuntosPersonasExp(id);
		}
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.listadoDocumentosGeneric(id, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);	
		}else{
			return super.getAdjuntosContratoExp(id);
		}
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);	
		}else{
			return super.getAdjuntosCntConBorrado(id);
		}
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);	
		}else{
			return super.getAdjuntosPersonaConBorrado(id);
		}
	}
	
	@Override
	@BusinessOperation(overrides = BO_ADJ_BAJAR_ADJUNTO_ASUNTO)
	public FileItem bajarAdjuntoAsunto(Long asuntoId, Long adjuntoId) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.recuperacionDocumento(adjuntoId);	
		}else{
			return super.bajarAdjuntoAsunto(asuntoId, adjuntoId);
		}
	}
	
	@Override
	@BusinessOperation(overrides = BO_ADJ_BAJAR_ADJUNTO_EXPEDIENTE)
	public FileItem bajarAdjuntoExpediente(Long adjuntoId) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.recuperacionDocumento(adjuntoId);	
		}else{
			return super.bajarAdjuntoExpediente(adjuntoId);
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJ_BAJAR_ADJUNTO_CONTRATO)
	public FileItem bajarAdjuntoContrato(Long adjuntoId) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.recuperacionDocumento(adjuntoId);	
		}else{
			return super.bajarAdjuntoContrato(adjuntoId);
		}
	}

	@Override
	@BusinessOperation(overrides = BO_ADJ_BAJAR_ADJUNTO_PERSONA)
	public FileItem bajarAdjuntoPersona(Long adjuntoId) {
		if(esEntidadCajamar()){
			return AdjuntoAssembler.recuperacionDocumento(adjuntoId);
		}else{
			return super.bajarAdjuntoPersona(adjuntoId);
		}
	}

	
	private boolean esEntidadCajamar(){
		
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if(ENTIDAD_CAJAMAR.equals(usuario.getEntidad().getDescripcion())){
			return true;
		}else{
			return false;	
		}
		
	}
}
