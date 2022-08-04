package es.pfsgroup.plugin.rem.model;


import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de Datos de Contacto > Direcciones y delegaciones de la ficha proveedor.
 */
public class DtoDireccionDelegacion extends WebDto {
	private static final long serialVersionUID = 0L;

	private String id;
	private String proveedorID;
	private String tipoDireccion;
	private String localAbiertoPublicoCodigo;
	private String referencia;
	private String tipoViaCodigo;
	private String nombreVia;
	private String numeroVia;
	private String puerta;
	private String localidadCodigo;
	private String provincia;
	private Integer codigoPostal;
	private String telefono;
	private String email;
	private int totalCount;
	private Integer piso;
	private String otros;
	
	
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Integer getCodigoPostal() {
		return this.codigoPostal;
	}
	public void setCodigoPostal(Integer codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getTipoDireccion() {
		return tipoDireccion;
	}
	public void setTipoDireccion(String tipoDireccion) {
		this.tipoDireccion = tipoDireccion;
	}
	public String getLocalAbiertoPublicoCodigo() {
		return localAbiertoPublicoCodigo;
	}
	public void setLocalAbiertoPublicoCodigo(String localAbiertoPublicoCodigo) {
		this.localAbiertoPublicoCodigo = localAbiertoPublicoCodigo;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getTipoViaCodigo() {
		return tipoViaCodigo;
	}
	public void setTipoViaCodigo(String tipoViaCodigo) {
		this.tipoViaCodigo = tipoViaCodigo;
	}
	public String getNombreVia() {
		return nombreVia;
	}
	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}
	public String getNumeroVia() {
		return numeroVia;
	}
	public void setNumeroVia(String numeroVia) {
		this.numeroVia = numeroVia;
	}
	public String getPuerta() {
		return puerta;
	}
	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}
	public String getLocalidadCodigo() {
		return localidadCodigo;
	}
	public void setLocalidadCodigo(String localidadCodigo) {
		this.localidadCodigo = localidadCodigo;
	}
	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public void setCodigoPostal(int codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	// Método para establecer el ID de proveedor al crear una nueva fila.
	public void setIdEntidad(String idEntidad) {
		this.proveedorID = idEntidad;
	}
	public String getProveedorID() {
		return proveedorID;
	}
	public void setProveedorID(String proveedorID) {
		this.proveedorID = proveedorID;
	}
	public Integer getPiso() {
		return piso;
	}
	public void setPiso(Integer piso) {
		this.piso = piso;
	}
	public String getOtros() {
		return otros;
	}
	public void setOtros(String otros) {
		this.otros = otros;
	}
	
}