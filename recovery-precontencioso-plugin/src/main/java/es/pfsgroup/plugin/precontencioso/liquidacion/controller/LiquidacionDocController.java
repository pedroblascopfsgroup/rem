package es.pfsgroup.plugin.precontencioso.liquidacion.controller;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContext;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectUtils;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarDocumentoApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarLiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.DDPropietarioPCODto;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Controller
public class LiquidacionDocController {

	private static final String JSP_LIQUIDACION_CERT_SALDO = "plugin/precontencioso/liquidacion/popups/seleccionarLiquidacionCertSaldo";
	private static final String JSP_LIQUIDACION_CARTA_NOTARIO = "plugin/precontencioso/liquidacion/popups/seleccionarLiquidacionCartaNotario";
	
	private static final String JSON_PROPIETARIAS = "plugin/precontencioso/liquidacion/json/propietariasJSON";
	private static final String JSON_LOCALIDADES_FIRMA = "plugin/precontencioso/liquidacion/json/localidadesFirmaJSON";
	private static final String JSON_CENTROS = "plugin/precontencioso/liquidacion/json/centrosJSON";
	private static final String JSP_DOWNLOAD_FILE = "plugin/geninformes/download";
	private static final String JSON_PLANTILLAS = "plugin/precontencioso/liquidacion/json/plantillasJSON";

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired(required = false)
	private GenerarDocumentoApi generarDocumentoApi;
	
	@Autowired
	PrecontenciosoProjectContext precontenciosoContext;
	
	@Autowired(required = false)
	PrecontenciosoProjectUtils precontenciosoUtils;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	private List<DDTipoLiquidacionPCO> getPlantillasLiquidacion() {
		return diccionarioApi.dameValoresDiccionario(DDTipoLiquidacionPCO.class);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getPlantillasLiquidacion(ModelMap model) {

		List<DDTipoLiquidacionPCO> plantillas = getPlantillasLiquidacion();
		model.put("plantillas", plantillas);
		return JSON_PLANTILLAS;

	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirPopupCertSaldo(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {

		List<DDTipoLiquidacionPCO> plantillas = getPlantillasLiquidacion();
		model.put("ocultarCombo", Checks.estaVacio(plantillas));
		model.put("idLiquidacionSeleccionada", id);
		return JSP_LIQUIDACION_CERT_SALDO;
	
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirPopupCartaNotario(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {

		model.put("idLiquidacionSeleccionada", id);
		return JSP_LIQUIDACION_CARTA_NOTARIO;

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String obtenerPropietarias(ModelMap model) {

		List<DDPropietarioPCODto> propietarios = null;
		if (precontenciosoUtils != null) {
			propietarios = precontenciosoUtils.getListaEntidadesPropietarias();
		}
		model.put("propietarias", propietarios);
		return JSON_PROPIETARIAS;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String obtenerLocalidadesFirma(ModelMap model) {

		List<String> localidadesFirma = null;
		if (precontenciosoUtils != null) {
			localidadesFirma = precontenciosoUtils.getListaLocalidades();
		}
		model.put("localidadesFirma", localidadesFirma);		
		return JSON_LOCALIDADES_FIRMA;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String obtenerCentros(ModelMap model) {

		List<String> centros = null;
		if (precontenciosoUtils != null) {
			centros = precontenciosoUtils.getListaCentros();
		}
		model.put("centros", centros);		
		return JSON_CENTROS;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarCertSaldo(@RequestParam(value = "idLiquidacion", required = true) Long idLiquidacion, 
			@RequestParam(value = "idPlantilla", required = true) Long idPlantilla, 
			@RequestParam(value = "codigoPropietaria", required = true) String codigoPropietaria,
			@RequestParam(value = "localidadFirma", required = true) String localidadFirma,
			@RequestParam(value = "notario", required = true) String notario,
			ModelMap model) {

		if (generarDocumentoApi == null) {
			logger.error("LiquidacionDocController.generarCertSaldo: No existe una implementacion para generarDocumentoApi");
			throw new BusinessOperationException("Not implemented generarDocumentoApi");
		}

		FileItem documentoLiquidacion = generarDocumentoApi.generarCertificadoSaldo(idLiquidacion, idPlantilla, codigoPropietaria, localidadFirma, notario);
		model.put("fileItem", documentoLiquidacion);

		return JSP_DOWNLOAD_FILE;

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generarCartaNotario(@RequestParam(value = "idLiquidacion", required = true) Long idLiquidacion, 
			@RequestParam(value = "notario", required = true) String notario,
			@RequestParam(value = "localidadNotario", required = true) String localidadNotario,
			@RequestParam(value = "adjuntosAdicionales", required = true) String adjuntosAdicionales,
			@RequestParam(value = "codigoPropietaria", required = true) String codigoPropietaria,
			@RequestParam(value = "centro", required = true) String centro,
			@RequestParam(value = "localidadFirma", required = true) String localidadFirma,
			ModelMap model) {
			
		if (generarDocumentoApi == null) {
			logger.error("LiquidacionDocController.generarCartaNotario: No existe una implementacion para generarDocumentoApi");
			throw new BusinessOperationException("Not implemented generarDocumentoApi");
		}

		FileItem documentoLiquidacion = generarDocumentoApi.generarCartaNotario(idLiquidacion, notario, localidadNotario, adjuntosAdicionales, codigoPropietaria, centro, localidadFirma);
		model.put("fileItem", documentoLiquidacion);

		return JSP_DOWNLOAD_FILE;

	}
}
