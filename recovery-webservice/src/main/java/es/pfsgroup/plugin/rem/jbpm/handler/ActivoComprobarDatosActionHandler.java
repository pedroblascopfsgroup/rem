package es.pfsgroup.plugin.rem.jbpm.handler;

import java.io.IOException;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.plugin.rem.api.GestorActivoApi;

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

		
		getExecutionContext().getToken().signal("DatosIguales");


	}
	
	private void writeObject(java.io.ObjectOutputStream out) throws IOException {
		//empty
	}

	private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
		//empty
	}

}
