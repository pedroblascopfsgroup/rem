package es.capgemini.pfs.persona.dto;

import es.capgemini.pfs.persona.model.Persona;

/**
 * DTO para mapear una lista de personas con el check 'asiste' que indica si fue incluído
 * en el procedimiento y el contrato por el cual ha sido agregado
 * @author marruiz
 */
public class DtoProcedimientoPersona {

	private Persona persona;
	private Boolean asiste;
	private Long cntId;


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
	
	/**
	 * @return the cntId
	 */
	public Long getCntId() {
		return cntId;
	}
	
	/**
	 * @param cntId the cntId to set
	 */
	public void setCntId(Long cntId) {
		this.cntId = cntId;
	}
}
