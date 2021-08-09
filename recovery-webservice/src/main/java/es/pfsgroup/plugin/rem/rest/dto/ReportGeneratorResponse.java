package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

import org.codehaus.jackson.annotate.JsonProperty;

public class ReportGeneratorResponse implements Serializable{
	
	
	@JsonProperty("nombre")
    String nombre;

	@JsonProperty("response")
    byte[] response;

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public byte[] getResponse() {
		return response;
	}

	public void setResponse(byte[] response) {
		this.response = response;
	}

    
}
