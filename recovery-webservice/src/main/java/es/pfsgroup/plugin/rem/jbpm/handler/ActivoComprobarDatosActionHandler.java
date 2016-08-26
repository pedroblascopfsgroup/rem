package es.pfsgroup.plugin.rem.jbpm.handler;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

/**
 * Clase que comprueba si el informe comercial tiene fecha aceptación y si los datos de mediador 
 * son distintos que los de admisión.
 * @author Daniel Gutiérrez
 */

public class ActivoComprobarDatosActionHandler extends ActivoBaseActionHandler{

	private static final long serialVersionUID = 1920406024815248515L;
	
	@Autowired
	GestorActivoApi gestorActivoApi;

	@Override
	public void run(ExecutionContext executionContext) throws Exception { 

		ActivoTramite tramite = getActivoTramite(executionContext);
		
		Activo activo = tramite.getActivo();
		
		//TODO: Pendiente de definir ActivoEstadosInformeComercialHistorico de HREOS-685, de momento lanzamos la siguiente tarea.
		
		getExecutionContext().getToken().signal("DatosIguales");


	}

}
