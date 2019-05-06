package es.pfsgroup.plugin.rem.comisionamiento.dto;

import java.util.ArrayList;

import antlr.collections.List;

public class RespuestaComisionResultDto {
	private String amount;
	private ArrayList<RespuestaComisionReglaDto> rule;
	
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public ArrayList<RespuestaComisionReglaDto> getRule() {
		return rule;
	}
	public void setRule(ArrayList<RespuestaComisionReglaDto> rule) {
		this.rule = rule;
	}
	
}
