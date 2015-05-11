package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.dto.WebDto;

public class PCDtoQuery extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -8409945576844560487L;

	private String query;

	public void setQuery(String query) {
		this.query = query;
	}

	public String getQuery() {
		return query;
	}
}
