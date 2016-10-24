package es.pfsgroup.plugin.rem.api.impl;

import java.util.HashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ReservaDto;

@Service("reservaManager")
public class ReservaManager extends BusinessOperationOverrider<ReservaApi> implements ReservaApi{

	
	protected static final Log logger = LogFactory.getLog(ReservaManager.class);

	@Autowired
	private RestApi restApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Override
	public String managerName() {
		return "reservaManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	
	
	

	@Override
	public HashMap<String, String> validateReservaPostRequestData(ReservaDto reservaDto, Object jsonFields) throws Exception {
		HashMap<String, String> hashErrores = null;


		hashErrores = restApi.validateRequestObject(reservaDto, TIPO_VALIDACION.INSERT);	
		
		if (!Checks.esNulo(reservaDto.getActivo())) {
			Activo activo = activoApi.getByNumActivoUvem(reservaDto.getActivo());
			if(Checks.esNulo(activo)){
				hashErrores.put("activo", "El activo no existe.");
				
			}else{
				Oferta oferta = activoApi.tieneOfertaAceptada(activo);
				if(Checks.esNulo(oferta)){
					hashErrores.put("activo", "El activo no tiene ofertas aceptadas.");		
				}else{
				
					ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
					if (Checks.esNulo(expedienteComercial)) {
						hashErrores.put("activo", "No existe expediente comericial para esta activo.");	
					}
					if(Checks.esNulo(expedienteComercial.getReserva())){
						hashErrores.put("activo", "El activo no tiene reserva");
						
					}else{
					
						if (!Checks.esNulo(reservaDto.getAccion())) {
							if(!reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_RESERVA) &&
							   !reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_VENTA)	&&
							   !reservaDto.getAccion().equalsIgnoreCase(ReservaApi.DEVOLUCION_RESERVA)){
								hashErrores.put("accion", RestApi.REST_MSG_UNKNOWN_KEY);
			
							}else if(reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_RESERVA) &&
									!expedienteComercial.getReserva().getEstadoReserva().getCodigo().equals(DDEstadosReserva.CODIGO_PENDIENTE_FIRMA)){
								hashErrores.put("activo", "La reserva debe estar en el estado pendiente de firma.");
						
							}else if(reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_RESERVA) &&
									!expedienteComercial.getEstado().getCodigo().equals(DDEstadosExpedienteComercial.APROBADO)){
								hashErrores.put("activo", "El expediente debe estar aprobado.");
							
							}else if(reservaDto.getAccion().equalsIgnoreCase(ReservaApi.DEVOLUCION_RESERVA) &&
									!expedienteComercial.getReserva().getEstadoReserva().getCodigo().equals(DDEstadosReserva.CODIGO_ANULADA)){
								hashErrores.put("activo", "La reserva debe estar en el estado anulada.");
							
							}else if(reservaDto.getAccion().equalsIgnoreCase(ReservaApi.DEVOLUCION_RESERVA) &&
									!expedienteComercial.getEstado().getCodigo().equals(DDEstadosExpedienteComercial.ANULADO)){
								hashErrores.put("activo", "El expediente debe estar anulado.");
								
							}else if(reservaDto.getAccion().equalsIgnoreCase(ReservaApi.DEVOLUCION_RESERVA) &&
									expedienteComercial.getReserva().getEstadoDevolucion()!=null && 
									!expedienteComercial.getReserva().getEstadoDevolucion().getCodigo().equals(DDEstadoDevolucion.ESTADO_PENDIENTE)){
								hashErrores.put("activo", "La devolucion debe estar pendiente.");
							
							}else if(reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_VENTA) &&
									!expedienteComercial.getReserva().getEstadoReserva().getCodigo().equals(DDEstadosReserva.CODIGO_FIRMADA)){
								hashErrores.put("activo", "La reserva debe estar en el estado firmada.");
								
							}else if(reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_VENTA) &&
									!expedienteComercial.getEstado().getCodigo().equals(DDEstadosExpedienteComercial.POSICIONADO)){
								hashErrores.put("activo", "El expediente debe estar posicionado.");
								
							}
						}
					}	
				}
			}
		}
		return hashErrores;
	}

	

}
