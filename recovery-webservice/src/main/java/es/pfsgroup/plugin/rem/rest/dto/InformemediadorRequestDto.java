package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class InformemediadorRequestDto extends RequestDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private List<InformeMediadorDto> data;

	public List<InformeMediadorDto> getData() {
		return data;
	}

	public void setData(List<InformeMediadorDto> data) {
		this.data = data;
	}

}
