package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro gestores
 * @author Luis Caballero
 *
 */
public class DtoReasignarTarea extends WebDto {

	private static final long serialVersionUID = 0L;
	private Long idTarea;
	private Long usuarioGestor;
	private Long usuarioSupervisor;
	public Long getIdTarea() {
		return idTarea;
	}
	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}
	public Long getUsuarioGestor() {
		return usuarioGestor;
	}
	public void setUsuarioGestor(Long usuarioGestor) {
		this.usuarioGestor = usuarioGestor;
	}
	public Long getUsuarioSupervisor() {
		return usuarioSupervisor;
	}
	public void setUsuarioSupervisor(Long usuarioSupervisor) {
		this.usuarioSupervisor = usuarioSupervisor;
	}
	
}