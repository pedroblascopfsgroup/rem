package es.pfsgroup.plugin.recovery.config.delegaciones.dto;

import es.capgemini.devon.dto.WebDto;



public class DelegacionDto extends WebDto{

	private static final long serialVersionUID = 1255504419542683443L;


	private Long id;
	private Long usuarioOrigen;
	private Long usuarioDestino;
	private String fechaIniVigencia;
	private String fechaFinVigencia;
	private String estado;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	public Long getUsuarioOrigen() {
		return usuarioOrigen;
	}
	public void setUsuarioOrigen(Long usuarioOrigen) {
		this.usuarioOrigen = usuarioOrigen;
	}
	
	public Long getUsuarioDestino() {
		return usuarioDestino;
	}
	public void setUsuarioDestino(Long usuarioDestino) {
		this.usuarioDestino = usuarioDestino;
	}
	
	public String getFechaIniVigencia() {
		return fechaIniVigencia;
	}
	public void setFechaIniVigencia(String fechaIniVigencia) {
		this.fechaIniVigencia = fechaIniVigencia;
	}
	
	public String getFechaFinVigencia() {
		return fechaFinVigencia;
	}
	public void setFechaFinVigencia(String fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}
	
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	
}
