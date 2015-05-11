package es.pfsgroup.plugin.recovery.config.usuarios.dto;

import java.io.Serializable;

import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Representación de los grupos de usuario para se utilizada como combo
 * @author Guillem
 *
 */
public class ADMDiccionarioGrupoUsuario implements Dictionary, Serializable{
	
	/**
	 * SERIAL UID
	 */
	private static final long serialVersionUID = 8339182530004446123L;

	public Long id;
	
	public String codigo;
	
	public String descripcion;
	
	public String descripcionLarga;
	
	public Long idusuario;
	
	public Long grupo;

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

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public Long getIdusuario() {
		return idusuario;
	}

	public void setIdusuario(Long idusuario) {
		this.idusuario = idusuario;
	}

	public Long getGrupo() {
		return grupo;
	}

	public void setGrupo(Long grupo) {
		this.grupo = grupo;
	}	
	
}
