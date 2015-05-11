package es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto;

import es.capgemini.pfs.adjunto.model.Adjunto;

public class DtoAdjuntoMail {

	private Adjunto adjunto;
	private String nombre;

	public Adjunto getAdjunto() {
		return adjunto;
	}

	public void setAdjunto(Adjunto adjunto) {
		this.adjunto = adjunto;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

}
