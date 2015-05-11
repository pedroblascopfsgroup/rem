package es.pfsgroup.plugin.recovery.coreextension.api;

import es.capgemini.devon.dto.WebDto;

public class UsuarioDto extends WebDto {

	private static final long serialVersionUID = 5041223980322029317L;

	private Long idTipoDespacho;
	
	public Long getIdTipoDespacho() {
		return idTipoDespacho;
	}

	public void setIdTipoDespacho(Long idTipoDespacho) {
		this.idTipoDespacho = idTipoDespacho;
	}

	public String getQuery() {
		return query;
	}

	public void setQuery(String query) {
		this.query = query;
	}

	private String query;
}
