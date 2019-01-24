package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
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
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ReservaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDAccionGastos;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.ReservaDto;
import es.pfsgroup.plugin.rem.rest.dto.ReservaRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularUVEMDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;

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
	private OfertaApi ofertaApi;
	
	private final Log logger = LogFactory.getLog(getClass());
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/reserva")
	public void reservaInmueble(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {
		ReservaRequestDto jsonData = null;
		ReservaDto reservaDto = null;
		JSONObject jsonFields = null;
		Map<String, Object> respuesta = new HashMap<String, Object>();
		HashMap<String, String> errorList = null;
		Oferta oferta = null;
		
		try{
			jsonFields = request.getJsonObject();
			jsonData = (ReservaRequestDto) request.getRequestData(ReservaRequestDto.class);
			reservaDto = jsonData.getData();
			
			errorList = reservaApi.validateReservaPostRequestData(reservaDto, jsonFields) ;
			if (errorList != null && errorList.isEmpty()) {
				
				Activo activo = activoApi.getByNumActivoUvem(reservaDto.getActivo());
				
				//HREOS-1704: Para la ANULACION_DEVOLUCION_RESERVA hay que buscar la última oferta rechazada.
				if (reservaDto.getAccion().equalsIgnoreCase(ReservaApi.ANULACION_DEVOLUCION_RESERVA)) {
					DtoOfertasFilter dtoOfertasFilter = new DtoOfertasFilter();
					dtoOfertasFilter.setIdActivo(activo.getId());
					dtoOfertasFilter.setEstadoOferta(DDEstadoOferta.CODIGO_RECHAZADA);
					
					List<VOfertasActivosAgrupacion> listaOfer = (List<VOfertasActivosAgrupacion>) ofertaApi.getListOfertasFromView(dtoOfertasFilter);
					if(!Checks.esNulo(listaOfer) && listaOfer.size()>0){
						Long idOferta = listaOfer.get(0).getIdOferta();
						if(!Checks.esNulo(idOferta)){
							oferta = ofertaApi.getOfertaById(idOferta);
						}
					}						
				}else{
					//Para el resto de acciones hay que buscar la última oferta aceptada.
					oferta = activoApi.tieneOfertaAceptada(activo);					
				}
				if(Checks.esNulo(oferta)){
					throw new Exception("El activo no tiene ofertas.");
				}
				
				ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
				
				OfertaUVEMDto ofertaUVEM = expedienteComercialApi.createOfertaOVEM(oferta, expedienteComercial);				
				if(!reservaDto.getAccion().equalsIgnoreCase(ReservaApi.COBRO_VENTA)){
					//El prescriptor solo se debe alimentar en la consulta del cobro de la venta.
					//No se debe de enviar ni en el cobro de la reserva ni en la devolución.
					ofertaUVEM.setCodPrescriptor("");
				} else {
					
					boolean bankia = false;

					List<GastosExpediente> gastosExpediente = expedienteComercial.getHonorarios();

					if (!Checks.estaVacio(gastosExpediente)) {
						for (GastosExpediente gastoExp : gastosExpediente) {
							if (!Checks.esNulo(gastoExp.getAccionGastos())) {
								if (DDAccionGastos.CODIGO_PRESCRIPCION.equals(gastoExp.getAccionGastos().getCodigo())) {
									if (!Checks.esNulo(gastoExp.getProveedor())) {
										if (DDTipoProveedor.COD_OFICINA_BANKIA
												.equals(gastoExp.getProveedor().getTipoProveedor().getCodigo())) {
											ofertaUVEM.setCodPrescriptor(
													(gastoExp.getProveedor().getCodigoApiProveedor()));
											bankia = true;
											break;
										}
									}
								}
							}
						}
					}

					if (!bankia)
						ofertaUVEM.setCodPrescriptor("C000");

				}			
				
				ArrayList<TitularUVEMDto> listaTitularUVEM = expedienteComercialApi.obtenerListaTitularesUVEM(expedienteComercial);
				
				respuesta.put("oferta", ofertaUVEM);
				respuesta.put("titulares", listaTitularUVEM);
				
				model.put("id", jsonFields.get("id"));
				model.put("data", respuesta);
				model.put("error", "");
				
			}else{
				model.put("id", jsonFields.get("id"));
				model.put("data", null);
				model.put("error", errorList);
			}
		}catch(Exception e){
			logger.error("Error reserva", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			model.put("id", jsonFields.get("id"));
			model.put("data", respuesta);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);
		}
		
		restApi.sendResponse(response, model,request);
		
	}



}
