package es.capgemini.pfs.politica.dto;

import java.io.Serializable;

import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.politica.model.Politica;

/**
 * DTO con la persona y su última política.
 * @author marruiz
 */
public class DtoPersonaPoliticaUlt implements Serializable {

	private static final long serialVersionUID = 4406294346853987308L;

	private Persona persona;
	private Politica politicaUltima;


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
	 * @return the politicaUltima
	 */
	public Politica getPoliticaUltima() {
		return politicaUltima;
	}
	/**
	 * @param politicaUltima the politicaUltima to set
	 */
	public void setPoliticaUltima(Politica politicaUltima) {
		this.politicaUltima = politicaUltima;
	}
}
