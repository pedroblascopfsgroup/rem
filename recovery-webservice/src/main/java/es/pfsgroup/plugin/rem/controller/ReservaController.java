package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.ReservaDto;
import es.pfsgroup.plugin.rem.rest.dto.ReservaRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularUVEMDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class ReservaController {

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ReservaApi reservaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private RestApi restApi;
	
	@Autowired
	private GenericABMDao genericDao;

	private final Log logger = LogFactory.getLog(getClass());

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/reserva")
	public void reservaInmueble(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		Double importeReserva = null;
		ReservaRequestDto jsonData = null;
		ReservaDto reservaDto = null;
		Map<String, Object> respuesta = new HashMap<String, Object>();
		JSONObject jsonFields = null;
		HashMap<String, String> errorList = null;
		
		try {
			
			jsonFields = request.getJsonObject();
			logger.debug("PETICIÓN: " + jsonFields);
			
			jsonData = (ReservaRequestDto) request.getRequestData(ReservaRequestDto.class);
			reservaDto = jsonData.getData();

			errorList = reservaApi.validateReservaPostRequestData(reservaDto, jsonFields) ;

			if (errorList != null && errorList.isEmpty()) {
				
				Activo activo = activoApi.getByNumActivoUvem(reservaDto.getActivo());
				Oferta oferta = activoApi.tieneOfertaAceptada(activo);
				ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
				OfertaUVEMDto ofertaUVEM = expedienteComercialApi.createOfertaOVEM(oferta, expedienteComercial);
				ArrayList<TitularUVEMDto> listaTitularUVEM = expedienteComercialApi.obtenerListaTitularesUVEM(expedienteComercial);
				
				respuesta.put("oferta", ofertaUVEM);
				respuesta.put("titulares", listaTitularUVEM);				
				importeReserva = Double.valueOf(ofertaUVEM.getImporteReserva());

				if (ReservaApi.COBRO_RESERVA.equals(reservaDto.getAccion())) {
					
					EntregaReserva entregaReserva = new EntregaReserva();
					entregaReserva.setImporte(importeReserva);
					Date fechaEntrega = new Date();
					entregaReserva.setFechaEntrega(fechaEntrega);
					entregaReserva.setReserva(expedienteComercial.getReserva());
					if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
						throw new Exception("No se ha podido guardar la reserva entregada en base de datos");
					}
					DDEstadosExpedienteComercial estadoReservado = expedienteComercialApi
							.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.RESERVADO);
					if (estadoReservado == null) {
						throw new Exception("No se ha podido obtener estado RESERVADO de base de datos");
					}
					expedienteComercial.setEstado(estadoReservado);
					if (!expedienteComercialApi.update(expedienteComercial)) {
						throw new Exception("No se ha podido actualizar estado expediente comercial en base de datos");
					}
				}

				if (ReservaApi.DEVOLUCION_RESERVA.equals(reservaDto.getAccion())) {

					EntregaReserva entregaReserva = new EntregaReserva();
					entregaReserva.setImporte(-importeReserva);
					Date fechaEntrega = new Date();
					entregaReserva.setFechaEntrega(fechaEntrega);
					entregaReserva.setReserva(expedienteComercial.getReserva());

					if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
						throw new Exception("No se ha podido eliminar la reserva entregada en base de datos");
					}
					DDEstadosExpedienteComercial estadoReservado = expedienteComercialApi
							.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.ANULADO);
					if (estadoReservado == null) {
						throw new Exception("No se ha podido obtener estado ANULADO de base de datos");
					}
					expedienteComercial.setEstado(estadoReservado);
					
					DDEstadoDevolucion estadoDevolucion = (DDEstadoDevolucion) genericDao.get(DDEstadoDevolucion.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDevolucion.ESTADO_DEVUELTA));
					expedienteComercial.getReserva().setEstadoDevolucion(estadoDevolucion);
					
					if (!expedienteComercialApi.update(expedienteComercial)) {
						throw new Exception("No se ha podido actualizar estado expediente comercial en base de datos");
					}
				}

				if (ReservaApi.COBRO_VENTA.equals(reservaDto.getAccion())) {

					DDEstadosExpedienteComercial estadoReservado = expedienteComercialApi
							.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.VENDIDO);
					if (estadoReservado == null) {
						throw new Exception("No se ha podido obtener estado VENDIDO de base de datos");
					}
					expedienteComercial.setEstado(estadoReservado);
					if (!expedienteComercialApi.update(expedienteComercial)) {
						throw new Exception("No se ha podido actualizar estado expediente comercial en base de datos");
					}
				}

				model.put("id", jsonFields.get("id"));
				model.put("data", respuesta);
				model.put("error", "");
			} else {
				model.put("id", jsonFields.get("id"));
				model.put("data", null);
				model.put("error", errorList);
			}

		} catch (Exception e) {
			logger.error(e);
			model.put("id", jsonFields.get("id"));
			model.put("data", respuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
		} finally {
			logger.debug("RESPUESTA: " + model);
		}

		restApi.sendResponse(response, model);
	}

}
