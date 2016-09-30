package es.pfsgroup.plugin.rem.api.services.webcom;

import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.ActivoObrasNuevasDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.CabeceraObrasNuevasDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.InformeMediadorDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ProveedorDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.UsuarioDto;

public interface ServiciosWebcomApi {

	/**
	 * REM - WEBCOM: Contiene la información del resultado de los trabajos
	 * solicitados, bien la denegación o bien la aceptación y finalización de
	 * los mismos, todo ello generará un correo a dichos mediadores
	 * 
	 * @param estadoTrabajo
	 *            Lista de DTO's con los cambios de estado que queremos
	 *            notificar
	 * 
	 * @throws ErrorServicioWebcom
	 */
	public void webcomRestEstadoPeticionTrabajo(List<EstadoTrabajoDto> estadoTrabajo) throws ErrorServicioWebcom;

	/**
	 * REM - WEBCOM: Contiene la información del resultado de las ofertas
	 * presentadas desde los canales WEB, WEBCOM tendrá que actualizar dicha
	 * información para que las oficinas y mediadores sean conscientes del
	 * resultado de las mismas. REM actualiza siempre el estado de la oferta
	 * hacia Webcom.
	 * 
	 * @param estadoOferta
	 *            Lista de DTO's con los cambios de estado que queremos
	 *            notificar.
	 * @throws ErrorServicioWebcom
	 */
	public void webcomRestEstadoOferta(List<EstadoOfertaDto> estadoOferta) throws ErrorServicioWebcom;

	/**
	 * Este WS es únicamente de dirección REM - WEBCOM, contiene la información
	 * de TODO el stock de activos de REM, los activos vendidos tendrán su
	 * ultimo envío el día de la venta, este stock lo dará de alta WEBCOM en sus
	 * BBDD
	 * 
	 * @param stock
	 *            Stock de activos (alta/modificación)
	 */
	public void webcomRestStock(List<StockDto> stock) throws ErrorServicioWebcom;

	/**
	 * REM - WEBCOM: Contiene la información de las contestaciones del gestor
	 * correspondiente a las notificaciones realizadas por los mediadores
	 * 
	 * @param notificaciones
	 * @throws ErrorServicioWebcom
	 */
	public void webcomRestEstadoNotificacion(List<NotificacionDto> notificaciones) throws ErrorServicioWebcom;

	/**
	 * REM - WEBCOM: Contiene la información de los honorarios asociados a una
	 * oferta una vez se apruebe esta, también viaja las observaciones del
	 * gestor comercial a la NO aceptación de los mismos por el mediador
	 * 
	 * @param comisiones
	 * @throws ErrorServicioWebcom
	 */
	public void webcomRestVentasYcomisiones(List<ComisionesDto> comisiones) throws ErrorServicioWebcom;

	/**
	 * Este WS es únicamente de dirección REM - WEBCOM, contiene la información
	 * de TODOS los mediadores, oficinas, DZ, DT, Delegaciones y Direcciones
	 * tanto de Bankia como de Cajamar, es decir todas aquellas “instituciones”
	 * que pueden acceder o no a la herramienta de mediadores o de oficinas
	 * 
	 * @param proveedores
	 * @throws ErrorServicioWebcom
	 */
	public void webcomRestProveedores(List<ProveedorDto> proveedores) throws ErrorServicioWebcom;

	/**
	 * REM - WEBCOM: Contiene la información existente en REM para consolidarla
	 * en WEBCOM y así tener integridad de datos, WEBCOM tendrá que darla de
	 * alta en sus BBDD
	 * 
	 * @param informes
	 * @throws ErrorServicioWebcom
	 */
	public void webcomRestEstadoInformeMediador(List<InformeMediadorDto> informes) throws ErrorServicioWebcom;

	/**
	 * Este WS es únicamente de dirección REM - WEBCOM, contiene la información
	 * de las cabeceras (divisiones) de las distintas Obras para que WEBCOM
	 * pueda gestionar su publicación en los distintos portales
	 * 
	 * @param cabeceras
	 * @throws ErrorServicioWebcom
	 */
	public void webcomRestCabeceraObrasNuevas(List<CabeceraObrasNuevasDto> cabeceras) throws ErrorServicioWebcom;

	/**
	 * Este WS es únicamente de dirección REM - WEBCOM, contiene la relación
	 * entre los activos y las distintas obras nuevas o campañas (activos que
	 * las componen) para que WEBCOM pueda gestionar su publicación en los
	 * distintos portales
	 * 
	 * @param activos
	 * @throws ErrorServicioWebcom
	 */
	public void webcomRestActivosObrasNuevas(List<ActivoObrasNuevasDto> activos) throws ErrorServicioWebcom;

	/**
	 * Este WS es únicamente de dirección REM - WEBCOM, contiene la información
	 * de los usuarios asociados a los proveedores anteriores que pueden acceder
	 * o no a la herramienta de mediadores o de oficinas
	 * 
	 * @param usuarios
	 * @throws ErrorServicioWebcom
	 */
	public void webcomRestUsuarios(List<UsuarioDto> usuarios) throws ErrorServicioWebcom;;

}
