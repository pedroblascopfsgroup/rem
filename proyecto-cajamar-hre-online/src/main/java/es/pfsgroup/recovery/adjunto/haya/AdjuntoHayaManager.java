package es.pfsgroup.recovery.adjunto.haya;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.dao.ContratoDao;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.core.api.parametrizacion.ParametrizacionApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.expediente.dao.ExpedienteDao;
import es.capgemini.pfs.expediente.model.AdjuntoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.dao.PersonaDao;
import es.capgemini.pfs.persona.model.AdjuntoPersona;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tipoFicheroAdjuntoEntidad.DDTipoAdjuntoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearPropuestaDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.RecoveryToGestorExpAssembler;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.IdentificacionDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCrearDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;
import es.pfsgroup.plugin.gestordocumental.api.GestorDocumentalServicioDocumentosApi;
import es.pfsgroup.plugin.gestordocumental.api.GestorDocumentalServicioExpedientesApi;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CabeceraPeticionRestClientDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.CrearDocumentoDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.DocumentosExpedienteDto;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.RecoveryToGestorDocAssembler;
import es.pfsgroup.plugin.gestordocumental.dto.documentos.UsuarioPasswordDto;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.context.CajamarHreProjectContext;
import es.pfsgroup.recovery.ext.impl.adjunto.dao.EXTAdjuntoAsuntoDao;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;
import es.pfsgroup.recovery.haya.contenedor.model.ContenedorGestorDocumental;
import es.pfsgroup.recovery.haya.gestorDocumental.GestorDocToRecoveryAssembler;
import es.pfsgroup.tipoContenedor.MapeoTipoContenedor;

@Component
public class AdjuntoHayaManager {
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private Executor executor;
    
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GestorDocumentalServicioDocumentosApi gestorDocumentalServicioDocumentosApi;
	
	@Autowired
	private GestorDocumentalServicioExpedientesApi gestorDocumentalServicioExpedientesApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
    private PersonaDao personaDao;
    
	@Autowired
    private ExpedienteDao expedienteDao;
    
	@Autowired
    private ContratoDao contratoDao;
	
	@Autowired
	private CajamarHreProjectContext cajamarHreProjectContext;    
	
	@Autowired
	private EXTAdjuntoAsuntoDao extAdjuntoAsuntoDao;
	
