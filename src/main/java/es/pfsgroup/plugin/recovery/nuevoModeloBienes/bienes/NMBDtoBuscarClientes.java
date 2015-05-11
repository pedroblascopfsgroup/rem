package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes;

import es.capgemini.devon.dto.WebDto;

/**
 * Clase que transfiere informaciï¿½n desde la vista hacia el modelo.
 * @author Sergio Alarcón
 *
 */
public class NMBDtoBuscarClientes extends WebDto {

    private static final long serialVersionUID = 6015680735564006220L;

    private Long entidad;
    
    private String docId;
    
    private String nombre;
    
    private String apellido1;
    
    private String apellido2;

	public Long getEntidad() {
		return entidad;
	}

	public void setEntidad(Long entidad) {
		this.entidad = entidad;
	}

	public String getDocId() {
		return docId;
	}

	public void setDocId(String docId) {
		this.docId = docId;
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
    
    
    	
}