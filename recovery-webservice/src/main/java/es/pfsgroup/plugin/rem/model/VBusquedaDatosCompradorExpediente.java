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
	@Column(name = "VCEX_ID")
	private Long vcexId;

	@Column(name = "COM_ID")
	private Long id;
	
	@Column(name = "ECO_ID")
	private Long idExpedienteComercial;
	
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
	
	@Column(name = "COD_TIPO_DOCUMENTO_CONYUGE")
	private String codTipoDocumentoConyuge;
	
	@Column(name = "DESC_TIPO_DOCUMENTO_CONYUGE")
	private String descripcionTipoDocumentoConyuge;
	
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

	@Column(name = "COM_CESION_DATOS")
	private Boolean cesionDatos;
	    
	@Column(name = "COM_COMUNI_TERCEROS")
	private Boolean comunicacionTerceros;
	    
	@Column(name = "COM_TRANSF_INTER")
	private Boolean transferenciasInternacionales;
	
	@Column(name = "ADCOM_ID")
	private Long idDocAdjunto;
	
	@Column(name = "PROBLEMAS_URSUS")
    private String problemasUrsus;
	
	@Column(name = "DD_ECV_ID_URSUS")
	private String estadoCivilURSUS;
	
	@Column(name = "DD_REM_ID_URSUS")
	private String regimenMatrimonialUrsus;
	
	@Column(name = "N_URSUS_CONYUGE")
	private String numeroConyugeUrsus;
	
	@Column(name = "NOMBRE_CONYUGE_URSUS")
	private String nombreConyugeURSUS;
	
	@Column(name = "CEX_CLI_URSUS_CONYUGE_REM")
	private String cexClienteUrsusConyuge;
	
	@Column(name = "CEX_NUM_URSUS_CONYUGE_REM")
	private String numeroClienteUrsusConyuge;
	
	@Column(name = "CEX_NUM_URSUS_CONYUGE_BH_REM")
	private String numeroClienteUrsusBhConyuge;
	
	@Column(name = "CEX_C4C_ID")
	private String idBC4C;
	
	@Column(name = "COM_FECHA_NACIOCONST")
	private Date fechaNacimientoConstitucion;
	
	@Column(name="COM_FORMA_JURIDICA")
    private String formaJuridica;
	
	@Column(name="CEX_FECHA_NACIMIENTO_REPR")
    private Date fechaNacimientoRepresentante;
	
	@Column(name="DD_LOC_CODIGO_CEX")
    private String localidadNacimientoRepresentanteCodigo;
	
	@Column(name="DD_LOC_DESCRIPCION_CEX")
    private String localidadNacimientoRepresentanteDescripcion;
	
	@Column(name="DD_PAI_CODIGO_CEX")
    private String paisNacimientoRepresentanteCodigo;
	
	@Column(name="DD_PAI_DESCRIPCION_CEX")
    private String paisNacimientoRepresentanteDescripcion;
	
	@Column(name="CEX_USUFRUCTUARIO")
    private Integer usufructuario;
	
	
	@Column(name="DD_LOC_CODIGO_COM")
    private String localidadNacimientoCompradorCodigo;
	
	@Column(name="DD_LOC_DESCRIPCION_COM")
    private String localidadNacimientoCompradorDescripcion;
	
	@Column(name="COM_PRP")
    private Integer compradorPrp;

	@Column(name="DD_VIC_CODIGO")
    private String vinculoCaixaCodigo;
	

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
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
	
	public String getCodTipoDocumentoConyuge() {
		return codTipoDocumentoConyuge;
	}

	public void setCodTipoDocumentoConyuge(String codTipoDocumentoConyuge) {
		this.codTipoDocumentoConyuge = codTipoDocumentoConyuge;
	}

	public String getDescripcionTipoDocumentoConyuge() {
		return descripcionTipoDocumentoConyuge;
	}

	public void setDescripcionTipoDocumentoConyuge(String descripcionTipoDocumentoConyuge) {
		this.descripcionTipoDocumentoConyuge = descripcionTipoDocumentoConyuge;
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

	public Long getIdExpedienteComercial() {
		return idExpedienteComercial;
	}

	public void setIdExpedienteComercial(Long idExpedienteComercial) {
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

	public String getProblemasUrsus() {
		return problemasUrsus;
	}

	public void setProblemasUrsus(String problemasUrsus) {
		this.problemasUrsus = problemasUrsus;
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

	public Long getVcexId() {
		return vcexId;
	}

	public void setCexId(Long vcexId) {
		this.vcexId = vcexId;
	}

	public String getIdBC4C() {
		return idBC4C;
	}

	public void setIdBC4C(String idBC4C) {
		this.idBC4C = idBC4C;
	}

	public Date getFechaNacimientoConstitucion() {
		return fechaNacimientoConstitucion;
	}

	public void setFechaNacimientoConstitucion(Date fechaNacimientoConstitucion) {
		this.fechaNacimientoConstitucion = fechaNacimientoConstitucion;
	}

	public String getFormaJuridica() {
		return formaJuridica;
	}

	public void setFormaJuridica(String formaJuridica) {
		this.formaJuridica = formaJuridica;
	}

	public Date getFechaNacimientoRepresentante() {
		return fechaNacimientoRepresentante;
	}

	public void setFechaNacimientoRepresentante(Date fechaNacimientoRepresentante) {
		this.fechaNacimientoRepresentante = fechaNacimientoRepresentante;
	}

	public Integer getUsufructuario() {
		return usufructuario;
	}

	public void setUsufructuario(Integer usufructuario) {
		this.usufructuario = usufructuario;
	}

	public Integer getCompradorPrp() {
		return compradorPrp;
	}

	public void setCompradorPrp(Integer compradorPrp) {
		this.compradorPrp = compradorPrp;
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

	public String getVinculoCaixaCodigo() {
		return vinculoCaixaCodigo;
	}

	public void setVinculoCaixaCodigo(String vinculoCaixaCodigo) {
		this.vinculoCaixaCodigo = vinculoCaixaCodigo;
	}	
	
}
