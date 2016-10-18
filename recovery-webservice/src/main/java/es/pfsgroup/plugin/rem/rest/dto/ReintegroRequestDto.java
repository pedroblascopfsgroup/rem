package es.pfsgroup.plugin.rem.rest.dto;

public class ReintegroRequestDto extends RequestDto {

	private static final long serialVersionUID = 1L;
	
	private ReintegroDto data;

	public ReintegroDto getData() {
		return data;
	}
	public void setData(ReintegroDto data) {
		this.data = data;
	}


	
}
