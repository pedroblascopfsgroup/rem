package es.pfsgroup.plugin.rem.model;
import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_GRID_BUSQUEDA_TRABAJOS", schema = "${entity.schema}")
public class VGridBusquedaTrabajos implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "TBJ_ID")
	private Long id;
	
	@Column(name= "PVE_ID")
	private Long idProveedor;

	@Column(name = "NUM_TRABAJO")
	private Long numTrabajo;
	
	@Column(name = "NUM_AGRUPACION")
	private Long numAgrupacion;	

	@Column(name = "NUM_ACTIVO_AGRUPACION")
	private String numActivoAgrupacion;

	@Column(name = "TIPO_ENTIDAD")
	private String tipoEntidad;

	@Column(name = "TIPO_TRABAJO_CODIGO")
	private String tipoTrabajoCodigo;

	@Column(name = "TIPO_TRABAJO_DESCRIPCION")
	private String tipoTrabajoDescripcion;

	@Column(name = "SUBTIPO_TRABAJO_CODIGO")
	private String subtipoTrabajoCodigo;

	@Column(name = "SUBTIPO_TRABAJO_DESCRIPCION")
	private String subtipoTrabajoDescripcion;

	@Column(name = "ESTADO_TRABAJO_CODIGO")
	private String estadoTrabajoCodigo;

	@Column(name = "ESTADO_TRABAJO_DESCRIPCION")
	private String estadoTrabajoDescripcion;

	@Column(name = "PROVEEDOR_NOMBRE")
	private String proveedor;

	@Column(name = "SOLICITANTE_NOMBRE")
	private String solicitante;

	@Column(name = "FECHA_SOLICITUD")
	private Date fechaSolicitud;

	@Column(name = "LOCALIDAD_DESCRIPCION")
	private String localidadDescripcion;

	@Column(name = "PROVINCIA_CODIGO")
	private String provinciaCodigo;

	@Column(name = "PROVINCIA_DESCRIPCION")
	private String provinciaDescripcion;

	@Column(name = "COD_POSTAL")
	private String codPostal;
	
	@Column(name = "DD_IRE_DESCRIPCION")
	private String areaPeticionaria;
	
	@Column(name = "TBJ_RESPONSABLE_TRABAJO")
	private String responsableTrabajo;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

	public Long getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public Long getNumAgrupacion() {
		return numAgrupacion;
	}

	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}

	public String getNumActivoAgrupacion() {
		return numActivoAgrupacion;
	}

	public void setNumActivoAgrupacion(String numActivoAgrupacion) {
		this.numActivoAgrupacion = numActivoAgrupacion;
	}

	public String getTipoEntidad() {
		return tipoEntidad;
	}

	public void setTipoEntidad(String tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}

	public String getTipoTrabajoCodigo() {
		return tipoTrabajoCodigo;
	}

	public void setTipoTrabajoCodigo(String tipoTrabajoCodigo) {
		this.tipoTrabajoCodigo = tipoTrabajoCodigo;
	}

	public String getTipoTrabajoDescripcion() {
		return tipoTrabajoDescripcion;
	}

	public void setTipoTrabajoDescripcion(String tipoTrabajoDescripcion) {
		this.tipoTrabajoDescripcion = tipoTrabajoDescripcion;
	}

	public String getSubtipoTrabajoCodigo() {
		return subtipoTrabajoCodigo;
	}

	public void setSubtipoTrabajoCodigo(String subtipoTrabajoCodigo) {
		this.subtipoTrabajoCodigo = subtipoTrabajoCodigo;
	}

	public String getSubtipoTrabajoDescripcion() {
		return subtipoTrabajoDescripcion;
	}

	public void setSubtipoTrabajoDescripcion(String subtipoTrabajoDescripcion) {
		this.subtipoTrabajoDescripcion = subtipoTrabajoDescripcion;
	}

	public String getEstadoTrabajoCodigo() {
		return estadoTrabajoCodigo;
	}

	public void setEstadoTrabajoCodigo(String estadoTrabajoCodigo) {
		this.estadoTrabajoCodigo = estadoTrabajoCodigo;
	}

	public String getEstadoTrabajoDescripcion() {
		return estadoTrabajoDescripcion;
	}

	public void setEstadoTrabajoDescripcion(String estadoTrabajoDescripcion) {
		this.estadoTrabajoDescripcion = estadoTrabajoDescripcion;
	}

	public String getProveedor() {
		return proveedor;
	}

	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}

	public String getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public String getLocalidadDescripcion() {
		return localidadDescripcion;
	}

	public void setLocalidadDescripcion(String localidadDescripcion) {
		this.localidadDescripcion = localidadDescripcion;
	}

	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}

	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}

	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}

	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public String getAreaPeticionaria() {
		return areaPeticionaria;
	}

	public void setAreaPeticionaria(String areaPeticionaria) {
		this.areaPeticionaria = areaPeticionaria;
	}

	public String getResponsableTrabajo() {
		return responsableTrabajo;
	}

	public void setResponsableTrabajo(String responsableTrabajo) {
		this.responsableTrabajo = responsableTrabajo;
	}

}

