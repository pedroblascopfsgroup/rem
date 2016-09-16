package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class ComisionRequestDto extends RequestDto{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private List<ComisionDto> data;

	
	public List<ComisionDto> getData() {
		return data;
	}

	public void setData(List<ComisionDto> data) {
		this.data = data;
	}
	
	
}
