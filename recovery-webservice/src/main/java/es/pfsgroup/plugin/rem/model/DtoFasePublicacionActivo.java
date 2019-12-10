package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoFasePublicacionActivo extends WebDto{
	
	private Long idActivo;
	private String fasePublicacionCodigo;
	private String subfasePublicacionCodigo;
	private String comentario;
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getFasePublicacionCodigo() {
		return fasePublicacionCodigo;
	}
	public void setFasePublicacionCodigo(String fasePublicacionCodigo) {
		this.fasePublicacionCodigo = fasePublicacionCodigo;
	}
	public String getSubfasePublicacionCodigo() {
		return subfasePublicacionCodigo;
	}
	public void setSubfasePublicacionCodigo(String subfasePublicacionCodigo) {
		this.subfasePublicacionCodigo = subfasePublicacionCodigo;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
}
