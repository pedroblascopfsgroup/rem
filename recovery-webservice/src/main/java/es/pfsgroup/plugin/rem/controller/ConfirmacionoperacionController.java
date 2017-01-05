package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.ReservaDto;
import es.pfsgroup.plugin.rem.rest.dto.ReservaRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularUVEMDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;

@Controller
public class ConfirmacionoperacionController {
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ReservaApi reservaApi;
	
	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	@Autowired
	private RestApi restApi;

	@Autowired
	private GenericABMDao genericDao;

	private final Log logger = LogFactory.getLog(getClass());

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/confirmacionoperacion")
	public void reservaInmuebleOld(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		Double importeReserva = null;
		Double importeTotal = null;
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

			errorList = reservaApi.validateReservaPostRequestData(reservaDto, jsonFields);

			if (errorList != null && errorList.isEmpty()) {

				Activo activo = activoApi.getByNumActivoUvem(reservaDto.getActivo());
				Oferta oferta = activoApi.tieneOfertaAceptada(activo);

				ExpedienteComercial expedienteComercial = expedienteComercialApi
						.expedienteComercialPorOferta(oferta.getId());
				Reserva reserva = expedienteComercial.getReserva();
				OfertaUVEMDto ofertaUVEM = expedienteComercialApi.createOfertaOVEM(oferta, expedienteComercial);
				ArrayList<TitularUVEMDto> listaTitularUVEM = expedienteComercialApi
						.obtenerListaTitularesUVEM(expedienteComercial);

				respuesta.put("oferta", ofertaUVEM);
				respuesta.put("titulares", listaTitularUVEM);
				importeReserva = Double.valueOf(ofertaUVEM.getImporteReserva());
				importeTotal = Checks.esNulo(oferta.getImporteContraOferta())
						? oferta.getImporteOferta() - importeReserva : oferta.getImporteContraOferta() - importeReserva;

				Date fechaActual = new Date();
				if (ReservaApi.COBRO_RESERVA.equals(reservaDto.getAccion())) {

					EntregaReserva entregaReserva = new EntregaReserva();
					entregaReserva.setImporte(importeReserva);

					entregaReserva.setFechaEntrega(fechaActual);
					entregaReserva.setReserva(expedienteComercial.getReserva());
					if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
						throw new Exception("No se ha podido guardar la reserva entregada en base de datos");
					}

					// Actualiza estado expediente comercial a RESERVADO
					DDEstadosExpedienteComercial estadoReservado = expedienteComercialApi
							.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.RESERVADO);
					if (estadoReservado == null) {
						throw new Exception("No se ha podido obtener estado RESERVADO de base de datos");
					}
					expedienteComercial.setEstado(estadoReservado);

					// Actualiza estado reserva a FIRMADA
					DDEstadosReserva estReserva = reservaApi
							.getDDEstadosReservaByCodigo(DDEstadosReserva.CODIGO_FIRMADA);
					if (estReserva == null) {
						throw new Exception("No se ha podido obtener estado FIRMADA de la reserva de base de datos");
					}
					reserva.setEstadoReserva(estReserva);
					reserva.setFechaFirma(fechaActual);
					reserva.setFechaEnvio(fechaActual);
					expedienteComercial.setReserva(reserva);

					if (!expedienteComercialApi.update(expedienteComercial)) {
						throw new Exception("No se ha podido actualizar estado expediente comercial en base de datos");
					}
				}

				if (ReservaApi.COBRO_VENTA.equals(reservaDto.getAccion())) {

					//-Realizar cuando expediente "Posicionado". (Cuando se lance la tarea de posicionamiento y firma).
					EntregaReserva entregaReserva = new EntregaReserva();
					entregaReserva.setImporte(importeTotal);
					Date fechaEntrega = new Date();
					entregaReserva.setFechaEntrega(fechaEntrega);
					entregaReserva.setReserva(expedienteComercial.getReserva());
					if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
						throw new Exception("No se ha podido guardar la reserva entregada en base de datos");
					}
					expedienteComercial.setFechaContabilizacionPropietario(fechaActual);
					expedienteComercial.setFechaVenta(fechaActual);

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

					// Actualiza estado reserva a ANULADA
					DDEstadosReserva estReserva = reservaApi
							.getDDEstadosReservaByCodigo(DDEstadosReserva.CODIGO_RESUELTA_DEVUELTA);
					if (estReserva == null) {
						throw new Exception("No se ha podido obtener estado CODIGO_RESUELTA_DEVUELTA de la reserva de base de datos");
					}
					expedienteComercial.getReserva().setEstadoReserva(estReserva);
					
					DDEstadoOferta estOferta = ofertaApi.getDDEstadosOfertaByCodigo(DDEstadoOferta.CODIGO_RECHAZADA);
					if (estOferta == null) {
						throw new Exception("No se ha podido obtener estado Rechazada de la oferta de base de datos");
					}
					expedienteComercial.getOferta().setEstadoOferta(estOferta);
					
					DDEstadosExpedienteComercial estadoAnulado = expedienteComercialApi
							.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.ANULADO);
					if (estadoAnulado == null) {
						throw new Exception("No se ha podido obtener estado RESERVADO de base de datos");
					}
					expedienteComercial.setEstado(estadoAnulado);

					// Actualiza estado devolucion a ANULADO
					DDEstadoDevolucion estadoDevolucion = (DDEstadoDevolucion) genericDao.get(DDEstadoDevolucion.class,
							genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDevolucion.ESTADO_DEVUELTA));
					expedienteComercial.getReserva().setEstadoDevolucion(estadoDevolucion);
					
					expedienteComercial.setFechaDevolucionEntregas(fechaEntrega);
					expedienteComercial.setImporteDevolucionEntregas(importeReserva);

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
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));
			model.put("data", respuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
		} finally {
			logger.debug("RESPUESTA: " + model);
		}

		restApi.sendResponse(response, model, request);
	}
}
