package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Proveedores.
 * 
 * @author Daniel Gutiérrez
 */
public class DtoProveedorFilter extends WebDto {
	private static final long serialVersionUID = 0L;

	private String id;
	private String codigo;
	private String tipoProveedorDescripcion;
	private String tipoProveedorCodigo;
	private String subtipoProveedorDescripcion;
	private String subtipoProveedorCodigo;
	private String nifProveedor;
	private String nombreProveedor;
	private String nifPersonaContacto;
	private String nombrePersonaContacto;
	private String nombreComercialProveedor;
	private String estadoProveedorDescripcion;
	private String estadoProveedorCodigo;
	private String observaciones;
	private String fechaAlta;
	private String fechaBaja;
	private String tipoPersonaCodigo;
	private String cartera;
	private String ambitoProveedor;
	private String provinciaCodigo;
	private String municipioCodigo;
	private Integer codigoPostal;
	private String contactoNIFProveedor;
	private String contactoNombreProveedor;
	private Integer homologadoCodigo;
	private String calificacionCodigo;
	private Integer topCodigo;
	private String propietario;
	private String nombrePersContacto;
	private int totalCount;
	private String nombre;
	private String especialidadCodigo;
	private String lineaNegocioCodigo;
	
	
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getTipoProveedorDescripcion() {
		return tipoProveedorDescripcion;
	}
	public void setTipoProveedorDescripcion(String tipoProveedorDescripcion) {
		this.tipoProveedorDescripcion = tipoProveedorDescripcion;
	}
	public String getTipoProveedorCodigo() {
		return tipoProveedorCodigo;
	}
	public void setTipoProveedorCodigo(String tipoProveedorCodigo) {
		this.tipoProveedorCodigo = tipoProveedorCodigo;
	}
	public String getSubtipoProveedorDescripcion() {
		return subtipoProveedorDescripcion;
	}
	public void setSubtipoProveedorDescripcion(String subtipoProveedorDescripcion) {
		this.subtipoProveedorDescripcion = subtipoProveedorDescripcion;
	}
	public String getSubtipoProveedorCodigo() {
		return subtipoProveedorCodigo;
	}
	public void setSubtipoProveedorCodigo(String subtipoProveedorCodigo) {
		this.subtipoProveedorCodigo = subtipoProveedorCodigo;
	}
	public String getNifPersonaContacto() {
		return nifPersonaContacto;
	}
	public void setNifPersonaContacto(String nifPersonaContacto) {
		this.nifPersonaContacto = nifPersonaContacto;
	}
	public String getNombrePersonaContacto() {
		return nombrePersonaContacto;
	}
	public void setNombrePersonaContacto(String nombrePersonaContacto) {
		this.nombrePersonaContacto = nombrePersonaContacto;
	}
	public String getNombreComercialProveedor() {
		return nombreComercialProveedor;
	}
	public void setNombreComercialProveedor(String nombreComercialProveedor) {
		this.nombreComercialProveedor = nombreComercialProveedor;
	}
	public String getEstadoProveedorDescripcion() {
		return estadoProveedorDescripcion;
	}
	public void setEstadoProveedorDescripcion(String estadoProveedorDescripcion) {
		this.estadoProveedorDescripcion = estadoProveedorDescripcion;
	}
	public String getEstadoProveedorCodigo() {
		return estadoProveedorCodigo;
	}
	public void setEstadoProveedorCodigo(String estadoProveedorCodigo) {
		this.estadoProveedorCodigo = estadoProveedorCodigo;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(String fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public String getTipoPersonaCodigo() {
		return tipoPersonaCodigo;
	}
	public void setTipoPersonaCodigo(String tipoPersonaCodigo) {
		this.tipoPersonaCodigo = tipoPersonaCodigo;
	}
	public String getCartera() {
		return cartera;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	public String getAmbitoProveedor() {
		return ambitoProveedor;
	}
	public void setAmbitoProveedor(String ambitoProveedor) {
		this.ambitoProveedor = ambitoProveedor;
	}
	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}
	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}
	public String getMunicipioCodigo() {
		return municipioCodigo;
	}
	public void setMunicipioCodigo(String municipioCodigo) {
		this.municipioCodigo = municipioCodigo;
	}
	public Integer getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(Integer codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getContactoNIFProveedor() {
		return contactoNIFProveedor;
	}
	public void setContactoNIFProveedor(String contactoNIFProveedor) {
		this.contactoNIFProveedor = contactoNIFProveedor;
	}
	public String getContactoNombreProveedor() {
		return contactoNombreProveedor;
	}
	public void setContactoNombreProveedor(String contactoNombreProveedor) {
		this.contactoNombreProveedor = contactoNombreProveedor;
	}
	public Integer getHomologadoProveedor() {
		return homologadoCodigo;
	}
	public void setHomologadoCodigo(Integer homologadoCodigo) {
		this.homologadoCodigo = homologadoCodigo;
	}
	public String getCalificacionCodigo() {
		return calificacionCodigo;
	}
	public void setCalificacionCodigo(String calificacionCodigo) {
		this.calificacionCodigo = calificacionCodigo;
	}
	public Integer getTopCodigo() {
		return topCodigo;
	}
	public void setTopCodigo(Integer topCodigo) {
		this.topCodigo = topCodigo;
	}
	public String getPropietario() {
		return propietario;
	}
	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}
	public String getNombrePersContacto() {
		return nombrePersContacto;
	}
	public void setNombrePersContacto(String nombrePersContacto) {
		this.nombrePersContacto = nombrePersContacto;
	}
	public Integer getHomologadoCodigo() {
		return homologadoCodigo;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public String getNifProveedor() {
		return nifProveedor;
	}
	public void setNifProveedor(String nifProveedor) {
		this.nifProveedor = nifProveedor;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getEspecialidadCodigo() {
		return especialidadCodigo;
	}
	public void setEspecialidadCodigo(String especialidadCodigo) {
		this.especialidadCodigo = especialidadCodigo;
	}
	public String getLineaNegocioCodigo() {
		return lineaNegocioCodigo;
	}
	public void setLineaNegocioCodigo(String lineaNegocioCodigo) {
		this.lineaNegocioCodigo = lineaNegocioCodigo;
	}
	
}