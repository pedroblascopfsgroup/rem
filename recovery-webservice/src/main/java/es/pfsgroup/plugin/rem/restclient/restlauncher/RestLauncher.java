package es.pfsgroup.plugin.rem.restclient.restlauncher;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import es.pfsgroup.plugin.rem.restclient.schedule.DeteccionCambiosBDTask;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomActivosObrasNuevas;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomCabecerasObrasNuevas;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomEstadoInformeMediador;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomEstadoNotificacion;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomProveedores;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomStock;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomUsuarios;

@Service
@ManagedResource("webcom:type=RestLauncher")
public class RestLauncher {
	
	@Autowired
	private DetectorWebcomActivosObrasNuevas cambiosActivosObrasNuevas;
	
	@Autowired
	private DetectorWebcomCabecerasObrasNuevas cambiosCabecerasObrasNuevas;
	
	@Autowired
	private DetectorWebcomEstadoInformeMediador cambiosInformemediador;
	
	@Autowired
	private DetectorWebcomEstadoNotificacion cambiosEstadoNotificacion;
	
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
	
	@ManagedOperation(description = "Envia la lista de Activos de obra nueva")
	public void enviarActivosObrasNuevas() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosActivosObrasNuevas);
		
	}
	
	@ManagedOperation(description = "Envia la lista de cabeceras de obras nuevas")
	public void enviarCabecerasObrasNuevas() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosCabecerasObrasNuevas);
		
	}
	
	@ManagedOperation(description = "Envia la lista de cambios informe mediador")
	public void enviarEstadosInformeMediador() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosInformemediador);
		
	}
	@ManagedOperation(description = "Envia la lista de cambios estado notificacion")
	public void enviarEstadoNotificacion() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosEstadoNotificacion);
		
	}

}
