package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
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
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private RestApi restApi;

	private final Log logger = LogFactory.getLog(getClass());

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/reserva")
	public void reservaInmueble(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {

		final String COBRO_RESERVA = "1";
		final String COBRO_VENTA = "3";
		final String DEVOLUCION_RESERVA = "5";

		ReservaRequestDto jsonData = null;
		ReservaDto reservaDto = null;
		Map<String, Object> respuesta = new HashMap<String, Object>();

		try {

			jsonData = (ReservaRequestDto) request.getRequestData(ReservaRequestDto.class);
			reservaDto = jsonData.getData();

			HashMap<String, String> errorList = restApi.validateRequestObject(reservaDto, TIPO_VALIDACION.INSERT);

			if (errorList != null && errorList.isEmpty()) {
				Double importeReserva = null;
				Activo activo = activoApi.getByNumActivoUvem(reservaDto.getActivo());
				Oferta oferta = activoApi.tieneOfertaAceptada(activo);
				if (oferta == null) {
					throw new Exception("El activo no tiene ofertas aceptadas");
				}

				ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
				if (expedienteComercial == null) {
					throw new Exception("No existe el expediente comericial para esta oferta");
				}
				OfertaUVEMDto ofertaUVEM = expedienteComercialApi.createOfertaOVEM(oferta, expedienteComercial);
				Map<String, Object> mapOferta = new HashMap<String, Object>();
				mapOferta.put("oferta", ofertaUVEM);
				importeReserva = Double.valueOf(ofertaUVEM.getImporteReserva());

				ArrayList<TitularUVEMDto> listaTitularUVEM = expedienteComercialApi.obtenerListaTitularesUVEM(expedienteComercial);
				Map<String, Object> mapTitulares = new HashMap<String, Object>();
				mapTitulares.put("titulares", listaTitularUVEM);

				respuesta.put("oferta", mapOferta);
				respuesta.put("titulares", mapTitulares);

				if (COBRO_RESERVA.equals(reservaDto.getAccion())) {
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

				if (DEVOLUCION_RESERVA.equals(reservaDto.getAccion())) {
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
					if (!expedienteComercialApi.update(expedienteComercial)) {
						throw new Exception("No se ha podido actualizar estado expediente comercial en base de datos");
					}
				}

				if (COBRO_VENTA.equals(reservaDto.getAccion())) {
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

				model.put("id", jsonData.getId());
				model.put("data", respuesta);
				model.put("error", "");
			} else {
				model.put("id", jsonData.getId());
				model.put("data", null);
				model.put("error", errorList);
			}

		} catch (Exception e) {
			logger.error(e);
			model.put("id", jsonData.getId());
			model.put("data", "");
			model.put("error", e.getMessage());
		}

		restApi.sendResponse(response, model);
	}

}
