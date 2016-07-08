package es.pfsgroup.plugin.rem.jbpm.handler;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

/**
 * Clase que comprueba si el usuario que ha creado el trámite es Gestor de Activo del activo o Gestor de admisión del activo
 * al que pertenece el trámite.
 * @author Daniel Gutiérrez
 */

public class ActivoComprobarGestorActionHandler extends ActivoBaseActionHandler{

	private static final long serialVersionUID = 1920406024815248515L;
	
	private static final String CODIGO_TRAMITE_DOCUMENTAL = "T002";
	
	@Autowired
	GestorActivoApi gestorActivoApi;

	@Override
	public void run(ExecutionContext executionContext) throws Exception { 

		ActivoTramite tramite = getActivoTramite(executionContext);
		Usuario usuario = tramite.getTrabajo().getSolicitante();
		
		//Si viene del Trámite documental, se debe comprobar "si es gest. activo o gest. de admisión".
		//para el resto de trámites, solo "gestor de activo"
		if(CODIGO_TRAMITE_DOCUMENTAL.equals(tramite.getTipoTramite().getCodigo())){

			if(gestorActivoApi.isGestorActivoOAdmision(tramite.getActivo(),usuario))
				getExecutionContext().getToken().signal("GestorActivo");
			else
				getExecutionContext().getToken().signal("OtrosGestores");
			
		} else {
			
			if(gestorActivoApi.isGestorActivo(tramite.getActivo(),usuario))
				getExecutionContext().getToken().signal("GestorActivo");
			else
				getExecutionContext().getToken().signal("OtrosGestores");
			
		}
	}

}
