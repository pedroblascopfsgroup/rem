package es.pfsgroup.plugin.rem.restclient.webcom;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.plugin.rem.api.services.webcom.ErrorServicioWebcom;
import es.pfsgroup.plugin.rem.api.services.webcom.ServiciosWebcomApi;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.ComisionesDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoOfertaDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.EstadoTrabajoDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.NotificacionDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.StockDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;

@Controller
public class WebcomController {

	@Autowired
	private ServiciosWebcomApi servicios;

	/**
	 * Ejemplo de URL para probar
	 * 
	 * <pre>
	 * pfs/webcom/notificaciones.htm?idUsuarioRemAccion=1&idNotificacionWebcom=2&idNotificacionRem=3&idActivoHaya=4&descripcion=test
	 * </pre>
	 * 
	 * @param idUsuarioRemAccion
	 * @param descripcion
	 * @param idActivoHaya
	 * @param idNotificacionRem
	 * @param idNotificacionWebcom
	 * @return
	 * @throws ErrorServicioWebcom 
	 */
	@RequestMapping
	public String notificaciones(Long idUsuarioRemAccion, String descripcion, Long idActivoHaya, Long idNotificacionRem,
			Long idNotificacionWebcom) throws ErrorServicioWebcom {
		NotificacionDto dto = new NotificacionDto();

		dto.setIdUsuarioRemAccion(LongDataType.longDataType(idUsuarioRemAccion));
		dto.setFechaAccion(DateDataType.dateDataType(new Date()));
		dto.setDescripcion(StringDataType.stringDataType(descripcion));
		dto.setIdActivoHaya(LongDataType.longDataType(idActivoHaya));
		dto.setIdNotificacionRem(LongDataType.longDataType(idNotificacionRem));
		dto.setIdNotificacionWebcom(LongDataType.longDataType(idNotificacionWebcom));

		servicios.estadoNotificacion(Arrays.asList(new NotificacionDto[] { dto }));

		return "default";
	}

	/**
	 * Ejemplo de URL par probar
	 * 
	 * <pre>
	 * pfs/webcom/comisiones.htm?idUsuarioRemAccion=1&idOfertaRem=2&idOfertaWebcom=3&idProveedorRem=4&esPrescripcion=true&esColaboracion=false&esResponsable=false&esFdv=false&esDoblePrescripcion=false&observaciones=test&importe=5&porcentaje=6
	 * </pre>
	 * 
	 * @param idUsuarioRemAccion
	 * @param esColaboracion
	 * @param esDoblePrescripcion
	 * @param esFdv
	 * @param esPrescripcion
	 * @param esResponsable
	 * @param idOfertaRem
	 * @param idOfertaWebcom
	 * @param idProveedorRem
	 * @param importe
	 * @param observaciones
	 * @param porcentaje
	 * @return
	 * @throws ErrorServicioWebcom 
	 */
	@RequestMapping
	public String comisiones(Long idUsuarioRemAccion, Boolean esColaboracion, Boolean esDoblePrescripcion,
			Boolean esFdv, Boolean esPrescripcion, Boolean esResponsable, Long idOfertaRem, Long idOfertaWebcom,
			Long idProveedorRem, Double importe, String observaciones, Double porcentaje) throws ErrorServicioWebcom {
		ComisionesDto dto = new ComisionesDto();
		dto.setIdUsuarioRemAccion(LongDataType.longDataType(idUsuarioRemAccion));
		dto.setFechaAccion(DateDataType.dateDataType(new Date()));
		dto.setEsColaboracion(BooleanDataType.booleanDataType(esColaboracion));
		dto.setEsDoblePrescripcion(BooleanDataType.booleanDataType(esDoblePrescripcion));
		dto.setEsFdv(BooleanDataType.booleanDataType(esFdv));
		dto.setEsPrescripcion(BooleanDataType.booleanDataType(esPrescripcion));
		dto.setEsResponsable(BooleanDataType.booleanDataType(esResponsable));
		dto.setIdOfertaRem(LongDataType.longDataType(idOfertaRem));
		dto.setIdOfertaWebcom(LongDataType.longDataType(idOfertaWebcom));
		dto.setIdProveedorRem(LongDataType.longDataType(idProveedorRem));
		dto.setImporte(DoubleDataType.doubleDataType(importe));
		dto.setObservaciones(StringDataType.stringDataType(observaciones));
		dto.setPorcentaje(DoubleDataType.doubleDataType(porcentaje));

		servicios.ventasYcomisiones(Arrays.asList(new ComisionesDto[] { dto }));
		return "default";
	}

