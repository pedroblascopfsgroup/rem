package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_DATOS_COMPRADOR_EXP", schema = "${entity.schema}")
public class VBusquedaDatosCompradorExpediente implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "COM_ID")
	private String id;
	
	@Column(name = "ECO_ID")
	private String idExpedienteComercial;
	
	@Column(name = "COD_TIPO_PERSONA")
	private String codTipoPersona;
	
	@Column(name = "DESC_TIPO_PERSONA")
	private String descripcionTipoPersona;
	
	@Column(name = "TITULAR_RESERVA")
	private Integer titularReserva;
	
	@Column(name = "PORCENTAJE_COMPRA")
	private Double porcentajeCompra;
	
	@Column(name = "TITULAR_CONTRATACION")
	private Integer titularContratacion;
	
	@Column(name = "COD_TIPO_DOCUMENTO")
	private String codTipoDocumento;
	
	@Column(name = "DESC_TIPO_DOCUMENTO")
	private String descripcionTipoDocumento;
	
	@Column(name = "COM_DOCUMENTO")
	private String numDocumento;
	
	@Column(name = "NOMBRE_COMPRADOR")
	private String nombreRazonSocial;
	
	@Column(name = "COM_DIRECCION")
	private String direccion;
	
	@Column(name = "DD_LOC_CODIGO")
	private String municipioCodigo;
	
	@Column(name = "DD_LOC_DESCRIPCION")
	private String municipioDescripcion;
	
	@Column(name = "COM_TELEFONO1")
	private String telefono1;
	
	@Column(name = "DD_PRV_CODIGO")
	private String provinciaCodigo;
	
	@Column(name = "DD_PRV_DESCRIPCION")
	private String provinciaDescripcion;
	
	@Column(name = "COM_TELEFONO2")
	private String telefono2;
	
	@Column(name = "COM_CODIGO_POSTAL")
	private String codigoPostal;
	
	@Column(name = "COM_EMAIL")
	private String email;
	
	@Column(name = "COD_ESTADO_CIVIL")
	private String codEstadoCivil;
	
	@Column(name = "DESC_ESTADO_CIVIL")
	private String descripcionEstadoCivil;
	
	@Column(name = "CEX_DOCUMENTO_CONYUGE")
	private String documentoConyuge;
	
	@Column(name = "CEX_ANTIGUO_DEUDOR")
	private Integer antiguoDeudor;
	
	@Column(name = "CEX_RELACION_ANT_DEUDOR")
	private Integer relacionAntDeudor;
	
	@Column(name = "COD_TIPO_DOCUMENTO_RTE")
	private String codTipoDocumentoRte;
	
	@Column(name = "DESC_TIPO_DOCUMENTO_RTE")
	private String descripcionTipoDocumentoRte;
	
	@Column(name = "CEX_DOCUMENTO_RTE")
	private String numDocumentoRte;
	
	@Column(name = "NOMBRE_REPRESENTANTE")
	private String nombreRazonSocialRte;
	
	@Column(name = "CEX_DIRECCION_RTE")
	private String direccionRte;
	
	@Column(name = "DD_LOC_CODIGO_RTE")
	private String municipioRteCodigo;
	
	@Column(name = "DD_LOC_DESCRIPCION_RTE")
	private String municipioRteDescripcion;
	
	@Column(name = "CEX_TELEFONO1_RTE")
	private String telefono1Rte;
	
	@Column(name = "DD_PRV_CODIGO_RTE")
	private String provinciaRteCodigo;
	
	@Column(name = "DD_PRV_DESCRIPCION_RTE")
	private String provinciaRteDescripcion;
	
	@Column(name = "CEX_TELEFONO2_RTE")
	private String telefono2Rte;
	
	@Column(name = "CEX_CODIGO_POSTAL_RTE")
	private String codigoPostalRte;
	
	@Column(name = "CEX_EMAIL_RTE")
	private String emailRte;
	
    @Column(name="CEX_RESPONSABLE_TRAMITACION")
    private String responsableTramitacion;
    
    @Column(name="CEX_IMPTE_PROPORCIONAL_OFERTA")
    private Double importeProporcionalOferta;
    
    @Column(name="CEX_IMPTE_FINANCIADO")
    private Double importeFinanciado;
    
    @Column(name = "COD_ESTADO_PBC")
    private String codigoEstadoPbc;
    
    @Column(name = "DESC_ESTADO_PBC")
    private String descripcionEstadoPbc;
    
    @Column(name="CEX_RELACION_HRE")
    private String relacionHre;
    
    @Column(name="COD_REM_CODIGO")
    private String codigoRegimenMatrimonial;
    
    @Column(name="DESC_REM_CODIGO")
    private String descripcionRegimenMatrimonial;
    
    @Column(name="APELLIDOS_COMPRADOR")
    private String apellidos;
    
    @Column(name="APELLIDOS_COMPRADOR_RTE")
    private String apellidosRte;
    
    @Column(name="CEX_FECHA_PETICION")
    private Date fechaPeticion;
    
    @Column(name="CEX_FECHA_RESOLUCION")
    private Date fechaResolucion;
    
	@Column(name = "COD_USO_ACTIVO")
	private String codUsoActivo;
	
	@Column(name = "DESC_USO_ACTIVO")
	private String descripcionUsoActivo;
	
	@Column(name = "ID_COMPRADOR_URSUS")
	private Long numeroClienteUrsus;
	
	@Column(name = "ID_COMPRADOR_URSUS_BH")
	private Long numeroClienteUrsusBh;
	
	@Column(name = "COD_GRADO_PROPIEDAD")
	private String codigoGradoPropiedad;
	
	@Column(name = "DESC_GRADO_PROPIEDAD")
	private String descripcionGradoPropiedad;
	
	@Column(name = "COD_PAIS")
	private String codigoPais;
	
	@Column(name = "DESC_PAIS")
	private String descripcionPais;
	
	@Column(name = "COD_PAIS_RTE")
	private String codigoPaisRte;
	
	@Column(name = "DESC_PAIS_RTE")
	private String descripcionPaisRte;
	
	// HREOS-4937
	private Boolean cesionDatos;
	private Boolean comunicacionTerceros;
	private Boolean transferenciasInternacionales;
	private Long idDocAdjunto;
    

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getCodTipoPersona() {
		return codTipoPersona;
	}

	public void setCodTipoPersona(String codTipoPersona) {
		this.codTipoPersona = codTipoPersona;
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

	public String getIdExpedienteComercial() {
		return idExpedienteComercial;
	}

	public void setIdExpedienteComercial(String idExpedienteComercial) {
		this.idExpedienteComercial = idExpedienteComercial;
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

	public void setDescripcionRegimenMatrimonial(
			String descripcionRegimenMatrimonial) {
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

	public void setTelefono1Rte(String telefono1Rte) {
		this.telefono1Rte = telefono1Rte;
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

	//HREOS-4937
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

	public Long getIdDocAdjunto() {
		return idDocAdjunto;
	}

	public void setIdDocAdjunto(Long idDocAdjunto) {
		this.idDocAdjunto = idDocAdjunto;
	}


}
