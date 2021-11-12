package es.pfsgroup.plugin.rem.gencat;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatAdjuntoDao;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatDao;
import es.pfsgroup.plugin.rem.activo.dao.HistoricoComunicacionGencatAdjuntoDao;
import es.pfsgroup.plugin.rem.activo.dao.NotificacionGencatDao;
import es.pfsgroup.plugin.rem.activo.dao.VisitaGencatDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.AdecuacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.NotificacionGencatApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.OfertaGencatApi;
import es.pfsgroup.plugin.rem.api.ReclamacionGencatApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.VisitaGencatApi;
import es.pfsgroup.plugin.rem.gastosExpediente.dao.GastosExpedienteDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.AdecuacionGencat;
import es.pfsgroup.plugin.rem.model.AdjuntoComunicacion;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ComunicacionGencatAdjunto;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAltaVisita;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoGencat;
import es.pfsgroup.plugin.rem.model.DtoGencatSave;
import es.pfsgroup.plugin.rem.model.DtoHistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoNotificacionActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasAsociadasActivo;
import es.pfsgroup.plugin.rem.model.DtoReclamacionActivo;
import es.pfsgroup.plugin.rem.model.DtoTiposDocumentoComunicacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoAdecuacionGencat;
import es.pfsgroup.plugin.rem.model.HistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.HistoricoComunicacionGencatAdjunto;
import es.pfsgroup.plugin.rem.model.HistoricoNotificacionGencat;
import es.pfsgroup.plugin.rem.model.HistoricoOfertaGencat;
import es.pfsgroup.plugin.rem.model.HistoricoReclamacionGencat;
import es.pfsgroup.plugin.rem.model.HistoricoVisitaGencat;
import es.pfsgroup.plugin.rem.model.NotificacionGencat;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;
import es.pfsgroup.plugin.rem.model.RelacionHistoricoComunicacion;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VExpPreBloqueoGencat;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.VisitaGencat;
import es.pfsgroup.plugin.rem.model.dd.ActivoAdmisionRevisionTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDCedulaHabitabilidad;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSancionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDSistemaOrigen;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoComunicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoNotificacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.rest.dto.SalesforceAuthDto;
import es.pfsgroup.plugin.rem.rest.dto.SalesforceResponseDto;
import es.pfsgroup.plugin.rem.rest.salesforce.api.SalesforceApi;
import es.pfsgroup.plugin.rem.tramitacionofertas.TramitacionOfertasManager;


@Service("gencatManager")
public class GencatManager extends  BusinessOperationOverrider<GencatApi> implements GencatApi {
	
	protected static final Log logger = LogFactory.getLog(GencatManager.class);
	
	public static final String DD_TIPO_DOCUMENTO_CODIGO_NIF = "15";
	
	private SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	//Errores
	private static final  String ERROR_FALTA_VISITA = "El método no se ha invocado correctamente. Hay que enviar una visita.";
	private static final String ERROR_FALTA_IDACTIVO = "Falta el ID del activo.";
	private static final String ERROR_FALTA_NOMBRE = "Nombre es un campo obligatorio.";
	private static final String ERROR_FALTA_TELEFONO = "Teléfono es un campo obligatorio.";
	private static final String ERROR_FALTA_EMAIL = "Email es un campo obligatorio.";
	private static final String ERROR_FALTA_COMUNICACION = "El activo no tiene ninguna comunicación asociada.";
	private static final String ERROR_YA_HAY_VISITA = "Ya se ha solicitado una visita previamente.";

	private static final Float PRECIO_REFORMA_ADECUACION = 52.3f;
	
	@Autowired
	private NotificacionesGencatManager notificacionesGencat;
			
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private ComunicacionGencatAdjuntoDao comunicacionGencatAdjuntoDao;
	
	@Autowired
	private HistoricoComunicacionGencatAdjuntoDao historicoComunicacionGencatAdjuntoDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private NotificacionGencatDao notificacionGencatDao;
	
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private ComunicacionGencatDao comunicacionGencatDao;
		
	@Autowired
	private AdecuacionGencatApi adecuacionGencatApi;
	
	@Autowired
	private OfertaGencatApi ofertaGencatApi;
	
	@Autowired
	private NotificacionGencatApi notificacionGencatApi;
	
	@Autowired
	private ReclamacionGencatApi reclamacionGencatApi;
	
	@Autowired
	private VisitaGencatApi visitaGencatApi;
	
	@Autowired 
	private OfertaApi ofertaApi;

	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	protected JBPMActivoTramiteManager jbpmActivoTramiteManager;
	
	@Autowired
	protected TipoProcedimientoManager tipoProcedimientoManager;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	protected ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	protected GastosExpedienteDao gastosExpedienteDao;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;
	
	@Autowired
	private SalesforceApi salesforceManager;

	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private VisitaGencatDao visitaGencatDao;
	
	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;
	
	@Autowired
	private TramitacionOfertasManager tramitacionOfertasManager;
	
	@Override
	public DtoGencat getDetalleGencatByIdActivo(Long idActivo) {
		DtoGencat gencatDto = new DtoGencat();
		
		Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		//Datos comunicación 
		List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
		
		ComunicacionGencat comunicacionGencat = null;
		if (resultComunicacion != null && !resultComunicacion.isEmpty()) {
			comunicacionGencat = resultComunicacion.get(0);
		}
		
		
		
		if (comunicacionGencat != null) {
			try {
				// Comrpueba que los datos minimos del usuario nuevo esten completos
				if (!Checks.esNulo(comunicacionGencat.getNuevoCompradorNif()) && !Checks.esNulo(comunicacionGencat.getNuevoCompradorNombre())) {
					gencatDto.setUsuarioCompleto(true);
				} else {
					gencatDto.setUsuarioCompleto(false);
				}
				
				BeanUtils.copyProperties(gencatDto, comunicacionGencat);
				gencatDto.setSancion(comunicacionGencat.getSancion() != null ? comunicacionGencat.getSancion().getCodigo() : null);
				gencatDto.setEstadoComunicacion(comunicacionGencat.getEstadoComunicacion() != null ? comunicacionGencat.getEstadoComunicacion().getCodigo() : null);
				gencatDto.setComunicadoAnulacionAGencat2(comunicacionGencat.getComunicadoAnulacionAGencat());
				gencatDto.setIdComunicacion(comunicacionGencat.getId());
				Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", comunicacionGencat.getId());
				
				//Adecuacion
				List <AdecuacionGencat> resultAdecuacion = genericDao.getListOrdered(AdecuacionGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultAdecuacion != null && !resultAdecuacion.isEmpty()) {
					AdecuacionGencat adecuacionGencat = resultAdecuacion.get(0);
					BeanUtils.copyProperties(gencatDto, adecuacionGencat);
					gencatDto.setNecesitaReforma(adecuacionGencat.getNecesitaReforma());
				}
				
				//Visita
				List <VisitaGencat> resultVisitaGencat = genericDao.getListOrdered(VisitaGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultVisitaGencat != null && !resultVisitaGencat.isEmpty()) {
					VisitaGencat visitaGencat = resultVisitaGencat.get(0);
					Visita visita = visitaGencat.getVisita();
					if (visita != null) {
						gencatDto.setIdVisita(visita.getNumVisitaRem());
						gencatDto.setEstadoVisita(visita.getEstadoVisita() != null ? visita.getEstadoVisita().getCodigo() : null);
						gencatDto.setFechaRealizacionVisita(visita.getFechaVisita());
						
						Usuario mediador = visita.getUsuarioAccion();
						if (mediador != null) {
							gencatDto.setApiRealizaLaVisita(mediador.getApellidoNombre());
						}
						
					}
					gencatDto.setIdLeadSF(visitaGencat.getIdLeadSF());
				}
				if(!Checks.esNulo(gencatDto.getSancion()) && DDSancionGencat.COD_EJERCE.equals(gencatDto.getSancion())) {
					List<OfertaGencat> ofertasGencatActivo = genericDao.getList(OfertaGencat.class, filtroIdComunicacion);
					
					for(OfertaGencat ofertaGencat: ofertasGencatActivo) {
						if(!Checks.esNulo(ofertaGencat) && !Checks.esNulo(ofertaGencat.getIdOfertaAnterior()) && !Checks.esNulo(ofertaGencat.getOferta())
								&& DDEstadoOferta.CODIGO_ACEPTADA.equals(ofertaGencat.getOferta().getEstadoOferta().getCodigo())) {
							gencatDto.setOfertaGencat(ofertaGencat.getOferta().getNumOferta());
							break;
						}
					}
				}
			}
			catch (IllegalAccessException e) {
				logger.error("Error en gencatManager", e);
			}
			catch (InvocationTargetException e) {
				logger.error("Error en gencatManager", e);
			}
		}
		
		return gencatDto;
	}

	@Override
	public String managerName() {
		return "gencatManager";
	}
	
	@Override
	public List<DtoOfertasAsociadasActivo> getOfertasAsociadasByIdActivo(Long idActivo) {

		List<DtoOfertasAsociadasActivo> listaDtoOfertasAsociadasActivo = new ArrayList<DtoOfertasAsociadasActivo>();
		
		Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		//Datos comunicación
		List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
		ComunicacionGencat comunicacionGencat = null;
		if (resultComunicacion != null && !resultComunicacion.isEmpty()) {
			comunicacionGencat = resultComunicacion.get(0);
		}
		
		if (comunicacionGencat != null) {
			Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", comunicacionGencat.getId());
			
			//Oferta
			List<OfertaGencat> listaOfertasGencat = genericDao.getList(OfertaGencat.class, filtroIdComunicacion, filtroBorrado);
			DtoOfertasAsociadasActivo dtoOfertasAsociadasActivo;
			for (int i = 0; i < listaOfertasGencat.size(); i++) {
				dtoOfertasAsociadasActivo = new DtoOfertasAsociadasActivo();
				
				OfertaGencat ofertaGencat = listaOfertasGencat.get(i);
				Oferta oferta = ofertaGencat.getOferta();
				
				dtoOfertasAsociadasActivo.setFechaPreBloqueo(comunicacionGencat.getFechaPreBloqueo());
				dtoOfertasAsociadasActivo.setNumOferta(oferta.getNumOferta());
				dtoOfertasAsociadasActivo.setImporteOferta(ofertaGencat.getImporte());
				if (!Checks.esNulo(ofertaGencat.getTiposPersona())) {
					dtoOfertasAsociadasActivo.setTipoComprador(ofertaGencat.getTiposPersona().getDescripcion());
				}
				if (!Checks.esNulo(ofertaGencat.getSituacionPosesoria())) {
					dtoOfertasAsociadasActivo.setSituacionOcupacional(ofertaGencat.getSituacionPosesoria().getDescripcion());
				}
				
				listaDtoOfertasAsociadasActivo.add(dtoOfertasAsociadasActivo);
			}
		}
		
		return listaDtoOfertasAsociadasActivo;

	}
	
	@Override
	public List<DtoReclamacionActivo> getReclamacionesByIdActivo(Long idActivo) {
		
		List<DtoReclamacionActivo> listaReclamacion = new ArrayList<DtoReclamacionActivo>();
		
		Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		//Datos comunicación
		List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
		ComunicacionGencat comunicacionGencat = null;
		if (resultComunicacion != null && !resultComunicacion.isEmpty()) {
			comunicacionGencat = resultComunicacion.get(0);
		}
		
		if (comunicacionGencat != null) {
			try {
				Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", comunicacionGencat.getId());
				Order orderByFechaAviso = new Order(OrderType.DESC, "fechaAviso");
				
				//Reclamacion
				List<ReclamacionGencat> listaReclamacionGencat = genericDao.getListOrdered(ReclamacionGencat.class, orderByFechaAviso, filtroIdComunicacion, filtroBorrado);
				DtoReclamacionActivo dtoReclamacionActivo;
				for (int i = 0; i < listaReclamacionGencat.size(); i++) {
					dtoReclamacionActivo = new DtoReclamacionActivo();
					BeanUtils.copyProperties(dtoReclamacionActivo, listaReclamacionGencat.get(i));
					listaReclamacion.add(dtoReclamacionActivo);
				}
			}
			catch (IllegalAccessException e) {
				logger.error("Error en gencatManager", e);
			}
			catch (InvocationTargetException e) {
				logger.error("Error en gencatManager", e);
			}
		}
		
		return listaReclamacion;
		
	}
	
	@Override
	public List<DtoAdjunto> getListAdjuntosComunicacionByIdActivo(Long idActivo) throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		
		Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		//Datos comunicación
		List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
		ComunicacionGencat comunicacionGencat = null;
		if (!Checks.esNulo(resultComunicacion) && !resultComunicacion.isEmpty()) {
			comunicacionGencat = resultComunicacion.get(0);
		}
		
