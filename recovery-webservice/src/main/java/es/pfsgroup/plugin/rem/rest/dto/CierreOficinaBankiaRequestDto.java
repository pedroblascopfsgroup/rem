package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class CierreOficinaBankiaRequestDto extends RequestDto{

	
private static final long serialVersionUID = 1L;
	
	
	private List<CierreOficinaBankiaDto> data;

	public List<CierreOficinaBankiaDto> getData() {
		return data;
	}

	public void setData(List<CierreOficinaBankiaDto> data) {
		this.data = data;
	}
}
