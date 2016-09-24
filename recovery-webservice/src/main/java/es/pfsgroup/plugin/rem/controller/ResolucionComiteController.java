package es.pfsgroup.plugin.rem.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class ResolucionComiteController {
	
	
	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/resolucioncomite")
	public ModelAndView resolucionComite(ModelMap model, RestRequestWrapper request) {
		
		final Log logger = LogFactory.getLog(getClass());
		
		final Long RESOLUCION_APROBADA = new Long(1);
		final Long RESOLUCION_DENEGADA = new Long(3);
		final Long RESOLUCION_CONTRAOFERTA = new Long(4);
		
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
			
			if( Checks.esNulo(jsonData) || resolucionComiteDto == null) {
				throw new Exception("No se han podido recuperar los datos de la petición. Peticion mal estructurada.");
			}
			
//			Oferta oferta = ofertaApi.getOfertaByNumOfertaRem(resolucionComiteDto.getOfertaHRE());
//			ExpedienteComercial expedienteComercial = expedienteComercialApi.expedienteComercialPorOferta (oferta.getId());
			
			if (RESOLUCION_APROBADA.equals(resolucionComiteDto.getCodigoResolucion())) {
//				DDEstadosExpedienteComercial estadoAprobado = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.APROBADO);
//				expedienteComercial.setEstado(estadoAprobado);
				logger.warn("RESOLUCION_APROBADA: CodigoComite="+resolucionComiteDto.getCodigoComite()+" CodigoResolucion="+resolucionComiteDto.getCodigoResolucion());
				//TODO: Falta hacer BPM de RESOLUCION_APROBADA
			} else if (RESOLUCION_DENEGADA.equals(resolucionComiteDto.getCodigoResolucion())) {
//				DDEstadoOferta ofertaDenegada = ofertaApi.getDDEstadosOfertaByCodigo(DDEstadoOferta.CODIGO_RECHAZADA);
//				oferta.setEstadoOferta(ofertaDenegada);
//				DDEstadosExpedienteComercial estadoDenegado = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.DENEGADO);
//				expedienteComercial.setEstado(estadoDenegado);
				logger.warn("RESOLUCION_DENEGADA: CodigoComite="+resolucionComiteDto.getCodigoComite()+" CodigoDenegacion="+resolucionComiteDto.getCodigoDenegacion());
				//TODO: Falta hacer BPM de RESOLUCION_DENEGADA
			} else if (RESOLUCION_CONTRAOFERTA.equals(resolucionComiteDto.getCodigoResolucion())) {
//				DDEstadosExpedienteComercial estadoContraofertado = expedienteComercialApi.getDDEstadosExpedienteComercialByCodigo(DDEstadosExpedienteComercial.CONTRAOFERTADO);
//				expedienteComercial.setEstado(estadoContraofertado);
				logger.warn("RESOLUCION_CONTRAOFERTA: CodigoComite="+resolucionComiteDto.getCodigoComite()+" ImporteContraoferta="+resolucionComiteDto.getImporteContraoferta());
				//TODO: Falta hacer BPM de RESOLUCION_CONTRAOFERTA
			}
			model.put("id", jsonData.getId());	
			
		} catch (Exception e) {
			
			e.printStackTrace();
			model.put("id", jsonData.getId());	
			model.put("error", e.getMessage());
		}
	
		return new ModelAndView("jsonView", model);
		
	}
	
}