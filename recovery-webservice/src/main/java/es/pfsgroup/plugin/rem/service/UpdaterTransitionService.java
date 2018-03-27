package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.Method;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoSaltoTarea;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;

@Component
public class UpdaterTransitionService {
	
	protected static final Log logger = LogFactory.getLog(UpdaterTransitionService.class);
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	
	
	public void updateFrom(DtoSaltoTarea dto) {
		
		
		/*if(DDTareaDestinoSalto.CODIGO_DEFINICION_OFERTA.equals(dto.getCodigoTareaDestino())) {
		updateT013_DefinicionOferta(dto);
		}*/

		String tarea = dto.getCodigoTareaDestino();
		String methodName = "update"+tarea;

		Method method;
		try {
			
			method = this.getClass().getDeclaredMethod(methodName, DtoSaltoTarea.class);
			method.invoke(this, dto);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
		} 
		
	}
	
	public void updateT013_DefinicionOferta(DtoSaltoTarea dto) {
				
		Filter filtro;
		DDEstadosExpedienteComercial estado;

		filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.EN_TRAMITACION);
		estado = genericDao.get(DDEstadosExpedienteComercial.class, filtro);
		
		update(estado, dto);
		
	}

	private void update(DDEstadosExpedienteComercial estado, DtoSaltoTarea dto) {
		
		ActivoTramite activoTramite = activoTramiteApi.get(dto.getIdTramite());
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(activoTramite.getTrabajo());
		ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
		Reserva reserva = expediente.getReserva();
		
		expediente.setEstado(estado);
		
		updateExpediente(expediente, dto);
		
		updateOferta(ofertaAceptada, dto);
		
		updateReserva(reserva, dto);
		
		
		
		//TODO NO está definido donde guardar esta información.
		/*
		if(!Checks.esNulo(dto.getFirmaEscritura())) {
			
		}
		
		if(!Checks.esNulo(dto.getFechaFirmaPropietario())) {
			
		}
		
		if(!Checks.esNulo(dto.getNotario())) {
			
		}
		
		if(!Checks.esNulo(dto.getNumProtocolo())) {
			
		}
		
		if(!Checks.esNulo(dto.getPrecioEscrituracion())) {
			
		}
		
		if(!Checks.esNulo(dto.getResolucion())) {
			
		}
		
		if(!Checks.esNulo(dto.getAceptaContraoferta())) {
			
		}
		
		if(!Checks.esNulo(dto.getFechaRespuestaOfertante())) {
			
		}
		
		if(!Checks.esNulo(dto.getSolicitaReserva())) {
			
		}*/
		
	}

	private void updateReserva(Reserva reserva, DtoSaltoTarea dto) {
		
		Boolean update = false;
		
		if(!Checks.esNulo(dto.getTipoArras())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoArras());
			DDTiposArras tipoArras = (DDTiposArras) genericDao.get(DDTiposArras.class, filtro);						
			reserva.setTipoArras(tipoArras);
			update=true;
		}
		
		if(!Checks.esNulo(dto.getFechaEnvioReserva())) {
			if(!Checks.esNulo(reserva)){
				reserva.setFechaEnvio(dto.getFechaEnvioReserva());	
				update=true;
			}
				
		}
		
		if(!Checks.esNulo(dto.getFechaFirmaReserva())) {
			reserva.setFechaFirma(dto.getFechaFirmaReserva());
			update=true;
		}
		
		if(update) {
			genericDao.save(Reserva.class, reserva);
		}
		
	}

	private void updateOferta(Oferta ofertaAceptada, DtoSaltoTarea dto) {
		
		Boolean update = true;
		
		if(!Checks.esNulo(dto.getImporteContraoferta())) {
			ofertaAceptada.setImporteContraOferta(dto.getImporteContraoferta());
			update=true;
		}
		
		if(!Checks.esNulo(dto.getImporteOfertante())) {
			ofertaAceptada.setImporteContraOferta(dto.getImporteOfertante());
			update=true;
		}
		
		if(update) {
			genericDao.save(Oferta.class, ofertaAceptada);
		}
		
		
	}

	private void updateExpediente(ExpedienteComercial expediente, DtoSaltoTarea dto) {
		
		if(!Checks.esNulo(dto.getConflictoIntereses())) {
			expediente.setConflictoIntereses(dto.getConflictoIntereses());
		}
		
		if(!Checks.esNulo(dto.getRiesgoReputacional())) {
			expediente.setRiesgoReputacional(dto.getRiesgoReputacional());
		}
		
		if(!Checks.esNulo(dto.getComiteSancionador())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getComiteSancionador());
			DDComiteSancion comiteSancion = genericDao.get(DDComiteSancion.class, filtro);
			expediente.setComiteSancion(comiteSancion);
		}
		
		if(!Checks.esNulo(dto.getFechaEnvioSancion())) {
			expediente.setFechaSancion(dto.getFechaEnvioSancion());
		}
		
		if(!Checks.esNulo(dto.getPbcAprobado())) {
			expediente.setEstadoPbc(dto.getPbcAprobado());
		}
		
		if(!Checks.esNulo(dto.getMotivoAnulacion())) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getMotivoAnulacion());
			DDMotivoAnulacionExpediente motivoAnulacion = (DDMotivoAnulacionExpediente) genericDao.get(DDMotivoAnulacionExpediente.class, filtro);
			expediente.setMotivoAnulacion(motivoAnulacion);
		}
		
		if(!Checks.esNulo(dto.getFechaRespuestaComite())) {
			expediente.setFechaSancion(dto.getFechaRespuestaComite());
		}
		
		genericDao.save(ExpedienteComercial.class, expediente);

	}

}
