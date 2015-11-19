package es.pfsgroup.recovery.haya.adjunto;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjuntos.api.AdjuntoApi;
import es.capgemini.pfs.adjuntos.manager.AdjuntoManager;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.expediente.api.ExpedienteManagerApi;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.recovery.adjunto.AdjuntoAssembler;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

@Component("adjuntoManagerHayaImpl")
public class AdjuntoHayaManager extends AdjuntoManager  implements AdjuntoApi {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GestorDocumentalApi gestorDocumentalApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteManagerApi expedienteManagerApi;
	
	private String ENTIDAD_CAJAMAR = "CAJAMAR";
	
	@Autowired
	private AdjuntoAssembler adjuntoAssembler;

	@Override
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
		if(esEntidadCajamar()){
			final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
			return adjuntoAssembler.listAdjuntoGridDtoToEXTAdjuntoDto(gestorDocumentalApi.listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, null), borrarOtrosUsu);
		}else{
			return super.getAdjuntosConBorrado(id);
		}
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		if(esEntidadCajamar()){
			
			List<ExtAdjuntoGenericoDto> adjuntos = new ArrayList<ExtAdjuntoGenericoDto>();
			
			Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(id);
			
			for(Contrato contrato : asunto.getContratos()){
				List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(contrato.getId(), DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);
				if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
					adjuntos.add(adjuntoAssembler.contratoToExtAdjuntoGenericoDto(contrato));
				}else{
					adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto));
				}
			}			
			
			return adjuntos;	
			
		}else{
			return super.getAdjuntosContratosAsu(id);
		}
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		if(esEntidadCajamar()){
			
			List<ExtAdjuntoGenericoDto> adjuntos = new ArrayList<ExtAdjuntoGenericoDto>();
			List<Persona> personas = proxyFactory.proxy(AsuntoApi.class).obtenerPersonasDeUnAsunto(id);
			
			for(Persona persona : personas){
				List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(persona.getId(), DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);
				if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
					adjuntos.add(adjuntoAssembler.personaToExtAdjuntoGenericoDto(persona));
				}else{
					adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto));
				}
			}				
			
			return adjuntos;
			
		}else{
			return super.getAdjuntosPersonaAsu(id);
		}
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		if(esEntidadCajamar()){
			
			List<ExtAdjuntoGenericoDto> adjuntos = new ArrayList<ExtAdjuntoGenericoDto>();
			Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(id);
	
			if(!Checks.esNulo(asunto.getExpediente())){
				List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(asunto.getExpediente().getId(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
				if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
					adjuntos.add(adjuntoAssembler.expedienteToExtAdjuntoGenericoDto(asunto.getExpediente()));
				}else{
					adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto));
				}
			}
			
			return adjuntos;	
			
		}else{
			return super.getAdjuntosExpedienteAsu(id);
		}
	}

	@Override
	public String upload(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return altaDocumento(Long.parseLong(uploadForm.getParameter("id")), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, null, uploadForm);
			}else{
				return super.upload(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	public String uploadPersona(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null, uploadForm);	
			}else{
				return super.uploadPersona(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	public String uploadExpediente(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null, uploadForm);	
			}else{
				return super.uploadExpediente(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	public String uploadContrato(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if(esEntidadCajamar()){
				return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null, uploadForm);	
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
			final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(prcId, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, null);
			final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
			return adjuntoAssembler.listAdjuntoGridDtoTOListAdjuntoDto(listDto,borrarOtrosUsu);	
		}else{
			return super.getAdjuntosConBorradoByPrcId(prcId);
		}
		
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		if(esEntidadCajamar()){
			final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
			final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
			return adjuntoAssembler.listAdjuntoGridDtoTOListAdjuntoDto(listDto,borrarOtrosUsu);	
		}else{
			return super.getAdjuntosConBorradoExp(id);
		}
		
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		if(esEntidadCajamar()){
			
			List<ExtAdjuntoGenericoDto> adjuntos = new ArrayList<ExtAdjuntoGenericoDto>();
			
			for(Persona persona : expedienteManagerApi.findPersonasByExpedienteId(id)){
				List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(persona.getId(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);	
				if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
					adjuntos.add(adjuntoAssembler.personaToExtAdjuntoGenericoDto(persona));
				}else{
					adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto));
				}
			}
			
			return adjuntos;
			
		}else{
			return super.getAdjuntosPersonasExp(id);
		}
	}

	@Override
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		if(esEntidadCajamar()){
			
			List<ExtAdjuntoGenericoDto> adjuntos = new ArrayList<ExtAdjuntoGenericoDto>();
			
			for(Contrato contrato : expedienteManagerApi.findContratosRiesgoExpediente(id)){
				List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(contrato.getId(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
				if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
					adjuntos.add(adjuntoAssembler.contratoToExtAdjuntoGenericoDto(contrato));
				}else{
					adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto));
				}
			}		
			
			return adjuntos;
			
		}else{
			return super.getAdjuntosContratoExp(id);
		}
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id) {
		if(esEntidadCajamar()){
			final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);
			final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
			return adjuntoAssembler.listAdjuntoGridDtoTOListAdjuntoDto(listDto,borrarOtrosUsu);	
		}else{
			return super.getAdjuntosCntConBorrado(id);
		}
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		if(esEntidadCajamar()){
			final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(id, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);
			final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
			return adjuntoAssembler.listAdjuntoGridDtoTOListAdjuntoDto(listDto,borrarOtrosUsu);	
		}else{
			return super.getAdjuntosPersonaConBorrado(id);
		}
	}
	
	@Override
	public FileItem bajarAdjuntoAsunto(Long asuntoId, String adjuntoId) {
		if(esEntidadCajamar()){
			return recuperacionDocumento(adjuntoId);	
		}else{
			return super.bajarAdjuntoAsunto(asuntoId, adjuntoId);
		}
	}
	
	@Override
	public FileItem bajarAdjuntoExpediente(String adjuntoId) {
		if(esEntidadCajamar()){
			return recuperacionDocumento(adjuntoId);	
		}else{
			return super.bajarAdjuntoExpediente(adjuntoId);
		}
	}

	@Override
	public FileItem bajarAdjuntoContrato(String adjuntoId) {
		if(esEntidadCajamar()){
			return recuperacionDocumento(adjuntoId);	
		}else{
			return super.bajarAdjuntoContrato(adjuntoId);
		}
	}

	@Override
	public FileItem bajarAdjuntoPersona(String adjuntoId) {
		if(esEntidadCajamar()){
			return recuperacionDocumento(adjuntoId);
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
	
	private  boolean tieneFuncion(Usuario usuario, String codigo) {
		List<Perfil> perfiles = usuario.getPerfiles();
		for (Perfil per : perfiles) {
			for (Funcion fun : per.getFunciones()) {
				if (fun.getDescripcion().equals(codigo)) {
					return true;
				}
			}
		}

		return false;
	}
	
	public String altaDocumento(Long idEntidad, String tipoEntidadGrid, String tipoDocumento, WebFileItem uploadForm){
		return gestorDocumentalApi.altaDocumento(idEntidad, tipoEntidadGrid, tipoDocumento, uploadForm);
	}
	
	public FileItem recuperacionDocumento(String id){
		
		if(!Checks.esNulo(id)){
			AdjuntoGridDto djDto = gestorDocumentalApi.recuperacionDocumento(id);
			File file = new File("tmp");
			FileItem fileItem = null;
			try {
				FileUtils.writeStringToFile(file, djDto.getFicheroBase64());
				fileItem = new FileItem(file);
				file.delete();
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return fileItem;
			
		}else{
			return null;
		}
		
	}
}
