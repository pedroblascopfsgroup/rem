package es.capgemini.pfs.asunto.dto;

import java.util.Date;

import es.pfsgroup.commons.utils.Checks;

public class DtoReportInstrucciones {

	private static final long serialVersionUID = 1L;
	private Date fecha;
	private String texto;
	
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public String getTexto() {
		return texto;
	}
	public void setTexto(String texto) {
		this.texto = texto;
	}

	/**
	 * Texto sin formato HTML
	 * 
	 * @return
	 */
	public String getTextoSinHTML() {
		if (Checks.esNulo(this.texto)) return this.texto;
		String cleanText = this.texto.replaceAll("(<\\/p.*?>)", "$1\n");
		cleanText = cleanText.replaceAll("<br.*?>", "\n");
		cleanText = cleanText.replaceAll("<[^>]*>", "");
		return cleanText;
	}
	
}
