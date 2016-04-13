package es.pfsgroup.recovery.adjunto.cajamar;

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
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
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

@Component
public class AdjuntoCajamarManager {
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GestorDocumentalApi gestorDocumentalApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ExpedienteManagerApi expedienteManagerApi;
	
	@Autowired
	private AdjuntoAssembler adjuntoAssembler;
	
	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private EXTAsuntoManager extAsuntoManager;
	
    @Resource
    Properties appProperties;
    
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
		Asunto asun = genericDao.get(Asunto.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		EXTAsunto asunto = extAsuntoManager.prepareGuid(asun);
		
		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
		return adjuntoAssembler.listAdjuntoGridDtoToEXTAdjuntoDto(gestorDocumentalApi.listadoDocumentos(id, asunto.getGuid() , DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, null), borrarOtrosUsu);
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(id);
		
		List<ExtAdjuntoGenericoDto> adjuntos = new ArrayList<ExtAdjuntoGenericoDto>();
		for(Contrato contrato : asunto.getContratos()){
			List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(null, contrato.getNroContrato() , DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);
			if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
				adjuntos.add(adjuntoAssembler.contratoToExtAdjuntoGenericoDto(contrato));
			}else{
				adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto, contrato.getId(), contrato.getNroContrato()));
			}
		}			
		return adjuntos;	
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		List<ExtAdjuntoGenericoDto> adjuntos = new ArrayList<ExtAdjuntoGenericoDto>();
		List<Persona> personas = proxyFactory.proxy(AsuntoApi.class).obtenerPersonasDeUnAsunto(id);
		
		for(Persona persona : personas){
			List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(null, persona.getCodClienteEntidad().toString(), DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);
			if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
				adjuntos.add(adjuntoAssembler.personaToExtAdjuntoGenericoDto(persona));
			}else{
				adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto, persona.getId(), persona.getApellidoNombre()));
			}
		}				
		
		return adjuntos;
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		List<ExtAdjuntoGenericoDto> adjuntos = new ArrayList<ExtAdjuntoGenericoDto>();
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(id);

		if(!Checks.esNulo(asunto.getExpediente()) && !Checks.esNulo(asunto.getExpediente().getId())){
			
			Expediente expediente = genericDao.get(Expediente.class, genericDao.createFilter(FilterType.EQUALS, "id", asunto.getExpediente().getId()));
			
			List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(null, expediente.getGuid(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
			if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
				adjuntos.add(adjuntoAssembler.expedienteToExtAdjuntoGenericoDto(expediente));
			}else{
				adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto, expediente.getId(), expediente.getDescripcion()));
			}
		}
		
		return adjuntos;	
	}

	public String upload(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			if (!Checks.esNulo(uploadForm.getParameter("prcId"))) {
				return altaDocumento(Long.parseLong(uploadForm.getParameter("prcId")), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, uploadForm.getParameter("comboTipoFichero"), uploadForm);
			}else{
				return altaDocumento(Long.parseLong(uploadForm.getParameter("id")), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, uploadForm.getParameter("comboTipoFichero"), uploadForm);	
			}
		}else{
			return null;
		}
	}

	public String uploadPersona(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, uploadForm.getParameter("comboTipoDoc"), uploadForm);	
		}else{
			return null;
		}
	}

	public String uploadExpediente(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, uploadForm.getParameter("comboTipoDoc"), uploadForm);	
		}else{
			return null;
		}
	}

	public String uploadContrato(WebFileItem uploadForm) {
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){
			return altaDocumento(Long.parseLong(uploadForm.getParameter("id")),DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, uploadForm.getParameter("comboTipoDoc"), uploadForm);	
		}else{
			return null;
		}
	}

	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
		MEJProcedimiento procedimiento = extProcedimientoManager.prepareGuid(prc);
		
		final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(prcId, procedimiento.getGuid(), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO, null);
		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
		return adjuntoAssembler.listAdjuntoGridDtoTOListAdjuntoDto(listDto,borrarOtrosUsu);	
	}

	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		Expediente expediente = genericDao.get(Expediente.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		
		final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(null, expediente.getGuid(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
		return adjuntoAssembler.listAdjuntoGridDtoTOListAdjuntoDto(listDto,borrarOtrosUsu);	
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		List<ExtAdjuntoGenericoDto> adjuntos = new ArrayList<ExtAdjuntoGenericoDto>();
		
		for(Persona persona : expedienteManagerApi.findPersonasByExpedienteId(id)){
			List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(null, persona.getCodClienteEntidad().toString(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);	
			if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
				adjuntos.add(adjuntoAssembler.personaToExtAdjuntoGenericoDto(persona));
			}else{
				adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto, persona.getId(), persona.getApellidoNombre()));
			}
		}
		
		return adjuntos;
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		List<ExtAdjuntoGenericoDto> adjuntos = new ArrayList<ExtAdjuntoGenericoDto>();
		
		for(Contrato contrato : expedienteManagerApi.findContratosRiesgoExpediente(id)){
			List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(null, contrato.getNroContrato(), DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE, null);
			if(Checks.esNulo(listDto) || Checks.estaVacio(listDto)){
				adjuntos.add(adjuntoAssembler.contratoToExtAdjuntoGenericoDto(contrato));
			}else{
				adjuntos.addAll(adjuntoAssembler.listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(listDto, contrato.getId(), contrato.getNroContrato()));
			}
		}		
		
		return adjuntos;
	}

	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id) {
		Contrato contrato = genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		
		final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(null, contrato.getNroContrato(), DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO, null);
		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
		return adjuntoAssembler.listAdjuntoGridDtoTOListAdjuntoDto(listDto,borrarOtrosUsu);	
	}

	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		Persona persona = genericDao.get(Persona.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		
		final List<AdjuntoGridDto> listDto = gestorDocumentalApi.listadoDocumentos(null, persona.getCodClienteEntidad().toString(), DDTipoEntidad.CODIGO_ENTIDAD_PERSONA, null);
		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");
		return adjuntoAssembler.listAdjuntoGridDtoTOListAdjuntoDto(listDto,borrarOtrosUsu);	
	}
	
	public FileItem bajarAdjuntoAsunto(Long asuntoId, String adjuntoId, String nombre, String extension) {
		return recuperacionDocumento(adjuntoId, nombre, extension);	
	}
	
	public FileItem bajarAdjuntoExpediente(String adjuntoId, String nombre, String extension) {
		return recuperacionDocumento(adjuntoId, nombre, extension);		
	}

	public FileItem bajarAdjuntoContrato(String adjuntoId, String nombre, String extension) {
		return recuperacionDocumento(adjuntoId, nombre, extension);	
	}

	public FileItem bajarAdjuntoPersona(String adjuntoId, String nombre, String extension) {
		return recuperacionDocumento(adjuntoId, nombre, extension);
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
		String ficheroBase64 = gestorDocumentalApi.recuperacionDocumento(id);
		try {
			return generaFileItem(nombre, ficheroBase64, extension);
		} catch (Throwable e) {
			logger.error("RecuperacionDocumento error: " + e);
		}
		return new FileItem();
	}
	
	private FileItem generaFileItem(String nombreFichero, String contenido, String extension) throws Throwable {
		logger.info("Recupera documento generaFileItem...");
		String nomFichero = "nomFichero";
		String ext = nombreFichero.substring(nombreFichero.lastIndexOf(".")+1);
		
		File fileSalidaTemporal = null;
		FileItem resultado = null;
		InputStream stream =  new ByteArrayInputStream(Base64.decodeBase64(contenido.getBytes()));
		
		fileSalidaTemporal = File.createTempFile(nomFichero, "."+ext);
		fileSalidaTemporal.deleteOnExit();
		
		resultado = new FileItem();
		resultado.setFileName(nomFichero + (new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())) + "."+ext);
		if(Checks.esNulo(extension)) {
			resultado.setContentType("");			
		}else{
			resultado.setContentType(extension);
		}
		resultado.setFile(fileSalidaTemporal);
        OutputStream outputStream = resultado.getOutputStream(); // Last step is to get FileItem's output stream, and write your inputStream in it. This is the way to write to your FileItem.
        int read = 0;
		byte[] bytes = new byte[1024];

		while ((read = stream.read(bytes)) != -1) {
			outputStream.write(bytes, 0, read);
		}

		outputStream.close();
		logger.info("Finaliza generaFileItem...");
		return resultado;
		
	}
	
}
