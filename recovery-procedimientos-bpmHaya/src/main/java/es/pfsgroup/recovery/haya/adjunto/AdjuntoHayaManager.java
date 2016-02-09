package es.pfsgroup.recovery.haya.adjunto;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjuntos.api.AdjuntoApi;
import es.capgemini.pfs.adjuntos.manager.AdjuntoManager;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
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
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.adjunto.AdjuntoAssembler;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;
import es.pfsgroup.tipoFicheroAdjunto.MapeoTipoFicheroAdjunto;

@Service("adjuntoManagerHayaImpl")
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
	
	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private EXTAsuntoManager extAsuntoManager;
	
    @Resource
    Properties appProperties;
    
    private final static String GESTOR_DOCUMENTAL_WS_ACTIVADO = "gestor.documental.cajamar.ws.activado"; 

	@Override
	@Transactional(readOnly = false)
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
		if(esEntidadCajamar()){
			
			Asunto asun = genericDao.get(Asunto.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
			
			EXTAsunto asunto = extAsuntoManager.prepareGuid(asun);
			
			final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
			return adjuntoAssembler.listAdjuntoGridDtoToEXTAdjuntoDto(gestorDocumentalApi.listadoDocumentos(asunto.getGuid() , DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, null), borrarOtrosUsu);
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
				List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(contrato.getNroContrato() , DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);
				if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
					adjuntos.add(adjuntoAssembler.contratoToExtAdjuntoGenericoDto(contrato));
				}else{
					adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto, contrato.getId(), contrato.getNroContrato()));
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
				List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(persona.getCodClienteEntidad().toString(), DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);
				if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
					adjuntos.add(adjuntoAssembler.personaToExtAdjuntoGenericoDto(persona));
				}else{
					adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto, persona.getId(), persona.getApellidoNombre()));
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
	
			if(!Checks.esNulo(asunto.getExpediente()) && !Checks.esNulo(asunto.getExpediente().getId())){
				
				Expediente expediente = genericDao.get(Expediente.class, genericDao.createFilter(FilterType.EQUALS, "id", asunto.getExpediente().getId()));
				
				List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(expediente.getGuid(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
				if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
					adjuntos.add(adjuntoAssembler.expedienteToExtAdjuntoGenericoDto(expediente));
				}else{
					adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto, expediente.getId(), expediente.getDescripcion()));
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
				
				String codigoTipoAdjunto = null;
				
				///Obtenemos el codigo mapeado
				if(!Checks.esNulo(uploadForm.getParameter("comboTipoFichero"))){
					MapeoTipoFicheroAdjunto mapeo = genericDao.get(MapeoTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "tipoFichero.codigo", uploadForm.getParameter("comboTipoFichero")));
					if(!Checks.esNulo(mapeo)){
						codigoTipoAdjunto = mapeo.getTipoFicheroExterno();
					}
				}
				
				if (!Checks.esNulo(uploadForm.getParameter("prcId"))) {
					return altaDocumento(Long.parseLong(uploadForm.getParameter("prcId")), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, codigoTipoAdjunto, uploadForm);
				}else{
					return altaDocumento(Long.parseLong(uploadForm.getParameter("id")), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, codigoTipoAdjunto, uploadForm);	
				}
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
				return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, uploadForm.getParameter("comboTipoDoc"), uploadForm);	
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
				return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, uploadForm.getParameter("comboTipoDoc"), uploadForm);	
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
				return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, uploadForm.getParameter("comboTipoDoc"), uploadForm);	
			}else{
				return super.uploadContrato(uploadForm);
			}
		}else{
			return null;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		if(esEntidadCajamar()){
			
			Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
			MEJProcedimiento procedimiento = extProcedimientoManager.prepareGuid(prc);
			
			final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(procedimiento.getGuid(), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, null);
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
			
			Expediente expediente = genericDao.get(Expediente.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
			
			final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(expediente.getGuid(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
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
				List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(persona.getCodClienteEntidad().toString(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);	
				if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
					adjuntos.add(adjuntoAssembler.personaToExtAdjuntoGenericoDto(persona));
				}else{
					adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto, persona.getId(), persona.getApellidoNombre()));
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
				List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(contrato.getNroContrato(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
				if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
					adjuntos.add(adjuntoAssembler.contratoToExtAdjuntoGenericoDto(contrato));
				}else{
					adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto, contrato.getId(), contrato.getNroContrato()));
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
			
			Contrato contrato = genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
			
			final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(contrato.getNroContrato(), DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);
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
			
			Persona persona = genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
			
			final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(persona.getCodClienteEntidad().toString(), DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);
			final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
			return adjuntoAssembler.listAdjuntoGridDtoTOListAdjuntoDto(listDto,borrarOtrosUsu);	
		}else{
			return super.getAdjuntosPersonaConBorrado(id);
		}
	}
	
	@Override
	public FileItem bajarAdjuntoAsunto(Long asuntoId, String adjuntoId, String nombre, String extension) {
		if(esEntidadCajamar()){
			return recuperacionDocumento(adjuntoId, nombre, extension);	
		}else{
			return super.bajarAdjuntoAsunto(asuntoId, adjuntoId, nombre, extension);
		}
	}
	
	@Override
	public FileItem bajarAdjuntoExpediente(String adjuntoId, String nombre, String extension) {
		if(esEntidadCajamar()){
			return recuperacionDocumento(adjuntoId, nombre, extension);	
		}else{
			return super.bajarAdjuntoExpediente(adjuntoId, nombre, extension);
		}
	}

	@Override
	public FileItem bajarAdjuntoContrato(String adjuntoId, String nombre, String extension) {
		if(esEntidadCajamar()){
			return recuperacionDocumento(adjuntoId, nombre, extension);	
		}else{
			return super.bajarAdjuntoContrato(adjuntoId, nombre, extension);
		}
	}

	@Override
	public FileItem bajarAdjuntoPersona(String adjuntoId, String nombre, String extension) {
		if(esEntidadCajamar()){
			return recuperacionDocumento(adjuntoId, nombre, extension);
		}else{
			return super.bajarAdjuntoPersona(adjuntoId, nombre, extension);
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
	
	public FileItem recuperacionDocumento(String id, String nombre, String extension){
		
		if(!Checks.esNulo(id)){
			AdjuntoGridDto adjunto = gestorDocumentalApi.recuperacionDocumento(id);
			try {
				if(adjunto != null) {
					return generaFileItem(nombre, adjunto.getFicheroBase64(), extension);
				}
			} catch (Throwable e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}else{
			return null;
		}
		return null;
		
	}
	
	private FileItem generaFileItem(String nombreFichero, String contenido, String extension) throws Throwable {
		
		String nomFichero = nombreFichero.substring(0, nombreFichero.indexOf("."));
		String ext = nombreFichero.substring(nombreFichero.indexOf(".")+1);
		
		File fileSalidaTemporal = null;
		FileItem resultado = null;
		InputStream stream =  new ByteArrayInputStream(Base64.decodeBase64(contenido.getBytes()));
		
		fileSalidaTemporal = File.createTempFile(nomFichero, "."+ext);
		fileSalidaTemporal.deleteOnExit();
		
		resultado = new FileItem();
		resultado.setFileName(nomFichero + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + "."+ext);
		resultado.setContentType(extension);
		resultado.setFile(fileSalidaTemporal);
        OutputStream outputStream = resultado.getOutputStream(); // Last step is to get FileItem's output stream, and write your inputStream in it. This is the way to write to your FileItem.
        int read = 0;
		byte[] bytes = new byte[1024];

		while ((read = stream.read(bytes)) != -1) {
			outputStream.write(bytes, 0, read);
		}

		outputStream.close();
		return resultado;
		
	}
	
}
