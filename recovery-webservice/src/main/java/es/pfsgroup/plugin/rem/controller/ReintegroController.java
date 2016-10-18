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

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDevolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.ReintegroRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularUVEMDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller

public class ReintegroController {

	@Autowired
	private RestApi restApi;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;

	private final Log logger = LogFactory.getLog(getClass());

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/reintegro")
	public void reintegroReservaInmueble(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {

		ReintegroRequestDto jsonData = null;
		Map<String, Object> respuesta = new HashMap<String, Object>();

		try {
			jsonData = (ReintegroRequestDto) request.getRequestData(ReintegroRequestDto.class);

			HashMap<String, String> errorList = restApi.validateRequestObject(jsonData.getData(),
					TIPO_VALIDACION.INSERT);

			if (errorList.size() == 0) {
				// Obtenemos el activo
				Activo activo = activoApi.getByNumActivoUvem(jsonData.getData().getActivo());
				Oferta oferta = activoApi.tieneOfertaAceptada(activo);
				if (oferta == null) {
					throw new Exception("El activo no tiene ofertas aceptadas");
				}

				// obtenemos el expediente comercial
				ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
				if (expedienteComercial == null) {
					throw new Exception("No existe el expediente comericial para esta oferta");
				}

				// validamos que tenga reserva en estado Pte. Firma.
				if (expedienteComercial.getReserva() == null || expedienteComercial.getReserva().getEstadoReserva() == null
						|| !expedienteComercial.getReserva().getEstadoReserva().getCodigo()
								.equals(DDEstadosReserva.CODIGO_PENDIENTE_FIRMA)) {
					throw new Exception("La oferta debe estar en el estado pendiente de firma");
				}

				// validamos que el expediente comercial este en estado anulado
				if (expedienteComercial.getEstado() == null
						|| !expedienteComercial.getEstado().getCodigo().equals(DDEstadosExpedienteComercial.ANULADO)) {
					throw new Exception("El expediente comercial debe estar en el estado anulado");
				}
				
				Map<String, Object> mapOferta = new HashMap<String, Object>();
				OfertaUVEMDto ofertaUVEM = expedienteComercialApi.createOfertaOVEM(oferta, expedienteComercial);
				mapOferta.put("oferta", ofertaUVEM);
				respuesta.put("oferta", mapOferta);
				ArrayList<TitularUVEMDto> listaTitularUVEM = expedienteComercialApi.obtenerListaTitularesUVEM(expedienteComercial);
				Map<String, Object> mapTitulares = new HashMap<String, Object>();
				mapTitulares.put("titulares", listaTitularUVEM);
				respuesta.put("titulares", mapTitulares);
				
				Double importeReserva = Double.valueOf(ofertaUVEM.getImporteReserva());
				EntregaReserva entregaReserva = new EntregaReserva();
				entregaReserva.setImporte(-importeReserva);
				Date fechaEntrega = new Date();
				entregaReserva.setFechaEntrega(fechaEntrega);
				entregaReserva.setReserva(expedienteComercial.getReserva());

				if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expedienteComercial.getId())) {
					throw new Exception("No se ha podido eliminar la reserva entregada en base de datos");
				}
				DDEstadoDevolucion estadoDevolucion = (DDEstadoDevolucion) genericDao.get(DDEstadoDevolucion.class,
						genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoDevolucion.ESTADO_BLOQUEADA));
				expedienteComercial.getReserva().setEstadoDevolucion(estadoDevolucion);
				expedienteComercialApi.update(expedienteComercial);	

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
			if (jsonData != null) {
				model.put("id", jsonData.getId());
			}
			model.put("data", "");
			model.put("error", e.getMessage());
		}
		restApi.sendResponse(response, model);
	}

}
