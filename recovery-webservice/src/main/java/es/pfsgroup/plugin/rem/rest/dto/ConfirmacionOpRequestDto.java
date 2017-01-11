package es.pfsgroup.plugin.rem.rest.dto;

public class ConfirmacionOpRequestDto extends RequestDto {

	private static final long serialVersionUID = 1L;
	
	private ConfirmacionOpDto data;

	public ConfirmacionOpDto getData() {
		return data;
	}
	public void setData(ConfirmacionOpDto data) {
		this.data = data;
	}


	
}
