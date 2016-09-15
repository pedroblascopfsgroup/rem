package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype;

public class StringDataType extends WebcomDataType<String>{
	
	private String value;

	protected StringDataType(String s){
		this.value = s;
	}

	@Override
	public String getValue() {
		return value;
	}

}
