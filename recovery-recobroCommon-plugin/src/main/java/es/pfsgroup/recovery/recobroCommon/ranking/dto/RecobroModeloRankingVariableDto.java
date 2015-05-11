package es.pfsgroup.recovery.recobroCommon.ranking.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroModeloRankingVariableDto extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -85304062605393923L;
	private Long idVariable;
	private Long idModelo;
	private String tipoVariable;
	private Float coeficiente;
	public Long getIdVariable() {
		return idVariable;
	}
	public void setIdVariable(Long idVariable) {
		this.idVariable = idVariable;
	}
	public Long getIdModelo() {
		return idModelo;
	}
	public void setIdModelo(Long idModelo) {
		this.idModelo = idModelo;
	}
	public String getTipoVariable() {
		return tipoVariable;
	}
	public void setTipoVariable(String tipoVariable) {
		this.tipoVariable = tipoVariable;
	}
	public Float getCoeficiente() {
		return coeficiente;
	}
	public void setCoeficiente(Float coeficiente) {
		this.coeficiente = coeficiente;
	}
	
	

}
