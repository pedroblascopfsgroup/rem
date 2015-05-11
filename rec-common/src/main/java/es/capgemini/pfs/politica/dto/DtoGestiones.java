package es.capgemini.pfs.politica.dto;

import es.capgemini.pfs.politica.model.DDTipoGestion;

/**
 * Dto para enviar a la pantalla los tipos de gestión indicando si están o no seleccionados.
 * @author pamuller
 *
 */
public class DtoGestiones {

	private DDTipoGestion tipoGestion;

	private Boolean seleccionado = Boolean.FALSE;

	/**
	 * @return the tipoGestion
	 */
	public DDTipoGestion getTipoGestion() {
		return tipoGestion;
	}

	/**
	 * @param tipoGestion the tipoGestion to set
	 */
	public void setTipoGestion(DDTipoGestion tipoGestion) {
		this.tipoGestion = tipoGestion;
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
