package es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto;

import es.capgemini.devon.dto.WebDto;

public class PTEDtoQuery  extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4022141306875953304L;

	private String query;
	private String codigo;

	public void setQuery(String query) {
		this.query = query;
	}

	public String getQuery() {
		return query;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getCodigo() {
		return codigo;
	}
}
