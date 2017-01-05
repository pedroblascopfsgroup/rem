package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;




/**
 * Dto para carga de datasource de visitas del informe propuesta
 * @author Anahuac de Vicente
 *
 */
public class DtoVisita extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String numVisita;
	private String numActivo;
	private String fechaSolicitud;	
	private String fechaVisita;
	private String solicitante;
	private String nifSolicitante;
	private String telefonoSolicitante;
	private String emailSolicitante;
	private String fechaContactoCliente;
	private String situacionVisita;
	
	
	
	public String getNumVisita() {
		return numVisita;
	}
	public void setNumVisita(String numVisita) {
		this.numVisita = numVisita;
	}
	public String getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}
	public String getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(String fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public String getFechaVisita() {
		return fechaVisita;
	}
	public void setFechaVisita(String fechaVisita) {
		this.fechaVisita = fechaVisita;
	}
	public String getSolicitante() {
		return solicitante;
	}
	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}
	public String getNifSolicitante() {
		return nifSolicitante;
	}
	public void setNifSolicitante(String nifSolicitante) {
		this.nifSolicitante = nifSolicitante;
	}
	public String getTelefonoSolicitante() {
		return telefonoSolicitante;
	}
	public void setTelefonoSolicitante(String telefonoSolicitante) {
		this.telefonoSolicitante = telefonoSolicitante;
	}
	public String getEmailSolicitante() {
		return emailSolicitante;
	}
	public void setEmailSolicitante(String emailSolicitante) {
		this.emailSolicitante = emailSolicitante;
	}
	public String getFechaContactoCliente() {
		return fechaContactoCliente;
	}
	public void setFechaContactoCliente(String fechaContactoCliente) {
		this.fechaContactoCliente = fechaContactoCliente;
	}
	public String getSituacionVisita() {
		return situacionVisita;
	}
	public void setSituacionVisita(String situacionVisita) {
		this.situacionVisita = situacionVisita;
	}
	
	
}