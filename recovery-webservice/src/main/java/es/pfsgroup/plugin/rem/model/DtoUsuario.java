package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para mostrar usuarios
 * @author Daniel Gutiérrez
 *
 */
public class DtoUsuario extends WebDto implements Comparable<DtoUsuario>{

	private static final long serialVersionUID = 0L;

	private Long id;
	
	private String apellidoNombre;
	
	private Boolean usuarioGrupo;
	
	public Long getId() {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getApellidoNombre() {
		return apellidoNombre;
	}
	
	public void setApellidoNombre(String apellidoNombre) {
		this.apellidoNombre = apellidoNombre;
	}

	public Boolean getUsuarioGrupo() {
		return usuarioGrupo;
	}

	public void setUsuarioGrupo(Boolean usuarioGrupo) {
		this.usuarioGrupo = usuarioGrupo;
	}
	
	@Override
	public int compareTo(DtoUsuario o) {
		int resultado = 0;
		if((this.getUsuarioGrupo() && o.getUsuarioGrupo())){
			resultado= this.getApellidoNombre().compareTo(o.getApellidoNombre());
		}
		else{
			if(this.getUsuarioGrupo() || o.getUsuarioGrupo()){
				resultado= o.getUsuarioGrupo().compareTo(this.getUsuarioGrupo());
			}
			else{
				resultado= this.getApellidoNombre().compareTo(o.getApellidoNombre());
			}
		}
		return resultado;
	}
	
}