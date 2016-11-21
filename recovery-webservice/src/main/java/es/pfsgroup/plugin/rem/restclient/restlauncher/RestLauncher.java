package es.pfsgroup.plugin.rem.restclient.restlauncher;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.restclient.schedule.DeteccionCambiosBDTask;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomActivosObrasNuevas;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomCabecerasObrasNuevas;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomEstadoInformeMediador;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomEstadoNotificacion;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomEstadoPeticionTrabajo;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomObrasNuevasCampanyas;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomProveedores;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomStock;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomUsuarios;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.DetectorWebcomVentasYcomisiones;

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
	private DetectorWebcomEstadoOferta cambiosEstadoOferta;
	
	@Autowired
	private DetectorWebcomEstadoPeticionTrabajo cambiosPeticionTrabajo;
	
	@Autowired
	private DetectorWebcomObrasNuevasCampanyas cambiosObrasNuevasCampanyas;
	
	@Autowired
	private DetectorWebcomVentasYcomisiones cambiosVentasYcomisiones;
	
	@Autowired
	private DeteccionCambiosBDTask task;
	
	/**
	 * ACTUALIZA VISTA MATERIALIZADA
	 * @throws ErrorServicioWebcom
	 */	
	@ManagedOperation(description = "Actualiza vista materializada")
	public void actualizarVistasMaterializadas() throws ErrorServicioWebcom {
		task.actualizaVistasMaterializadas();
	}

	/**
	 * ENVIA TODOS LOS CAMBIOS A WEBCOM
	 * @throws ErrorServicioWebcom
	 */
	@ManagedOperation(description = "Envia todos los cambios a Webcom")
	public void enviarCambios() throws ErrorServicioWebcom {
		task.detectaCambios();		
	}
	
	/*
	 * 
	 * 
	 *	STOCK 
	 * 
	 */
	
	
	@ManagedOperation(description = "Envia el stock de Activos completos a Webcom")
	public void enviarCompletoStockWebcom() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosStock);
		
	}
	
	@ManagedOperation(description = "Envia el stock de Activos  a Webcom")
	public void enviarStockWebcom() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosStock);
		
	}
	
	/*
	 * 
	 * 
	 *	USUARIOS
	 * 
	 */
	
	@ManagedOperation(description = "Envia la lista completa de Usuarios a Webcom")
	public void enviarCompletoUsuariosWebcom() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosUsuarios);		
	}
	
	@ManagedOperation(description = "Envia la lista de Usuarios a Webcom")
	public void enviarUsuariosWebcom() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosUsuarios);		
	}
	
	/*
	 * 
	 * 
	 *	PROVEEDORES 
	 * 
	 */
	
	@ManagedOperation(description = "Envia la lista completa de Proveedores a Webcom")
	public void enviarCompletoProveedoresWebcom() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosProveedores);
		
	}
	
    @ManagedOperation(description = "Envia la lista de Proveedores a Webcom")
	public void enviarProveedoresWebcom() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosProveedores);
		
	}
    
    /*
	 * 
	 * 
	 *	OBRAS NUEVAS 
	 * 
	 */
	
    @ManagedOperation(description = "Envia la lista completa de Activos de obra nueva")
	public void enviarCompletoActivosObrasNuevas() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosActivosObrasNuevas);
		
	}
    
	@ManagedOperation(description = "Envia la lista de Activos de obra nueva")
	public void enviarActivosObrasNuevas() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosActivosObrasNuevas);
		
	}
	
	/*
	 * 
	 * 
	 *	CABECERAS 
	 * 
	 */
	
	@ManagedOperation(description = "Envia la lista completa de cabeceras de obras nuevas")
	public void enviarCompletoCabecerasObrasNuevas() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosCabecerasObrasNuevas);
		
	}
	
	@ManagedOperation(description = "Envia la lista de cabeceras de obras nuevas")
	public void enviarCabecerasObrasNuevas() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosCabecerasObrasNuevas);
		
	}
	
	/*
	 * 
	 * 
	 *	INFORME MEDIADOR 
	 * 
	 */
	
	@ManagedOperation(description = "Envia la lista completa de cambios informe mediador")
	public void enviarCompletoEstadosInformeMediador() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosInformemediador);
		
	}
	
	@ManagedOperation(description = "Envia la lista de cambios informe mediador")
	public void enviarEstadosInformeMediador() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosInformemediador);
		
	}
	
	
	/*
	 * 
	 * 
	 *	NOTIFICACIONES 
	 * 
	 */
	
	@ManagedOperation(description = "Envia la lista completa de cambios estado notificacion")
	public void enviarCompletoEstadoNotificacion() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosEstadoNotificacion);
		
	}
	
	@ManagedOperation(description = "Envia la lista de cambios estado notificacion")
	public void enviarEstadoNotificacion() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosEstadoNotificacion);
		
	}
	
	/*
	 * 
	 * 
	 *	ESTADO OFERTA 
	 * 
	 */
	
	@ManagedOperation(description = "Envia la lista completa de cambios estado oferta")
	public void enviarCompletoEstadoOferta() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosEstadoOferta);
		
	}
	
	@ManagedOperation(description = "Envia la lista de cambios estado oferta")
	public void enviarEstadoOferta() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosEstadoOferta);
		
	}
	
	/*
	 * 
	 * 
	 *	PETICION TRABAJO 
	 * 
	 */
	
	@ManagedOperation(description = "Envia la lista completa de cambios  peticion trabajo")
	public void enviarCompletoPeticionTrabajo() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosPeticionTrabajo);
		
	}
	
	@ManagedOperation(description = "Envia la lista de cambios peticion trabajo")
	public void enviarPeticionTrabajo() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosPeticionTrabajo);
		
	}
	
	/*
	 * 
	 * 
	 *	OBRAS NUEVAS CAMPANYAS 
	 * 
	 */
	
	@ManagedOperation(description = "Envia la lista completa de nuevas campanyas")
	public void enviarCompletoObrasNuevasCampanyas() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosObrasNuevasCampanyas);
		
	}
	
	@ManagedOperation(description = "Envia la lista de nuevas campanyas")
	public void enviarObrasNuevasCampanyas() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosObrasNuevasCampanyas);
		
	}
	
	/*
	 * 
	 * 
	 * VENTAS Y COMISIONES 
	 * 
	 */
	
	@ManagedOperation(description = "Envia la lista completa de ventas y comisiones")
	public void enviarCompletoVentasYcomisiones() throws ErrorServicioWebcom {
		task.enviaInformacionCompleta(cambiosVentasYcomisiones);
		
	}
	
	@ManagedOperation(description = "Envia la lista de ventas y comisiones")
	public void enviarVentasYcomisiones() throws ErrorServicioWebcom {
		task.detectaCambios(cambiosVentasYcomisiones);
		
	}

}
