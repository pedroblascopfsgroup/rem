package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public class DtoModificarCompradores {
	
	
	private String id;
	
	private String idExpedienteComercial;
	
	private String codTipoPersona;
	
	private String entidadPropietariaCodigo;

	private String descripcionTipoPersona;
	
	private Integer titularReserva;
	
	private Double porcentajeCompra;
	
	private Integer titularContratacion;

	private String codTipoDocumento;
	
	private String descripcionTipoDocumento;
	
	private String numDocumento;
	
	private String nombreRazonSocial;
	
	private String direccion;

	private String municipioCodigo;

	private String municipioDescripcion;

	private String telefono1;

	private String provinciaCodigo;

	private String provinciaDescripcion;

	private String telefono2;

	private String codigoPostal;
	
	private String email;

	private String codEstadoCivil;

	private String descripcionEstadoCivil;
	
	private String documentoConyuge;
	
	private Integer antiguoDeudor;
	
	private Integer relacionAntDeudor;
	
	private String codTipoDocumentoRte;

	private String descripcionTipoDocumentoRte;

	private String numDocumentoRte;

	private String nombreRazonSocialRte;

	private String direccionRte;

	private String municipioRteCodigo;

	private String municipioRteDescripcion;

	private String telefono1Rte;
	
	private String provinciaRteCodigo;

	private String provinciaRteDescripcion;
	
	private String telefono2Rte;

	private String codigoPostalRte;
	
	private String emailRte;
	
    private String responsableTramitacion;

    private Double importeProporcionalOferta;

    private Double importeFinanciado;

    private String codigoEstadoPbc;

    private String descripcionEstadoPbc;

    private String relacionHre;

    private String codigoRegimenMatrimonial;

    private String descripcionRegimenMatrimonial;

    private String apellidos;

    private String apellidosRte;

    private Date fechaPeticion;

    private Date fechaResolucion;

	private String codUsoActivo;
	
	private String descripcionUsoActivo;

	private Long numeroClienteUrsus;

	private Long numeroClienteUrsusBh;

	private String codigoGradoPropiedad;

	private String descripcionGradoPropiedad;

	private String codigoPais;

	private String descripcionPais;

	private String codigoPaisRte;

	private String descripcionPaisRte;
	
	private Boolean esBH;
	
	private Boolean cesionDatos;
	
	private Boolean comunicacionTerceros;
	
	private Boolean transferenciasInternacionales;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdExpedienteComercial() {
		return idExpedienteComercial;
	}

	public void setIdExpedienteComercial(String idExpedienteComercial) {
		this.idExpedienteComercial = idExpedienteComercial;
	}

	public String getCodTipoPersona() {
		return codTipoPersona;
	}

	public void setCodTipoPersona(String codTipoPersona) {
		this.codTipoPersona = codTipoPersona;
	}
	
	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}

	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}

	public String getDescripcionTipoPersona() {
		return descripcionTipoPersona;
	}

	public void setDescripcionTipoPersona(String descripcionTipoPersona) {
		this.descripcionTipoPersona = descripcionTipoPersona;
	}

	public Integer getTitularReserva() {
		return titularReserva;
	}

	public void setTitularReserva(Integer titularReserva) {
		this.titularReserva = titularReserva;
	}

	public Double getPorcentajeCompra() {
		return porcentajeCompra;
	}

	public void setPorcentajeCompra(Double porcentajeCompra) {
		this.porcentajeCompra = porcentajeCompra;
	}

	public Integer getTitularContratacion() {
		return titularContratacion;
	}

	public void setTitularContratacion(Integer titularContratacion) {
		this.titularContratacion = titularContratacion;
	}

	public String getCodTipoDocumento() {
		return codTipoDocumento;
	}

	public void setCodTipoDocumento(String codTipoDocumento) {
		this.codTipoDocumento = codTipoDocumento;
	}

	public String getDescripcionTipoDocumento() {
		return descripcionTipoDocumento;
	}

	public void setDescripcionTipoDocumento(String descripcionTipoDocumento) {
		this.descripcionTipoDocumento = descripcionTipoDocumento;
	}

	public String getNumDocumento() {
		return numDocumento;
	}

	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}

	public String getNombreRazonSocial() {
		return nombreRazonSocial;
	}

	public void setNombreRazonSocial(String nombreRazonSocial) {
		this.nombreRazonSocial = nombreRazonSocial;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getMunicipioCodigo() {
		return municipioCodigo;
	}

	public void setMunicipioCodigo(String municipioCodigo) {
		this.municipioCodigo = municipioCodigo;
	}

	public String getMunicipioDescripcion() {
		return municipioDescripcion;
	}

	public void setMunicipioDescripcion(String municipioDescripcion) {
		this.municipioDescripcion = municipioDescripcion;
	}

	public String getTelefono1() {
		return telefono1;
	}

	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
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

	public String getTelefono2() {
		return telefono2;
	}

	public void setTelefono2(String telefono2) {
		this.telefono2 = telefono2;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getCodEstadoCivil() {
		return codEstadoCivil;
	}

	public void setCodEstadoCivil(String codEstadoCivil) {
		this.codEstadoCivil = codEstadoCivil;
	}

	public String getDescripcionEstadoCivil() {
		return descripcionEstadoCivil;
	}

	public void setDescripcionEstadoCivil(String descripcionEstadoCivil) {
		this.descripcionEstadoCivil = descripcionEstadoCivil;
	}

	public String getDocumentoConyuge() {
		return documentoConyuge;
	}

	public void setDocumentoConyuge(String documentoConyuge) {
		this.documentoConyuge = documentoConyuge;
	}

	public Integer getAntiguoDeudor() {
		return antiguoDeudor;
	}

	public void setAntiguoDeudor(Integer antiguoDeudor) {
		this.antiguoDeudor = antiguoDeudor;
	}

	public Integer getRelacionAntDeudor() {
		return relacionAntDeudor;
	}

	public void setRelacionAntDeudor(Integer relacionAntDeudor) {
		this.relacionAntDeudor = relacionAntDeudor;
	}

	public String getCodTipoDocumentoRte() {
		return codTipoDocumentoRte;
	}

	public void setCodTipoDocumentoRte(String codTipoDocumentoRte) {
		this.codTipoDocumentoRte = codTipoDocumentoRte;
	}

	public String getDescripcionTipoDocumentoRte() {
		return descripcionTipoDocumentoRte;
	}

	public void setDescripcionTipoDocumentoRte(String descripcionTipoDocumentoRte) {
		this.descripcionTipoDocumentoRte = descripcionTipoDocumentoRte;
	}

	public String getNumDocumentoRte() {
		return numDocumentoRte;
	}

	public void setNumDocumentoRte(String numDocumentoRte) {
		this.numDocumentoRte = numDocumentoRte;
	}

	public String getNombreRazonSocialRte() {
		return nombreRazonSocialRte;
	}

	public void setNombreRazonSocialRte(String nombreRazonSocialRte) {
		this.nombreRazonSocialRte = nombreRazonSocialRte;
	}

	public String getDireccionRte() {
		return direccionRte;
	}

	public void setDireccionRte(String direccionRte) {
		this.direccionRte = direccionRte;
	}

	public String getMunicipioRteCodigo() {
		return municipioRteCodigo;
	}

	public void setMunicipioRteCodigo(String municipioRteCodigo) {
		this.municipioRteCodigo = municipioRteCodigo;
	}

	public String getMunicipioRteDescripcion() {
		return municipioRteDescripcion;
	}

	public void setMunicipioRteDescripcion(String municipioRteDescripcion) {
		this.municipioRteDescripcion = municipioRteDescripcion;
	}

	public String getTelefono1Rte() {
		return telefono1Rte;
	}

	public void setTelefono1Rte(String telefono1Rte) {
		this.telefono1Rte = telefono1Rte;
	}

	public String getProvinciaRteCodigo() {
		return provinciaRteCodigo;
	}

	public void setProvinciaRteCodigo(String provinciaRteCodigo) {
		this.provinciaRteCodigo = provinciaRteCodigo;
	}

	public String getProvinciaRteDescripcion() {
		return provinciaRteDescripcion;
	}

	public void setProvinciaRteDescripcion(String provinciaRteDescripcion) {
		this.provinciaRteDescripcion = provinciaRteDescripcion;
	}

	public String getTelefono2Rte() {
		return telefono2Rte;
	}

	public void setTelefono2Rte(String telefono2Rte) {
		this.telefono2Rte = telefono2Rte;
	}

	public String getCodigoPostalRte() {
		return codigoPostalRte;
	}

	public void setCodigoPostalRte(String codigoPostalRte) {
		this.codigoPostalRte = codigoPostalRte;
	}

	public String getEmailRte() {
		return emailRte;
	}

	public void setEmailRte(String emailRte) {
		this.emailRte = emailRte;
	}

	public String getResponsableTramitacion() {
		return responsableTramitacion;
	}

	public void setResponsableTramitacion(String responsableTramitacion) {
		this.responsableTramitacion = responsableTramitacion;
	}

	public Double getImporteProporcionalOferta() {
		return importeProporcionalOferta;
	}

	public void setImporteProporcionalOferta(Double importeProporcionalOferta) {
		this.importeProporcionalOferta = importeProporcionalOferta;
	}

	public Double getImporteFinanciado() {
		return importeFinanciado;
	}

	public void setImporteFinanciado(Double importeFinanciado) {
		this.importeFinanciado = importeFinanciado;
	}

	public String getCodigoEstadoPbc() {
		return codigoEstadoPbc;
	}

	public void setCodigoEstadoPbc(String codigoEstadoPbc) {
		this.codigoEstadoPbc = codigoEstadoPbc;
	}

	public String getDescripcionEstadoPbc() {
		return descripcionEstadoPbc;
	}

	public void setDescripcionEstadoPbc(String descripcionEstadoPbc) {
		this.descripcionEstadoPbc = descripcionEstadoPbc;
	}

	public String getRelacionHre() {
		return relacionHre;
	}

	public void setRelacionHre(String relacionHre) {
		this.relacionHre = relacionHre;
	}

	public String getCodigoRegimenMatrimonial() {
		return codigoRegimenMatrimonial;
	}

	public void setCodigoRegimenMatrimonial(String codigoRegimenMatrimonial) {
		this.codigoRegimenMatrimonial = codigoRegimenMatrimonial;
	}

	public String getDescripcionRegimenMatrimonial() {
		return descripcionRegimenMatrimonial;
	}

	public void setDescripcionRegimenMatrimonial(String descripcionRegimenMatrimonial) {
		this.descripcionRegimenMatrimonial = descripcionRegimenMatrimonial;
	}

	public String getApellidos() {
		return apellidos;
	}

	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}

	public String getApellidosRte() {
		return apellidosRte;
	}

	public void setApellidosRte(String apellidosRte) {
		this.apellidosRte = apellidosRte;
	}

	public Date getFechaPeticion() {
		return fechaPeticion;
	}

	public void setFechaPeticion(Date fechaPeticion) {
		this.fechaPeticion = fechaPeticion;
	}

	public Date getFechaResolucion() {
		return fechaResolucion;
	}

	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}

	public String getCodUsoActivo() {
		return codUsoActivo;
	}

	public void setCodUsoActivo(String codUsoActivo) {
		this.codUsoActivo = codUsoActivo;
	}

	public String getDescripcionUsoActivo() {
		return descripcionUsoActivo;
	}

	public void setDescripcionUsoActivo(String descripcionUsoActivo) {
		this.descripcionUsoActivo = descripcionUsoActivo;
	}

	public Long getNumeroClienteUrsus() {
		return numeroClienteUrsus;
	}

	public void setNumeroClienteUrsus(Long numeroClienteUrsus) {
		this.numeroClienteUrsus = numeroClienteUrsus;
	}

	public Long getNumeroClienteUrsusBh() {
		return numeroClienteUrsusBh;
	}

	public void setNumeroClienteUrsusBh(Long numeroClienteUrsusBh) {
		this.numeroClienteUrsusBh = numeroClienteUrsusBh;
	}

	public String getCodigoGradoPropiedad() {
		return codigoGradoPropiedad;
	}

	public void setCodigoGradoPropiedad(String codigoGradoPropiedad) {
		this.codigoGradoPropiedad = codigoGradoPropiedad;
	}

	public String getDescripcionGradoPropiedad() {
		return descripcionGradoPropiedad;
	}

	public void setDescripcionGradoPropiedad(String descripcionGradoPropiedad) {
		this.descripcionGradoPropiedad = descripcionGradoPropiedad;
	}

	public String getCodigoPais() {
		return codigoPais;
	}

	public void setCodigoPais(String codigoPais) {
		this.codigoPais = codigoPais;
	}

	public String getDescripcionPais() {
		return descripcionPais;
	}

	public void setDescripcionPais(String descripcionPais) {
		this.descripcionPais = descripcionPais;
	}

	public String getCodigoPaisRte() {
		return codigoPaisRte;
	}

	public void setCodigoPaisRte(String codigoPaisRte) {
		this.codigoPaisRte = codigoPaisRte;
	}

	public String getDescripcionPaisRte() {
		return descripcionPaisRte;
	}

	public void setDescripcionPaisRte(String descripcionPaisRte) {
		this.descripcionPaisRte = descripcionPaisRte;
	}

	public Boolean getEsBH() {
		return esBH;
	}

	public void setEsBH(Boolean esBH) {
		this.esBH = esBH;
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

}
