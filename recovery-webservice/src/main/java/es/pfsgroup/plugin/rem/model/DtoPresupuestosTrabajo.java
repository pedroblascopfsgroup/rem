package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * DTO que gestiona los presupuestos presentados para un trabajo
 *  
 * @author Carlos Feliu
 *
 */
public class DtoPresupuestosTrabajo extends WebDto {

	private static final long serialVersionUID = 1L;
	
	private String id;

	private Long idTrabajo;
	
	private String tipoTrabajoDescripcion;
	
	private String subtipoTrabajoDescripcion;
	
	private Long idProveedor;
	
	private String proveedorDescripcion;
	
	private String estadoPresupuestoCodigo;
	
	private String estadoPresupuestoDescripcion;
	
	private Double importe;
	
	private Date fecha;
	
	private Boolean repartirProporcional;
	
	private String comentarios;
	
	private String refPresupuestoProveedor;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Long getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

	public String getTipoTrabajoDescripcion() {
		return tipoTrabajoDescripcion;
	}

	public void setTipoTrabajoDescripcion(String tipoTrabajoDescripcion) {
		this.tipoTrabajoDescripcion = tipoTrabajoDescripcion;
	}

	public String getSubtipoTrabajoDescripcion() {
		return subtipoTrabajoDescripcion;
	}

	public void setSubtipoTrabajoDescripcion(String subtipoTrabajoDescripcion) {
		this.subtipoTrabajoDescripcion = subtipoTrabajoDescripcion;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

	public String getProveedorDescripcion() {
		return proveedorDescripcion;
	}

	public void setProveedorDescripcion(String proveedorDescripcion) {
		this.proveedorDescripcion = proveedorDescripcion;
	}

	public String getEstadoPresupuestoCodigo() {
		return estadoPresupuestoCodigo;
	}

	public void setEstadoPresupuestoCodigo(String estadoPresupuestoCodigo) {
		this.estadoPresupuestoCodigo = estadoPresupuestoCodigo;
	}

	public String getEstadoPresupuestoDescripcion() {
		return estadoPresupuestoDescripcion;
	}

	public void setEstadoPresupuestoDescripcion(String estadoPresupuestoDescripcion) {
		this.estadoPresupuestoDescripcion = estadoPresupuestoDescripcion;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public Boolean getRepartirProporcional() {
		return repartirProporcional;
	}

	public void setRepartirProporcional(Boolean repartirProporcional) {
		this.repartirProporcional = repartirProporcional;
	}

	public String getComentarios() {
		return comentarios;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}

	public String getRefPresupuestoProveedor() {
		return refPresupuestoProveedor;
	}

	public void setRefPresupuestoProveedor(String refPresupuestoProveedor) {
		this.refPresupuestoProveedor = refPresupuestoProveedor;
	}
	
}
