package es.pfsgroup.framework.paradise.bulkUpload.dto;

import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.framework.paradise.bulkUpload.controller.GridFilter;

public class MSVDtoFiltroProcesos extends WebDto{

	private static final long serialVersionUID = -2015980707950011743L;
	
	private String username;
	
	private Boolean esSupervisor;
	
	private List<GridFilter> filtros;

	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public Boolean getEsSupervisor() {
		return esSupervisor;
	}
	public void setEsSupervisor(Boolean esSupervisor) {
		this.esSupervisor = esSupervisor;
	}
	public List<GridFilter> getFiltros() {
		return filtros;
	}
	public void setFiltros(List<GridFilter> filtros) {
		this.filtros = filtros;
	}

}
