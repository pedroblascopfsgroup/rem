package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los comparecientes de un expediente.
 *  
 * @author Luis Caballero
 *
 */
public class DtoComparecienteVendedor extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idComparecienteVendedor;
	private String tipoCompareciente;
	private String nombre;
	private String direccion;
	private String telefono;
	private String email;
	
	
	public Long getIdComparecienteVendedor() {
		return idComparecienteVendedor;
	}
	public void setIdComparecienteVendedor(Long idComparecienteVendedor) {
		this.idComparecienteVendedor = idComparecienteVendedor;
	}
	public String getTipoCompareciente() {
		return tipoCompareciente;
	}
	public void setTipoCompareciente(String tipoCompareciente) {
		this.tipoCompareciente = tipoCompareciente;
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
	
	
	
	
	
	
   	
   	
}
