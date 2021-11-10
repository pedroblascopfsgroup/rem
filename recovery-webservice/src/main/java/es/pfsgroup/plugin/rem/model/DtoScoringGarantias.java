package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoScoringGarantias extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String resultadoScoringHaya;
    private Date fechaSancScoring;
	private String motivoRechazo;
	private String numExpediente;
	private String ratingHaya;
	
	
	public String getResultadoScoringHaya() {
		return resultadoScoringHaya;
	}
	public void setResultadoScoringHaya(String resultadoScoringHaya) {
		this.resultadoScoringHaya = resultadoScoringHaya;
	}
	public Date getFechaSancScoring() {
		return fechaSancScoring;
	}
	public void setFechaSancScoring(Date fechaSancScoring) {
		this.fechaSancScoring = fechaSancScoring;
	}
	public String getMotivoRechazo() {
		return motivoRechazo;
	}
	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	public String getNumExpediente() {
		return numExpediente;
	}
	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}
	public String getRatingHaya() {
		return ratingHaya;
	}
	public void setRatingHaya(String ratingHaya) {
		this.ratingHaya = ratingHaya;
	}
	
	
	
}
