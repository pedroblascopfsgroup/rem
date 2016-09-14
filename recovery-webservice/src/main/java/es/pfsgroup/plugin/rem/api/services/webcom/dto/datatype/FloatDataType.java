package es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype;

public class FloatDataType extends WebcomDataType<Float>{
	
	private Float value;

	protected FloatDataType(Float f){
		this.value = f;
	}

	@Override
	public Float getValue() {
		return this.value;
	}

}
