package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class TrabajoRequestDto extends RequestDto{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private List<TrabajoDto> data;

	
	public List<TrabajoDto> getData() {
		return data;
	}

	public void setData(List<TrabajoDto> data) {
		this.data = data;
	}
	
	
}
