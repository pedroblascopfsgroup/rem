package es.pfsgroup.plugin.rem.rest.dto;

public class PropuestaRequestDto extends RequestDto {

	private static final long serialVersionUID = 1L;
	
	private PropuestaDto data;

	public PropuestaDto getData() {
		return data;
	}

	public void setData(PropuestaDto data) {
		this.data = data;
	}

}
