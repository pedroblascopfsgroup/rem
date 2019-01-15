package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de las resoluciones del expediente.
 *  
 * @author Ivan Rubio
 *
 */
public class DtoExpedienteDocumentos extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8069190137997202586L;

	private Boolean docOk;
	private Date fechaValidacion;
	public Boolean getDocOk() {
		return docOk;
	}
	public void setDocOk(Boolean docOk) {
		this.docOk = docOk;
	}
	public Date getFechaValidacion() {
		return fechaValidacion;
	}
	public void setFechaValidacion(Date fechaValidacion) {
		this.fechaValidacion = fechaValidacion;
	}

}
