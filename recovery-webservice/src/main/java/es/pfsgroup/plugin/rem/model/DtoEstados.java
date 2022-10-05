package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto que gestiona la informacion de las resoluciones del expediente.
 *  
 * @author Lara
 *
 */
public class DtoEstados {
    /**
	 * 
	 */
    private static final long serialVersionUID = 1L;
    

	private String codigoEstadoExpediente;
	private String codigoEstadoExpedienteBc;
	
	public String getCodigoEstadoExpediente() {
		return codigoEstadoExpediente;
	}
	public void setCodigoEstadoExpediente(String codigoEstadoExpediente) {
		this.codigoEstadoExpediente = codigoEstadoExpediente;
	}
	public String getCodigoEstadoExpedienteBc() {
		return codigoEstadoExpedienteBc;
	}
	public void setCodigoEstadoExpedienteBc(String codigoEstadoExpedienteBc) {
		this.codigoEstadoExpedienteBc = codigoEstadoExpedienteBc;
	}
	
	
	
}