package es.pfsgroup.plugin.rem.comisionamiento.dto;

import org.codehaus.jackson.annotate.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class RespuestaComisionResultDto {
	private String amount;
	private RespuestaComisionReglaDto rule;
	
	public RespuestaComisionResultDto() {
		
	}
	
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public RespuestaComisionReglaDto getRule() {
		return rule;
	}
	public void setRule(RespuestaComisionReglaDto rule) {
		this.rule = rule;
	}
	
}