	/**
	 * Ejemplo para probar
	 * 
	 * <pre>
	 * pfs/webcom/stock.htm?idUsuarioRemAccion=1&idActivoHaya=2&codTipoVia=3&nombreCalle=Rue%20del%20percebe&numeroCalle=4&escalera=5&planta=6&puerta=7
	 * </pre>
	 * 
	 * @param idActivoHaya
	 * @param codTipoVia
	 * @param nombreCalle
	 * @param numeroCalle
	 * @param escalera
	 * @param planta
	 * @param puerta
	 * @param idUsuarioRemAccion
	 * @return
	 * @throws ErrorServicioWebcom 
	 */
	@RequestMapping
	public String stock(Long idActivoHaya, String codTipoVia, String nombreCalle, String numeroCalle, String escalera,
			String planta, String puerta, Long idUsuarioRemAccion) throws ErrorServicioWebcom {

		StockDto dto = new StockDto();
		dto.setFechaAccion(DateDataType.dateDataType(new Date()));
		dto.setIdUsuarioRemAccion(LongDataType.longDataType(idUsuarioRemAccion));
		dto.setIdActivoHaya(LongDataType.longDataType(idActivoHaya));
		dto.setCodTipoVia(StringDataType.stringDataType(codTipoVia));
		dto.setNombreCalle(StringDataType.stringDataType(nombreCalle));
		dto.setNumeroCalle(StringDataType.stringDataType(numeroCalle));
		dto.setEscalera(StringDataType.stringDataType(escalera));
		dto.setPlanta(StringDataType.stringDataType(planta));
		dto.setPuerta(StringDataType.stringDataType(puerta));

		servicios.enviarStock(Arrays.asList(new StockDto[] { dto }));

		return "default";

	}

	/**
	 * Ejemplo para probar
	 * 
	 * <pre>
	 * pfs/webcom/ofertas.htm?idUsuarioRemAccion=1&idOfertaWebcom=2&idOfertaRem=3&idActivoHaya=4&codEstadoOferta=A&codEstadoExpediente=B&vendido=true
	 * </pre>
	 * 
	 * @param idUsuarioRemAccion
	 * @param idOfertaWebcom
	 * @param idOfertaRem
	 * @param idActivoHaya
	 * @param codEstadoOferta
	 * @param codEstadoExpediente
	 * @param vendido
	 * @return
	 * @throws ErrorServicioWebcom 
	 */
	@RequestMapping
	public String ofertas(Long idUsuarioRemAccion, Long idOfertaWebcom, Long idOfertaRem, Long idActivoHaya,
			String codEstadoOferta, String codEstadoExpediente, Boolean vendido) throws ErrorServicioWebcom {
		EstadoOfertaDto dto = new EstadoOfertaDto();
		dto.setFechaAccion(DateDataType.dateDataType(new Date()));
		dto.setIdUsuarioRemAccion(LongDataType.longDataType(idUsuarioRemAccion));
		dto.setIdOfertaWebcom(LongDataType.longDataType(idOfertaWebcom));
		dto.setIdOfertaRem(LongDataType.longDataType(idOfertaRem));
		dto.setIdActivoHaya(LongDataType.longDataType(idActivoHaya));
		dto.setCodEstadoOferta(StringDataType.stringDataType(codEstadoOferta));
		dto.setCodEstadoExpediente(StringDataType.stringDataType(codEstadoExpediente));
		dto.setVendido(BooleanDataType.booleanDataType(vendido));

		servicios.enviaActualizacionEstadoOferta(Arrays.asList(new EstadoOfertaDto[] { dto }));

		return "default";
	}

	/**
	 * Ejemplo para probar
	 * 
	 * <pre>
	 * pfs/webcom/trabajos.htm?idUsuarioRemAccion=1&idTrabajoWebcom=2&idTrabajoRem=3&codEstadoTrabajo=4&motivoRechazo=no%20%20lo%20quiero%20hacerrr
	 * </pre>
	 * 
	 * @param idUsuarioRemAccion
	 * @param idTrabajoWebcom
	 * @param idTrabajoRem
	 * @param codEstadoTrabajo
	 * @param motivoRechazo
	 * @return
	 * @throws ErrorServicioWebcom 
	 */
	@RequestMapping
	public String trabajos(Long idUsuarioRemAccion, Long idTrabajoWebcom, Long idTrabajoRem, String codEstadoTrabajo,
			String motivoRechazo) throws ErrorServicioWebcom {
		EstadoTrabajoDto dto = new EstadoTrabajoDto();
		dto.setFechaAccion(DateDataType.dateDataType(new Date()));
		dto.setIdUsuarioRemAccion(LongDataType.longDataType(idUsuarioRemAccion));
		dto.setIdTrabajoWebcom(LongDataType.longDataType(idTrabajoWebcom));
		dto.setIdTrabajoRem(LongDataType.longDataType(idTrabajoRem));
		dto.setCodEstadoTrabajo(StringDataType.stringDataType(codEstadoTrabajo));
		dto.setMotivoRechazo(StringDataType.stringDataType(motivoRechazo));

		servicios.enviaActualizacionEstadoTrabajo(Arrays.asList(new EstadoTrabajoDto[] { dto }));

		return "default";
	}
}
