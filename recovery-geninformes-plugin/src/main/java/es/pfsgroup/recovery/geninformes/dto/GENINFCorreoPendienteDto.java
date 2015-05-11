package es.pfsgroup.recovery.geninformes.dto;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.recovery.geninformes.model.GENINFCorreoPendiente;

public class GENINFCorreoPendienteDto {

	private String destinatario;
	private String emailFrom;
	private String asuntoMail;
	private String cuerpoEmail;
	private FileItem adjunto;
	private String nombreAdjunto;

	public String getDestinatario() {
		return destinatario;
	}
	public void setDestinatario(String destinatario) {
		this.destinatario = destinatario;
	}
	public String getEmailFrom() {
		return emailFrom;
	}
	public void setEmailFrom(String emailFrom) {
		this.emailFrom = emailFrom;
	}
	public String getAsuntoMail() {
		return asuntoMail;
	}
	public void setAsuntoMail(String asuntoMail) {
		this.asuntoMail = asuntoMail;
	}
	public String getCuerpoEmail() {
		return cuerpoEmail;
	}
	public void setCuerpoEmail(String cuerpoEmail) {
		this.cuerpoEmail = cuerpoEmail;
	}
	public FileItem getAdjunto() {
		return adjunto;
	}
	public void setAdjunto(FileItem adjunto) {
		this.adjunto = adjunto;
	}
	public String getNombreAdjunto() {
		return nombreAdjunto;
	}
	public void setNombreAdjunto(String nombreAdjunto) {
		this.nombreAdjunto = nombreAdjunto;
	}
	
	public void populateDto(GENINFCorreoPendiente correoPendiente) {
		
		destinatario = correoPendiente.getTo();
		emailFrom = correoPendiente.getFrom();
		asuntoMail = correoPendiente.getAsunto();
		cuerpoEmail = correoPendiente.getCuerpo();
		nombreAdjunto = correoPendiente.getNombre();

	}
}
