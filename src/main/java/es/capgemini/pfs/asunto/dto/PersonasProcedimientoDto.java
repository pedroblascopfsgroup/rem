package es.capgemini.pfs.asunto.dto;

import java.io.Serializable;

import es.capgemini.pfs.contrato.model.ContratoPersona;

/**
 * Clase para poblar la vista de edici�n de procedimientos.
 * Indica si la contratoPersona, que debe estar asociada al contrato del procedimiento, está asignada al procedimiento.
 * @author pamuller
 *
 */
public class PersonasProcedimientoDto implements Serializable{

	private static final long serialVersionUID = 1025185246554183252L;

	private ContratoPersona contratoPersona;

	private Boolean asociada = Boolean.FALSE;
	/**
	 * @return the contratoPersona
	 */
	public ContratoPersona getContratoPersona() {
		return contratoPersona;
	}
	/**
	 * @param contratoPersona the contratoPersona to set
	 */
	public void setContratoPersona(ContratoPersona contratoPersona) {
		this.contratoPersona = contratoPersona;
	}
	/**
	 * @return the asociada
	 */
	public boolean getAsociada() {
		return asociada.booleanValue();
	}
	/**
	 * @param asociada the asociada to set
	 */
	public void setAsociada(Boolean asociada) {
		this.asociada = asociada;
	}

}
