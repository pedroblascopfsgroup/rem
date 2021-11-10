package es.pfsgroup.plugin.rem.api.impl;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionIncAnuladas;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.reserva.dao.ReservaDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ReservaDto;

@Service("reservaManager")
public class ReservaManager extends BusinessOperationOverrider<ReservaApi> implements ReservaApi {

	protected static final Log logger = LogFactory.getLog(ReservaManager.class);

	@Autowired
	private RestApi restApi;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ReservaDao reservaDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Override
	public String managerName() {
		return "reservaManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	@Override
	public HashMap<String, String> validateReservaPostRequestData(ReservaDto reservaDto, Object jsonFields)
			throws Exception {
		HashMap<String, String> hashErrores = null;
		Oferta oferta = null;

		hashErrores = restApi.validateRequestObject(reservaDto, TIPO_VALIDACION.INSERT);

		if (Checks.esNulo(reservaDto.getAccion())) {
			hashErrores.put("accion", RestApi.REST_MSG_MISSING_REQUIRED);
			
		} else if (!reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_RESERVA)
				&& !reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_VENTA)
				&& !reservaDto.getAccion().equalsIgnoreCase(ReservaApi.DEVOLUCION_RESERVA)
				&& !reservaDto.getAccion().equalsIgnoreCase(ReservaApi.ANULACION_COBRO_RESERVA)
				&& !reservaDto.getAccion().equalsIgnoreCase(ReservaApi.ANULACION_COBRO_VENTA)
				&& !reservaDto.getAccion().equalsIgnoreCase(ReservaApi.ANULACION_DEVOLUCION_RESERVA)) {
			hashErrores.put("accion", RestApi.REST_MSG_UNKNOWN_KEY);		
			
		} else if (Checks.esNulo(reservaDto.getActivo())) {
			hashErrores.put("activo", RestApi.REST_MSG_MISSING_REQUIRED);	
			
		} else {
			
			Activo activo = activoApi.getByNumActivoUvem(reservaDto.getActivo());
			if (Checks.esNulo(activo)) {
				hashErrores.put("activo", "El activo no existe.");
				
			} else {
				
				//HREOS-1704: Para la ANULACION_DEVOLUCION_RESERVA hay que buscar la última oferta rechazada.
				if (reservaDto.getAccion().equalsIgnoreCase(ReservaApi.ANULACION_DEVOLUCION_RESERVA)) {
					if (!Checks.esNulo(reservaDto.getOfertaHRE())){
						oferta = ofertaApi.getOfertaByNumOfertaRem(reservaDto.getOfertaHRE());
					} else {
						DtoOfertasFilter dtoOfertasFilter = new DtoOfertasFilter();
						dtoOfertasFilter.setIdActivo(activo.getId());
						dtoOfertasFilter.setEstadoOferta(DDEstadoOferta.CODIGO_RECHAZADA);
						dtoOfertasFilter.setExcluirGencat(true);
						List<VGridOfertasActivosAgrupacionIncAnuladas> listaOfer = ofertaApi.getListOfertasFromView(dtoOfertasFilter);
						if(!Checks.esNulo(listaOfer) && !listaOfer.isEmpty()){
							Long idOferta = listaOfer.get(0).getIdOferta();
							if(!Checks.esNulo(idOferta)){
								oferta = ofertaApi.getOfertaById(idOferta);
							}
						}
					}
					if(Checks.esNulo(oferta)){
						hashErrores.put("activo", "No se ha podido obtener la oferta. El activo no tiene ofertas rechazadas.");		
					}			
				}else{
					//Para el resto de acciones hay que buscar la última oferta aceptada.
					oferta = activoApi.tieneOfertaTramitadaOCongeladaConReserva(activo);
					if(Checks.esNulo(oferta)){
						hashErrores.put("activo", "No se ha podido obtener la oferta. El activo no tiene ofertas aceptadas.");
					}	
				}
					
				if(!Checks.esNulo(oferta)){				
					ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
					if (Checks.esNulo(expedienteComercial)) {
						hashErrores.put("activo", "No existe expediente comercial para esta activo.");
						
					} else if((reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_RESERVA) ||
							reservaDto.getAccion().equalsIgnoreCase(ReservaApi.DEVOLUCION_RESERVA) ||
							reservaDto.getAccion().equalsIgnoreCase(ReservaApi.ANULACION_COBRO_RESERVA) || 
							reservaDto.getAccion().equalsIgnoreCase(ReservaApi.ANULACION_DEVOLUCION_RESERVA)) &&
							Checks.esNulo(expedienteComercial.getReserva())){
						hashErrores.put("accion", "No existe reserva para esta activo.");
						
					}else{
								
						if (reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_RESERVA) ||
							reservaDto.getAccion().equalsIgnoreCase(ReservaApi.DEVOLUCION_RESERVA)){
							
							if( Checks.esNulo(expedienteComercial.getReserva())) {
								hashErrores.put("activo", "El activo no tiene reserva");
							}
	
							CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
							if(Checks.esNulo(condExp)){
								hashErrores.put("activo", "No se han podido obtener los datos de la reserva para el activo.");
							
							}else if(Checks.esNulo(condExp.getImporteReserva())){
								hashErrores.put("activo", "No se ha podido obtener el importe de la reserva.");
							}
						}
						
							
						
						if (reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_RESERVA)){
							
							if(expedienteComercial.getEstado().getCodigo().equals(DDEstadosExpedienteComercial.RESERVADO)) {
								hashErrores.put("activo", "Ya se ha relizado el cobro de la reserva.");
	
							} 
						} else if (reservaDto.getAccion().equalsIgnoreCase(ReservaApi.DEVOLUCION_RESERVA)){
							
							if(expedienteComercial.getReserva().getEstadoReserva().getCodigo().equals(DDEstadosReserva.CODIGO_RESUELTA) ||
							   expedienteComercial.getReserva().getEstadoReserva().getCodigo().equals(DDEstadosReserva.CODIGO_RESUELTA_DEVUELTA)) {
								   hashErrores.put("activo", "Ya se ha realizado la devolución de la reserva.");

							} 
						} else if (reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_VENTA)){
						
							  if (expedienteComercial.getFechaContabilizacionPropietario()!=null) {
								  hashErrores.put("activo", "El cobro ya se ha realizado");
							  }

							  
						} else if (reservaDto.getAccion().equalsIgnoreCase(ReservaApi.ANULACION_COBRO_RESERVA)){
							
							Boolean tieneJustif =  expedienteComercialApi.comprobarExisteAdjuntoExpedienteComercial
									(expedienteComercial.getTrabajo().getId(), DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_RESERVA);
							Date now = new Date();
							
							if(Checks.esNulo(expedienteComercial.getReserva())) {
								hashErrores.put("activo", "No existe reserva para este activo.");
								
							} else if (Checks.esNulo(expedienteComercial.getTrabajo()) || (!Checks.esNulo(expedienteComercial.getTrabajo()) && tieneJustif)) {
								hashErrores.put("activo", "Justificante de ingreso de la reserva entregado. No se puede anular el cobro de reserva.");
								
							} else if(Checks.esNulo(expedienteComercial.getReserva().getFechaFirma())){
								hashErrores.put("activo", "No se ha realizado el cobro de la reserva.");
								
							} else if(!isSameDay(expedienteComercial.getReserva().getFechaFirma(), now)){					
								hashErrores.put("activo", "Ha pasado más de 1 día desde el cobro de la reserva.");
							}
							
							
							
						} else if (reservaDto.getAccion().equalsIgnoreCase(ReservaApi.ANULACION_COBRO_VENTA)){
							
							Boolean tieneJustif =  expedienteComercialApi.comprobarExisteAdjuntoExpedienteComercial
									(expedienteComercial.getTrabajo().getId(), DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_COMPRAVENTA);
							Date now = new Date();
							
							if(Checks.esNulo(expedienteComercial.getReserva())) {
								hashErrores.put("activo", "No se han podido obtener los datos de la venta.");
								
							} else if (Checks.esNulo(expedienteComercial.getTrabajo()) || (!Checks.esNulo(expedienteComercial.getTrabajo()) && tieneJustif)) {
								hashErrores.put("activo", "Justificante de ingreso de la compraventa entregado. No se puede anular el cobro de la venta.");
								
							} else if(Checks.esNulo(expedienteComercial.getFechaContabilizacionPropietario())){
								hashErrores.put("activo", "No se ha realizado el cobro de la venta.");
								
							} else if(!isSameDay(expedienteComercial.getFechaContabilizacionPropietario(), now)){					
								hashErrores.put("activo", "Ha pasado más de 1 día desde el cobro de la venta.");
							}
						
							
							
						} else if (reservaDto.getAccion().equalsIgnoreCase(ReservaApi.ANULACION_DEVOLUCION_RESERVA)){
							
							Date now = new Date();
							
							if(Checks.esNulo(expedienteComercial.getReserva())) {
								hashErrores.put("activo", "No existe reserva para este activo.");
								
							} else if(Checks.esNulo(expedienteComercial.getFechaDevolucionEntregas())){
								hashErrores.put("activo", "No se ha realizado la devolución del cobro de la reserva.");
								
							} else if(!isSameDay(expedienteComercial.getFechaDevolucionEntregas(), now)){					
								hashErrores.put("activo", "Ha pasado más de 1 día desde la devolución del cobro de la reserva.");
							}
						}
					}
				}
			}
		}
		return hashErrores;
	}
	
	
	private boolean isSameDay(Date date1, Date date2) {
		Calendar cal1 = Calendar.getInstance();
		Calendar cal2 = Calendar.getInstance();
		cal1.setTime(date1);
		cal2.setTime(date2);
		return cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR)
				&& cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR);
	}
	

	@Transactional(readOnly = true)
	public DDEstadosReserva getDDEstadosReservaByCodigo(String codigo) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		DDEstadosReserva estado = null;
		try {
			estado = genericDao.get(DDEstadosReserva.class, filtro);
		} catch (Exception e) {
			logger.error(e);
			return null;
		}
		return estado;
	}
	
	public Date getFechaFirmaByIdExpediente(String idExpediente) {
		return reservaDao.getFechaFirmaReservaByIdExpediente(Long.parseLong(idExpediente));
	}
	
	@Override
	public boolean tieneReservaFirmada(ExpedienteComercial eco) {
		return DDEstadosReserva.tieneReservaFirmada(eco.getReserva());
	}
}
