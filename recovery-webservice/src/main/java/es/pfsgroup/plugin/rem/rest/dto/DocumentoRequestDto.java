package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class DocumentoRequestDto extends RequestDto{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String id;
	
	private String idTarea;
	
	private DocumentoDto data;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(String idTarea) {
		this.idTarea = idTarea;
	}

	public DocumentoDto getData() {
		return data;
	}

	public void setData(DocumentoDto data) {
		this.data = data;
	}
	
	
	
}