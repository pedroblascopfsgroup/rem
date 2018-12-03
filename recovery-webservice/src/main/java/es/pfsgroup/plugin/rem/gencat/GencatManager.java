package es.pfsgroup.plugin.rem.gencat;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GencatApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoActivo;
import es.pfsgroup.plugin.rem.model.AdecuacionGencat;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoGencat;
import es.pfsgroup.plugin.rem.model.DtoHistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoOfertasAsociadasActivo;
import es.pfsgroup.plugin.rem.model.DtoReclamacionActivo;
import es.pfsgroup.plugin.rem.model.HistoricoComunicacionGencat;
import es.pfsgroup.plugin.rem.model.NotificacionGencat;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.OfertaGencat;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;
import es.pfsgroup.plugin.rem.model.Visita;
import es.pfsgroup.plugin.rem.model.VisitaGencat;

@Service("gencatManager")
public class GencatManager extends BusinessOperationOverrider<GencatApi> implements GencatApi {
	
	protected static final Log logger = LogFactory.getLog(ActivoManager.class);
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;

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
				List <NotificacionGencat> resultNotificacionGencat = genericDao.getListOrdered(NotificacionGencat.class, orderByFechaCrear, filtroIdComunicacion, filtroBorrado);
				if (resultNotificacionGencat != null && !resultNotificacionGencat.isEmpty()) {
					NotificacionGencat notificacionGencat = resultNotificacionGencat.get(0);
					BeanUtils.copyProperties(gencatDto, notificacionGencat);
					gencatDto.setMotivoNotificacion(notificacionGencat.getTipoNotificacion() != null ? notificacionGencat.getTipoNotificacion().getCodigo() : null);
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
			catch (IllegalAccessException iae) {
				logger.error("aaa");
			}
			catch (InvocationTargetException ite) {
				logger.error("eee");
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
			catch (IllegalAccessException iae) {
				logger.error("aaa");
			}
			catch (InvocationTargetException ite) {
				logger.error("eee");
			}
		}
		
		return listaReclamacion;
		
	}
	
	public List<DtoAdjunto> getAdjuntosActivo(Long id) throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		
		//TODO: filtrar los documentos que se obtienen para que sólo suba los documentos de los 7 tipos especificados en el HREOS-4836
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Activo activo = activoApi.get(id);
			listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosActivo(activo);

			for (DtoAdjunto adj : listaAdjuntos) {
				ActivoAdjuntoActivo adjuntoActivo = activo.getAdjuntoGD(adj.getId());
				if (!Checks.esNulo(adjuntoActivo)) {
					if (!Checks.esNulo(adjuntoActivo.getTipoDocumentoActivo())) {
						adj.setDescripcionTipo(adjuntoActivo.getTipoDocumentoActivo().getDescripcion());
					}
					adj.setContentType(adjuntoActivo.getContentType());
					if (!Checks.esNulo(adjuntoActivo.getAuditoria())) {
						adj.setGestor(adjuntoActivo.getAuditoria().getUsuarioCrear());
					}
					adj.setTamanyo(adjuntoActivo.getTamanyo());
				}
			}

		} 
		else {
			listaAdjuntos = getAdjuntosActivo(id, listaAdjuntos);
		}
		//--------------------------------
		
		return listaAdjuntos;
		
	}
	
	private List<DtoAdjunto> getAdjuntosActivo(Long id, List<DtoAdjunto> listaAdjuntos)
			throws IllegalAccessException, InvocationTargetException {
		Activo activo = activoApi.get(id);

		for (ActivoAdjuntoActivo adjunto : activo.getAdjuntos()) {
			DtoAdjunto dto = new DtoAdjunto();

			BeanUtils.copyProperties(dto, adjunto);
			dto.setIdEntidad(activo.getId());
			dto.setDescripcionTipo(adjunto.getTipoDocumentoActivo().getDescripcion());
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
				listaHistoricoComunicaciones.add(dtoHistoricoComunicacion);
			}
		}
		catch (IllegalAccessException iae) {
			logger.error("aaa");
		}
		catch (InvocationTargetException ite) {
			logger.error("eee");
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
		
		try {
			if (hComunicacionGencat != null) {
				BeanUtils.copyProperties(gencatDto, hComunicacionGencat);
				gencatDto.setSancion(hComunicacionGencat.getSancion() != null ? hComunicacionGencat.getSancion().getCodigo() : null);
				gencatDto.setEstadoComunicacion(hComunicacionGencat.getEstadoComunicacion() != null ? hComunicacionGencat.getEstadoComunicacion().getCodigo() : null);
			}
		}
		catch (IllegalAccessException iae) {
			logger.error("aaa");
		}
		catch (InvocationTargetException ite) {
			logger.error("eee");
		}
		
		return gencatDto;
	}
	
}
