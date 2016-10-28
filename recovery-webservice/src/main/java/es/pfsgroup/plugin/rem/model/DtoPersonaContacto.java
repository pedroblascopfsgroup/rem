package es.pfsgroup.plugin.rem.model;


import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de Datos de Contacto > Personas Contactos de la ficha proveedor.
 */
public class DtoPersonaContacto extends WebDto {
	private static final long serialVersionUID = 0L;

	private String id;
	private String proveedorID;
	private int personaPrincipal;
	private String nombre;
	private String apellido1;
	private String apellido2;
	private String cargoCombobox;
	private String cargoTexto;
	private String nif;
	private String codigoUsuario;
	private String telefono;
	private String email;
	private String direccion;
	private String delegacion;
	private Date fechaAlta;
	private Date fechaBaja;
	private String observaciones;
	private int totalCount;
	
	
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public int getPersonaPrincipal() {
		return personaPrincipal;
	}
	public void setPersonaPrincipal(int personaPrincipal) {
		this.personaPrincipal = personaPrincipal;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
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
	public String getCargoCombobox() {
		return cargoCombobox;
	}
	public void setCargoCombobox(String cargoCombobox) {
		this.cargoCombobox = cargoCombobox;
	}
	public String getCargoTexto() {
		return cargoTexto;
	}
	public void setCargoTexto(String cargoTexto) {
		this.cargoTexto = cargoTexto;
	}
	public String getNif() {
		return nif;
	}
	public void setNif(String nif) {
		this.nif = nif;
	}
	public String getCodigoUsuario() {
		return codigoUsuario;
	}
	public void setCodigoUsuario(String codigoUsuario) {
		this.codigoUsuario = codigoUsuario;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Date getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getProveedorID() {
		return proveedorID;
	}
	public void setIdEntidad(String idEntidad) {
		this.proveedorID = idEntidad;
	}
	public void setProveedorID(String proveedorID) {
		this.proveedorID = proveedorID;
	}
	public String getDelegacion() {
		return delegacion;
	}
	public void setDelegacion(String delegacion) {
		this.delegacion = delegacion;
	}
	
}