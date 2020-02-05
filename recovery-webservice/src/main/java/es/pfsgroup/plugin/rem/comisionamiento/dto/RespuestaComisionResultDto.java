package es.pfsgroup.plugin.rem.comisionamiento.dto;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class RespuestaComisionResultDto {
	private Double commissionAmount;
	private Double maxCommissionAmount;
	private Double minCommissionAmount ;

	public RespuestaComisionResultDto() {
		
	}
	
	public Double getCommissionAmount() {
		return commissionAmount;
	}
	public void setCommissionAmount(Double commissionAmount) {
		this.commissionAmount = commissionAmount;
	}

	public Double getMaxCommissionAmount() {
		return maxCommissionAmount;
	}

	public void setMaxCommissionAmount(Double maxCommissionAmount) {
		this.maxCommissionAmount = maxCommissionAmount;
	}

	public Double getMinCommissionAmount() {
		return minCommissionAmount;
	}

	public void setMinCommissionAmount(Double minCommissionAmount) {
		this.minCommissionAmount = minCommissionAmount;
	}
	
}
