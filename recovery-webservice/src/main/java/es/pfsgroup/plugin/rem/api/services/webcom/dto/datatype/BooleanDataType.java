package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype;

public class BooleanDataType extends WebcomDataType<Boolean>{
	
	public static BooleanDataType TRUE = new BooleanDataType(true);
	public static BooleanDataType FALSE = new BooleanDataType(false);
	
	private Boolean value;

	protected BooleanDataType(Boolean b){
		this.value = b;
	}

	@Override
	public Boolean getValue() {
		return value;
	}

}
