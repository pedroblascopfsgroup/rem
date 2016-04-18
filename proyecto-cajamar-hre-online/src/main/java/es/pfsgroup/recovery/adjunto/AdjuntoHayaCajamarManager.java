package es.pfsgroup.recovery.adjunto;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjuntos.api.AdjuntoApi;
import es.capgemini.pfs.adjuntos.manager.AdjuntoManager;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.adjunto.cajamar.AdjuntoCajamarManager;
import es.pfsgroup.recovery.adjunto.haya.AdjuntoHayaManager;

@Service("adjuntoManagerHayaCajamarImpl")
public class AdjuntoHayaCajamarManager extends AdjuntoManager  implements AdjuntoApi {
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private AdjuntoHayaManager adjuntoHayaManager;
	
	@Autowired
	private AdjuntoCajamarManager adjuntoCajamarManager;
	
	@Resource
    Properties appProperties;
	
	private String ENTIDAD_CAJAMAR = "CAJAMAR";
    private final static String GESTOR_DOCUMENTAL_WS_ACTIVADO = "gestor.documental.cajamar.ws.activado"; 

	@Override
	@Transactional(readOnly = false)
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
		if(esEntidadCajamar()){
			return (List<? extends EXTAdjuntoDto>) adjuntoCajamarManager.getAdjuntosCntConBorrado(id);
		}else{
			return adjuntoHayaManager.getAdjuntosConBorrado(id);
		}
	}

	@Override
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.getAdjuntosConBorradoByPrcId(prcId);
		}else{
			return adjuntoHayaManager.getAdjuntosConBorradoByPrcId(prcId);
		}
	}
	
	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.getAdjuntosContratosAsu(id);
		}else{
			return adjuntoHayaManager.getAdjuntosContratosAsu(id);
		}
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.getAdjuntosPersonaAsu(id);
		}else{
			return adjuntoHayaManager.getAdjuntosPersonaAsu(id);
		}
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.getAdjuntosExpedienteAsu(id);
		}else{
			return super.getAdjuntosExpedienteAsu(id);
//			return adjuntoHayaManager.getAdjuntosExpedienteAsu(id);
		}
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.getAdjuntosConBorradoExp(id);
		}else{
			return super.getAdjuntosConBorradoExp(id);
//			return adjuntoHayaManager.getAdjuntosConBorradoExp(id);
		}
		
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.getAdjuntosPersonasExp(id);
		}else{
			return super.getAdjuntosPersonasExp(id);
//			return adjuntoHayaManager.getAdjuntosPersonasExp(id);
		}
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.getAdjuntosContratoExp(id);
		}else{
			return super.getAdjuntosContratoExp(id);
//			return adjuntoHayaManager.getAdjuntosContratoExp(id);
		}
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.getAdjuntosCntConBorrado(id);
		}else{
			return adjuntoHayaManager.getAdjuntosCntConBorrado(id);
		}
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.getAdjuntosPersonaConBorrado(id);
		}else{
			return adjuntoHayaManager.getAdjuntosPersonaConBorrado(id);
		}
	}

	@Override
	public String upload(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return adjuntoCajamarManager.upload(uploadForm);
			}else{
				return adjuntoHayaManager.upload(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	public String uploadPersona(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return adjuntoCajamarManager.uploadPersona(uploadForm);
			}else{
				return adjuntoHayaManager.uploadPersona(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	public String uploadExpediente(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return adjuntoCajamarManager.uploadExpediente(uploadForm);
			}else{
				return super.uploadExpediente(uploadForm);
//				return adjuntoHayaManager.uploadExpediente(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	public String uploadContrato(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return adjuntoCajamarManager.uploadContrato(uploadForm);
			}else{
				return adjuntoHayaManager.uploadContrato(uploadForm);
			}
		}else{
			return null;
		}
	}
	
	@Override
	public FileItem bajarAdjuntoAsunto(Long asuntoId, String adjuntoId, String nombre, String extension) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.bajarAdjuntoAsunto(asuntoId, adjuntoId, nombre, extension);
		}else{
			return adjuntoHayaManager.bajarAdjunto(adjuntoId);
		}
	}
	
	@Override
	public FileItem bajarAdjuntoExpediente(String adjuntoId, String nombre, String extension) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.bajarAdjuntoExpediente(adjuntoId, nombre, extension);
		}else{
			return super.bajarAdjuntoExpediente(adjuntoId, nombre, extension);
//			return adjuntoHayaManager.bajarAdjunto(adjuntoId);
		}
	}

	@Override
	public FileItem bajarAdjuntoContrato(String adjuntoId, String nombre, String extension) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.bajarAdjuntoContrato(adjuntoId, nombre, extension);
		}else{
			return adjuntoHayaManager.bajarAdjunto(adjuntoId);
		}
	}

	@Override
	public FileItem bajarAdjuntoPersona(String adjuntoId, String nombre, String extension) {
		if(esEntidadCajamar()){
			return adjuntoCajamarManager.bajarAdjuntoPersona(adjuntoId, nombre, extension);
		}else{
			return adjuntoHayaManager.bajarAdjunto(adjuntoId);
		}
	}

	private boolean esEntidadCajamar(){
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if(ENTIDAD_CAJAMAR.equals(usuario.getEntidad().getDescripcion()) && Boolean.parseBoolean(appProperties.getProperty(GESTOR_DOCUMENTAL_WS_ACTIVADO))){
			return true;
		}else{
			return false;	
		}
	}	
}
