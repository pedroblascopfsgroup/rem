package es.pfsgroup.procedimientos.adjudicacion;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.procedimientos.PROEndProcessActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class PROEndElevacionCajamarActionHandler extends PROEndProcessActionHandler {

	private static final long serialVersionUID = 1L;

	@Override
	protected String getTransicion(ExecutionContext executionContext) {
        String transitionName = (Checks.esNulo(this.getTransicionIntegracion()))
        		? getNombreProceso(executionContext)
        		: this.getTransicionIntegracion();
        
        TareaExterna tex = getTareaExternaByName("HCJ002_ObtenerValidacionComite", executionContext);
   		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tex.getId());
        		
   		if (!Checks.esNulo(listado)) {
			for (TareaExternaValor tev : listado) {
				
				if(tev.getNombre().equals("comboResultado") || tev.getNombre().equals("comboSuspension")) {
					transitionName += "/" + tev.getNombre() + ":" + tev.getValor();
				}
			}
		}
   		
        return transitionName;
	}
}
