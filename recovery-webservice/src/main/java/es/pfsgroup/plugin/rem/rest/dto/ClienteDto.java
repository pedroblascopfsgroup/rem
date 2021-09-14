package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.Date;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.IsNumber;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDeDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOcupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTiposDocumentos;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPersona;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class ClienteDto implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	private Long idClienteWebcom;
	@NotNull(groups = { Update.class })
	private Long idClienteRem;
	@Size(max=250,groups = { Insert.class, Update.class })
	private String razonSocial;
	@Size(max=250,groups = { Insert.class, Update.class })
	private String nombre;
	@Size(max=250,groups = { Insert.class, Update.class })
	private String apellidos;
	@NotNull(groups = { Insert.class })
	@Size(max=20,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoDocumento.class, message = "El codTipoDocumento no existe", groups = { Insert.class,
			Update.class })
	private String codTipoDocumento;
	@NotNull(groups = { Insert.class })
	@Size(max=14)
	private String documento;
	@Size(max=20,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoDocumento.class, message = "El codTipoDocumentoRepresentante no existe", groups = { Insert.class,
		Update.class })
	private String codTipoDocumentoRepresentante;
	@Size(max=14,groups = { Insert.class, Update.class })
	private String documentoRepresentante;
	@Size(max=20,groups = { Insert.class, Update.class })
	private String telefono1;
	@Size(max=20,groups = { Insert.class, Update.class })
	private String telefono2;
	@Size(max=50,groups = { Insert.class, Update.class })
	private String email;
	@Diccionary(clase = ActivoProveedor.class, message = "El idProveedorRemPrescriptor no existe", groups = { Insert.class,
			Update.class },foreingField="codigoProveedorRem")
	private Long idProveedorRemPrescriptor;
	@Diccionary(clase = ActivoProveedor.class, message = "El idProveedorRemResponsable no existe", groups = { Insert.class,
			Update.class },foreingField="codigoProveedorRem")
	private Long idProveedorRemResponsable;
	@Size(max=20,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoVia.class, message = "El codTipoVia de activo no existe", groups = { Insert.class,
			Update.class })
	private String codTipoVia;
	@Size(max=100,groups = { Insert.class, Update.class })
	private String nombreCalle;
	@Size(max=100)
	private String numeroCalle;
	@Size(max=10,groups = { Insert.class, Update.class })
	private String escalera;
	@Size(max=11,groups = { Insert.class, Update.class })
	private String planta;
	@Size(max=17,groups = { Insert.class, Update.class })
	private String puerta;
	@Size(max=20,groups = { Insert.class, Update.class })
	@Diccionary(clase = Localidad.class, message = "El codMunicipio no existe", groups = { Insert.class, Update.class })
	private String codMunicipio;
	@Size(max=20,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDProvincia.class, message = "El codProvincia no existe", groups = { Insert.class,
			Update.class })
	private String codProvincia;
	@Size(max=20,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDUnidadPoblacional.class, message = "El codPedania no existe", groups = { Insert.class,
			Update.class })
	private String codPedania;
	@Size(max=5,groups = { Insert.class, Update.class })
	private String codigoPostal;
	@Size(max=250,groups = { Insert.class, Update.class })
	private String observaciones;
	@NotNull(groups = { Insert.class, Update.class })
	private Date fechaAccion;
	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = Usuario.class, message = "El usuario no existe", groups = { Insert.class,
		Update.class },foreingField="id")
	private Long idUsuarioRemAccion;
	
	//Se añaden nuevos atributos petición HREOS-1395
	private Boolean rechazaPublicidad;
	@Size(max=20,groups = { Insert.class, Update.class })
	private String idClienteSalesforce;
	@Size(max=14,groups = { Insert.class, Update.class })
	private String telefonoContactoVisitas;
	
	@NotNull(groups = { Insert.class})
	@Diccionary(clase = DDTiposPersona.class, message = "El tipoPersona no existe", groups = { Insert.class,
			Update.class })
	private String codTipoPersona;
	
	@Diccionary(clase = DDEstadosCiviles.class, message = "El estado civil no existe", groups = { Insert.class,
			Update.class })
	private String codEstadoCivil;
	
	@Diccionary(clase = DDRegimenesMatrimoniales.class, message = "El regimen matrimonial no existe", groups = { Insert.class,
			Update.class })
	private String codRegimenMatrimonial;
	
	//HREOS-4851
	private Boolean cesionDatos;
	private Boolean comunicacionTerceros;
	private Boolean transferenciasInternacionales;
	
	//REMVIP-3846
	@Size(max=10,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoDocumento.class, message = "El conyugeTipoDocumento no existe", groups = { Insert.class,
			Update.class })
	private String conyugeTipoDocumento;
	
	@Size(groups = { Insert.class, Update.class })
	private String conyugeDocumento;
	
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDPaises.class, message = "El codPais no existe", groups = { Insert.class,
			Update.class })
	private String codPais;
	
	@Size(max=100,groups = { Insert.class, Update.class })
	private String direccionRepresentante;
	
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDProvincia.class, message = "El codProvinciaRepresentante no existe", groups = { Insert.class,
			Update.class })
	private String codProvinciaRepresentante;
	
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = Localidad.class, message = "El codMunicipioRepresentante no existe", groups = { Insert.class,
			Update.class })
	private String codMunicipioRepresentante;
	
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDPaises.class, message = "El codPaisRepresentante no existe", groups = { Insert.class,
			Update.class })
	private String codPaisRepresentante;
	
	@Size(max=5,groups = { Insert.class, Update.class })
	@IsNumber(groups = { Insert.class, Update.class }, message="El cp no es valido")
	private String codigoPostalRepresentante;
	
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoOcupacion.class, message = "El codOcupacion no existe", groups = { Insert.class,
			Update.class })
	private String codOcupacion;
	
	@Size(max=250,groups = { Insert.class, Update.class })
	private String nombreRepresentante;
	
	@Size(max=250,groups = { Insert.class, Update.class })
	private String apellidosRepresentante;
	
	@Size(max=20,groups = { Insert.class, Update.class })
	private String telefonoRepresentante;
	
	@Size(max=50,groups = { Insert.class, Update.class })
	private String emailRepresentante;
	
	@Size(max=250,groups = { Insert.class, Update.class })
	private String nombreContacto;
	
	@Size(max=250,groups = { Insert.class, Update.class })
	private String apellidosContacto;
	
	@Size(max=5,groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoDeDocumento.class, message = "El codTipoDocumentoContacto no existe", groups = { Insert.class,
			Update.class })
	private String codTipoDocumentoContacto;
	
	@Size(max=14,groups = { Insert.class, Update.class })
	private String documentoContacto;
	
	@Size(max=20,groups = { Insert.class, Update.class })
	private String telefonoContacto;
	
	@Size(max=50,groups = { Insert.class, Update.class })
	private String emailContacto;
	
	private Long idClienteRemRepresentante;
	
	private Long idClienteContacto;
	
	
	public String getCodTipoPersona() {
		return codTipoPersona;
	}
	public void setCodTipoPersona(String codTipoPersona) {
		this.codTipoPersona = codTipoPersona;
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
	public Date getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public Long getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(Long idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
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
	public Long getIdProveedorRemPrescriptor() {
		return idProveedorRemPrescriptor;
	}
	public void setIdProveedorRemPrescriptor(Long idProveedorRemPrescriptor) {
		this.idProveedorRemPrescriptor = idProveedorRemPrescriptor;
	}
	public Long getIdProveedorRemResponsable() {
		return idProveedorRemResponsable;
	}
	public void setIdProveedorRemResponsable(Long idProveedorRemResponsable) {
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
	public String getCodPedania() {
		return codPedania;
	}
	public void setCodPedania(String codPedania) {
		this.codPedania = codPedania;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Boolean getRechazaPublicidad() {
		return rechazaPublicidad;
	}
	public void setRechazaPublicidad(Boolean rechazaPublicidad) {
		this.rechazaPublicidad = rechazaPublicidad;
	}
	public String getIdClienteSalesforce() {
		return idClienteSalesforce;
	}
	public void setIdClienteSalesforce(String idClienteSalesforce) {
		this.idClienteSalesforce = idClienteSalesforce;
	}
	public String getTelefonoContactoVisitas() {
		return telefonoContactoVisitas;
	}
	public void setTelefonoContactoVisitas(String telefonoContactoVisitas) {
		this.telefonoContactoVisitas = telefonoContactoVisitas;
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
	public String getCodPais() {
		return codPais;
	}
	public void setCodPais(String codPais) {
		this.codPais = codPais;
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
	public String getCodOcupacion() {
		return codOcupacion;
	}
	public void setCodOcupacion(String codOcupacion) {
		this.codOcupacion = codOcupacion;
	}
	public String getNombreRepresentante() {
		return nombreRepresentante;
	}
	public void setNombreRepresentante(String nombreRepresentante) {
		this.nombreRepresentante = nombreRepresentante;
	}
	public String getApellidosRepresentante() {
		return apellidosRepresentante;
	}
	public void setApellidosRepresentante(String apellidosRepresentante) {
		this.apellidosRepresentante = apellidosRepresentante;
	}
	public String getTelefonoRepresentante() {
		return telefonoRepresentante;
	}
	public void setTelefonoRepresentante(String telefonoRepresentante) {
		this.telefonoRepresentante = telefonoRepresentante;
	}
	public String getEmailRepresentante() {
		return emailRepresentante;
	}
	public void setEmailRepresentante(String emailRepresentante) {
		this.emailRepresentante = emailRepresentante;
	}
	public String getNombreContacto() {
		return nombreContacto;
	}
	public void setNombreContacto(String nombreContacto) {
		this.nombreContacto = nombreContacto;
	}
	public String getApellidosContacto() {
		return apellidosContacto;
	}
	public void setApellidosContacto(String apellidosContacto) {
		this.apellidosContacto = apellidosContacto;
	}
	public String getCodTipoDocumentoContacto() {
		return codTipoDocumentoContacto;
	}
	public void setCodTipoDocumentoContacto(String codTipoDocumentoContacto) {
		this.codTipoDocumentoContacto = codTipoDocumentoContacto;
	}
	public String getDocumentoContacto() {
		return documentoContacto;
	}
	public void setDocumentoContacto(String documentoContacto) {
		this.documentoContacto = documentoContacto;
	}
	public String getTelefonoContacto() {
		return telefonoContacto;
	}
	public void setTelefonoContacto(String telefonoContacto) {
		this.telefonoContacto = telefonoContacto;
	}
	public String getEmailContacto() {
		return emailContacto;
	}
	public void setEmailContacto(String emailContacto) {
		this.emailContacto = emailContacto;
	}
	public Long getIdClienteRemRepresentante() {
		return idClienteRemRepresentante;
	}
	public void setIdClienteRemRepresentante(Long idClienteRemRepresentante) {
		this.idClienteRemRepresentante = idClienteRemRepresentante;
	}
	public Long getIdClienteContacto() {
		return idClienteContacto;
	}
	public void setIdClienteContacto(Long idClienteContacto) {
		this.idClienteContacto = idClienteContacto;
	}
}
