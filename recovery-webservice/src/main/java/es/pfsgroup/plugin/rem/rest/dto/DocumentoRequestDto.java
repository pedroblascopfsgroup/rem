package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class DocumentoRequestDto extends RequestDto{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Long idLlamada;
	
	private List<DocumentoDto> data;

	public Long getIdLlamada() {
		return idLlamada;
	}

	public void setIdLlamada(Long idLlamada) {
		this.idLlamada = idLlamada;
	}

	public List<DocumentoDto> getData() {
		return data;
	}

	public void setData(List<DocumentoDto> data) {
		this.data = data;
	}
	
	
	
}