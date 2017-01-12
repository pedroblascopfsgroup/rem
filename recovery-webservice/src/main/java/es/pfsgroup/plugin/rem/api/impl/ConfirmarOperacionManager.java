package es.pfsgroup.plugin.rem.api.impl;

import java.util.Date;
import java.util.HashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ConfirmarOperacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ReintegroApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ConfirmacionOpDto;
import es.pfsgroup.plugin.rem.rest.dto.ReintegroDto;
import es.pfsgroup.plugin.rem.rest.dto.ReservaDto;

@Service("confirmarOperacionManager")
public class ConfirmarOperacionManager extends BusinessOperationOverrider<ConfirmarOperacionApi> implements ConfirmarOperacionApi{

	
	protected static final Log logger = LogFactory.getLog(ConfirmarOperacionManager.class);

	@Autowired
	private RestApi restApi;
	
	@Autowired
	private ReservaApi reservaApi;
	
	@Autowired
	private ReintegroApi reintegroApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Override
	public String managerName() {
		return "ConfirmarOperacionManager";
	}

	

	@Override
	public HashMap<String, String> validateConfirmarOperacionPostRequestData(ConfirmacionOpDto confirmacionOpDto, Object jsonFields) throws Exception {
		HashMap<String, String> hashErrores = null;
		HashMap<String, String> errorList = null;

		hashErrores = restApi.validateRequestObject(confirmacionOpDto, TIPO_VALIDACION.INSERT);	
	
		if (!Checks.esNulo(confirmacionOpDto.getAccion()) &&
			!confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_RESERVA) && 
			!confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_RESERVA) && 
			!confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_VENTA) &&
			!confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_VENTA) &&
			!confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.DEVOLUCION_RESERVA) &&
			!confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_DEVOLUCION_RESERVA) &&
			!confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.REINTEGRO_RESERVA)) {
				hashErrores.put("accion", RestApi.REST_MSG_UNKNOWN_KEY);
				
		}else if(!Checks.esNulo(confirmacionOpDto.getResultado()) && 
				!confirmacionOpDto.getResultado().equals(Integer.valueOf(0)) &&
				!confirmacionOpDto.getResultado().equals(Integer.valueOf(1))){
			hashErrores.put("resultado", RestApi.REST_MSG_UNKNOWN_KEY);
			
		}else{
			
			if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_RESERVA) || 
			   confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.COBRO_VENTA) || 
			   confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.DEVOLUCION_RESERVA)){
				
				ReservaDto reservaDto = new ReservaDto();
				reservaDto.setAccion(confirmacionOpDto.getAccion());
				reservaDto.setActivo(confirmacionOpDto.getActivo());			
				errorList = reservaApi.validateReservaPostRequestData(reservaDto, jsonFields);
				hashErrores.putAll(errorList);
				
			}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.REINTEGRO_RESERVA)){
				
				ReintegroDto reintegroDto = new ReintegroDto();
				reintegroDto.setOfertaHRE(confirmacionOpDto.getOfertaHRE());						
				errorList = reintegroApi.validateReintegroPostRequestData(reintegroDto, jsonFields);
				hashErrores.putAll(errorList);
				
			}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_RESERVA)){
				
			}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_COBRO_VENTA)){
				
			}else if(confirmacionOpDto.getAccion().equalsIgnoreCase(ConfirmarOperacionApi.ANUL_DEVOLUCION_RESERVA)){
				
			}	
		}
				
		return hashErrores;
	}
	
	

	
	/**
	 * Registra el cobro de la reserva. Insertar en entregas a cuentas en positivo,
	 * actualizar fecha firma reserva y fecha envío reserva, 
	 * estado del expediente como RESERVADO y el estado de la reserva a FIRMADA
	 * @param ConfirmacionOpDto con los datos necesarios para registrar el cobro de la reserva
	 * @return void 
	 */
	@Override
	public void cobrarReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception{
		Double importeReserva = null;
		Date fechaActual = new Date();
		
		//Estas validaciones ya se realizan en el metodo validador del ws
		Activo activo = activoApi.getByNumActivoUvem(confirmacionOpDto.getActivo());
		if (Checks.esNulo(activo)) {
			throw new Exception("No existe el activo");
		}		
		Oferta oferta = activoApi.tieneOfertaAceptada(activo);
		if (Checks.esNulo(oferta)) {
			throw new Exception("El activo no tiene ofertas aceptadas.");
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (Checks.esNulo(expedienteComercial)) {
			throw new Exception("No existe expediente comercial para esta activo.");
		} 		
		Reserva reserva = expedienteComercial.getReserva();
		if (Checks.esNulo(reserva)) {
			throw new Exception("El activo no tiene reserva");
		}
		
		//Importe Reserva:
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		if (!Checks.esNulo(condExp)) {
			importeReserva = condExp.getImporteReserva();
		}
		

		//Insertar en entregas a cuentas en positivo
		EntregaReserva entregaReserva = new EntregaReserva();
		entregaReserva.setImporte(importeReserva);
		entregaReserva.setFechaEntrega(fechaActual);
		entregaReserva.setReserva(expedienteComercial.getReserva());
		if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
			throw new Exception("No se ha podido guardar el cobro de la reserva.");
		}

		//Actualizar fecha firma reserva y fecha envío reserva, 		
		reserva.setFechaFirma(fechaActual);
		reserva.setFechaEnvio(fechaActual);

		//Actualizar estado reserva a FIRMADA
		DDEstadosReserva estReserva = reservaApi.getDDEstadosReservaByCodigo(DDEstadosReserva.CODIGO_FIRMADA);
		if (estReserva == null) {
			throw new Exception("Error al actualizar el estado de la reserva.");
		}
		reserva.setEstadoReserva(estReserva);
		expedienteComercial.setReserva(reserva);	
		
		//Actualizar estado expediente comercial a RESERVADO
		DDEstadosExpedienteComercial estadoExpCom = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.RESERVADO);
		if(Checks.esNulo(estadoExpCom)) {
			throw new Exception("Error al actualizar el estado del expediente comercial.");
		}
		expedienteComercial.setEstado(estadoExpCom);
		if (!expedienteComercialApi.update(expedienteComercial)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}

	}
	
	
	
	
	/**
	 * Registra el cobro de la venta. Insertar en entregas a cuentas en positivo,
	 * actualizar fecha contabilizacionPropietario, fecha venta,
	 * @param ConfirmacionOpDto con los datos necesarios para registrar el cobro de la venta
	 * @return void  
	 */
	@Override
	public void cobrarVenta(ConfirmacionOpDto confirmacionOpDto) throws Exception{
		Double importeReserva = null;
		Double importeTotal = null;
		Date fechaActual = new Date();

		//Estas validaciones ya se realizan en el metodo validador del ws
		Activo activo = activoApi.getByNumActivoUvem(confirmacionOpDto.getActivo());
		if (Checks.esNulo(activo)) {
			throw new Exception("No existe el activo");
		}	
		Oferta oferta = activoApi.tieneOfertaAceptada(activo);
		if (Checks.esNulo(oferta)) {
			throw new Exception("El activo no tiene ofertas aceptadas.");
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (Checks.esNulo(expedienteComercial)) {
			throw new Exception("No existe expediente comercial para esta activo.");
		} 
		Reserva reserva = expedienteComercial.getReserva();
		if (Checks.esNulo(reserva)) {
			throw new Exception("El activo no tiene reserva");
		}
		
		//Importe Reserva:
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		if (!Checks.esNulo(condExp)) {
			importeReserva = condExp.getImporteReserva();
		}
		//Importe Total:
		importeTotal = Checks.esNulo(oferta.getImporteContraOferta()) ? oferta.getImporteOferta() - importeReserva : oferta.getImporteContraOferta() - importeReserva;
				
		
		//Insertar en entregas a cuentas en positivo,
		EntregaReserva entregaReserva = new EntregaReserva();
		entregaReserva.setImporte(importeTotal);
		Date fechaEntrega = new Date();
		entregaReserva.setFechaEntrega(fechaEntrega);
		entregaReserva.setReserva(expedienteComercial.getReserva());
		if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
			throw new Exception("No se ha podido guardar el cobro de la venta.");
		}
		
		//Actualizar fecha contabilizacionPropietario, fecha venta,
		expedienteComercial.setFechaContabilizacionPropietario(fechaActual);
		expedienteComercial.setFechaVenta(fechaActual);
		if (!expedienteComercialApi.update(expedienteComercial)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}
		
	}
	
	
	


	/**
	 * Registra la devolución de la reserva. Insertar en entregas a cuentas en negativo,
	 * Actualiza estado reserva a CODIGO_RESUELTA_DEVUELTA, el estado de la oferta CODIGO_RECHAZADA, el estado del expediente ANULADO,
	 * Poner estadoReserva CODIGO_RESUELTA_DEVUELTA.
	 * Actualiza fecha de devolución e importe devuelto
	 * @param ConfirmacionOpDto con los datos necesarios para registrar la devolución de la reserva
	 * @return void
	 */
	@Override
	public void devolverReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception{
		Double importeReserva = null;
		Date fechaActual = new Date();
		
		//Estas validaciones ya se realizan en el metodo validador del ws
		Activo activo = activoApi.getByNumActivoUvem(confirmacionOpDto.getActivo());
		if (Checks.esNulo(activo)) {
			throw new Exception("No existe el activo");
		}	
		Oferta oferta = activoApi.tieneOfertaAceptada(activo);
		if (Checks.esNulo(oferta)) {
			throw new Exception("El activo no tiene ofertas aceptadas.");
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (Checks.esNulo(expedienteComercial)) {
			throw new Exception("No existe expediente comercial para esta activo.");
		} 
		Reserva reserva = expedienteComercial.getReserva();
		if (Checks.esNulo(reserva)) {
			throw new Exception("El activo no tiene reserva");
		}
				
		
		//Importe Reserva:
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		if (!Checks.esNulo(condExp)) {
			importeReserva = condExp.getImporteReserva();
		}
		
		
		//Insertar en entregas a cuentas en negativo
		EntregaReserva entregaReserva = new EntregaReserva();
		entregaReserva.setImporte(-importeReserva);
		entregaReserva.setFechaEntrega(fechaActual);
		entregaReserva.setReserva(expedienteComercial.getReserva());
		if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
			throw new Exception("No se ha podido guardar la devolución de la reserva.");
		}

		
		//Actualiza estado reserva a CODIGO_RESUELTA_DEVUELTA, 
		DDEstadosReserva estReserva = reservaApi.getDDEstadosReservaByCodigo(DDEstadosReserva.CODIGO_RESUELTA_DEVUELTA);
		if (Checks.esNulo(estReserva)) {
			throw new Exception("Error al actualizar el estado de la reserva.");
		}
		expedienteComercial.getReserva().setEstadoReserva(estReserva);
		
		
		//Actualiza estado de la oferta CODIGO_RECHAZADA 
		DDEstadoOferta estOferta = ofertaApi.getDDEstadosOfertaByCodigo(DDEstadoOferta.CODIGO_RECHAZADA);
		if (Checks.esNulo(estOferta)) {
			throw new Exception("Error al actualizar el estado de la oferta.");
		}
		expedienteComercial.getOferta().setEstadoOferta(estOferta);
		
		
		//Actualiza estado del expediente comercial ANULADO
		DDEstadosExpedienteComercial estadoExpCom = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.ANULADO);
		if (Checks.esNulo(estadoExpCom)) {
			throw new Exception("Error al actualizar el estado del expediente comercial.");
		}
		expedienteComercial.setEstado(estadoExpCom);

		
		//Actualiza fecha de devolución e importe devuelto
		expedienteComercial.setFechaDevolucionEntregas(fechaActual);
		expedienteComercial.setImporteDevolucionEntregas(importeReserva);

		if (!expedienteComercialApi.update(expedienteComercial)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}
		
	}
	
	
	
	
	
	
	/**
	 * Registra el reintegro de la reserva. Insertar en entregas a cuentas en negativo,
	 * Actualiza estado reserva a CODIGO_RESUELTA_REINTEGRADA,
	 * @param ConfirmacionOpDto con los datos necesarios para registrar el reintegro de la reserva
	 * @return void 
	 */
	@Override
	public void reintegrarReserva(ConfirmacionOpDto confirmacionOpDto) throws Exception{
		Double importeReserva = null;
		Date fechaActual = new Date();
		
		
		//Estas validaciones ya se realizan en el metodo validador del ws
		Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(confirmacionOpDto.getOfertaHRE());
		if(Checks.esNulo(oferta)){
			throw new Exception("No existe la oferta.");	
		}
		ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
		if (Checks.esNulo(expedienteComercial)) {
			throw new Exception("No existe expediente comercial para esta activo.");
		} 
		Reserva reserva = expedienteComercial.getReserva();
		if (Checks.esNulo(reserva)) {
			throw new Exception("El activo no tiene reserva");
		}
		
		//Importe Reserva:
		CondicionanteExpediente condExp = expedienteComercial.getCondicionante();
		if (!Checks.esNulo(condExp)) {
			importeReserva = condExp.getImporteReserva();
		}
				
		//Insertar en entregas a cuentas en negativo,
		EntregaReserva entregaReserva = new EntregaReserva();
		entregaReserva.setImporte(-importeReserva);
		entregaReserva.setFechaEntrega(fechaActual);
		entregaReserva.setReserva(expedienteComercial.getReserva());
		if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
			throw new Exception("No se ha podido guardar el reintegro de la reserva.");
		}
		
		//Actualiza estado reserva a CODIGO_RESUELTA_REINTEGRADA
		DDEstadosReserva estReserva = reservaApi.getDDEstadosReservaByCodigo(DDEstadosReserva.CODIGO_RESUELTA_REINTEGRADA);
		if (Checks.esNulo(estReserva)) {
			throw new Exception("Error al actualizar el estado de la reserva.");
		}
		expedienteComercial.getReserva().setEstadoReserva(estReserva);
		
		
		if (!expedienteComercialApi.update(expedienteComercial)) {
			throw new Exception("Error al actualizar el expediente comercial.");
		}

	}



	@Override
	public void anularCobroReserva(ConfirmacionOpDto confirmacionOpDto)
			throws Exception {
		// TODO Auto-generated method stub
		
	}



	@Override
	public void anularCobroVenta(ConfirmacionOpDto confirmacionOpDto)
			throws Exception {
		// TODO Auto-generated method stub
		
	}



	@Override
	public void anularDevolucionReserva(ConfirmacionOpDto confirmacionOpDto)
			throws Exception {
		// TODO Auto-generated method stub
		
	}
	
	
	
}
