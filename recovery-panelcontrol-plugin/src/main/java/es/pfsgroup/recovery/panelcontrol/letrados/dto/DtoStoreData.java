package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.pagination.PaginationParamsImpl;

public class DtoStoreData extends PaginationParamsImpl{
	/**
	 * 
	 */
	private static final long serialVersionUID = -2345472348736981181L;

	private String valor;

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}

}
