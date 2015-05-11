package es.pfsgroup.plugin.recovery.masivo.model.notificacion;

import java.io.Serializable;

import es.capgemini.pfs.persona.model.Persona;

public class MSVInfoDemandado implements Serializable{
	
	private static final long serialVersionUID = -2274596644052216457L;

	private Persona persona;

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

}
