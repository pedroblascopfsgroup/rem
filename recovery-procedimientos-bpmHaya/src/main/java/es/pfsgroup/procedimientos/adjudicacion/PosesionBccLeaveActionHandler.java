package es.pfsgroup.procedimientos.adjudicacion;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class PosesionBccLeaveActionHandler extends AdjudicacionHayaLeaveActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private AdjudicacionHayaProcedimientoManager hayaProcManager;

	private List<EXTTareaExternaValor> camposTarea(TareaExterna tex) {
		return ((SubastaProcedimientoApi) proxyFactory
				.proxy(SubastaProcedimientoApi.class))
				.obtenerValoresTareaByTexId(tex.getId());
	}	
	
	@Override
	protected void setDecisionVariable(ExecutionContext executionContext) {
		
		if (executionContext.getNode().getName().equals("H015_RegistrarPosesionYLanzamiento")) {
			
			TareaExterna tex = getTareaExternaPorCodigo("H015_RegistrarSolicitudPosesion", executionContext);
			List<EXTTareaExternaValor> campos = camposTarea(tex);
			String viviendaHabitual = dameValorTarea(campos, "comboViviendaHab");
        	this.setVariable("op_viviendaHabitual", (viviendaHabitual.equals(DDSiNo.SI) ? "Si" : "No"), executionContext);
        	
        	tex = getTareaExternaPorCodigo("H015_RegistrarPosesionYLanzamiento", executionContext);
			campos = camposTarea(tex);
			String lanzamiento = dameValorTarea(campos, "comboLanzamiento");
			if(lanzamiento != null) {
				this.setVariable("op_lanzamiento", (lanzamiento.equals(DDSiNo.SI) ? "hayLanzamiento" : "noHayLanzamiento"), executionContext);
			}
		}
		
		super.setDecisionVariable(executionContext);
	}
	
	private TareaExterna getTareaExternaPorCodigo(String codigo, ExecutionContext executionContext) {
        Long idTarea = getIdTareaExterna(codigo, executionContext);
        if (idTarea != null) {
            return proxyFactory.proxy(TareaExternaApi.class).get(idTarea);
        }
        return null;

    }

    private Long getIdTareaExterna(String codigo, ExecutionContext executionContext) {
        final Long idToken = executionContext.getToken().getId();

        // Esto permite tener asociación robusta para cada tarea en el contexto JBPM.
        // Manteniendo sólo el ID de tarea no funciona bien cuando una misma tarea la replicamos N veces en un contexto.
        // Ahora se almacenerá esa correspondencia de la siguiente forma: idTAREA_token = idtareaexterna
        // Se mantiene compatibilidad hacia atrás
        String shortTokenName = String.format("id%s", codigo);
        String uniqueTokenName = String.format("id%s.%d", codigo, idToken);
        Long tex_id = (Long)executionContext.getVariable(uniqueTokenName);
        if (tex_id == null) {
        	tex_id = (Long)executionContext.getVariable(shortTokenName);
        }
        return tex_id;
    }


	private String dameValorTarea(List<EXTTareaExternaValor> campos, String nombreCampo) {
		String valor = null;
		for (TareaExternaValor tev : campos) {
			if (tev.getNombre().equals(nombreCampo)) {
				valor = tev.getValor();
				break;
			}
		}
		
		return valor;		
	}
}
