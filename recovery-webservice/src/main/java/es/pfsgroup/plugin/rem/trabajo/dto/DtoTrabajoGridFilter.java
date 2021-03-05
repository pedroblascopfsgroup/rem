package es.pfsgroup.plugin.rem.trabajo.dto;
import es.capgemini.devon.dto.WebDto;

public class DtoTrabajoGridFilter extends WebDto {

	private static final long serialVersionUID = 1L;
	private Long id;
	private Long idProveedor;
	private String tipoEntidad;
	private String numTrabajo;
	private String numActivoAgrupacion;
	private String tipoTrabajoCodigo;
	private String tipoTrabajoDescripcion;
	private String subtipoTrabajoCodigo;
	private String subtipoTrabajoDescripcion;
	private String estadoTrabajoCodigo;
	private String estadoTrabajoDescripcion;
	private String proveedor;
	private String solicitante;
	private String provinciaCodigo;
	private String provinciaDescripcion;
	private String localidadDescripcion;
	private String codPostal;
	private String fechaSolicitud;
	private String gestorActivo;
	private String numActivo;
	private String numAgrupacion;	
	private String fechaPeticionDesde;
	private String fechaPeticionHasta;
	private String carteraCodigo;	
	private Boolean esControlConsulta;
	private Boolean esGestorExterno;
	
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
	public String getTipoEntidad() {
		return tipoEntidad;
	}
	public void setTipoEntidad(String tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}
	public String getNumTrabajo() {
		return numTrabajo;
	}
	public void setNumTrabajo(String numTrabajo) {
		this.numTrabajo = numTrabajo;
	}
	public String getNumActivoAgrupacion() {
		return numActivoAgrupacion;
	}
	public void setNumActivoAgrupacion(String numActivoAgrupacion) {
		this.numActivoAgrupacion = numActivoAgrupacion;
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
	public String getLocalidadDescripcion() {
		return localidadDescripcion;
	}
	public void setLocalidadDescripcion(String localidadDescripcion) {
		this.localidadDescripcion = localidadDescripcion;
	}
	public String getCodPostal() {
		return codPostal;
	}
	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}
	public String getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(String fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public String getGestorActivo() {
		return gestorActivo;
	}
	public void setGestorActivo(String gestorActivo) {
		this.gestorActivo = gestorActivo;
	}
	public String getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}
	public String getNumAgrupacion() {
		return numAgrupacion;
	}
	public void setNumAgrupacion(String numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}
	public String getFechaPeticionDesde() {
		return fechaPeticionDesde;
	}
	public void setFechaPeticionDesde(String fechaPeticionDesde) {
		this.fechaPeticionDesde = fechaPeticionDesde;
	}
	public String getFechaPeticionHasta() {
		return fechaPeticionHasta;
	}
	public void setFechaPeticionHasta(String fechaPeticionHasta) {
		this.fechaPeticionHasta = fechaPeticionHasta;
	}
	public String getCarteraCodigo() {
		return carteraCodigo;
	}
	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}
	public Boolean getEsControlConsulta() {
		return esControlConsulta;
	}
	public void setEsControlConsulta(Boolean esControlConsulta) {
		this.esControlConsulta = esControlConsulta;
	}
	public Boolean getEsGestorExterno() {
		return esGestorExterno;
	}
	public void setEsGestorExterno(Boolean esGestorExterno) {
		this.esGestorExterno = esGestorExterno;
	}
}