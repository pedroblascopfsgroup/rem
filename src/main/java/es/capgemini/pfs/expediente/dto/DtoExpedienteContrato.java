package es.capgemini.pfs.expediente.dto;

import es.capgemini.pfs.expediente.model.ExpedienteContrato;

/**
 * @author marruiz
 */
public class DtoExpedienteContrato {

	private ExpedienteContrato expedienteContrato;
	private Boolean seleccionado;


	/**
	 * @return the expedienteContrato
	 */
	public ExpedienteContrato getExpedienteContrato() {
		return expedienteContrato;
	}

	/**
	 * @param expedienteContrato the expedienteContrato to set
	 */
	public void setExpedienteContrato(ExpedienteContrato expedienteContrato) {
		this.expedienteContrato = expedienteContrato;
	}

	/**
	 * @return the seleccionado
	 */
	public Boolean getSeleccionado() {
		return seleccionado;
	}

	/**
	 * @param seleccionado the seleccionado to set
	 */
	public void setSeleccionado(Boolean seleccionado) {
		this.seleccionado = seleccionado;
	}
}
