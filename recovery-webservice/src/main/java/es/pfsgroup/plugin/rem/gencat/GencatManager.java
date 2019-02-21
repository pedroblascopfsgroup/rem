package es.pfsgroup.plugin.rem.gencat;

import java.lang.reflect.InvocationTargetException;
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
import es.capgemini.pfs.auditoria.model.Auditoria;
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
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.AdecuacionGencatDao;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatAdjuntoDao;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatDao;
import es.pfsgroup.plugin.rem.activo.dao.HistoricoComunicacionGencatAdjuntoDao;
import es.pfsgroup.plugin.rem.activo.dao.NotificacionGencatDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.AdecuacionGencatApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
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
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
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
import es.pfsgroup.plugin.rem.model.DtoGencat;
import es.pfsgroup.plugin.rem.model.DtoGencatSave;
import es.pfsgroup.plugin.rem.model.DtoHistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoImpuestosActivo;
import es.pfsgroup.plugin.rem.model.DtoNotificacionActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasAsociadasActivo;
import es.pfsgroup.plugin.rem.model.DtoReclamacionActivo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoAdecuacionGencat;
import es.pfsgroup.plugin.rem.model.HistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.HistoricoComunicacionGencatAdjunto;
import es.pfsgroup.plugin.rem.model.HistoricoNotificacionGencat;
import es.pfsgroup.plugin.rem.model.HistoricoOfertaGencat;
import es.pfsgroup.plugin.rem.model.HistoricoReclamacionGencat;
import es.pfsgroup.plugin.rem.model.HistoricoVisitaGencat;
import es.pfsgroup.plugin.rem.model.ImpuestosActivo;
import es.pfsgroup.plugin.rem.model.NotificacionGencat;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VExpPreBloqueoGencat;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.VisitaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDCalculoImpuesto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosVisitaOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSancionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoComunicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoNotificacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;

@Service("gencatManager")
public class GencatManager extends  BusinessOperationOverrider<GencatApi> implements GencatApi {
	
	protected static final Log logger = LogFactory.getLog(GencatManager.class);
	
	public static final String DD_TIPO_DOCUMENTO_CODIGO_NIF = "15";
	
	private SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
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
	private NotificacionGencatDao motificacionGencatDao;
	
	@Autowired
	private AdecuacionGencatDao adecuacionGencatDao;
	
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

