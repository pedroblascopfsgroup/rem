package es.pfsgroup.plugin.recovery.itinerarios.gestorDespacho.dto;

import es.capgemini.devon.dto.WebDto;

public class ITIDtoGestorAUsuario extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7367651560161533574L;
	
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
