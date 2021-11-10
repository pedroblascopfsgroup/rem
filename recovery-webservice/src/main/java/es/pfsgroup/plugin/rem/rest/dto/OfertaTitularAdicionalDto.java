package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.IsNumber;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSocioComercial;
import es.pfsgroup.plugin.rem.model.dd.DDVinculoCaixa;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;


public class OfertaTitularAdicionalDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Diccionary(clase = DDTipoDocumento.class, message = "El tipo de documento no existe", groups = { Insert.class,
			Update.class })
	private String codTipoDocumento;
	@Size(max=14,groups = { Insert.class, Update.class })
	private String documento;
	@Size(max=60,groups = { Insert.class, Update.class })
	private String nombre;
	@Size(max=120,groups = { Insert.class, Update.class })
	private String apellidos;

	@Diccionary(clase = Localidad.class, message = "El municipio no existe", groups = { Insert.class,
			Update.class })
	private String codMunicipio;
	@Diccionary(clase = DDProvincia.class, message = "La provincia no existe", groups = { Insert.class,
			Update.class })
	private String codProvincia;
	@Size(max=20,groups = { Insert.class, Update.class })
	private String codigoPostal;
	@Diccionary(clase = DDEstadosCiviles.class, message = "El estado civil no existe", groups = { Insert.class,
			Update.class })
	private String codEstadoCivil;
	@Diccionary(clase = DDRegimenesMatrimoniales.class, message = "El regimen matrimonial no existe", groups = { Insert.class,
			Update.class })
	private String codRegimenMatrimonial;

	
	private Boolean transferenciasInternacionales = Boolean.FALSE;
	private Boolean cesionDatos = Boolean.FALSE;
	private Boolean comunicacionTerceros = Boolean.FALSE;
	private Boolean aceptacionOfertaTSecundario;
	
	//REMVIP-3846
	@Size(max=50,groups = { Insert.class, Update.class })
	private String razonSocial;
	@Size(max=14,groups = { Insert.class, Update.class })
	private String telefono1;
	@Size(max=14,groups = { Insert.class, Update.class })
	private String telefono2;
	@Size(max=50,groups = { Insert.class, Update.class })
	private String email;
	
	private String idProveedorRemPrescriptor;
	private String idProveedorRemResponsable;
	
	@Size(max=20,groups = { Insert.class, Update.class })
	private String codTipoVia;
	
	@Size(max=100,groups = { Insert.class, Update.class })
	private String nombreCalle;
	@Size(max=100,groups = { Insert.class, Update.class })
	private String numeroCalle;
	@Size(max=10,groups = { Insert.class, Update.class })
	private String escalera;
	@Size(max=11,groups = { Insert.class, Update.class })
	private String planta;
	@Size(max=17,groups = { Insert.class, Update.class })
	private String puerta;
	
	@Size(max=5,groups = { Insert.class, Update.class })
	private String codPedania;
	@Size(max=100,groups = { Insert.class, Update.class })
	private String observaciones;

	@Size(max=5,groups = { Insert.class, Update.class })
	private String conyugeNombre;
	@Size(max=5,groups = { Insert.class, Update.class })
	private String conyugeApellidos;
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoDocumento.class, message = "El conyugeTipoDocumento no existe", groups = { Insert.class,
			Update.class })
	private String conyugeTipoDocumento;
	@Size(max=5,groups = { Insert.class, Update.class })
	private String conyugeDocumento;
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoPersona.class, message = "El codTipoPersona no existe", groups = { Insert.class,
			Update.class })
	private String codTipoPersona;
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDPaises.class, message = "El codPais no existe", groups = { Insert.class,
			Update.class })
	private String codPais;
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoDocumento.class, message = "El codTipoDocumentoRepresentante no existe", groups = { Insert.class,
			Update.class })
	private String codTipoDocumentoRepresentante;
	@Size(max=5,groups = { Insert.class, Update.class })
	private String documentoRepresentante;
	@Size(max=5,groups = { Insert.class, Update.class })
	private String direccionRepresentante;
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDProvincia.class, message = "La provincia no existe", groups = { Insert.class,
			Update.class })
	private String codProvinciaRepresentante;
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = Localidad.class, message = "El municipio no existe", groups = { Insert.class,
			Update.class })
	private String codMunicipioRepresentante;
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDPaises.class, message = "El codPaisRepresentante no existe", groups = { Insert.class,
			Update.class })
	private String codPaisRepresentante;
	@Size(max=5,groups = { Insert.class, Update.class })
	private String codigoPostalRepresentante;
	@Size(max=5,groups = { Insert.class, Update.class })
	private String documentoIdentificativo;
	@Size(max=5,groups = { Insert.class, Update.class })
	private String nombreDocumentoIdentificativo;
	@Size(max=5,groups = { Insert.class, Update.class })
	private String documentoGDPR;
	@Size(max=5,groups = { Insert.class, Update.class })
	private String nombreDocumentoGDPR;
	@Size(max=250,groups = { Insert.class, Update.class })
	private Date fechaAcepGdpr;
	
	@Diccionary(clase = DDPaises.class, message = "El codPaisNacimiento no existe")
	private String codPaisNacimiento;
	@Diccionary(clase = Localidad.class, message = "El codMunicipioNacimiento no existe")
	private String codMunicipioNacimiento;
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDPaises.class, message = "El codPaisNacimientoRepresentante no existe")
	private String codPaisNacimientoRepresentante;
	@Diccionary(clase = Localidad.class, message = "El codMunicipioNacimientoRepresentante no existe")
	private String codMunicipioNacimientoRepresentante;
	private Date fechaNacimiento;
	private Date fechaNacimientoRepresentante;	
	private Boolean prp;
	private Boolean prpRepresentante;
	
	@Diccionary(clase = DDVinculoCaixa.class, message = "El vinculoCaixa no existe")
	private String vinculoCaixa;	
	@Diccionary(clase = DDTipoSocioComercial.class, message = "El sociedadEmpleadoGrupoCaixa no existe")
	private String sociedadEmpleadoGrupoCaixa;
	@IsNumber(message = "Debe ser un número")
	private Integer oficinaEmpleadoCaixa;
	private Boolean esAntiguoDeudor;
	@Diccionary(clase = DDProvincia.class, message = "El codProvinciaNacimiento no existe")
	private String codProvinciaNacimiento;
	@Diccionary(clase = DDProvincia.class, message = "El codProvinciaNacimientoRepresentante no existe")
	private String codProvinciaNacimientoRepresentante;
	
	
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
	public String getCodMunicipio() {
		return codMunicipio;
	}
	public void setCodMunicipio(String codMunicipio) {
		this.codMunicipio = codMunicipio;
	}
	public String getCodProvincia() {
		return codProvincia;
	}
	public void setCodProvincia(String codProvincia) {
		this.codProvincia = codProvincia;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getCodEstadoCivil() {
		return codEstadoCivil;
	}
	public void setCodEstadoCivil(String codEstadoCivil) {
		this.codEstadoCivil = codEstadoCivil;
	}
	public String getCodRegimenMatrimonial() {
		return codRegimenMatrimonial;
	}
	public void setCodRegimenMatrimonial(String codRegimenMatrimonial) {
		this.codRegimenMatrimonial = codRegimenMatrimonial;
	}
	public Boolean getTransferenciasInternacionales() {
		return transferenciasInternacionales;
	}
	public void setTransferenciasInternacionales(Boolean transferenciasInternacionales) {
		this.transferenciasInternacionales = transferenciasInternacionales;
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
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
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
	public String getIdProveedorRemPrescriptor() {
		return idProveedorRemPrescriptor;
	}
	public void setIdProveedorRemPrescriptor(String idProveedorRemPrescriptor) {
		this.idProveedorRemPrescriptor = idProveedorRemPrescriptor;
	}
	public String getIdProveedorRemResponsable() {
		return idProveedorRemResponsable;
	}
	public void setIdProveedorRemResponsable(String idProveedorRemResponsable) {
		this.idProveedorRemResponsable = idProveedorRemResponsable;
	}
	public String getCodTipoVia() {
		return codTipoVia;
	}
	public void setCodTipoVia(String codTipoVia) {
		this.codTipoVia = codTipoVia;
	}
	public String getNombreCalle() {
		return nombreCalle;
	}
	public void setNombreCalle(String nombreCalle) {
		this.nombreCalle = nombreCalle;
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
	public String getConyugeNombre() {
		return conyugeNombre;
	}
	public void setConyugeNombre(String conyugeNombre) {
		this.conyugeNombre = conyugeNombre;
	}
	public String getConyugeApellidos() {
		return conyugeApellidos;
	}
	public void setConyugeApellidos(String conyugeApellidos) {
		this.conyugeApellidos = conyugeApellidos;
	}
	public String getConyugeTipoDocumento() {
		return conyugeTipoDocumento;
	}
	public void setConyugeTipoDocumento(String conyugeTipoDocumento) {
		this.conyugeTipoDocumento = conyugeTipoDocumento;
	}
	public String getConyugeDocumento() {
		return conyugeDocumento;
	}
	public void setConyugeDocumento(String conyugeDocumento) {
		this.conyugeDocumento = conyugeDocumento;
	}
	public String getCodTipoPersona() {
		return codTipoPersona;
	}
	public void setCodTipoPersona(String codTipoPersona) {
		this.codTipoPersona = codTipoPersona;
	}
	public String getCodPais() {
		return codPais;
	}
	public void setCodPais(String codPais) {
		this.codPais = codPais;
	}
	public String getCodTipoDocumentoRepresentante() {
		return codTipoDocumentoRepresentante;
	}
	public void setCodTipoDocumentoRepresentante(String codTipoDocumentoRepresentante) {
		this.codTipoDocumentoRepresentante = codTipoDocumentoRepresentante;
	}
	public String getDocumentoRepresentante() {
		return documentoRepresentante;
	}
	public void setDocumentoRepresentante(String documentoRepresentante) {
		this.documentoRepresentante = documentoRepresentante;
	}
	public String getDireccionRepresentante() {
		return direccionRepresentante;
	}
	public void setDireccionRepresentante(String direccionRepresentante) {
		this.direccionRepresentante = direccionRepresentante;
	}
	public String getCodProvinciaRepresentante() {
		return codProvinciaRepresentante;
	}
	public void setCodProvinciaRepresentante(String codProvinciaRepresentante) {
		this.codProvinciaRepresentante = codProvinciaRepresentante;
	}
	public String getCodMunicipioRepresentante() {
		return codMunicipioRepresentante;
	}
	public void setCodMunicipioRepresentante(String codMunicipioRepresentante) {
		this.codMunicipioRepresentante = codMunicipioRepresentante;
	}
	public String getCodPaisRepresentante() {
		return codPaisRepresentante;
	}
	public void setCodPaisRepresentante(String codPaisRepresentante) {
		this.codPaisRepresentante = codPaisRepresentante;
	}
	public String getCodigoPostalRepresentante() {
		return codigoPostalRepresentante;
	}
	public void setCodigoPostalRepresentante(String codigoPostalRepresentante) {
		this.codigoPostalRepresentante = codigoPostalRepresentante;
	}
	public String getDocumentoIdentificativo() {
		return documentoIdentificativo;
	}
	public void setDocumentoIdentificativo(String documentoIdentificativo) {
		this.documentoIdentificativo = documentoIdentificativo;
	}
	public String getNombreDocumentoIdentificativo() {
		return nombreDocumentoIdentificativo;
	}
	public void setNombreDocumentoIdentificativo(String nombreDocumentoIdentificativo) {
		this.nombreDocumentoIdentificativo = nombreDocumentoIdentificativo;
	}
	public String getDocumentoGDPR() {
		return documentoGDPR;
	}
	public void setDocumentoGDPR(String documentoGDPR) {
		this.documentoGDPR = documentoGDPR;
	}
	public String getNombreDocumentoGDPR() {
		return nombreDocumentoGDPR;
	}
	public void setNombreDocumentoGDPR(String nombreDocumentoGDPR) {
		this.nombreDocumentoGDPR = nombreDocumentoGDPR;
	}
	public Date getFechaAcepGdpr() {
		return fechaAcepGdpr;
	}
	public void setFechaAcepGdpr(Date fechaAcepGdpr) {
		this.fechaAcepGdpr = fechaAcepGdpr;
	}
	public String getCodPaisNacimiento() {
		return codPaisNacimiento;
	}
	public void setCodPaisNacimiento(String codPaisNacimiento) {
		this.codPaisNacimiento = codPaisNacimiento;
	}
	public String getCodMunicipioNacimiento() {
		return codMunicipioNacimiento;
	}
	public void setCodMunicipioNacimiento(String codMunicipioNacimiento) {
		this.codMunicipioNacimiento = codMunicipioNacimiento;
	}
	public String getCodPaisNacimientoRepresentante() {
		return codPaisNacimientoRepresentante;
	}
	public void setCodPaisNacimientoRepresentante(String codPaisNacimientoRepresentante) {
		this.codPaisNacimientoRepresentante = codPaisNacimientoRepresentante;
	}
	public String getCodMunicipioNacimientoRepresentante() {
		return codMunicipioNacimientoRepresentante;
	}
	public void setCodMunicipioNacimientoRepresentante(String codMunicipioNacimientoRepresentante) {
		this.codMunicipioNacimientoRepresentante = codMunicipioNacimientoRepresentante;
	}
	public Date getFechaNacimiento() {
		return fechaNacimiento;
	}
	public void setFechaNacimiento(Date fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public Date getFechaNacimientoRepresentante() {
		return fechaNacimientoRepresentante;
	}
	public void setFechaNacimientoRepresentante(Date fechaNacimientoRepresentante) {
		this.fechaNacimientoRepresentante = fechaNacimientoRepresentante;
	}
	public Boolean getPrp() {
		return prp;
	}
	public void setPrp(Boolean prp) {
		this.prp = prp;
	}
	public Boolean getPrpRepresentante() {
		return prpRepresentante;
	}
	public void setPrpRepresentante(Boolean prpRepresentante) {
		this.prpRepresentante = prpRepresentante;
	}
	public String getVinculoCaixa() {
		return vinculoCaixa;
	}
	public void setVinculoCaixa(String vinculoCaixa) {
		this.vinculoCaixa = vinculoCaixa;
	}
	public String getSociedadEmpleadoGrupoCaixa() {
		return sociedadEmpleadoGrupoCaixa;
	}
	public void setSociedadEmpleadoGrupoCaixa(String sociedadEmpleadoGrupoCaixa) {
		this.sociedadEmpleadoGrupoCaixa = sociedadEmpleadoGrupoCaixa;
	}
	public Integer getOficinaEmpleadoCaixa() {
		return oficinaEmpleadoCaixa;
	}
	public void setOficinaEmpleadoCaixa(Integer oficinaEmpleadoCaixa) {
		this.oficinaEmpleadoCaixa = oficinaEmpleadoCaixa;
	}
	public Boolean getEsAntiguoDeudor() {
		return esAntiguoDeudor;
	}
	public void setEsAntiguoDeudor(Boolean esAntiguoDeudor) {
		this.esAntiguoDeudor = esAntiguoDeudor;
	}
	public String getCodProvinciaNacimiento() {
		return codProvinciaNacimiento;
	}
	public void setCodProvinciaNacimiento(String codProvinciaNacimiento) {
		this.codProvinciaNacimiento = codProvinciaNacimiento;
	}
	public String getCodProvinciaNacimientoRepresentante() {
		return codProvinciaNacimientoRepresentante;
	}
	public void setCodProvinciaNacimientoRepresentante(String codProvinciaNacimientoRepresentante) {
		this.codProvinciaNacimientoRepresentante = codProvinciaNacimientoRepresentante;
	}
	public Boolean getAceptacionOfertaTSecundario() {
		return aceptacionOfertaTSecundario;
	}
	public void setAceptacionOfertaTSecundario(Boolean aceptacionOfertaTSecundario) {
		this.aceptacionOfertaTSecundario = aceptacionOfertaTSecundario;
	}
}
