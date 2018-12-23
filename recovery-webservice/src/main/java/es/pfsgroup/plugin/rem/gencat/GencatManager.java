package es.pfsgroup.plugin.rem.gencat;

import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatAdjuntoDao;
import es.pfsgroup.plugin.rem.activo.dao.HistoricoComunicacionGencatAdjuntoDao;
import es.pfsgroup.plugin.rem.activo.dao.NotificacionGencatDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.AdecuacionGencat;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.ComunicacionGencatAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoGencat;
import es.pfsgroup.plugin.rem.model.DtoHistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoNotificacionActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasAsociadasActivo;
import es.pfsgroup.plugin.rem.model.DtoReclamacionActivo;
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
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.VisitaGencat;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoNotificacionGencat;

@Service("gencatManager")
public class GencatManager extends BusinessOperationOverrider<GencatApi> implements GencatApi {
	
	protected static final Log logger = LogFactory.getLog(GencatManager.class);
	
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
				
				//Notificacion
				/*List <NotificacionGencat> resultNotificacionGencat = genericDao.getListOrdered(NotificacionGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultNotificacionGencat != null && !resultNotificacionGencat.isEmpty()) {
					NotificacionGencat notificacionGencat = resultNotificacionGencat.get(0);
					BeanUtils.copyProperties(gencatDto, notificacionGencat);
					gencatDto.setMotivoNotificacion(notificacionGencat.getTipoNotificacion() != null ? notificacionGencat.getTipoNotificacion().getCodigo() : null);
				}*/
				
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
				dtoOfertasAsociadasActivo.setTipoComprador(ofertaGencat.getTipoPeriocidad().getDescripcion());
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
				
				//Notificacion
				List <HistoricoNotificacionGencat> resultNotificacionGencat = genericDao.getListOrdered(HistoricoNotificacionGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultNotificacionGencat != null && !resultNotificacionGencat.isEmpty()) {
					HistoricoNotificacionGencat notificacionGencat = resultNotificacionGencat.get(0);
					BeanUtils.copyProperties(gencatDto, notificacionGencat);
					gencatDto.setMotivoNotificacion(notificacionGencat.getTipoNotificacion() != null ? notificacionGencat.getTipoNotificacion().getCodigo() : null);
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
				dtoOfertasAsociadasActivo.setTipoComprador(ofertaGencat.getTipoPeriocidad().getDescripcion());
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
	
}
