package es.capgemini.pfs.usuario.dto;

import es.capgemini.devon.dto.WebDto;

public class EXTDtoUsuario extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8968920092027760003L;
	
	private Long codigo;
	private String descripcion;
	
	public void setCodigo(Long codigo) {
		this.codigo = codigo;
	}
	public Long getCodigo() {
		return codigo;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	

}
