package es.pfsgroup.procedimientos.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoQuery extends WebDto {
	private static final long serialVersionUID = 1L;
	private String query;

	public void setQuery(String query) {
		this.query = query;
	}

	public String getQuery() {
		return query;
	}
}
