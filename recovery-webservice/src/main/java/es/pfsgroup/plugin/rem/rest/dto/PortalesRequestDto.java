package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class PortalesRequestDto {

	private Long id;
	private List<PortalesDto> data; 
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public List<PortalesDto> getData() {
		return data;
	}
	public void setData(List<PortalesDto> data) {
		this.data = data;
	}

	
}
