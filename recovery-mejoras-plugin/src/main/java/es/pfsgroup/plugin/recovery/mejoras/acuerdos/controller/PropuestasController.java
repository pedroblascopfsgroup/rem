package es.pfsgroup.plugin.recovery.mejoras.acuerdos.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.core.api.acuerdo.AcuerdoApi;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;

@Controller
public class PropuestasController {

	private static final String DEFAULT = "default";
	private static final String JSP_ALTA_PROPUESTA = "plugin/mejoras/acuerdos/editaConclusionesAcuerdo";
	private static final String LISTADO_PROPUESTAS_JSON =  "plugin/mejoras/acuerdos/acuerdosJSON";
	private static final String JSON_LISTADO_CONTRATOS = "plugin/mejoras/acuerdos/listadoContratosAsuntoJSON";
	private static final String JSP_FINALIZACION_PROPUESTA = "plugin/mejoras/acuerdos/finalizacionPropuesta";

	@Autowired 
	private DictionaryManager dictionaryManager; 

	@Autowired
	private PropuestaApi propuestaApi;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private ApiProxyFactory proxyFactory;

    /**
     * Abre la ventana para crear una nueva propuesta.
     * @param idExpediente
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String abreCrearPropuesta(ModelMap model,Long idExpediente) {
		
		model.put("readOnly", false);
		
		model.put("tiposAcuerdo", dictionaryManager.getList("DDTipoAcuerdo"));
		model.put("solicitantes", dictionaryManager.getList("DDSolicitante"));
		model.put("estados", dictionaryManager.getList("DDEstadoAcuerdo"));
		model.put("tiposPago", dictionaryManager.getList("DDTipoPagoAcuerdo"));
		model.put("periodicidad", dictionaryManager.getList("DDPeriodicidadAcuerdo"));
		
//		model.put("esGestor", procedimientoApi.esGestor(idProcedimiento));
//		model.put("esSupervisor", procedimientoApi.esSupervisor(idProcedimiento));
		
		model.put("idExpediente",idExpediente);
		
		
		return JSP_ALTA_PROPUESTA;
	}

	@RequestMapping
	public String abrirFinalizacion(@RequestParam(value = "idAcuerdo", required = true) Long id, ModelMap map) {
		Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(id);
		map.put("acuerdo",acuerdo);

		return JSP_FINALIZACION_PROPUESTA;
	}

    /**
     * Obtiene un listado de las propuestas asignadas al expediente.
     * @param idExpediente
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String getPropuestasByExpedienteId(Long id,ModelMap model) {
		
		model.put("acuerdos",propuestaApi.listadoPropuestasByExpedienteId(id));
		
		return LISTADO_PROPUESTAS_JSON;
	}
	
	@RequestMapping
    public String proponer(@RequestParam(value = "idPropuesta", required = true) Long idPropuesta, ModelMap model) {
		propuestaApi.proponer(idPropuesta);
		return DEFAULT;
	}

	@RequestMapping
    public String cancelar(@RequestParam(value = "idPropuesta", required = true) Long idPropuesta, ModelMap model) {
		propuestaApi.cancelar(idPropuesta);
		return DEFAULT;
	}
	
	@RequestMapping
    public String rechazar(@RequestParam(value = "idPropuesta", required = true) Long idPropuesta, String motivo) {
		propuestaApi.rechazar(idPropuesta, motivo);
		return DEFAULT;
	}

	@RequestMapping
    public String finalizar(WebRequest request, ModelMap model) throws ParseException {
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

		Long idPropuesta = Long.valueOf(request.getParameter("id"));
		Date fechaPago = formatter.parse(request.getParameter("fechaPago"));
		String observaciones = request.getParameter("observaciones");
		Boolean cumplido = Boolean.valueOf(request.getParameter("cumplido"));

		propuestaApi.finalizar(idPropuesta, fechaPago, cumplido, observaciones);

		return DEFAULT;
	}

    /**
     * Obtiene un listado de los contratos del expediente.
     * @param idExpediente
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String getContratosByExpedienteId(Long idExpediente,ModelMap model) {
		
		model.put("listadoContratosAsuntos",propuestaApi.listadoContratosByExpedienteId(idExpediente));
		
		return JSON_LISTADO_CONTRATOS;
	}
}
