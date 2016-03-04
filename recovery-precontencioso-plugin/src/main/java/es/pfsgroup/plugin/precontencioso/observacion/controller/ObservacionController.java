package es.pfsgroup.plugin.precontencioso.observacion.controller;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.obervacion.model.ObservacionPCO;
import es.pfsgroup.plugin.precontencioso.observacion.api.ObservacionApi;
import es.pfsgroup.plugin.precontencioso.observacion.dto.ObservacionDTO;
import es.pfsgroup.plugin.precontencioso.observacion.manager.ObservacionManager;

@Controller
public class ObservacionController {
	
	private static final String DEFAULT = "default";
	private static final String JSON_OBSERVACIONES = "plugin/precontencioso/observacion/json/observacionesJSON";
	private static final String VENTANA_NUEVA_OBSERVACION = "plugin/precontencioso/observacion/popups/crearObservacion";
	private static final String VENTANA_EDITAR_OBSERVACION = "plugin/precontencioso/observacion/popups/editarObservacion";
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private ObservacionApi observacionApi;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private ObservacionManager observacionManager;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getObservacionesPorProcedimientoId(@RequestParam(value = "idProcedimientoPCO", required = true) Long idProcedimientoPCO, ModelMap model) {
		
		List<ObservacionDTO> observaciones = observacionApi.getObservacionesPorIdProcedimientoPCO(idProcedimientoPCO);
		model.put("observaciones", observaciones);
		model.put("idUserLogado", usuarioManager.getUsuarioLogado().getId());
		
		return JSON_OBSERVACIONES;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String agregarNuevaObservacion(@RequestParam(value = "idProcedimientoPCO", required = true) Long idProcedimientoPCO, ModelMap model) {
		
		model.put("idPcoPrc",idProcedimientoPCO);
		model.put("idUsuario", usuarioManager.getUsuarioLogado().getId());
		
		return VENTANA_NUEVA_OBSERVACION;
	}

	@RequestMapping
	public String guardarObservacion(ObservacionDTO dto) {
		/*if(Checks.esNulo(dto.getFechaAnotacion())) {
			Date fecha = new Date();
			dto.setFechaAnotacion(fecha);
		}*/
		if(Checks.esNulo(dto.getIdUsuario())) {
			dto.setIdUsuario(usuarioManager.getUsuarioLogado().getId());
		}
		
		observacionApi.guardarObservacion(dto);
		
		return DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirEditarObservacion(@RequestParam(value = "idObservacion", required = true) Long idObservacionPCO, ModelMap model) {
		
		ObservacionPCO observacion = observacionApi.getObservacionPCOById(idObservacionPCO);
		model.put("idObservacion",idObservacionPCO);
		model.put("Usuario", observacion.getUsuario());
		model.put("textoAnotacion", observacion.getTextoAnotacion());
		model.put("idPcoPrc", observacion.getProcedimientoPCO().getId());
		model.put("idUserLogado", usuarioManager.getUsuarioLogado().getId());
		
		return VENTANA_EDITAR_OBSERVACION;
	}
	
	@RequestMapping
	public String borrarObservacion(@RequestParam(value = "idObservacion", required = true) Long idObservacionPCO, ModelMap model) {
		
		observacionManager.borrarObservacion(idObservacionPCO);
		
		return DEFAULT;
	}
	
}
