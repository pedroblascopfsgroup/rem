package es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.dto;

import es.capgemini.devon.dto.WebDto;

public class BPRDtoGestorAUsuario extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2492724362417947066L;
	
	private Long id;
	private String usuario;
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getUsuario() {
		return usuario;
	}
	

}
