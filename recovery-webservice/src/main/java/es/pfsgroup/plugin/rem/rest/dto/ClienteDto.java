package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

public class ClienteDto implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@NotNull
	private Long idClienteWebcom;
	private Long idClienteRem;
	@Size(max=50)
	private String razonSocial;
	@NotNull
	@Size(max=25)
	private String nombre;
	@NotNull
	@Size(max=50)
	private String apellidos;
	@NotNull
	private Date fechaAccion;
	@NotNull
	private Long idUsuarioRem;
	@Size(max=20)
	private String codTipoDocumento;
	@Size(max=14)
	private String documento;
	@Size(max=20)
	private String codTipoDocumentoRepresentante;
	@Size(max=14)
	private String documentoRepresentante;
	@Size(max=14)
	private String telefono1;
	@Size(max=14)
	private String telefono2;
	@Size(max=50)
	private String email;
	@Size(max=20)
	private String codTipoPrescriptor;
	private Long idPrescriptor;
	private Long idApiResponsable;
	@Size(max=20)
	private String codTipoVia;
	@Size(max=60)
	private String direccion;
	@Size(max=100)
	private String numeroCalle;
	@Size(max=10)
	private String escalera;
	@Size(max=11)
	private String planta;
	@Size(max=17)
	private String puerta;
	@Size(max=5)
	private String codigoPostal;
	@Size(max=20)
	private String codMunicipio;
	@Size(max=20)
	private String codProvincia;
	@Size(max=20)
	private String codPedania;
	@Size(max=250)
	private String observaciones;
	
	
	public Long getIdClienteWebcom() {
		return idClienteWebcom;
	}
	public void setIdClienteWebcom(Long idClienteWebcom) {
		this.idClienteWebcom = idClienteWebcom;
	}
	public Long getIdClienteRem() {
		return idClienteRem;
	}
	public void setIdClienteRem(Long idClienteRem) {
		this.idClienteRem = idClienteRem;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellidos() {
		return apellidos;
	}
	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}
	public Date getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public Long getIdUsuarioRem() {
		return idUsuarioRem;
	}
	public void setIdUsuarioRem(Long idUsuarioRem) {
		this.idUsuarioRem = idUsuarioRem;
	}
	public String getCodTipoDocumento() {
		return codTipoDocumento;
	}
	public void setCodTipoDocumento(String codTipoDocumento) {
		this.codTipoDocumento = codTipoDocumento;
	}
	public String getDocumento() {
		return documento;
	}
	public void setDocumento(String documento) {
		this.documento = documento;
	}
	public String getCodTipoDocumentoRepresentante() {
		return codTipoDocumentoRepresentante;
	}
	public void setCodTipoDocumentoRepresentante(
			String codTipoDocumentoRepresentante) {
		this.codTipoDocumentoRepresentante = codTipoDocumentoRepresentante;
	}
	public String getDocumentoRepresentante() {
		return documentoRepresentante;
	}
	public void setDocumentoRepresentante(String documentoRepresentante) {
		this.documentoRepresentante = documentoRepresentante;
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
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getCodTipoPrescriptor() {
		return codTipoPrescriptor;
	}
	public void setCodTipoPrescriptor(String codTipoPrescriptor) {
		this.codTipoPrescriptor = codTipoPrescriptor;
	}
	public Long getIdPrescriptor() {
		return idPrescriptor;
	}
	public void setIdPrescriptor(Long idPrescriptor) {
		this.idPrescriptor = idPrescriptor;
	}
	public Long getIdApiResponsable() {
		return idApiResponsable;
	}
	public void setIdApiResponsable(Long idApiResponsable) {
		this.idApiResponsable = idApiResponsable;
	}
	public String getCodTipoVia() {
		return codTipoVia;
	}
	public void setCodTipoVia(String codTipoVia) {
		this.codTipoVia = codTipoVia;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
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
	public String getCodProvincia() {
		return codProvincia;
	}
	public void setCodProvincia(String codProvincia) {
		this.codProvincia = codProvincia;
	}
	public String getCodMunicipio() {
		return codMunicipio;
	}
	public void setCodMunicipio(String codMunicipio) {
		this.codMunicipio = codMunicipio;
	}
	public String getCodPedania() {
		return codPedania;
	}
	public void setCodPedania(String codPedania) {
		this.codPedania = codPedania;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
}
