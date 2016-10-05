package es.pfsgroup.plugin.rem.restclient.restlauncher;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.schedule.DeteccionCambiosBDTask;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomProveedores;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomStock;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomUsuarios;

@Service
@ManagedResource("webcom:type=RestLauncher")
public class RestLauncher {
	
	@Autowired
	private DetectorWebcomStock cambiosStock;
	
	@Autowired
	private DetectorWebcomUsuarios cambiosUsuarios;
	
	@Autowired
	private DetectorWebcomProveedores cambiosProveedores;
	
	@Autowired
	private DeteccionCambiosBDTask task;

	@ManagedOperation(description = "Envia el stock de Activos completos a Webcom")
	public void enviarStockWebcom() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosStock);
		
	}
	
	@ManagedOperation(description = "Envia la lista de Usuarios a Webcom")
	public void enviarUsuariosWebcom() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosUsuarios);
		
	}
	
	@ManagedOperation(description = "Envia la lista de Proveedores a Webcom")
	public void enviarProveedoresWebcom() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosProveedores);
		
	}

}
