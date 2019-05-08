package es.pfsgroup.plugin.rem.comisionamiento.dto;

import java.util.ArrayList;
import org.codehaus.jackson.annotate.JsonIgnoreProperties;
import antlr.collections.List;

@JsonIgnoreProperties(ignoreUnknown = true)
public class RespuestaComisionResultDto {
	private String amount;
	//private String[] rule;
	
	public RespuestaComisionResultDto() {
		
	}
	
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
//	public String[] getRule() {
//		return rule;
//	}
//	public void setRule(String[] rule) {
//		this.rule = rule;
//	}
	
}
