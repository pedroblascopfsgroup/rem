package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

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
import es.pfsgroup.plugin.rem.rest.dto.OfertaUVEMDto;
import es.pfsgroup.plugin.rem.rest.dto.ReservaDto;
import es.pfsgroup.plugin.rem.rest.dto.ReservaRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteRequestDto;
import es.pfsgroup.plugin.rem.rest.dto.TitularUVEMDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class ResolucionComiteController {

	@RequestMapping(method = RequestMethod.POST, value = "/resolucioncomite")
	public ModelAndView resolucionComite(ModelMap model, RestRequestWrapper request) {
		
		final String RESOLUCION_APROBADA = "1";
		final String RESOLUCION_DENEGADA = "3";
		final String RESOLUCION_CONTRAOFERTA = "4";
		
		final String COMITE_DGVIER = "2";
		final String COMITE_PLATAFORMA = "3";
		final String COMITE_ACTIVIDAD_INMOBILIARIA = "4";
		final String COMITE_GESTIÓN_INMOBILIARIA = "5";
		final String COMITE_INMOBILIARIO = "6";
		final String COMITE_DIRECCION = "7";
		final String COMITE_CONSEJO_ADMIN = "8";
		final String COMITE_FTA = "9";
		
		final String DENEGACION_BAJO_IMPORTE = "1";
		final String DENEGACION_OFERTAS_MEJORES = "2";
		final String DENEGACION_NO_ACEPTA_IMPORTE_RESERVA = "3";
		final String DENEGACION_NO_ACEPTA_PLAZO_RESERVA = "4";
		final String DENEGACION_NO_ASUME_GASTOS_COMPRAVENTA = "5";
		final String DENEGACION_NO_ASUME_CARGAS_NO_CANCELABLES = "6";
		final String DENEGACION_NO_ASUME_SITUACION_URBANISTICA = "7";
		final String DENEGACION_NO_ASUME_TIPO_IMPOSITIVO = "8";
		final String DENEGACION_NO_ASUME_SITUACION_FISICA = "9";
		final String DENEGACION_NO_ASUME_SITUACION_ARRENDATICIA = "10";
		final String DENEGACION_EMPLEADO_NO_CUBRE_MINIMO = "11";
		final String DENEGACION_DEUDOR_NO_ACREDITA_FINANCIACION = "12";
		final String DENEGACION_DEUDOR_NO_CUBRE_VALOR = "13";
		final String DENEGACION_DEUDOR_NO_ACEPTA_CONDICIONES = "14";
		final String DENEGACION_DECISION_DEL_COMITE = "15";
		final String DENEGACION_DECISION_DEL_AREA = "16";
		final String DENEGACION_OTROS = "17";
		final String DENEGACION_IMPORTE_INFERIOR_PRECIO_MÍNIMO = "18";
		
		
		ResolucionComiteRequestDto jsonData = null;
		ResolucionComiteDto resolucionComiteDto = null;
		
		try {
			jsonData = (ResolucionComiteRequestDto) request.getRequestData(ResolucionComiteRequestDto.class);
			resolucionComiteDto = jsonData.getData();
			
		} catch (Exception e) {
			e.printStackTrace();
			model.put("id", jsonData.getId());	
			model.put("data", "");
			model.put("error", e.getMessage());
		}
	
		return new ModelAndView("jsonView", model);
		
	}
	
}