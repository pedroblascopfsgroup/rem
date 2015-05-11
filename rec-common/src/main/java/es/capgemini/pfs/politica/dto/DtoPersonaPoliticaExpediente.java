package es.capgemini.pfs.politica.dto;

import java.io.Serializable;

import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.politica.model.Politica;

/**
 * DTO para mostrar la información de políticas de las personas en un expediente
 * en el export a PDF.
 * @author marruiz
 */
public class DtoPersonaPoliticaExpediente implements Serializable {

	private static final long serialVersionUID = -8155468525726563338L;

	private Persona persona;
	private String fecha;
	private Politica politica;


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
	 * @return the fecha
	 */
	public String getFecha() {
		return fecha;
	}
	/**
	 * @param fecha the fecha to set
	 */
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	/**
	 * @return the politica
	 */
	public Politica getPolitica() {
		return politica;
	}
	/**
	 * @param politica the politica to set
	 */
	public void setPolitica(Politica politica) {
		this.politica = politica;
	}
}
