package es.pfsgroup.plugin.rem.jbpm.handler;

import java.io.IOException;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

/**
 * Clase que comprueba si para el trabajo existe ya generada una propuesta de precios y retorna señales
 * según si la propuesta fue generada por peticion o de forma manual, incluso si no hay propuesta previa.
 * @author Bender
 */

public class ActivoComprobarPropuestaPreciosActionHandler extends ActivoBaseActionHandler{

	private static final long serialVersionUID = 102030L;
	
	
	@Autowired
	GestorActivoApi gestorActivoApi;

	@Override
	public void run(ExecutionContext executionContext) throws Exception { 

		ActivoTramite tramite = getActivoTramite(executionContext);
		Usuario usuario = tramite.getTrabajo().getSolicitante();

		if(!Checks.esNulo(tramite.getTrabajo().getPropuestaPrecio()) 
				&& tramite.getTrabajo().getPropuestaPrecio().getEsPropuestaManual())
			//Existe una propuesta y es de solicitud manual
			getExecutionContext().getToken().signal("Manual");
		else {
			//No existe una propuesta o si existe es de solicitud por petición
			//Debe comprobar si "es gestor precios/marketing u otros"
			if(gestorActivoApi.isGestorPreciosOMarketing(tramite.getActivo(),usuario))
				getExecutionContext().getToken().signal("GestorMarketingOPrecio");
			else
				getExecutionContext().getToken().signal("OtrosGestores");
		}
	}
	
	private void writeObject(java.io.ObjectOutputStream out) throws IOException {
		//empty
	}

	private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
		//empty
	}

}
