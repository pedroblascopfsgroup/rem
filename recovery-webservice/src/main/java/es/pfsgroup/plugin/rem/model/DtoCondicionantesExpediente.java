package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoCondicionantesExpediente extends WebDto {
	
	private static final long serialVersionUID = 1L;

	private Boolean fianzaExonerada;

	public Boolean getFianzaExonerada() {
		return fianzaExonerada;
	}

	public void setFianzaExonerada(Boolean fianzaExonerada) {
		this.fianzaExonerada = fianzaExonerada;
	}
	
}
