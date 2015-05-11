package es.capgemini.pfs.asunto.dto;

import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;

public class DtoReportAsuntoDemandados {

	private String tipoIntervencion;
	private Persona persona;

	public String getTipoIntervencion() {
		return tipoIntervencion;
	}

	public void setTipoIntervencion(String tipoIntervencion) {
		this.tipoIntervencion = tipoIntervencion;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

}
