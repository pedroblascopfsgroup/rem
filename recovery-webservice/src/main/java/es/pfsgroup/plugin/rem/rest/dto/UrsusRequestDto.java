package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class UrsusRequestDto extends RequestDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private List<UrsusDto> data;

	public List<UrsusDto> getData() {
		return data;
	}

	public void setData(List<UrsusDto> data) {
		this.data = data;
	}

}
