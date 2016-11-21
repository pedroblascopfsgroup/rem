package es.pfsgroup.plugin.rem.rest.dto;

public class PropuestaRequestDto extends RequestDto {

	private static final long serialVersionUID = 1L;
	
	private OfertaSimpleDto data;

	public OfertaSimpleDto getData() {
		return data;
	}

	public void setData(OfertaSimpleDto data) {
		this.data = data;
	}

}
