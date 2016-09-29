package es.pfsgroup.plugin.rem.rest.dto;

public class ReservaRequestDto extends RequestDto {

	private static final long serialVersionUID = 1L;
	
	private ReservaDto data;

	public ReservaDto getData() {
		return data;
	}
	public void setData(ReservaDto data) {
		this.data = data;
	}


	
}