	private static final Long MIN_MESES = 60L;

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
	private ActivoDao activoDao;
	
	
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
				}
				
				//Oferta
				gencatDto.setOfertasAsociadasEstanAnuladas(true);
				List <OfertaGencat> resultOfertaGencatGencat = genericDao.getListOrdered(OfertaGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultOfertaGencatGencat != null && !resultOfertaGencatGencat.isEmpty()) {
					OfertaGencat ofertaGencat = resultOfertaGencatGencat.get(0);
					Oferta oferta = ofertaGencat.getOferta();
					if (oferta != null) {
						gencatDto.setOfertaGencat(oferta.getNumOferta());
					}
					for (OfertaGencat ofertGencat : resultOfertaGencatGencat) {
						if(!Checks.esNulo(ofertGencat)) {
							if(!Checks.esNulo(ofertGencat.getOferta())) {
								if(!Checks.esNulo(ofertGencat.getOferta().getEstadoOferta())) {
									if(!ofertGencat.getOferta().getEstadoOferta().getCodigo().equals(DDEstadoOferta.CODIGO_RECHAZADA)) {
										gencatDto.setOfertasAsociadasEstanAnuladas(false);
									}
								}
							}
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
		
		if (!Checks.esNulo(comunicacionGencat)) {
			
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
							gexc.printStackTrace();
							logger.debug(gexc.getMessage());
						}
	
					}
					try {
						throw gex;
					} catch (GestorDocumentalException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
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

		for (ComunicacionGencatAdjunto referenciaAdjunto : comunicacion.getAdjuntos()) {
			DtoAdjunto dto = new DtoAdjunto();

			AdjuntoComunicacion adjunto = referenciaAdjunto.getAdjuntoComunicacion();
			BeanUtils.copyProperties(dto, adjunto);
			dto.setIdEntidad(idActivo);
			dto.setDescripcionTipo(adjunto.getTipoDocumentoComunicacion().getDescripcion());
			dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());

			listaAdjuntos.add(dto);
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
				BeanUtils.copyProperties(gencatDto, hComunicacionGencat);
				gencatDto.setSancion(hComunicacionGencat.getSancion() != null ? hComunicacionGencat.getSancion().getCodigo() : null);
				gencatDto.setEstadoComunicacion(hComunicacionGencat.getEstadoComunicacion() != null ? hComunicacionGencat.getEstadoComunicacion().getCodigo() : null);
				
				Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "historicoComunicacion.id", hComunicacionGencat.getId());
				Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
				
				//Adecuacion
				List <HistoricoAdecuacionGencat> resultAdecuacion = genericDao.getListOrdered(HistoricoAdecuacionGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultAdecuacion != null && !resultAdecuacion.isEmpty()) {
					HistoricoAdecuacionGencat adecuacionGencat = resultAdecuacion.get(0);
					BeanUtils.copyProperties(gencatDto, adecuacionGencat);
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
						gencatDto.setOfertaGencat(oferta.getNumOferta());
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
				
				dtoOfertasAsociadasActivo.setFechaPreBloqueo(hComunicacionGencat.getFechaPreBloqueo());
				dtoOfertasAsociadasActivo.setNumOferta(oferta.getNumOferta());
				dtoOfertasAsociadasActivo.setImporteOferta(ofertaGencat.getImporte());
				dtoOfertasAsociadasActivo.setTipoComprador(ofertaGencat.getTiposPersona().getDescripcion());
				dtoOfertasAsociadasActivo.setSituacionOcupacional(ofertaGencat.getSituacionPosesoria().getDescripcion());
				
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
				listaAdjuntos = getAdjuntosComunicacionHistoricoGD(hComunicacionGencat, listaAdjuntos);
			} 
			else {
				listaAdjuntos = getAdjuntosComunicacionHistorico(hComunicacionGencat, listaAdjuntos);
			}
			
		}
		
		return listaAdjuntos;
		
	}
	
	private List<DtoAdjunto> getAdjuntosComunicacionHistorico(HistoricoComunicacionGencat hComunicacionGencat, List<DtoAdjunto> listaAdjuntos) 
			throws IllegalAccessException, InvocationTargetException {
		
		for (HistoricoComunicacionGencatAdjunto referenciaAdjunto : hComunicacionGencat.getAdjuntos()) {
			DtoAdjunto dto = new DtoAdjunto();

			AdjuntoComunicacion adjunto = referenciaAdjunto.getAdjuntoComunicacion();
			BeanUtils.copyProperties(dto, adjunto);
			dto.setIdEntidad(hComunicacionGencat.getActivo().getId());
			dto.setDescripcionTipo(adjunto.getTipoDocumentoComunicacion().getDescripcion());
			dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());

			listaAdjuntos.add(dto);
		}
		return listaAdjuntos;
	}
	
	private List<DtoAdjunto> getAdjuntosComunicacionHistoricoGD(HistoricoComunicacionGencat hComunicacionGencat, List<DtoAdjunto> listaAdjuntos) 
			throws IllegalAccessException, InvocationTargetException {
		
		Activo activo = activoApi.get(hComunicacionGencat.getActivo().getId());
		
		for (HistoricoComunicacionGencatAdjunto referenciaAdjunto : hComunicacionGencat.getAdjuntos()) {
			DtoAdjunto dto = new DtoAdjunto();
			
			Long idAdjuntoGD = referenciaAdjunto.getAdjuntoComunicacion().getIdDocRestClient();

			if (!Checks.esNulo(idAdjuntoGD)) {
				
				ActivoAdjuntoActivo adjunto = activo.getAdjuntoGD(idAdjuntoGD);
				if (!Checks.esNulo(adjunto)) {
					BeanUtils.copyProperties(dto, adjunto);
					dto.setIdEntidad(activo.getId());
					dto.setId(idAdjuntoGD);
					if (!Checks.esNulo(adjunto.getTipoDocumentoActivo())) {
						dto.setDescripcionTipo(adjunto.getTipoDocumentoActivo().getDescripcion());
					}
					dto.setContentType(adjunto.getContentType());
					if (!Checks.esNulo(adjunto.getAuditoria())) {
						dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());
					}
					dto.setTamanyo(adjunto.getTamanyo());
					listaAdjuntos.add(dto);
				}
			}
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
				
				adjuntoComunicacion.setComunicacionGencat(comunicacionGencat);

				adjuntoComunicacion.setIdDocRestClient(idDocRestClient);

				adjuntoComunicacion.setTipoDocumentoComunicacion(tipoDocumento);

				adjuntoComunicacion.setContentType(webFileItem.getFileItem().getContentType());

				adjuntoComunicacion.setTamanyo(webFileItem.getFileItem().getLength());

				adjuntoComunicacion.setNombre(webFileItem.getFileItem().getFileName());

				adjuntoComunicacion.setDescripcion(webFileItem.getParameter("descripcion"));

				adjuntoComunicacion.setFechaDocumento(new Date());
								
				String fechaNotificacion = webFileItem.getParameter("fechaNotificacion");
				SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
						Date fNotificacion = sdf.parse(fechaNotificacion);
				
				adjuntoComunicacion.setFechaNotificacion(fNotificacion);

				genericDao.save(AdjuntoComunicacion.class, adjuntoComunicacion);
				String idHComunicacion = webFileItem.getParameter("idHComunicacion");
				
				agregarReferenciaComunicacionAdjunto(null, activo, usuarioLogado, idHComunicacion,comunicacionGencat,adjuntoComunicacion);
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
					dtoNotificacionActivo.setMotivoNotificacion(historicoNotificacionGencatlist.get(i).getTipoNotificacion() != null ? historicoNotificacionGencatlist.get(i).getTipoNotificacion().getDescripcion() : null);
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
				
				Filter filtroIdTipoNotificacion = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoNotificacion.getMotivoNotificacion());
				
				DDTipoNotificacionGencat tipoNotificacionGencat = genericDao.get(DDTipoNotificacionGencat.class, filtroIdTipoNotificacion, filtroBorrado);
				
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				SimpleDateFormat dateformat3 = new SimpleDateFormat("dd/MM/yyyy");
				
				Date fechaNotificacion = dateformat3.parse(dtoNotificacion.getFechaNotificacion());
				Date fechaSancion = dateformat3.parse(dtoNotificacion.getFechaSancionNotificacion());
				Date fechaCierre = dateformat3.parse(dtoNotificacion.getCierreNotificacion());
				
				//Insertar Notificacion
				NotificacionGencat notificacion = new NotificacionGencat();
				notificacion.setCheckNotificacion(true);
				notificacion.setComunicacion(comunicacionGencat);
				
				notificacion.setFechaNotificacion(fechaNotificacion);
				notificacion.setTipoNotificacion(tipoNotificacionGencat);
				notificacion.setFechaSancionNotificacion(fechaSancion);
				notificacion.setCierreNotificacion(fechaCierre);
				
				Auditoria auditoria = new Auditoria();
				auditoria.setBorrado(false);
				auditoria.setFechaCrear(new Date());
				auditoria.setUsuarioCrear(usuarioLogado.getApellidoNombre());
				
				notificacion.setVersion(new Long(0));
				notificacion.setAuditoria(auditoria);
				
				motificacionGencatDao.save(notificacion);
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
		
		CompradorExpediente compradorExp = genericDao.get(CompradorExpediente.class, genericDao.createFilter(FilterType.EQUALS,"expediente",expComercial.getId()));
		
		if(!Checks.esNulo(compradorExp)) {
			comprador = genericDao.get(Comprador.class, genericDao.createFilter(FilterType.EQUALS,"id",compradorExp.getComprador()));
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
				//TODO REVISAR CONDICIONES DE ULTIMA OFERTA QUE PROVOCO LA COMUNICACION CON LOS DATOS DEL EXPEDIENTE QUE SE RECOGEN
				comGencat = genericDao.get(ComunicacionGencat.class, genericDao.createFilter(FilterType.EQUALS,"activo.id", idActivo));
				if(!Checks.esNulo(expComercial.getCondicionante())) {
					if(!Checks.esNulo(expComercial.getCondicionante().getSituacionPosesoria())){
						codSitPos = expComercial.getCondicionante().getSituacionPosesoria().getCodigo();
					}
						
					if(!Checks.esNulo(comprador) && !Checks.esNulo(comprador.getTipoPersona())) {
						codTipoPer = comprador.getTipoPersona().getCodigo();
					}
						
						//TODO COMPROBACION CONDICIONANTES
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
					}else {
						if(!Checks.esNulo(comGencat.getSancion())) {
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
				if(!Checks.esNulo(comGencat.getEstadoComunicacion())
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
		Long diferenciaEn_ms = fechaActual.getTime() - fechaComparar.getTime();
		Long dias = diferenciaEn_ms / (1000 * 60 * 60 * 24);
		return dias;
	}
		
	@Override
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
		comunicacionGencat.setActivo(activoApi.get(idActivo));
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
		
		// Creamos la nueva adecuación, habiendo creado previamente la comunicación
		adecuacionGencat.setComunicacion(comunicacionGencat);
		adecuacionGencat.setAuditoria(auditoria);
		adecuacionGencat.setVersion(0L);
		
		// TODO Crear notificacionGencat, visitaGencat, reclamacionGencat y la tabla nueva que no esta creada
		

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
//				NotificacionGencat notificacionGencat = notificacionGencatApi.getNotificacionByIdComunicacionGencat(idComunicacionGencat);
//				ReclamacionGencat reclamacionGencat = reclamacionGencatApi.getReclamacionByIdComunicacionGencat(idComunicacionGencat);
//				VisitaGencat visitaGencat = visitaGencatApi.getVisitaByIdComunicacionGencat(idComunicacionGencat);
				
				if(!Checks.esNulo(comunicacionGencat)
						&& !Checks.esNulo(adecuacionGencat)
						&& !Checks.esNulo(ofertaGencat)) {
					
					// Historificacion del tramite de GENCAT
					HistoricoComunicacionGencat historicoComunicacionGencat = crearHistoricoComunicacionGencatByComunicacionGencat(comunicacionGencat);
					crearHistoricoAdecuacionGencatByAdecuacionGencat(adecuacionGencat, historicoComunicacionGencat);
					crearHistoricoOfertaGencatByOfertaGencat(ofertaGencat, historicoComunicacionGencat);
//					crearHistoricoNotificacionGencatByNotificacionGencat(notificacionGencat, historicoComunicacionGencat);
//					crearHistoricoReclamacionGencatByNotificacionGencat(reclamacionGencat, historicoComunicacionGencat);
//					crearHistoricoVisitaGencatByNotificacionGencat(visitaGencat, historicoComunicacionGencat);
					
					// Borrado del registro vigente del tramite de GENCAT
					borrarTramiteGENCAT(comunicacionGencat, adecuacionGencat, ofertaGencat, null, null, null);
					
				}
				
			}
			
		}
		
	}
	
	private void borrarTramiteGENCAT(ComunicacionGencat comunicacionGencat, AdecuacionGencat adecuacionGencat, OfertaGencat ofertaGencat,
			NotificacionGencat notificacionGencat, ReclamacionGencat reclamacionGencat, VisitaGencat visitaGencat) {
		
		if(!Checks.esNulo(comunicacionGencat.getId())
				&& !Checks.esNulo(adecuacionGencat.getId())
				&& !Checks.esNulo(ofertaGencat.getId())
//				&& !Checks.esNulo(notificacionGencat.getId())
//				&& !Checks.esNulo(reclamacionGencat.getId())
//				&& !Checks.esNulo(visitaGencat.getId())
				) {

			// TODO eliminar metodo y añadir los DAO correspondientes
			activoAgrupacionActivoDao.deleteTramiteGencatById(adecuacionGencat.getId(), ofertaGencat.getId(), null, 
					null, null, comunicacionGencat.getId());
			
		}
	}
	
	@Transactional(readOnly = false)
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
		
		return historicoComunicacionGencat;
		
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
			
		}
		
		genericDao.save(HistoricoNotificacionGencat.class, historicoNotificacionGencat);
		
	}
	
	@Transactional(readOnly = false)
	private void crearHistoricoReclamacionGencatByNotificacionGencat(ReclamacionGencat reclamacionGencat, HistoricoComunicacionGencat historicoComunicacionGencat) {
		
		HistoricoReclamacionGencat historicoReclamacionGencat = new HistoricoReclamacionGencat();
		
		if(!Checks.esNulo(reclamacionGencat)) {
			historicoReclamacionGencat.setHistoricoComunicacion(historicoComunicacionGencat);
			historicoReclamacionGencat.setFechaAviso(reclamacionGencat.getFechaAviso());			
			historicoReclamacionGencat.setFechaReclamacion(reclamacionGencat.getFechaReclamacion());
			historicoReclamacionGencat.setVersion(reclamacionGencat.getVersion());
			historicoReclamacionGencat.setAuditoria(reclamacionGencat.getAuditoria());
			
		}
		
		genericDao.save(HistoricoReclamacionGencat.class, historicoReclamacionGencat);
		
	}
	
	private void crearHistoricoVisitaGencatByNotificacionGencat(VisitaGencat visitaGencat, HistoricoComunicacionGencat historicoComunicacionGencat) {
		
		HistoricoVisitaGencat historicoVisitaGencat = new HistoricoVisitaGencat();
		
		if(!Checks.esNulo(visitaGencat)) {
			historicoVisitaGencat.setHistoricoComunicacion(historicoComunicacionGencat);
			historicoVisitaGencat.setVisita(visitaGencat.getVisita());
			historicoVisitaGencat.setVersion(visitaGencat.getVersion());
			historicoVisitaGencat.setAuditoria(visitaGencat.getAuditoria());
			
		}
		
		genericDao.save(HistoricoVisitaGencat.class, historicoVisitaGencat);
		
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
				
				notificacionesGencat.sendMailNotificacionSancionGencat(gencatDto, activo, sancion);

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
					notificacionesGencat.sendMailNotificacionSancionGencat(gencatDto, activo, sancion);

					return true;
				}
			}
			
			
		}
		
		return false;
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
				e.printStackTrace();
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
		
		AdjuntoComunicacion adjunto = genericDao.get(AdjuntoComunicacion.class, genericDao.createFilter(FilterType.EQUALS, "comunicacionGencat.id",comunicacionGencat.getId()),genericDao.createFilter(FilterType.EQUALS, "idDocRestClient",dtoAdjunto.getId()));
		genericDao.deleteById(AdjuntoComunicacion.class, adjunto.getId());
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
		nuevaOferta.setOrigen(oferta.getOrigen());
		nuevaOferta.setOfertaExpress(oferta.getOfertaExpress());
		
		nuevaOferta.setImporteOferta(oferta.getImporteOferta());
		nuevaOferta.setCanalPrescripcion(oferta.getCanalPrescripcion());
		nuevaOferta.setPrescriptor(oferta.getPrescriptor());
		
		// Activo/s
		List<ActivoOferta> listaActOfr = ofertaApi.buildListaActivoOferta(cmg.getActivo(), null, nuevaOferta);
		nuevaOferta.setActivosOferta(listaActOfr);
		
		//  Comprador
		ClienteComercial clienteComercial = new ClienteComercial();
		Long clcremid = activoDao.getNextClienteRemId();
		clienteComercial.setIdClienteRem(clcremid);
		clienteComercial.setNombre(cmg.getNuevoCompradorNombre());
		clienteComercial.setApellidos(cmg.getNuevoCompradorApellido1()+" "+cmg.getNuevoCompradorApellido2());
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
				.dameValorDiccionarioByCod(DDSubtipoTrabajo.class, activoApi.getSubtipoTrabajoByOferta(nuevaOferta));
		Trabajo trabajo = trabajoApi.create(subtipoTrabajo, listaActivos, null, false);
		ExpedienteComercial nuevoExpedienteComercial = activoApi.crearExpediente(nuevaOferta, trabajo, oferta);
		trabajoApi.createTramiteTrabajo(trabajo);
		
		
		nuevoExpedienteComercial.setConflictoIntereses(expedienteComercial.getConflictoIntereses());
		nuevoExpedienteComercial.setRiesgoReputacional(expedienteComercial.getRiesgoReputacional());
		nuevoExpedienteComercial.setEstadoPbc(expedienteComercial.getEstadoPbc());
		
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
			condicionesNuevas.setSolicitaReserva(condiciones.getSolicitaReserva());
			condicionesNuevas.setTipoCalculoReserva(condiciones.getTipoCalculoReserva());
			condicionesNuevas.setPorcentajeReserva(condiciones.getPorcentajeReserva());
			condicionesNuevas.setPlazoFirmaReserva(condiciones.getPlazoFirmaReserva());
			condicionesNuevas.setImporteReserva(condiciones.getImporteReserva());
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
		ofertaGencat.setImporte(nuevaOferta.getImporteOferta());
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
		/*
		List<ActivoAgrupacionActivo> listaAGR = activoAgrupacionActivoDao.getListActivoAgrupacionVentaByIdActivo(cmg.getActivo().getId());
		
		for (ActivoAgrupacionActivo aga : listaAGR) {
			List<Oferta> lista = activoApi.getOfertasPendientesOTramitadasByActivoAgrupacion(aga.getAgrupacion());
			for (Oferta ofr : lista) {
				ofertaApi.congelarOferta(ofr);
			}
			
		}
		*/
	/////////////////////////////////////////////////////////////////
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
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			genericDao.update(ReclamacionGencat.class, reclamacion);

			return true;
		}
		
		return false;
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
		
		long cmg = comunicacionGencat.getId();
		
		Filter filtroCmgId = genericDao.createFilter(FilterType.EQUALS, "comunicacionGencat.id", cmg);
		
		List <AdjuntoComunicacion> resultAdjuntoComunicacion = genericDao.getList(AdjuntoComunicacion.class, filtroCmgId);
		
		if (!Checks.esNulo(resultAdjuntoComunicacion)) {
			for(AdjuntoComunicacion cga: resultAdjuntoComunicacion) {
				if(cga.getTipoDocumentoComunicacion().getCodigo().equals(DDTipoDocumentoComunicacion.CODIGO_ANULACION_OFERTA_GENCAT)) {
					return true;
				}else {
					return false;
				}
			}
		}else {
			return false;
		}
		
		return false;
	}
}
