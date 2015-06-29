package es.capgemini.pfs.integration;

import com.fasterxml.jackson.annotation.JsonTypeInfo;

@JsonTypeInfo(use=JsonTypeInfo.Id.NAME, 
include=JsonTypeInfo.As.PROPERTY, property="@type")
public class PojoStr {

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}

	public String valor;
	
	public PojoStr(String valor) {
		this.valor = valor;
	}
	
	public PojoStr() {
	}
	
}
