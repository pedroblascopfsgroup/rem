package es.pfsgroup.plugin.rem.model;

public class DtoClienteComercial {

	private Long id;
    private String razonSocial;
    private String nombreCliente;
    private String apellidosCliente;
    private String direccion;
    private String telefono;
    private String email;
	private String tipoPersonaCodigo;
	private String tipoPersonaDescripcion;
	private String estadoCivilCodigo;
	private String estadoCivilDescripcion;
	private String regimenMatrimonialCodigo;
	private String regimenMatrimonialDescripcion;
    private Boolean cesionDatos;
    private Boolean comunicacionTerceros;
    private Boolean transferenciasInternacionales;
    private String telefono1;
    private String telefono2;
    private String numeroCalle;
    private String escalera;
    private String planta;
    private String puerta;
    private String codigoPostal;
    private String provinciaCodigo;
	private String provinciaDescripcion;
    private String documento;
    private String tipoDocumentoCodigo;
    private String tipoDocumentoDescripcion;
    private String documentoRepresentante;
    private String tipoDocumentoRteCodigo;
    private String tipoDocumentoRteDescripcion;
    private String idPersonaHaya;
    
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getApellidosCliente() {
		return apellidosCliente;
	}
	public void setApellidosCliente(String apellidosCliente) {
		this.apellidosCliente = apellidosCliente;
	}
	public String getTipoPersonaCodigo() {
		return tipoPersonaCodigo;
	}
	public void setTipoPersonaCodigo(String tipoPersonaCodigo) {
		this.tipoPersonaCodigo = tipoPersonaCodigo;
	}
	public String getTipoPersonaDescripcion() {
		return tipoPersonaDescripcion;
	}
	public void setTipoPersonaDescripcion(String tipoPersonaDescripcion) {
		this.tipoPersonaDescripcion = tipoPersonaDescripcion;
	}
	public String getEstadoCivilCodigo() {
		return estadoCivilCodigo;
	}
	public void setEstadoCivilCodigo(String estadoCivilCodigo) {
		this.estadoCivilCodigo = estadoCivilCodigo;
	}
	public String getEstadoCivilDescripcion() {
		return estadoCivilDescripcion;
	}
	public void setEstadoCivilDescripcion(String estadoCivilDescripcion) {
		this.estadoCivilDescripcion = estadoCivilDescripcion;
	}
	public String getRegimenMatrimonialCodigo() {
		return regimenMatrimonialCodigo;
	}
	public void setRegimenMatrimonialCodigo(String regimenMatrimonialCodigo) {
		this.regimenMatrimonialCodigo = regimenMatrimonialCodigo;
	}
	public String getRegimenMatrimonialDescripcion() {
		return regimenMatrimonialDescripcion;
	}
	public void setRegimenMatrimonialDescripcion(String regimenMatrimonialDescripcion) {
		this.regimenMatrimonialDescripcion = regimenMatrimonialDescripcion;
	}
	public Boolean getCesionDatos() {
		return cesionDatos;
	}
	public void setCesionDatos(Boolean cesionDatos) {
		this.cesionDatos = cesionDatos;
	}
	public Boolean getComunicacionTerceros() {
		return comunicacionTerceros;
	}
	public void setComunicacionTerceros(Boolean comunicacionTerceros) {
		this.comunicacionTerceros = comunicacionTerceros;
	}
	public Boolean getTransferenciasInternacionales() {
		return transferenciasInternacionales;
	}
	public void setTransferenciasInternacionales(Boolean transferenciasInternacionales) {
		this.transferenciasInternacionales = transferenciasInternacionales;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getTelefono1() {
		return telefono1;
	}
	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
	}
	public String getTelefono2() {
		return telefono2;
	}
	public void setTelefono2(String telefono2) {
		this.telefono2 = telefono2;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getNumeroCalle() {
		return numeroCalle;
	}
	public void setNumeroCalle(String numeroCalle) {
		this.numeroCalle = numeroCalle;
	}
	public String getEscalera() {
		return escalera;
	}
	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}
	public String getPlanta() {
		return planta;
	}
	public void setPlanta(String planta) {
		this.planta = planta;
	}
	public String getPuerta() {
		return puerta;
	}
	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getDocumento() {
		return documento;
	}
	public void setDocumento(String documento) {
		this.documento = documento;
	}
	
	public String getTipoDocumentoCodigo() {
		return tipoDocumentoCodigo;
	}
	public void setTipoDocumentoCodigo(String tipoDocumentoCodigo) {
		this.tipoDocumentoCodigo = tipoDocumentoCodigo;
	}
	public String getTipoDocumentoDescripcion() {
		return tipoDocumentoDescripcion;
	}
	public void setTipoDocumentoDescripcion(String tipoDocumentoDescripcion) {
		this.tipoDocumentoDescripcion = tipoDocumentoDescripcion;
	}
	public String getDocumentoRepresentante() {
		return documentoRepresentante;
	}
	public void setDocumentoRepresentante(String documentoRepresentante) {
		this.documentoRepresentante = documentoRepresentante;
	}
	public String getTipoDocumentoRteCodigo() {
		return tipoDocumentoRteCodigo;
	}
	public void setTipoDocumentoRteCodigo(String tipoDocumentoRteCodigo) {
		this.tipoDocumentoRteCodigo = tipoDocumentoRteCodigo;
	}
	public String getTipoDocumentoRteDescripcion() {
		return tipoDocumentoRteDescripcion;
	}
	public void setTipoDocumentoRteDescripcion(String tipoDocumentoRteDescripcion) {
		this.tipoDocumentoRteDescripcion = tipoDocumentoRteDescripcion;
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
	public String getIdPersonaHaya() {
		return idPersonaHaya;
	}
	public void setIdPersonaHaya(String idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}
}
