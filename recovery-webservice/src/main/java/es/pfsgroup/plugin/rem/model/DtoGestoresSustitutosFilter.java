package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoGestoresSustitutosFilter extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -113423286698687481L;

	private String id;
	private String usernameOrigen;
	private String usernameSustituto;
	private String nombreOrigen;
	private String nombreSustituto;
	private Date fechaInicio;
	private Date fechaFin;
	private Boolean vigente;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	public String getUsernameOrigen() {
		return usernameOrigen;
	}
	public void setUsernameOrigen(String usernameOrigen) {
		this.usernameOrigen = usernameOrigen;
	}
	public String getUsernameSustituto() {
		return usernameSustituto;
	}
	public void setUsernameSustituto(String usernameSustituto) {
		this.usernameSustituto = usernameSustituto;
	}
	public String getNombreOrigen() {
		return nombreOrigen;
	}
	public void setNombreOrigen(String nombreOrigen) {
		this.nombreOrigen = nombreOrigen;
	}
	public String getNombreSustituto() {
		return nombreSustituto;
	}
	public void setNombreSustituto(String nombreSustituto) {
		this.nombreSustituto = nombreSustituto;
	}
	public Boolean getVigente() {
		return vigente;
	}
	public void setVigente(Boolean vigente) {
		this.vigente = vigente;
	}
	public Date getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public Date getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}
}
