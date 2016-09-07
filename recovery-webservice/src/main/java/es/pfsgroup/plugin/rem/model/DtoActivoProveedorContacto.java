package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los proveedores contactos del expediente.
 *  
 * @author Luis Caballero
 *
 */
public class DtoActivoProveedorContacto extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idActivoProveedorContacto;
	private String nombre;
	private String direccion;
	private String personaContacto;
	private String cargo;
	private String telefono;
	private String email;
	private String usuario;
	private String provincia;
	private String tipoDocIdentificativo;
	private String docIdentificativo;
	private Integer codigoPostal;
	private String fax;
	private String telefono2;
	
	
	public Long getIdActivoProveedorContacto() {
		return idActivoProveedorContacto;
	}
	public void setIdActivoProveedorContacto(Long idActivoProveedorContacto) {
		this.idActivoProveedorContacto = idActivoProveedorContacto;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
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
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getTipoDocIdentificativo() {
		return tipoDocIdentificativo;
	}
	public void setTipoDocIdentificativo(String tipoDocIdentificativo) {
		this.tipoDocIdentificativo = tipoDocIdentificativo;
	}
	public String getDocIdentificativo() {
		return docIdentificativo;
	}
	public void setDocIdentificativo(String docIdentificativo) {
		this.docIdentificativo = docIdentificativo;
	}
	public Integer getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(Integer codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	public String getTelefono2() {
		return telefono2;
	}
	public void setTelefono2(String telefono2) {
		this.telefono2 = telefono2;
	}

   		
}
