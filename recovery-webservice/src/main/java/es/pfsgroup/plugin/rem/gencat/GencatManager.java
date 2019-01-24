package es.pfsgroup.plugin.rem.gencat;

import java.lang.reflect.InvocationTargetException;
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
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatAdjuntoDao;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatDao;
import es.pfsgroup.plugin.rem.activo.dao.HistoricoComunicacionGencatAdjuntoDao;
import es.pfsgroup.plugin.rem.activo.dao.NotificacionGencatDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.AdecuacionGencatApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.OfertaGencatApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.AdecuacionGencat;
import es.pfsgroup.plugin.rem.model.Comprador;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ComunicacionGencatAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoGencat;
import es.pfsgroup.plugin.rem.model.DtoGencatSave;
import es.pfsgroup.plugin.rem.model.DtoHistoricoComunicacionGencat;
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
import es.pfsgroup.plugin.rem.model.NotificacionGencat;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;
import es.pfsgroup.plugin.rem.model.VExpPreBloqueoGencat;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.VisitaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDSancionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoNotificacionGencat;

@Service("gencatManager")
public class GencatManager extends  BusinessOperationOverrider<GencatApi> implements GencatApi {
	
	protected static final Log logger = LogFactory.getLog(GencatManager.class);
	
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
	private ActivoDao activoDao;
	
	@Autowired
	private ComunicacionGencatAdjuntoDao comunicacionGencatAdjuntoDao;
	
	@Autowired
	private HistoricoComunicacionGencatAdjuntoDao historicoComunicacionGencatAdjuntoDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private NotificacionGencatDao motificacionGencatDao;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private ComunicacionGencatDao comunicacionGencatDao;
	
	@Autowired
	private AdecuacionGencatApi adecuacionGencatApi;
	
	@Autowired
	private OfertaGencatApi ofertaGencatApi;
	
	@Autowired 
	private OfertaApi ofertaApi;

	private static final Long MIN_MESES = 60L;

	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	protected JBPMActivoTramiteManager jbpmActivoTramiteManager;
	
	@Autowired
	protected TipoProcedimientoManager tipoProcedimientoManager;
	
	
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
				BeanUtils.copyProperties(gencatDto, comunicacionGencat);
				gencatDto.setSancion(comunicacionGencat.getSancion() != null ? comunicacionGencat.getSancion().getCodigo() : null);
				gencatDto.setEstadoComunicacion(comunicacionGencat.getEstadoComunicacion() != null ? comunicacionGencat.getEstadoComunicacion().getCodigo() : null);
				
				Filter filtroIdComunicacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", comunicacionGencat.getId());
				
