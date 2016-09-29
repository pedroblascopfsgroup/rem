package es.pfsgroup.plugin.rem.api.services.webcom;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ProveedorDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.restclient.webcom.clients.exception.ErrorServicioWebcom;

public interface ServiciosWebcomApi {

	/**
	 * Envia a WEBCOM una actualización del estado del Trabajo
	 * 
	 * @param estadoTrabajo
	 *            Lista de DTO's con los cambios de estado que queremos
	 *            notificar
	 * 
	 * @throws ErrorServicioWebcom
	 */
	public void enviaActualizacionEstadoTrabajo(List<EstadoTrabajoDto> estadoTrabajo) throws ErrorServicioWebcom;

	/**
	 * Envia a WEBCOM una actualización del estado de una Oferta.
	 * 
	 * @param estadoOferta
	 *            Lista de DTO's con los cambios de estado que queremos
	 *            notificar.
	 * @throws ErrorServicioWebcom
	 */
	public void enviaActualizacionEstadoOferta(List<EstadoOfertaDto> estadoOferta) throws ErrorServicioWebcom;

	/**
	 * Envia a WEBCOM una actualización del stock de activos
	 * 
	 * @param stock
	 *            Stock de activos (alta/modificación)
	 */
	public void enviarStock(List<StockDto> stock) throws ErrorServicioWebcom;

	/**
	 * Honorarios asociados a una oferta una vez se apruebe ésta, también viaja
	 * las observaciones del gestor comercial a la NO aceptación de los mismos
	 * por el mediador.
	 * 
	 * @param notificaciones
	 * @throws ErrorServicioWebcom
	 */
	public void estadoNotificacion(List<NotificacionDto> notificaciones) throws ErrorServicioWebcom;

	/**
	 * Honorarios asociados a una oferta una vez se apruebe ésta, también viaja
	 * las observaciones del gestor comercial a la NO aceptación de los mismos
	 * por el mediador.
	 * 
	 * @param comisiones
	 * @throws ErrorServicioWebcom
	 */
	public void ventasYcomisiones(List<ComisionesDto> comisiones) throws ErrorServicioWebcom;

	/**
	 * Este WS es únicamente de dirección REM - WEBCOM, contiene la información
	 * de TODOS los mediadores, oficinas, DZ, DT, Delegaciones y Direcciones
	 * tanto de Bankia como de Cajamar, es decir todas aquellas “instituciones”
	 * que pueden acceder o no a la herramienta de mediadores o de oficinas
	 * 
	 * @param proveedores
	 * @throws ErrorServicioWebcom
	 */
	public void enviaProveedores(List<ProveedorDto> proveedores) throws ErrorServicioWebcom;

}
