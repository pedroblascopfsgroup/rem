package es.pfsgroup.plugin.rem.rest.dto;

import java.util.Map;

public class TareaRequestDto extends RequestDto{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String id;
	private Long idLlamada;
	private Map<String, String[]> data;

	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Long getIdLlamada() {
		return idLlamada;
	}

	public void setIdLlamada(Long idLlamada) {
		this.idLlamada = idLlamada;
	}

	public Map<String, String[]> getData() {
		return data;
	}

	public void setData(Map<String, String[]> data) {
		this.data = data;
	}
	
}