				//Adecuacion
				List <AdecuacionGencat> resultAdecuacion = genericDao.getListOrdered(AdecuacionGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultAdecuacion != null && !resultAdecuacion.isEmpty()) {
					AdecuacionGencat adecuacionGencat = resultAdecuacion.get(0);
					BeanUtils.copyProperties(gencatDto, adecuacionGencat);
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
				List <OfertaGencat> resultOfertaGencatGencat = genericDao.getListOrdered(OfertaGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultOfertaGencatGencat != null && !resultOfertaGencatGencat.isEmpty()) {
					OfertaGencat ofertaGencat = resultOfertaGencatGencat.get(0);
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
				dtoOfertasAsociadasActivo.setTipoComprador(ofertaGencat.getTiposPersona().getDescripcion());
				dtoOfertasAsociadasActivo.setSituacionOcupacional(ofertaGencat.getSituacionPosesoria().getDescripcion());
				
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
				listaAdjuntos = getAdjuntosComunicacionGD(idActivo, comunicacionGencat, listaAdjuntos);

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

			ActivoAdjuntoActivo adjunto = referenciaAdjunto.getActivoAdjuntoActivo();
			BeanUtils.copyProperties(dto, adjunto);
			dto.setIdEntidad(idActivo);
			dto.setDescripcionTipo(adjunto.getTipoDocumentoActivo().getDescripcion());
			dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());

			listaAdjuntos.add(dto);
		}
		return listaAdjuntos;
	}
	
	private List<DtoAdjunto> getAdjuntosComunicacionGD(Long idActivo, ComunicacionGencat comunicacion, List<DtoAdjunto> listaAdjuntos) 
			throws IllegalAccessException, InvocationTargetException {
		
		Activo activo = activoApi.get(idActivo);

		for (ComunicacionGencatAdjunto referenciaAdjunto : comunicacion.getAdjuntos()) {
			DtoAdjunto dto = new DtoAdjunto();
			
			Long idAdjuntoGD = referenciaAdjunto.getActivoAdjuntoActivo().getIdDocRestClient();

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

			ActivoAdjuntoActivo adjunto = referenciaAdjunto.getActivoAdjuntoActivo();
			BeanUtils.copyProperties(dto, adjunto);
			dto.setIdEntidad(hComunicacionGencat.getActivo().getId());
			dto.setDescripcionTipo(adjunto.getTipoDocumentoActivo().getDescripcion());
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
			
			Long idAdjuntoGD = referenciaAdjunto.getActivoAdjuntoActivo().getIdDocRestClient();

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
	public String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, Activo activoEntrada, String matricula, Usuario usuarioLogado) throws Exception {
		Activo activo = null;
		DDTipoDocumentoActivo tipoDocumento = null;
		if (Checks.esNulo(activoEntrada)) {
			activo = activoApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));

			if (webFileItem.getParameter("tipo") == null)
				throw new Exception("Tipo no valido");

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class, filtro);
			
		} else {
			activo = activoEntrada;
			if (!Checks.esNulo(matricula)) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
				tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class, filtro);
			}
			if (tipoDocumento == null) {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
				tipoDocumento = (DDTipoDocumentoActivo) genericDao.get(DDTipoDocumentoActivo.class, filtro);
			}
		}

		try {
			if (!Checks.esNulo(activo) && !Checks.esNulo(tipoDocumento)) {

				Adjunto adj = uploadAdapter.saveBLOB(webFileItem.getFileItem());

				ActivoAdjuntoActivo adjuntoActivo = new ActivoAdjuntoActivo();
				adjuntoActivo.setAdjunto(adj);
				adjuntoActivo.setActivo(activo);

				adjuntoActivo.setIdDocRestClient(idDocRestClient);

				adjuntoActivo.setTipoDocumentoActivo(tipoDocumento);

				adjuntoActivo.setContentType(webFileItem.getFileItem().getContentType());

				adjuntoActivo.setTamanyo(webFileItem.getFileItem().getLength());

				adjuntoActivo.setNombre(webFileItem.getFileItem().getFileName());

				adjuntoActivo.setDescripcion(webFileItem.getParameter("descripcion"));

				adjuntoActivo.setFechaDocumento(new Date());

				Auditoria.save(adjuntoActivo);

				activo.getAdjuntos().add(adjuntoActivo);

				activoDao.save(activo);
				
				String idHComunicacion = webFileItem.getParameter("idHComunicacion");
				
				agregarReferenciaComunicacionAdjunto(adj, activo, usuarioLogado, idHComunicacion);
			} 
			else {
				throw new Exception("No se ha encontrado activo o tipo para relacionar adjunto");
			}
		} catch (Exception e) {
			logger.error("Error en gencatManager", e);
		}

		return null;

	}
	
	private void agregarReferenciaComunicacionAdjunto(Adjunto adjunto, Activo activo, Usuario usuarioLogado, String idHComunicacionString) {
		
		Filter filtroIdAdjunto = genericDao.createFilter(FilterType.EQUALS, "adjunto.id", adjunto.getId());
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false); 
		Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
		
		//Datos del nuevo fichero subido
		List <ActivoAdjuntoActivo> resultActivoAdjuntoActivo = genericDao.getListOrdered(ActivoAdjuntoActivo.class, orderByFechaCrear, filtroIdAdjunto, filtroIdActivo, filtroBorrado);
		ActivoAdjuntoActivo activoAdjuntoActivo = null;
		if (!Checks.esNulo(resultActivoAdjuntoActivo) && !resultActivoAdjuntoActivo.isEmpty()) {
			activoAdjuntoActivo = resultActivoAdjuntoActivo.get(0);
		}
		
		if (!Checks.esNulo(idHComunicacionString)) {
			
			Long idHComunicacion = Long.parseLong(idHComunicacionString);
			
			Filter filtroHComunicacionId = genericDao.createFilter(FilterType.EQUALS, "id", idHComunicacion);
			
			//Datos de la comunicación del histórico
			HistoricoComunicacionGencat hComunicacionGencat = genericDao.get(HistoricoComunicacionGencat.class, filtroHComunicacionId, filtroBorrado);
			
			if (!Checks.esNulo(activoAdjuntoActivo) && !Checks.esNulo(hComunicacionGencat)) {
				
				HistoricoComunicacionGencatAdjunto referenciaComunicacionHistoricoAdjunto = new HistoricoComunicacionGencatAdjunto();
				referenciaComunicacionHistoricoAdjunto.setActivoAdjuntoActivo(activoAdjuntoActivo);
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
			
			//Datos de la comunicación del activo
			List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroIdActivo, filtroBorrado);
			ComunicacionGencat comunicacionGencat = null;
			if (!Checks.esNulo(resultComunicacion) && !resultComunicacion.isEmpty()) {
				comunicacionGencat = resultComunicacion.get(0);
			}
			
			if (!Checks.esNulo(activoAdjuntoActivo) && !Checks.esNulo(comunicacionGencat)) {
				ComunicacionGencatAdjunto referenciaComunicacionAdjunto = new ComunicacionGencatAdjunto();
				referenciaComunicacionAdjunto.setActivoAdjuntoActivo(activoAdjuntoActivo);
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
	public void bloqueoExpedienteGENCAT(ExpedienteComercial expComercial, ActivoTramite tramite) {
		
		Date fechaActual = new Date();
		Oferta oferta = expComercial.getOferta();
		Comprador comprador = new Comprador();
		
		CompradorExpediente compradorExp = genericDao.get(CompradorExpediente.class, genericDao.createFilter(FilterType.EQUALS,"expediente",expComercial.getId()));
		
		if(!Checks.esNulo(compradorExp)) {
			comprador = genericDao.get(Comprador.class, genericDao.createFilter(FilterType.EQUALS,"id",compradorExp.getComprador()));
		}
		List<ActivoOferta> listActivosOferta = expComercial.getOferta().getActivosOferta();
		Activo activo = new Activo();
		String codSitPos = "0";
		String codTipoPer = "0";
		ComunicacionGencat comGencat = new ComunicacionGencat();
		VExpPreBloqueoGencat datoVista = null;
		
		for (ActivoOferta activoOferta : listActivosOferta) {
			activo = activoOferta.getPrimaryKey().getActivo();
			
			List<VExpPreBloqueoGencat> listDatosVista = genericDao.getList(VExpPreBloqueoGencat.class, 
					genericDao.createFilter(FilterType.EQUALS,"idActivo", activo.getId()));

			if(!Checks.estaVacio(listDatosVista)) {
				//Pillar 1º registro que es el mas reciente para comparar los condicionantes
				datoVista = listDatosVista.get(0);
				//COMPROBACION SI HAY COMUNICACION GENCAT CREADA
				
				if(!Checks.esNulo(datoVista.getFecha_comunicacion())) {
					//TODO REVISAR CONDICIONES DE ULTIMA OFERTA QUE PROVOCO LA COMUNICACION CON LOS DATOS DEL EXPEDIENTE QUE SE RECOGEN
					comGencat = genericDao.get(ComunicacionGencat.class, genericDao.createFilter(FilterType.EQUALS,"activo.id", activo.getId()));
					if(!Checks.esNulo(expComercial.getCondicionante())) {
						if(!Checks.esNulo(expComercial.getCondicionante().getSituacionPosesoria())){
							codSitPos = expComercial.getCondicionante().getSituacionPosesoria().getCodigo();
							
							
							if(!Checks.esNulo(comprador) && !Checks.esNulo(comprador.getTipoPersona())) {
								codTipoPer = comprador.getTipoPersona().getCodigo();
							}
							
							//TODO COMPROBACION CONDICIONANTES
							if(codSitPos.equals(datoVista.getSituacionPosesoria()) 
									&& codTipoPer.equals(datoVista.getTipoPersona())
									&& (!Checks.esNulo(oferta.getImporteOferta()) ? oferta.getImporteOferta() : new Double(0)).equals(datoVista.getImporteOferta())) {
								
								//COMPROBACION OFERTA ULTIMA SANCION:
									//SI DD_ECG_CODIGO SANCIONADA SE COMPARA TIEMPO SANCION AL TIEMPO ACTUAL:
										//SI TIEMPO > 2 MESES LANZAR TRAMITE GENCAT
										//SI TIEMPO < 2 MESES NO HACER NADA.
								if(!Checks.esNulo(comGencat.getEstadoComunicacion())
										&& DDEstadoComunicacionGencat.COD_SANCIONADO.equalsIgnoreCase(comGencat.getEstadoComunicacion().getDescripcion())
										&& !Checks.esNulo(datoVista.getFecha_sancion())) {
									
									if(MIN_MESES > calculoDiferenciaFechasEnDias(fechaActual,datoVista.getFecha_sancion())){
										
										lanzarTramiteGENCAT(tramite, oferta, expComercial);
										
									}
									
								}
									//SI DD_ECG_CODIGO ANULADA Y CMG_FECHA_ANULACION RELLENA LANZA TRAMITE GENCAT
								if(!Checks.esNulo(comGencat.getEstadoComunicacion())
										&& DDEstadoComunicacionGencat.COD_ANULADO.equals(comGencat.getEstadoComunicacion().getCodigo())
										&& !Checks.esNulo(datoVista.getFecha_anulacion())) {
									
									lanzarTramiteGENCAT(tramite, oferta, expComercial);
								}
									//SI DD_ECG_CODIGO ANULADA Y CMG_FECHA_ANULACION NULL SE COMPARA TIEMPO SANCION AL TIEMPO ACTUAL:
										//SI TIEMPO < 2 MESES NO HACER NADA.
								if(!Checks.esNulo(comGencat.getEstadoComunicacion())
										&& DDEstadoComunicacionGencat.COD_ANULADO.equals(comGencat.getEstadoComunicacion().getCodigo())
										&& Checks.esNulo(datoVista.getFecha_anulacion())) {
									if(MIN_MESES > calculoDiferenciaFechasEnDias(fechaActual,datoVista.getFecha_sancion())){
										
										lanzarTramiteGENCAT(tramite, oferta, expComercial);
										
									}
									
								}
								
							}else {								
								lanzarTramiteGENCAT(tramite, oferta, expComercial);
							}
							
						}
						
					}
					
				}else {					
					lanzarTramiteGENCAT(tramite, oferta, expComercial);
				}
				
			}else {				
				lanzarTramiteGENCAT(tramite, oferta, expComercial);
			}
			
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
	public void lanzarTramiteGENCAT(ActivoTramite tramite, Oferta oferta, ExpedienteComercial expedienteComercial) {
		
		historificarTramiteGENCAT(tramite);
		crearRegistrosTramiteGENCAT(expedienteComercial, oferta, tramite);
		
		ActivoTramite tramiteNuevo = jbpmActivoTramiteManager.createActivoTramiteTrabajo(
				tipoProcedimientoManager.getByCodigo(ActivoTramiteApi.CODIGO_TRAMITE_COMUNICACION_GENCAT), 
				tramite.getTrabajo());
		tramiteNuevo.setActivo(tramite.getActivo());
		
		jbpmActivoTramiteManager.lanzaBPMAsociadoATramite(tramiteNuevo.getId());
				
	}
	
	@Override
	public void crearRegistrosTramiteGENCAT(ExpedienteComercial expedienteComercial, Oferta oferta, ActivoTramite tramite) {
		
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
		comunicacionGencat.setActivo(oferta.getActivoPrincipal());
		comunicacionGencat.setComunicadoAnulacionAGencat(false);
		comunicacionGencat.setEstadoComunicacion(estadoComunicacion);
		comunicacionGencat.setFechaPreBloqueo(new Date());
		comunicacionGencat.setVersion(0L);
		
		// Creamos la nueva oferta, habiendo creado previamente la comunicación
		ofertaGencat.setOferta(expedienteComercial.getOferta());
		ofertaGencat.setComunicacion(comunicacionGencat);
		ofertaGencat.setImporte(oferta.getImporteOferta());
		if(!Checks.esNulo(expedienteComercial.getOferta())) {
			
			ofertaGencat.setIdOfertaAnterior(expedienteComercial.getOferta().getId());
			
		}
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

		genericDao.save(ComunicacionGencat.class, comunicacionGencat);
		genericDao.save(OfertaGencat.class, ofertaGencat);
		genericDao.save(AdecuacionGencat.class, adecuacionGencat);
		
	}
	
	@Override
	public void historificarTramiteGENCAT(ActivoTramite tramite) {
				
		if(!Checks.esNulo(tramite)) {
			
			ComunicacionGencat comunicacionGencat = genericDao.get(ComunicacionGencat.class, 
					genericDao.createFilter(FilterType.EQUALS,"activo.id", tramite.getActivo().getId()));
			
			if(!Checks.esNulo(comunicacionGencat)) {
				Long idComunicacionGencat = comunicacionGencat.getId();
				
				AdecuacionGencat adecuacionGencat = adecuacionGencatApi.getAdecuacionByIdComunicacion(idComunicacionGencat);
				OfertaGencat ofertaGencat = ofertaGencatApi.getOfertaByIdComunicacionGencat(idComunicacionGencat);
				
				if(!Checks.esNulo(comunicacionGencat)
						&& !Checks.esNulo(adecuacionGencat)
						&& !Checks.esNulo(ofertaGencat)) {
					
					// Historificacion del tramite de GENCAT
					HistoricoComunicacionGencat historicoComunicacionGencat = crearHistoricoComunicacionGencatByComunicacionGencat(comunicacionGencat);
					crearHistoricoAdecuacionGencatByAdecuacionGencat(adecuacionGencat, historicoComunicacionGencat);
					crearHistoricoOfertaGencatByOfertaGencat(ofertaGencat, historicoComunicacionGencat);
					
					// Borrado del registro vigente del tramite de GENCAT
					updateTramiteGENCAT(comunicacionGencat, adecuacionGencat, ofertaGencat);
					
				}
				
			}
			
		}
		
	}
	
	
	private void updateTramiteGENCAT(ComunicacionGencat comunicacionGencat, AdecuacionGencat adecuacionGencat, OfertaGencat ofertaGencat) {
		
		if(!Checks.esNulo(comunicacionGencat.getId())
				&& !Checks.esNulo(adecuacionGencat.getId())
				&& !Checks.esNulo(ofertaGencat.getId())) {
			genericDao.deleteById(AdecuacionGencat.class, adecuacionGencat.getId());
			genericDao.deleteById(OfertaGencat.class, ofertaGencat.getId());
			genericDao.deleteById(ComunicacionGencat.class, comunicacionGencat.getId());
			
			AdecuacionGencat ag = 
			
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
	
	@Override
	public void cambiarEstadoComunicacionGENCAT(ComunicacionGencat comunicacionGencat) {
		
		if(!Checks.esNulo(comunicacionGencat)) {
			comunicacionGencat.setEstadoComunicacion((DDEstadoComunicacionGencat) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoComunicacionGencat.class , DDEstadoComunicacionGencat.COD_COMUNICADO));
		}
		
	}
	
	@Override
	public void informarFechaSancion(ComunicacionGencat comunicacionGencat) {
		
		Calendar cal = Calendar.getInstance(); 
        cal.setTime(new Date()); 
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
			cg.setSancion( sancion );
			if( DDSancionGencat.COD_EJERCE.equals(sancion.getCodigo()) )
			{
				cg.setNuevoCompradorNif( gencatDto.getNuevoCompradorNif() );
				cg.setNuevoCompradorNombre( gencatDto.getNuevoCompradorNombre() );
				cg.setNuevoCompradorApellido1( gencatDto.getNuevoCompradorApellido1() );
				cg.setNuevoCompradorApellido2( gencatDto.getNuevoCompradorApellido2() );
			}
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
	
	
}
