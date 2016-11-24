package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para datos de contacto de un notario en formacion > posicionamiento
 * 
 * @author Bender
 * 
 */
public class DtoNotarioContacto extends WebDto {
	
	private static final long serialVersionUID = 10992122201349110L;

	// Datos Notario: Nombre, Dirección, Persona de contacto, Cargo, Teléfono y Email.
	// "nombre" y "dirección" del proveedor y el resto de datos de los proveedores contacto
	
	// Poner datos de ActivoProveedor
	private Long id;
	private String codigo;
	private String nombreProveedor;
	private String direccion;
	
	// Poner datos de ActivoProveedorContacto
	private Long idContacto;
	private Integer principal;
	private String personaContacto;
	private String cargo;
	private String provincia;
	private String localidad;
	private String codigoPostal;
	private String telefono1;
	private String telefono2;
	private String fax;
	private String email;

	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public Long getIdContacto() {
		return idContacto;
	}
	public void setIdContacto(Long idContacto) {
		this.idContacto = idContacto;
	}
	public Integer getPrincipal() {
		return principal;
	}
	public void setPrincipal(Integer principal) {
		this.principal = principal;
	}
	public String getPersonaContacto() {
		return personaContacto;
	}
	public void setPersonaContacto(String personaContacto) {
		this.personaContacto = personaContacto;
	}
	public String getCargo() {
		return cargo;
	}
	public void setCargo(String cargo) {
		this.cargo = cargo;
	}
	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getLocalidad() {
		return localidad;
	}
	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
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
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}

}