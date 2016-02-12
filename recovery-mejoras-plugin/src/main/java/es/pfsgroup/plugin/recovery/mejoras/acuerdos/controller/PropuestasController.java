package es.pfsgroup.plugin.recovery.mejoras.acuerdos.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.annotations.Check;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import com.tc.aspectwerkz.transform.inlining.compiler.CompilationInfo.Model;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDMotivoRechazoAcuerdo;
import es.capgemini.pfs.core.api.acuerdo.AcuerdoApi;
import es.capgemini.pfs.core.api.acuerdo.CumplimientoAcuerdoDto;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.api.PropuestaApi;

@Controller
public class PropuestasController {

	private static final String DEFAULT = "default";

	private static final String JSP_ALTA_PROPUESTA = "plugin/mejoras/acuerdos/editaConclusionesAcuerdo";
	private static final String JSP_RECHAZA_PROPUESTA = "plugin/mejoras/acuerdos/rechazarAcuerdo";
	private static final String LISTADO_PROPUESTAS_JSON =  "plugin/mejoras/acuerdos/acuerdosJSON";
	private static final String JSON_LISTADO_CONTRATOS = "plugin/mejoras/acuerdos/listadoContratosAsuntoJSON";
	private static final String JSP_FINALIZACION_PROPUESTA = "plugin/mejoras/acuerdos/finalizacionPropuesta";
	private static final String LISTADO_PROPUESTAS_REALIZADAS_JSON =  "plugin/mejoras/acuerdos/propuestasRealizadasJSON";
	private static final String LISTADO_PROPUESTAS_EXPLORAR_JSON =  "plugin/mejoras/acuerdos/propuestasExplorarJSON";
	private static final String JSON_LISTADO_BIENES_PROPUESTA = "plugin/mejoras/acuerdos/listadoBienesAcuerdoJSON";
	private static final String JSP_CUMPLIMIENTO_PROPUESTA = "plugin/mejoras/acuerdos/cumplimientoPropuesta";


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
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String rechazarAcuerdo(ModelMap model, Long idAcuerdo){
		model.put("motivosRechazo", dictionaryManager.getList("DDMotivoRechazoAcuerdo")); 
		
		Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(idAcuerdo);
		model.put("acuerdo",acuerdo);
		
		model.put("esPropuesta", true);

		return JSP_RECHAZA_PROPUESTA;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirFinalizacion(@RequestParam(value = "idAcuerdo", required = true) Long id, ModelMap map) {
		Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(id);
		map.put("acuerdo",acuerdo);
		
		List<DDSiNo> ddsino = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDSiNo.class);
		map.put("ddSiNo", ddsino);
		
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
	
	/**
     * Obtiene un listado de las propuestas asignadas al expediente.
     * @param idExpediente
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String getPropuestasRealizadasByExpedienteId(Long id,ModelMap model) {
		model.put("propuestas",propuestaApi.listadoPropuestasRealizadasByExpedienteId(id));
		return LISTADO_PROPUESTAS_REALIZADAS_JSON;
	}
	
	
	/**
     * Obtiene un listado de las propuestas asignadas al expediente.
     * @param idExpediente
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String getPropuestasExplorarByExpedienteId(Long id,ModelMap model) {
		model.put("actuacionesAExplorar",propuestaApi.listadoActuacionesAExplorarExpediente(id));
		return LISTADO_PROPUESTAS_EXPLORAR_JSON;
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
    public String rechazar(@RequestParam(value = "idPropuesta", required = true) Long idPropuesta, @RequestParam(value = "idMotivo", required = true) String motivo, 
    		@RequestParam(value = "observaciones") String observaciones) {
		propuestaApi.rechazar(idPropuesta, motivo, observaciones);
		return DEFAULT;
	}

	@RequestMapping
    public String finalizar(WebRequest request, ModelMap model) throws ParseException {
		
		Long idPropuesta = Long.valueOf(request.getParameter("id"));
		
		Date fechaPago = new Date();
		
		if(!Checks.esNulo(request.getParameter("fechaPago"))){
			SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
			fechaPago = formatter.parse(request.getParameter("fechaPago"));	
		}
		
		String observaciones = request.getParameter("observaciones");
		Boolean cumplido = false;
		if(DDSiNo.SI.equals(request.getParameter("cumplido"))){
			cumplido = true;
		}

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
	
	@RequestMapping
    public String obtenerListadoBienesPropuesta(@RequestParam(value = "idExpediente", required = true) Long idExpediente, String contratosIncluidos, ModelMap model){
		
		List<Long> idsContrato = new ArrayList<Long>();
		for(String contrato : contratosIncluidos.split(",")){
			if (!contrato.equals("")) {
				idsContrato.add(Long.parseLong(contrato));
			}
		}

		model.put("listadoBienesAcuerdo", propuestaApi.getBienesDelExpedienteParaLaPropuesta(idExpediente,idsContrato));
		
		return JSON_LISTADO_BIENES_PROPUESTA;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openCumplimientoPropuesta(@RequestParam(value = "idPropuesta", required = true) Long id, ModelMap map) {
				
		Acuerdo acuerdo = proxyFactory.proxy(AcuerdoApi.class).getAcuerdoById(id);
		map.put("acuerdo",acuerdo);
		
		List<DDSiNo> ddsino = proxyFactory.proxy(UtilDiccionarioApi.class).dameValoresDiccionario(DDSiNo.class);
		map.put("ddSiNo", ddsino);
		
		return JSP_CUMPLIMIENTO_PROPUESTA;
	}
	
	@RequestMapping
	public String guardaCumplimientoAcuerdo(WebRequest request){
		CumplimientoAcuerdoDto dto = creaDto (request);
		
		if (dto.getFinalizar()){
			proxyFactory.proxy(PropuestaApi.class).cerrarPropuesta(dto.getId());
		}

		proxyFactory.proxy(PropuestaApi.class).registraCumplimientoPropuesta(dto);
		return "default";
	}

	private CumplimientoAcuerdoDto creaDto(final WebRequest request) {
		return DynamicDtoUtils.create(CumplimientoAcuerdoDto.class, request);
	}
}