		if (comunicacionGencat != null) {
			
			//if... gestor documental activado
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				try {
					listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosComunicacionGencat(comunicacionGencat);
				} catch (GestorDocumentalException gex) {
					String[] error = gex.getMessage().split("-");
					if (error.length > 0 &&  (error[2].trim().contains("Error al obtener el activo, no existe"))) {
						Usuario usuario = genericAdapter.getUsuarioLogado();
						Integer idExp;
						try{
							idExp = gestorDocumentalAdapterApi.crearContenedorComunicacionGencat(comunicacionGencat,usuario.getUsername());
							logger.debug("GESTOR DOCUMENTAL [ crearExpediente para " + comunicacionGencat.getId() + "]: ID EXPEDIENTE RECIBIDO " + idExp);
						} catch (GestorDocumentalException gexc) {
							logger.debug(gexc.getMessage(),gexc);
						}
	
					}
					try {
						throw gex;
					} catch (GestorDocumentalException e) {
						logger.error(e.getMessage(),e);
					}
				}
			} 
			else {
				listaAdjuntos = getAdjuntosComunicacion(idActivo, comunicacionGencat, listaAdjuntos);
			}
			
		}
		
		return listaAdjuntos;
		
	}
	
	private List<DtoAdjunto> getAdjuntosComunicacion(Long idActivo, ComunicacionGencat comunicacion, List<DtoAdjunto> listaAdjuntos) 
			throws IllegalAccessException, InvocationTargetException {
			List<AdjuntoComunicacion> listaAdjuntosComunicacion = genericDao.getList(AdjuntoComunicacion.class , genericDao.createFilter(FilterType.EQUALS, "comunicacionGencat.id", comunicacion.getId()),genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false));
			
			if (!Checks.estaVacio(listaAdjuntosComunicacion)) {
				for (AdjuntoComunicacion adjunto : listaAdjuntosComunicacion) {
					DtoAdjunto dto = new DtoAdjunto();
					BeanUtils.copyProperties(dto, adjunto);
					dto.setIdEntidad(idActivo);
					dto.setDescripcionTipo(adjunto.getTipoDocumentoComunicacion().getDescripcion());
					dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());
					dto.setCreateDate(adjunto.getFechaDocumento());
					listaAdjuntos.add(dto);
				}
			}

		return listaAdjuntos;
	}
	

	
	@Override
	public List<DtoHistoricoComunicacionGencat> getHistoricoComunicacionesByIdActivo(Long idActivo) {
		
		List<DtoHistoricoComunicacionGencat> listaHistoricoComunicaciones = new ArrayList<DtoHistoricoComunicacionGencat>();
		
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false); 
		Order orderByFechaPreBloqueo = new Order(OrderType.DESC, "fechaPreBloqueo");
		
		//Datos del histórico de comunicaciones
		try {
			List <HistoricoComunicacionGencat> resultHistoricoComunicaciones = genericDao.getListOrdered(HistoricoComunicacionGencat.class, orderByFechaPreBloqueo, filtroIdActivo, filtroBorrado);
			DtoHistoricoComunicacionGencat dtoHistoricoComunicacion = null;
			for (int i = 0; i < resultHistoricoComunicaciones.size(); i++) {
				dtoHistoricoComunicacion = new DtoHistoricoComunicacionGencat();
				BeanUtils.copyProperties(dtoHistoricoComunicacion, resultHistoricoComunicaciones.get(i));
				dtoHistoricoComunicacion.setSancion(resultHistoricoComunicaciones.get(i).getSancion() != null ? resultHistoricoComunicaciones.get(i).getSancion().getDescripcion() : null);
				dtoHistoricoComunicacion.setEstadoComunicacion(resultHistoricoComunicaciones.get(i).getEstadoComunicacion() != null ? resultHistoricoComunicaciones.get(i).getEstadoComunicacion().getDescripcion() : null);
				dtoHistoricoComunicacion.setFechaPreBloqueo(resultHistoricoComunicaciones.get(i).getFechaPreBloqueo());
				listaHistoricoComunicaciones.add(dtoHistoricoComunicacion);
			}
		}
		catch (IllegalAccessException e) {
			logger.error("Error en gencatManager", e);
		}
		catch (InvocationTargetException e) {
			logger.error("Error en gencatManager", e);
		}
		
		return listaHistoricoComunicaciones;
		
	}
	
	@Override
	public DtoGencat getDetalleHistoricoByIdComunicacionHistorico(Long idComunicacionHistorico) {
		DtoGencat gencatDto = new DtoGencat();
		
		Filter filtroHComunicacionId = genericDao.createFilter(FilterType.EQUALS, "id", idComunicacionHistorico);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		//Datos historico de la comunicación
		HistoricoComunicacionGencat hComunicacionGencat = genericDao.get(HistoricoComunicacionGencat.class, filtroHComunicacionId, filtroBorrado);
		
		if (hComunicacionGencat != null) {
			try {
				
				// Comrpueba que los datos minimos del usuario nuevo esten completos
				if (!Checks.esNulo(hComunicacionGencat.getNifComprador()) && !Checks.esNulo(hComunicacionGencat.getNombreComprador())) {
					gencatDto.setUsuarioCompleto(true);
				} else {
					gencatDto.setUsuarioCompleto(false);
				}
				
				BeanUtils.copyProperties(gencatDto, hComunicacionGencat);
				if(!Checks.esNulo(hComunicacionGencat.getSancion())) {
					gencatDto.setSancion(hComunicacionGencat.getSancion().getDescripcion());
				}
				if(!Checks.esNulo(hComunicacionGencat.getEstadoComunicacion())) {
					gencatDto.setEstadoComunicacion(hComunicacionGencat.getEstadoComunicacion().getDescripcion());
				}
				if(!Checks.esNulo(hComunicacionGencat.getFechaPrevSancion())) {
					gencatDto.setFechaPrevistaSancion(hComunicacionGencat.getFechaPrevSancion());
				}
				if(!Checks.esNulo(hComunicacionGencat.getNifComprador())) {
					gencatDto.setNuevoCompradorNif(hComunicacionGencat.getNifComprador());
				}
				if(!Checks.esNulo(hComunicacionGencat.getNombreComprador())) {
					gencatDto.setNuevoCompradorNombre(hComunicacionGencat.getNombreComprador());
				}
				if(!Checks.esNulo(hComunicacionGencat.getCompradorApellido1())) {
					gencatDto.setNuevoCompradorApellido1(hComunicacionGencat.getCompradorApellido1());
				}
				if(!Checks.esNulo(hComunicacionGencat.getCompradorApellido2())) {
					gencatDto.setNuevoCompradorApellido2(hComunicacionGencat.getCompradorApellido2());
				}
				if(!Checks.esNulo(hComunicacionGencat.getSancion())) {
					if(!DDSancionGencat.COD_EJERCE.equals(hComunicacionGencat.getSancion().getCodigo())) {
						gencatDto.setOfertaGencat(null);
					}
				}
				if(!Checks.esNulo(hComunicacionGencat.getAnulacion())) {
					gencatDto.setComunicadoAnulacionAGencat(hComunicacionGencat.getAnulacion());
				}
				
				
				Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "historicoComunicacion.id", hComunicacionGencat.getId());
				Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
				
				//Adecuacion
				HistoricoAdecuacionGencat adecuacionGencat = genericDao.get(HistoricoAdecuacionGencat.class, filtroIdComunicacion, filtroBorrado);
				if (!Checks.esNulo(adecuacionGencat)) {
					if (!Checks.esNulo(adecuacionGencat.getNecesitaReforma())) {
						gencatDto.setNecesitaReforma(adecuacionGencat.getNecesitaReforma());
					}
					if (!Checks.esNulo(adecuacionGencat.getImporteReforma())) {
						gencatDto.setImporteReforma(adecuacionGencat.getImporteReforma());
					} else {
						gencatDto.setImporteReforma(0.00);
					}
					if (!Checks.esNulo(adecuacionGencat.getFechaRevision())) {
						gencatDto.setFechaRevision(adecuacionGencat.getFechaRevision());
					}
				}
				
				//Visita
				List <HistoricoVisitaGencat> resultVisitaGencat = genericDao.getListOrdered(HistoricoVisitaGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultVisitaGencat != null && !resultVisitaGencat.isEmpty()) {
					HistoricoVisitaGencat visitaGencat = resultVisitaGencat.get(0);
					Visita visita = visitaGencat.getVisita();
					if (visita != null) {
						gencatDto.setIdVisita(visita.getNumVisitaRem());
						gencatDto.setEstadoVisita(visita.getEstadoVisita() != null ? visita.getEstadoVisita().getCodigo() : null);
						gencatDto.setFechaRealizacionVisita(visita.getFechaVisita());
						
						Usuario mediador = visita.getUsuarioAccion();
						if (mediador != null) {
							gencatDto.setApiRealizaLaVisita(mediador.getApellidoNombre());
						}
					}
				}
				
				//Oferta
				List <HistoricoOfertaGencat> resultOfertaGencatGencat = genericDao.getListOrdered(HistoricoOfertaGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultOfertaGencatGencat != null && !resultOfertaGencatGencat.isEmpty()) {
					HistoricoOfertaGencat ofertaGencat = resultOfertaGencatGencat.get(0);
					Oferta oferta = ofertaGencat.getOferta();
					if (oferta != null) {
						if(!Checks.esNulo(hComunicacionGencat.getSancion())) {
							if(DDSancionGencat.COD_EJERCE.equals(hComunicacionGencat.getSancion().getCodigo())) {
								gencatDto.setOfertaGencat(oferta.getNumOferta());
							}else {
								gencatDto.setOfertaGencat(null);
							}
						}else {
							gencatDto.setOfertaGencat(null);
						}
					}
				}
				
			}
			catch (IllegalAccessException e) {
				logger.error("Error en gencatManager", e);
			}
			catch (InvocationTargetException e) {
				logger.error("Error en gencatManager", e);
			}
		}
		
		return gencatDto;
	}
	
	@Override
	public List<DtoOfertasAsociadasActivo> getHistoricoOfertasAsociadasIdComunicacionHistorico(Long idComunicacionHistorico) {

		List<DtoOfertasAsociadasActivo> listaDtoOfertasAsociadasActivo = new ArrayList<DtoOfertasAsociadasActivo>();
		
		Filter filtroHComunicacionId = genericDao.createFilter(FilterType.EQUALS, "id", idComunicacionHistorico);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		//Datos historico de la comunicación
		HistoricoComunicacionGencat hComunicacionGencat = genericDao.get(HistoricoComunicacionGencat.class, filtroHComunicacionId, filtroBorrado);
		
		if (hComunicacionGencat != null) {
			Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "historicoComunicacion.id", hComunicacionGencat.getId());
			
			//Oferta
			List<HistoricoOfertaGencat> listaOfertasGencat = genericDao.getList(HistoricoOfertaGencat.class, filtroIdComunicacion, filtroBorrado);
			DtoOfertasAsociadasActivo dtoOfertasAsociadasActivo;
			for (int i = 0; i < listaOfertasGencat.size(); i++) {
				dtoOfertasAsociadasActivo = new DtoOfertasAsociadasActivo();
				
				HistoricoOfertaGencat ofertaGencat = listaOfertasGencat.get(i);
				Oferta oferta = ofertaGencat.getOferta();
				if(!Checks.esNulo(ofertaGencat)) {
					dtoOfertasAsociadasActivo.setImporteOferta(ofertaGencat.getImporte());
					if(!Checks.esNulo(ofertaGencat.getTiposPersona())){
						dtoOfertasAsociadasActivo.setTipoComprador(ofertaGencat.getTiposPersona().getDescripcion());
					}
					if(!Checks.esNulo(ofertaGencat.getSituacionPosesoria())){
						dtoOfertasAsociadasActivo.setSituacionOcupacional(ofertaGencat.getSituacionPosesoria().getDescripcion());
					}
				}
				if(!Checks.esNulo(oferta)) {
					dtoOfertasAsociadasActivo.setNumOferta(oferta.getNumOferta());
				}
				if(!Checks.esNulo(hComunicacionGencat)) {
					dtoOfertasAsociadasActivo.setFechaPreBloqueo(hComunicacionGencat.getFechaPreBloqueo());
				}
				listaDtoOfertasAsociadasActivo.add(dtoOfertasAsociadasActivo);
			}
		}
		
		return listaDtoOfertasAsociadasActivo;

	}
	
	@Override
	public List<DtoReclamacionActivo> getHistoricoReclamacionesByIdComunicacionHistorico(Long idComunicacionHistorico) {
		
		List<DtoReclamacionActivo> listaReclamacion = new ArrayList<DtoReclamacionActivo>();
		
		Filter filtroHComunicacionId = genericDao.createFilter(FilterType.EQUALS, "id", idComunicacionHistorico);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		//Datos historico de la comunicación
		HistoricoComunicacionGencat hComunicacionGencat = genericDao.get(HistoricoComunicacionGencat.class, filtroHComunicacionId, filtroBorrado);
		
		if (hComunicacionGencat != null) {
			try {
				Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "historicoComunicacion.id", hComunicacionGencat.getId());
				Order orderByFechaAviso = new Order(OrderType.DESC, "fechaAviso");
				
				//Reclamacion
				List<HistoricoReclamacionGencat> listaReclamacionGencat = genericDao.getListOrdered(HistoricoReclamacionGencat.class, orderByFechaAviso, filtroIdComunicacion, filtroBorrado);
				DtoReclamacionActivo dtoReclamacionActivo;
				for (int i = 0; i < listaReclamacionGencat.size(); i++) {
					dtoReclamacionActivo = new DtoReclamacionActivo();
					BeanUtils.copyProperties(dtoReclamacionActivo, listaReclamacionGencat.get(i));
					listaReclamacion.add(dtoReclamacionActivo);
				}
			}
			catch (IllegalAccessException e) {
				logger.error("Error en gencatManager", e);
			}
			catch (InvocationTargetException e) {
				logger.error("Error en gencatManager", e);
			}
		}
		
		return listaReclamacion;
		
	}
	
	@Override
	public List<DtoAdjunto> getListAdjuntosComunicacionHistoricoByIdComunicacionHistorico(Long idComunicacionHistorico) throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		
		Filter filtroHComunicacionId = genericDao.createFilter(FilterType.EQUALS, "id", idComunicacionHistorico);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		//Datos historico de la comunicación
		HistoricoComunicacionGencat hComunicacionGencat = genericDao.get(HistoricoComunicacionGencat.class, filtroHComunicacionId, filtroBorrado);
		
		if (!Checks.esNulo(hComunicacionGencat)) {
			
			//if... gestor documental activado
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosComunicacionGencat(null, hComunicacionGencat);
			} 
			else {
				listaAdjuntos = getAdjuntosComunicacionHistorico(hComunicacionGencat, listaAdjuntos);
			}
			
		}
		
		return listaAdjuntos;
		
	}
	
	private List<DtoAdjunto> getAdjuntosComunicacionHistorico(HistoricoComunicacionGencat hComunicacionGencat, List<DtoAdjunto> listaAdjuntos) 
			throws IllegalAccessException, InvocationTargetException {
		
		List<AdjuntoComunicacion> adjuntos = genericDao.getList(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "historicoComunicacionGencat", hComunicacionGencat), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		
		for (AdjuntoComunicacion adjunto : adjuntos) {
			DtoAdjunto dto = new DtoAdjunto();

			BeanUtils.copyProperties(dto, adjunto);
			dto.setIdEntidad(hComunicacionGencat.getActivo().getId());
			dto.setDescripcionTipo(adjunto.getTipoDocumentoComunicacion().getDescripcion());
			dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());

			listaAdjuntos.add(dto);
		}
		return listaAdjuntos;
	}
	
	@Override
	@Transactional(readOnly = false)
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, Activo activoEntrada, String matricula, Usuario usuarioLogado, ComunicacionGencat comunicacionGencat) throws Exception {
		Activo activo = null;
		DDTipoDocumentoComunicacion tipoDocumento = null;
		if (Checks.esNulo(activoEntrada)) {
			activo = activoApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));

			if (webFileItem.getParameter("tipo") == null)
				throw new Exception("Tipo no valido");

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			tipoDocumento = genericDao.get(DDTipoDocumentoComunicacion.class, filtro);
			
		} else {
			activo = activoEntrada;
			if (!Checks.esNulo(matricula)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				tipoDocumento = genericDao.get(DDTipoDocumentoComunicacion.class, filtro);
			}
			if (tipoDocumento == null) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				tipoDocumento = genericDao.get(DDTipoDocumentoComunicacion.class, filtro);
			}
		}

		try {
			if (!Checks.esNulo(activo) && !Checks.esNulo(tipoDocumento)) {


				AdjuntoComunicacion adjuntoComunicacion = new AdjuntoComunicacion();
				if(Checks.esNulo(idDocRestClient)){
					Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());
					adjuntoComunicacion.setAdjunto(adj);
				}
				
				if (!Checks.esNulo(webFileItem.getParameter("idHComunicacion"))) {
					HistoricoComunicacionGencat historicoComunicacionGencat = genericDao.get(HistoricoComunicacionGencat.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(webFileItem.getParameter("idHComunicacion"))));
					adjuntoComunicacion.setHistoricoComunicacionGencat(historicoComunicacionGencat);
				} else {
					adjuntoComunicacion.setComunicacionGencat(comunicacionGencat);
				}

				adjuntoComunicacion.setIdDocRestClient(idDocRestClient);

				adjuntoComunicacion.setTipoDocumentoComunicacion(tipoDocumento);

				adjuntoComunicacion.setContentType(webFileItem.getFileItem().getContentType());

				adjuntoComunicacion.setTamanyo(webFileItem.getFileItem().getLength());

				adjuntoComunicacion.setNombre(webFileItem.getFileItem().getFileName());

				adjuntoComunicacion.setDescripcion(webFileItem.getParameter("descripcion"));

				adjuntoComunicacion.setFechaDocumento(new Date());
				
				adjuntoComunicacion.setFechaNotificacion(new Date());

				genericDao.save(AdjuntoComunicacion.class, adjuntoComunicacion);
				String idHComunicacion = webFileItem.getParameter("idHComunicacion");
				
				agregarReferenciaComunicacionAdjunto(null, activo, usuarioLogado, idHComunicacion,comunicacionGencat,adjuntoComunicacion);
				
				return adjuntoComunicacion.getId().toString();
			} 
			else {
				throw new Exception("No se ha encontrado activo o tipo para relacionar adjunto");
			}
		} catch (Exception e) {
			logger.error("Error en gencatManager", e);
		}

		return null;

	}
	
	private void agregarReferenciaComunicacionAdjunto(Adjunto adjunto, Activo activo, Usuario usuarioLogado, String idHComunicacionString, ComunicacionGencat comunicacionGencat, AdjuntoComunicacion adjuntoComunicacion) {
		

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false); 
				
		if (!Checks.esNulo(idHComunicacionString)) {
			
			Long idHComunicacion = Long.parseLong(idHComunicacionString);
			
			Filter filtroHComunicacionId = genericDao.createFilter(FilterType.EQUALS, "id", idHComunicacion);
			
			//Datos de la comunicación del histórico
			HistoricoComunicacionGencat hComunicacionGencat = genericDao.get(HistoricoComunicacionGencat.class, filtroHComunicacionId, filtroBorrado);
			
			if (!Checks.esNulo(adjuntoComunicacion) && !Checks.esNulo(hComunicacionGencat)) {
				
				HistoricoComunicacionGencatAdjunto referenciaComunicacionHistoricoAdjunto = new HistoricoComunicacionGencatAdjunto();
				referenciaComunicacionHistoricoAdjunto.setAdjuntoComunicacion(adjuntoComunicacion);
				referenciaComunicacionHistoricoAdjunto.setHistoricoComunicacionGencat(hComunicacionGencat);
				
				Auditoria auditoria = new Auditoria();
				auditoria.setBorrado(false);
				auditoria.setFechaCrear(new Date());
				auditoria.setUsuarioCrear(usuarioLogado.getApellidoNombre());
				
				referenciaComunicacionHistoricoAdjunto.setVersion(new Long(0));
				referenciaComunicacionHistoricoAdjunto.setAuditoria(auditoria);
				
				historicoComunicacionGencatAdjuntoDao.save(referenciaComunicacionHistoricoAdjunto);
				
			}
			
		}
		else {
			
		
			if (!Checks.esNulo(adjuntoComunicacion) && !Checks.esNulo(comunicacionGencat)) {
				ComunicacionGencatAdjunto referenciaComunicacionAdjunto = new ComunicacionGencatAdjunto();
				referenciaComunicacionAdjunto.setAdjuntoComunicacion(adjuntoComunicacion);
				referenciaComunicacionAdjunto.setComunicacionGencat(comunicacionGencat);
				
				Auditoria auditoria = new Auditoria();
				auditoria.setBorrado(false);
				auditoria.setFechaCrear(new Date());
				auditoria.setUsuarioCrear(usuarioLogado.getApellidoNombre());
				
				referenciaComunicacionAdjunto.setVersion(new Long(0));
				referenciaComunicacionAdjunto.setAuditoria(auditoria);
				
				comunicacionGencatAdjuntoDao.save(referenciaComunicacionAdjunto);
			}
			
		}
		
	}
	
	@Override
	public List<DtoNotificacionActivo> getNotificacionesByIdActivo(Long idActivo) {
		
		List<DtoNotificacionActivo> listaNotificaciones = new ArrayList<DtoNotificacionActivo>();
		
		Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		//Datos comunicación
		List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
		ComunicacionGencat comunicacionGencat = null;
		if (resultComunicacion != null && !resultComunicacion.isEmpty()) {
			comunicacionGencat = resultComunicacion.get(0);
		}
		
		if (comunicacionGencat != null) {
			try {
				Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", comunicacionGencat.getId());
				
				//Notificaciones
				List<NotificacionGencat> listaNotificacionGencat = genericDao.getList(NotificacionGencat.class, filtroIdComunicacion, filtroBorrado);
				DtoNotificacionActivo dtoNotificacionActivo;
				for (int i = 0; i < listaNotificacionGencat.size(); i++) {
					dtoNotificacionActivo = new DtoNotificacionActivo();
					BeanUtils.copyProperties(dtoNotificacionActivo, listaNotificacionGencat.get(i));
					dtoNotificacionActivo.setMotivoNotificacion(listaNotificacionGencat.get(i).getTipoNotificacion() != null ? listaNotificacionGencat.get(i).getTipoNotificacion().getDescripcion() : null);
					if(!Checks.esNulo(listaNotificacionGencat.get(i).getAdjuntoComunicacion())) {
						dtoNotificacionActivo.setNombre(listaNotificacionGencat.get(i).getAdjuntoComunicacion().getNombre());
					}
					if(!Checks.esNulo(listaNotificacionGencat.get(i).getAdjuntoComunicacionSancion())) {
						dtoNotificacionActivo.setNombreSancion(listaNotificacionGencat.get(i).getAdjuntoComunicacionSancion().getNombre());
					}
					listaNotificaciones.add(dtoNotificacionActivo);
				}
			}
			catch (IllegalAccessException e) {
				logger.error("Error en gencatManager", e);
			}
			catch (InvocationTargetException e) {
				logger.error("Error en gencatManager", e);
			}
		}
		
		return listaNotificaciones;
		
	}
	
	@Override
	public List<DtoNotificacionActivo> getNotificacionesHistoricoByIdComunicacionHistorico(Long idComunicacionHistorico) {
		
		List<DtoNotificacionActivo> listaNotificaciones = new ArrayList<DtoNotificacionActivo>();
		
		Filter filtroHComunicacionId = genericDao.createFilter(FilterType.EQUALS, "id", idComunicacionHistorico);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		//Datos historico de la comunicación
		HistoricoComunicacionGencat hComunicacionGencat = genericDao.get(HistoricoComunicacionGencat.class, filtroHComunicacionId, filtroBorrado);
		
		if (hComunicacionGencat != null) {
			try {
				Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "historicoComunicacion.id", hComunicacionGencat.getId());
				
				//Reclamacion
				List<HistoricoNotificacionGencat> historicoNotificacionGencatlist = genericDao.getList(HistoricoNotificacionGencat.class, filtroIdComunicacion, filtroBorrado);
				DtoNotificacionActivo dtoNotificacionActivo;
				for (int i = 0; i < historicoNotificacionGencatlist.size(); i++) {
					dtoNotificacionActivo = new DtoNotificacionActivo();
					BeanUtils.copyProperties(dtoNotificacionActivo, historicoNotificacionGencatlist.get(i));
					dtoNotificacionActivo.setNombre(historicoNotificacionGencatlist.get(i).getAdjuntoComunicacion().getNombre());
					dtoNotificacionActivo.setMotivoNotificacion(historicoNotificacionGencatlist.get(i).getTipoNotificacion() != null ? historicoNotificacionGencatlist.get(i).getTipoNotificacion().getDescripcion() : null);
					if (!Checks.esNulo(historicoNotificacionGencatlist.get(i)) && !Checks.esNulo(historicoNotificacionGencatlist.get(i).getAdjuntoComunicacionSancion()) && !Checks.esNulo(historicoNotificacionGencatlist.get(i).getAdjuntoComunicacionSancion().getNombre())) {
						dtoNotificacionActivo.setNombreSancion(historicoNotificacionGencatlist.get(i).getAdjuntoComunicacionSancion().getNombre());
					}
					listaNotificaciones.add(dtoNotificacionActivo);
				}
			}
			catch (IllegalAccessException e) {
				logger.error("Error en gencatManager", e);
			}
			catch (InvocationTargetException e) {
				logger.error("Error en gencatManager", e);
			}
		}
		
		return listaNotificaciones;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public DtoNotificacionActivo createNotificacionComunicacion(DtoNotificacionActivo dtoNotificacion) {
		
		Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", dtoNotificacion.getIdActivo());
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		//Datos comunicación
		List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
		ComunicacionGencat comunicacionGencat = null;
		if (resultComunicacion != null && !resultComunicacion.isEmpty()) {
			comunicacionGencat = resultComunicacion.get(0);
		}
		
		if (comunicacionGencat != null) {
			try {
				
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				SimpleDateFormat dateformat3 = new SimpleDateFormat("dd/MM/yyyy");
				NotificacionGencat notificacion = new NotificacionGencat();
				
				if(!Checks.esNulo(dtoNotificacion.getId())){
					notificacion = genericDao.get(NotificacionGencat.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoNotificacion.getId()));
				}
				
				if(!Checks.esNulo(dtoNotificacion.getMotivoNotificacion())) {
					Filter filtroIdTipoNotificacion = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoNotificacion.getMotivoNotificacion());
					DDTipoNotificacionGencat tipoNotificacionGencat = genericDao.get(DDTipoNotificacionGencat.class, filtroIdTipoNotificacion, filtroBorrado);
					notificacion.setTipoNotificacion(tipoNotificacionGencat);
				}
				if(Checks.esNulo(dtoNotificacion.getId())) {
					if(!Checks.esNulo(dtoNotificacion.getIdDocumento())) {
						AdjuntoComunicacion adj = genericDao.get(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "id",Long.valueOf(dtoNotificacion.getIdDocumento())));
						notificacion.setAdjuntoComunicacion(adj);
					}
				}else {
					if(!Checks.esNulo(dtoNotificacion.getIdDocumento())) {
						AdjuntoComunicacion adj = genericDao.get(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "id",Long.valueOf(dtoNotificacion.getIdDocumento())));
						notificacion.setAdjuntoComunicacionSancion(adj);
					}
				}
				
				
				if(!Checks.esNulo(dtoNotificacion.getFechaNotificacion())) {
					Date fechaNotificacion = dateformat3.parse(dtoNotificacion.getFechaNotificacion());
					notificacion.setFechaNotificacion(fechaNotificacion);
				}
				if(!Checks.esNulo(dtoNotificacion.getFechaSancionNotificacion())) {
					Date fechaSancion = dateformat3.parse(dtoNotificacion.getFechaSancionNotificacion());
					notificacion.setFechaSancionNotificacion(fechaSancion);
				}
				if(!Checks.esNulo(dtoNotificacion.getCierreNotificacion())) {
					Date fechaCierre = dateformat3.parse(dtoNotificacion.getCierreNotificacion());
					notificacion.setCierreNotificacion(fechaCierre);
				}
				
				if(comunicacionGencat.getEstadoComunicacion().getCodigo().equals(DDEstadoComunicacionGencat.COD_COMUNICADO) && !Checks.esNulo(comunicacionGencat.getFechaPrevistaSancion())) {
					comunicacionGencat.setFechaPrevistaSancion(null);
				}
				
				//Insertar Notificacion
				
				notificacion.setCheckNotificacion(true);
				notificacion.setComunicacion(comunicacionGencat);	
				if (!Checks.esNulo(dtoNotificacion.getId())) {
					Auditoria auditoria = new Auditoria();
					auditoria.setBorrado(false);
					auditoria.setFechaCrear(notificacion.getAuditoria().getFechaCrear());
					auditoria.setUsuarioCrear(notificacion.getAuditoria().getUsuarioCrear());
					auditoria.setFechaModificar(new Date());
					auditoria.setUsuarioModificar(usuarioLogado.getUsername());
					notificacion.setAuditoria(auditoria);
				}				
				
				notificacionGencatDao.saveOrUpdate(notificacion);

			}
			catch (java.text.ParseException e) {
				logger.error("Error en gencatManager", e);
			}
			
		}
		
		return dtoNotificacion;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public DtoNotificacionActivo createHistoricoNotificacionComunicacion(DtoNotificacionActivo dtoNotificacion) {
		
		HistoricoComunicacionGencat historicoComunicacionGencat = genericDao.get(HistoricoComunicacionGencat.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dtoNotificacion.getIdHComunicacion())));
		
		if (!Checks.esNulo(historicoComunicacionGencat)) {
			try {
				HistoricoNotificacionGencat notificacion = new HistoricoNotificacionGencat();
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				SimpleDateFormat dateformat3 = new SimpleDateFormat("dd/MM/yyyy");
				Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
				if(!Checks.esNulo(dtoNotificacion.getId())){
					notificacion = genericDao.get(HistoricoNotificacionGencat.class, genericDao.createFilter(FilterType.EQUALS, "id", dtoNotificacion.getId()));
				}
				if(!Checks.esNulo(dtoNotificacion.getMotivoNotificacion())) {
					Filter filtroIdTipoNotificacion = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoNotificacion.getMotivoNotificacion());
					DDTipoNotificacionGencat tipoNotificacionGencat = genericDao.get(DDTipoNotificacionGencat.class, filtroIdTipoNotificacion, filtroBorrado);
					notificacion.setTipoNotificacion(tipoNotificacionGencat);
				}
				if(Checks.esNulo(dtoNotificacion.getId())) {
					if(!Checks.esNulo(dtoNotificacion.getIdDocumento())) {
						AdjuntoComunicacion adj = genericDao.get(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "id",Long.valueOf(dtoNotificacion.getIdDocumento())));
						notificacion.setAdjuntoComunicacion(adj);
					}
				}else {
					if(!Checks.esNulo(dtoNotificacion.getIdDocumento())) {
						AdjuntoComunicacion adj = genericDao.get(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "id",Long.valueOf(dtoNotificacion.getIdDocumento())));
						notificacion.setAdjuntoComunicacionSancion(adj);
					}
				}
				
				//Insertar Notificacion
				notificacion.setCheckNotificacion(true);
				notificacion.setHistoricoComunicacion(historicoComunicacionGencat);
				if(!Checks.esNulo(dtoNotificacion.getFechaNotificacion())) {
					Date fechaNotificacion = dateformat3.parse(dtoNotificacion.getFechaNotificacion());
					notificacion.setFechaNotificacion(fechaNotificacion);
				}
				if(!Checks.esNulo(dtoNotificacion.getFechaSancionNotificacion())) {
					Date fechaSancion = dateformat3.parse(dtoNotificacion.getFechaSancionNotificacion());
					notificacion.setFechaSancionNotificacion(fechaSancion);
				}
				if(!Checks.esNulo(dtoNotificacion.getCierreNotificacion())) {
					Date fechaCierre = dateformat3.parse(dtoNotificacion.getCierreNotificacion());
					notificacion.setCierreNotificacion(fechaCierre);
				}

				if (!Checks.esNulo(dtoNotificacion.getId())) {
					Auditoria auditoria = new Auditoria();
					auditoria.setBorrado(false);
					auditoria.setFechaCrear(notificacion.getAuditoria().getFechaCrear());
					auditoria.setUsuarioCrear(notificacion.getAuditoria().getUsuarioCrear());
					auditoria.setFechaModificar(new Date());
					auditoria.setUsuarioModificar(usuarioLogado.getUsername());
					notificacion.setAuditoria(auditoria);
				}				
				
				if (Checks.esNulo(dtoNotificacion.getId())) {
					genericDao.save(HistoricoNotificacionGencat.class, notificacion);
				} else {
					genericDao.update(HistoricoNotificacionGencat.class, notificacion);
				}
			}
			catch (java.text.ParseException e) {
				logger.error("Error en gencatManager", e);
			}
			
		}
		
		return dtoNotificacion;
		
	}

	@Override
	@Transactional(readOnly = false)
	public void bloqueoExpedienteGENCAT(ExpedienteComercial expComercial, Long idActivo) {
		
		Date fechaActual = new Date();
		Oferta oferta = expComercial.getOferta();
		Comprador comprador = new Comprador();
		
		Order orden = new Order(OrderType.DESC, "porcionCompra");
		
		List<CompradorExpediente> compradoresExp = genericDao.getListOrdered(CompradorExpediente.class, orden ,genericDao.createFilter(FilterType.EQUALS,"expediente",expComercial.getId())
				, genericDao.createFilter(FilterType.EQUALS, "borrado", false), genericDao.createFilter(FilterType.EQUALS, "titularContratacion", 1));
		
		if(!Checks.estaVacio(compradoresExp)) {
			comprador = genericDao.get(Comprador.class, genericDao.createFilter(FilterType.EQUALS,"id",compradoresExp.get(0).getComprador()));
		}
		String codSitPos = "0";
		String codTipoPer = "0";
		ComunicacionGencat comGencat = new ComunicacionGencat();
		VExpPreBloqueoGencat datoVista = null;
		
		List<VExpPreBloqueoGencat> listDatosVista = genericDao.getList(VExpPreBloqueoGencat.class, 
			genericDao.createFilter(FilterType.EQUALS,"idActivo", idActivo));

		if(!Checks.estaVacio(listDatosVista)) { //Pillar 1º registro que es el mas reciente para comparar los condicionantes
			datoVista = listDatosVista.get(0);
			
			//COMPROBACION SI HAY COMUNICACION GENCAT CREADA+
			if(!Checks.esNulo(datoVista.getFecha_comunicacion())) {
				comGencat = genericDao.get(ComunicacionGencat.class, genericDao.createFilter(FilterType.EQUALS,"activo.id", idActivo),genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false));
				if(!Checks.esNulo(expComercial.getCondicionante())) {
					if(!Checks.esNulo(expComercial.getCondicionante().getSituacionPosesoria())){
						codSitPos = expComercial.getCondicionante().getSituacionPosesoria().getCodigo();
					}
						
					if(!Checks.esNulo(comprador) && !Checks.esNulo(comprador.getTipoPersona())) {
						codTipoPer = comprador.getTipoPersona().getCodigo();
					}
						
					if(!Checks.esNulo(datoVista.getSituacionPosesoria()) && datoVista.getSituacionPosesoria().equals(codSitPos) 
						&& !Checks.esNulo(datoVista.getTipoPersona())&&  datoVista.getTipoPersona().equals(codTipoPer)
						&& (!Checks.esNulo(oferta.getImporteOferta()) && oferta.getImporteOferta().equals(datoVista.getImporteOferta()))) {
							
							//COMPROBACION OFERTA ULTIMA SANCION:
								//SI DD_ECG_CODIGO SANCIONADA SE COMPARA TIEMPO SANCION AL TIEMPO ACTUAL:
									//SI TIEMPO > 2 MESES LANZAR TRAMITE GENCAT
									//SI TIEMPO < 2 MESES NO HACER NADA.
						if(!Checks.esNulo(comGencat.getEstadoComunicacion())
							&& DDEstadoComunicacionGencat.COD_SANCIONADO.equals(comGencat.getEstadoComunicacion().getCodigo())
							&& !Checks.esNulo(datoVista.getFecha_sancion())) {
							if(!Checks.esNulo(comGencat.getSancion()) && DDSancionGencat.COD_NO_EJERCE.equals(comGencat.getSancion().getCodigo())) {
								Date fecha2MesesMasSancion;
								if(!Checks.esNulo(comGencat.getFechaSancion())) {
									Calendar cal = Calendar.getInstance(); 
							        cal.setTime(comGencat.getFechaSancion()); 
							        cal.add(Calendar.MONTH, 2);
							        fecha2MesesMasSancion = cal.getTime();
								}else{
									fecha2MesesMasSancion = fechaActual;
								} 
								if(fechaActual.after(fecha2MesesMasSancion) || Checks.esNulo(comGencat.getFechaSancion())){  
									lanzarTramiteGENCAT(idActivo, oferta, expComercial);
								}
							}
						}
						//SI DD_ECG_CODIGO ANULADA
						if(!Checks.esNulo(comGencat.getEstadoComunicacion())
							&& DDEstadoComunicacionGencat.COD_ANULADO.equals(comGencat.getEstadoComunicacion().getCodigo())) {
								lanzarTramiteGENCAT(idActivo, oferta, expComercial);
						}
						if(!Checks.esNulo(comGencat.getEstadoComunicacion())
								&& DDEstadoComunicacionGencat.COD_COMUNICADO.equals(comGencat.getEstadoComunicacion().getCodigo())
								&& !Checks.esNulo(comGencat.getFechaComunicacion())) {
								OfertaGencat ofertaGencat = new OfertaGencat();
								Auditoria auditoria = new Auditoria();
								auditoria.setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
								auditoria.setBorrado(false);
								auditoria.setFechaCrear(new Date());
								ofertaGencat.setOferta(expComercial.getOferta());
								ofertaGencat.setComunicacion(comGencat);
								ofertaGencat.setImporte(oferta.getImporteOferta());
								if(!Checks.esNulo(expComercial.getCondicionante())) {
									ofertaGencat.setSituacionPosesoria(expComercial.getCondicionante().getSituacionPosesoria());
								}
								ofertaGencat.setTiposPersona(oferta.getCliente().getTipoPersona());
								ofertaGencat.setAuditoria(auditoria);
								ofertaGencat.setVersion(0L);
								genericDao.save(OfertaGencat.class, ofertaGencat);
						} 
					}else {
						if(DDEstadoComunicacionGencat.COD_ANULADO.equals(comGencat.getEstadoComunicacion().getCodigo())) 
						{
							lanzarTramiteGENCAT(idActivo, oferta, expComercial);
							
						}else if(!Checks.esNulo(comGencat.getSancion())) {
							if(!DDSancionGencat.COD_EJERCE.equals(comGencat.getSancion().getCodigo())) {
								lanzarTramiteGENCAT(idActivo, oferta, expComercial);
							}
						}else {
							lanzarTramiteGENCAT(idActivo, oferta, expComercial);
						}
					}
				}else {
					if(!Checks.esNulo(comGencat.getEstadoComunicacion())
							&& DDEstadoComunicacionGencat.COD_ANULADO.equals(comGencat.getEstadoComunicacion().getCodigo())) {
								lanzarTramiteGENCAT(idActivo, oferta, expComercial);
						}
				}
			}else {
				comGencat = genericDao.get(ComunicacionGencat.class, genericDao.createFilter(FilterType.EQUALS,"activo.id", idActivo));
				if(comGencat != null && !Checks.esNulo(comGencat.getEstadoComunicacion())
					&& DDEstadoComunicacionGencat.COD_ANULADO.equals(comGencat.getEstadoComunicacion().getCodigo())
					|| DDEstadoComunicacionGencat.COD_RECHAZADO.equals(comGencat.getEstadoComunicacion().getCodigo())) {
						lanzarTramiteGENCAT(idActivo, oferta, expComercial);
				}
			}
		}else {					
			lanzarTramiteGENCAT(idActivo, oferta, expComercial);
		}	
	}

	/**
	 * Diferencia en dias entre 2 fechas.
	 * @param fechaActual normalmente la fecha de ahora
	 * @param fechaComparar normalmente la fecha a comparar
	 * @return nº de dias de diferencia entre las 2 fechas.
	 */
	public Long calculoDiferenciaFechasEnDias(Date fechaActual, Date fechaComparar) {
		Long diferenciaEnMs = fechaActual.getTime() - fechaComparar.getTime();
		return diferenciaEnMs / (1000 * 60 * 60 * 24);
	}
		
	@Override
	@Transactional(readOnly = false)
	public void lanzarTramiteGENCAT(Long idActivo, Oferta oferta, ExpedienteComercial expedienteComercial) {
		
		historificarTramiteGENCAT(idActivo);
		crearRegistrosTramiteGENCAT(expedienteComercial, oferta, idActivo);
				
		activoAdapter.crearTramiteGencat(idActivo);
				
	}
	
	@Override
	@Transactional(readOnly = false)
	public void crearRegistrosTramiteGENCAT(ExpedienteComercial expedienteComercial, Oferta oferta, Long idActivo) {
		
		ComunicacionGencat comunicacionGencat = new ComunicacionGencat();
		AdecuacionGencat adecuacionGencat = new AdecuacionGencat();
		OfertaGencat ofertaGencat = new OfertaGencat();
		Auditoria auditoria = new Auditoria();
		Activo activo = activoApi.get(idActivo);
		
		// Creamos el estado de la nueva comunicacion a CREADO
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",
				DDEstadoComunicacionGencat.COD_CREADO);
		DDEstadoComunicacionGencat estadoComunicacion = genericDao.get(DDEstadoComunicacionGencat.class, filtro);
		
		// Creamos los valores de Auditoria
		auditoria.setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
		auditoria.setBorrado(false);
		auditoria.setFechaCrear(new Date());

		// Creamos la nueva comunicación
		comunicacionGencat.setAuditoria(auditoria);
		comunicacionGencat.setActivo(activo);
		comunicacionGencat.setComunicadoAnulacionAGencat(false);
		comunicacionGencat.setEstadoComunicacion(estadoComunicacion);
		comunicacionGencat.setFechaPreBloqueo(new Date());
		comunicacionGencat.setVersion(0L);
		
		// Creamos la nueva oferta, habiendo creado previamente la comunicación
		ofertaGencat.setOferta(expedienteComercial.getOferta());
		ofertaGencat.setComunicacion(comunicacionGencat);
		ofertaGencat.setImporte(oferta.getImporteOferta());
		if(!Checks.esNulo(expedienteComercial.getCondicionante())) {
			
			ofertaGencat.setSituacionPosesoria(expedienteComercial.getCondicionante().getSituacionPosesoria());
			
		}
		ofertaGencat.setTiposPersona(oferta.getCliente().getTipoPersona());
		ofertaGencat.setAuditoria(auditoria);
		ofertaGencat.setVersion(0L);
		
		ActivoAdmisionRevisionTitulo revisionTitulo = comunicacionGencat.getActivo().getAdmisionRevisionTitulo();
		DDCedulaHabitabilidad cedula = (revisionTitulo != null) ? revisionTitulo.getCedulaHabitabilidad() : null;
		if(revisionTitulo != null || cedula != null && cedula.getCodigo().equals(DDCedulaHabitabilidad.CODIGO_OBTENIDO)) {
			adecuacionGencat.setNecesitaReforma(false);
		}else {
			adecuacionGencat.setNecesitaReforma(true);
				
			NMBInformacionRegistralBien informacionRegistralBien = comunicacionGencat.getActivo() != null && comunicacionGencat.getActivo().getBien() != null 
					&& comunicacionGencat.getActivo().getBien().getInformacionRegistral() != null 
					&& !comunicacionGencat.getActivo().getBien().getInformacionRegistral().isEmpty() ? 
							comunicacionGencat.getActivo().getBien().getInformacionRegistral().get(0) : null;
			
			int importeReforma = 0;
			
			if(informacionRegistralBien != null) {
				importeReforma = (int) (informacionRegistralBien.getSuperficieConstruida() != null ? 
						informacionRegistralBien.getSuperficieConstruida().floatValue() * PRECIO_REFORMA_ADECUACION * 100 : 0);
			}

			adecuacionGencat.setImporteReforma(importeReforma/100d);
		}
		
		// Creamos la nueva adecuación, habiendo creado previamente la comunicación
		adecuacionGencat.setComunicacion(comunicacionGencat);
		adecuacionGencat.setAuditoria(auditoria);
		adecuacionGencat.setVersion(0L);

		genericDao.save(ComunicacionGencat.class, comunicacionGencat);
		genericDao.save(OfertaGencat.class, ofertaGencat);
		genericDao.save(AdecuacionGencat.class, adecuacionGencat);
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public void historificarTramiteGENCAT(Long idActivo) {
				
		if(!Checks.esNulo(idActivo)) {
			
			ComunicacionGencat comunicacionGencat = genericDao.get(ComunicacionGencat.class, 
					genericDao.createFilter(FilterType.EQUALS,"activo.id", idActivo));
			
			if(!Checks.esNulo(comunicacionGencat)) {
				Long idComunicacionGencat = comunicacionGencat.getId();
				
				AdecuacionGencat adecuacionGencat = adecuacionGencatApi.getAdecuacionByIdComunicacion(idComunicacionGencat);
				OfertaGencat ofertaGencat = ofertaGencatApi.getOfertaByIdComunicacionGencat(idComunicacionGencat);
				List<NotificacionGencat> notificacionesGencatList = notificacionGencatApi.getNotificacionByIdComunicacionGencat(idComunicacionGencat);
				List<ReclamacionGencat> reclamacionesGencat = reclamacionGencatApi.getReclamacionByIdComunicacionGencat(idComunicacionGencat);
				VisitaGencat visitaGencat = visitaGencatApi.getVisitaByIdComunicacionGencat(idComunicacionGencat);
				
				if(!Checks.esNulo(comunicacionGencat)
						&& !Checks.esNulo(adecuacionGencat)
						&& !Checks.esNulo(ofertaGencat)) {
					
					// Historificacion del tramite de GENCAT
					HistoricoComunicacionGencat historicoComunicacionGencat = crearHistoricoComunicacionGencatByComunicacionGencat(comunicacionGencat);
					crearRelacionHistoricoComunicacionByComunicacionGencatAndHistorico(historicoComunicacionGencat, comunicacionGencat);
					crearHistoricoAdecuacionGencatByAdecuacionGencat(adecuacionGencat, historicoComunicacionGencat);
					crearHistoricoOfertaGencatByOfertaGencat(ofertaGencat, historicoComunicacionGencat);
					if (!Checks.estaVacio(notificacionesGencatList)) {
						for (NotificacionGencat notificacionGencat : notificacionesGencatList) {
							crearHistoricoNotificacionGencatByNotificacionGencat(notificacionGencat, historicoComunicacionGencat);
						}
					}
					if (!Checks.estaVacio(reclamacionesGencat)) {
						for (ReclamacionGencat reclamacionGencat : reclamacionesGencat) {
							crearHistoricoReclamacionGencatByNotificacionGencat(reclamacionGencat, historicoComunicacionGencat);
						}
					}
					crearHistoricoVisitaGencatByNotificacionGencat(visitaGencat, historicoComunicacionGencat);
					
					// Borrado del registro vigente del tramite de GENCAT
					borrarTramiteGENCAT(comunicacionGencat, notificacionesGencatList, reclamacionesGencat, visitaGencat);
					
				}
				
			}
			
		}
		
	}
	
	private void borrarTramiteGENCAT(ComunicacionGencat comunicacionGencat, List<NotificacionGencat> notificacionesGencat, List<ReclamacionGencat> reclamacionesGencat, VisitaGencat visitaGencat) {
		
		if(!Checks.esNulo(comunicacionGencat)) {
			activoAgrupacionActivoDao.deleteTramiteGencat(comunicacionGencat, notificacionesGencat, reclamacionesGencat, visitaGencat);
		}
	}
	
	private HistoricoComunicacionGencat crearHistoricoComunicacionGencatByComunicacionGencat(ComunicacionGencat comunicacionGencat) {
		
		HistoricoComunicacionGencat historicoComunicacionGencat = new HistoricoComunicacionGencat();
				
		if(!Checks.esNulo(comunicacionGencat)) {
			
			historicoComunicacionGencat.setActivo(comunicacionGencat.getActivo());
			historicoComunicacionGencat.setEstadoComunicacion(comunicacionGencat.getEstadoComunicacion());
			historicoComunicacionGencat.setFechaComunicacion(comunicacionGencat.getFechaComunicacion());
			historicoComunicacionGencat.setAnulacion(comunicacionGencat.getComunicadoAnulacionAGencat());
			historicoComunicacionGencat.setFechaAnulacion(comunicacionGencat.getFechaAnulacion());
			historicoComunicacionGencat.setSancion(comunicacionGencat.getSancion());
			historicoComunicacionGencat.setFechaPrevSancion(comunicacionGencat.getFechaPrevistaSancion());
			historicoComunicacionGencat.setFechaSancion(comunicacionGencat.getFechaSancion());
			historicoComunicacionGencat.setNifComprador(comunicacionGencat.getNuevoCompradorNif());
			historicoComunicacionGencat.setNombreComprador(comunicacionGencat.getNuevoCompradorNombre());
			historicoComunicacionGencat.setCompradorApellido1(comunicacionGencat.getNuevoCompradorApellido1());
			historicoComunicacionGencat.setCompradorApellido2(comunicacionGencat.getNuevoCompradorApellido2());
			historicoComunicacionGencat.setVersion(comunicacionGencat.getVersion());
			historicoComunicacionGencat.setAuditoria(comunicacionGencat.getAuditoria());
			historicoComunicacionGencat.setFechaPreBloqueo(comunicacionGencat.getFechaPreBloqueo());
			
		}
		
		genericDao.save(HistoricoComunicacionGencat.class, historicoComunicacionGencat);
		
		 List<AdjuntoComunicacion> adjuntosComunicacion = genericDao.getList(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "comunicacionGencat.id", comunicacionGencat.getId()));
		 if(!Checks.estaVacio(adjuntosComunicacion)) {
			 for (AdjuntoComunicacion adjuntoComunicacion : adjuntosComunicacion) {
				 adjuntoComunicacion.setHistoricoComunicacionGencat(historicoComunicacionGencat);
					
				 genericDao.update(AdjuntoComunicacion.class, adjuntoComunicacion);
			}

		 }
	
		return historicoComunicacionGencat;
		
	}
	

	private void crearRelacionHistoricoComunicacionByComunicacionGencatAndHistorico(HistoricoComunicacionGencat historicoComunicacionGencat, ComunicacionGencat comunicacionGencat) {
		
		RelacionHistoricoComunicacion relacionHistoricoComunicacion = new RelacionHistoricoComunicacion();
				
		if(!Checks.esNulo(comunicacionGencat) && !Checks.esNulo(historicoComunicacionGencat)) {
			relacionHistoricoComunicacion.setHistoricoComunicacionGencat(historicoComunicacionGencat);
			relacionHistoricoComunicacion.setIdComunicacionGencat(comunicacionGencat.getId());
			relacionHistoricoComunicacion.setAuditoria(comunicacionGencat.getAuditoria());
			relacionHistoricoComunicacion.setVersion(comunicacionGencat.getVersion());
		}
		
		genericDao.save(RelacionHistoricoComunicacion.class, relacionHistoricoComunicacion);
		
	}
	
	private void crearHistoricoAdecuacionGencatByAdecuacionGencat(AdecuacionGencat adecuacionGencat, HistoricoComunicacionGencat historicoComunicacionGencat) {
		
		HistoricoAdecuacionGencat historicoAdecuacionGencat = new HistoricoAdecuacionGencat();
		
		if(!Checks.esNulo(adecuacionGencat)) {
						
			historicoAdecuacionGencat.setHistoricoComunicacion(historicoComunicacionGencat);
			historicoAdecuacionGencat.setFechaRevision(adecuacionGencat.getFechaRevision());
			historicoAdecuacionGencat.setImporteReforma(adecuacionGencat.getImporteReforma());
			historicoAdecuacionGencat.setNecesitaReforma(adecuacionGencat.getNecesitaReforma());
			historicoAdecuacionGencat.setAuditoria(adecuacionGencat.getAuditoria());
			historicoAdecuacionGencat.setVersion(adecuacionGencat.getVersion());
			historicoAdecuacionGencat.setAuditoria(adecuacionGencat.getAuditoria());
			
		}
		
		genericDao.save(HistoricoAdecuacionGencat.class, historicoAdecuacionGencat);
		
	}
	
	private void crearHistoricoOfertaGencatByOfertaGencat(OfertaGencat ofertaGencat, HistoricoComunicacionGencat historicoComunicacionGencat) {
		
		HistoricoOfertaGencat historicoOfertaGencat = new HistoricoOfertaGencat();
		
		if(!Checks.esNulo(ofertaGencat)) {
			historicoOfertaGencat.setHistoricoComunicacion(historicoComunicacionGencat);
			historicoOfertaGencat.setImporte(ofertaGencat.getImporte());
			historicoOfertaGencat.setOferta(ofertaGencat.getOferta());
			historicoOfertaGencat.setSituacionPosesoria(ofertaGencat.getSituacionPosesoria());
			historicoOfertaGencat.setTiposPersona(ofertaGencat.getTiposPersona());
			historicoOfertaGencat.setVersion(ofertaGencat.getVersion());
			historicoOfertaGencat.setAuditoria(ofertaGencat.getAuditoria());
			historicoOfertaGencat.setIdOfertaAnterior(ofertaGencat.getIdOfertaAnterior());
			
		}
		
		genericDao.save(HistoricoOfertaGencat.class, historicoOfertaGencat);
		
	}
	
	private void crearHistoricoNotificacionGencatByNotificacionGencat(NotificacionGencat notificacionGencat, HistoricoComunicacionGencat historicoComunicacionGencat) {
		
		HistoricoNotificacionGencat historicoNotificacionGencat = new HistoricoNotificacionGencat();
		
		if(!Checks.esNulo(notificacionGencat)) {
			historicoNotificacionGencat.setHistoricoComunicacion(historicoComunicacionGencat);
			historicoNotificacionGencat.setCheckNotificacion(notificacionGencat.getCheckNotificacion());			
			historicoNotificacionGencat.setCierreNotificacion(notificacionGencat.getCierreNotificacion());
			historicoNotificacionGencat.setFechaNotificacion(notificacionGencat.getFechaNotificacion());			
			historicoNotificacionGencat.setFechaSancionNotificacion(notificacionGencat.getFechaSancionNotificacion());
			historicoNotificacionGencat.setTipoNotificacion(notificacionGencat.getTipoNotificacion());
			historicoNotificacionGencat.setVersion(notificacionGencat.getVersion());
			historicoNotificacionGencat.setAuditoria(notificacionGencat.getAuditoria());
			historicoNotificacionGencat.setAdjuntoComunicacion(notificacionGencat.getAdjuntoComunicacion());
			historicoNotificacionGencat.setAdjuntoComunicacionSancion(notificacionGencat.getAdjuntoComunicacionSancion());
			
			genericDao.save(HistoricoNotificacionGencat.class, historicoNotificacionGencat);
		}
		
	}
	
	private void crearHistoricoReclamacionGencatByNotificacionGencat(ReclamacionGencat reclamacionGencat, HistoricoComunicacionGencat historicoComunicacionGencat) {
		
		HistoricoReclamacionGencat historicoReclamacionGencat = new HistoricoReclamacionGencat();
		
		if(!Checks.esNulo(reclamacionGencat)) {
			historicoReclamacionGencat.setHistoricoComunicacion(historicoComunicacionGencat);
			historicoReclamacionGencat.setFechaAviso(reclamacionGencat.getFechaAviso());			
			historicoReclamacionGencat.setFechaReclamacion(reclamacionGencat.getFechaReclamacion());
			historicoReclamacionGencat.setVersion(reclamacionGencat.getVersion());
			historicoReclamacionGencat.setAuditoria(reclamacionGencat.getAuditoria());
			
			genericDao.save(HistoricoReclamacionGencat.class, historicoReclamacionGencat);
		}
		
	}
	
	private void crearHistoricoVisitaGencatByNotificacionGencat(VisitaGencat visitaGencat, HistoricoComunicacionGencat historicoComunicacionGencat) {
		
		HistoricoVisitaGencat historicoVisitaGencat = new HistoricoVisitaGencat();
		
		if(!Checks.esNulo(visitaGencat)) {
			historicoVisitaGencat.setHistoricoComunicacion(historicoComunicacionGencat);
			historicoVisitaGencat.setVisita(visitaGencat.getVisita());
			historicoVisitaGencat.setVersion(visitaGencat.getVersion());
			historicoVisitaGencat.setAuditoria(visitaGencat.getAuditoria());
			
			genericDao.save(HistoricoVisitaGencat.class, historicoVisitaGencat);
		}
		
	}
		
	@Override
	public void cambiarEstadoComunicacionGENCAT(ComunicacionGencat comunicacionGencat) {
		
		if(!Checks.esNulo(comunicacionGencat)) {
			comunicacionGencat.setEstadoComunicacion((DDEstadoComunicacionGencat) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoComunicacionGencat.class , DDEstadoComunicacionGencat.COD_COMUNICADO));
		}
		
	}
	
	@Override
	public void informarFechaSancion(ComunicacionGencat comunicacionGencat) {
		
		Calendar cal = Calendar.getInstance(); 
        cal.setTime(comunicacionGencat.getFechaComunicacion()); 
        cal.add(Calendar.MONTH, 2);
        Date fechaSancion = cal.getTime();
		
		comunicacionGencat.setFechaPrevistaSancion(fechaSancion);
		
	}
	
	@Transactional(readOnly = false)
	public Boolean saveDatosComunicacion(DtoGencatSave gencatDto)
	{
		Activo activo = activoApi.get( gencatDto.getIdActivo() );
		DDSancionGencat sancion = (DDSancionGencat) utilDiccionarioApi.dameValorDiccionarioByCod( DDSancionGencat.class , gencatDto.getSancion() );	
		
		ExpedienteComercial expediente = null;
		
		if (!Checks.estaVacio(activo.getOfertas())) {
			for (ActivoOferta activoOferta : activo.getOfertas()) {
				if (!Checks.esNulo(activoOferta.getPrimaryKey().getOferta()) && DDEstadoOferta.CODIGO_ACEPTADA
						.equals(activoOferta.getPrimaryKey().getOferta().getEstadoOferta().getCodigo())) {
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id",
							activoOferta.getPrimaryKey().getOferta().getId());
					expediente = genericDao.get(ExpedienteComercial.class, filtro);
					
					break;
				}
			}
		}
		
		if(!Checks.esNulo(gencatDto.getIdActivo()))

		{
			ComunicacionGencat comunicacionGencat = getComunicacionGencatByIdActivo(gencatDto.getIdActivo());
			if(!Checks.esNulo(comunicacionGencat))
			{

				dtoToBeanPreSave(comunicacionGencat, gencatDto );
				comunicacionGencat.getAuditoria().setFechaModificar(new Date());
				comunicacionGencat.getAuditoria().setUsuarioModificar( usuarioManager.getUsuarioLogado().getUsername() );				
				comunicacionGencatDao.saveOrUpdate(comunicacionGencat);	
				
				if(comunicacionGencat.getComunicadoAnulacionAGencat() 
					&& !Checks.esNulo(comunicacionGencat.getEstadoComunicacion()) 
					&& !(DDEstadoComunicacionGencat.COD_RECHAZADO.equals(comunicacionGencat.getEstadoComunicacion().getCodigo()))) {
					
						DDEstadoComunicacionGencat anulado = (DDEstadoComunicacionGencat) utilDiccionarioApi.dameValorDiccionarioByCod( DDEstadoComunicacionGencat.class , DDEstadoComunicacionGencat.COD_ANULADO );	
						comunicacionGencat.setEstadoComunicacion(anulado);
						comunicacionGencat.setFechaAnulacion(new Date());
						
				}
				
				notificacionesGencat.sendMailNotificacionSancionGencat(gencatDto, activo, sancion, expediente);
				bajaAgrupacionConActivosGenCat(activo, gencatDto);

				return true;
			}
			else
			{
				comunicacionGencat = new ComunicacionGencat();
				dtoToBeanPreSave(comunicacionGencat, gencatDto);
				comunicacionGencat.setAuditoria(new Auditoria());
				comunicacionGencat.getAuditoria().setFechaCrear(new Date());
				comunicacionGencat.getAuditoria().setUsuarioCrear(usuarioManager.getUsuarioLogado().getUsername());
				comunicacionGencat.getAuditoria().setBorrado(false);
				
				if(!Checks.esNulo(activo))
				{

					comunicacionGencat.setActivo(activo);
					comunicacionGencatDao.saveOrUpdate(comunicacionGencat);	
					notificacionesGencat.sendMailNotificacionSancionGencat(gencatDto, activo, sancion, expediente);
					bajaAgrupacionConActivosGenCat(activo,gencatDto);

					return true;
				}
			}
			
			
		}
		
		return false;
	}
	
	public void bajaAgrupacionConActivosGenCat(Activo activo, DtoGencatSave gencatDto){
		
		List<ActivoAgrupacionActivo> listaAgrupaciones = activo.getAgrupaciones();
		if(!Checks.estaVacio(listaAgrupaciones)){
			for(ActivoAgrupacionActivo agr : listaAgrupaciones){
				DDTipoAgrupacion tipoAgrupacion = agr.getAgrupacion().getTipoAgrupacion();
				if(!Checks.esNulo(tipoAgrupacion)){
					if(!DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(tipoAgrupacion.getCodigo())){
						if(Checks.esNulo(agr.getAgrupacion().getFechaBaja())) {
							if (!Checks.esNulo(gencatDto.getSancion()) && gencatDto.getSancion().equals(DDSancionGencat.COD_EJERCE)){
								ActivoAgrupacion agrupacion = new ActivoAgrupacion();
								agrupacion = agr.getAgrupacion();
								Date date = Calendar.getInstance().getTime();
								agr.getAgrupacion().setFechaBaja(date);
								genericDao.save(ActivoAgrupacion.class, agrupacion);
							}
						}		 
					}
				}
			}
		}
		
	}
	
	public DtoAviso getAviso(ActivoAgrupacion agrupacion, Usuario usuarioLogado) {


		DtoAviso dtoAviso = new DtoAviso();
		boolean continuar = true;
		if (!Checks.esNulo(agrupacion.getTipoAgrupacion()) && (DDTipoAgrupacion.AGRUPACION_RESTRINGIDA.equals(agrupacion.getTipoAgrupacion().getCodigo())
				|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER.equals(agrupacion.getTipoAgrupacion().getCodigo())
				|| DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM.equals(agrupacion.getTipoAgrupacion().getCodigo()))) {

			// Obtener los activos de la agrupación restringida.
			for(ActivoAgrupacionActivo activoAgrupacion : agrupacion.getActivos()) {
				// Por cada activo obtener las agrupaciones a las que pertenezca.
				for(ActivoAgrupacionActivo agr : activoAgrupacion.getActivo().getAgrupaciones()) {
					// Comprobar si alguna (primera coincidencia) es de tipo obra nueva.
					if(!Checks.esNulo(agr.getAgrupacion().getTipoAgrupacion()) && DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA.equals(agr.getAgrupacion().getTipoAgrupacion().getCodigo())) {
						dtoAviso.setDescripcion("Agrupación restringida integrada en obra nueva");
						dtoAviso.setId(String.valueOf(agrupacion.getId()));
						continuar = false;
						break;
					}
				}
				if(!continuar) {
					break;
				}
			}
		}

		return dtoAviso;		
	}
	
	

	public void dtoToBeanPreSave(ComunicacionGencat cg , DtoGencatSave gencatDto)
	{		
		DDSancionGencat sancion = (DDSancionGencat) utilDiccionarioApi.dameValorDiccionarioByCod( DDSancionGencat.class , gencatDto.getSancion() );	
		cg.setFechaSancion(	gencatDto.getDateFechaSancion() );
		
		if(Checks.esNulo(gencatDto.getComunicadoAnulacionAGencat()))
		{
			cg.setComunicadoAnulacionAGencat( false );
		}
		else
		{
			cg.setComunicadoAnulacionAGencat( gencatDto.getComunicadoAnulacionAGencat() );
		}
		if(!Checks.esNulo(sancion)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoComunicacionGencat.COD_SANCIONADO);
			DDEstadoComunicacionGencat estadoComunicacion = genericDao.get(DDEstadoComunicacionGencat.class, filtro);
			cg.setEstadoComunicacion(estadoComunicacion);
			if( DDSancionGencat.COD_EJERCE.equals(sancion.getCodigo()))
			{
				if (!Checks.esNulo(gencatDto.getNuevoCompradorNif()) && !Checks.esNulo(gencatDto.getNuevoCompradorNombre())) {
					cg.setNuevoCompradorNif( gencatDto.getNuevoCompradorNif() );
					cg.setNuevoCompradorNombre( gencatDto.getNuevoCompradorNombre() );
					cg.setNuevoCompradorApellido1( gencatDto.getNuevoCompradorApellido1() );
					cg.setNuevoCompradorApellido2( gencatDto.getNuevoCompradorApellido2() );
					
					OfertaGencat ofertaGencatEjerce = ofertaGencatApi.getByIdComunicacionGencatAndIdOfertaAnteriorIsNotNull(cg.getId());
					// Si ofertaGencatEjerce != null es porque ya se creo la oferta para gencat tras ejercer
					if (Checks.esNulo(ofertaGencatEjerce)) {
						OfertaGencat ofertaGencat = ofertaGencatApi.getOfertaByIdComunicacionGencat(cg.getId());
						if (!Checks.esNulo(ofertaGencat)) {
							ExpedienteComercial exp = expedienteComercialApi.findOneByOferta(ofertaGencat.getOferta());
							if (!Checks.esNulo(exp)) {
								try {
									crearNuevaOfertaGENCAT(exp, cg);
								} catch (Exception e) {
									logger.error("Error en gencatManager", e);
								}
							}
						}
					}
					
				} else {
					cg.setNuevoCompradorNif(null);
					cg.setNuevoCompradorNombre(null);
					cg.setNuevoCompradorApellido1(null);
					cg.setNuevoCompradorApellido2(null);
				}
			} else {
				cg.setNuevoCompradorNif(null);
				cg.setNuevoCompradorNombre(null);
				cg.setNuevoCompradorApellido1(null);
				cg.setNuevoCompradorApellido2(null);
			}
			
			cg.setSancion( sancion );
		}
		
	}
	
	public ComunicacionGencat getComunicacionGencatByIdActivo(Long idActivo) {
		
		if( idActivo != null)
		{
			Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
			
			//Datos comunicación
			List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
			ComunicacionGencat comunicacionGencat = null;
			if (resultComunicacion != null && !resultComunicacion.isEmpty()) {
				comunicacionGencat = resultComunicacion.get(0);
			}
			return comunicacionGencat;
		}
		return null;	
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			try {
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
				borrado = deleteAdjuntoLocal(dtoAdjunto);
			} catch (Exception e) {
				logger.error(e.getMessage(),e);
			}
		} else {
			borrado = this.deleteAdjuntoLocal(dtoAdjunto);
		}
		return borrado;
	}

	private boolean deleteAdjuntoLocal(DtoAdjunto dtoAdjunto) {
		Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", dtoAdjunto.getIdEntidad());
 		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
		ComunicacionGencat comunicacionGencat = null;
		if (resultComunicacion != null && !resultComunicacion.isEmpty()) {
			comunicacionGencat = resultComunicacion.get(0);
		}
		
		if(comunicacionGencat != null) {
			AdjuntoComunicacion adjunto = genericDao.get(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "comunicacionGencat.id",comunicacionGencat.getId()),genericDao.createFilter(FilterType.EQUALS, "idDocRestClient",dtoAdjunto.getId()));
			if (!Checks.esNulo(adjunto)){
				genericDao.deleteById(AdjuntoComunicacion.class, adjunto.getId());
			}else {
				adjunto = genericDao.get(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "comunicacionGencat.id",comunicacionGencat.getId()),genericDao.createFilter(FilterType.EQUALS, "id",dtoAdjunto.getId()));
				if (!Checks.esNulo(adjunto)){
					genericDao.deleteById(AdjuntoComunicacion.class, adjunto.getId());
				}
			}
		}
		
		return true;
	}
	
	public void crearNuevaOfertaGENCAT(ExpedienteComercial expedienteComercial, ComunicacionGencat cmg) throws Exception {

		Auditoria auditoria = new Auditoria();
		// Creamos los valores de Auditoria
		auditoria.setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
		auditoria.setBorrado(false);
		auditoria.setFechaCrear(new Date());
		
	////////////////////// OFERTA ////////////////////////////////
		Oferta nuevaOferta = new Oferta();
		Oferta oferta = expedienteComercial.getOferta();
		nuevaOferta.setAuditoria(auditoria);
		// Datos Generales
		Long numOferta = activoDao.getNextNumOferta();
		nuevaOferta.setNumOferta(numOferta);
		DDEstadoOferta estadoOferta = (DDEstadoOferta) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadoOferta.class, DDEstadoOferta.CODIGO_ACEPTADA);
		nuevaOferta.setEstadoOferta(estadoOferta);
		nuevaOferta.setFechaAlta(new Date());
		nuevaOferta.setTipoOferta(oferta.getTipoOferta());
		nuevaOferta.setVentaDirecta(oferta.getVentaDirecta());
		
		DDSistemaOrigen sistemaOrigen = genericDao.get(DDSistemaOrigen.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSistemaOrigen.CODIGO_REM));
		if (sistemaOrigen != null)
			nuevaOferta.setOrigen(sistemaOrigen);
		
		nuevaOferta.setOfertaExpress(oferta.getOfertaExpress());
		nuevaOferta.setCanalPrescripcion(oferta.getCanalPrescripcion());
		nuevaOferta.setPrescriptor(oferta.getPrescriptor());
		nuevaOferta.setImporteOferta(oferta.getImporteOferta());
		nuevaOferta.setOfrDocRespPrescriptor(oferta.getOfrDocRespPrescriptor());
		nuevaOferta.setRespDocCliente(oferta.getRespDocCliente());

		// Activo/s
		List<ActivoOferta> listaActOfr = ofertaApi.buildListaActivoOferta(cmg.getActivo(), null, nuevaOferta); 
		Long idActivo = cmg.getActivo().getId();
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo", idActivo);
		Filter filtroIdOferta = genericDao.createFilter(FilterType.EQUALS, "oferta", oferta.getId());
		ActivoOferta actOfr = genericDao.get(ActivoOferta.class, filtroIdActivo, filtroIdOferta);
		if (!Checks.esNulo(actOfr)) {
			nuevaOferta.setImporteOferta(actOfr.getImporteActivoOferta());
		}
		nuevaOferta.setActivosOferta(listaActOfr);
		
		//  Comprador
		ClienteComercial clienteComercial = new ClienteComercial();
		Long clcremid = activoDao.getNextClienteRemId();
		clienteComercial.setIdClienteRem(clcremid);
		clienteComercial.setNombre(cmg.getNuevoCompradorNombre());
		String apellidos = null;
		if(!Checks.esNulo(cmg.getNuevoCompradorApellido1())){
			apellidos = cmg.getNuevoCompradorApellido1();
		}
		if(!Checks.esNulo(apellidos) && !Checks.esNulo(cmg.getNuevoCompradorApellido2())) {
			apellidos = apellidos+" "+cmg.getNuevoCompradorApellido2();
		}else if(Checks.esNulo(apellidos)&& !Checks.esNulo(cmg.getNuevoCompradorApellido2())) {
			apellidos = cmg.getNuevoCompradorApellido2();
		}
		clienteComercial.setApellidos(apellidos);
		clienteComercial.setDocumento(cmg.getNuevoCompradorNif());
		DDTipoDocumento tipoDocumento = (DDTipoDocumento) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoDocumento.class, DD_TIPO_DOCUMENTO_CODIGO_NIF);
		clienteComercial.setTipoDocumento(tipoDocumento);
		clienteComercial.setAuditoria(auditoria);
		DDTiposPersona tipoPersona = genericDao.get(DDTiposPersona.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", DDTiposPersona.CODIGO_TIPO_PERSONA_JURIDICA));
		clienteComercial.setTipoPersona(tipoPersona);

		genericDao.save(ClienteComercial.class, clienteComercial);
		
		nuevaOferta.setCliente(clienteComercial);
		
		genericDao.save(Oferta.class, nuevaOferta);
	/////////////////////////////////////////////////////////////////
		
	/////////////////////// EXPEDIENTE ////////////////////////////////
		// Creacion Exp comercial
		List<Activo> listaActivos = new ArrayList<Activo>();
		for (ActivoOferta activoOferta : nuevaOferta.getActivosOferta()) {
			listaActivos.add(activoOferta.getPrimaryKey().getActivo());
		}
		DDSubtipoTrabajo subtipoTrabajo = (DDSubtipoTrabajo) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, tramitacionOfertasManager.getSubtipoTrabajoByOferta(nuevaOferta));
		Trabajo trabajo = trabajoApi.create(subtipoTrabajo, listaActivos, null, false);
		ExpedienteComercial nuevoExpedienteComercial = tramitacionOfertasManager.crearExpediente(nuevaOferta, trabajo, oferta, oferta.getActivoPrincipal());
		trabajoApi.createTramiteTrabajo(trabajo,nuevoExpedienteComercial);
		
		
		nuevoExpedienteComercial.setConflictoIntereses(expedienteComercial.getConflictoIntereses());
		nuevoExpedienteComercial.setRiesgoReputacional(expedienteComercial.getRiesgoReputacional());
		nuevoExpedienteComercial.setEstadoPbc(expedienteComercial.getEstadoPbc());
		nuevoExpedienteComercial.setComiteSancion(expedienteComercial.getComiteSancion());
		
		this.copiarGestoresNuevaOfertaGENCAT(expedienteComercial, nuevoExpedienteComercial);
		
		Filter ofertaExpediente = genericDao.createFilter(FilterType.EQUALS, "oferta", nuevoExpedienteComercial.getOferta().getId());
		ActivoOferta actOfrExpediente = genericDao.get(ActivoOferta.class, ofertaExpediente);
		if (!Checks.esNulo(actOfrExpediente)) {
			actOfrExpediente.setImporteActivoOferta(actOfr.getImporteActivoOferta());
		}
		genericDao.update(ActivoOferta.class, actOfrExpediente);
		genericDao.save(ExpedienteComercial.class, nuevoExpedienteComercial);
		
		
		
		// Condiciones
		
		CondicionanteExpediente condiciones = expedienteComercial.getCondicionante();
		CondicionanteExpediente condicionesNuevas = nuevoExpedienteComercial.getCondicionante();
		if (!Checks.esNulo(condiciones) && !Checks.esNulo(condicionesNuevas)) {
			condicionesNuevas.setSolicitaFinanciacion(condiciones.getSolicitaFinanciacion());
			condicionesNuevas.setEstadoFinanciacion(condiciones.getEstadoFinanciacion());
			condicionesNuevas.setEntidadFinanciacion(condiciones.getEntidadFinanciacion());
			condicionesNuevas.setFechaInicioExpediente(condiciones.getFechaInicioExpediente());
			condicionesNuevas.setFechaInicioFinanciacion(condiciones.getFechaInicioFinanciacion());
			condicionesNuevas.setFechaFinFinanciacion(condiciones.getFechaFinFinanciacion());
			condicionesNuevas.setSolicitaReserva(0);
			condicionesNuevas.setTipoCalculoReserva(null);
			condicionesNuevas.setPorcentajeReserva(null);
			condicionesNuevas.setPlazoFirmaReserva(null);
			condicionesNuevas.setImporteReserva(null);
			condicionesNuevas.setTipoImpuesto(condiciones.getTipoImpuesto());
			condicionesNuevas.setTipoAplicable(condiciones.getTipoAplicable());
			condicionesNuevas.setRenunciaExencion(condiciones.getRenunciaExencion());
			condicionesNuevas.setReservaConImpuesto(condiciones.getReservaConImpuesto());
			condicionesNuevas.setOperacionExenta(condiciones.getOperacionExenta());
			condicionesNuevas.setInversionDeSujetoPasivo(condiciones.getInversionDeSujetoPasivo());
			condicionesNuevas.setGastosPlusvalia(condiciones.getGastosPlusvalia());
			condicionesNuevas.setTipoPorCuentaPlusvalia(condiciones.getTipoPorCuentaPlusvalia());
			condicionesNuevas.setGastosNotaria(condiciones.getGastosNotaria());
			condicionesNuevas.setTipoPorCuentaNotaria(condiciones.getTipoPorCuentaNotaria());
			condicionesNuevas.setGastosOtros(condiciones.getGastosOtros());
			condicionesNuevas.setTipoPorCuentaGastosOtros(condiciones.getTipoPorCuentaGastosOtros());
			condicionesNuevas.setCargasImpuestos(condiciones.getCargasImpuestos());
			condicionesNuevas.setTipoPorCuentaImpuestos(condiciones.getTipoPorCuentaImpuestos());
			condicionesNuevas.setCargasComunidad(condiciones.getCargasComunidad());
			condicionesNuevas.setTipoPorCuentaComunidad(condiciones.getTipoPorCuentaComunidad());
			condicionesNuevas.setCargasOtros(condiciones.getCargasOtros());
			condicionesNuevas.setTipoPorCuentaCargasOtros(condiciones.getTipoPorCuentaCargasOtros());
			condicionesNuevas.setSujetoTanteoRetracto(condiciones.getSujetoTanteoRetracto());
			condicionesNuevas.setEstadoTramite(condiciones.getEstadoTramite());
			condicionesNuevas.setEstadoTitulo(condiciones.getEstadoTitulo());
			condicionesNuevas.setPosesionInicial((condiciones.getPosesionInicial()));
			condicionesNuevas.setSituacionPosesoria(condiciones.getSituacionPosesoria());
			condicionesNuevas.setRenunciaSaneamientoEviccion(condiciones.getRenunciaSaneamientoEviccion());
			condicionesNuevas.setRenunciaSaneamientoVicios(condiciones.getRenunciaSaneamientoVicios());
			condicionesNuevas.setProcedeDescalificacion(condiciones.getProcedeDescalificacion());
			condicionesNuevas.setTipoPorCuentaDescalificacion(condiciones.getTipoPorCuentaDescalificacion());
			condicionesNuevas.setLicencia(condiciones.getLicencia());
			condicionesNuevas.setTipoPorCuentaLicencia(condiciones.getTipoPorCuentaLicencia());
			
			genericDao.save(CondicionanteExpediente.class, condicionesNuevas);
		}

		
	///////////////// OFERTA GENCAT ///////////////////////////////////
		OfertaGencat ofertaGencat = new OfertaGencat();
		ofertaGencat.setAuditoria(auditoria);
		ofertaGencat.setVersion(0L);
		
		ofertaGencat.setOferta(nuevaOferta);
		ofertaGencat.setComunicacion(cmg);
		if (!Checks.esNulo(actOfr)) {
			ofertaGencat.setImporte(actOfr.getImporteActivoOferta());
		}else {
			ofertaGencat.setImporte(nuevaOferta.getImporteOferta());
		}
		
		ofertaGencat.setIdOfertaAnterior(oferta.getId());
		if(!Checks.esNulo(expedienteComercial.getCondicionante())) {
			
			ofertaGencat.setSituacionPosesoria(expedienteComercial.getCondicionante().getSituacionPosesoria());
		}
		
		ofertaGencat.setTiposPersona(nuevaOferta.getCliente().getTipoPersona());
		
		genericDao.save(OfertaGencat.class, ofertaGencat);
	/////////////////////////////////////////////////////////////////
		
	///////////////// CONGELAR OFERTAS PENDIENTES Y TRAMITADAS DEL ACTIVO ///////////////////////////////////
		List<Oferta> listaOfertasVivas = activoApi.getOfertasPendientesOTramitadasByActivo(cmg.getActivo());
		for (Oferta ofr : listaOfertasVivas) {
			if (!ofr.equals(nuevaOferta)) {
				ofertaApi.congelarOferta(ofr);
			}
		}
	
	/////////////////////////////////////////////////////////////////
			
	//////////////// INSERTAR DATOS IDENTIFICACION EN COM_COMPRADOR ////////////////////////
		Comprador comprador = genericDao.get(Comprador.class, 
				genericDao.createFilter(FilterType.EQUALS, "documento", clienteComercial.getDocumento())
				, genericDao.createFilter(FilterType.EQUALS, "tipoDocumento", clienteComercial.getTipoDocumento()));
		if (!Checks.esNulo(comprador)) {
			comprador.setNombre(cmg.getNuevoCompradorNombre());
			apellidos = null;
			if(!Checks.esNulo(cmg.getNuevoCompradorApellido1())){
				apellidos = cmg.getNuevoCompradorApellido1();
			}
			if(!Checks.esNulo(apellidos) && !Checks.esNulo(cmg.getNuevoCompradorApellido2())) {
				apellidos = apellidos+" "+cmg.getNuevoCompradorApellido2();
			}else if(Checks.esNulo(apellidos)&& !Checks.esNulo(cmg.getNuevoCompradorApellido2())) {
				apellidos = cmg.getNuevoCompradorApellido2();
			}
			cmg.getNuevoCompradorApellido2();
			comprador.setApellidos(apellidos);
			genericDao.update(Comprador.class, comprador);
			
			CompradorExpediente compradoresExp = genericDao.get(CompradorExpediente.class ,genericDao.createFilter(FilterType.EQUALS,"expediente", nuevoExpedienteComercial.getId())
					,genericDao.createFilter(FilterType.EQUALS,"comprador", comprador.getId()), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		
			//////////////// BORRADO DE DATOS EN REPRESENTANTE ///////////////	
			if(!Checks.esNulo(compradoresExp)) {
				compradoresExp.setNombreRepresentante(null);
				compradoresExp.setApellidosRepresentante(null);
				genericDao.update(CompradorExpediente.class, compradoresExp);
			}
		}
	////////////////////////////////////////////////////////////////
		
	}
	
	@SuppressWarnings("static-access")
	private void copiarGestoresNuevaOfertaGENCAT(ExpedienteComercial expedienteOrigen, ExpedienteComercial expedienteGENCAT) {
		// Copiamos los gestores del expediente origen
		GestorEntidadDto dto = new GestorEntidadDto();
		dto.setIdEntidad(expedienteGENCAT.getId());
		dto.setTipoEntidad(GestorEntidadDto.TIPO_ENTIDAD_EXPEDIENTE_COMERCIAL);
		
		Usuario usuarioGestorFormalizacion = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expedienteOrigen
				, gestorExpedienteComercialApi.CODIGO_GESTOR_FORMALIZACION);
		Usuario usuarioGestoriaFormalizacion = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expedienteOrigen
				, gestorExpedienteComercialApi.CODIGO_GESTORIA_FORMALIZACION);
		Usuario usuarioSupervisorFormalizacion = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expedienteOrigen
				, gestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION);
		Usuario usuarioGestorController = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expedienteOrigen
				, gestorExpedienteComercialApi.CODIGO_GESTOR_CONTROLLER);
		if (!Checks.esNulo(usuarioGestorFormalizacion)) {
			this.agregarTipoGestorYUsuarioEnOfertaGENCAT(gestorExpedienteComercialApi.CODIGO_GESTOR_FORMALIZACION, usuarioGestorFormalizacion.getUsername(), dto);
		}
		if (!Checks.esNulo(usuarioGestoriaFormalizacion)) {
			this.agregarTipoGestorYUsuarioEnOfertaGENCAT(gestorExpedienteComercialApi.CODIGO_GESTORIA_FORMALIZACION, usuarioGestoriaFormalizacion.getUsername(), dto);
		}
		if (!Checks.esNulo(usuarioSupervisorFormalizacion)) {
			this.agregarTipoGestorYUsuarioEnOfertaGENCAT(gestorExpedienteComercialApi.CODIGO_SUPERVISOR_FORMALIZACION, usuarioSupervisorFormalizacion.getUsername(), dto);
		}	
		if (!Checks.esNulo(usuarioGestorController)) {
			this.agregarTipoGestorYUsuarioEnOfertaGENCAT(gestorExpedienteComercialApi.CODIGO_GESTOR_CONTROLLER, usuarioGestorController.getUsername(), dto);
		}
	}
	
	private void agregarTipoGestorYUsuarioEnOfertaGENCAT(String codTipoGestor, String username, GestorEntidadDto dto) {
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", codTipoGestor));
		Usuario usu = genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", username));

		if (!Checks.esNulo(tipoGestor) && !Checks.esNulo(usu)) {
			dto.setIdTipoGestor(tipoGestor.getId());
			dto.setIdUsuario(usu.getId());
			gestorExpedienteComercialApi.insertarGestorAdicionalExpedienteComercial(dto);
		}
	}

	@Override
	@Transactional(readOnly = false)
	public boolean updateFechaReclamacion(DtoReclamacionActivo gencatDto) {
		
		if (!Checks.esNulo(gencatDto)) {
			ReclamacionGencat reclamacion = genericDao.get(ReclamacionGencat.class, 
					genericDao.createFilter(FilterType.EQUALS, "id", gencatDto.getId()));
			
			if (!Checks.esNulo(gencatDto.getFechaReclamacion())) {
				try {
					reclamacion.setFechaReclamacion(ft.parse(gencatDto.getFechaReclamacion()));
				} catch (ParseException e) {
					logger.error(e.getMessage(),e);
				}
			}
			
			genericDao.update(ReclamacionGencat.class, reclamacion);

			return true;
		}
		
		return false;
	}

	@Override
	public List <DtoTiposDocumentoComunicacion> getTiposDocumentoComunicacion() {
		
		List <DtoTiposDocumentoComunicacion> listDtoTipoDocumento = new ArrayList <DtoTiposDocumentoComunicacion>();
		List <DDTipoDocumentoComunicacion> listaDDTipoDocumento= new ArrayList <DDTipoDocumentoComunicacion>();		
		
		listaDDTipoDocumento = genericDao.getList(DDTipoDocumentoComunicacion.class);
		
		for (DDTipoDocumentoComunicacion tipDoc : listaDDTipoDocumento) {
			if (!DDTipoDocumentoComunicacion.CODIGO_NOTIFICACION_VARIACIONES_DATOS_GENCAT.equals(tipDoc.getCodigo())
					&& !DDTipoDocumentoComunicacion.CODIGO_SANCION_NOTIFICACION_GENCAT.equals(tipDoc.getCodigo())) {
				DtoTiposDocumentoComunicacion aux = new DtoTiposDocumentoComunicacion();
				aux.setCodigo(tipDoc.getCodigo());
				aux.setDescripcion(tipDoc.getDescripcion());
				aux.setDescripcionLarga(tipDoc.getDescripcionLarga());
				listDtoTipoDocumento.add(aux);
			}
		}
		return listDtoTipoDocumento;
	}
	
	@Override
	public List <DtoTiposDocumentoComunicacion> getTiposDocumentoNotificacion(Long idNotificacion) {
		
		List <DtoTiposDocumentoComunicacion> listDtoTipoDocumento = new ArrayList <DtoTiposDocumentoComunicacion>();	
		DtoTiposDocumentoComunicacion aux = new DtoTiposDocumentoComunicacion();
		DDTipoDocumentoComunicacion tipoDocumento;
	
		if(Checks.esNulo(idNotificacion)) {
			tipoDocumento = genericDao.get(DDTipoDocumentoComunicacion.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDTipoDocumentoComunicacion.CODIGO_NOTIFICACION_VARIACIONES_DATOS_GENCAT));
			aux.setCodigo(tipoDocumento.getCodigo());
			aux.setDescripcion(tipoDocumento.getDescripcion());
			aux.setDescripcionLarga(tipoDocumento.getDescripcionLarga());
			listDtoTipoDocumento.add(aux);
		}else {
			 tipoDocumento = genericDao.get(DDTipoDocumentoComunicacion.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDTipoDocumentoComunicacion.CODIGO_SANCION_NOTIFICACION_GENCAT));
			 aux.setCodigo(tipoDocumento.getCodigo());
			 aux.setDescripcion(tipoDocumento.getDescripcion());
			 aux.setDescripcionLarga(tipoDocumento.getDescripcionLarga());
			 listDtoTipoDocumento.add(aux);	
		}
		return listDtoTipoDocumento;
	}
	
	public boolean comprobacionDocumentoAnulacion(Long idActivo) {
		
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		//Datos comunicación
		List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroIdActivo, filtroBorrado);
		ComunicacionGencat comunicacionGencat = null;
		if (!Checks.esNulo(resultComunicacion) && !resultComunicacion.isEmpty()) {
			comunicacionGencat = resultComunicacion.get(0);
		}
		
		if(comunicacionGencat != null) {
			long cmg = comunicacionGencat.getId();
			
			Filter filtroCmgId = genericDao.createFilter(FilterType.EQUALS, "comunicacionGencat.id", cmg);
			
			List <AdjuntoComunicacion> resultAdjuntoComunicacion = genericDao.getList(AdjuntoComunicacion.class, filtroCmgId);
			
			if (!Checks.esNulo(resultAdjuntoComunicacion)) {
				for(AdjuntoComunicacion cga: resultAdjuntoComunicacion) {
					if(cga.getTipoDocumentoComunicacion().getCodigo().equals(DDTipoDocumentoComunicacion.CODIGO_ANULACION_OFERTA_GENCAT)) {
						boolean estadosOfertas = activoDao.todasLasOfertasEstanAnuladas(idActivo);
						if (!Checks.esNulo(estadosOfertas)) {
							return estadosOfertas;
						}					
					}else {
						return false;
					}
				}
			}else {
				return false;
			}
		}
		return false;
	}

	@Override
	@Transactional(readOnly = false)
	public DtoAltaVisita altaVisitaComunicacion(DtoAltaVisita dtoAltaVisita) throws Exception {
		
		//Validacion
		ComunicacionGencat comunicacionGencat = validateAltaVisita(dtoAltaVisita);
		
		//Se obtiene el id del activo en Haya
		Activo activo = activoApi.get(dtoAltaVisita.getIdActivo());
		dtoAltaVisita.setIdActivoHaya(activo.getNumActivo());
		
		//WS que dan da alta la visita en SF
		SalesforceAuthDto auth = salesforceManager.getAuthtoken();
		SalesforceResponseDto salesforceResponseDto = salesforceManager.altaVisita(auth, dtoAltaVisita);
		
		//Guardado en BBDD
		createVisitaComunicacion(comunicacionGencat, dtoAltaVisita, salesforceResponseDto);
		
		return dtoAltaVisita;
	}
	
	@Override
	public ComunicacionGencat validateAltaVisita(DtoAltaVisita dtoAltaVisita) {
		
		if (Checks.esNulo(dtoAltaVisita)) {
			throw new IllegalArgumentException(ERROR_FALTA_VISITA);
		}
		
		if (Checks.esNulo(dtoAltaVisita.getIdActivo())) {
			throw new IllegalArgumentException(ERROR_FALTA_IDACTIVO);
		}
		
		if (Checks.esNulo(dtoAltaVisita.getNombre())) {
			throw new IllegalArgumentException(ERROR_FALTA_NOMBRE);
		}
		
		if (Checks.esNulo(dtoAltaVisita.getTelefono())) {
			throw new IllegalArgumentException(ERROR_FALTA_TELEFONO);
		}
		
		if (Checks.esNulo(dtoAltaVisita.getEmail())) {
			throw new IllegalArgumentException(ERROR_FALTA_EMAIL);
		}
		
		//Se comprueba si el activo pasado como parametro tiene una comunicacion
		Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", dtoAltaVisita.getIdActivo());
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
		ComunicacionGencat comunicacionGencat = null;
		if (resultComunicacion != null && !resultComunicacion.isEmpty()) {
			comunicacionGencat = resultComunicacion.get(0);
		}
				
		if (comunicacionGencat == null) {
			throw new IllegalArgumentException(ERROR_FALTA_COMUNICACION);
		}
		
		if(!Checks.esNulo(comunicacionGencat) && comunicacionGencat.getEstadoComunicacion().getCodigo().equals(DDEstadoComunicacionGencat.COD_COMUNICADO) && !Checks.esNulo(comunicacionGencat.getFechaPrevistaSancion())) {
			comunicacionGencat.setFechaPrevistaSancion(null);
		}
		
		//Se comprueba si ya se ha enviado previamente una visita
		Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", comunicacionGencat.getId());
		List <VisitaGencat> resultVisitaGencat = genericDao.getListOrdered(VisitaGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
		VisitaGencat visitaGencat = null;
		if (resultVisitaGencat != null && !resultVisitaGencat.isEmpty()) {
			visitaGencat = resultVisitaGencat.get(0);
		}
		
		if (!Checks.esNulo(visitaGencat)) {
			throw new IllegalArgumentException(ERROR_YA_HAY_VISITA);
		}
		
		return comunicacionGencat;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public DtoAltaVisita createVisitaComunicacion(ComunicacionGencat comunicacionGencat, DtoAltaVisita dtoAltaVisita, SalesforceResponseDto salesforceResponseDto) {
			
		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		
		VisitaGencat visita = new VisitaGencat();
		visita.setComunicacion(comunicacionGencat);
		visita.setFechaEnvioSolicitud(new Date());
		visita.setIdLeadSF(salesforceResponseDto.getResults().get(0).getId());
		
		Auditoria auditoria = new Auditoria();
		auditoria.setBorrado(false);
		auditoria.setFechaCrear(new Date());
		auditoria.setUsuarioCrear(usuarioLogado.getApellidoNombre());
		
		visita.setVersion(Long.valueOf(0));
		visita.setAuditoria(auditoria);
		
		visitaGencatDao.save(visita);
		
		return dtoAltaVisita;
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public void updateVisitaComunicacion(Long idActivo, String idSalesforce, Visita visitaInsertada) {
		
		Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		//Datos comunicación
		List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
		ComunicacionGencat comunicacionGencat = null;
		if (resultComunicacion != null && !resultComunicacion.isEmpty()) {
			comunicacionGencat = resultComunicacion.get(0);
		}
		
		
		if (comunicacionGencat != null) {
			
			//Visita
			Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", comunicacionGencat.getId());
			Filter filtroIdSalesforce = genericDao.createFilter(FilterType.EQUALS, "idLeadSF", idSalesforce);
			List <VisitaGencat> resultVisitaGencat = genericDao.getListOrdered(VisitaGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroIdSalesforce, filtroBorrado);
			
			//Si la visita ya estaba creada, actualizaremos la fecha de recepcion y visita asociada
			if (resultVisitaGencat != null && !resultVisitaGencat.isEmpty()) {
				VisitaGencat visitaGencat = resultVisitaGencat.get(0);
				
				visitaGencat.setVisita(visitaInsertada);
				visitaGencat.setFechaRecepcionSolicitud(new Date());
				
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				
				visitaGencat.getAuditoria().setUsuarioModificar(usuarioLogado.getUsername());
				visitaGencat.getAuditoria().setFechaModificar(new Date());
				
				visitaGencatDao.save(visitaGencat);
				
			}
			//Si la visita no existe, se crea
			else {
				
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				
				//Insertar Visita
				VisitaGencat visitaGencat = new VisitaGencat();
				visitaGencat.setComunicacion(comunicacionGencat);
				visitaGencat.setFechaRecepcionSolicitud(new Date());
				visitaGencat.setIdLeadSF(idSalesforce);
				
				Auditoria auditoria = new Auditoria();
				auditoria.setBorrado(false);
				auditoria.setFechaCrear(new Date());
				auditoria.setUsuarioCrear(usuarioLogado.getUsername());
				
				visitaGencat.setVersion(Long.valueOf(0));
				visitaGencat.setAuditoria(auditoria);
				
				visitaGencatDao.save(visitaGencat);
				
			}
			
		}
		
	}
	
	@Override
	public boolean comprobarExpedienteAnuladoGencat(List<ComunicacionGencat> comunicacionesGencat) {
		for (ComunicacionGencat comunicacionGencat : comunicacionesGencat) {
			if (!Checks.esNulo(comunicacionGencat) && !Checks.esNulo(comunicacionGencat.getFechaSancion())
					&& !Checks.esNulo(comunicacionGencat.getSancion())
					&& DDSancionGencat.COD_EJERCE.equals(comunicacionGencat.getSancion().getCodigo())) {
				List<ActivoTramite> actTraList = genericDao.getList(ActivoTramite.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", comunicacionGencat.getActivo().getId()));
				if(!Checks.estaVacio(actTraList)) {
					for (ActivoTramite activoTramite : actTraList) {
						if (ActivoTramiteApi.CODIGO_TRAMITE_COMUNICACION_GENCAT.equals(activoTramite.getTipoTramite().getCodigo())
								&& (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(activoTramite.getEstadoTramite().getCodigo())
										|| DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO.equals(activoTramite.getEstadoTramite().getCodigo()))) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}
	
	@Override
	public boolean comprobarExpedienteBloqueadoGencat(List<ComunicacionGencat> comunicacionesGencat) {
		for (ComunicacionGencat comunicacionGencat : comunicacionesGencat) {
			if (!Checks.esNulo(comunicacionGencat) && !Checks.esNulo(comunicacionGencat.getFechaComunicacion())
					&& DDEstadoComunicacionGencat.COD_COMUNICADO.equals(comunicacionGencat.getEstadoComunicacion().getCodigo())) {
				List<ActivoTramite> actTraList = genericDao.getList(ActivoTramite.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", comunicacionGencat.getActivo().getId()));
				if(!Checks.estaVacio(actTraList)) {
					for (ActivoTramite activoTramite : actTraList) {
						if (ActivoTramiteApi.CODIGO_TRAMITE_COMUNICACION_GENCAT.equals(activoTramite.getTipoTramite().getCodigo())
								&& (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(activoTramite.getEstadoTramite().getCodigo())
										|| DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO.equals(activoTramite.getEstadoTramite().getCodigo()))) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}
	
	@Override
	public boolean comprobarExpedientePreBloqueadoGencat(List<ComunicacionGencat> comunicacionesGencat) {
		for (ComunicacionGencat comunicacionGencat : comunicacionesGencat) {
			if (!Checks.esNulo(comunicacionGencat) && DDEstadoComunicacionGencat.COD_CREADO.equals(comunicacionGencat.getEstadoComunicacion().getCodigo())) {
				return true;
			}
		}
		return false;
	}
	
	@Override
	public boolean descongelaExpedienteGencat(ExpedienteComercial expediente) {
		boolean descongelar = false;
		boolean expedienteAnulado = false;
		List<ComunicacionGencat> comunicacionesVivas = comunicacionesVivas(expediente);
		expedienteAnulado = comprobarExpedienteAnuladoGencat(comunicacionesVivas);
		if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getOferta())) {
			Oferta oferta = expediente.getOferta();	
			List<OfertaGencat> ofertaGencat = genericDao.getList(OfertaGencat.class,genericDao.createFilter(FilterType.EQUALS,"oferta", oferta));
			
			if(!Checks.estaVacio(ofertaGencat) && expedienteAnulado) {
				List<ActivoOferta> actOfrList = expediente.getOferta().getActivosOferta();
				for (ActivoOferta actOfr : actOfrList){
					Activo activo = actOfr.getPrimaryKey().getActivo();
					if (activoApi.isAfectoGencat(activo)) {
						return descongelar;
					}
				}
			} else {
				descongelar = true;
			}
		} else {
			descongelar = true;	
		}
		return descongelar;
	}
	
	@Override
	public List<ComunicacionGencat> comunicacionesVivas(ExpedienteComercial expediente) {
		List<ComunicacionGencat> comunicacionesGencat = new ArrayList<ComunicacionGencat>();
		if (!Checks.esNulo(expediente)) {
			List<OfertaGencat> ofertaGencat = genericDao.getList(OfertaGencat.class, genericDao.createFilter(FilterType.EQUALS, "oferta", expediente.getOferta()), genericDao.createFilter(FilterType.NULL, "idOfertaAnterior"));
			List<ActivoOferta> actOfrList = expediente.getOferta().getActivosOferta();
			if (!Checks.estaVacio(ofertaGencat)) {
				for (ActivoOferta actOfr : actOfrList) {
					ComunicacionGencat comunicacionGencat = genericDao.get(ComunicacionGencat.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", actOfr.getActivoId()));
					if (!Checks.esNulo(comunicacionGencat)) {
						comunicacionesGencat.add(comunicacionGencat);
					}
				}
			}
		}
		
		return comunicacionesGencat;
	}
	
	@Override
	public boolean esOfertaGencat(ExpedienteComercial expediente) {
		boolean provieneOfertaGencat = false;
		List<OfertaGencat> esOfertaGencat = genericDao.getList(OfertaGencat.class, genericDao.createFilter(FilterType.EQUALS, "oferta", expediente.getOferta()), genericDao.createFilter(FilterType.NOTNULL, "idOfertaAnterior"));
		List<HistoricoOfertaGencat> esOfertaGencatHistorico = genericDao.getList(HistoricoOfertaGencat.class, genericDao.createFilter(FilterType.EQUALS, "oferta", expediente.getOferta()), genericDao.createFilter(FilterType.NOTNULL, "idOfertaAnterior"));
		if (!Checks.estaVacio(esOfertaGencat) || !Checks.estaVacio(esOfertaGencatHistorico) ) {
			provieneOfertaGencat = true;
		}
		return provieneOfertaGencat;
	}

}
