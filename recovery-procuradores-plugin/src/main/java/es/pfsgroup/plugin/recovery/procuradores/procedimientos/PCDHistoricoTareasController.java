package es.pfsgroup.plugin.recovery.procuradores.procedimientos;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVCodigoPostalPlazaApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.factories.MSVCodigoPostalPlazaFactory;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

/**
 * Controlador para mostrar el historico de tareas y resoluciones
 * 
 * @author Carlos
 * 
 */
@Controller
public class PCDHistoricoTareasController {
	

	public static final String JSON_HIST_TAREAS = "plugin/masivo/procedimientos/historicoTareasJSON";
	public static final String JSP_VENTANA_RESOLUCION_DESDE_TAREA = "plugin/procuradores/procedimientos/tabs/ventanaDetalleResolucion";
	
	

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	MSVCodigoPostalPlazaFactory msvCodigoPostalPlazaFactory;
	
 
    
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abreFormularioDinamico(Long idInput, Long idTipoResolucion, ModelMap model){
		
		String html = proxyFactory.proxy(MSVResolucionApi.class).dameAyuda(idTipoResolucion);
		
		RecoveryBPMfwkInput input = proxyFactory.proxy(RecoveryBPMfwkInputApi.class).get(idInput);

		Long idProcedimiento = input.getIdProcedimiento();
		Procedimiento prc = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
		Long idAsunto = prc.getAsunto().getId();
		
		MSVCodigoPostalPlazaApi msvCodigoPostalPlazaApi = msvCodigoPostalPlazaFactory.getBusinessObject();
		//MSVCodigoPostalPlazaApi msvCodigoPostalPlazaApi = msvGenericFactory.getBusinessObject();
		String codigoPlaza = msvCodigoPostalPlazaApi.obtenerPlazaAPartirDeDomicilio(idAsunto);

		model.put("html", html);
		model.put("idTipoResolucion", idTipoResolucion);
		model.put("idProcedimiento", idProcedimiento);
		model.put("idAsunto", idAsunto);
		model.put("idInput", idInput);
		model.put("codigoTipoProc", prc.getTipoProcedimiento().getCodigo());
		model.put("codigoPlaza", codigoPlaza);
		
		return JSP_VENTANA_RESOLUCION_DESDE_TAREA;
	}
	
    

}
