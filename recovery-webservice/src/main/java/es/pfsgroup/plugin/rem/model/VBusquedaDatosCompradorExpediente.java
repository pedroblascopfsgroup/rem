package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
	
	@Column(name = "COM_MUNICIPIO")
	private String municipio;
	
	@Column(name = "COM_TELEFONO1")
	private String telefono1;
	
	@Column(name = "COM_PROVINCIA")
	private String provincia;
	
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
	
	@Column(name = "CEX_MUNICIPIO_RTE")
	private String municipioRte;
	
	@Column(name = "CEX_TELEFONO1_RTE")
	private String telefono1Rte;
	
	@Column(name = "CEX_PROVINCIA_RTE")
	private String provinciaRte;
	
	@Column(name = "CEX_TELEFONO2_RTE")
	private String telefono2Rte;
	
	@Column(name = "CEX_CODIGO_POSTAL_RTE")
	private String codigoPostalRte;
	
	@Column(name = "CEX_EMAIL_RTE")
	private String emailRte;

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

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public String getTelefono1() {
		return telefono1;
	}

	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
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

	public String getMunicipioRte() {
		return municipioRte;
	}

	public void setMunicipioRte(String municipioRte) {
		this.municipioRte = municipioRte;
	}

	public String getTelefono1Rte() {
		return telefono1Rte;
	}

	public void setTelefono1Rte(String telefono1Rte) {
		this.telefono1Rte = telefono1Rte;
	}

	public String getProvinciaRte() {
		return provinciaRte;
	}

	public void setProvinciaRte(String provinciaRte) {
		this.provinciaRte = provinciaRte;
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
	
	

}
