package es.pfsgroup.recovery.gestionClientes;

import es.capgemini.devon.dto.WebDto;

public class GestionClientesBusquedaDTO extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String nif; 
	private String nombre;
	private String apellidos; 
	private String codigoContrato;
	
	/**
	 * @return the nif
	 */
	public String getNif() {
		return nif;
	}
	
	/**
	 * @param nif the nif to set
	 */
	public void setNif(String nif) {
		this.nif = nif;
	}
	
	/**
	 * @return the nombre
	 */
	public String getNombre() {
		return nombre;
	}
	
	/**
	 * @param nombre the nombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	/**
	 * @return the apellidos
	 */
	public String getApellidos() {
		return apellidos;
	}

	/**
	 * @param apellidos the apellidos to set
	 */
	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}

	/**
	 * @return the codigoContrato
	 */
	public String getCodigoContrato() {
		return codigoContrato;
	}

	/**
	 * @param codigoContrato the codigoContrato to set
	 */
	public void setCodigoContrato(String codigoContrato) {
		this.codigoContrato = codigoContrato;
	}

}
