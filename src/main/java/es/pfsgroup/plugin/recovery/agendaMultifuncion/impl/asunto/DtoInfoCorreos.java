package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.asunto;

import java.util.Date;

public class DtoInfoCorreos {
	
	private String emisor;
	private String destinatario;
	private String asunto;
	private Date fechaEnvio;
	private String texto;
	
	public DtoInfoCorreos(String emisor, String destinatario, String asunto, Date fechaEnvio, String texto) {
		this.emisor = emisor;
		this.destinatario = destinatario;
		this.asunto = asunto;
		this.fechaEnvio = fechaEnvio;
		this.texto = texto;
	}
	public String getEmisor() {
		return emisor;
	}
	public String getDestinatario() {
		return destinatario;
	}
	public String getAsunto() {
		return asunto;
	}
	public Date getFechaEnvio() {
		return fechaEnvio;
	}
	public String getTexto() {
		return texto;
	}	
}
