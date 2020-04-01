package es.pfsgroup.plugin.rem.jbpm;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

@Service("validateJbpmManager")
public class ValidateJbpmManager implements ValidateJbpmApi {

	private final String FALTA_MARCAR_RESERVA_NECESARIA = "En la reserva del expediente se debe marcar si es necesaria o no para poder avanzar.";
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Override
	public String definicionOfertaT013(TareaExterna tareaExterna, String codigo, Map<String, Map<String,String>> valores) {
		//HREOS-2161
		Trabajo trabajo = trabajoApi.tareaExternaToTrabajo(tareaExterna);
		if (!trabajoApi.checkReservaNecesariaNotNull(tareaExterna) &&
			!Checks.esNulo(trabajo) && 
			expedienteComercialApi.isComiteSancionadorHaya(trabajo)) {
			return FALTA_MARCAR_RESERVA_NECESARIA;		
		}
		// SELECT TAP_SCRIPT_VALIDACION_JBPM FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'T013_DefinicionOferta'
		//  - (checkFormalizacion() ? (checkDeDerechoTanteo() == false ? (checkBankia() ? altaComiteProcess() : null) : null) : null)				
		if (trabajoApi.checkFormalizacion(tareaExterna)) {
			if (ofertaApi.checkDeDerechoTanteo(tareaExterna) == false) {
				if (trabajoApi.checkBankia(tareaExterna)) {
					return ofertaApi.altaComiteProcess(tareaExterna, codigo);
				}
			}
		}		
		if (trabajoApi.checkLiberbank(tareaExterna)) {
			if(ofertaApi.comprobarComiteLiberbankPlantillaPropuesta(tareaExterna)) {
				String errores = activoTramiteApi.existeAdjuntoUGCarteraValidacion(tareaExterna,"36","E","08");
				if(Checks.esNulo(errores)) {
					return ofertaApi.isValidateOfertasDependientes(tareaExterna, valores);
				}else {
					return errores;
				}
			}else {
				return ofertaApi.isValidateOfertasDependientes(tareaExterna, valores);
			}
		}
		return null;
	}
	
	@Override
	public String resolucionComiteT013(TareaExterna tareaExterna, Map<String, Map<String, String>> valores) {
		//HREOS-2161
		if (!trabajoApi.checkReservaNecesariaNotNull(tareaExterna)) return FALTA_MARCAR_RESERVA_NECESARIA;
		if (trabajoApi.checkBankia(tareaExterna) || trabajoApi.checkLiberbank(tareaExterna)
				|| trabajoApi.checkGiants(tareaExterna)) {
			return ofertaApi.isValidateOfertasDependientes(tareaExterna, valores);
		}
		return activoTramiteApi.existeAdjuntoUGValidacion(tareaExterna, DDSubtipoDocumentoExpediente.CODIGO_ADVISORY_NOTE_FIRMADO_PROPIEDAD,"E");

	}	
	
	@Override
	public String respuestaOfertanteT013(TareaExterna tareaExterna, String importeOfertante) {
		String resultado = null;
		//HREOS-2161
		if (!trabajoApi.checkReservaNecesariaNotNull(tareaExterna) && !trabajoApi.checkBankia(tareaExterna)) return FALTA_MARCAR_RESERVA_NECESARIA;		
		// SELECT TAP_SCRIPT_VALIDACION_JBPM FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'T013_RespuestaOfertante'
		//  - (checkBankia() ? ratificacionComiteProcess() : null)
		if (trabajoApi.checkBankia(tareaExterna)) {
			resultado = ofertaApi.ratificacionComiteProcess(tareaExterna, importeOfertante);
		}
		return resultado;		
	}
	
	@Override
	public String ratificacionComiteT013(TareaExterna tareaExterna) {
		//HREOS-2161
		if (!trabajoApi.checkReservaNecesariaNotNull(tareaExterna)) return FALTA_MARCAR_RESERVA_NECESARIA;
		return null;		
	}
}
