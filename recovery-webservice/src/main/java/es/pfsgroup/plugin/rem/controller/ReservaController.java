package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.CompradorExpediente;
import es.pfsgroup.plugin.rem.model.CondicionanteExpediente;
import es.pfsgroup.plugin.rem.model.EntregaReserva;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;
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
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private RestApi restApi;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/reserva")
	public void reservaInmueble(ModelMap model, RestRequestWrapper request,HttpServletResponse response) {
		
		final String COBRO_RESERVA = "1";
		final String COBRO_VENTA = "3";
		final String DEVOLUCION_RESERVA = "5";

		ReservaRequestDto jsonData = null;
		ReservaDto reservaDto = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		
		try {
			
			jsonData = (ReservaRequestDto) request.getRequestData(ReservaRequestDto.class);
			reservaDto = jsonData.getData();			
			Double importeReserva = null;
			Activo activo = activoApi.get(reservaDto.getActivo());
			List<ActivoOferta> listaActivoOferta = activo.getOfertas();
			boolean isAccepted = false;
			int i=0;
			Oferta oferta = null;
			while (i < listaActivoOferta.size() && !isAccepted) {
				ActivoOferta tmp = listaActivoOferta.get(i);
				i++;
				oferta = tmp.getPrimaryKey().getOferta();
				if ( DDEstadoOferta.CODIGO_ACEPTADA.equals(oferta.getEstadoOferta().getCodigo()) ) {
					isAccepted=true;	
				}
			}
			
			if (isAccepted && oferta!=null) {
				ExpedienteComercial expC = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
				CondicionanteExpediente condExp = expC.getCondicionante();
				OfertaUVEMDto ofertaUVEM = new OfertaUVEMDto();
				if (oferta.getTipoOferta()!=null) {
					ofertaUVEM.setCodOpcion(oferta.getTipoOferta().getCodigo());
				}
				if (oferta.getNumOferta()!=null) {
					ofertaUVEM.setCodOfertaHRE(oferta.getNumOferta().toString());
				}
				if (oferta.getPrescriptor()!=null) {
					ofertaUVEM.setCodPrescriptor(oferta.getPrescriptor().getCodProveedorUvem());
				}
				if (condExp!=null) {
					if (DDTipoCalculo.TIPO_CALCULO_PORCENTAJE.equals(condExp.getTipoCalculoReserva()) ) {
						importeReserva = condExp.getPorcentajeReserva()*oferta.getImporteOferta();
						if (importeReserva != null) {
							ofertaUVEM.setImporteReserva(importeReserva.toString());
						}
					} else {
						importeReserva = condExp.getImporteReserva();
						if (importeReserva != null) {
							ofertaUVEM.setImporteReserva(importeReserva.toString());
						}						
					}
				}
				if (oferta.getImporteOferta()!=null) {
					ofertaUVEM.setImporteVenta(oferta.getImporteOferta().toString());
				}
				Map<String, Object> mapOferta = new HashMap<String, Object>();
				mapOferta.put("oferta", ofertaUVEM);
								
				ArrayList<TitularUVEMDto> listaTitularUVEM = new ArrayList<TitularUVEMDto>();
				for (int k=0; k<expC.getCompradores().size();k++) {
					CompradorExpediente compradorExpediente = expC.getCompradores().get(k);
					TitularUVEMDto titularUVEM = new TitularUVEMDto();
					if (compradorExpediente.getComprador()!=null) {
						titularUVEM.setCliente(compradorExpediente.getComprador().toString());
					}
					if (compradorExpediente.getImporteProporcionalOferta()!=null) {
						titularUVEM.setPorcentaje(compradorExpediente.getPorcionCompra().toString());
					}			
					if (condExp.getReservaConImpuesto()!=null && condExp.getReservaConImpuesto()==1) {
						titularUVEM.setImpuestos("S");
					} else {
						titularUVEM.setImpuestos("N");
					}
					if (condExp.getEntidadFinanciacion()!=null) {
						titularUVEM.setEntidad(condExp.getEntidadFinanciacion());
					}
					if (expC.getReserva()!=null) {
						if (expC.getReserva().getTipoArras()!=null) {
							if (DDTiposArras.CONFIRMATORIAS.equals(expC.getReserva().getTipoArras().getCodigo())) {
								titularUVEM.setArras("A");
							} else {
								titularUVEM.setArras("B");
							}
						} else {
							titularUVEM.setArras("");
						}
					}					
					listaTitularUVEM.add(titularUVEM);
				}
				Map<String, Object> mapTitulares = new HashMap<String, Object>();
				mapTitulares.put("titulares",listaTitularUVEM);

				listaRespuesta.add(mapOferta);
				listaRespuesta.add(mapTitulares);
				
				if (COBRO_RESERVA.equals(reservaDto.getAccion())) {
					EntregaReserva entregaReserva = new EntregaReserva();				
					entregaReserva.setImporte(importeReserva);
					Date fechaEntrega = new Date();
					entregaReserva.setFechaEntrega(fechaEntrega);
					entregaReserva.setReserva(expC.getReserva());
					if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expC.getId())) {
						throw new Exception("No se ha podido guardar la reserva entregada en base de datos");
					}
					DDEstadosExpedienteComercial estadoReservado = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.RESERVADO);
					if (estadoReservado==null) {
						throw new Exception("No se ha podido obtener estado RESERVADO de base de datos");
					}
					expC.setEstado(estadoReservado);
					if (!expedienteComercialApi.update(expC)) {
						throw new Exception("No se ha podido actualizar estado expediente comercial en base de datos");
					}
				}
				
				if (DEVOLUCION_RESERVA.equals(reservaDto.getAccion())) {
					EntregaReserva entregaReserva = new EntregaReserva();
					entregaReserva.setImporte(-importeReserva);
					Date fechaEntrega = new Date();
					entregaReserva.setFechaEntrega(fechaEntrega);
					entregaReserva.setReserva(expC.getReserva());
					
					if (!expedienteComercialApi.addEntregaReserva(entregaReserva, expC.getId())) {
						throw new Exception("No se ha podido eliminar la reserva entregada en base de datos");
					}
					DDEstadosExpedienteComercial estadoReservado = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.ANULADO);
					if (estadoReservado==null) {
						throw new Exception("No se ha podido obtener estado ANULADO de base de datos");
					}
					expC.setEstado(estadoReservado);
					if (!expedienteComercialApi.update(expC)) {
						throw new Exception("No se ha podido actualizar estado expediente comercial en base de datos");
					}
				}

				if (COBRO_VENTA.equals(reservaDto.getAccion())) {
					DDEstadosExpedienteComercial estadoReservado = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.VENDIDO);
					if (estadoReservado==null) {
						throw new Exception("No se ha podido obtener estado VENDIDO de base de datos");
					}
					expC.setEstado(estadoReservado);
					if (!expedienteComercialApi.update(expC)) {
						throw new Exception("No se ha podido actualizar estado expediente comercial en base de datos");
					}
				}
			}					
			
			model.put("id", jsonData.getId());	
			model.put("data", listaRespuesta);
			model.put("error", "");

		} catch (Exception e) {
			e.printStackTrace();
			model.put("id", jsonData.getId());	
			model.put("data", "");
			model.put("error", e.getMessage());
		}
	
		restApi.sendResponse(response, model);
	}
	
	
}
