package es.pfsgroup.plugin.rem.rest.dto;

import java.util.Map;

public class TareaRequestDto extends RequestDto{

	
	/**
	 * 
	 */
	private static final Long serialVersionUID = 1L;
	
	private String idTarea;
	private String id;
	private Map<String, String[]> data;

	
	public String getIdTarea() {
		return idTarea;
	}

	public void setIdTarea(String idTarea) {
		this.idTarea = idTarea;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Map<String, String[]> getData() {
		return data;
	}

	public void setData(Map<String, String[]> data) {
		this.data = data;
	}
	
}
