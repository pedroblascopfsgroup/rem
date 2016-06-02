package es.pfsgroup.plugin.recovery.config.delegaciones.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.config.delegaciones.model.DDEstadoDelegaciones;



public class DelegacionBusquedaDto extends WebDto{

	private static final long serialVersionUID = 1255504419542683443L;


	private Long id;
	private Usuario usuarioOrigen;
	private Usuario usuarioDestino;
	private Date fechaIniVigencia;
	private Date fechaFinVigencia;
	private String usuarioCrear;
	private Date fechaCrear;
	private DDEstadoDelegaciones estado;
	

	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Usuario getUsuarioOrigen() {
		return usuarioOrigen;
	}
	public void setUsuarioOrigen(Usuario usuarioOrigen) {
		this.usuarioOrigen = usuarioOrigen;
	}
	public Usuario getUsuarioDestino() {
		return usuarioDestino;
	}
	public void setUsuarioDestino(Usuario usuarioDestino) {
		this.usuarioDestino = usuarioDestino;
	}
	public Date getFechaIniVigencia() {
		return fechaIniVigencia;
	}
	public void setFechaIniVigencia(Date fechaIniVigencia) {
		this.fechaIniVigencia = fechaIniVigencia;
	}
	public Date getFechaFinVigencia() {
		return fechaFinVigencia;
	}
	public void setFechaFinVigencia(Date fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}
	public String getUsuarioCrear() {
		return usuarioCrear;
	}
	public void setUsuarioCrear(String usuarioCrear) {
		this.usuarioCrear = usuarioCrear;
	}
	public Date getFechaCrear() {
		return fechaCrear;
	}
	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}
	public DDEstadoDelegaciones getEstado() {
		return estado;
	}
	public void setEstado(DDEstadoDelegaciones estado) {
		this.estado = estado;
	}
	
}
