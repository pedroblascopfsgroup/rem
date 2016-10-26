package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para la ficha de datos de Proveedores.
 */
public class DtoActivoProveedor extends WebDto {
	private static final long serialVersionUID = 0L;

	// Datos generales.
	private Date fechaUltimaActualizacion;
	private Long id;
	private String codigo;
	private String nombreProveedor;
	private Date fechaAltaProveedor;
	private String tipoProveedorCodigo;
	private String nombreComercialProveedor;
	private Date fechaBajaProveedor;
	private String subtipoProveedorCodigo;
	private String nifProveedor;
	private String localizadaProveedorCodigo;
	private String estadoProveedorCodigo;
	private String tipoPersonaProveedorCodigo;
	private String observacionesProveedor;
	private String webUrlProveedor;
	private Date fechaConstitucionProveedor;
	private String operativaCodigo;
	
	
	// Ambito.
	private String territorialCodigo;
	private String carteraCodigo;
	private String subcarteraCodigo;
	
	// Mediador.
	private String custodioCodigo;
	private String tipoActivosCarteraCodigo;
	private String calificacionCodigo;
	private String incluidoTopCodigo;
	private String homologadoCodigo;
	
	//Datos economicos.
	private String numCuentaIBAN;
	private String titularCuenta;
	private String retencionPagoCodigo;
	private Date fechaRetencion;
	private String motivoRetencionCodigo;
	
	// Control PBC.
	private Date fechaProceso;
	private String resultadoBlanqueoCodigo;
	
	private String direccion;
	
	private String telefono;
	
	private String provincia;
	
	private String email;
	
	private String subtipoProveedorDescripcion;
	
	
	
	
	
