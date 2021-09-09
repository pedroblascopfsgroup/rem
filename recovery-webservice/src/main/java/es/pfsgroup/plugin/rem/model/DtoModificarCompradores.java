package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public class DtoModificarCompradores{
	

	private Long id;
	
	private Long idExpedienteComercial;
	
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
	
	private String codTipoDocumentoConyuge;
	
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

	private Boolean esCarteraBankia;
	
	private Boolean mostrarUrsus;
	
	private Boolean mostrarUrsusBh;
	
	private String descripcionTipoDocumentoConyuge;
	
	private String estadoCivilURSUS;
	
	private String regimenMatrimonialUrsus;
	
	private String numeroConyugeUrsus;
	
	private String problemasUrsus;
	
	private String nombreConyugeURSUS;

	private String cexClienteUrsusConyuge;
	
	private String numeroClienteUrsusConyuge;
	
	private String numeroClienteUrsusBhConyuge;
	
	private boolean visualizar;
	
	private Integer compradorPrp;
	
	private Integer representantePrp;
	
	private Date fechaNacimientoConstitucion;
	
	private Date fechaNacimientoRepresentante;
	
	private String paisNacimientoCompradorCodigo;
	
	private String paisNacimientoCompradorDescripcion;
	
	private String paisNacimientoRepresentanteCodigo;
	
	private String paisNacimientoRepresentanteDescripcion;
	
	private String provinciaNacimientoCompradorCodigo;
	
	private String provinciaNacimientoCompradorDescripcion;

	private String provinciaNacimientoRepresentanteCodigo;
	
	private String provinciaNacimientoRepresentanteDescripcion;
	
	private String localidadNacimientoCompradorCodigo;

	private String localidadNacimientoCompradorDescripcion;
	
	private String localidadNacimientoRepresentanteCodigo;
	
	private String localidadNacimientoRepresentanteDescripcion;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdExpedienteComercial() {
		return idExpedienteComercial;
	}

	public void setIdExpedienteComercial(Long idExpedienteComercial) {
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
	
	public String getCodTipoDocumentoConyuge() {
		return codTipoDocumentoConyuge;
	}

	public void setCodTipoDocumentoConyuge(String codTipoDocumentoConyuge) {
		this.codTipoDocumentoConyuge = codTipoDocumentoConyuge;
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

	public Boolean getEsCarteraBankia() {
		return esCarteraBankia;
	}

	public void setEsCarteraBankia(Boolean esCarteraBankia) {
		this.esCarteraBankia = esCarteraBankia;
	}

	public Boolean getMostrarUrsus() {
		return mostrarUrsus;
	}

	public void setMostrarUrsus(Boolean mostrarUrsus) {
		this.mostrarUrsus = mostrarUrsus;
	}

	public Boolean getMostrarUrsusBh() {
		return mostrarUrsusBh;
	}

	public void setMostrarUrsusBh(Boolean mostrarUrsusBh) {
		this.mostrarUrsusBh = mostrarUrsusBh;
	}

	public String getDescripcionTipoDocumentoConyuge() {
		return descripcionTipoDocumentoConyuge;
	}

	public void setDescripcionTipoDocumentoConyuge(String descripcionTipoDocumentoConyuge) {
		this.descripcionTipoDocumentoConyuge = descripcionTipoDocumentoConyuge;
	}

	public String getEstadoCivilURSUS() {
		return estadoCivilURSUS;
	}

	public void setEstadoCivilURSUS(String estadoCivilURSUS) {
		this.estadoCivilURSUS = estadoCivilURSUS;
	}

	public String getRegimenMatrimonialUrsus() {
		return regimenMatrimonialUrsus;
	}

	public void setRegimenMatrimonialUrsus(String regimenMatrimonialUrsus) {
		this.regimenMatrimonialUrsus = regimenMatrimonialUrsus;
	}

	public String getNumeroConyugeUrsus() {
		return numeroConyugeUrsus;
	}

	public void setNumeroConyugeUrsus(String numeroConyugeUrsus) {
		this.numeroConyugeUrsus = numeroConyugeUrsus;
	}

	public String getProblemasUrsus() {
		return problemasUrsus;
	}

	public void setProblemasUrsus(String problemasUrsus) {
		this.problemasUrsus = problemasUrsus;
	}

	public String getNombreConyugeURSUS() {
		return nombreConyugeURSUS;
	}

	public void setNombreConyugeURSUS(String nombreConyugeURSUS) {
		this.nombreConyugeURSUS = nombreConyugeURSUS;
	}

	public String getCexClienteUrsusConyuge() {
		return cexClienteUrsusConyuge;
	}

	public void setCexClienteUrsusConyuge(String cexClienteUrsusConyuge) {
		this.cexClienteUrsusConyuge = cexClienteUrsusConyuge;
	}

	public String getNumeroClienteUrsusConyuge() {
		return numeroClienteUrsusConyuge;
	}

	public void setNumeroClienteUrsusConyuge(String numeroClienteUrsusConyuge) {
		this.numeroClienteUrsusConyuge = numeroClienteUrsusConyuge;
	}

	public String getNumeroClienteUrsusBhConyuge() {
		return numeroClienteUrsusBhConyuge;
	}

	public void setNumeroClienteUrsusBhConyuge(String numeroClienteUrsusBhConyuge) {
		this.numeroClienteUrsusBhConyuge = numeroClienteUrsusBhConyuge;
	}

	public boolean isVisualizar() {
		return visualizar;
	}

	public void setVisualizar(boolean visualizar) {
		this.visualizar = visualizar;
	}

	public Integer getCompradorPrp() {
		return compradorPrp;
	}

	public void setCompradorPrp(Integer compradorPrp) {
		this.compradorPrp = compradorPrp;
	}

	public Integer getRepresentantePrp() {
		return representantePrp;
	}

	public void setRepresentantePrp(Integer representantePrp) {
		this.representantePrp = representantePrp;
	}

	public Date getFechaNacimientoConstitucion() {
		return fechaNacimientoConstitucion;
	}

	public void setFechaNacimientoConstitucion(Date fechaNacimientoConstitucion) {
		this.fechaNacimientoConstitucion = fechaNacimientoConstitucion;
	}

	public Date getFechaNacimientoRepresentante() {
		return fechaNacimientoRepresentante;
	}

	public void setFechaNacimientoRepresentante(Date fechaNacimientoRepresentante) {
		this.fechaNacimientoRepresentante = fechaNacimientoRepresentante;
	}

	public String getPaisNacimientoCompradorCodigo() {
		return paisNacimientoCompradorCodigo;
	}

	public void setPaisNacimientoCompradorCodigo(String paisNacimientoCompradorCodigo) {
		this.paisNacimientoCompradorCodigo = paisNacimientoCompradorCodigo;
	}

	public String getPaisNacimientoCompradorDescripcion() {
		return paisNacimientoCompradorDescripcion;
	}

	public void setPaisNacimientoCompradorDescripcion(String paisNacimientoCompradorDescripcion) {
		this.paisNacimientoCompradorDescripcion = paisNacimientoCompradorDescripcion;
	}

	public String getPaisNacimientoRepresentanteCodigo() {
		return paisNacimientoRepresentanteCodigo;
	}

	public void setPaisNacimientoRepresentanteCodigo(String paisNacimientoRepresentanteCodigo) {
		this.paisNacimientoRepresentanteCodigo = paisNacimientoRepresentanteCodigo;
	}

	public String getPaisNacimientoRepresentanteDescripcion() {
		return paisNacimientoRepresentanteDescripcion;
	}

	public void setPaisNacimientoRepresentanteDescripcion(String paisNacimientoRepresentanteDescripcion) {
		this.paisNacimientoRepresentanteDescripcion = paisNacimientoRepresentanteDescripcion;
	}

	public String getProvinciaNacimientoCompradorCodigo() {
		return provinciaNacimientoCompradorCodigo;
	}

	public void setProvinciaNacimientoCompradorCodigo(String provinciaNacimientoCompradorCodigo) {
		this.provinciaNacimientoCompradorCodigo = provinciaNacimientoCompradorCodigo;
	}

	public String getProvinciaNacimientoCompradorDescripcion() {
		return provinciaNacimientoCompradorDescripcion;
	}

	public void setProvinciaNacimientoCompradorDescripcion(String provinciaNacimientoCompradorDescripcion) {
		this.provinciaNacimientoCompradorDescripcion = provinciaNacimientoCompradorDescripcion;
	}

	public String getProvinciaNacimientoRepresentanteCodigo() {
		return provinciaNacimientoRepresentanteCodigo;
	}

	public void setProvinciaNacimientoRepresentanteCodigo(String provinciaNacimientoRepresentanteCodigo) {
		this.provinciaNacimientoRepresentanteCodigo = provinciaNacimientoRepresentanteCodigo;
	}

	public String getProvinciaNacimientoRepresentanteDescripcion() {
		return provinciaNacimientoRepresentanteDescripcion;
	}

	public void setProvinciaNacimientoRepresentanteDescripcion(String provinciaNacimientoRepresentanteDescripcion) {
		this.provinciaNacimientoRepresentanteDescripcion = provinciaNacimientoRepresentanteDescripcion;
	}

	public String getLocalidadNacimientoCompradorCodigo() {
		return localidadNacimientoCompradorCodigo;
	}

	public void setLocalidadNacimientoCompradorCodigo(String localidadNacimientoCompradorCodigo) {
		this.localidadNacimientoCompradorCodigo = localidadNacimientoCompradorCodigo;
	}

	public String getLocalidadNacimientoCompradorDescripcion() {
		return localidadNacimientoCompradorDescripcion;
	}

	public void setLocalidadNacimientoCompradorDescripcion(String localidadNacimientoCompradorDescripcion) {
		this.localidadNacimientoCompradorDescripcion = localidadNacimientoCompradorDescripcion;
	}

	public String getLocalidadNacimientoRepresentanteCodigo() {
		return localidadNacimientoRepresentanteCodigo;
	}

	public void setLocalidadNacimientoRepresentanteCodigo(String localidadNacimientoRepresentanteCodigo) {
		this.localidadNacimientoRepresentanteCodigo = localidadNacimientoRepresentanteCodigo;
	}

	public String getLocalidadNacimientoRepresentanteDescripcion() {
		return localidadNacimientoRepresentanteDescripcion;
	}

	public void setLocalidadNacimientoRepresentanteDescripcion(String localidadNacimientoRepresentanteDescripcion) {
		this.localidadNacimientoRepresentanteDescripcion = localidadNacimientoRepresentanteDescripcion;
	}
	
}
