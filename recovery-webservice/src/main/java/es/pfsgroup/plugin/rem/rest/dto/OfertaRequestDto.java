package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class OfertaRequestDto extends RequestDto{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	private List<OfertaDto> data;

	public List<OfertaDto> getData() {
		return data;
	}

	public void setData(List<OfertaDto> data) {
		this.data = data;
	}
	
	
	
}
