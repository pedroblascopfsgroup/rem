package es.pfsgroup.plugin.recovery.config.delegaciones.dto;

import es.capgemini.devon.dto.WebDto;



public class DelegacionFiltrosBusquedaDto extends WebDto{

	private static final long serialVersionUID = 1255504419542683443L;


	private Long id;
	private Long usuarioOrigen;
	private Long usuarioDestino;
	private String fechaDesdeIniVigencia;
	private String fechaHastaIniVigencia;
	private String fechaDesdeFinVigencia;
	private String fechaHastaFinVigencia;
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
	
	public String getFechaDesdeIniVigencia() {
		return fechaDesdeIniVigencia;
	}
	public void setFechaDesdeIniVigencia(String fechaDesdeIniVigencia) {
		this.fechaDesdeIniVigencia = fechaDesdeIniVigencia;
	}
	
	public String getFechaHastaIniVigencia() {
		return fechaHastaIniVigencia;
	}
	public void setFechaHastaIniVigencia(String fechaHastaIniVigencia) {
		this.fechaHastaIniVigencia = fechaHastaIniVigencia;
	}
	
	public String getFechaDesdeFinVigencia() {
		return fechaDesdeFinVigencia;
	}
	public void setFechaDesdeFinVigencia(String fechaDesdeFinVigencia) {
		this.fechaDesdeFinVigencia = fechaDesdeFinVigencia;
	}
	
	public String getFechaHastaFinVigencia() {
		return fechaHastaFinVigencia;
	}
	public void setFechaHastaFinVigencia(String fechaHastaFinVigencia) {
		this.fechaHastaFinVigencia = fechaHastaFinVigencia;
	}
	
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	
}
