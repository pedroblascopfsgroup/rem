package es.pfsgroup.recovery.recobroCommon.facturacion.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroModeloFacturacionTramoCorrectorDto extends WebDto{

	private static final long serialVersionUID = -5768135316322384957L;
	
	private Long idModFact;
	
	private Long idTramoCorrector;
	
	private Integer rankingPosicion;
	
	private Float objetivoInicio;
	
	private Float objetivoFin;
	
	private Float coeficiente;

	public Long getIdModFact() {
		return idModFact;
	}

	public void setIdModFact(Long idModFact) {
		this.idModFact = idModFact;
	}

	public Integer getRankingPosicion() {
		return rankingPosicion;
	}

	public void setRankingPosicion(Integer rankingPosicion) {
		this.rankingPosicion = rankingPosicion;
	}

	public Float getObjetivoInicio() {
		return objetivoInicio;
	}

	public void setObjetivoInicio(Float objetivoInicio) {
		this.objetivoInicio = objetivoInicio;
	}

	public Float getObjetivoFin() {
		return objetivoFin;
	}

	public void setObjetivoFin(Float objetivoFin) {
		this.objetivoFin = objetivoFin;
	}

	public Float getCoeficiente() {
		return coeficiente;
	}

	public void setCoeficiente(Float coeficiente) {
		this.coeficiente = coeficiente;
	}

	public Long getIdTramoCorrector() {
		return idTramoCorrector;
	}

	public void setIdTramoCorrector(Long idTramoCorrector) {
		this.idTramoCorrector = idTramoCorrector;
	}
	
}
