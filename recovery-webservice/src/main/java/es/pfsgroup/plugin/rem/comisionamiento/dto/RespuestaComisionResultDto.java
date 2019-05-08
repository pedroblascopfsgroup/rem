package es.pfsgroup.plugin.rem.comisionamiento.dto;

import java.util.ArrayList;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import antlr.collections.List;

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
