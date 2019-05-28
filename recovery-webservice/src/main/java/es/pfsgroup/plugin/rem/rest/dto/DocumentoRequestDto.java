package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class DocumentoRequestDto extends RequestDto{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	private List<DocumentoDto> data;

	public List<DocumentoDto> getData() {
		return data;
	}

	public void setData(List<DocumentoDto> data) {
		this.data = data;
	}
	
	
	
}