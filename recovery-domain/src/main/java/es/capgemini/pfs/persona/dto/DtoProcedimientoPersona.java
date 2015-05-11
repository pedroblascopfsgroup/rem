package es.capgemini.pfs.persona.dto;

import es.capgemini.pfs.persona.model.Persona;

/**
 * DTO para mapear una lista de personas con el check 'asiste' que indica si fue incluído
 * en el procedimiento.
 * @author marruiz
 */
public class DtoProcedimientoPersona {

	private Persona persona;
	private Boolean asiste;


	/**
	 * @return the persona
	 */
	public Persona getPersona() {
		return persona;
	}
	/**
	 * @param persona the persona to set
	 */
	public void setPersona(Persona persona) {
		this.persona = persona;
	}
	/**
	 * @return the asiste
	 */
	public Boolean getAsiste() {
		return asiste;
	}
	/**
	 * @param asiste the asiste to set
	 */
	public void setAsiste(Boolean asiste) {
		this.asiste = asiste;
	}
}
