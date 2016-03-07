package es.pfsgroup.plugin.precontencioso.observacion.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;

public class ObservacionDTO extends WebDto {

	private static final long serialVersionUID = -1065448242120456270L;
	
	private Long id;
	private Long idProcedimientoPCO;
	private Date fechaAnotacion;
	private String textoAnotacion;
	private Integer secuenciaAnotacion;
	private String textoResumen;
	
	//Usuario
	private Long idUsuario;
	private String username;
	
	/*
	 * GETTERS & SETTERS
	 */
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdProcedimientoPCO() {
		return idProcedimientoPCO;
	}
	public void setIdProcedimientoPCO(Long idProcedimientoPCO) {
		this.idProcedimientoPCO = idProcedimientoPCO;
	}
	public Date getFechaAnotacion() {
		return fechaAnotacion;
	}
	public void setFechaAnotacion(Date fechaAnotacion) {
		this.fechaAnotacion = fechaAnotacion;
	}
	public String getTextoAnotacion() {
		return textoAnotacion;
	}
	public void setTextoAnotacion(String textoAnotacion) {
		this.textoAnotacion = textoAnotacion;
		if(!Checks.esNulo(textoAnotacion)) {
			if(textoAnotacion.length() > 50) {
				this.textoResumen = textoAnotacion.substring(0, 50) + "...";
			}
			else {
				this.textoResumen = textoAnotacion;
			}
		}
	}
	public Integer getSecuenciaAnotacion() {
		return secuenciaAnotacion;
	}
	public void setSecuenciaAnotacion(Integer secuenciaAnotacion) {
		this.secuenciaAnotacion = secuenciaAnotacion;
	}
	public Long getIdUsuario() {
		return idUsuario;
	}
	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getTextoResumen() {
		return textoResumen;
	}
	public void setTextoResumen(String textoResumen) {
		this.textoResumen = textoResumen;
	}
	
	
}
