package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class VisitaRequestDto extends RequestDto{

	private static final long serialVersionUID = -1461203975934437526L;
	
	private List<VisitaDto> data;

	public List<VisitaDto> getData() {
		return data;
	}

	public void setData(List<VisitaDto> data) {
		this.data = data;
	}
	
	
	
}
