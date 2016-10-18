package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class PortalesRequestDto extends RequestDto {

	private static final long serialVersionUID = 2451364543888351039L;
	
	private List<PortalesDto> data;

	
	public List<PortalesDto> getData() {
		return data;
	}

	public void setData(List<PortalesDto> data) {
		this.data = data;
	}

}
