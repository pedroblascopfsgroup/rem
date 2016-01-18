package es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dto;

import es.capgemini.devon.dto.WebDto;

public class JUZDtoBusquedaPlaza extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4688129840473404199L;
	
	private String filtroPlaza;
	private String filtroJuzgado;
	

	public void setFiltroPlaza(String filtroPlaza) {
		this.filtroPlaza = filtroPlaza;
	}

	public String getFiltroPlaza() {
		return filtroPlaza;
	}

	public void setFiltroJuzgado(String filtroJuzgado) {
		this.filtroJuzgado = filtroJuzgado;
	}

	public String getFiltroJuzgado() {
		return filtroJuzgado;
	}

}
