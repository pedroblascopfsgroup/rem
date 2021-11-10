package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;




/**
 * Dto para el listado de propietarios de los activos
 * @author Anahuac de Vicente
 *
 */
public class DtoPropietario extends WebDto {

	private static final long serialVersionUID = 0L;

	
	private long id;
	private String idActivo;
	private String idPropietario;
	private Float porcPropiedad;
	private String tipoGradoPropiedadDescripcion;
	private String localidadDescripcion;
	private String provinciaDescripcion;
	private String tipoPersonaDescripcion;
	private String localidadContactoDescripcion;
	private String provinciaContactoDescripcion;
	private String codigo;
	private String nombre;
	private String apellido1;
	private String apellido2;
	private String nombreCompleto;
	private String docIdentificativo;
	private String direccion;
	private String telefono; 
	private String email;
	private String codigoPostal;
	private String nombreContacto;
	private String telefono1Contacto;
	private String telefono2Contacto;
	private String emailContacto; 
	private String direccionContacto;
	private String codigoPostalContacto;
	private String observaciones;
	private String tipoDocIdentificativoDesc;
	private String tipoPropietario;
	private String localidadCodigo;
	private String tipoGradoPropiedadCodigo;
	private String provinciaCodigo;
	private String tipoPersonaCodigo;
	private String tipoDocIdentificativoCodigo;
	private String provinciaContactoCodigo;
	private String localidadContactoCodigo;
	private String descripcion;
	private Integer anyoConcesion;	
	private Date fechaFinConcesion;
	
	
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	public String getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}
	public String getIdPropietario() {
		return idPropietario;
	}
	public void setIdPropietario(String idPropietario) {
		this.idPropietario = idPropietario;
	}
	public Float getPorcPropiedad() {
		return porcPropiedad;
	}
	public void setPorcPropiedad(Float porcPropiedad) {
		this.porcPropiedad = porcPropiedad;
	}
	public String getTipoGradoPropiedadDescripcion() {
		return tipoGradoPropiedadDescripcion;
	}
	public void setTipoGradoPropiedadDescripcion(
			String tipoGradoPropiedadDescripcion) {
		this.tipoGradoPropiedadDescripcion = tipoGradoPropiedadDescripcion;
	}
	public String getLocalidadDescripcion() {
		return localidadDescripcion;
	}
	public void setLocalidadDescripcion(String localidadDescripcion) {
		this.localidadDescripcion = localidadDescripcion;
	}
	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}
	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}
	public String getTipoPersonaDescripcion() {
		return tipoPersonaDescripcion;
	}
	public void setTipoPersonaDescripcion(String tipoPersonaDescripcion) {
		this.tipoPersonaDescripcion = tipoPersonaDescripcion;
	}
	public String getLocalidadContactoDescripcion() {
		return localidadContactoDescripcion;
	}
	public void setLocalidadContactoDescripcion(String localidadContactoDescripcion) {
		this.localidadContactoDescripcion = localidadContactoDescripcion;
	}
	public String getProvinciaContactoDescripcion() {
		return provinciaContactoDescripcion;
	}
	public void setProvinciaContactoDescripcion(String provinciaContactoDescripcion) {
		this.provinciaContactoDescripcion = provinciaContactoDescripcion;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getTipoDocIdentificativoDesc() {
		return tipoDocIdentificativoDesc;
	}
	public void setTipoDocIdentificativoDesc(String tipoDocIdentificativoDesc) {
		this.tipoDocIdentificativoDesc = tipoDocIdentificativoDesc;
	}
	public String getDocIdentificativo() {
		return docIdentificativo;
	}
	public void setDocIdentificativo(String docIdentificativo) {
		this.docIdentificativo = docIdentificativo;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
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
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getNombreContacto() {
		return nombreContacto;
	}
	public void setNombreContacto(String nombreContacto) {
		this.nombreContacto = nombreContacto;
	}
	public String getTelefono1Contacto() {
		return telefono1Contacto;
	}
	public void setTelefono1Contacto(String telefono1Contacto) {
		this.telefono1Contacto = telefono1Contacto;
	}
	public String getTelefono2Contacto() {
		return telefono2Contacto;
	}
	public void setTelefono2Contacto(String telefono2Contacto) {
		this.telefono2Contacto = telefono2Contacto;
	}
	public String getEmailContacto() {
		return emailContacto;
	}
	public void setEmailContacto(String emailContacto) {
		this.emailContacto = emailContacto;
	}
	public String getDireccionContacto() {
		return direccionContacto;
	}
	public void setDireccionContacto(String direccionContacto) {
		this.direccionContacto = direccionContacto;
	}
	public String getCodigoPostalContacto() {
		return codigoPostalContacto;
	}
	public void setCodigoPostalContacto(String codigoPostalContacto) {
		this.codigoPostalContacto = codigoPostalContacto;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getApellido1() {
		return apellido1;
	}
	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}
	public String getApellido2() {
		return apellido2;
	}
	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getTipoPropietario() {
		return tipoPropietario;
	}
	public void setTipoPropietario(String tipoPropietario) {
		this.tipoPropietario = tipoPropietario;
	}
	public String getLocalidadCodigo() {
		return localidadCodigo;
	}
	public void setLocalidadCodigo(String localidadCodigo) {
		this.localidadCodigo = localidadCodigo;
	}
	public String getTipoGradoPropiedadCodigo() {
		return tipoGradoPropiedadCodigo;
	}
	public void setTipoGradoPropiedadCodigo(String tipoGradoPropiedadCodigo) {
		this.tipoGradoPropiedadCodigo = tipoGradoPropiedadCodigo;
	}
	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}
	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}
	public String getTipoPersonaCodigo() {
		return tipoPersonaCodigo;
	}
	public void setTipoPersonaCodigo(String tipoPersonaCodigo) {
		this.tipoPersonaCodigo = tipoPersonaCodigo;
	}
	public String getTipoDocIdentificativoCodigo() {
		return tipoDocIdentificativoCodigo;
	}
	public void setTipoDocIdentificativoCodigo(String tipoDocIdentificativoCodigo) {
		this.tipoDocIdentificativoCodigo = tipoDocIdentificativoCodigo;
	}
	public String getProvinciaContactoCodigo() {
		return provinciaContactoCodigo;
	}
	public void setProvinciaContactoCodigo(String provinciaContactoCodigo) {
		this.provinciaContactoCodigo = provinciaContactoCodigo;
	}
	public String getLocalidadContactoCodigo() {
		return localidadContactoCodigo;
	}
	public void setLocalidadContactoCodigo(String localidadContactoCodigo) {
		this.localidadContactoCodigo = localidadContactoCodigo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Integer getAnyoConcesion() {
		return anyoConcesion;
	}
	public void setAnyoConcesion(Integer anyoConcesion) {
		this.anyoConcesion = anyoConcesion;
	}
	public Date getFechaFinConcesion() {
		return fechaFinConcesion;
	}
	public void setFechaFinConcesion(Date fechaFinConcesion) {
		this.fechaFinConcesion = fechaFinConcesion;
	}
	
	
}