	public Date getFechaUltimaActualizacion() {
		return fechaUltimaActualizacion;
	}
	public void setFechaUltimaActualizacion(Date fechaUltimaActualizacion) {
		this.fechaUltimaActualizacion = fechaUltimaActualizacion;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public Date getFechaAltaProveedor() {
		return fechaAltaProveedor;
	}
	public void setFechaAltaProveedor(Date fechaAltaProveedor) {
		this.fechaAltaProveedor = fechaAltaProveedor;
	}
	public String getTipoProveedorCodigo() {
		return tipoProveedorCodigo;
	}
	public void setTipoProveedorCodigo(String tipoProveedorCodigo) {
		this.tipoProveedorCodigo = tipoProveedorCodigo;
	}
	public String getNombreComercialProveedor() {
		return nombreComercialProveedor;
	}
	public void setNombreComercialProveedor(String nombreComercialProveedor) {
		this.nombreComercialProveedor = nombreComercialProveedor;
	}
	public Date getFechaBajaProveedor() {
		return fechaBajaProveedor;
	}
	public void setFechaBajaProveedor(Date fechaBajaProveedor) {
		this.fechaBajaProveedor = fechaBajaProveedor;
	}
	public String getSubtipoProveedorCodigo() {
		return subtipoProveedorCodigo;
	}
	public void setSubtipoProveedorCodigo(String subtipoProveedorCodigo) {
		this.subtipoProveedorCodigo = subtipoProveedorCodigo;
	}
	public String getNifProveedor() {
		return nifProveedor;
	}
	public void setNifProveedor(String nifProveedor) {
		this.nifProveedor = nifProveedor;
	}
	public String getLocalizadaProveedorCodigo() {
		return localizadaProveedorCodigo;
	}
	public void setLocalizadaProveedorCodigo(String localizadaProveedorCodigo) {
		this.localizadaProveedorCodigo = localizadaProveedorCodigo;
	}
	public String getEstadoProveedorCodigo() {
		return estadoProveedorCodigo;
	}
	public void setEstadoProveedorCodigo(String estadoProveedorCodigo) {
		this.estadoProveedorCodigo = estadoProveedorCodigo;
	}
	public String getTipoPersonaProveedorCodigo() {
		return tipoPersonaProveedorCodigo;
	}
	public void setTipoPersonaProveedorCodigo(String tipoPersonaProveedorCodigo) {
		this.tipoPersonaProveedorCodigo = tipoPersonaProveedorCodigo;
	}
	public String getObservacionesProveedor() {
		return observacionesProveedor;
	}
	public void setObservacionesProveedor(String observacionesProveedor) {
		this.observacionesProveedor = observacionesProveedor;
	}
	public String getWebUrlProveedor() {
		return webUrlProveedor;
	}
	public void setWebUrlProveedor(String webUrlProveedor) {
		this.webUrlProveedor = webUrlProveedor;
	}
	public Date getFechaConstitucionProveedor() {
		return fechaConstitucionProveedor;
	}
	public void setFechaConstitucionProveedor(Date fechaConstitucionProveedor) {
		this.fechaConstitucionProveedor = fechaConstitucionProveedor;
	}
	public String getTerritorialCodigo() {
		return territorialCodigo;
	}
	public void setTerritorialCodigo(String territorialCodigo) {
		this.territorialCodigo = territorialCodigo;
	}
	public String getCarteraCodigo() {
		return carteraCodigo;
	}
	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}
	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}
	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}
	public String getCustodioCodigo() {
		return custodioCodigo;
	}
	public void setCustodioCodigo(String custodioCodigo) {
		this.custodioCodigo = custodioCodigo;
	}
	public String getTipoActivosCarteraCodigo() {
		return tipoActivosCarteraCodigo;
	}
	public void setTipoActivosCarteraCodigo(String tipoActivosCarteraCodigo) {
		this.tipoActivosCarteraCodigo = tipoActivosCarteraCodigo;
	}
	public String getCalificacionCodigo() {
		return calificacionCodigo;
	}
	public void setCalificacionCodigo(String calificacionCodigo) {
		this.calificacionCodigo = calificacionCodigo;
	}
	public String getIncluidoTopCodigo() {
		return incluidoTopCodigo;
	}
	public void setIncluidoTopCodigo(String incluidoTopCodigo) {
		this.incluidoTopCodigo = incluidoTopCodigo;
	}
	public String getNumCuentaIBAN() {
		return numCuentaIBAN;
	}
	public void setNumCuentaIBAN(String numCuentaIBAN) {
		this.numCuentaIBAN = numCuentaIBAN;
	}
	public String getTitularCuenta() {
		return titularCuenta;
	}
	public void setTitularCuenta(String titularCuenta) {
		this.titularCuenta = titularCuenta;
	}
	public String getRetencionPagoCodigo() {
		return retencionPagoCodigo;
	}
	public void setRetencionPagoCodigo(String retencionPagoCodigo) {
		this.retencionPagoCodigo = retencionPagoCodigo;
	}
	public Date getFechaRetencion() {
		return fechaRetencion;
	}
	public void setFechaRetencion(Date fechaRetencion) {
		this.fechaRetencion = fechaRetencion;
	}
	public String getMotivoRetencionCodigo() {
		return motivoRetencionCodigo;
	}
	public void setMotivoRetencionCodigo(String motivoRetencionCodigo) {
		this.motivoRetencionCodigo = motivoRetencionCodigo;
	}
	public Date getFechaProceso() {
		return fechaProceso;
	}
	public void setFechaProceso(Date fechaProceso) {
		this.fechaProceso = fechaProceso;
	}
	public String getResultadoBlanqueoCodigo() {
		return resultadoBlanqueoCodigo;
	}
	public void setResultadoBlanqueoCodigo(String resultadoBlanqueoCodigo) {
		this.resultadoBlanqueoCodigo = resultadoBlanqueoCodigo;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getOperativaCodigo() {
		return operativaCodigo;
	}
	public void setOperativaCodigo(String operativaCodigo) {
		this.operativaCodigo = operativaCodigo;
	}
	public String getHomologadoCodigo() {
		return homologadoCodigo;
	}
	public void setHomologadoCodigo(String homologadoCodigo) {
		this.homologadoCodigo = homologadoCodigo;
	}
	public String getSubtipoProveedorDescripcion() {
		return subtipoProveedorDescripcion;
	}
	public void setSubtipoProveedorDescripcion(String subtipoProveedorDescripcion) {
		this.subtipoProveedorDescripcion = subtipoProveedorDescripcion;
	}
	
}