    @Resource
    Properties appProperties;
	
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
    	Asunto asun = genericDao.get(Asunto.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
   		for(Procedimiento prc : asun.getProcedimientos()) {
			crearPropuesta(prc);
		}
        
   		List<EXTAdjuntoDto> adjuntosAsunto = new ArrayList<EXTAdjuntoDto>();
			for(String claseExpediente : getDistinctTipoProcedimientoFromAsunto(asun)) {
				adjuntosAsunto.addAll(documentosExpediente(id, null, claseExpediente));
			}
		return adjuntosAsunto;
	}
	
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", prcId));
		crearPropuesta(prc);
		String claseExpediente = getClaseExpedienteByProcedimientoPadre(prc);
		return documentosExpediente(prc.getAsunto().getId(), prcId, claseExpediente);
	}
	
	private void crearPropuesta(Procedimiento prc) {
		if( buscarTPRCsinContenedor(prc)) {
			String idAsunto=prc.getAsunto().getId().toString();
			String claseExpe = cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
			UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), null);
			CrearPropuestaDto crearPropuesta = RecoveryToGestorExpAssembler.getCrearPropuestaDto(idAsunto, claseExpe, usuPass);
			
			try {
				RespuestaCrearExpediente respuesta = gestorDocumentalServicioExpedientesApi.crearPropuesta(crearPropuesta);
				insertarContenedor(respuesta.getIdExpediente(), prc.getAsunto(), claseExpe);
			} catch (GestorDocumentalException e) {
				e.printStackTrace();
			}	
		}
	}
	
	private List<EXTAdjuntoDto> documentosExpediente(Long idAsunto, Long idPrc, String claseExpediente) {
		List<Integer> idsDocumento = new ArrayList<Integer>();
		UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), null);

		CabeceraPeticionRestClientDto cabecera = RecoveryToGestorDocAssembler.getCabeceraPeticionRestClient(idAsunto.toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExpediente);
		DocumentosExpedienteDto docExpDto = RecoveryToGestorDocAssembler.getDocumentosExpedienteDto(usuPass);
		try {
			RespuestaDocumentosExpedientes respuesta = gestorDocumentalServicioDocumentosApi.documentosExpediente(cabecera, docExpDto);
			for(IdentificacionDocumento idenDoc : respuesta.getDocumentos()) {
				idsDocumento.add(idenDoc.getIdentificadorNodo());
			}
		} catch (GestorDocumentalException e) {
			logger.error("getAdjuntosConBorradoByPrcId error: " + e);
		}
		if(Checks.esNulo(idsDocumento) || Checks.estaVacio(idsDocumento)) {
			return null;
		}
		Set<AdjuntoAsunto> list = extAdjuntoAsuntoDao.getAdjuntoAsuntoByIdDocumentoAndPrcId(idsDocumento, idPrc);
		List<EXTAdjuntoDto> adjuntosAsunto = new ArrayList<EXTAdjuntoDto>();
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		adjuntosAsunto.addAll(creaObjetosEXTAsuntos(list, usuario, false));
		return adjuntosAsunto;
	}
	
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		return null;
//		return super.getAdjuntosContratosAsu(id);
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		return null;
//		return super.getAdjuntosPersonaAsu(id);
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		return null;
//		return super.getAdjuntosExpedienteAsu(id);
	}

	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id) {
		return null;
//		return super.getAdjuntosConBorradoExp(id);
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id) {
		return null;
//		return super.getAdjuntosPersonasExp(id);
	}

	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id) {
		return null;
//		return super.getAdjuntosContratoExp(id);
	}

	public List<? extends AdjuntoDto> getAdjuntosCntConBorrado(Long id){
		return null;
//		return super.getAdjuntosCntConBorrado(id);
	}

	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id) {
		return null;
//		return super.getAdjuntosPersonaConBorrado(id);
	}

    private void insertarContenedor(Integer idExpediente, Asunto asun, String claseExp) {
    	ContenedorGestorDocumental contenedor = new ContenedorGestorDocumental();
		contenedor.setIdExterno(new Long(idExpediente));
		contenedor.setAsunto(asun);
		contenedor.setCodigoTipo(GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS);
		contenedor.setCodigoClase(claseExp);
		Auditoria.save(contenedor);
		genericDao.save(ContenedorGestorDocumental.class, contenedor);
    }
    
    private List<String> getDistinctTipoProcedimientoFromAsunto(Asunto asun) {
    	List<String> listTipoProcedimiento = new ArrayList<String>();
    	for (Procedimiento prc : asun.getProcedimientos()) {
    		String claseExpe = cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
    		if(!listTipoProcedimiento.contains(claseExpe) && !Checks.esNulo(claseExpe)) {
    			listTipoProcedimiento.add(claseExpe);
    		}
    	}
    	return listTipoProcedimiento;
    }

	public String upload(WebFileItem uploadForm) {
		String retorno = null;
		if(!Checks.esNulo(uploadForm) && !Checks.esNulo(uploadForm.getParameter("id"))){			
			Long idAsunto = Long.parseLong(uploadForm.getParameter("id"));
			if (!Checks.esNulo(uploadForm.getParameter("prcId"))){
				retorno = uploadProcedimiento(uploadForm, idAsunto);
			}else{
				retorno = uploadAsunto(uploadForm, idAsunto);
			}
		}
		return retorno;
	}
	
	private String uploadAsunto(WebFileItem uploadForm, Long idAsunto) {
		boolean contenedorEncontrado = false;
		List<String> listaContenedores = null;
		listaContenedores = getContenedoresByAsunto(idAsunto);			
		for(String claseExpe : listaContenedores) {
			if(!Checks.esNulo(claseExpe)) {
				RespuestaCrearDocumento respuesta = uploadGestorDoc(idAsunto, claseExpe, uploadForm, DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
				if(!Checks.esNulo(respuesta) && !Checks.esNulo(respuesta.getIdDocumento())) {
					contenedorEncontrado = true;
					break;
				}
			}
		}
		
		if(!contenedorEncontrado) {
			return GestorDocumentalConstants.ERROR_NO_EXISTE_CONTENEDOR;
		}
		return null;
	}
	
	private String uploadProcedimiento(WebFileItem uploadForm, Long idAsunto) {
		Long idProcedimiento = Long.parseLong(uploadForm.getParameter("prcId"));
		Procedimiento prc = genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", idProcedimiento));
		String claseExp = getClaseExpedienteByProcedimientoPadre(prc);
		uploadGestorDoc(idAsunto, claseExp, uploadForm, DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
		return null;
	}
	
	public String uploadPersona(WebFileItem uploadForm) {
		uploadGestorDoc(1L, "clase", uploadForm, DDTipoEntidad.CODIGO_ENTIDAD_PERSONA);
		return null;
	}

	public String uploadExpediente(WebFileItem uploadForm) {
		uploadGestorDoc(1L, "clase", uploadForm, DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE);
		return null;
	}

	public String uploadContrato(WebFileItem uploadForm) {
		uploadGestorDoc(1L, "clase", uploadForm, DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO);
		return null;
	}

	
	private RespuestaCrearDocumento uploadGestorDoc(Long idAsunto, String claseExp, WebFileItem uploadForm, String tipoEntidad) {
		RespuestaCrearDocumento respuesta = null;
		CabeceraPeticionRestClientDto cabecera = RecoveryToGestorDocAssembler.getCabeceraPeticionRestClient(idAsunto.toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExp);	
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), usuario.getUsername());
		CrearDocumentoDto crearDoc = RecoveryToGestorDocAssembler.getCrearDocumentoDto(uploadForm, usuPass, obtenerMatricula(GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_PROPUESTAS, claseExp, uploadForm.getParameter("comboTipoFichero")));
		try {
			respuesta = gestorDocumentalServicioDocumentosApi.crearDocumento(cabecera, crearDoc);
			uploadDoc(tipoEntidad, uploadForm, new Long(respuesta.getIdDocumento()));
		} catch (GestorDocumentalException e) {
			logger.error("upload error: " + e);
		}
		return respuesta;
	}
	
	private String obtenerMatricula(String tipoExp, String claseExp, String tipoFichero){
		StringBuilder sb = new StringBuilder();
		MapeoTipoContenedor mapeo = genericDao.get(MapeoTipoContenedor.class, genericDao.createFilter(FilterType.EQUALS, "tipoFichero.codigo", tipoFichero));
		if(!Checks.esNulo(mapeo)){
			sb.append(tipoExp);
			sb.append("-");
			sb.append(claseExp);
			sb.append("-");
			sb.append(mapeo.getCodigoTDN2().substring(6));
		}
		return sb.toString();
	}
	
	private String getClaseExpedienteByProcedimientoPadre(Procedimiento prc) {
		String claseExp = cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
		Procedimiento padre = prc.getProcedimientoPadre();
		while(Checks.esNulo(claseExp)) {
			if(cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(padre.getTipoProcedimiento().getCodigo()) == null){
				padre = padre.getProcedimientoPadre();
			}else{
				claseExp = cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(padre.getTipoProcedimiento().getCodigo());
			}
		}
		return claseExp;
	}
	
	public FileItem bajarAdjunto(String adjuntoId) {
		RespuestaDescargarDocumento respuesta = null;
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		UsuarioPasswordDto usuPass = RecoveryToGestorDocAssembler.getUsuarioPasswordDto(getUsuarioGestorDocumental(), getPasswordGestorDocumental(), usuario.getUsername());
		try {
			respuesta = gestorDocumentalServicioDocumentosApi.descargarDocumento(Long.valueOf(adjuntoId), usuPass);
		} catch (NumberFormatException e) {
			logger.error("bajarAdjuntoAsunto error: " + e);
		} catch (GestorDocumentalException e) {
			logger.error("bajarAdjuntoAsunto error: " + e);
		}
		try {
			return GestorDocToRecoveryAssembler.getFileItem(respuesta);
		} catch (IOException e) {
			logger.error("bajarAdjuntoAsunto error: " + e);
		}
		return null;
	}
	
	private String getUsuarioGestorDocumental() {
		Parametrizacion parametro = proxyFactory.proxy(ParametrizacionApi.class).buscarParametroPorNombre(Parametrizacion.GESTOR_DOCUMENTAL_REST_CLIENT_USUARIO);
		return parametro.getValor();
	}
	
	private String getPasswordGestorDocumental() {
		Parametrizacion parametro = proxyFactory.proxy(ParametrizacionApi.class).buscarParametroPorNombre(Parametrizacion.GESTOR_DOCUMENTAL_REST_CLIENT_PASSWORD);
		return parametro.getValor();
	}
	
	/**
	 * Busca si NO hay contenedor para el tipo de prc.
	 * @param prc
	 *  @return false - No se ha de crear contenedor ||| true - Hay que crear un contenedor para el TIPO de prc
	 */
	public boolean buscarTPRCsinContenedor(Procedimiento prc) {
		
		boolean resultado = false;
		
		String claseExpe = cajamarHreProjectContext.getMapaClasesExpeGesDoc().get(prc.getTipoProcedimiento().getCodigo());
		if(Checks.esNulo(claseExpe) || claseExpe=="")
		{
			//Para este tipo de procedimiento no se requiere contendor
			return false;
		}
		ContenedorGestorDocumental contenedor = genericDao.get(ContenedorGestorDocumental.class, genericDao.createFilter(FilterType.EQUALS, "asunto", prc.getAsunto()), genericDao.createFilter(FilterType.EQUALS, "codigoClase", claseExpe));
		
		if(Checks.esNulo(contenedor)) {
			//Se requiere contenedor y no existe actualmente
			resultado = true;
		}
		
		return resultado;		
	}
	
	/**
	 * Devuelve un lista de la clase de expediente que contiene el asunto ordenada por su fecha de creación
	 * @param asu
	 * @return
	 */
	private List<String> getContenedoresByAsunto(Long idAsunto) {
		Order order = new Order(OrderType.DESC, "auditoria.fechaCrear");
		List<ContenedorGestorDocumental> listaContenedor = genericDao.getListOrdered(ContenedorGestorDocumental.class, order ,genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto));
		List<String> listaClaseExp = new ArrayList<String>();
		
		for(ContenedorGestorDocumental contenedor : listaContenedor) {
			listaClaseExp.add(contenedor.getCodigoClase());
		}
		
		return listaClaseExp;
	}
	
	 private String uploadDoc(String tipoEntidad, WebFileItem uploadForm, Long idDocumento) {
		String tipoDocumento = "";
		
		Integer max = getLimiteFichero(tipoEntidad);
		if (uploadForm.getFileItem().getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }
		
		if(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad) || DDTipoEntidad.CODIGO_ENTIDAD_PERSONA.equals(tipoEntidad) || DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad)) {
			tipoDocumento = uploadForm.getParameter("comboTipoDoc");
			DDTipoAdjuntoEntidad tpoAdjEnt = genericDao.get(DDTipoAdjuntoEntidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
			if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
				Expediente expediente = expedienteDao.get(Long.parseLong(uploadForm.getParameter("id")));
				AdjuntoExpediente adjuntoexp = new AdjuntoExpediente(uploadForm.getFileItem(), tpoAdjEnt);
				adjuntoexp.setExpediente(expediente);
				genericDao.save(AdjuntoExpediente.class, adjuntoexp);
			} else if (DDTipoEntidad.CODIGO_ENTIDAD_PERSONA.equals(tipoEntidad)) {
				Persona persona = personaDao.get(Long.parseLong(uploadForm.getParameter("id")));
				AdjuntoPersona adjPers = new AdjuntoPersona(uploadForm.getFileItem(),tpoAdjEnt);
				adjPers.setPersona(persona);
				genericDao.save(AdjuntoPersona.class, adjPers);
			} else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad)) {
				Contrato contrato = contratoDao.get(Long.parseLong(uploadForm.getParameter("id")));
				AdjuntoContrato adjCnt = new AdjuntoContrato(uploadForm.getFileItem(),tpoAdjEnt);
				adjCnt.setContrato(contrato);
				genericDao.save(AdjuntoContrato.class, adjCnt);
			}
		}else{
			tipoDocumento = uploadForm.getParameter("comboTipoFichero");
			DDTipoFicheroAdjunto tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", tipoDocumento));
			EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(uploadForm.getFileItem());
			adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
			adjuntoAsunto.setServicerId(idDocumento);
			if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad)) {
				Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(Long.parseLong(uploadForm.getParameter("id")));
				adjuntoAsunto.setAsunto(asunto);
			} else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad)) {
				Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(Long.parseLong(uploadForm.getParameter("id")));
				adjuntoAsunto.setAsunto(prc.getAsunto());
				adjuntoAsunto.setProcedimiento(prc);
			}
			genericDao.save(EXTAdjuntoAsunto.class, adjuntoAsunto);
		}
		return null;
	}
	 
	 private Integer getLimiteFichero(String tipoEntidad) {
		 String limite = "";
		 if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad) || DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad)) {
			 limite = Parametrizacion.LIMITE_FICHERO_ASUNTO;
		 }else if(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
			 limite = Parametrizacion.LIMITE_FICHERO_EXPEDIENTE;
		 }else if(DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad)) {
			 limite = Parametrizacion.LIMITE_FICHERO_CONTRATO;
		 }else if(DDTipoEntidad.CODIGO_ENTIDAD_PERSONA.equals(tipoEntidad)) {
			 limite = Parametrizacion.LIMITE_FICHERO_PERSONA;
		 }
			 
		try {
		    Parametrizacion param = (Parametrizacion) executor.execute(
		            ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, limite);
		    return Integer.valueOf(param.getValor());
		} catch (Exception e) {
		    logger.warn("No esta parametrizado el l�mite m�ximo del fichero en bytes para asuntos, se toma un valor por defecto (2Mb)");
		    return new Integer(2 * 1024 * 1024);
		}
	 }
	
	 private Set<EXTAdjuntoDto> creaObjetosEXTAsuntos(final Set<AdjuntoAsunto> adjuntos, final Usuario usuario, final Boolean borrarOtrosUsu) {
			if (adjuntos == null)
				return null;

			HashSet<EXTAdjuntoDto> result = new HashSet<EXTAdjuntoDto>();

			for (final AdjuntoAsunto aa : adjuntos) {
				EXTAdjuntoDto dto = new EXTAdjuntoDto() {
					@Override
					public Boolean getPuedeBorrar() {
						if (borrarOtrosUsu || aa.getAuditoria().getUsuarioCrear().equals(usuario.getUsername())) {
							return true;
						} else {
							return false;
						}
					}

					@Override
					public AdjuntoAsunto getAdjunto() {
						return (AdjuntoAsunto) aa;
					}

					@Override
					public String getTipoDocumento() {
						if (aa instanceof EXTAdjuntoAsunto) {
							if (((EXTAdjuntoAsunto) aa).getTipoFichero() != null)
								return ((EXTAdjuntoAsunto) aa).getTipoFichero().getDescripcion();
							else
								return "";
						} else
							return "";

					}

					@Override
					public Long prcId() {
						if (aa instanceof EXTAdjuntoAsunto) {
							if(((EXTAdjuntoAsunto) aa).getProcedimiento() != null)
								return ((EXTAdjuntoAsunto) aa).getProcedimiento().getId();
							else 
								return null;
						}
						else 
							return null;
					}

					@Override
					public String getRefCentera() {
						if(aa.getServicerId() != null) {
							return aa.getServicerId().toString();
						}
						return null;
					}

					@Override
					public String getNombreTipoDoc() {
						// TODO Auto-generated method stub
						return null;
					}
				};
				result.add(dto);
			}
			return result;
		}	
		 
	 
}
