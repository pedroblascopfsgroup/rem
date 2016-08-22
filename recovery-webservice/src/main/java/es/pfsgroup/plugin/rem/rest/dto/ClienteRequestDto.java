package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class ClienteRequestDto extends RequestDto{

	private static final long serialVersionUID = -1461203975934437526L;
	
	private List<ClienteDto> data;

	
	public List<ClienteDto> getData() {
		return data;
	}

	public void setData(List<ClienteDto> data) {
		this.data = data;
	}
	
	
}
