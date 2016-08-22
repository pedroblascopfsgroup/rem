package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * DTO para mostrar datos extendidos del presupuesto seleccionado en el grid de gestión económica del trabajo 
 *  
 * @author Carlos Feliu
 *
 */
public class DtoPresupuestoTrabajo extends WebDto {

	private static final long serialVersionUID = 1L;
	
	private String id;

	private Long idTrabajo;
	
	private String tipoTrabajoDescripcion;
	
	private String subtipoTrabajoDescripcion;
	
	private Long idProveedor;
	
	private String estadoPresupuestoCodigo;
	
	private String estadoPresupuestoDescripcion;
	
	private Double importe;
	
	private Date fecha;
	
	private String nombreProveedor;
	
	private String usuarioProveedor;
	
	private String emailProveedor;
	
	private String telefonoProveedor;
	
	private String cuentaContable;
	
	private String partidaPresupuestaria;
	
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

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
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

	public String getComentarios() {
		return comentarios;
	}

	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
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

	public String getNombreProveedor() {
		return nombreProveedor;
	}

	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}

	public String getUsuarioProveedor() {
		return usuarioProveedor;
	}

	public void setUsuarioProveedor(String usuarioProveedor) {
		this.usuarioProveedor = usuarioProveedor;
	}

	public String getEmailProveedor() {
		return emailProveedor;
	}

	public void setEmailProveedor(String emailProveedor) {
		this.emailProveedor = emailProveedor;
	}

	public String getTelefonoProveedor() {
		return telefonoProveedor;
	}

	public void setTelefonoProveedor(String telefonoProveedor) {
		this.telefonoProveedor = telefonoProveedor;
	}

	public String getCuentaContable() {
		return cuentaContable;
	}

	public void setCuentaContable(String cuentaContable) {
		this.cuentaContable = cuentaContable;
	}

	public String getPartidaPresupuestaria() {
		return partidaPresupuestaria;
	}

	public void setPartidaPresupuestaria(String partidaPresupuestaria) {
		this.partidaPresupuestaria = partidaPresupuestaria;
	}

	public String getRefPresupuestoProveedor() {
		return refPresupuestoProveedor;
	}

	public void setRefPresupuestoProveedor(String refPresupuestoProveedor) {
		this.refPresupuestoProveedor = refPresupuestoProveedor;
	}
	
}
